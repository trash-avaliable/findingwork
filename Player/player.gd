extends CharacterBody2D  # 改为物理体

@export var playerstates: CharacterTemplate

@onready var left_eye: Panel = $Face/LeftEye
@onready var right_eye: Panel = $Face/RightEye
@onready var camera_2d: Camera2D = $Camera2D
@onready var rich_text_label: RichTextLabel = $CanvasLayer/RichTextLabel

@export var left_horizontal_sensitivity := 6.0      # 左眼水平最大偏移量
@export var right_horizontal_sensitivity := 10.0    # 右眼水平最大偏移量
@export var down_vertical_offset := 10.0            # 向下看时的垂直偏移
@export var up_vertical_offset := 10.0              # 向上看时的垂直偏移

var left_eye_base_pos: Vector2
var right_eye_base_pos: Vector2

func _ready() -> void:
	left_eye_base_pos = left_eye.position
	right_eye_base_pos = right_eye.position

	if not playerstates:
		if GameManager.instance and GameManager.instance.game_state:
			playerstates = GameManager.instance.game_state.player

func _physics_process(delta: float) -> void:
	# ----- 移动部分（物理驱动）-----
	var mouse_pos = get_global_mouse_position()
	var to_mouse = mouse_pos - global_position
	var dist = to_mouse.length()
	
	if dist > 5:
		var dir = to_mouse.normalized()
		velocity = dir * playerstates.speed
	else:
		velocity = Vector2.ZERO
	
	# 让物理引擎处理移动和碰撞
	move_and_slide()
	
	# ----- 眼睛偏移部分（仅视觉效果，放在 _process 或这里均可）-----
	_update_eye_offset(to_mouse)

func _process(delta: float) -> void:
	# 只保留非物理的视觉更新（眼睛偏移已在 _physics_process 中调用，这里也可留空）
	# 但为了逻辑清晰，眼睛偏移统一由 _physics_process 调用
	pass

func _update_eye_offset(to_mouse: Vector2) -> void:
	var dir = to_mouse.normalized() if to_mouse.length() > 0 else Vector2.ZERO
	var dist = to_mouse.length()
	
	# 根据鼠标水平方向决定左右眼灵敏度分配
	var left_h_sens: float
	var right_h_sens: float
	if dir.x > 0:  # 鼠标在右侧
		left_h_sens = right_horizontal_sensitivity   # 左眼（远离侧）幅度大
		right_h_sens = left_horizontal_sensitivity   # 右眼（靠近侧）幅度小
	else:          # 鼠标在左侧或正上/正下
		left_h_sens = left_horizontal_sensitivity
		right_h_sens = right_horizontal_sensitivity

	var left_offset_x = dir.x * left_h_sens
	var right_offset_x = dir.x * right_h_sens

	# 垂直偏移
	var vertical_offset: float
	if dir.y > 0:   # 向下看
		vertical_offset = dir.y * down_vertical_offset
	else:           # 向上看
		vertical_offset = dir.y * up_vertical_offset

	# 应用到基础位置
	left_eye.position = left_eye_base_pos + Vector2(left_offset_x, vertical_offset)
	right_eye.position = right_eye_base_pos + Vector2(right_offset_x, vertical_offset)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera_2d.zoom += Vector2(0.1, 0.1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera_2d.zoom -= Vector2(0.1, 0.1)
		camera_2d.zoom = camera_2d.zoom.clamp(Vector2(0.5, 0.5), Vector2(3.0, 3.0))
