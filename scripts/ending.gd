extends Control

@onready var resultLabel: Label = $Result
@onready var final_scoreLabel: Label = $Final_Score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;
	
func instan():
	resultLabel.text = Music.result;
	final_scoreLabel.text = Music.final_score;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(resultLabel != null && final_scoreLabel != null):
		instan();


func _on_back_podium_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lobby.tscn");
