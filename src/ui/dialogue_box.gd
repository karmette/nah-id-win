extends Control

@onready var text_label: RichTextLabel = $DialogueBox/DialogueText
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
var timer: Timer

var letter_time: float = 0.03
var space_time: float = 0.06
var puncuation_time: float = 0.2

var diag_finished: bool = false

signal skip # may replace?
signal next_d

func _ready() -> void:
	self.visible = false
	timer = Timer.new()
	self.add_child.call_deferred(timer)
	signal_connect.call_deferred()

func signal_connect():
	timer.timeout.connect(_on_letter_display_timer_timeout)
	SignalBus.start_dialogue.connect(dialogue_sequence)
	skip.connect(skip_dialogue)

func skip_dialogue():
	text_label.visible_characters = text_label.text.length()
	diag_finished = true

func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		# emit the Timer's timeout signal so awaiting code resumes
		timer.emit_signal("timeout")
		if diag_finished:
			next_d.emit()
		else:
			skip.emit()

func dialogue_sequence(c: String):
	self.visible = true
	var diag = JsonHelper.parse_json(Constants.DIALOG.get(c)).data.nodes
	for line in diag:
		diag_finished = false
		text_label.visible_characters = -1
		text_label.text = line.text
		_display_letter()
		await get_tree().create_timer(5).timeout
	SignalBus.cutscene_finished.emit()
	self.visible = false

func _display_letter():
	text_label.visible_characters += 1
	if text_label.visible_characters >= text_label.text.length():
		diag_finished = true
		return
	match text_label.text[text_label.visible_characters]:
		"!", ".", ",", "?":
			timer.start(puncuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			audio_player.play()


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
