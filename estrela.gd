extends Area2D
class_name EstrelaColetavel

@onready var som_estrela = $SomEstrela
@export var valor_pontos: int = 1

func _ready():
	$AnimatedSprite2D.play('default')
	body_entered.connect(_ao_coletar)
	
func _ao_coletar(corpo):
	if corpo.is_in_group("jogador"):
		set_deferred("monitoring",false)
		$AnimatedSprite2D.visible = false
		if corpo.has_method("coletar_estrela"):
			corpo.coletar_estrela(valor_pontos)
		som_estrela.play()
		await som_estrela.finished
		queue_free()
		
		
		
