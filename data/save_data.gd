class_name SaveData extends Resource

@export var high_scores: Dictionary

const SAVE_PATH = "user://saves_data.tres"

func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)

static func load_save_file() -> SaveData:
	var res: SaveData
	
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH) as SaveData
	else:
		res = SaveData.new()
		
	return res
