extends Node

var player: CharacterBody2D

signal start_dialogue(s: String) # pass dialogue name in constants

signal toggle_attacking(state: bool)
