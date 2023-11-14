extends Node3D

var errors = []

func check_letter_correct(letter:Letter) -> bool:
	errors.clear()
	if Global.game_day >= 1:
		#Day 1 rules
		if not letter.has_stamp:
			errors.append("Missing stamp")
		if not letter.has_destination:
			errors.append("No Destination")
		if not letter.destination_universe == letter.sorted_bin_location:
			errors.append("Sorted into wrong bin")
	
	if Global.game_day >= 2:
		if not letter.has_seal and letter.origin_universe == NameList.universe.MAGIC:
			errors.append("Missing seal")
	
	#If there are no errors, check if it was stamped Approved
	if not errors:
		if not letter.is_approved:
			errors.append("Stamped Return to Sender Incorrectly")
	else:
		#If there are errors, but was not stamped RTS
		if not letter.is_returned:
			errors.append("Stamped Approved Incorrectly")
		#If there are errors and stamped RTS, but placed in wrong bin.
		elif not letter.sorted_bin_location == -1:
			errors.append("Sorted into wrong bin")
		else:
			#If there are errors, but stamped RTS and placed in RTS bin correctly
			return true
	
	print(errors)
	if errors:
		return false
	else:
		#No errors, Sorted Correctly
		return true
