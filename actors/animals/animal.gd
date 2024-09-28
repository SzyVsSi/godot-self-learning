extends CharacterBody3D


const ANIM_BLEND := 0.2


enum States {
	Idle,
	Wander,
	Dead,
	Flee,
	Hurt,
	Chase,
	Attack
}


var state := States.Idle
var player_in_vision_range := false


@export var hittable_object_attributes: HittableObjectAttributes
@export var normal_speed := 0.6
@export var running_speed := 1.7
@export var idle_animations: Array[String] = []
@export var hurt_animations: Array[String] = []
@export var turn_speed_weight := 0.07
@export var min_idle_time := 2.0
@export var max_idle_time := 7.0
@export var min_wander_time := 2.0
@export var max_wander_time := 4.0
@export var fleeing_time := 3.5
@export var is_aggressive := false
@export var attack_distance := 2.0
@export var damage := 20.0
@export var vision_range := 15.0
@export var vision_fov := 80.0


@onready var idle_timer: Timer = %IdleTimer
@onready var wander_timer: Timer = %WanderTimer
@onready var disappear_after_death_timer: Timer = %DisappearAfterDeathTimer
@onready var flee_timer: Timer = %FleeTimer

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
	animation_player.animation_finished.connect(animation_finished)
	vision_area_collision_shape.shape.radius = vision_range


func animation_finished(_anim_name: String) -> void:
	if state == States.Idle:
		animation_player.play(idle_animations.pick_random(), ANIM_BLEND)

	if state == States.Hurt:
		if not is_aggressive:
			set_state(States.Flee)
		else:
			set_state(States.Chase)

	if state == States.Attack:
		set_state(States.Chase)


func _physics_process(_delta: float) -> void:
	match state:
		States.Idle:
			idle_loop()
		States.Wander:
			wander_loop()
		States.Flee:
			flee_loop()
		States.Chase:
			chase_loop()
		States.Attack:
			attack_loop()


func idle_loop() -> void:
	if is_aggressive and can_see_player():
		set_state(States.Chase)


func wander_loop() -> void:
	look_forward()
	move_and_slide()

	if is_aggressive and can_see_player():
		set_state(States.Chase)


func flee_loop() -> void:
	look_forward()
	move_and_slide()


func chase_loop() -> void:
	look_forward()
	if global_position.distance_to(player.global_position) < attack_distance:
		set_state(States.Attack)
		return
	
	nav_agent.target_position = player.global_position
	var dir := global_position.direction_to(nav_agent.get_next_path_position())
	velocity = Vector3(dir.x, 0, dir.z) * running_speed
	move_and_slide()


func attack_loop() -> void:
	var dir := global_position.direction_to(player.global_position)
	rotation.y = lerp_angle(rotation.y, atan2(dir.x, dir.z) + PI, turn_speed_weight)


func attack() -> void:
	if player in attack_hit_area.get_overlapping_bodies():
		EventSystem.PLA_change_health.emit(-damage)


func look_forward() -> void:
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z) + PI, turn_speed_weight)


func pick_wander_velocity() -> void:
	var dir := Vector2.UP.rotated(randf() * TAU)
	velocity = Vector3(dir.x, 0, dir.y) * normal_speed


func pick_velocity_away_from_player() -> void:
	if not is_instance_valid(player):
		set_state(States.Idle)
		return

	var dir := player.global_position.direction_to(global_position)
	velocity = Vector3(dir.x, 0, dir.z) * running_speed


func can_see_player() -> bool:
	return player_in_vision_range and player_in_fov() and player_in_los()


func player_in_fov() -> bool:
	if not player:
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


func _on_idle_timer_timeout() -> void:
	set_state(States.Wander)


func _on_wander_timer_timeout() -> void:
	set_state(States.Idle)


func _on_disappear_after_death_timer_timeout() -> void:
	queue_free()


func _on_flee_timer_timeout() -> void:
	set_state(States.Idle)


func set_state(new_state: States) -> void:
	state = new_state

	match state:
		States.Idle:
			idle_timer.start(randf_range(min_idle_time, max_idle_time))
			animation_player.play(idle_animations.pick_random(), ANIM_BLEND)
		States.Wander:
			pick_wander_velocity()
			wander_timer.start(randf_range(min_wander_time, max_wander_time))
			animation_player.play("Walk", ANIM_BLEND)
		States.Hurt:
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			animation_player.play(hurt_animations.pick_random(), ANIM_BLEND)
		States.Flee:
			pick_velocity_away_from_player()
			animation_player.play("Gallop", ANIM_BLEND)
			flee_timer.start(fleeing_time)
		States.Chase:
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			animation_player.play("Gallop", ANIM_BLEND)
		States.Attack:
			animation_player.play("Attack", ANIM_BLEND)
		States.Dead:
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			main_collision_shape.disabled = true
			animation_player.play("Death", ANIM_BLEND)
			var meat_scene := ItemConfig.get_pickuppable_item(ItemConfig.Keys.RawMeat)
			EventSystem.SPA_spawn_scene.emit(meat_scene, meat_spawn_marker.global_transform)
			set_physics_process(false)
			disappear_after_death_timer.start(10)


func take_hit(weapon_item_resource: WeaponItemResource) -> void:
	if hittable_object_attributes.weapon_filter.has(weapon_item_resource.item_key):
		health -= weapon_item_resource.damage

		if state not in [States.Dead, States.Hurt]:
			if health <= 0:
				set_state(States.Dead)
				return
			set_state(States.Hurt)


func _on_vision_area_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_vision_range = true


func _on_vision_area_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_vision_range = false