extends RefCounted

const COMBAT_ADVANTAGE_ATTACK_BONUS: int = 2


static func are_opposite_adjacent(
	attacker_position: Vector2i,
	ally_position: Vector2i,
	target_position: Vector2i
) -> bool:
	var attacker_offset: Vector2i = attacker_position - target_position
	var ally_offset: Vector2i = ally_position - target_position
	if attacker_offset == Vector2i.ZERO or ally_offset == Vector2i.ZERO:
		return false
	if maxi(absi(attacker_offset.x), absi(attacker_offset.y)) != 1:
		return false
	if maxi(absi(ally_offset.x), absi(ally_offset.y)) != 1:
		return false
	return ally_offset == -attacker_offset
