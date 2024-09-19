extends Node

signal BUL_create_bulletin(key: BulletinConfig.Keys, extra_args)
signal BUL_destroy_bulletin(key: BulletinConfig.Keys)


signal INV_try_to_pickup_item(key: ItemConfig.Keys, callback: Callable)
signal INV_request_inventory
signal INV_update_inventory(inventory: Array)
signal INV_update_hotbar(hotbar: Array)
signal INV_switch_two_item_indexes(first: int, firstCondition: bool, second: int, secondCondition: bool)
signal INV_add_item(key: ItemConfig.Keys)
signal INV_delete_crafting_blueprint_costs


signal PLA_freeze_player
signal PLA_unfreeze_player


signal EQU_hotkey_pressed(hotkey: int)
signal EQU_equip_item(key: ItemConfig.Keys)
signal EQU_unequip_item()
signal EQU_active_hotbar_slot_changed(slot: Variant)