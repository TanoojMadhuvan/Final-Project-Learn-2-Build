extends CharacterBody2D

@export var speed = 100
@export var reload = 1

var direction = "down";
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var timer: Timer = $Timer
@onready var sound: AudioStreamPlayer = $AudioPlayer2D

var canHit = true;

func _ready() -> void:
	timer.set_wait_time(reload);
	timer.stop();

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	if(Input.is_action_pressed("left") and Input.is_action_pressed("right")):
		pass;
	elif(Input.is_action_pressed("left")):
		direction = "left";
	elif(Input.is_action_pressed("right")):
		direction = "right";
		
	if(Input.is_action_pressed("up") and Input.is_action_pressed("down")):
		pass;
	elif(Input.is_action_pressed("up")):
		direction = "up";
	elif(Input.is_action_pressed("down")):
		direction = "down";
	
	if(direction == "left"):
		direction = "left_side";
		sprite.flip_h = false;
	elif(direction == "right"):
		direction = "left_side";
		sprite.flip_h = true;
	
	var motion = "idle";
	
	if(velocity.length() != 0):
		motion = "walk";
	
	if(Input.is_action_just_pressed("space") && canHit):
		motion = "attack";
		canHit = false;
		timer.start();
		
	var animation = direction + "_" + motion;
	
	if(Input.is_action_just_pressed("enter")):
		animation = "pick_up";
	
	if((sprite.animation == "left_side_attack" or sprite.animation == "up_attack" or sprite.animation == "down_attack" ) && sprite.frame < 2):
		sprite.play();
	elif(sprite.animation == "pick_up"):
		sprite.play();
	else:
		sprite.set_animation(animation);
		sprite.play();
	
	if(sprite.animation == "up_walk" or sprite.animation == "down_walk"  or sprite.animation == "left_side_walk"):
		sound.get_child(0).play("run");
	elif(sprite.animation == "up_attack" or sprite.animation == "down_attack" or sprite.animation == "left_side_attack"):
		sound.get_child(0).play("attack");
	else:
		sound.get_child(0).pause();
	
func _physics_process(delta):
	get_input()
	if(sprite.animation != "pick_up"):
		move_and_slide()
	


func _on_timer_timeout() -> void:
	canHit = true;
	timer.set_wait_time(reload);
	timer.stop();
