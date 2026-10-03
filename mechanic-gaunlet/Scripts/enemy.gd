extends CharacterBody2D

#raycasts
@onready var left_down: RayCast2D = $Raycasts/LeftDown
@onready var leftup: RayCast2D = $Raycasts/Leftup
@onready var left_middle: RayCast2D = $Raycasts/LeftMiddle
@onready var right_down: RayCast2D = $Raycasts/RightDown
@onready var rightup: RayCast2D = $Raycasts/Rightup
@onready var right_middle: RayCast2D = $Raycasts/RightMiddle





#@onready var player: player

#health
var health = 2

#timers
@onready var invincibility: Timer = $Invincibility
@onready var attack_duration: Timer = $AttackDuration
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var attack_wait: Timer = $AttackWait


var current_inv = false
var target
var lock = false

#speed and gravity
const SPEED = 10000.0
const JUMP_VELOCITY = -400.0

var hit
var direction


func _ready() -> void:
	$AnimationPlayer.play("RESET")
	var rdirection = randi()%2
	if rdirection == 0:
		direction = -1
		$Icon.flip_h = true

	elif rdirection == 1:
		direction = 1
		$Icon.flip_h = false
	

func _physics_process(delta: float) -> void:
	#if enemy has no health left
	if health <= 0:
		$CollisionShape2D.disabled = true
		GlobalManager.gauntlet_power += 1
		GlobalManager.score += 100
	
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#when it is hit
	if hit == true and not current_inv:
		health -= 1
		$AnimationPlayer.play("vulnerable")
		current_inv = true
		invincibility.start()
	
	
	
	#when the raycasts on the left detect something, it would switch directions
	if not left_down.is_colliding() or leftup.is_colliding() or left_middle.is_colliding():
		direction = 1
		
		$Icon.flip_h = false
	
	elif not right_down.is_colliding() or rightup.is_colliding() or right_middle.is_colliding():
		direction = -1
		
		$Icon.flip_h = true
	
	
	#detects player and attacks
	if  target == true and lock == false:
		if direction > 0:
			$Icon.flip_h = false
		lock = true
		attack_wait.start()
	elif target == true and lock == false:
		if direction < 0:
			$Icon.flip_h = true
		lock = true
		attack_wait.start()
	
	#this is for receiving player attacks
	
	velocity.x = direction * SPEED * delta
	
	move_and_slide()


func _on_area_2d_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	
	if area.is_in_group("player_attack"):
		hit = true


func _on_invincibility_timeout() -> void:
	hit = false
	
	current_inv = false
	$AnimationPlayer.play("RESET")
	$Area2D/CollisionShape2D.disabled = false

func _on_fight_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = true


func _on_fight_left_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = false


func _on_fight_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = true


func _on_fight_right_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = false

func play_attack():
	$Icon.play("attack")
