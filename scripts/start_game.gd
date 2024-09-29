extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_pressed() -> void:
	$"../Transition".layer = 1
	$"../Transition".transitionOut()
	await $"../Transition/AnimationPlayer".animation_finished
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	
