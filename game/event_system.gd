extends Node


signal BUL_create_bulletin(key: BulletinConfig.Keys, extra_args)
signal BUL_destroy_bulletin(key: BulletinConfig.Keys)
signal BUL_destroy_all_bulletins


signal INV_try_to_pickup_item(key: ItemConfig.Keys, callback: Callable)
signal INV_request_inventory
signal INV_update_inventory(inventory: Array)
signal INV_update_hotbar(hotbar: Array)
signal INV_switch_two_item_indexes(first: int, firstCondition: bool, second: int, secondCondition: bool)
signal INV_add_item(key: ItemConfig.Keys)
signal INV_delete_crafting_blueprint_costs
signal INV_delete_item_by_index(index: int, is_in_hotbar: bool)
signal INV_add_item_by_index(item_key: ItemConfig.Keys, index: int, is_in_hotbar: bool)


signal PLA_freeze_player
signal PLA_unfreeze_player
signal PLA_change_energy(energy_change: float)
signal PLA_update_energy(max_energy: float, current_energy: float)
signal PLA_change_health(health_change: float)
signal PLA_update_health(max_health: float, current_health: float)
signal PLA_player_sleep


signal EQU_hotkey_pressed(hotkey: int)
signal EQU_equip_item(key: ItemConfig.Keys)
signal EQU_unequip_item
signal EQU_active_hotbar_slot_changed(slot: Variant)
signal EQU_delete_equipped_item()


signal SPA_spawn_scene(scene: PackedScene, transform: Transform3D)


signal SFX_play_sfx(sfx_key: SFXConfig.Keys)
signal SFX_play_dynamic_sfx(sfx_key: SFXConfig.Keys, position: Vector3, pitch_rand: float)


signal MUS_play_music(music_key: MusicConfig.Keys)


signal GAM_fast_forward_day_night_anim(time_in_hours: float)
signal GAM_game_fade_in(fade_time: float, callback: Callable, show_loading_label: bool)
signal GAM_game_fade_out(fade_time: float, callback: Callable)


signal HUD_hide_hud
signal HUD_show_hud


signal STA_change_stage(stage_key: StageConfig.Keys)


signal SET_change_music_volume(volume: float)
signal SET_change_sfx_volume(volume: float)
signal SET_change_res_scale(scale: float)
signal SET_change_ssaa(value: bool)
signal SET_toggle_fullscreen(value: bool)