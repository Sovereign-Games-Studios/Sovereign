class_name Comparisons
extends Node


static func calculate_enemy_strength(npc: NPC, enemy_npc: Node3D, kingdom_state:TeamState):
	var value = 0
	var npc_knowledge = npc.brain
	# var enemy_npc = npc.target
	
	if enemy_npc is NPC and npc.definition.character_type == "Hero":
		# The way we calculate this means that units with a very high bravery essentially won't flee monsters despite low health.	
		if enemy_npc.level > npc.level:
			value -= clamp(5 * ((npc.bravery-npc.personality.cowardice)/100), 0, 100)
		# The way we calculate this means that units with a very high bravery essentially won't flee monsters despite low health.
		if enemy_npc.current_health > npc.current_health:		
			value -= clamp((5 * ((npc.personality.cowardice - npc.personality.bravery)/100)), 0, 100)
		# If an enemy npc is near death, go for the killing blow.
		if enemy_npc.current_health / enemy_npc.max_health < .2:
			value += 10
	else:
		value = 0
	
	for enemy in npc_knowledge.enemies_in_range:
		# The way we calculate this means that units with a very high bravery essentially won't flee monsters despite low health.	
		if enemy.level > npc.level:
			value -= clamp(5 * ((npc.bravery-npc.personality.cowardice)/100), 0, 100)
		else:
			value += clamp(5 * ((npc.bravery-npc.personality.cowardice)/100), 0, 100)
		# The way we calculate this means that units with a very high bravery essentially won't flee monsters despite low health.
		if enemy.current_health > npc.current_health:		
			value -= clamp((5 * ((npc.personality.cowardice - npc.personality.bravery)/100)), 0, 100)
		else:
			value += clamp((5 * ((npc.personality.cowardice - npc.personality.bravery)/100)), 0, 100)
		# If an enemy npc is near death, go for the killing blow.
		if enemy.current_health / enemy.max_health < .2:
			value += 10
		# We are thoroughly outclassed by the enemy.
		if npc.attributes.attribute_dict[npc.attributes.primary_stat] < enemy.attribute_dict[npc.attributes.primary_stat]:
			value -= clamp(10 * ((npc.bravery-npc.personality.cowardice)/100), 0, 100)
		else:
			value += clamp(5 * ((npc.bravery-npc.personality.cowardice)/100), 0, 100)
	
	
	for ally in npc_knowledge.allies_in_range:
		# The way we calculate this means that units with a very high bravery essentially won't flee monsters despite low health.	
		if ally.level > npc.level:
			value += clamp(5 * ((npc.bravery-npc.personality.cowardice)/100), 0, 100)
		else:
			value += clamp(1 * ((npc.bravery-npc.personality.cowardice)/100), 0, 100)
		# The way we calculate this means that units with a very high bravery essentially won't flee monsters despite low health.
		if ally.current_health > npc.current_health:		
			value += clamp((5 * ((npc.personality.cowardice - npc.personality.bravery)/100)), 0, 100)
		else:
			value += clamp((1 * ((npc.personality.cowardice - npc.personality.bravery)/100)), 0, 100)
		# If an ally npc is near death, get spooked.
		if ally.current_health / enemy_npc.max_health < .2:
			value -= 5
		
		# If an ally npc is a spellcaster, and we are smart, we should acknowledge the power advantage.
		if ally.definition.character_type == "Wizard" && npc.attributes.intelligence > 15:
			value += 5
		
	return clamp(value, 0, 100)
	
static func best_target_in_range(npc: NPC, kingdom_state: TeamState):
	var npc_knowledge = npc.brain
	var best_enemy_value = 0
	var best_enemy
	for enemy in kingdom_state.observed_enemies.keys():
		if not best_enemy:
			best_enemy = kingdom_state.observed_enemies.keys()[0] 
		var value = 0	
		# The way we calculate this means that units with a very high bravery essentially won't flee monsters despite low health.	
		if enemy.level > npc.level:
			value -= clamp(5 * ((npc.bravery-npc.personality.cowardice)/100), 0, 100)
		else:
			value += clamp(5 * ((npc.bravery-npc.personality.cowardice)/100), 0, 100)
		# The way we calculate this means that units with a very high bravery essentially won't flee monsters despite low health.
		if enemy.current_health > npc.current_health:		
			value -= clamp((5 * ((npc.personality.cowardice - npc.personality.bravery)/100)), 0, 100)
		else:
			value += clamp((5 * ((npc.personality.cowardice - npc.personality.bravery)/100)), 0, 100)
		# If an enemy npc is near death, go for the killing blow.
		if enemy.current_health / enemy.max_health < .2:
			value += 10
		# We are thoroughly outclassed by the enemy.
		if enemy is NPC:
			if npc.attributes.attribute_dict[npc.attributes.primary_stat] < enemy.attributes.attribute_dict[npc.attributes.primary_stat]:
				value -= clamp(10 * ((npc.bravery-npc.personality.cowardice)/100), 0, 100)
			else:
				value += clamp(5 * ((npc.bravery-npc.personality.cowardice)/100), 0, 100)
		# Every 100 gold is worth 1 value, with greed modifying that. 
		value += clamp(.01 * enemy.reward_flag.value * npc.personality.greed, 0, 100)
		
		# final clamp
		value = clamp(value, 0, 100)
		
		if value > best_enemy_value:
			best_enemy_value = value
			best_enemy = enemy
		elif value == best_enemy_value:
			var current_distance = npc.transform.origin.distance_squared_to(best_enemy.global_transform.origin)
			var other_distance = npc.transform.origin.distance_squared_to(enemy.global_transform.origin)
			if current_distance > other_distance:
				best_enemy_value = value
				best_enemy = enemy
				
	# No enemies in range? Do we at least know of an enemy?
	if best_enemy == null and kingdom_state.combat_reward_flags.size() > 0:
		var best_bounty = 0
		best_enemy = kingdom_state.combat_reward_flags[0]
		for flag_target in kingdom_state.combat_reward_flags:
			# Money is a powerful motivator, 100 gold = 1 value but greed can change this.
			var flag_val = flag_target.reward_flag.value  * .01 * npc.personality.greed
			# Likewise, very strong opponents require more motivation
			var combat_val = Comparisons.calculate_enemy_strength(npc, flag_target, kingdom_state) * npc.personality.cowardice
			
			var total_val = clamp((flag_val - combat_val), 0, 100)
			
			if total_val > best_bounty:
				best_bounty = total_val
				best_enemy = flag_target
		
	return best_enemy



