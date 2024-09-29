extends CanvasLayer


func transitionOut():
	$AnimationPlayer.play("fade_to_black")
	print("Fading to black")

func transitionIn():
	$AnimationPlayer.play("fade_to_normal")
	print("Fading to black")
