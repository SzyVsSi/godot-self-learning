extends Node
class_name State

## Signal to transition to another state
signal state_finished(next_state_path: String, data: Dictionary)

## State equivalent of _input
func handle_input(_event: InputEvent) -> void:
  pass

## State equivalent of _process
func update(_delta: float) -> void:
  pass

## State equivalent of _physics_process
func update_physics(_delta: float) -> void:
  pass

## Called by state machine when state initialized, can accept optional data
func enter(_previous_state_path: String, _data := {}) -> void:
  pass

## Called by state machine when state exists
func exit() -> void:
  pass