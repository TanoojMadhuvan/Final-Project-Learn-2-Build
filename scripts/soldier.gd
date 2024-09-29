extends CharacterBody2D

@onready var sound: AudioStreamPlayer = $AudioPlayer2D

var SPEED = 1
const JUMP_VELOCITY = -400.0

var targetX = 0;
var targetY = 0;
var health = 200;
var alive = true;

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D;

func initialize(X, Y, S, SP):
	position.x = X;
	position.y = Y;
	scale.x = S;
	scale.y = S;
	z_index = 19;
	SPEED = SP;

func set_target(X, Y):
	targetX = X;
	targetY = Y;
	
func take_damage():
	health -= 3;
	sprite.set_animation("hurt");
	if(health <= 0):
		alive = false;
		sprite.set_animation("death")

func move_to_target():
	var xmul = 1;
	var ymul = 1;

	if(position.x > targetX):
		xmul = -1;
	elif(position.x < targetX - 20):
		xmul = 1;
	else:
		xmul = 0;
		
	if(position.x + 10 < targetX):
		sprite.flip_h = false;
	else:
		sprite.flip_h = true;
		
		
	if(position.y > targetY):
		ymul = -1;
	elif(position.y < targetY):
		ymul = 1;
	else:
		ymul = 0;
		
	if(abs(position.x - targetX) < 2):
		xmul = 0;
	
	if(abs(position.y - targetY) < 2):
		ymul = 0;
		
	if(xmul != 0 && ymul != 0):
		xmul /= sqrt(2);
		ymul /= sqrt(2);
	
	position.x += xmul * SPEED;
	position.y += ymul * SPEED;
	
	if(sprite.animation == "hurt" && sprite.frame < 3):
		sound.get_child(0).play("hurt");
	elif(xmul == 0 && ymul == 0):
		sprite.set_animation("attack");
		sound.get_child(0).play("attack");
	else:
		sprite.set_animation("walk");
		
	
func _physics_process(delta: float) -> void:
	move_and_slide()
