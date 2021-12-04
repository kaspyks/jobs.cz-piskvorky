#!/bin/bash

function checkSquare {
	x="${1}"
	y="${2}"
	pID="${3}"
	debug "########## Check: ${x}, ${y}, ${pID}"
	if [[ "${pID}" == "${uID}" ]]
	then
		p2="2"
		p3="5" # priority by 3 in row
		p4="625" # priority by 4 in row
	else
		p2="1"
		p3="25" # priority by 3 in row
		p4="125" # priority by 4 in row
	fi
	p32=$(( p3 + p3 )) # priority by 3 in row When empty fields around
	
	##########################################################
	if [[ -z $( getData $(( x - 1 )) "${y}" ) && $( getData $(( x - 2 )) "${y}" ) == "${pID}" ]]
	then
		debug "1.0"
		insertData $(( x - 1 )) "${y}" "${p2}"
	fi
	if [[ $( getData $(( x - 1 )) "${y}" ) == "${pID}" ]] # if 2 in row
	then
		debug "1.1"
		t="hor" # hor, ver, oblbot, obltop
		insertData $(( x + 1 )) "${y}" "${p2}"
		insertData $(( x - 2 )) "${y}" "${p2}"
		if [[ -z $( getData $(( x + 1 )) "${y}" ) && $( getData $(( x + 2 )) "${y}" ) == "${pID}" ]]
		then
			if [[ $( getData $(( x + 3 )) "${y}" ) == "${pID}" ]]
			then
				debug "1.1.2.1"
				insertData $(( x + 1 )) "${y}" "${p4}"
			else
				debug "1.1.2.2"
				insertData $(( x - 2 )) "${y}" $(( p3 - 1 ))
				insertData $(( x + 3 )) "${y}" $(( p3 - 1 ))
				if [[ -z $( getData $(( x - 2 )) "${y}" ) && -z $( getData $(( x + 3 )) "${y}" ) ]]
				then
					debug "1.1.3.1"
					insertData $(( x + 1 )) "${y}" "${p32}"
				else
					debug "1.1.3.2"
					insertData $(( x + 1 )) "${y}" "${p3}"
				fi					
			fi
		fi
		if [[ -z $( getData $(( x - 2 )) "${y}" ) && $( getData $(( x - 3 )) "${y}" ) == "${pID}" ]]
		then
			insertData $(( x - 4 )) "${y}" $(( p3 - 1 ))
			insertData $(( x + 1 )) "${y}" $(( p3 - 1 ))
			if [[ -z $( getData $(( x - 4 )) "${y}" ) && -z $( getData $(( x + 1 )) "${y}" ) ]]
			then
				debug "1.1.4.1"
				insertData $(( x - 2 )) "${y}" "${p32}"
			else
				debug "1.1.4.2"
				insertData $(( x - 2 )) "${y}" "${p3}"
			fi
		fi
		
		if [[ $( getData $(( x + 1 )) "${y}" ) == "${pID}" ]] # if 3 in row
		then
			debug "1.2"
			p3s=""
			if [[ -z $( getData $(( x + 2 )) "${y}" ) && -z $( getData $(( x - 2 )) "${y}" ) ]]
			then
				p3s="${p32}"
			else
				p3s="${p3}"
				if [[ -z $( getData $(( x + 2 )) "${y}" ) ]]
				then
					insertData $(( x + 3 )) "${y}" $(( p3 - 1 ))
				fi
				if [[ -z $( getData $(( x - 2 )) "${y}" ) ]]
				then
					insertData $(( x - 3 )) "${y}" $(( p3 - 1 ))
				fi
			fi
			
			if [[ -z $( getData $(( x + 2 )) "${y}" ) && $( getData $(( x + 3 )) "${y}" ) == "${pID}" ]]
			then
				debug "1.2.1"
				insertData $(( x + 2 )) "${y}" "${p4}"
			else
				debug "1.2.2"
				insertData $(( x + 2 )) "${y}" "${p3s}"
			fi
			if [[ -z $( getData $(( x - 2 )) "${y}" ) && $( getData $(( x - 3 )) "${y}" ) == "${pID}" ]]
			then
				debug "1.2.3"
				insertData $(( x - 2 )) "${y}" "${p4}"
			else
				debug "1.2.4"
				insertData $(( x - 2 )) "${y}" "${p3s}"
			fi
			if [[ $( getData $(( x + 2 )) "${y}" ) == "${pID}" ]]
			then
				debug "1.2.5"
				insertData $(( x + 3 )) "${y}" "${p4}"
				insertData $(( x - 2 )) "${y}" "${p4}"
			fi
			if [[ $( getData $(( x - 2 )) "${y}" ) == "${pID}" ]]
			then
				debug "1.2.6"
				insertData $(( x - 3 )) "${y}" "${p4}"
				insertData $(( x + 2 )) "${y}" "${p4}"
			fi
		fi
	fi
	##########################################################
	if [[ -z $( getData "${x}" $(( y - 1 )) ) && $( getData "${x}" $(( y - 2 )) ) == "${pID}" ]]
	then
		debug "2.0"
		insertData "${x}" $(( y - 1 )) "${p2}"
	fi
	if [[ $( getData "${x}" $(( y - 1 )) ) == "${pID}" ]] # if 2 in row
	then
		debug "2.1"
		t="ver" # hor, ver, oblbot, obltop
		insertData "${x}" $(( y + 1 )) "${p2}"
		insertData "${x}" $(( y - 2 )) "${p2}"
		if [[ -z $( getData "${x}" $(( y + 1 )) ) && $( getData "${x}" $(( y + 2 )) ) == "${pID}" ]]
		then			
			if [[ $( getData "${x}" $(( y + 3 )) ) == "${pID}" ]]
			then
				insertData "${x}" $(( y + 1 )) "${p4}"
			else
				insertData "${x}" $(( y - 2 )) $(( p3 - 1 ))
				insertData "${x}" $(( y + 3 )) $(( p3 - 1 ))
				if [[ -z $( getData "${x}" $(( y - 2 )) ) && -z $( getData "${x}" $(( y + 3 )) ) ]]
				then
					debug "2.1.3.1"
					insertData "${x}" $(( y + 1 )) "${p32}"
				else
					debug "2.1.3.2"
					insertData "${x}" $(( y + 1 )) "${p3}"
				fi
			fi
		fi
		if [[ -z $( getData "${x}" $(( y - 2 )) ) && $( getData "${x}" $(( y - 3 )) ) == "${pID}" ]]
		then
			insertData "${x}" $(( y - 4 )) $(( p3 - 1 ))
			insertData "${x}" $(( y + 1 )) $(( p3 - 1 ))
			if [[ -z $( getData "${x}" $(( y - 4 )) ) && -z $( getData "${x}" $(( y + 1 )) ) ]]
			then
				debug "2.1.4.1"
				insertData "${x}" $(( y - 2 )) "${p32}"
			else
				debug "2.1.4.2"
				insertData "${x}" $(( y - 2 )) "${p3}"
			fi
		fi
	
		if [[ $( getData "${x}" $(( y + 1 )) ) == "${pID}" ]] # if 3 in row
		then
			debug "2.2"
			p3s=""
			if [[ -z $( getData "${x}" $(( y + 2 )) ) && -z $( getData "${x}" $(( y - 2 )) ) ]]
			then
				p3s="${p32}"
			else
				p3s="${p3}"
				if [[ -z $( getData "${x}" $(( y + 2 )) ) ]]
				then
					insertData "${x}" $(( y + 3 )) $(( p3 - 1 ))
				fi
				if [[ -z $( getData "${x}" $(( y - 2 )) ) ]]
				then
					insertData "${x}" $(( y - 3 )) $(( p3 - 1 ))
				fi
			fi
			
			if [[ -z $( getData "${x}" $(( y + 2 )) ) && $( getData "${x}" $(( y + 3 )) ) == "${pID}" ]]
			then
				insertData "${x}" $(( y + 2 )) "${p4}"
			else
				insertData "${x}" $(( y + 2 )) "${p3s}"
			fi
			if [[ -z $( getData "${x}" $(( y - 2 )) ) && $( getData "${x}" $(( y - 3 )) ) == "${pID}" ]]
			then
				insertData "${x}" $(( y - 2 )) "${p4}"
			else
				insertData "${x}" $(( y - 2 )) "${p3s}"
			fi
			if [[ $( getData "${x}" $(( y + 2 )) ) == "${pID}" ]]
			then
				insertData "${x}" $(( y + 3 )) "${p4}"
				insertData "${x}" $(( y - 2 )) "${p4}"
			fi
			if [[ $( getData "${x}" $(( y - 2 )) ) == "${pID}" ]]
			then
				insertData "${x}" $(( y - 3 )) "${p4}"
				insertData "${x}" $(( y + 2 )) "${p4}"
			fi
		fi
	fi
	##########################################################
	if [[ -z $( getData  $(( x - 1 )) $(( y + 1 )) ) && $( getData  $(( x - 2 )) $(( y + 2 )) ) == "${pID}" ]]
	then
		debug "3.0"
		insertData $(( x - 1 )) $(( y + 1 )) "${p2}"
	fi
	if [[ $( getData $(( x - 1 )) $(( y + 1 )) ) == "${pID}" ]] # if 2 in row
	then
		debug "3.1"
		t="obltop" # hor, ver, oblbot, obltop
		insertData $(( x + 1 )) $(( y - 1 )) "${p2}"
		insertData $(( x - 2 )) $(( y + 2 )) "${p2}"
		if [[ -z $( getData $(( x + 1 )) $(( y - 1 )) ) && $( getData $(( x + 2 )) $(( y - 2 )) ) == "${pID}" ]]
		then			
			if [[ $( getData $(( x + 3 )) $(( y - 3 )) ) == "${pID}" ]]
			then
				insertData $(( x + 1 )) $(( y - 1 )) "${p4}"
			else
				insertData $(( x - 2 )) $(( y + 2 )) $(( p3 - 1 ))
				insertData $(( x + 3 )) $(( y - 3 )) $(( p3 - 1 ))
				if [[ -z $( getData $(( x - 2 )) $(( y + 2 )) ) && -z $( getData $(( x + 3 )) $(( y - 3 )) ) ]]
				then
					debug "3.1.3.1"
					insertData $(( x + 1 )) $(( y - 1 )) "${p32}"
				else
					debug "3.1.3.2"
					insertData $(( x + 1 )) $(( y - 1 )) "${p3}"
				fi
			fi
		fi
		if [[ -z $( getData $(( x - 2 )) $(( y + 2 )) ) && $( getData $(( x - 3 )) $(( y + 3 )) ) == "${pID}" ]]
		then
			insertData $(( x - 4 )) $(( y + 4 )) $(( p3 - 1 ))
			insertData $(( x + 1 )) $(( y - 1 )) $(( p3 - 1 ))
			if [[ -z $( getData $(( x - 4 )) $(( y + 4 )) ) && -z $( getData $(( x + 1 )) $(( y -1 )) ) ]]
			then
				debug "3.1.4.1"
				insertData $(( x - 2 )) $(( y + 2 )) "${p32}"
			else
				debug "3.1.4.2"
				insertData $(( x - 2 )) $(( y + 2 )) "${p3}"
			fi
		fi
	
		if [[ $( getData $(( x + 1 )) $(( y - 1 )) ) == "${pID}" ]] # if 3 in row
		then
			debug "3.2"
			p3s=""
			if [[ -z $( getData $(( x - 2 )) $(( y + 2 )) ) && -z $( getData $(( x + 2 )) $(( y - 2 )) ) ]]
			then
				p3s="${p32}"
			else
				p3s="${p3}"
				if [[ -z $( getData $(( x - 2 )) $(( y + 2 )) ) ]]
				then
					insertData $(( x - 3 )) $(( y + 3 )) $(( p3 - 1 ))
				fi
				if [[ -z $( getData $(( x + 2 )) $(( y - 2 )) ) ]]
				then
					insertData $(( x + 3 )) $(( y - 3 )) $(( p3 - 1 ))
				fi
			fi
			
			if [[ -z $( getData $(( x + 2 )) $(( y - 2 )) ) && $( getData $(( x + 3 )) $(( y - 3 )) ) == "${pID}" ]]
			then
				insertData $(( x + 2 )) $(( y - 2 )) "${p4}"
			else
				insertData $(( x + 2 )) $(( y - 2 )) "${p3s}"
			fi
			if [[ -z $( getData $(( x - 2 )) $(( y + 2 )) ) && $( getData $(( x - 3 )) $(( y + 3 )) ) == "${pID}" ]]
			then
				insertData $(( x - 2 )) $(( y + 2 )) "${p4}"
			else
				insertData $(( x - 2 )) $(( y + 2 )) "${p3s}"
			fi
			if [[ $( getData $(( x + 2 )) $(( y - 2 )) ) == "${pID}" ]]
			then
				insertData $(( x + 3 )) $(( y - 3 )) "${p4}"
				insertData $(( x - 2 )) $(( y + 2 )) "${p4}"
			fi
			if [[ $( getData $(( x - 2 )) $(( y + 2 )) ) == "${pID}" ]]
			then
				insertData $(( x - 3 )) $(( y + 3 )) "${p4}"
				insertData $(( x + 2 )) $(( y - 2 )) "${p4}"
			fi
		fi
	fi
	##########################################################
	if [[ -z $( getData  $(( x - 1 )) $(( y - 1 )) ) && $( getData  $(( x - 2 )) $(( y - 2 )) ) == "${pID}" ]]
	then
		debug "4.0"
		insertData $(( x - 1 )) $(( y - 1 )) "${p2}"
	fi
	if [[ $( getData $(( x - 1 )) $(( y - 1 )) ) == "${pID}" ]] # if 2 in row
	then
		debug "4.1"
		t="oblbot" # hor, ver, oblbot, obltop
		insertData $(( x + 1 )) $(( y + 1 )) "${p2}"
		insertData $(( x - 2 )) $(( y - 2 )) "${p2}"
		if [[ -z $( getData $(( x + 1 )) $(( y + 1 )) ) && $( getData $(( x + 2 )) $(( y + 2 )) ) == "${pID}" ]]
		then			
			if [[ $( getData $(( x + 3 )) $(( y + 3 )) ) == "${pID}" ]]
			then
				insertData $(( x + 1 )) $(( y + 1 )) "${p4}"
			else
				insertData $(( x - 2 )) $(( y - 2 )) $(( p3 - 1 ))
				insertData $(( x + 3 )) $(( y + 3 )) $(( p3 - 1 ))
				if [[ -z $( getData $(( x - 2 )) $(( y - 2 )) ) && -z $( getData $(( x + 3 )) $(( y + 3 )) ) ]]
				then
					debug "4.1.3.1"
					insertData $(( x + 1 )) $(( y + 1 )) "${p32}"
				else
					debug "4.1.3.2"
					insertData $(( x + 1 )) $(( y + 1 )) "${p3}"
				fi
			fi
		fi
		if [[ -z $( getData $(( x - 2 )) $(( y - 2 )) ) && $( getData $(( x - 3 )) $(( y - 3 )) ) == "${pID}" ]]
		then
			insertData $(( x - 4 )) $(( y - 4 )) $(( p3 - 1 ))
			insertData $(( x + 1 )) $(( y + 1 )) $(( p3 - 1 ))
			if [[ -z $( getData $(( x - 4 )) $(( y - 4 )) ) && -z $( getData $(( x + 1 )) $(( y + 1 )) ) ]]
			then
				debug "4.1.4.1"
				insertData $(( x - 2 )) $(( y - 2 )) "${p32}"
			else
				debug "4.1.4.2"
				insertData $(( x - 2 )) $(( y - 2 )) "${p3}"
			fi
		fi
	
		if [[ $( getData $(( x + 1 )) $(( y + 1 )) ) == "${pID}" ]] # if 3 in row
		then
			debug "4.2"
			p3s=""
			if [[ -z $( getData $(( x + 2 )) $(( y + 2 )) ) && -z $( getData $(( x - 2 )) $(( y - 2 )) ) ]]
			then
				p3s="${p32}"
			else
				p3s="${p3}"
				if [[ -z $( getData $(( x + 2 )) $(( y + 2 )) ) ]]
				then
					insertData $(( x + 3 )) $(( y + 3 ))  $(( p3 - 1 ))
				fi
				if [[ -z $( getData $(( x - 2 )) $(( y - 2 )) ) ]]
				then
					insertData $(( x - 3 )) $(( y - 3 )) $(( p3 - 1 ))
				fi
			fi
			
			if [[ -z $( getData $(( x + 2 )) $(( y + 2 )) ) && $( getData $(( x + 3 )) $(( y + 3 )) ) == "${pID}" ]]
			then
				insertData $(( x + 2 )) $(( y + 2 )) "${p4}"
			else
				insertData $(( x + 2 )) $(( y + 2 )) "${p3s}"
			fi
			if [[ -z $( getData $(( x - 2 )) $(( y - 2 )) ) && $( getData $(( x - 3 )) $(( y - 3 )) ) == "${pID}" ]]
			then
				insertData $(( x - 2 )) $(( y - 2 )) "${p4}"
			else
				insertData $(( x - 2 )) $(( y - 2 )) "${p3s}"
			fi
			if [[ $( getData $(( x + 2 )) $(( y + 2 )) ) == "${pID}" ]]
			then
				insertData $(( x + 3 )) $(( y + 3 )) "${p4}"
				insertData $(( x - 2 )) $(( y - 2 )) "${p4}"
			fi
			if [[ $( getData $(( x - 2 )) $(( y - 2 )) ) == "${pID}" ]]
			then
				insertData $(( x - 3 )) $(( y - 3 )) "${p4}"
				insertData $(( x + 2 )) $(( y + 2 )) "${p4}"
			fi
		fi
	fi
	##########################################################
	
}

function cleanInvalidNextHits {
	sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM nextHits;" | while read -r line
	do
		x=$( echo "${line}" | cut -d "|" -f 1 )
		y=$( echo "${line}" | cut -d "|" -f 2 )
		
		if [[ "${x}" -lt "${minX}" || "${x}" -gt "${maxX}" || "${y}" -lt "${minY}" || "${y}" -gt "${maxY}" ]]
		then
			sqlite3 "${tmpFolder}/${gID}.db" "DELETE FROM nextHits WHERE x = '${x}' AND y = '${y}'"
			continue
		fi
		if [[ -n $( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM game WHERE x = '${x}' AND y = '${y}';" ) ]]
		then
			sqlite3 "${tmpFolder}/${gID}.db" "DELETE FROM nextHits WHERE x = '${x}' AND y = '${y}'"
		fi
	done
}

function getData {
	sqlite3 "${tmpFolder}/${gID}.db" "SELECT p FROM game WHERE x = '${1}' AND y = '${2}';"
}

function insertData {
	sqlite3 "${tmpFolder}/${gID}.db" "INSERT INTO nextHits ( x, y, p, t ) VALUES ( '${1}', '${2}', '${3}', '${t}' ) ON CONFLICT( x, y, t ) DO UPDATE SET p = CASE WHEN p < ${3} THEN ${3} ELSE p END;"
	debug "INSERT: ${1}, ${2}, ${3}, ${t}"
}

function thinking {

	nHX=""
	nHY=""	
	sqlite3 "${tmpFolder}/${gID}.db" "DELETE FROM nextHits;"
	sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM game WHERE p = '${oppID}';" | while read -r line
	do
		x=$( echo "${line}" | cut -d "|" -f 1 )
		y=$( echo "${line}" | cut -d "|" -f 2 )
		checkSquare "${x}" "${y}" "${oppID}"
	done
	
	sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM game WHERE p = '${uID}';" | while read -r line
	do
		x=$( echo "${line}" | cut -d "|" -f 1 )
		y=$( echo "${line}" | cut -d "|" -f 2 )
		checkSquare "${x}" "${y}" "${uID}"
	done
	
	cleanInvalidNextHits
	debug "########## Prehled, ze kteryho vybiram:"
	debug "$( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y, s FROM nextHitsView;" )"
	debug "########## Konec prehledu"
	line=$( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM nextHitsView WHERE s = ( SELECT MAX(s) FROM nextHitsView ) ORDER BY RANDOM() LIMIT 1;" )
	nHX=$( echo "${line}" | cut -d "|" -f 1 )
	nHY=$( echo "${line}" | cut -d "|" -f 2 )
	
	###first few hits:
	
	if [[ -z "${nHX}" || -z "${nHY}" ]]
	then
		if [[ -z $( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM game" ) ]]
		then
			# Start position if I start
			#nHX=$(( ( $RANDOM % 50 ) - 25 ))
			#nHY=$(( ( $RANDOM % 30 ) - 15 ))
			nHX=0
			nHY=0
		else
			sqlite3 "${tmpFolder}/${gID}.db" "DELETE FROM nextHits;"
			sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM game WHERE p = '${uID}';" | while read -r line
			do
				x=$( echo "${line}" | cut -d "|" -f 1 )
				y=$( echo "${line}" | cut -d "|" -f 2 )
				sqlite3 "${tmpFolder}/${gID}.db" "INSERT OR IGNORE INTO nextHits ( x, y, p, t ) VALUES ( '$(( x + 1 ))', '$(( y + 1 ))', '2', '${x}|${y}' ), ( '$(( x - 1 ))', '$(( y + 1 ))', '2', '${x}|${y}' ), ( '$(( x - 1 ))', '$(( y - 1 ))', '2', '${x}|${y}' ), ( '$(( x + 1 ))', '$(( y - 1 ))', '2', '${x}|${y}' ), ( '${x}', '$(( y + 1 ))', '2', '${x}|${y}' ), ( '${x}', '$(( y - 1 ))', '2', '${x}|${y}' ), ( '$(( x + 1 ))', '${y}', '2', '${x}|${y}' ), ( '$(( x - 1 ))', '${y}', '2', '${x}|${y}' )"
			done
			sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM game WHERE p = '${oppID}';" | while read -r line
			do
				x=$( echo "${line}" | cut -d "|" -f 1 )
				y=$( echo "${line}" | cut -d "|" -f 2 )
				sqlite3 "${tmpFolder}/${gID}.db" "INSERT OR IGNORE INTO nextHits ( x, y, p, t ) VALUES ( '$(( x + 1 ))', '$(( y + 1 ))', '1', '${x}|${y}' ), ( '$(( x - 1 ))', '$(( y + 1 ))', '1', '${x}|${y}' ), ( '$(( x - 1 ))', '$(( y - 1 ))', '1', '${x}|${y}' ), ( '$(( x + 1 ))', '$(( y - 1 ))', '1', '${x}|${y}' ), ( '${x}', '$(( y + 1 ))', '1', '${x}|${y}' ), ( '${x}', '$(( y - 1 ))', '1', '${x}|${y}' ), ( '$(( x + 1 ))', '${y}', '1', '${x}|${y}' ), ( '$(( x - 1 ))', '${y}', '1', '${x}|${y}' )"
			done
			
			cleanInvalidNextHits
			debug "########## Moznosti mimo:"
			debug "$( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y, s FROM nextHitsView WHERE s = ( SELECT MAX(s) FROM nextHitsView ) ORDER BY RANDOM();" )"
			debug "########## Konec moznosti mimo"
			line=$( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM nextHitsView WHERE s = ( SELECT MAX(s) FROM nextHitsView ) ORDER BY RANDOM() LIMIT 1;" )
			nHX=$( echo "${line}" | cut -d "|" -f 1 )
			nHY=$( echo "${line}" | cut -d "|" -f 2 )
		fi
	fi
}
