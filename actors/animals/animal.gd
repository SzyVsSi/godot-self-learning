extends CharacterBody3D
class_name Animal


const ANIM_BLEND := 0.2


var player_in_vision_range := false


@export var hittable_object_attributes: HittableObjectAttributes
@export var running_speed := 1.7
@export var idle_animations: Array[String] = []
@export var hurt_animations: Array[String] = []
@export var turn_speed_weight := 0.07
@export var is_aggressive := false
@export var attack_distance := 2.0
@export var damage := 20.0
@export var vision_range := 15.0
@export var vision_fov := 80.0


@onready var state_machine: Node = $StateMachine


@onready var attack_hit_area: Area3D = $AttackHitArea
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var main_collision_shape: CollisionShape3D = $CollisionShape3D
@onready var meat_spawn_marker: Marker3D = $MeatSpawnMarker
@onready var eyes_marker: Marker3D = $EyesMarker
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var health := hittable_object_attributes.max_health
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var vision_area_collision_shape: CollisionShape3D = $VisionArea/CollisionShape3D


func _ready() -> void:
	vision_area_collision_shape.shape.radius = vision_range


func play_animal_animation(animation_name: String) -> void:
	animation_player.play(animation_name, ANIM_BLEND)


func attack() -> void:
	if player in attack_hit_area.get_overlapping_bodies():
		EventSystem.PLA_change_health.emit(-damage)


func look_forward() -> void:
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z) + PI, turn_speed_weight)


func take_hit(weapon_item_resource: WeaponItemResource) -> void:
	if hittable_object_attributes.weapon_filter.has(weapon_item_resource.item_key):
		health -= weapon_item_resource.damage

		if state_machine.state not in [AnimalState.DEAD, AnimalState.HURT]:
			if health <= 0:
				state_machine.transition_to_next_state(AnimalState.DEAD)
				return
			state_machine.transition_to_next_state(AnimalState.HURT)


func can_see_player() -> bool:
	return player_in_vision_range and player_in_fov() and player_in_los()


func player_in_fov() -> bool:
	if not is_instance_valid(player):
		return false
	
	var direction_to_player := global_position.direction_to(player.global_position)
	var forward := -global_transform.basis.z
	return direction_to_player.angle_to(forward) <= deg_to_rad(vision_fov)


func player_in_los() -> bool:
	if not player:
		return false

	var query_params := PhysicsRayQueryParameters3D.new()
	query_params.from = eyes_marker.global_position
	query_params.to = player.head.global_position
	query_params.collision_mask = 1 + 64
	var space_state := get_world_3d().direct_space_state
	var result := space_state.intersect_ray(query_params)

	return result.is_empty()


func _on_vision_area_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_vision_range = true


func _on_vision_area_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_vision_range = false