extends RefCounted


static func resolve_attack(
	attack_bonus: int,
	target_ac: int
) -> Dictionary:
	var dice_roll: int = randi_range(
		1,
		20
	)
	
	var attack_total: int = (
		dice_roll
		+ attack_bonus
	)
	
	var hit: bool = false
	var critical_hit: bool = false
	
	if dice_roll == 20:
		hit = true
		critical_hit = true
	elif (
		dice_roll != 1
		and attack_total >= target_ac
	):
		hit = true
	
	return {
		"dice_roll": dice_roll,
		"attack_bonus": attack_bonus,
		"attack_total": attack_total,
		"target_ac": target_ac,
		"hit": hit,
		"critical_hit": critical_hit
	}
