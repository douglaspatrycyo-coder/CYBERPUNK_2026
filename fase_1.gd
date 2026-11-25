extends Node2D

func _ready():
	var jogador = get_tree().get_first_node_in_group("jogador")
	if jogador and jogador.has_node("Camera2D"):
		var cam = jogador.get_node("Camera2D")
		cam.limit_left = 0
		cam.limit_top = 0
		cam.limit_right = 1248
		cam.limit_bottom = 176
	var boss = get_tree().get_first_node_in_group("boss")
	if boss:
		boss.morreu.connect(_ao_boss_morrer)
		
func _ao_boss_morrer():
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://vitoria.tscn")
