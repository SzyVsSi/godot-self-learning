extends TextureRect


var item_key: ItemConfig.Keys


@onready var icon_texture_rect: TextureRect = $MarginContainer/IconTextureRect


func set_item_key(_item_key: ItemConfig.Keys) -> void:
	item_key = _item_key
	icon_texture_rect.texture = ItemConfig.get_item_resource(item_key).icon
