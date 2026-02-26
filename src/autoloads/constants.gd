extends Node

const SCENES: Dictionary[String, String] = {
	"main_game":"uid://c722daqyojicv",
	"cutscene_one":"uid://cenyyrkjnngh6"
}

const PICKUP = preload("uid://c3mcpfn2t5j81")

const PICKUPS = {
	"fork":preload("uid://dxvhrja3viy1k"),
	"blue_cheese":preload("uid://hr7ewnrdssff"),
	"milk":preload("uid://drs7pf5j0adgu")
}

const DIALOG = {
	"cutscene_one":"res://assets/json/dialogue/cheese.json",
	"cutscene_two":"res://assets/json/dialogue/cutscene2.json",
	"cutscene_three":"res://assets/json/dialogue/cutscene3.json"
}

const LEVELS: Dictionary[String, PackedScene] = {
	"sewers": preload("uid://c86shht007ngr"),
	"sewers2": preload("uid://qy1pisqcumtx")
}

const ENEMIES: Dictionary[String, PackedScene] = {
	"basic_rat":preload("uid://dqfe3qn5ji0i5"),
	"fast_rat":preload("uid://cu0a6br33xy46"),
	"bomb_rat":preload("uid://q75deiw45po4")
}

const WEAPONS: Dictionary[String, PackedScene] = {
	"fork":preload("uid://cgit7jq7kxjxs"),
}

const UI: Dictionary[String, String] = {
	"weapon_switcher":"uid://ciw5orhevh65f",
}
