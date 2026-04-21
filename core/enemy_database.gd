# enemy_database.gd (AutoLoad)
extends Node

var enemies: Dictionary = {}      # key = id, value = EnemyData
var wave_config: Dictionary = {}

func _ready():
	load_all_enemy_data()
	load_wave_config()

func load_all_enemy_data():
	# 确保目录存在
	if not DirAccess.dir_exists_absolute("res://data/enemies"):
		DirAccess.make_dir_recursive_absolute("res://data/enemies")
		return

	var dir = DirAccess.open("res://data/enemies")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var path = "res://data/enemies/" + file_name
				var data = ResourceLoader.load(path) as EnemyData
				if data:
					enemies[data.id] = data
			file_name = dir.get_next()

func load_wave_config():
	var config_path = "res://config/waves.json"
	if not FileAccess.file_exists(config_path):
		# 如果不存在，可以创建一个默认的或记录日志
		print("Wave config not found at: ", config_path)
		return

	var file = FileAccess.open(config_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(content)
		if error == OK:
			wave_config = json.data
		else:
			print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
