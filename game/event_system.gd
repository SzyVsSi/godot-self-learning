extends Node


signal BUL_create_bulletin(key: BulletinConfig.Keys, extra_args)
signal BUL_destroy_bulletin(key: BulletinConfig.Keys)


signal INV_try_to_pickup_item(key: ItemConfig.Keys, callback: Callable)
signal INV_request_inventory
signal INV_update_inventory(inventory: Array)
signal INV_switch_two_item_indexes(first: int, second: int)


signal PLA_freeze_player
signal PLA_unfreeze_player
