extends CharacterBody2D

signal vida_mudou(atual, maxima)
signal morreu

const TIRO_BOSS = preload("res://tiro_boss.tscn")
const EXPLOSAO = preload("res://explosao.tscn")


@export var vida_max: float = 25
@export var velocidade: float = 40.0
@export var alcance: float = 40.0
@export var intervalo_tiro: float = 2.0
@export var area_explosoes: Vector2 = Vector2(160, 60)

var gravidade = ProjectSettings.get_setting("physics/2d/default_gravity")
var vida: float
var ativo: bool = false
var morto: bool = false
var x_inicial: float
var direcao: int = -1
var tempo_tiro: float = 1.5

@onready var anim = $AnimatedSprite2D
@onready var ponta = $Ponta
@onready var som_dano = $SomDano
@onready var som_tiro = $SomTiro
@onready var som_explosao = $SomExplosao

func _ready():
	vida = vida_max
	x_inicial = global_position.x
	add_to_group("boss")
	anim.play("andar")

func ativar():
	if ativo:
		return
	ativo = true
	vida_mudou.emit(vida, vida_max)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravidade * delta

	if ativo and not morto:
		velocity.x = direcao * velocidade
		if global_position.x < x_inicial - alcance:
			direcao = 1
		elif global_position.x > x_inicial + alcance:
			direcao = -1

		tempo_tiro -= delta
		if tempo_tiro <= 0:
			atirar()
			tempo_tiro = intervalo_tiro
	else:
		velocity.x = 0

	move_and_slide()

func atirar():
	var tiro = TIRO_BOSS.instantiate()
	tiro.direcao = -1.0
	get_tree().current_scene.add_child(tiro)
	tiro.global_position = ponta.global_position
	som_tiro.play()

func levar_dano(valor: float):
	if morto:
		return
	ativar()
	vida = max(vida - valor, 0.0)
	vida_mudou.emit(vida, vida_max)
	som_dano.play()
	piscar_dano()
	if vida <= 0:
		morrer()

func piscar_dano():
	anim.modulate = Color(1, 0.3, 0.3)
	var t = create_tween()
	t.tween_property(anim, "modulate", Color.WHITE, 0.15)

func morrer():
	som_explosao.play()
	morto = true
	morreu.emit()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)

	for i in range(6):
		var desloc = Vector2(
			randf_range(-area_explosoes.x / 2, area_explosoes.x / 2),
			randf_range(-area_explosoes.y / 2, area_explosoes.y / 2))
		criar_explosao(desloc, randf_range(0.5, 0.9))
		await get_tree().create_timer(0.18).timeout

	criar_explosao(Vector2.ZERO, 1.3)
	await get_tree().create_timer(0.35).timeout
	anim.visible = false
	await get_tree().create_timer(0.6).timeout
	queue_free()

func criar_explosao(desloc: Vector2, escala: float):
	var e = EXPLOSAO.instantiate()
	get_tree().current_scene.add_child(e)
	e.global_position = global_position + desloc
	e.scale = Vector2.ONE * escala
