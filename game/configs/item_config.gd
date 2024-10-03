class_name ItemConfig


enum Keys {
	# Pickuppables
	Stick,
	Stone,
	Plant,
	Mushroom,
	Fruit,
	Log,
	Coal,
	Flintstone,
	RawMeat,
	CookedMeat,
	
	# Craftables
	Axe,
	Pickaxe,
	Campfire,
	Multitool,
	Rope,
	Tinderbox,
	Torch,
	Tent,
	Raft
}


const CRAFTABLE_ITEM_KEYS: Array[Keys] = [
	Keys.Axe,
	Keys.Pickaxe,
	Keys.Campfire,
	Keys.Multitool,
	Keys.Rope,
	Keys.Tinderbox,
	Keys.Torch,
	Keys.Tent,
	Keys.Raft
]


const ITEM_RESOURCE_PATHS := {
	# Tools
	Keys.Axe: "res://resources/item_resources/axe_resource.tres",
	Keys.Pickaxe: "res://resources/item_resources/pickaxe_resource.tres",
	Keys.Multitool: "res://resources/item_resources/multitool_resource.tres",
	Keys.Tinderbox: "res://resources/item_resources/tinderbox_resource.tres",
	
	# Resources
	Keys.Coal: "res://resources/item_resources/coal_resource.tres",
	Keys.Flintstone: "res://resources/item_resources/flintstone_resource.tres",
	Keys.Log: "res://resources/item_resources/log_resource.tres",
	Keys.Stone: 'res://resources/item_resources/stone_resource.tres',
	
	# Crafting
	Keys.Rope: "res://resources/item_resources/rope_resource.tres",
	Keys.Torch: "res://resources/item_resources/torch_resource.tres",
	Keys.Tent: "res://resources/item_resources/tent_resource.tres",
	Keys.Campfire: "res://resources/item_resources/campfire_resource.tres",
	Keys.Raft: "res://resources/item_resources/raft_resource.tres",
	
	# Food
	Keys.Fruit: "res://resources/item_resources/fruit_item_resource.tres",
	Keys.Mushroom: "res://resources/item_resources/mushroom_item_resource.tres",
	Keys.Plant: 'res://resources/item_resources/plant_resource.tres',
	Keys.RawMeat: "res://resources/item_resources/raw_meat_resource.tres",
	Keys.CookedMeat: "res://resources/item_resources/cooked_meat_resource.tres",
	
	# Misc
	Keys.Stick: 'res://resources/item_resources/stick_resource.tres',
}


static func get_item_resource(key: Keys) -> ItemResource:
	return load(ITEM_RESOURCE_PATHS.get(key))
	

const CRAFTING_BLUEPRINT_RESOURCE_PATHS := {
	Keys.Axe: "res://resources/crafting_blueprint_resources/axe_blueprint.tres",
	Keys.Rope: "res://resources/crafting_blueprint_resources/rope_blueprint.tres",
	Keys.Pickaxe: "res://resources/crafting_blueprint_resources/pickaxe_blueprint.tres",
	Keys.Tent: "res://resources/crafting_blueprint_resources/tent_blueprint.tres",
	Keys.Raft: "res://resources/crafting_blueprint_resources/raft_blueprint.tres",
	Keys.Campfire: "res://resources/crafting_blueprint_resources/campfire_blueprint.tres",
	Keys.Torch: "res://resources/crafting_blueprint_resources/torch_blueprint.tres",
	Keys.Tinderbox: "res://resources/crafting_blueprint_resources/tinderbox_blueprint.tres",
	Keys.Multitool: "res://resources/crafting_blueprint_resources/multitool_blueprint.tres",
}


static func get_crafting_blueprint_resource(key: Keys) -> CraftingBlueprintResource:
	return load(CRAFTING_BLUEPRINT_RESOURCE_PATHS.get(key))


const EQUIPPABLE_ITEM_PATHS := {
	# Food
	Keys.CookedMeat: "res://items/equippables/equippable_cooked_meat.tscn",
	Keys.Mushroom: "res://items/equippables/equippable_mushroom.tscn",
	Keys.Fruit: "res://items/equippables/equippable_fruit.tscn",
	
	# Others
	Keys.Axe: "res://items/equippables/equippable_axe.tscn",
	Keys.Campfire: "res://items/equippables/equippable_campfire.tscn",
	Keys.Pickaxe: "res://items/equippables/equippable_pickaxe.tscn",
	Keys.Tent: "res://items/equippables/equippable_tent.tscn",
	Keys.Raft: "res://items/equippables/equippable_raft.tscn",
	Keys.Torch: "res://items/equippables/equippable_torch.tscn",
}


static func get_equippable_item(key: Keys) -> PackedScene:
	return load(EQUIPPABLE_ITEM_PATHS.get(key))


const PICKUPPABLE_ITEM_PATHS := {
	Keys.Log: "res://items/interactables/rigid_pickuppable_log.tscn",
	Keys.Coal: "res://items/interactables/rigid_pickuppable_coal.tscn",
	Keys.RawMeat: "res://items/interactables/rigid_pickuppable_raw_meat.tscn",
	Keys.Flintstone: "res://items/interactables/rigid_pickuppable_flintstone.tscn"
}


static func get_pickuppable_item(key: Keys) -> PackedScene:
	return load(PICKUPPABLE_ITEM_PATHS.get(key))


const CONSTRUCTABLE_SCENES := {
	Keys.Tent: "res://objects/constructables/constructable_tent.tscn",
	Keys.Campfire: "res://objects/constructables/constructable_campfire.tscn",
	Keys.Raft: "res://objects/constructables/constructable_raft.tscn"
}


static func get_constructable_scene(key: Keys) -> PackedScene:
	return load(CONSTRUCTABLE_SCENES.get(key))