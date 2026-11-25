extends Area2D

func _ready():
	area_entered.connect(_ao_ser_atingido)

func _ao_ser_atingido(area: Area2D):
	var dono = get_parent()
	if "dano" in area and dono.has_method("levar_dano"):
		dono.levar_dano(area.dano)
