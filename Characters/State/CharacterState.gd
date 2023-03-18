class_name CharacterState
extends Node3D

var current_state: CharacterState
var children: Array[CharacterState] = []

func _ready() -> void:
	for child in get_children():
		if child is CharacterState:
			children.append(child)
			
	if children.is_empty():
		return
		
	children[0].enter(null)
	current_state = children[0]

func enter(_previous: CharacterState) -> void:
	pass
	
func exit(_next: CharacterState) -> void:
	pass
	
func change_state(new_state_name: String) -> void:
	var new_state: CharacterState
	for child in children:
		if child.name == new_state_name:
			new_state = child
			break
	if not new_state:
		push_error("No state found: " + new_state_name)
		return
	if current_state:
		current_state.exit(new_state)
	var old_state = current_state
	current_state = new_state
	new_state.enter(old_state)

func process_actions(delta: float, actions: CharacterActions, _parent: CharacterState) -> CharacterActions:
	if current_state:
		actions = current_state.process_actions(delta, actions, self)
	return actions
