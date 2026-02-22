extends Node

const DIALOG = {
	"cutscene_one":"res://assets/json/dialogue/cheese.json"
}

const LEVELS: Dictionary[String, PackedScene] = {
	"sewers": preload("uid://c86shht007ngr"),
}

const ENEMIES_EASY: Dictionary[String, PackedScene] = {
	"small_rat":preload("uid://dqfe3qn5ji0i5"),
	#"zombie_rat":""
}

const WEAPONS: Dictionary[String, PackedScene] = {
	"fork":preload("uid://cgit7jq7kxjxs")
}

const UI: Dictionary[String, String] = {
	"weapon_switcher":"uid://ciw5orhevh65f",
}