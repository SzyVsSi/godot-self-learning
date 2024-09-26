extends Node
class_name InventoryManager

const INVENTORY_SIZE := 28
const HOTBAR_SIZE := 9


var inventory := []
var hotbar := []


func _enter_tree() -> void:
	EventSystem.INV_try_to_pickup_item.connect(try_to_pickup_item)
	EventSystem.INV_request_inventory.connect(send_inventory)
	EventSystem.INV_switch_two_item_indexes.connect(switch_two_item_indexes)
	EventSystem.INV_add_item.connect(add_item)
	EventSystem.INV_delete_crafting_blueprint_costs.connect(delete_crafting_blueprint_costs)
	EventSystem.INV_delete_item_by_index.connect(delete_item_by_index)
	

func _ready() -> void:
	inventory.resize(INVENTORY_SIZE)
	hotbar.resize(HOTBAR_SIZE)

	# TODO: DELETE ME LATER
	inventory[0] = ItemConfig.Keys.Axe
	inventory[1] = ItemConfig.Keys.Pickaxe


func try_to_pickup_item(item_key: ItemConfig.Keys, destroy_pickuppable: Callable) -> void:
	if not get_free_slots(): return
	
	add_item(item_key)
	destroy_pickuppable.call()


func get_free_slots() -> int:
	return inventory.count(null)


func add_item(item_key: ItemConfig.Keys) -> void:
	for i in inventory.size():
		if inventory[i] == null:
			inventory[i] = item_key
			break
	send_inventory()


func delete_crafting_blueprint_costs(costs: Array[BlueprintCostData]) -> void:
	for cost in costs:
		for i in cost.amount:
			delete_item(cost.item_key)


func delete_item(item_key: ItemConfig.Keys) -> void:
	if not inventory.has(item_key):
		return
	
	var last_index = inventory.rfind(item_key)
	inventory[last_index] = null
	send_inventory()


func send_inventory() -> void:
	EventSystem.INV_update_inventory.emit(inventory)


func send_hotbar() -> void:
	EventSystem.INV_update_hotbar.emit(hotbar)
	
	
func switch_two_item_indexes(first: int, first_is_in_hot_bar: bool, second: int, second_is_in_hot_bar: bool) -> void:
	var item1 = inventory[first] if not first_is_in_hot_bar else hotbar[first]
	var item2 = inventory[second] if not second_is_in_hot_bar else hotbar[second]

	if not first_is_in_hot_bar:
		inventory[first] = item2
	else:
		hotbar[first] = item2

	if not second_is_in_hot_bar:
		inventory[second] = item1
	else:
		hotbar[second] = item1

	send_inventory()
	send_hotbar()


func delete_item_by_index(index: int, is_in_hotbar: bool) -> void:
	if is_in_hotbar:
		hotbar[index] = null
		send_hotbar()
		return

	inventory[index] = null
	send_inventory()