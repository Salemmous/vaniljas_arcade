extends Node

var blockers: Array[String] = []

func add_blocker(blocker_id: String):
	if blockers.has(blocker_id):
		return
	blockers.append(blocker_id)
	
func remove_blocker(blocker_id: String):
	blockers.erase(blocker_id)
	
func are_controls_blocked(): return not blockers.is_empty()
