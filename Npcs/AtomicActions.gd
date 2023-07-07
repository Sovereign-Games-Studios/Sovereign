class_name Action
extends Resource

'''
The standard actions in game all Behaviour Nodes reference. These scripts handle the actual implementation of chosen behaviours.
'''


func set_destination(npc: NPC, target: Vector3):
	return
func set_target(npc: NPC, target: Node3D):
	return
func attack_target(attacker: Node3D, defender: Node3D):
	var damage = Damage.calculateDamage(attacker, defender)
	defender.current_health -= damage
	return
func move_to_target(npc: NPC, building: Building):
	return
func leave_building(npc: NPC, building: Building):
	return
func equip_item(npc: NPC, item):
	return
func sell_item(building: Building, item):
	return
func buy_item(building: Building, item):
	return
func use_ability(npc: NPC, target_location: Vector3):
	return
func use_item(npc: NPC, item):
	return
func enter_building(npc: NPC, building: Building):
	return
func idle():
	return	
func go_home():
	return
func explore(npc):
	print("NPC in action:", npc)
	var npc_raycast = npc.get_child(0)
	
	print("Raycast: ", npc_raycast)
	var count = 0
	while count < 4:
		if npc_raycast.is_colliding():
			print("Collided with something: ", npc_raycast.get_collider())			
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
				print("Exploring Fog")
				return "exploring"
			else:
				print("Rotate to find FoW")
				npc.basis = npc.basis.rotated(Vector3(0,1,0), 90)
				count +=1
		else:
			print("Rotate to find FoW")
			npc.basis = npc.basis.rotated(Vector3(0,1,0), 90)
			count +=1
			
	print("Fog Not Found")
	npc.set_destination(npc.global_position + Vector3(randi_range(-20, 20), 0, randi_range(-20, 20)))

func distance(npc: NPC, enemy_npc: Node3D):
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
