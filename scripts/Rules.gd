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
	
	if Global.game_day >= 2:
		if not letter.has_seal and letter.origin_universe == NameList.universe.MAGIC:
			errors.append("Missing seal")
	
	#If there are no errors, check if it was stamped Approved
	if not errors:
		if not letter.is_approved:
			errors.append("Stamped Return to Sender Incorrectly")
		if not letter.destination_universe == letter.sorted_bin_location:
			errors.append("Sorted to wrong destination")
	else:
		#If there are errors, but was not stamped RTS
		if not letter.is_returned:
			errors.append("Stamped Approved Incorrectly")
		#If there are errors, stamped RTS, no origin, but not sorted to RTS bin
		elif not letter.has_origin and letter.sorted_bin_location != NameList.universe.RTS:
			errors.append("Not returned to RTS")
		#If there are errors and stamped RTS, has origin but returned to wrong bin.
		elif letter.has_origin and letter.sorted_bin_location != letter.origin_universe:
			errors.append("Returned to wrong origin")
		else:
			#If there are errors, stamped RTS and placed in RTS bin correctly
			print(str("Caught errors: ", errors))
			return true
	
	print(str("\n", errors))
	if errors:
		return false
	else:
		#No errors, Sorted Correctly
		return true


func check_package_correct(package : Package):
	errors.clear()
	
	var stickers = []
	for child in package.get_children():
		if child is Sticker:
			stickers.append(child)
	
	var weight_label_stickers = 0
	var has_destination_sticker = false
	var has_fragile_sticker = false
	var has_expedited_sticker = false
	
	for sticker in stickers:
		if Global.game_day >= 3:
			if sticker.type == Sticker.WEIGHT:
				weight_label_stickers += 1
				if sticker.weight > package.weight + 0.6 or sticker.weight < package.weight - 0.6:
					errors.append("Incorrect weight")
			if sticker.type == Sticker.DESTINATION:
				has_destination_sticker = true
				if sticker.destination != package.destination_universe:
					errors.append("Incorrect destination sticker")
		
		if Global.game_day >= 4:
			if sticker.type == Sticker.FRAGILE:
				has_fragile_sticker = true
				if not package.is_fragile:
					errors.append("Labeled fragile incorrectly")
		if Global.game_day >= 5:
			if sticker.type == Sticker.EXPEDITED:
				has_expedited_sticker = true
				if not package.is_priority_mail:
					errors.append("Labeled expedited incorrectly")
	
	
	if weight_label_stickers > 1:
		errors.append("Too many weight labels")
	if not has_destination_sticker:
		errors.append("Missing destination sticker")
	if package.is_fragile and not has_fragile_sticker:
		errors.append("Missing fragile sticker")
	if package.is_priority_mail and not has_expedited_sticker:
		errors.append("Missing expedited sticker")
	
	print(str("\n", errors))
	if errors:
		return false
	else:
		#No errors, Sorted Correctly
		print("Shipped Correctly")
		return true
