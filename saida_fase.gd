extends Area2D

@export_file("*.tscn") var proxima_cena: String

func _ready():
	body_entered.connect(_ao_entrar)

func _ao_entrar(corpo):
	if corpo.is_in_group("jogador"):
		set_deferred("monitoring", false)
		Transicao.mudar_cena("res://fase_1.tscn")
		get_tree().change_scene_to_file.call_deferred(proxima_cena)
