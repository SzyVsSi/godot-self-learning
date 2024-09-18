extends Node


const INVENTORY_SIZE := 28


var inventory := []


func _enter_tree() -> void:
	EventSystem.INV_try_to_pickup_item.connect(try_to_pickup_item)
	EventSystem.INV_request_inventory.connect(send_inventory)
	EventSystem.INV_switch_two_item_indexes.connect(switch_two_item_indexes)
	EventSystem.INV_add_item.connect(add_item)
	EventSystem.INV_delete_crafting_blueprint_costs.connect(delete_crafting_blueprint_costs)
	

func _ready() -> void:
	inventory.resize(INVENTORY_SIZE)


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
	
	
func switch_two_item_indexes(first: int, second: int) -> void:
	var temp = inventory[first]
	inventory[first] = inventory[second]
	inventory[second] = temp
	send_inventory()
