extends Node2D

const CENA_ESTRELA: PackedScene = preload("res://estrela.tscn")
@export var posicoes_estrelas: Array[Vector2] = [
	Vector2(190,75),
	Vector2(320,0),
	Vector2(445,75),
	Vector2(450,-70),
	Vector2(720,110)
]

func _ready():
	_instanciar_estrelas()
	var jogador = get_tree().get_first_node_in_group("jogador")
	if jogador and jogador.has_node("Camera2D"):
		var cam = jogador.get_node("Camera2D")
		cam.limit_left = 0
		cam.limit_top = -112
		cam.limit_right = 832
		cam.limit_bottom = 192

func _instanciar_estrelas():
	for pos in posicoes_estrelas:
		var estrela := CENA_ESTRELA.instantiate() as EstrelaColetavel
		if estrela:
			estrela.global_position = pos
			add_child(estrela)
