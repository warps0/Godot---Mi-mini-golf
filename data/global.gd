extends Node

var save_data: SaveData

func _ready() -> void:
	save_data = SaveData.load_save_file()
