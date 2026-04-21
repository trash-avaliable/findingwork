extends Area2D

@export var playerstates: CharacterTemplate

@onready var left_eye = $LeftEye
@onready var right_eye = $RightEye

func _ready() -> void:
	if not playerstates:
		# 如果没有导出，尝试从全局状态获取
		if GameManager.instance and GameManager.instance.game_state:
			playerstates = GameManager.instance.game_state.player

func _process(delta: float) -> void:
	if not playerstates: return
	
	# 鼠标指向移动
	var mouse_pos = get_global_mouse_position()
	var to_mouse = mouse_pos - global_position
	var dir = to_mouse.normalized()
	var dist = to_mouse.length()
	
	# 只有当距离足够远时才移动
	if dist > 5:
		global_position += dir * playerstates.speed * delta

	# 眼睛跟随鼠标且偏移量如同举例
	# 举例：玩家向左移动则左眼x轴偏移量为6，右眼x轴偏移量为10，y轴偏移量都是10
	var eye_offset_y = 10.0
	var left_eye_base_x = 6.0
	var right_eye_base_x = 10.0
	
	# 根据移动方向调整基础偏移（这里假设向右移动时偏移取反，或者保持对称）
	# 文档只给了向左的例子。通常向右应该是镜像的。
	if dir.x > 0: # 向右移动
		left_eye_base_x = -10.0
		right_eye_base_x = -6.0
	else: # 向左移动
		left_eye_base_x = 6.0
		right_eye_base_x = 10.0
		
	# 眼睛还需要稍微跟随鼠标视线
	var look_dir = dir * 2.0 # 视线微调
	
	left_eye.position = Vector2(left_eye_base_x, eye_offset_y) + look_dir
	right_eye.position = Vector2(right_eye_base_x, eye_offset_y) + look_dir
