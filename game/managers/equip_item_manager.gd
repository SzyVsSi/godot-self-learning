extends Node

var inventory_manager := preload("res://game/managers/inventory_manager.gd")

var active_hotbar_slot
var hotbar: Array


func _enter_tree() -> void:
	EventSystem.INV_update_hotbar.connect(update_hotbar)
	EventSystem.EQU_hotkey_pressed.connect(hotkey_pressed)
	EventSystem.EQU_delete_equipped_item.connect(delete_equipped_item)


func _ready() -> void:
	EventSystem.EQU_active_hotbar_slot_changed.emit(null)
	hotbar.resize(inventory_manager.HOTBAR_SIZE)


func update_hotbar(new_hotbar: Array) -> void:
	hotbar = new_hotbar

	if active_hotbar_slot != null and hotbar[active_hotbar_slot] == null:
		active_hotbar_slot = null
		EventSystem.EQU_unequip_item.emit()
		EventSystem.EQU_active_hotbar_slot_changed.emit(null)


func hotkey_pressed(hotkey: int) -> void:
	var index := hotkey - 1

	if hotbar[index] == null:
		return
	
	if index != active_hotbar_slot:
		active_hotbar_slot = index
		EventSystem.EQU_equip_item.emit(hotbar[index])
		EventSystem.EQU_active_hotbar_slot_changed.emit(index)
		return
	
	active_hotbar_slot = null
	EventSystem.EQU_unequip_item.emit()
	EventSystem.EQU_active_hotbar_slot_changed.emit(null)


func delete_equipped_item() -> void:
	EventSystem.INV_delete_item_by_index.emit(active_hotbar_slot, true)
	EventSystem.EQU_active_hotbar_slot_changed.emit(null)
	active_hotbar_slot = null