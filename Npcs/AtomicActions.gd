class_name Action
extends Resource

'''
The standard actions in game all Behaviour Nodes reference. These scripts handle the actual implementation of chosen behaviours.
'''


func set_target(npc: NPC, team_state: KingdomState):
	var best_distance = 10000
	var best_enemy = null
	for enemy in npc.brain.enemies_in_range:
		if is_instance_valid(enemy):
			npc.target = enemy
			var distance = distance(npc, team_state)
			if distance < best_distance:
				best_enemy = enemy
	if is_instance_valid(best_enemy):
		best_enemy.death_signal.connect(npc._handle_target_death)
		npc.target = best_enemy
	if is_instance_valid(npc.target):
		return "SUCCESS"
	else:
		return "FAILURE"
		
func attack_target(npc: NPC, team_state: KingdomState):
	var damage = Damage.calculateDamage(npc, npc.target)
	npc.target.current_health -= damage
	return
	
func move_to_target(npc: NPC, team_state: KingdomState):
	var counter = 0
	var distance = 9999999
	while npc.basic_attack.range < distance:
		await npc.get_tree().create_timer(1).timeout
		if npc.target != null:
			counter += 1
			distance = distance(npc, team_state)			
			if counter > 10:
				return "FAILURE"
		else:
			return "FAILURE"
	return "SUCCESS"
	
func leave_building(npc: NPC, team_state: KingdomState):
	return
func equip_item(npc: NPC, team_state: KingdomState):
	return
func sell_item(npc: NPC, team_state: KingdomState):
	return
func buy_item(npc: NPC, team_state: KingdomState):
	return
func use_ability(npc: NPC, team_state: KingdomState):
	return
func use_item(npc: NPC, team_state: KingdomState):
	return
func enter_building(npc: NPC, team_state: KingdomState):
	return
func idle(npc: NPC, team_state: KingdomState):
	return	
func go_home(npc: NPC, team_state: KingdomState):
	return
func explore(npc: NPC, team_state: KingdomState):
	var npc_raycast = npc.get_child(0)
	
	var count = 0
	while count < 4:
		if npc_raycast.is_colliding():
			var collision = npc_raycast.get_collision_point()
			var body = npc_raycast.get_collider().get_parent()
			# Only perform alignment when hit with terrain?
			# Could apply to other scenarios
			
			if (body.name == "Fog"):
				# Get the normal right below us 
				var n = npc_raycast.get_collision_normal()
				# Transform and interpolate with current orientation
				var xform = npc.global_transform
				xform.basis.x = n
				xform.basis.z = -xform.basis.y.cross(n)
				xform.basis = xform.basis.orthonormalized()
				npc.global_transform = npc.global_transform.interpolate_with(xform, 0.2)
				npc.set_destination(collision)
				var counter = 0
				while not npc.get_children()[3].is_target_reached():
					await npc.get_tree().create_timer(1).timeout
					counter += 1
					if counter > 10:
						return "FAILURE"
				return "SUCCESS"
			else:
				npc.basis = npc.basis.rotated(Vector3(0,1,0), 90)
				count +=1
		else:
			npc.basis = npc.basis.rotated(Vector3(0,1,0), 90)
			count +=1
			
	npc.set_destination(npc.global_position + Vector3(randi_range(-20, 20), 0, randi_range(-20, 20)))
	var counter = 0
	while not npc.get_children()[3].is_target_reached():
		await npc.get_tree().create_timer(1).timeout
		if not is_instance_valid(npc):
			return "FAILURE"
		counter += 1
		if counter > 10:
			return "FAILURE"
	return "SUCCESS"
	
func distance(npc: NPC, team_state: KingdomState):
	var enemy_npc = npc.target
	var enemy_pos = enemy_npc.global_position
	var enemy_x = enemy_pos.x
	var enemy_y = enemy_pos.y
	var enemy_z = enemy_pos.z
	var npc_pos = npc.global_position
	var npc_x = npc_pos.x
	var npc_y = npc_pos.y
	var npc_z = npc_pos.z
	
	var distance = sqrt(pow((enemy_x - npc_x), 2) + pow((enemy_y - npc_y), 2) + pow((enemy_z - npc_z), 2)) 
	return distance
