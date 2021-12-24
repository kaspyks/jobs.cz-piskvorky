#!/bin/bash

function checkSquares {
	
	for line in "${field[@]}"
	do
		if [[ "$( echo "${line}" | cut -d "|" -f 4 )" != "1" ]]
		then
			x=$( echo "${line}" | cut -d "|" -f 1 )
			y=$( echo "${line}" | cut -d "|" -f 2 )
			pID=$( echo "${line}" | cut -d "|" -f 3 )
			debug "########## Check: ${x}, ${y}, ${pID}"


			################################################################
			check=0
			for t in 1 2 3 4
			do
				hG1=$( hit "g" "1" )
				hG2=$( hit "g" "2" )
				hG3=$( hit "g" "3" )
				hGN1=$( hit "g" "-1" )
				hGN2=$( hit "g" "-2" )
				hGN3=$( hit "g" "-3" )
				hGN4=$( hit "g" "-4" )
				
				if [[ -n "${hG1}" ]]
				then
					if [[ "${hG1}" == "${pID}" ]]
					then
						if [[ -n "${hG2}" ]]
						then
							if [[ "${hG2}" == "${pID}" ]]
							then
								if [[ -n "${hG3}" && "${hG3}" != "${pID}" ]]
								then
									check=$(( check + 1 ))
								fi
							else
								check=$(( check + 1 ))
							fi
						fi
					else
						check=$(( check + 1 ))
					fi
				fi
				if [[ -n "${hGN1}" ]]
				then
					if [[ "${hGN1}" == "${pID}" ]]
					then
						if [[ -n "${hGN2}" ]]
						then
							if [[ "${hGN2}" == "${pID}" ]]
							then
								if [[ -n "${hGN3}" && "${hGN3}" != "${pID}" ]]
								then
									check=$(( check + 1 ))
								fi
							else
								check=$(( check + 1 ))
							fi
						fi
					else
						check=$(( check + 1 ))
					fi
				fi
				
				
				if [[ "${hGN1}" == "${pID}" && "${hG1}" == "${pID}" ]]
				then
					if [[ -z "${hG2}" && "${hG3}" == "${pID}" ]]; then debug "${t}.1"
						if [[ "${pID}" == "${uID}" ]]
						then
							hit "i" "2" "50000"
						else
							hit "i" "2" "10000"
						fi
					fi
					if [[ -z "${hGN2}" && "${hGN3}" == "${pID}" ]]; then debug "${t}.2"
						if [[ "${pID}" == "${uID}" ]]
						then
							hit "i" "-2" "50000"
						else
							hit "i" "-2" "10000"
						fi
					fi
					if [[ "${hG2}" == "${pID}" ]]
					then
						if [[ -z "${hGN2}" && -z "${hG3}" ]]; then debug "${t}.3"
							if [[ "${pID}" == "${uID}" ]]
							then
								hit "i" "-2" "50000"
								hit "i" "3" "50000"
							fi
						fi
						if [[ -z "${hG3}" && ( -n "${hGN2}" && "${hGN2}" != "${pID}" ) ]]; then debug "${t}.5"
							if [[ "${pID}" == "${uID}" ]]
							then
								hit "i" "3" "50000"
							else
								hit "i" "3" "10000"
							fi
						fi
						if [[ -z "${hGN2}" && ( -n "${hG3}" && "${hG3}" != "${pID}" ) ]]; then debug "${t}.6"
							if [[ "${pID}" == "${uID}" ]]
							then
								hit "i" "-2" "50000"
							else
								hit "i" "-2" "10000"
							fi
						fi
					fi
					if [[ -z "${hG2}" && -z "${hGN2}" ]]; then debug "${t}.11"
						if [[ "${pID}" == "${uID}" ]]
						then
							if [[ -z "${hG3}" ]]
							then
								hit "i" "2" "2000"
							else
								hit "i" "2" "1970"
							fi
							if [[ -z "${hGN3}" ]]
							then
								hit "i" "-2" "2000"
							else
								hit "i" "-2" "1970"
							fi
						else
							if [[ -z "${hG3}" ]]
							then
								hit "i" "2" "1000"
							else
								hit "i" "2" "970"
							fi
							if [[ -z "${hGN3}" ]]
							then
								hit "i" "-2" "1000"
							else
								hit "i" "-2" "970"
							fi
						fi
					fi
					if [[ -z "${hG2}" && -z "${hG3}" && ( -n "${hGN2}" && "${hGN2}" != "${pID}" ) ]]; then debug "${t}.12"
						if [[ "${pID}" == "${uID}" ]]
						then
							hit "i" "2" "400"
							hit "i" "3" "400"
						else
							hit "i" "2" "300"
							hit "i" "3" "300"
						fi
					fi
					if [[ -z "${hGN2}" && -z "${hGN3}" && ( -n "${hG2}" && "${hG2}" != "${pID}" ) ]]; then debug "${t}.13"
						if [[ "${pID}" == "${uID}" ]]
						then
							hit "i" "-2" "400"
							hit "i" "-3" "400"
						else
							hit "i" "-2" "300"
							hit "i" "-3" "300"
						fi
					fi
				fi
				if [[ "${hGN1}" == "${pID}" ]]
				then
					if [[ -z "${hG1}" && "${hG2}" == "${pID}" ]]
					then
						if [[ "${hG3}" == "${pID}" ]]; then debug "${t}.10"
							if [[ "${pID}" == "${uID}" ]]
							then
								hit "i" "1" "50000"
							else
								hit "i" "1" "10000"
							fi
						fi
						if [[ -z "${hGN2}" && -z "${hG3}" ]]; then debug "${t}.15"
							if [[ "${pID}" == "${uID}" ]]
							then
								hit "i" "-2" "350"
								hit "i" "3" "300"
								hit "i" "1" "2000"
							else
								hit "i" "-2" "450"
								hit "i" "3" "400"
								hit "i" "1" "1000"
							fi
						fi
						if [[ -z "${hG3}" && ( -n "${hGN2}" && "${hGN2}" != "${pID}" ) ]]; then debug "${t}.16"
							if [[ "${pID}" == "${uID}" ]]
							then
								hit "i" "3" "300"
								hit "i" "1" "150"
							else
								hit "i" "3" "400"
								hit "i" "1" "250"
							fi
						fi
						if [[ -z "${hGN2}" && ( -n "${hG3}" && "${hG3}" != "${pID}" ) ]]; then debug "${t}.17"
							if [[ "${pID}" == "${uID}" ]]
							then
								hit "i" "-2" "350"
								hit "i" "1" "250"
							else
								hit "i" "-2" "450"
								hit "i" "1" "350"
							fi
						fi
					fi
					if [[ -z "${hGN2}" && "${hGN3}" == "${pID}" ]]
					then
						if [[ -z "${hG1}" && -z "${hGN4}" ]]; then debug "${t}.19"
							if [[ "${pID}" == "${uID}" ]]
							then
								hit "i" "-2" "2000"
								hit "i" "-4" "300"
								hit "i" "1" "350"
							else
								hit "i" "-2" "1000"
								hit "i" "-4" "400"
								hit "i" "1" "450"
							fi
						fi
						if [[ -z "${hGN4}" && ( -n "${hG1}" && "${hG1}" != "${pID}" ) ]]; then debug "${t}.20"
							if [[ "${pID}" == "${uID}" ]]
							then
								hit "i" "-2" "150"
								hit "i" "-4" "300"
							else
								hit "i" "-2" "250"
								hit "i" "-4" "400"
							fi
						fi
						if [[ -z "${hG1}" && ( -n "${hGN4}" && "${hGN4}" != "${pID}" ) ]]; then debug "${t}.21"
							if [[ "${pID}" == "${uID}" ]]
							then
								hit "i" "-2" "250"
								hit "i" "1" "350"
							else
								hit "i" "-2" "350"
								hit "i" "1" "450"
							fi
						fi
					fi
				fi
				if [[ -z "${hGN1}" && "${hGN2}" == "${pID}" && -z "${hGN3}" && -z "${hG1}" ]]; then debug "${t}.25"
					hit "i" "-1" "50"
					hit "i" "-3" "40"
					hit "i" "1" "40"
				fi
			done
			
			
#			################################################### ALLLL
#			
#			for t in 1 2 3 4
#			do
#				hG1=$( hit "g" "1" )
#				hG2=$( hit "g" "2" )
#				hG3=$( hit "g" "3" )
#				hGN1=$( hit "g" "-1" )
#				hGN2=$( hit "g" "-2" )
#				hGN3=$( hit "g" "-3" )
#				hGN4=$( hit "g" "-4" )
#				
#				
#				if [[ -n "${hG1}" ]]
#				then
#					if [[ "${hG1}" == "${pID}" ]]
#					then
#						if [[ -n "${hG2}" ]]
#						then
#							if [[ "${hG2}" == "${pID}" ]]
#							then
#								if [[ -n "${hG3}" && "${hG3}" != "${pID}" ]]
#								then
#									check=$(( check + 1 ))
#								fi
#							else
#								check=$(( check + 1 ))
#							fi
#						fi
#					else
#						check=$(( check + 1 ))
#					fi
#				fi
#				if [[ -n "${hGN1}" ]]
#				then
#					if [[ "${hGN1}" == "${pID}" ]]
#					then
#						if [[ -n "${hGN2}" ]]
#						then
#							if [[ "${hGN2}" == "${pID}" ]]
#							then
#								if [[ -n "${hGN3}" && "${hGN3}" != "${pID}" ]]
#								then
#									check=$(( check + 1 ))
#								fi
#							else
#								check=$(( check + 1 ))
#							fi
#						fi
#					else
#						check=$(( check + 1 ))
#					fi
#				fi
#				
#				
#				if [[ "${hGN1}" == "${pID}" && "${hG1}" == "${pID}" ]]
#				then
#					if [[ -z "${hG2}" && "${hG3}" == "${pID}" ]]; then debug "${t}.1"
#						if [[ "${pID}" == "${uID}" ]]
#						then
#							hit "i" "2" "50000"
#						else
#							hit "i" "2" "10000"
#						fi
#					fi
#					if [[ -z "${hGN2}" && "${hGN3}" == "${pID}" ]]; then debug "${t}.2"
#						if [[ "${pID}" == "${uID}" ]]
#						then
#							hit "i" "-2" "50000"
#						else
#							hit "i" "-2" "10000"
#						fi
#					fi
#					if [[ "${hG2}" == "${pID}" ]]
#					then
#						if [[ -z "${hGN2}" && -z "${hG3}" ]]; then debug "${t}.3"
#							if [[ "${pID}" == "${uID}" ]]
#							then
#								hit "i" "-2" "50000"
#								hit "i" "3" "50000"
#							fi
#						fi
#						if [[ -z "${hG3}" && ( -n "${hGN2}" && "${hGN2}" != "${pID}" ) ]]; then debug "${t}.5"
#							if [[ "${pID}" == "${uID}" ]]
#							then
#								hit "i" "3" "50000"
#							else
#								hit "i" "3" "10000"
#							fi
#						fi
#						if [[ -z "${hGN2}" && ( -n "${hG3}" && "${hG3}" != "${pID}" ) ]]; then debug "${t}.6"
#							if [[ "${pID}" == "${uID}" ]]
#							then
#								hit "i" "-2" "50000"
#							else
#								hit "i" "-2" "10000"
#							fi
#						fi
#					fi
#					if [[ -z "${hG2}" && -z "${hGN2}" ]]; then debug "${t}.11"
#						if [[ "${pID}" == "${uID}" ]]
#						then
#							if [[ -z "${hG3}" ]]
#							then
#								hit "i" "2" "2000"
#							else
#								hit "i" "2" "1970"
#							fi
#							if [[ -z "${hGN3}" ]]
#							then
#								hit "i" "-2" "2000"
#							else
#								hit "i" "-2" "1970"
#							fi
#						else
#							if [[ -z "${hG3}" ]]
#							then
#								hit "i" "2" "1000"
#							else
#								hit "i" "2" "970"
#							fi
#							if [[ -z "${hGN3}" ]]
#							then
#								hit "i" "-2" "1000"
#							else
#								hit "i" "-2" "970"
#							fi
#						fi
#					fi
#					if [[ -z "${hG2}" && -z "${hG3}" && ( -n "${hGN2}" && "${hGN2}" != "${pID}" ) ]]; then debug "${t}.12"
#						if [[ "${pID}" == "${uID}" ]]
#						then
#							hit "i" "2" "400"
#							hit "i" "3" "400"
#						else
#							hit "i" "2" "300"
#							hit "i" "3" "300"
#						fi
#					fi
#					if [[ -z "${hGN2}" && -z "${hGN3}" && ( -n "${hG2}" && "${hG2}" != "${pID}" ) ]]; then debug "${t}.13"
#						if [[ "${pID}" == "${uID}" ]]
#						then
#							hit "i" "-2" "400"
#							hit "i" "-3" "400"
#						else
#							hit "i" "-2" "300"
#							hit "i" "-3" "300"
#						fi
#					fi
#				fi
#				if [[ "${hGN1}" == "${pID}" ]]
#				then
#					if [[ -z "${hG1}" && "${hG2}" == "${pID}" ]]
#					then
#						if [[ "${hG3}" == "${pID}" ]]; then debug "${t}.10"
#							if [[ "${pID}" == "${uID}" ]]
#							then
#								hit "i" "1" "50000"
#							else
#								hit "i" "1" "10000"
#							fi
#						fi
#						if [[ -z "${hGN2}" && -z "${hG3}" ]]; then debug "${t}.15"
#							if [[ "${pID}" == "${uID}" ]]
#							then
#								hit "i" "-2" "350"
#								hit "i" "3" "300"
#								hit "i" "1" "2000"
#							else
#								hit "i" "-2" "450"
#								hit "i" "3" "400"
#								hit "i" "1" "1000"
#							fi
#						fi
#						if [[ -z "${hG3}" && ( -n "${hGN2}" && "${hGN2}" != "${pID}" ) ]]; then debug "${t}.16"
#							if [[ "${pID}" == "${uID}" ]]
#							then
#								hit "i" "3" "300"
#								hit "i" "1" "150"
#							else
#								hit "i" "3" "400"
#								hit "i" "1" "250"
#							fi
#						fi
#						if [[ -z "${hGN2}" && ( -n "${hG3}" && "${hG3}" != "${pID}" ) ]]; then debug "${t}.17"
#							if [[ "${pID}" == "${uID}" ]]
#							then
#								hit "i" "-2" "350"
#								hit "i" "1" "250"
#							else
#								hit "i" "-2" "450"
#								hit "i" "1" "350"
#							fi
#						fi
#					fi
#					if [[ -z "${hGN2}" && "${hGN3}" == "${pID}" ]]
#					then
#						if [[ -z "${hG1}" && -z "${hGN4}" ]]; then debug "${t}.19"
#							if [[ "${pID}" == "${uID}" ]]
#							then
#								hit "i" "-2" "2000"
#								hit "i" "-4" "300"
#								hit "i" "1" "350"
#							else
#								hit "i" "-2" "1000"
#								hit "i" "-4" "400"
#								hit "i" "1" "450"
#							fi
#						fi
#						if [[ -z "${hGN4}" && ( -n "${hG1}" && "${hG1}" != "${pID}" ) ]]; then debug "${t}.20"
#							if [[ "${pID}" == "${uID}" ]]
#							then
#								hit "i" "-2" "150"
#								hit "i" "-4" "300"
#							else
#								hit "i" "-2" "250"
#								hit "i" "-4" "400"
#							fi
#						fi
#						if [[ -z "${hG1}" && ( -n "${hGN4}" && "${hGN4}" != "${pID}" ) ]]; then debug "${t}.21"
#							if [[ "${pID}" == "${uID}" ]]
#							then
#								hit "i" "-2" "250"
#								hit "i" "1" "350"
#							else
#								hit "i" "-2" "350"
#								hit "i" "1" "450"
#							fi
#						fi
#					fi
#				fi
#				if [[ -z "${hGN1}" && "${hGN2}" == "${pID}" && -z "${hGN3}" && -z "${hG1}" ]]; then debug "${t}.25"
#					hit "i" "-1" "50"
#					hit "i" "-3" "40"
#					hit "i" "1" "40"
#				fi
#			done
#			
#			######################### END OF ALLL
			
			
			
			if [[ "${check}" -eq 8 ]]
			then
				p=$( echo "${field[$((x+100))0$((y+100))]}" | cut -d "|" -f 3 )
				field[$((x+100))0$((y+100))]="${x}|${y}|${p}|1"
				debug "!!!!!!!!!!!!!!!!!!!!!! DONE ${x}, ${y}"
			fi
		fi
	done
	######################################################################
}

function chooseTheBest {
	res=$( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM nextHitsView WHERE s = ( SELECT MAX(s) FROM nextHitsView );" )
	if [[ $( echo "${res}" | wc -l ) -eq 1 ]]
	then
		nHX=$( echo "${res}" | cut -d "|" -f 1 )
		nHY=$( echo "${res}" | cut -d "|" -f 2 )
	else
		debug "### Running The Best Choice"
		sqlite3 "${tmpFolder}/${gID}.db" "DELETE FROM theBest;"
		echo "${res}" | while read -r line
		do
			x=$( echo "${line}" | cut -d "|" -f 1 )
			y=$( echo "${line}" | cut -d "|" -f 2 )
			score=0
			for t in 1 2 3 4
			do
				aPID=""
				for i in 1 2 3 4 -1 -2 -3 -4
				do
					if [[ "${i}" -eq -1 ]]; then aPID=""; fi
					h=$( hit "g" "${i}" )
					if [[ -z "${h}" ]]
					then
						continue
					else
						if [[ -z "${aPID}" ]]
						then
							aPID="${h}"
							score=$(( score + 1 ))
						else
							if [[ "${aPID}" == "${h}" ]]
							then
								score=$(( score + 1 ))
							else
								break
							fi
						fi
					fi
				done
			done
			sqlite3 "${tmpFolder}/${gID}.db" "INSERT INTO theBest ( x, y, p ) VALUES ( '${x}', '${y}', '${score}' );"
		done
		debug "########## The Best, ze kteryho vybiram:"
		debug "$( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y, p FROM theBest;" )"
		debug "########## The Best konec prehledu"
		line=$( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM theBest WHERE p = ( SELECT MAX(p) FROM theBest ) ORDER BY RANDOM() LIMIT 1;" )
		nHX=$( echo "${line}" | cut -d "|" -f 1 )
		nHY=$( echo "${line}" | cut -d "|" -f 2 )
	fi
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
		if [[ -n "${field[$((x+100))0$((y+100))]}" ]]
		then
			sqlite3 "${tmpFolder}/${gID}.db" "DELETE FROM nextHits WHERE x = '${x}' AND y = '${y}'"
		fi
	done
}

function hit {
	action="${1}"
	move="${2}"
	hX=""
	hY=""

	if [[ "${t}" == "1" ]] # hor
	then
		hX=$(( x + move ))
		hY="${y}"
	elif [[ "${t}" == "2" ]] # ver
	then
		hX="${x}"
		hY=$(( y + move ))
	elif [[ "${t}" == "3" ]] # oblbot
	then
		hX=$(( x + move ))
		hY=$(( y - move ))
	elif [[ "${t}" == "4" ]] # obltop
	then
		hX=$(( x + move ))
		hY=$(( y + move ))
	else
		return 1
	fi
	
	if [[ "${action}" == "i" ]]
	then
		sqlite3 "${tmpFolder}/${gID}.db" "INSERT INTO nextHits ( x, y, p, t ) VALUES ( '${hX}', '${hY}', '${3}', '${t}' ) ON CONFLICT( x, y, t ) DO UPDATE SET p = CASE WHEN p < ${3} THEN ${3} ELSE p END;"
		debug "INSERT: ${hX}, ${hY}, ${3}, ${t}"
		check=$(( check + 1 ))
	elif [[ "${action}" == "g" ]]
	then
		echo "${field[$((hX+100))0$((hY+100))]}" | cut -d "|" -f 3 | tr -d " "
	else
		return 2
	fi
}

function thinking {
	
	nHX=""
	nHY=""
	sqlite3 "${tmpFolder}/${gID}.db" "DELETE FROM nextHits;"
	checkSquares
	#checkSquares "${oppID}" &
	#checkSquares "${uID}" &
	#wait

	cleanInvalidNextHits
	debug "########## Prehled, ze kteryho vybiram:"
	debug "$( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y, s FROM nextHitsView;" )"
	debug "########## Konec prehledu"
	chooseTheBest
	
	###first few hits:
	
	if [[ -z "${nHX}" || -z "${nHY}" ]]
	then
		if [[ ${#field[@]} -eq 0 ]]
		then
			# Start position if I start
			#nHX=$(( ( $RANDOM % 50 ) - 25 ))
			#nHY=$(( ( $RANDOM % 30 ) - 15 ))
			nHX=0
			nHY=0
			sleep 1.2
		else
			sqlite3 "${tmpFolder}/${gID}.db" "DELETE FROM nextHits;"
			for line in "${field[@]}"
			do
				x=$( echo "${line}" | cut -d "|" -f 1 )
				y=$( echo "${line}" | cut -d "|" -f 2 )
				pID=$( echo "${line}" | cut -d "|" -f 3 )
				if [[ "${pID}" == "${uID}" ]]
				then
					p=2
				else
					p=1
				fi
				sqlite3 "${tmpFolder}/${gID}.db" "INSERT OR IGNORE INTO nextHits ( x, y, p, t ) VALUES ( '$(( x + 1 ))', '$(( y + 1 ))', '${p}', '${x}|${y}' ), ( '$(( x - 1 ))', '$(( y + 1 ))', '${p}', '${x}|${y}' ), ( '$(( x - 1 ))', '$(( y - 1 ))', '${p}', '${x}|${y}' ), ( '$(( x + 1 ))', '$(( y - 1 ))', '${p}', '${x}|${y}' ), ( '${x}', '$(( y + 1 ))', '${p}', '${x}|${y}' ), ( '${x}', '$(( y - 1 ))', '${p}', '${x}|${y}' ), ( '$(( x + 1 ))', '${y}', '${p}', '${x}|${y}' ), ( '$(( x - 1 ))', '${y}', '${p}', '${x}|${y}' )"
			done

			cleanInvalidNextHits
			debug "########## Moznosti mimo:"
			debug "$( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y, s FROM nextHitsView WHERE s = ( SELECT MAX(s) FROM nextHitsView ) ORDER BY RANDOM();" )"
			debug "########## Konec moznosti mimo"
			chooseTheBest
			#line=$( sqlite3 "${tmpFolder}/${gID}.db" "SELECT x, y FROM nextHitsView WHERE s = ( SELECT MAX(s) FROM nextHitsView ) ORDER BY RANDOM() LIMIT 1;" )
			#nHX=$( echo "${line}" | cut -d "|" -f 1 )
			#nHY=$( echo "${line}" | cut -d "|" -f 2 )
		fi
	fi
}
