class_name SFXConfig


enum Keys {
  UIClick,
  ItemPickup,
  Craft,
  Build,
  Eat,
  WeaponSwoosh
}


const FILE_PATHS := {
  Keys.UIClick: "res://audio/sfx/ui_click.wav",
  Keys.ItemPickup: "res://audio/sfx/item_pickup.wav",
  Keys.Craft: "res://audio/sfx/craft.wav",
  Keys.Build: "res://audio/sfx/build.wav",
  Keys.Eat: "res://audio/sfx/eat.wav",
  Keys.WeaponSwoosh: "res://audio/sfx/weapon_swoosh.wav",
}


static func get_audio_stream(key: Keys) -> AudioStream:
  return load(FILE_PATHS.get(key))