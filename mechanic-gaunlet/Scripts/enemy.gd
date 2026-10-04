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
@onready var attack_delay: Timer = $AttackDelay



var current_inv = false
var target_right
var target_left
var lock = false

#speed and gravity
const SPEED = 10000.0
const JUMP_VELOCITY = -400.0

var hit
var direction


func _ready() -> void:
	$AnimationPlayer.play("RESET")
	GlobalManager.enemy_quantitiy += 1
	var rdirection = randi()%2+1
	#left
	if rdirection == 1:
		$FightRight/Right.disabled = false
		$FightLeft/Left.disabled = true
		direction = 1
		$Icon.flip_h = false
#right
	elif rdirection == 2:
		$FightRight/Right.disabled = true
		$FightLeft/Left.disabled = false
		direction = -1
		$Icon.flip_h = true
	
	

func _physics_process(delta: float) -> void:
	#if enemy has no health left
	if health <= 0:
		$CollisionShape2D.disabled = true
		if GlobalManager.GAUNTLET_MAX > GlobalManager.gauntlet_power:
			GlobalManager.gauntlet_power += 1
		GlobalManager.score += 100
		GlobalManager.enemy_quantitiy -= 1
	
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#when it is hit
	if hit == true and not current_inv:
		health -= 1
		$AnimationPlayer.play("vulnerable")
		current_inv = true
		invincibility.start()
	
	if target_right == true:
		
		$AnimationPlayer.play("attackR")
		
		await $AnimationPlayer.animation_finished
		target_right = false
	if target_left == true:
		
		$AnimationPlayer.play("attackL")
		
		await $AnimationPlayer.animation_finished
		target_right = false
	
	#when the raycasts on the left detect something, it would switch directions
	if not left_down.is_colliding():
		direction = 1
		#print("egggs")
		$FightRight/Right.disabled = false
		$FightLeft/Left.disabled = true
		$Icon.flip_h = false
	elif left_middle.is_colliding():
		direction = 1
		$FightRight/Right.disabled = false
		$FightLeft/Left.disabled = true
		$Icon.flip_h = false
	
	elif not right_down.is_colliding() or right_middle.is_colliding():
		direction = -1
		#print("egggs")
		$FightRight/Right.disabled = true
		$FightLeft/Left.disabled = false
		$Icon.flip_h = true
	elif right_middle.is_colliding():
		print("edrfgr")
	
	$Icon.play("walk")
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
		target_left = true


func _on_fight_left_body_exited(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		target_left = false


func _on_fight_right_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		target_right = true


func _on_fight_right_body_exited(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		target_right = false
	
