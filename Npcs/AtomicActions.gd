class_name Action
extends Resource

'''
The standard actions in game all Behaviour Nodes reference. These scripts handle the actual implementation of chosen behaviours.
'''


func set_target(npc: NPC, team_state: TeamState):
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
		npc.set_destination(npc.target.global_position)
		return "SUCCESS"
	else:
		return "FAILURE"
		
func move_to_target(npc: NPC, team_state: TeamState):
	if npc.get_children()[3].distance_to_target() > npc.basic_attack.range:
		return "RUNNING"
	else:
		return "SUCCESS"
	
func move_to_destination(npc: NPC, team_state: TeamState):
	# moves to current target, will loop until target is reached or becomes unreachable.
	if not npc.get_children()[3].is_navigation_finished():
		# print(npc.get_children()[3].distance_to_target())
		# print("Navigation running from {current} to {destination}".format({"current": npc.global_position, "destination": npc.get_child(3).target_position}))
		return "RUNNING"
	elif npc.get_children()[3].is_navigation_finished():
		print("Navigation Finished")
		return "SUCCESS"
	else:
		print("Navigation Failed")		
		return "FAILURE"
	
func take_potion(npc: NPC, team_state: TeamState):
	npc.healing_potions -= 1
	npc.current_health = npc.max_health
	return "SUCCESS"	

func leave_building(npc: NPC, team_state: TeamState):
	return
func equip_item(npc: NPC, team_state: TeamState):
	return
func sell_item(npc: NPC, team_state: TeamState):
	return
func buy_item(npc: NPC, team_state: TeamState):
	if npc.state != "acquire_upgrades":
		for equipment in npc.desired_equipment:
			if npc.desired_equipment[equipment] != null:
				if npc.desired_equipment[equipment].value < npc.gold:
					for building in team_state.available_items:
						for item in team_state.available_items[building]:
							if item == npc.desired_equipment[equipment]:	
								npc.set_destination(building.global_position)
								npc.target_building = building
								npc.state = "acquire_upgrades"
								npc.purchase_goal = npc.desired_equipment[equipment]
								return "RUNNING"
	elif npc.get_children()[3].distance_to_target() < 10:
		npc.enterBuilding(npc.target_building)
		npc.target_building.services["Item Seller"].sell_item(npc, npc.purchase_goal)
		for slot in npc.desired_equipment:
			if npc.desired_equipment[slot] == npc.purchase_goal:
				npc.current_equipment[slot] = npc.inventory[-1]				
				npc.desired_equipment[slot] = null
				npc.equipmentHandler.equipment_change.emit()
		npc.purchase_goal = null
		npc.state = "idle"
		npc.leaveBuilding(npc.target_building)
		npc.target_building = null
		return "SUCCESS"
	else:
		return "RUNNING"
	return
func use_ability(npc: NPC, team_state: TeamState):
	return
func use_item(npc: NPC, team_state: TeamState):
	return
func enter_building(npc: NPC, team_state: TeamState):
	return
func idle(npc: NPC, team_state: TeamState):
	return	
func go_home(npc: NPC, team_state: TeamState):
	return
func set_exploration_destination(npc: NPC, team_state: TeamState):
	npc.state = "explore"
	# Sets our Destination based on fog of war collision or picks a random adjustment.
	var npc_raycast = npc.get_child(0)
	var count = 0
	# Enemy NPCs don't care about the fog of war. 
	while count <= 4 and npc.team != "enemy":
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
				return "SUCCESS"
				
		else:
			npc.basis = npc.basis.rotated(Vector3(0,1,0), 90)
			count +=1
	# Failed to collide with anything after rotating 4 times. 		
	npc.set_destination(npc.global_position + Vector3(randi_range(-10, 10), 0, randi_range(-10, 10)))
	return "SUCCESS"

func distance(npc: NPC, team_state: TeamState):
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
