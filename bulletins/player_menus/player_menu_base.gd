extends Bulletin
class_name PlayerMenuBase


@onready var inventory_container: GridContainer = %InventoryContainer
@onready var item_description_label: Label = %ItemDescriptionLabel
@onready var item_extra_info_label: Label = %ItemExtraInfoLabel


func _enter_tree() -> void:
	EventSystem.INV_update_inventory.connect(update_inventory)


func _ready() -> void:
	EventSystem.PLA_freeze_player.emit()
	EventSystem.INV_request_inventory.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	for inventory_slot in inventory_container.get_children():
		inventory_slot.mouse_entered.connect(show_item_info.bind(inventory_slot))
		inventory_slot.mouse_exited.connect(hide_item_info)

	for hotbar_slot in get_tree().get_nodes_in_group("HotBarSlots"):
		hotbar_slot.mouse_entered.connect(show_item_info.bind(hotbar_slot))
		hotbar_slot.mouse_exited.connect(hide_item_info)

	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.UIClick)
	%ScrapSlot.item_scrapped.connect(hide_item_info)


func close() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.CraftingMenu)
	EventSystem.PLA_unfreeze_player.emit()
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.UIClick)


func update_inventory(inventory: Array) -> void:
	for i in inventory.size():
		inventory_container.get_child(i).set_item_key(inventory[i])


func show_item_info(inventory_slot: InventorySlot) -> void:
	var item_key = inventory_slot.item_key
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or item_key == null:
		return
	var item_resource = ItemConfig.get_item_resource(item_key)
	item_description_label.text = "%s\n%s" % [item_resource.display_name, item_resource.description]
	%ScrapSlot.visible = true


func hide_item_info() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	
	item_description_label.text = ""
	%ScrapSlot.visible = false
