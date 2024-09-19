extends HBoxContainer


func _enter_tree() -> void:
  EventSystem.INV_update_hotbar.connect(update_hotbar)
  EventSystem.EQU_active_hotbar_slot_changed.connect(active_slot_changed)


func update_hotbar(hotbar: Array) -> void:
  for slot in get_children():
    slot.set_item_key(hotbar[slot.get_index()])


func active_slot_changed(index: Variant) -> void:
  for slot in get_children():
    slot.set_highlighted(slot.get_index() == index)