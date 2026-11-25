extends CanvasLayer

@onready var label_estrelas = $ContadorEstrelas/LabelEstrelas
@onready var barra_jogador = $BarraJogador
@onready var barra_boss = $BarraBoss

func _ready() -> void:
	_atualizar_estrelas(GameManager.total_estrelas)
	if not GameManager.estrelas_globais_mudaram.is_connected(_atualizar_estrelas):
		GameManager.estrelas_globais_mudaram.connect(_atualizar_estrelas)
		
	barra_boss.visible = false
	await get_tree().process_frame
	var jogador = get_tree().get_first_node_in_group("jogador")
	if jogador:
		jogador.vida_mudou.connect(_atualizar_jogador)
		_atualizar_jogador(jogador.vida, jogador.vida_max)
		jogador.estrelas_mudaram.connect(_atualizar_estrelas)
		_atualizar_estrelas(jogador.estrelas)
		
	var boss = get_tree().get_first_node_in_group("boss")
	if boss:
		boss.vida_mudou.connect(_atualizar_boss)
		boss.morreu.connect(func(): barra_boss.visible = false)

func _atualizar_jogador(atual, maxima):
	barra_jogador.max_value = maxima
	barra_jogador.value = atual

func _atualizar_boss(atual, maxima):
	barra_boss.visible = true
	barra_boss.max_value = maxima
	barra_boss.value = atual
	
func _atualizar_estrelas(total: int) -> void:
	label_estrelas.text = "x "	 + str(total)
