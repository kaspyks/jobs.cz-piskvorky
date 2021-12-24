#!/bin/bash

### usage:
#./play.sh {GameToken} {GameID}
#

### Array size: 58x40

declare -r domain="https://piskvorky.jobs.cz"
declare -r tmpFolder="/tmp"
declare -r maxX=28
declare -r minX=-28
declare -r maxY=20
declare -r minY=-19

declare -a field # x|y|pID|done
gToken="" # Game Token
gID="" # GameID
lHX="" # last hit coordinate X
lHY="" # last hit coordinate Y
nHX="" # next hit coordinate X
nHY="" # next hit coordinate Y
oppID="" # ID of opponent
startTime=""

shopt -s expand_aliases
alias curl="curl -s -X POST -H \"accept: application/json\" -H \"Content-Type: application/json\""

source "$( dirname "$( realpath "${0}" )" )/localConfig.sh"
source "$( dirname "$( realpath "${0}" )" )/thinking.sh"

function debug {
	if [[ "${testEnv}" -eq 1 ]]
	then
		echo "${1}"
	fi
	log "${1}"
	return 0
}

function log {
	echo "[$( date "+%Y/%m/%d %H:%M:%S" )] - ${1}" >> "${tmpFolder}/${gID}.log"
}

function print {
	echo "${1}"
	#log "${1}"
}

### INIT # END #####################################################

function actualState {
	opponentsTurnCount=0

	while true
	do
		res=$( curl "${domain}/api/v1/checkStatus" -d "{ \"userToken\": \"${uToken}\", \"gameToken\": \"${gToken}\"}" )
		#log "$( echo "${res}" | jq --compact-output '.' )"
		sCode=$( echo "${res}" | jq '.statusCode' )
		sleep 1.2

		if echo "${sCode}" | grep -iq "^20.$"
		then
			aP=$( echo "${res}" | jq '.actualPlayerId' | tr -d '"' ) # Actual Player
			if [[ "${aP}" != "${uID}" ]]
			then
				print "Actual State - Opponent's turn"
				aDate=$( date "+%s" )
				opponentsTurnCount=$(( opponentsTurnCount + 1 ))
				if [[ ${opponentsTurnCount} -gt 60 && ${aDate} -gt $(( startTime + 600 )) ]]
				then
					print "Actual State - Error timeout reached. Exiting"
					exit 2
				fi
				sleep 5
				continue
			fi
			#regenerateDB "${res}"
			break
		fi
		
		if [[ "${sCode}" == "226" ]]
		then
			checkCompletedGame "${res}"
		fi
		
		if echo -n "${sCode}" | grep -iq "^4"
		then
			if [[ "${sCode}" == "429" ]]
			then
				print "Actual State - Too many connections - Error ${sCode}"
				sleep 2
				continue
			else
				print "Actual State - Error ${sCode}"
				print "${res}"
				exit 1
			fi
		fi
	done
}

function checkCompletedGame {
	res="${1}"
	print "The game has been completed"
	winner=$( echo "${res}" | jq '.winnerId' | tr -d '"' )
	if [[ "${winner}" == "${uID}" ]]
	then
		print "You win! Congrats!"
		rm "${tmpFolder}/${gID}.db"
		rm "${tmpFolder}/${gID}.log"
	else
		print "You are looser"
	fi
	print "End of game. Exiting"
	sqlite3 "$( dirname "$( realpath "${0}" )" )/centralDB.db" "UPDATE games SET status = 'ended' WHERE gID = '${gID}' AND gToken = '${gToken}';"
	exit 0
}

function getLastHit {
	opponentsTurnCount=0
	
	while true
	do
		lHX=""
		lHY=""
		res=$( curl "${domain}/api/v1/checkLastStatus" -d "{ \"userToken\": \"${uToken}\", \"gameToken\": \"${gToken}\"}" )
		#log "$( echo "${res}" | jq --compact-output '.' )"
		sCode=$( echo "${res}" | jq '.statusCode' )
		# sleep 1.2
		
		if echo "${sCode}" | grep -iq "^20.$"
		then
			aP=$( echo "${res}" | jq '.actualPlayerId' | tr -d '"' ) # Actual Player
			if [[ "${aP}" != "${uID}" ]]
			then
				print "Get Last Hit - Opponent's turn"
				aDate=$( date "+%s" )
				opponentsTurnCount=$(( opponentsTurnCount + 1 ))
				if [[ ${opponentsTurnCount} -gt 60 && ${aDate} -gt $(( startTime + 600 )) ]]
				then
					print "Get Last Hit - Error timeout reached. Exiting"
					exit 2
				fi
				sleep 5
				continue
			else
				lHX=$( echo "${res}" | jq ".coordinates[0].x" )
				lHY=$( echo "${res}" | jq ".coordinates[0].y" )
				if [[ "${lHX}" != "null" && "${lHY}" != "null" ]]
				then
					field[$((lHX+100))0$((lHY+100))]="${lHX}|${lHY}|${oppID}|0"
					#sqlite3 "${tmpFolder}/${gID}.db" "INSERT INTO game ( x, y, p ) VALUES ( '${lHX}', '${lHY}', '${oppID}' )"
					print "@@@ Opponent hit on X: ${lHX}, Y: ${lHY}"
				fi
				break
			fi
		fi

		if [[ "${sCode}" == "226" ]]
		then
			checkCompletedGame "${res}"
		fi
		
		if echo -n "${sCode}" | grep -iq "^4"
		then
			if [[ "${sCode}" == "429" ]]
			then
				print "Get Last Hit - Too many connections - Error ${sCode}"
				sleep 2
				continue
			else
				print "Get Last Hit - Error ${sCode}"
				print "${res}"
				exit 1
			fi
		fi
	done
}

function initGame {
	if [[ -n "${1}" && -n "${2}" ]]
	then
		gToken="${1}"
		gID="${2}"
		regenerateDB
		return 0
	fi
	res=$( curl "${domain}/api/v1/connect" -d "{ \"userToken\": \"${uToken}\"}" )
	#log "$( echo "${res}" | jq --compact-output '.' )" ## neni jeste zjisteni gID
	sCode=$( echo "${res}" | jq '.statusCode' )
	sleep 1
	
	if echo "${sCode}" | grep -iq "^20.$"
	then
		if [[ ! -f "$( dirname "$( realpath "${0}" )" )/centralDB.db" ]]
		then
			sqlite3 "$( dirname "$( realpath "${0}" )" )/centralDB.db" "CREATE TABLE games ( gID VARCHAR ( 50 ), gToken VARCHAR ( 50 ), status VARCHAR ( 50 ), tries INTEGER,  UNIQUE ( gID , gToken ) );"
		fi
		gToken=$( echo "${res}" | jq '.gameToken' | tr -d '"' )
		gID=$( echo "${res}" | jq '.gameId' | tr -d '"' )
		startTime=$( date "+%s" )
		
		sqlite3 "$( dirname "$( realpath "${0}" )" )/centralDB.db" "INSERT INTO games ( gID, gToken, status ) VALUES ( '${gID}', '${gToken}', 'playing' );"
		#sqlite3 "${tmpFolder}/${gID}.db" "CREATE TABLE game ( x INTEGER, y INTEGER, p VARCHAR ( 50 ), done INTEGER, UNIQUE ( x , y ) )"
		sqlite3 "${tmpFolder}/${gID}.db" "CREATE TABLE nextHits ( x INTEGER, y INTEGER, p INTEGER, t VARCHAR ( 20 ), UNIQUE ( x, y, t ) )" # coordinate X, coordinate Y, Priority, Type [ hor, ver, oblbot, obltop ]
		sqlite3 "${tmpFolder}/${gID}.db" "CREATE TABLE theBest ( x INTEGER, y INTEGER, p INTEGER, UNIQUE ( x, y ) )" # coordinate X, coordinate Y, Priority
		sqlite3 "${tmpFolder}/${gID}.db" "CREATE VIEW nextHitsView AS SELECT x, y, SUM(p) AS s FROM nextHits GROUP BY x, y;"
		sqlite3 "${tmpFolder}/${gID}.db" ".timeout 10000"
		print "Init Game - Successful"
		print "Init Game - Game Token: ${gToken}"
		print "Init Game - Game ID: ${gID}"
		print "./play.sh ${gToken} ${gID}"
		return 0
	fi
		
	if echo -n "${sCode}" | grep -iq "^4"
	then
		echo "Init Game - Error ${sCode}"
		echo "${res}"
		exit 1
	fi
}

function regenerateDB {
	unset field
	declare -a field
	#sqlite3 "${tmpFolder}/${gID}.db" "DELETE FROM game;"
	
	res=""
	sCode=""
	if [[ -z "${1}" ]]
	then
		while true
		do
			res=$( curl "${domain}/api/v1/checkStatus" -d "{ \"userToken\": \"${uToken}\", \"gameToken\": \"${gToken}\"}" )
			#log "$( echo "${res}" | jq --compact-output '.' )"
			sCode=$( echo "${res}" | jq '.statusCode' )
			sleep 1.2
			
			if echo "${sCode}" | grep -iq "^2..$"
			then
				break
			else
				if echo -n "${sCode}" | grep -iq "^4"
				then
					if [[ "${sCode}" == "429" ]]
					then
						print "Regenerate DB - Too many connections - Error ${sCode}"
						sleep 2
						continue
					else
						print "Regenerate DB - Error ${sCode}"
						print "${res}"
						exit 1
					fi
				fi
			fi
		done
	else
		res="${1}"
	fi
	cCount=$( echo "${res}" | jq '.coordinates' | jq length )
	debug "Regenerating DB..."
	for (( i=0; i<cCount; i++ ))
	do
		x=$( echo "${res}" | jq ".coordinates[${i}].x" )
		y=$( echo "${res}" | jq ".coordinates[${i}].y" )
		p=$( echo "${res}" | jq ".coordinates[${i}].playerId" | tr -d '"' )
		field[$((x+100))0$((y+100))]="${x}|${y}|${p}|0"
		#sqlite3 "${tmpFolder}/${gID}.db" "INSERT INTO game ( x, y, p ) VALUES ( '${x}', '${y}', '${p}' )"
	done
	debug "Regenerating successful"
}

function sendHit {
	while true
	do
		res=$( curl "${domain}/api/v1/play" -d "{ \"userToken\": \"${uToken}\", \"gameToken\": \"${gToken}\", \"positionX\": ${nHX}, \"positionY\": ${nHY}}" )
		#log "$( echo "${res}" | jq --compact-output '.' )"
		sCode=$( echo "${res}" | jq '.statusCode' )
		sleep 1.2
		
		if echo "${sCode}" | grep -iq "^20.$"
		then
			field[$((nHX+100))0$((nHY+100))]="${nHX}|${nHY}|${uID}|0"
			#sqlite3 "${tmpFolder}/${gID}.db" "INSERT INTO game ( x, y, p ) VALUES ( '${nHX}', '${nHY}', '${uID}' )"
			print "@@@ My hit on X: ${nHX}, Y: ${nHY}"
			break
		fi
		if [[ "${sCode}" == "226" ]]
		then
			checkCompletedGame "${res}"
		fi
		if echo -n "${sCode}" | grep -iq "^4"
		then
			if [[ "${sCode}" == "406" ]]
			then
				print "Send Hit - Error ${sCode}"
				break
			elif [[ "${sCode}" == "409" ]]
			then
				print "Send Hit - Error ${sCode}"
				regenerateDB
				break
			elif [[ "${sCode}" == "410" ]]
			then
				print "Send Hit - Error ${sCode}"
				break
			elif [[ "${sCode}" == "429" ]]
			then
				print "Send Hit - Too many connections - Error ${sCode}"
				sleep 2
				continue
			else
				print "Send Hit - Error ${sCode}"
				print "${res}"
				exit 1
			fi
		fi
	done
}

function waitingForGame {
	while true
	do
		res=$( curl "${domain}/api/v1/checkStatus" -d "{ \"userToken\": \"${uToken}\", \"gameToken\": \"${gToken}\"}" )
		#log "$( echo "${res}" | jq --compact-output '.' )"
		sCode=$( echo "${res}" | jq '.statusCode' )
		sleep 1.2
		
		p0=""
		p1=""
		p0=$( echo "${res}" | jq '.playerCircleId' | tr -d '"' ) # Player circle
		p1=$( echo "${res}" | jq '.playerCrossId' | tr -d '"' ) # Player cross
		
		if echo "${sCode}" | grep -iq "^20.$"
		then
			if [[ "${p0}" == "null" || "${p1}" == "null" ]]
			then
				print "Waiting For Game - Opponent isn't connected yet, waiting..."
				sleep 10
				continue
			fi
		fi
		
		if echo -n "${sCode}" | grep -iq "^4"
		then
			if [[ "${sCode}" == "429" ]]
			then
				print "Waiting For Game - Too many connections - Error ${sCode}"
				sleep 2
				continue
			else			
				print "Waiting For Game - Error ${sCode}"
				print "${res}"
				exit 1
			fi
		fi
		
		if [[ "${p0}" != "${uID}" ]]
		then
			oppID="${p0}"
		else
			oppID="${p1}"
		fi
		break
	done
}

initGame "${1}" "${2}"
waitingForGame
#Let's Play!
print "Ready to play"
while true
do
	#actualState
	getLastHit
	thinking
	sendHit
done
