extends CharacterBody2D

@export var speed = 100

var direction = "down";
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $Sprite2D/AnimationPlayer

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
	
	if(Input.is_action_pressed("space")):
		motion = "attack";
		
	var animation = direction + "_" + motion;
	
	if(Input.is_action_pressed("enter")):
		animation = "pick_up";
	
	sprite.set_animation(animation);
	sprite.play();
	
func _physics_process(delta):
	get_input()
	move_and_slide()
	print(direction);
