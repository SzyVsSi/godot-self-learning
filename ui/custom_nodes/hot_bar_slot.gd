extends InventorySlot
class_name HotBarSlot


const ACTIVE_COLOR = Color.WHITE
const INACTIVE_COLOR = Color(0.8, 0.8, 0.8, 0.6)


func _ready() -> void:
	$NumTextureRect/NumLabel.text = str(get_index() + 1)


func _can_drop_data(_at_position: Vector2, origin_slot: Variant) -> bool:
	if origin_slot is not InventorySlot:
		return false

	return ItemConfig.get_item_resource(origin_slot.item_key).is_equippable


func set_highlighted(enabled: bool) -> void:
	if not enabled:
		modulate = INACTIVE_COLOR
		return
	
	modulate = ACTIVE_COLOR
