extends Node2D

#tutorial https://www.youtube.com/watch?v=LqkHEHB-HX4
@onready var enemy = preload("res://Scenes/Enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	


func _on_timer_timeout() -> void:
	#if GlobalManager.enemy_quantitiy < GlobalManager.ENEMY_MAX:
		var ene = enemy.instantiate()
		ene.position = position
		get_parent().add_child(ene)
