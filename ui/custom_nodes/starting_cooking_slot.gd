extends InventorySlot
class_name StartingCookingSlot


signal starting_ingredient_enabled
signal starting_ingredient_disabled


var cooking_in_progress := false


func _get_drag_data(at_position: Vector2) -> Variant:
	if cooking_in_progress:
		return null
	
	return super(at_position)


func _can_drop_data(_at_position: Vector2, slot: Variant) -> bool:
	if item_key != null:
		return false

	if ItemConfig.get_item_resource(slot.item_key).cooking_recipe == null:
		return false

	return slot is InventorySlot


func _drop_data(_at_position: Vector2, origin_slot: Variant) -> void:
	set_item_key(origin_slot.item_key)
	EventSystem.INV_delete_item_by_index.emit(origin_slot.get_index(), origin_slot is HotBarSlot)
	starting_ingredient_enabled.emit()