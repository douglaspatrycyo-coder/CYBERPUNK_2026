extends Area2D

@export var escala_normal: float = 0.5
@export var escala_carregado: float = 1.5 
@export var velocidade: float = 600.0
var direcao: Vector2 = Vector2.RIGHT
var dano: float = 1.0
var eh_carregado: bool = false

@export var som_normal: AudioStream
@export var som_carregado: AudioStream

@onready var animated_sprite = $AnimatedSprite2D
@onready var audio_player = $AudioStreamPlayer2D

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)
	
	area_entered.connect(func(_a): queue_free())
	body_entered.connect(_ao_bater_em_corpo)
	
	if eh_carregado:
		animated_sprite.play("carregado")
		dano = 3.0
		animated_sprite.flip_h = (direcao.x < 0)
		scale = Vector2.ONE * escala_carregado
		
		if som_carregado:
			audio_player.stream = som_carregado
			audio_player.play()
			
	else:
		animated_sprite.play("normal")
		dano = 1.0
		animated_sprite.flip_h = (direcao.x > 0)
		scale = Vector2.ONE * escala_normal
		
		if som_normal:
			audio_player.stream = som_normal
			audio_player.play()
		
func _ao_bater_em_corpo(corpo):
	if corpo.is_in_group("jogador"):
		return
	queue_free()
		
func _process(delta: float) -> void:
	position += direcao * velocidade * delta

func _on_screen_exited() -> void:
	queue_free()
