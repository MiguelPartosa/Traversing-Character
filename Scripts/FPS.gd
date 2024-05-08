extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(self.font)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var fontsize = LabelSettings.get_font_size
	#print(font)
	var fps = Engine.get_frames_per_second()
	set_text("FPS: " + str(fps))
	
