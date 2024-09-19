extends TextureRect


var item_key: ItemConfig.Keys


@onready var icon_texture_rect: TextureRect = $MarginContainer/IconTextureRect
@onready var button: Button = $Button


func set_item_key(new_item_key: ItemConfig.Keys) -> void:
	item_key = new_item_key
	icon_texture_rect.texture = ItemConfig.get_item_resource(item_key).icon
