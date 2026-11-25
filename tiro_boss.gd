extends Area2D

@export var velocidade: float = 160.0
@export var dano: float = 1.0
@export var escala: float = 0.6

var direcao: float = -1.0
var vida: float = 4.0

func _ready():
	scale = Vector2(-escala if direcao < 0 else escala, escala)
	$AnimatedSprite2D.play("voar")
	area_entered.connect(func(_a): queue_free())
	body_entered.connect(func(_b): queue_free())

func _physics_process(delta):
	position.x += direcao * velocidade * delta
	vida -= delta
	if vida <= 0:
		queue_free()
