extends TextureRect
class_name InventorySlot


var item_key


@onready var icon_texture_rect: TextureRect = $MarginContainer/IconTextureRect


func set_item_key(new_item_key: Variant) -> void:
	item_key = new_item_key
	update_icon()


func update_icon() -> void:
	if item_key == null:
		icon_texture_rect.texture = null
		return
	
	icon_texture_rect.texture = ItemConfig.get_item_resource(item_key).icon


func _get_drag_data(_at_position: Vector2) -> Variant:
	if item_key != null:
		var drag_preview := TextureRect.new()
		drag_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		drag_preview.texture = icon_texture_rect.texture
		drag_preview.custom_minimum_size = Vector2(70, 70)
		set_drag_preview(drag_preview)
		icon_texture_rect.texture = null
		return self
	
	return null


func _can_drop_data(_at_position: Vector2, origin_slot: Variant) -> bool:
	if item_key != null:
		if origin_slot is HotBarSlot:
			return ItemConfig.get_item_resource(item_key).is_equippable
		
		if origin_slot is StartingCookingSlot:
			return ItemConfig.get_item_resource(item_key).cooking_recipe != null

		if origin_slot is FinalCookingSlot:
			return false

	return origin_slot is InventorySlot


func _drop_data(_at_position: Vector2, origin_slot: Variant) -> void:
	if origin_slot is StartingCookingSlot:
		var temp_own_key = item_key
		EventSystem.INV_add_item_by_index.emit(origin_slot.item_key, get_index(), self is HotBarSlot)
		origin_slot.set_item_key(temp_own_key)
		return
	
	if origin_slot is StartingCookingSlot:
		EventSystem.INV_add_item_by_index.emit(origin_slot.item_key, get_index(), self is HotBarSlot)
		origin_slot.set_item_key(null)
		return

	EventSystem.INV_switch_two_item_indexes.emit(
		origin_slot.get_index(),
		origin_slot is HotBarSlot,
		get_index(),
		self is HotBarSlot
	)
	
	
func _notification(incoming_notification: int) -> void:
	match incoming_notification:
		NOTIFICATION_DRAG_END:
			update_icon()
