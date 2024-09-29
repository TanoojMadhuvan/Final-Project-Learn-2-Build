extends Node2D
@export var orc_scene: PackedScene
@export var soldier_scene: PackedScene

var score = 0;
var timer = 45;
var health = 100;
var trashX = 0;
var trashY = 0;
var kills = 0;

var lowX = 336.6379;
var lowY = -332.9376;
var highX = 1610.252;
var highY = 491.3983;

var orcs = [];
var soldiers = [];

var result = "";

@onready var player: CharacterBody2D = $player
@onready var labelSearch: Label = $CanvasLayer/Control/MarginContainer2/Label
@onready var gameScore: Label = $CanvasLayer/Control/MarginContainer3/Score
@onready var time: Label = $CanvasLayer/Control/MarginContainer4/Time
@onready var healthbar: TextureProgressBar = $CanvasLayer/Control/MarginContainer/TextureProgressBar

var rng = RandomNumberGenerator.new()

func spawnOrc():
	
	for i in range(rng.randi_range(2 + score*2, 5+ score*2)):	
		var mob = orc_scene.instantiate();
		mob.initialize(1020 + rng.randf_range(-30.0, 30.0), 20 + rng.randf_range(-30.0, 30.0), 0.5 + rng.randf_range(0, 0.3), 0.5 + (score *0.2) + rng.randf_range(-0.2, 0.5));
		mob.get_child(0).set_animation("idle");
		orcs.append(mob);
		add_child(mob);
	
func spawnSoldier():
	
	for i in range(rng.randi_range(2+score, 5+ score)):	
		var mob = soldier_scene.instantiate();
		mob.initialize(1020 + 2816 - 1006 + rng.randf_range(-100.0, 100.0), 20 + 155 + 167 + rng.randf_range(-100.0, 100.0), 0.5 + rng.randf_range(-0.1, 0.1), 1 + (score *0.2) + rng.randf_range(-0.3, 0.2));
		mob.get_child(0).set_animation("idle");
		soldiers.append(mob);
		add_child(mob);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomizeTrash();
	spawnSoldier();
	spawnOrc();

func randomizeTrash():
	var rand = RandomNumberGenerator.new();
	trashX = rand.randf_range(lowX, highX);
	trashY = rand.randf_range(lowY, highY);
	
	print(str(trashX) + " " + str(trashY));


func end(ending):
	if(ending == 0):
		result = "You ran out of time!";
	elif(ending == 1):
		result = "You were slaughered!";
	
	Music.result = result;
	Music.final_score = "Final score trash picked: " + str(score) + "\nKills: " + str(kills);
	get_tree().change_scene_to_file("res://scenes/ending.tscn");
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(health <= 0):
		end(1);
	elif(timer <= 0):
		end(0);
		
	
	var apx = player.position.x + 92
	var apy = player.position.y + 235
	
	healthbar.value = health;
	
	kills = 0;
	for mob in orcs:
		if(mob.alive):
			var mx = mob.position.x;
			var my = mob.position.y;
			
			mob.set_target(player.position.x + 82, player.position.y + 235);
			mob.move_to_target();
			mob.get_child(0).play();
			if(mob.get_child(0).frame == 5 && mob.get_child(0).animation == "attack"):
				health -= 3;
			
			if( player.get_child(0).animation == "down_attack" && (apx - 30 < mx) && (apx - 10 > mx) && (apy < my + 3) && (apy > my - 20)):
				mob.take_damage();
			elif( player.get_child(0).animation == "up_attack" && (apx - 30 < mx) && (apx - 10 > mx) && (my < apy + 3) && (my > apy - 20)):
				mob.take_damage();
			elif( player.get_child(0).animation == "left_side_attack" && player.get_child(0).flip_h == false && (apx - 40 < mx) && (apx - 10> mx) && (my < apy + 10) && (my > apy - 10)):
				mob.take_damage();
			elif( player.get_child(0).animation == "left_side_attack" && player.get_child(0).flip_h == true && (apx - 20 < mx) && (apx + 10> mx) && (my < apy + 10) && (my > apy - 10)):
				mob.take_damage();
		else:
			kills += 1;
	
	for mob in soldiers:
		if(mob.alive):
			var mx = mob.position.x;
			var my = mob.position.y;
			
			mob.set_target(player.position.x + 82, player.position.y + 235);
			mob.move_to_target();
			mob.get_child(0).play();
			if(mob.get_child(0).frame == 5 && mob.get_child(0).animation == "attack"):
				health -= 1;
			
			if( player.get_child(0).animation == "down_attack" && (apx - 30 < mx) && (apx - 10 > mx) && (apy < my + 3) && (apy > my - 20)):
				mob.take_damage();
			elif( player.get_child(0).animation == "up_attack" && (apx - 30 < mx) && (apx - 10 > mx) && (my < apy + 3) && (my > apy - 20)):
				mob.take_damage();
			elif( player.get_child(0).animation == "left_side_attack" && player.get_child(0).flip_h == false && (apx - 40 < mx) && (apx - 10> mx) && (my < apy + 10) && (my > apy - 10)):
				mob.take_damage();
			elif( player.get_child(0).animation == "left_side_attack" && player.get_child(0).flip_h == true && (apx - 20 < mx) && (apx + 10> mx) && (my < apy + 10) && (my > apy - 10)):
				mob.take_damage();
		else:
			kills += 1;
	
	if(player.get_child(0).animation == "pick_up" && player.get_child(0).frame < 4):
		labelSearch.text = "Searching for trash...";
	elif(player.get_child(0).animation == "pick_up" && player.get_child(0).frame == 4):
		var dist = sqrt((player.position.x - trashX)*(player.position.x - trashX) + (player.position.x - trashX)*(player.position.x - trashX));
		var message = "";
		player.get_child(0).set_animation("left_side_idle");
		if(dist < 100):
			message = "Found the trash... but your credit card is still lost! Keep searching!";
			score += 1;
			timer += 45
			gameScore.text = "Score: " + str(score);
			randomizeTrash();	
		elif(dist < 350):
			message = "Smoking HOT!!";
		elif(dist < 550):
			message = "Hot";
		elif(dist < 750):
			message = "Extremely warm";
		elif(dist < 950):
			message = "Warm";
		elif(dist < 1500):
			message = "Cool";
		elif(dist < 2000):
			message = "Cold";
		elif(dist < 2500):
			message = "Ice Cold";
		else:
			message = "Dreadful freezing Cold";
			
		labelSearch.text = message;


func _on_timer_timeout() -> void:
	timer -= 1;
	if(timer <= 0):
		print("Game over!");
	elif(timer == 1):
		time.text = "Time left: " + str(timer) + " second";
	else:
		time.text = "Time left: " + str(timer) + " seconds";
	


func _on_orc_spawn_timeout() -> void:
	spawnOrc();


func _on_soldier_spawn_timeout() -> void:
	spawnSoldier();
