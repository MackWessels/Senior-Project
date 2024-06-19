extends Area2D

var level = 1
var hp = 9999
var speed = 200.0
var damage = 10
var knockback_amount = 100
var paths = 1
var attack_size = 1.0
var attack_speed = 4.0

var target = Vector2.ZERO
var target_array = []

var angle = Vector2.ZERO
var reset_pos = Vector2.ZERO

var spr_jav_reg = preload("res://Senior-Project/Textures/Items/Weapons/javelin_3_new.png")
var spr_jav_atk = preload("res://Senior-Project/Textures/Items/Weapons/javelin_3_new_attack.png")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var attackTimer = get_node("%AttackTimer")
@onready var changeDirectionTimer = get_node("%ChangeDirection")
@onready var resetPosTimer = get_node("%ResetPosTimer")
@onready var snd_attack = $snd_attack

signal  remove_from_array(object)

func _ready():
	update_javelin()

func update_javelin():
	level = player.javelin_level
	match level:
		1:
			hp = 9999
			speed = 200.0
			damage = 10
			knockback_amount = 100
			paths = 3
			attack_size = 1.0
			attack_speed = 4.0
	scale = Vector2(1.0, 1.0) * attack_size
	attackTimer.wait_time = attack_size

func _physics_process(delta):
	if target_array.size() > 0:
		position += angle * speed * delta

func add_paths():
	snd_attack.play()
	emit_signal("remove_from_array",self)
	target_array.clear()
	var counter = 0
	while counter < paths:
		var new_path = player.get_random_target()
		target_array.append(new_path)
		counter += 1
		enable_attack(true)
	target = target_array[0]
	process_path()

func process_path():
	angle = global_position.direction_to(target)
	changeDirectionTimer.start()

func enable_attack(atk = true):
	if atk:
		collision.call_deferred("set","disabled",false)
		sprite.texture = spr_jav_atk
	else:
		collision.call_deferred("set","disabled",true)
		sprite.texture = spr_jav_reg

func _on_attack_timer_timeout():
	add_paths()

func _on_change_direction_timeout():
	if target_array.size() > 0:
		target_array.remove_at(0)
		if target_array.size() > 0:
			target = target_array[0]
			process_path()
			snd_attack.play()
			emit_signal("remove_from_array",self)
		else:
			enable_attack(false)
	else:
		changeDirectionTimer.stop()
		attackTimer.start()
		enable_attack(false)



