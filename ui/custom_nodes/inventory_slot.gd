extends TextureRect
class_name InventorySlot


var item_key


@onready var icon_texture_rect: TextureRect = $MarginContainer/IconTextureRect


func set_item_key(_item_key) -> void:
	item_key = _item_key
	update_icon()


func update_icon() -> void:
	if item_key == null:
		icon_texture_rect.texture = null
		return
	
	icon_texture_rect.texture = ItemConfig.get_item_resource(item_key).icon


func _get_drag_data(at_position: Vector2) -> Variant:
	if item_key != null:
		var drag_preview := TextureRect.new()
		drag_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		drag_preview.texture = icon_texture_rect.texture
		drag_preview.custom_minimum_size = Vector2(70, 70)
		set_drag_preview(drag_preview)
		icon_texture_rect.texture = null
		return self
	
	return null


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is InventorySlot


func _drop_data(at_position: Vector2, data: Variant) -> void:
	EventSystem.INV_switch_two_item_indexes.emit(data.get_index(), get_index())
	
	
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_END:
			update_icon()
