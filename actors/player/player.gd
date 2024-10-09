extends CharacterBody3D
class_name Player


var is_sprinting: bool
var is_grounded := true


@export var normal_speed := 3.0
@export var sprint_speed := 5.0
@export var jump_velocity := 4.0
@export var gravity := 0.2
@export var mouse_sensitivity := 0.005
@export var walking_energy_cost_per_1m := -0.05
@export var walking_footstep_audio_interval := 0.6
@export var sprinting_footstep_audio_interval := 0.3


@onready var head: Node3D = $Head
@onready var interaction_ray_cast: RayCast3D = $Head/InteractionRayCast
@onready var equippable_item_holder: Node3D = %EquippableItemHolder
@onready var footstep_audio_timer: Timer = $FootstepAudioTimer


func _enter_tree() -> void:
	EventSystem.PLA_freeze_player.connect(set_freeze.bind(true))
	EventSystem.PLA_unfreeze_player.connect(set_freeze.bind(false))


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventSystem.HUD_show_hud.emit()


func _exit_tree() -> void:
	EventSystem.HUD_hide_hud.emit()


func set_freeze(value: bool) -> void:
	set_process(!value)
	set_physics_process(!value)
	set_process_input(!value)
	set_process_unhandled_key_input(!value)
	

func _process(_delta: float) -> void:
	interaction_ray_cast.check_interaction()


func _physics_process(delta: float) -> void:
	move()
	check_walking_energy_change(delta)
	attack_or_use()


func move() -> void:
	if is_on_floor():
		is_sprinting = Input.is_action_pressed("sprint")

		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity

		if velocity != Vector3.ZERO and footstep_audio_timer.is_stopped():
			EventSystem.SFX_play_dynamic_sfx.emit(SFXConfig.Keys.Footstep, global_position, 0.25)
			footstep_audio_timer.start(walking_footstep_audio_interval if not is_sprinting else sprinting_footstep_audio_interval)

		if not is_grounded:
			is_grounded = true
			EventSystem.SFX_play_dynamic_sfx.emit(SFXConfig.Keys.JumpLand, global_position, 0.2)
	else:
		velocity.y -= gravity
		is_sprinting = false
		if is_grounded:
			is_grounded = false

	var speed := sprint_speed if is_sprinting else normal_speed
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.z = direction.z * speed
	velocity.x = direction.x * speed
	move_and_slide()


func check_walking_energy_change(delta: float) -> void:
	if velocity.x or velocity.z:
		var energy_cost = walking_energy_cost_per_1m * delta * Vector2(velocity.z, velocity.x).length()
		EventSystem.PLA_change_energy.emit(energy_cost)


func attack_or_use() -> void:
	if Input.is_action_just_pressed("use_item"):
		equippable_item_holder.try_to_use_item()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_around(event.relative)


func look_around(relative: Vector2) -> void:
	rotate_y(-relative.x * mouse_sensitivity)
	head.rotate_x(-relative.y * mouse_sensitivity)
	head.rotation.x = clampf(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.PauseMenu)
		return
	
	if event.is_action_pressed("open_crafting_menu"):
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.CraftingMenu)
	elif event.is_action_pressed("item_hotkey"):
		EventSystem.EQU_hotkey_pressed.emit(int(event.as_text()))