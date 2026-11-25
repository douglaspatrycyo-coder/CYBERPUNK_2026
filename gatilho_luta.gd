extends Area2D

@export var boss: Node

func _ready():
	body_entered.connect(_ao_entrar)

func _ao_entrar(corpo):
	if corpo.is_in_group("jogador") and boss:
		boss.ativar()
		queue_free()
