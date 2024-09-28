extends CharacterBody3D


const ANIM_BLEND := 0.2


enum States {
	Idle,
	Wander,
	Dead,
	Flee,
	Hurt
}


var state := States.Idle


@export var hittable_object_attributes: HittableObjectAttributes
@export var normal_speed := 0.6
@export var fleeing_speed := 1.7
@export var idle_animations: Array[String] = []
@export var hurt_animations: Array[String] = []
@export var turn_speed_weight := 0.07
@export var min_idle_time := 2.0
@export var max_idle_time := 7.0
@export var min_wander_time := 2.0
@export var max_wander_time := 4.0
@export var fleeing_time := 3.5
@export var is_aggressive := false


@onready var idle_timer: Timer = %IdleTimer
@onready var wander_timer: Timer = %WanderTimer
@onready var disappear_after_death_timer: Timer = %DisappearAfterDeathTimer
@onready var flee_timer: Timer = %FleeTimer

@onready var main_collision_shape: CollisionShape3D = $CollisionShape3D
@onready var meat_spawn_marker: Marker3D = $MeatSpawnMarker
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var health := hittable_object_attributes.max_health
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")


func _ready() -> void:
	animation_player.animation_finished.connect(animation_finished)


func animation_finished(_anim_name: String) -> void:
	if state == States.Idle:
		animation_player.play(idle_animations.pick_random(), ANIM_BLEND)

	if state == States.Hurt and not is_aggressive:
		set_state(States.Flee)


func _physics_process(_delta: float) -> void:
	if state == States.Wander:
		wander_loop()
		return
	
	if state == States.Flee:
		flee_loop()


func wander_loop() -> void:
	look_forward()
	move_and_slide()


func flee_loop() -> void:
	look_forward()
	move_and_slide()


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
	dir.y = 0
	velocity = dir * fleeing_speed


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
		States.Dead:
			animation_player.play("Death", ANIM_BLEND)
			main_collision_shape.disabled = true
			var meat_scene := ItemConfig.get_pickuppable_item(ItemConfig.Keys.RawMeat)
			EventSystem.SPA_spawn_scene.emit(meat_scene, meat_spawn_marker.global_transform)
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
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
