extends Node


signal BUL_create_bulletin(key: BulletinConfig.Keys, extra_args)
signal BUL_destroy_bulletin(key: BulletinConfig.Keys)


signal INV_try_to_pickup_item


signal PLA_freeze_player
signal PLA_unfreeze_player
