extends Node


var bulletins := {}


func _enter_tree() -> void:
	EventSystem.BUL_create_bulletin.connect(create_bulletin)
	EventSystem.BUL_destroy_bulletin.connect(destroy_bulletin)
	EventSystem.BUL_destroy_all_bulletins.connect(destroy_all_bulletins)


func create_bulletin(key: BulletinConfig.Keys, extra_arg = null) -> void:
	if bulletins.has(key):
		return

	var new_bulletin := BulletinConfig.get_bulletin(key)
	bulletins[key] = new_bulletin
	new_bulletin.initialize(extra_arg)
	add_child(new_bulletin)


func destroy_bulletin(key: BulletinConfig.Keys) -> void:
	if not bulletins.has(key):
		return

	bulletins[key].queue_free()
	bulletins.erase(key)


func destroy_all_bulletins() -> void:
	for child in get_children():
		child.queue_free()
		
	bulletins.clear()