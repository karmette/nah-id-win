extends AudioStreamPlayer

const SONGS = {
	"start":preload("uid://dkl6unk2sc5vs"),
	"loop":preload("uid://0hfme686hwag"),
	"journey":preload("uid://ba5p261c00xx6"),
	"shimmer":preload("uid://847n3xff0ev8")
}

func _ready():
	SignalBus.play_music.connect(play_song)


func play_song(s: String):
	if s == "start":
		stream = SONGS.start
		play()
		await finished
		stream = SONGS.loop
		play()
	else:
		stream = SONGS.get(s)
		play()