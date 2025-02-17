class_name SaveData extends Resource

@export var high_scores: Array = []
@export var best_times: Array = []

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


func save_best_scores(player_score: Array) -> void:
	high_scores.append(player_score)
	
	if high_scores.size() > 1:
		high_scores.sort()
		high_scores.reverse()
	
	if high_scores.size() > 10:
		high_scores.pop_back()


func save_best_times(player_time: Array) -> void:
	best_times.append(player_time)
	
	if best_times.size() > 1:
		best_times.sort()
	
	if best_times.size() > 10:
		best_times.pop_back()
