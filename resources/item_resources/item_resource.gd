extends Resource
class_name ItemResource


@export var item_key: ItemConfig.Keys
@export var display_name := "item name"
@export var icon: Texture2D
@export var is_equippable := false
@export var cooking_recipe: CookingRecipeResource
@export_multiline var description := "description"
