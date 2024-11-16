extends Node

var nodedata = {}  # Dictionary for the first JSON file
var enemydata = {}  # Dictionary for the second JSON file

var node_data_file_path = "res://nodedata.json"
var enemy_data_file_path = "res://enemydata.json"  # Path to the second JSON file

func _ready():
	# Load data from both JSON files
	nodedata = load_json_file(node_data_file_path)
	enemydata = load_json_file(enemy_data_file_path)  # Load the second JSON file into a new dictionary

# Function to load a JSON file and return a dictionary
func load_json_file(filePath : String) -> Dictionary:
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			# Example: Ensure specific fields like "Node" and "StarNum" are strings if necessary
			for key in parsedResult.keys():
				if parsedResult[key].has("Node"):
					parsedResult[key]["Node"] = str(parsedResult[key]["Node"])  # Convert "Node" to string
				if parsedResult[key].has("StarNum"):
					parsedResult[key]["StarNum"] = str(parsedResult[key]["StarNum"])  # Convert "StarNum" to string
					
			return parsedResult
		else:
			print("Error reading file: %s" % filePath)
			return {}
	else:
		print("File does not exist: %s" % filePath)
		return {}
