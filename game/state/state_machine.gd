extends Node
class_name StateMachine


@export var initial_state: State


var state: State


func _ready() -> void:
  state = initial_state if initial_state else get_child(0)

  for state_node: State in find_children("*", "State"):
    state_node.state_finished.connect(transition_to_next_state)

  await owner.ready
  state.enter("")


func _input(event: InputEvent) -> void:
  state.handle_input(event)


func _process(delta: float) -> void:
  state.update(delta)


func _physics_process(delta: float) -> void:
  state.update_physics(delta)


func transition_to_next_state(next_state_path: String, data := {}) -> void:
  if not has_node(next_state_path):
    var error := "%s: Trying to transition to state %s but it does not exist." % [owner.name, next_state_path]
    printerr(error)
    return

  var previous_state_path := state.name
  state.exit()
  state = get_node(next_state_path)
  state.enter(previous_state_path, data)