extends Node

func parse_json(path: String) -> JSON: # dictionary
	# json parse
	var file = FileAccess.open(path, FileAccess.READ)
	assert(FileAccess.file_exists(path),"File doesnt exist")
	var json = file.get_as_text()
	var json_object: JSON = JSON.new()

	json_object.parse(json)
	return json_object