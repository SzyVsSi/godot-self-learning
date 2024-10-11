extends Node3D


@export var constructable_holder: Node3D


@onready var object_holder: Node3D = $ObjectHolder


func _enter_tree() -> void:
	EventSystem.SPA_spawn_scene.connect(spawn_scene)


func spawn_scene(scene: PackedScene, tform: Transform3D, is_constructable := false) -> void:
	var object := scene.instantiate()
	object.global_transform = tform

	if is_constructable:
		constructable_holder.add_child(object)
		EventSystem.GAM_update_nav_mesh.emit()
	else:
		object_holder.add_child(object)
