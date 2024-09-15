extends Bulletin


var prompt_text := ""


func initialize(prompt: String) -> void:
	prompt_text = prompt


func _ready() -> void:
	$Label.text = prompt_text
