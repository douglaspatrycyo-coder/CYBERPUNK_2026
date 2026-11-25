extends Control

@export var titulo: String = "GAME OVER"

const CREDITOS = "Aluno: Douglas Patrício Silva
Personagem: [ansimuz] - [Creative Commons Zero v1.0 Universal]
Boss: [ansimuz] - [Free for commercial projects]
HUD: [Pupkin Assets] - [asset pack can be used.] e [Basic Pixel Health bar and Scroll bar] - [BDragon1727] - [Free to use on non-commercial games]
Cenários: [ansimuz] - [Free for commercial projects]
Efeitos sonoros: [Chequered Ink] - [Creative Commons CC0] Músicas: [David KBD] - [CC By 4.0]
Itens: [BDragon1727] - [Free to use on non-commercial games]"



@onready var label_titulo = $Titulo
@onready var label_creditos = $Creditos
@onready var botao = $BotaoReiniciar

func _ready():
	label_titulo.remove_theme_font_override("font")
	label_creditos.remove_theme_font_override("font")
	botao.remove_theme_font_override("font")
	botao.remove_theme_font_size_override("font_size")
	var fonte_segura := SystemFont.new()
	fonte_segura.font_names = PackedStringArray(["Arial", ["DejaVu Sans"]])
	fonte_segura.disable_embedded_bitmaps = false
	label_creditos.add_theme_font_override("font",fonte_segura)
	label_titulo.add_theme_font_override("font",fonte_segura)
	botao.add_theme_font_override("font", fonte_segura)
	label_titulo.text = titulo
	label_creditos.text = CREDITOS
	botao.pressed.connect(_reiniciar)
	
	
	
func _reiniciar():
	GameManager.total_estrelas = 0
	get_tree().change_scene_to_file("res://fase_0.tscn")
