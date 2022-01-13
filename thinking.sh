#!/bin/bash

function checkDoneSquares {

	if [[ -n "${hG1}" ]]
	then
		if [[ "${hG1}" == "${aPID}" ]]
		then
			if [[ -n "${hG2}" ]]
			then
				if [[ "${hG2}" == "${aPID}" ]]
				then
					if [[ -n "${hG3}" ]]
					then
						if [[ "${hG3}" == "${aPID}" ]]
						then
							if [[ -n "${hG4}" && "${hG4}" != "${aPID}" ]]
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
		else
			check=$(( check + 1 ))
		fi
	fi
	if [[ -n "${hGN1}" ]]
	then
		if [[ "${hGN1}" == "${aPID}" ]]
		then
			if [[ -n "${hGN2}" ]]
			then
				if [[ "${hGN2}" == "${aPID}" ]]
				then
					if [[ -n "${hGN3}" ]]
					then
						if [[ "${hGN3}" == "${aPID}" ]]
						then
							if [[ -n "${hGN4}" && "${hGN4}" != "${aPID}" ]]
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
		else
			check=$(( check + 1 ))
		fi
	fi
	
}

function chooseTheBest {
	if [[ ${#nextHits[@]} -eq 0 ]]; then return; fi
	if [[ ${#nextHits[@]} -eq 1 ]]
	then
		for line in "${nextHits[@]}"
		do
			aP=$( echo "${line}" | cut -d "|" -f 3 )
			if [[ "${aP}" -eq "${nextHitsMax}" ]]
			then 
				nHX=$( echo "${line}" | cut -d "|" -f 1 )
				nHY=$( echo "${line}" | cut -d "|" -f 2 )
				return
			else
				continue
			fi
		done
	fi
	debug "### Running The Best Choice"
	theBestMax=0
	unset theBest
	declare -a theBest
	self=0
	for line in "${nextHits[@]}"
	do
		aP=$( echo "${line}" | cut -d "|" -f 3 )
		if [[ -z "${line}" || "${aP}" -ne "${nextHitsMax}" ]]; then continue; fi
		aX=$( echo "${line}" | cut -d "|" -f 1 )
		aY=$( echo "${line}" | cut -d "|" -f 2 )
		score=0
		for t in 0 1 2 3
		do
			aPID=""
			for i in 1 2 3 4 -1 -2 -3 -4
			do
				if [[ "${i}" -eq -1 ]]; then aPID=""; fi
				h=$( hit "g" "${i}" "${t}" )
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
		theBest[$(( RANDOM % 10000 ))]="${aX}|${aY}|${score}"
		if [[ ${theBestMax} -lt ${score} ]]; then theBestMax=${score}; fi
	done
	debug "########## The Best, ze kteryho vybiram:"
	for i in "${theBest[@]}"; do debug "${i}"; done
	debug "########## The Best konec prehledu"
	for i in "${theBest[@]}"
	do
		if [[ $( echo "${i}" | cut -d "|" -f 3 ) -eq ${theBestMax} ]]
		then
			nHX=$( echo "${i}" | cut -d "|" -f 1 )
			nHY=$( echo "${i}" | cut -d "|" -f 2 )
			break
		fi
	done
}

function cleanInvalidNextHits {
	for line in "${nextHits[@]}"
	do
		x=$( echo "${line}" | cut -d "|" -f 1 )
		y=$( echo "${line}" | cut -d "|" -f 2 )
		
		if [[ "${x}" -lt "${minX}" || "${x}" -gt "${maxX}" || "${y}" -lt "${minY}" || "${y}" -gt "${maxY}" || -n "${field[$((x+100))0$((y+100))]}" ]]
		then
			nextHits[$((x+100))0$((y+100))]=""
		fi
	done
}

function firstFewHits {
	if [[ "${hG1}" != "${oppID}" &&  "${hGN1}" != "${oppID}" && ( "${hG2}" != "${oppID}" ||  "${hGN2}" != "${oppID}" ) && ( "${hG3}" != "${oppID}" ||  "${hGN3}" != "${oppID}" ) ]]
	then
		hit "i" "-2" "${t}" "1"
		hit "i" "-1" "${t}" "1"
		hit "i" "1" "${t}" "1"
		hit "i" "2" "${t}" "1"
	fi
}

function hit {

	action="${1}"
	move="${2}"
	aT="${3}"
	p="${4}"
	hX=""
	hY=""
	
	if [[ "${aT}" == "0" ]] # hor
	then
		hX=$(( aX + move ))
		hY="${aY}"
	elif [[ "${aT}" == "1" ]] # ver
	then
		hX="${aX}"
		hY=$(( aY + move ))
	elif [[ "${aT}" == "2" ]] # oblbot
	then
		hX=$(( aX + move ))
		hY=$(( aY - move ))
	elif [[ "${aT}" == "3" ]] # obltop
	then
		hX=$(( aX + move ))
		hY=$(( aY + move ))
	else
		return 1
	fi
	
	if [[ "${self}" -eq 0 && "${action}" == "i" ]]
	then
		nAX=$((hX+100))
		nAY=$((hY+100))
		if [[ -n "${nextHits[${nAX}0${nAY}]}" ]]
		then
			aPriority=$( echo "${nextHits[${nAX}0${nAY}]}" | cut -d "|" -f 3 )
			nextHits[${nAX}0${nAY}]="${hX}|${hY}|$(( p + aPriority ))|${aPID}"
			if [[ ${nextHitsMax} -lt $(( p + aPriority )) ]]; then nextHitsMax=$(( p + aPriority )); fi
		else
			nextHits[${nAX}0${nAY}]="${hX}|${hY}|${p}|${aPID}"
			if [[ ${nextHitsMax} -lt ${p} ]]; then nextHitsMax=${p}; fi
		fi
		debug "INSERT: ${hX}, ${hY}, ${p}"
		return
	fi
	if [[ "${action}" == "g" ]]
	then
		echo "${field[$((hX+100))0$((hY+100))]}" | cut -d "|" -f 3 | tr -d " "
	fi
}

function thinking {
	
	nHX=""
	nHY=""
	unset nextHits
	declare -a nextHits
	nextHitsMax=0

	for line in "${field[@]}"
	do
		aX=$( echo "${line}" | cut -d "|" -f 1 )
		aY=$( echo "${line}" | cut -d "|" -f 2 )
		aPID=$( echo "${line}" | cut -d "|" -f 3 )
		doneFields[0]=$( echo "${line}" | cut -d "|" -f 4 )
		doneFields[1]=$( echo "${line}" | cut -d "|" -f 5 )
		doneFields[2]=$( echo "${line}" | cut -d "|" -f 6 )
		doneFields[3]=$( echo "${line}" | cut -d "|" -f 7 )
		self=0
		for t in 0 1 2 3
		do
			if [[ "${doneFields[${t}]}" != "1" ]]
			then
				check=0
				hG1=$( hit "g" "1" "${t}" )
				hG2=$( hit "g" "2" "${t}" )
				hG3=$( hit "g" "3" "${t}" )
				hG4=$( hit "g" "4" "${t}" )
				hGN1=$( hit "g" "-1" "${t}" )
				hGN2=$( hit "g" "-2" "${t}" )
				hGN3=$( hit "g" "-3" "${t}" )
				hGN4=$( hit "g" "-4" "${t}" )
				checkDoneSquares
				if [[ "${check}" -eq 2 ]]
				then
					doneFields[${t}]="1"
				else
					threatHard
				fi
			fi
		done
		field[$((aX+100))0$((aY+100))]="${aX}|${aY}|${aPID}|${doneFields[0]}|${doneFields[1]}|${doneFields[2]}|${doneFields[3]}"
	done

	cleanInvalidNextHits
	debug "########## Hard - prehled, ze kteryho vybiram:"
	for i in "${nextHits[@]}"; do debug "${i}"; done
	debug "########## Hard - Konec prehledu"
	chooseTheBest

	if [[ -n "${nHX}" || -n "${nHY}" ]] # if I found coordinates for next hit, return back and send hit
	then
		return
	fi

	for line in "${field[@]}"
	do
		aX=$( echo "${line}" | cut -d "|" -f 1 )
		aY=$( echo "${line}" | cut -d "|" -f 2 )
		aPID=$( echo "${line}" | cut -d "|" -f 3 )
		doneFields[0]=$( echo "${line}" | cut -d "|" -f 4 )
		doneFields[1]=$( echo "${line}" | cut -d "|" -f 5 )
		doneFields[2]=$( echo "${line}" | cut -d "|" -f 6 )
		doneFields[3]=$( echo "${line}" | cut -d "|" -f 7 )
		self=0
		for t in 0 1 2 3
		do
			if [[ "${doneFields[${t}]}" != "1" ]]
			then
				hG1=$( hit "g" "1" "${t}" )
				hG2=$( hit "g" "2" "${t}" )
				hG3=$( hit "g" "3" "${t}" )
				hGN1=$( hit "g" "-1" "${t}" )
				hGN2=$( hit "g" "-2" "${t}" )
				hGN3=$( hit "g" "-3" "${t}" )
				hGN4=$( hit "g" "-4" "${t}" )
				threatSoft
			fi
		done
	done
	
	cleanInvalidNextHits
	debug "########## Soft - prehled, ze kteryho vybiram:"
	for i in "${nextHits[@]}"; do debug "${i}"; done
	debug "########## Soft - Konec prehledu"
	
	self=1
	for line in "${nextHits[@]}"
	do
		if [[ -z "${line}" ]]; then continue; fi
		aX=$( echo "${line}" | cut -d "|" -f 1 )
		aY=$( echo "${line}" | cut -d "|" -f 2 )
		aPID=$( echo "${line}" | cut -d "|" -f 4 )
		for t in 0 1 2 3
		do
			hG1=$( hit "g" "1" "${t}" )
			hG2=$( hit "g" "2" "${t}" )
			hG3=$( hit "g" "3" "${t}" )
			hG4=$( hit "g" "4" "${t}" )
			hGN1=$( hit "g" "-1" "${t}" )
			hGN2=$( hit "g" "-2" "${t}" )
			hGN3=$( hit "g" "-3" "${t}" )
			hGN4=$( hit "g" "-4" "${t}" )
			threatHard
		done
	done
	
	cleanInvalidNextHits
	debug "########## Soft + Hard - prehled, ze kteryho vybiram:"
	for i in "${nextHits[@]}"; do debug "${i}"; done
	debug "########## Soft + Hard - Konec prehledu"
	chooseTheBest
	
	###first few hits:
	
	if [[ -n "${nHX}" || -n "${nHY}" ]] # if I found coordinates for next hit, return back and send hit
	then
		return
	fi
	
	if [[ ${#field[@]} -eq 0 ]]
	then
		# Start position if I start
		nHX=$(( ( $RANDOM % 20 ) - 10 ))
		nHY=$(( ( $RANDOM % 14 ) - 7 ))
		#nHX=0
		#nHY=0
		mySleep
	elif [[ ${#field[@]} -eq 1 ]]
	then
		for line in "${field[@]}"
		do
			aX=$( echo "${line}" | cut -d "|" -f 1 )
			aY=$( echo "${line}" | cut -d "|" -f 2 )
			r=$(( RANDOM % 8 ))
			if [[ "${r}" -eq 0 ]]; then nHX=$(( aX + 1 )); nHY="${aY}"; fi
			if [[ "${r}" -eq 1 ]]; then nHX=$(( aX - 1 )); nHY="${aY}"; fi
			if [[ "${r}" -eq 2 ]]; then nHX="${aX}"; nHY=$(( aY + 1 )); fi
			if [[ "${r}" -eq 3 ]]; then nHX="${aX}"; nHY=$(( aY - 1 )); fi
			if [[ "${r}" -eq 4 ]]; then nHX=$(( aX + 1 )); nHY=$(( aY + 1 )); fi
			if [[ "${r}" -eq 5 ]]; then nHX=$(( aX + 1 )); nHY=$(( aY - 1 )); fi
			if [[ "${r}" -eq 6 ]]; then nHX=$(( aX - 1 )); nHY=$(( aY + 1 )); fi
			if [[ "${r}" -eq 7 ]]; then nHX=$(( aX - 1 )); nHY=$(( aY - 1 )); fi
		done
		mySleep
	else
		self=0
		unset nextHits
		declare -a nextHits
		nextHitsMax=0
		for line in "${field[@]}"
		do
			aX=$( echo "${line}" | cut -d "|" -f 1 )
			aY=$( echo "${line}" | cut -d "|" -f 2 )
			pID=$( echo "${line}" | cut -d "|" -f 3 )
			if [[ "${pID}" == "${uID}" ]]
			then
				doneFields[0]=$( echo "${line}" | cut -d "|" -f 4 )
				doneFields[1]=$( echo "${line}" | cut -d "|" -f 5 )
				doneFields[2]=$( echo "${line}" | cut -d "|" -f 6 )
				doneFields[3]=$( echo "${line}" | cut -d "|" -f 7 )
				for t in 0 1 2 3
				do
					if [[ "${doneFields[${t}]}" != "1" ]]
					then
						hG1=$( hit "g" "1" "${t}" )
						hG2=$( hit "g" "2" "${t}" )
						hG3=$( hit "g" "3" "${t}" )
						hGN1=$( hit "g" "-1" "${t}" )
						hGN2=$( hit "g" "-2" "${t}" )
						hGN3=$( hit "g" "-3" "${t}" )
						firstFewHits
					fi
				done
			fi
		done
		cleanInvalidNextHits
		debug "########## Moznosti mimo:"
		for i in "${nextHits[@]}"; do debug "${i}"; done
		debug "########## Konec moznosti mimo"
		chooseTheBest
	fi
	if [[ -n "${nHX}" || -n "${nHY}" ]] # if I found coordinates for next hit, return back and send hit
	then
		return
	fi
	nHX=$(( ( $RANDOM % 20 ) - 10 ))
	nHY=$(( ( $RANDOM % 14 ) - 7 ))
}

function threatHard {
	selfHit=0
	if [[ "${hGN1}" == "${aPID}" && "${hG1}" == "${aPID}" ]]
	then
		selfHit=$(( selfHit + 1 )) ## debug "${t}.11"
		if [[ -z "${hG2}" && "${hG3}" == "${aPID}" ]]; then debug "${t}.1"
			if [[ "${aPID}" == "${uID}" ]]
			then
				hit "i" "2" "${t}" "50000"
			else
				hit "i" "2" "${t}" "10000"
			fi
		fi
		if [[ -z "${hGN2}" && "${hGN3}" == "${aPID}" ]]; then debug "${t}.2"
			if [[ "${aPID}" == "${uID}" ]]
			then
				hit "i" "-2" "${t}" "50000"
			else
				hit "i" "-2" "${t}" "10000"
			fi
		fi
		if [[ "${hG2}" == "${aPID}" ]]
		then
			if [[ -z "${hGN2}" && -z "${hG3}" ]]; then debug "${t}.3"
				if [[ "${aPID}" == "${uID}" ]]
				then
					hit "i" "-2" "${t}" "50000"
					hit "i" "3" "${t}" "50000"
				fi
			fi
			if [[ -z "${hG3}" && ( -n "${hGN2}" && "${hGN2}" != "${aPID}" ) ]]; then debug "${t}.5"
				if [[ "${aPID}" == "${uID}" ]]
				then
					hit "i" "3" "${t}" "50000"
				else
					hit "i" "3" "${t}" "10000"
				fi
			fi
			if [[ -z "${hGN2}" && ( -n "${hG3}" && "${hG3}" != "${aPID}" ) ]]; then debug "${t}.6"
				if [[ "${aPID}" == "${uID}" ]]
				then
					hit "i" "-2" "${t}" "50000"
				else
					hit "i" "-2" "${t}" "10000"
				fi
			fi
		fi
		if [[ -z "${hG2}" && -z "${hGN2}" ]]; then debug "${t}.11"
			if [[ "${aPID}" == "${uID}" ]]
			then
				if [[ -z "${hG3}" ]]
				then
					hit "i" "2" "${t}" "2000"
				else
					hit "i" "2" "${t}" "1970"
				fi
				if [[ -z "${hGN3}" ]]
				then
					hit "i" "-2" "${t}" "2000"
				else
					hit "i" "-2" "${t}" "1970"
				fi
			else
				if [[ -z "${hG3}" ]]
				then
					hit "i" "2" "${t}" "1000"
				else
					hit "i" "2" "${t}" "970"
				fi
				if [[ -z "${hGN3}" ]]
				then
					hit "i" "-2" "${t}" "1000"
				else
					hit "i" "-2" "${t}" "970"
				fi
			fi
		fi
	fi
	if [[ "${hGN1}" == "${aPID}" ]]
	then
		if [[ -z "${hG1}" && "${hG2}" == "${aPID}" ]]
		then
			selfHit=$(( selfHit + 1 )) # debug "${t}.15"
			if [[ "${hG3}" == "${aPID}" ]]; then debug "${t}.10"
				if [[ "${aPID}" == "${uID}" ]]
				then
					hit "i" "1" "${t}" "50000"
				else
					hit "i" "1" "${t}" "10000"
				fi
			fi
			if [[ -z "${hGN2}" && -z "${hG3}" ]]; then debug "${t}.15"
				if [[ "${aPID}" == "${uID}" ]]
				then
					hit "i" "-2" "${t}" "350"
					hit "i" "3" "${t}" "300"
					hit "i" "1" "${t}" "2000"
				else
					hit "i" "-2" "${t}" "450"
					hit "i" "3" "${t}" "400"
					hit "i" "1" "${t}" "1000"
				fi
			fi
		fi
		if [[ -z "${hGN2}" && "${hGN3}" == "${aPID}" ]]
		then
			selfHit=$(( selfHit + 1 )) # debug "${t}.19"
			if [[ -z "${hG1}" && -z "${hGN4}" ]]; then debug "${t}.19"
				if [[ "${aPID}" == "${uID}" ]]
				then
					hit "i" "-2" "${t}" "2000"
					hit "i" "-4" "${t}" "300"
					hit "i" "1" "${t}" "350"
				else
					hit "i" "-2" "${t}" "1000"
					hit "i" "-4" "${t}" "400"
					hit "i" "1" "${t}" "450"
				fi
			fi
		fi
	fi


	if [[ "${self}" -eq 1 ]]
	then
		if [[ "${hG1}" == "${aPID}" ]]
		then
			if [[ "${hG2}" == "${aPID}" ]]; then debug "${t}.11.s.1"
				selfHit=$(( selfHit + 1 ))
			fi
			if [[ -z "${hG2}" && "${hG3}" == "${aPID}" ]]; then debug "${t}.15.s.1"
				selfHit=$(( selfHit + 1 ))
			fi
			if [[ -z "${hGN1}" && "${hGN2}" == "${aPID}" ]]; then debug "${t}.19.s.2"
				selfHit=$(( selfHit + 1 ))
			fi
		fi
		if [[ -z "${hG1}" && "${hG2}" == "${aPID}" && "${hG3}" == "${aPID}" ]]; then debug "${t}.19.s.1"
			selfHit=$(( selfHit + 1 ))
		fi
		if [[ -z "${hGN1}" && "${hGN2}" == "${aPID}" && "${hGN3}" == "${aPID}" ]]; then debug "${t}.15.s.2"
			selfHit=$(( selfHit + 1 ))
		fi
		if [[ "${hGN1}" == "${aPID}" && "${hGN2}" == "${aPID}" ]]; then debug "${t}.11.s.2"
			selfHit=$(( selfHit + 1 ))
		fi
		selfHit=$(( selfHit * 1000 ))
		if [[ "${selfHit}" -gt 0 ]]
		then
			nAX=$((aX+100))
			nAY=$((aY+100))
			if [[ -n "${nextHits[${nAX}0${nAY}]}" ]]
			then
				aPriority=$( echo "${nextHits[${nAX}0${nAY}]}" | cut -d "|" -f 3 )
				nextHits[${nAX}0${nAY}]="${aX}|${aY}|$(( selfHit + aPriority ))|${aPID}"
				if [[ ${nextHitsMax} -lt $(( selfHit + aPriority )) ]]; then nextHitsMax=$(( selfHit + aPriority )); fi
			else
				nextHits[${nAX}0${nAY}]="${aX}|${aY}|${selfHit}|${aPID}"
				if [[ ${nextHitsMax} -lt ${selfHit} ]]; then nextHitsMax=${selfHit}; fi
			fi
		fi
	fi
}

function threatSoft {
	if [[ "${hGN1}" == "${aPID}" && "${hG1}" == "${aPID}" ]]
	then
		if [[ -z "${hG2}" && -z "${hG3}" && ( -n "${hGN2}" && "${hGN2}" != "${aPID}" ) ]]; then debug "${t}.12"
			if [[ "${aPID}" == "${uID}" ]]
			then
				hit "i" "2" "${t}" "35"
				hit "i" "3" "${t}" "35"
			else
				hit "i" "2" "${t}" "300"
				hit "i" "3" "${t}" "300"
			fi
		fi
		if [[ -z "${hGN2}" && -z "${hGN3}" && ( -n "${hG2}" && "${hG2}" != "${aPID}" ) ]]; then debug "${t}.13"
			if [[ "${aPID}" == "${uID}" ]]
			then
				hit "i" "-2" "${t}" "35"
				hit "i" "-3" "${t}" "35"
			else
				hit "i" "-2" "${t}" "300"
				hit "i" "-3" "${t}" "300"
			fi
		fi
	fi
	if [[ "${hGN1}" == "${aPID}" ]]
	then
		if [[ -z "${hG1}" && "${hG2}" == "${aPID}" ]]
		then
			if [[ -z "${hG3}" && ( -n "${hGN2}" && "${hGN2}" != "${aPID}" ) ]]; then debug "${t}.16"
				if [[ "${aPID}" == "${uID}" ]]
				then
					hit "i" "3" "${t}" "300"
					hit "i" "1" "${t}" "150"
				else
					hit "i" "3" "${t}" "400"
					hit "i" "1" "${t}" "250"
				fi
			fi
			if [[ -z "${hGN2}" && ( -n "${hG3}" && "${hG3}" != "${aPID}" ) ]]; then debug "${t}.17"
				if [[ "${aPID}" == "${uID}" ]]
				then
					hit "i" "-2" "${t}" "350"
					hit "i" "1" "${t}" "250"
				else
					hit "i" "-2" "${t}" "450"
					hit "i" "1" "${t}" "350"
				fi
			fi
		fi
		if [[ -z "${hG1}" && -z "${hG2}" && "${hG3}" == "${aPID}" ]]; then debug "${t}.27"
			if [[ "${aPID}" == "${uID}" ]]
			then
				hit "i" "1" "${t}" "100"
				hit "i" "2" "${t}" "100"
			else
				hit "i" "1" "${t}" "80"
				hit "i" "2" "${t}" "80"
			fi
		fi
		if [[ -z "${hGN2}" ]]
		then
			if [[ -z "${hG1}" ]]; then debug "${t}.23"
				if [[ "${aPID}" == "${uID}" ]]
				then
					if [[ -z "${hG2}" ]]
					then
						hit "i" "1" "${t}" "50"
					else
						hit "i" "1" "${t}" "47"
					fi
					if [[ -z "${hGN3}" ]]
					then
						hit "i" "-2" "${t}" "50"
					else
						hit "i" "-2" "${t}" "47"
					fi
				else
					if [[ -z "${hG2}" ]]
					then
						hit "i" "1" "${t}" "40"
					else
						hit "i" "1" "${t}" "37"
					fi
					if [[ -z "${hGN3}" ]]
					then
						hit "i" "-2" "${t}" "40"
					else
						hit "i" "-2" "${t}" "37"
					fi
				fi
			fi
			if [[ "${hGN3}" == "${aPID}" ]]
			then
				if [[ -z "${hGN4}" && ( -n "${hG1}" && "${hG1}" != "${aPID}" ) ]]; then debug "${t}.20"
					if [[ "${aPID}" == "${uID}" ]]
					then
						hit "i" "-2" "${t}" "150"
						hit "i" "-4" "${t}" "300"
					else
						hit "i" "-2" "${t}" "250"
						hit "i" "-4" "${t}" "400"
					fi
				fi
				if [[ -z "${hG1}" && ( -n "${hGN4}" && "${hGN4}" != "${aPID}" ) ]]; then debug "${t}.21"
					if [[ "${aPID}" == "${uID}" ]]
					then
						hit "i" "-2" "${t}" "250"
						hit "i" "1" "${t}" "350"
					else
						hit "i" "-2" "${t}" "350"
						hit "i" "1" "${t}" "450"
					fi
				fi
			fi
		fi
	fi
	if [[ -z "${hGN1}" && "${hGN2}" == "${aPID}" && -z "${hGN3}" && -z "${hG1}" ]]; then debug "${t}.25"
		hit "i" "-1" "${t}" "50"
		hit "i" "-3" "${t}" "40"
		hit "i" "1" "${t}" "40"
	fi
}
