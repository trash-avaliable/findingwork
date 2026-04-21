extends Area2D

@export var playerstates: Resource

@onready var left_eye = $LeftEye
@onready var right_eye = $RightEye

var move_speed := 200.0

func _process(delta):
	# 鼠标指向移动
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	var dist = global_position.distance_to(mouse_pos)
	if dist > 5:
		global_position += dir * move_speed * delta

	# 眼睛跟随鼠标偏移
	var eye_offset_y = 10
	left_eye.position = Vector2(6, eye_offset_y) + (mouse_pos - global_position).normalized() * 4
	right_eye.position = Vector2(10, eye_offset_y) + (mouse_pos - global_position).normalized() * 4
