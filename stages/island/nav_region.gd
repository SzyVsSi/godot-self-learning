extends NavigationRegion3D


func _enter_tree() -> void:
  EventSystem.GAM_update_nav_mesh.connect(bake_navigation_mesh)
