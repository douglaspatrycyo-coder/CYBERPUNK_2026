extends CharacterBody2D

const VELOCIDADE = 200.0
const FORCA_PULO = -400.0
const TIRO_SCENE = preload("res://tiro.tscn")
const SOM_NORMAL = preload("res://audio/tiro_normal.mp3")

@onready var som_dano = $SomDano

@export var atraso_som_carga: float = 0.15
var som_carga_tocando: bool = false

@onready var som_tiro = $SomTiro
@onready var som_carga = $SomCarga

@export var tempo_para_carregar: float = 0.5

signal vida_mudou(atual, maxima)
signal estrelas_mudaram(total)
var estrelas : int = 0
signal morreu

@export var vida_max: float = 5.0
var vida: float
var morto: bool = false
var tempo_dano: float = 0.0
var tempo_invencivel: float = 0.0

var gravidade = ProjectSettings.get_setting("physics/2d/default_gravity")
var tempo_pressionado: float = 0.0
var esta_segurando: bool = false
var tempo_pose_tiro: float = 0.0

@onready var anim = $AnimatedSprite2D
@onready var ponta = $Ponta

func _ready() -> void:
	vida = vida_max
	add_to_group("jogador")
	estrelas = GameManager.total_estrelas
	estrelas_mudaram.emit(estrelas)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravidade * delta

	var direcao = 0.0
	if morto:
		velocity.x = 0
	elif tempo_dano <= 0:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = FORCA_PULO
		direcao = Input.get_axis("ui_left", "ui_right")
		velocity.x = direcao * VELOCIDADE

	tempo_dano = max(tempo_dano - delta, 0.0)
	tempo_pose_tiro = max(tempo_pose_tiro - delta, 0.0)
	atualizar_invencibilidade(delta)
	atualizar_animacao(direcao)
	move_and_slide()

func _process(delta: float) -> void:
	if esta_segurando:
		tempo_pressionado += delta
		if not som_carga_tocando and tempo_pressionado >= atraso_som_carga:
			som_carga_tocando = true
			som_carga.play(1.2)

func _unhandled_input(event: InputEvent) -> void:
	if morto:
		return
	if event.is_action_pressed("atirar") and tempo_dano <= 0:
		esta_segurando = true
		tempo_pressionado = 0.0
		som_carga_tocando = false
	elif event.is_action_released("atirar") and esta_segurando:
		esta_segurando = false
		som_carga.stop()
		som_carga_tocando = false
		atirar(tempo_pressionado >= tempo_para_carregar)

func atirar(carregado: bool) -> void:
	var dir = -1 if anim.flip_h else 1
	var instancia_tiro = TIRO_SCENE.instantiate()

	instancia_tiro.eh_carregado = carregado
	instancia_tiro.direcao = Vector2(dir, 0)

	get_tree().current_scene.add_child(instancia_tiro)

	instancia_tiro.global_position = global_position + Vector2(ponta.position.x * dir, ponta.position.y)

	som_tiro.stream = SOM_NORMAL
	som_tiro.play(0.67)

	tempo_pose_tiro = 0.25

func atualizar_animacao(direcao: float):
	if morto or tempo_dano > 0:
		anim.play("dano")
		return
		
	if direcao != 0:
		anim.flip_h = direcao < 0

	if not is_on_floor():
		if velocity.y < 0:
			anim.play("pular")
		else:
			anim.play("cair")
	elif direcao != 0:
		anim.play("correr")
	elif tempo_pose_tiro > 0:
		anim.play("atirar")
	else:
		anim.play("parado")

func levar_dano(valor: float):
	if morto or tempo_invencivel > 0:
		return
	vida = max(vida - valor, 0.0)
	vida_mudou.emit(vida, vida_max)
	som_dano.play()
	esta_segurando = false
	som_carga.stop()
	som_carga_tocando = false
	if vida <= 0:
		morrer()
		return
	tempo_dano = 0.3
	tempo_invencivel = 1.0
	var lado = 1 if anim.flip_h else -1
	velocity = Vector2(lado * 120, -150)
	
func morrer():
	morto = true
	morreu.emit()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://game_over.tscn")

func atualizar_invencibilidade(delta):
	if tempo_invencivel > 0:
		tempo_invencivel = max(tempo_invencivel - delta, 0.0)
		anim.modulate.a = 0.35 if int(tempo_invencivel * 20) % 2 == 0 else 1.0
	else:
		anim.modulate.a = 1.0

func coletar_estrela(valor: int) -> void:
	GameManager.adicionar_estrelas(valor)
	estrelas = GameManager.total_estrelas
	estrelas_mudaram.emit(estrelas)
