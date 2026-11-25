extends CanvasLayer

@onready var fundo_preto : ColorRect = $FundoPreto
var em_transicao : bool = false

func mudar_cena (_caminho_cena: String, duracao: float = 0.35) -> void:
	if em_transicao:
		return
	em_transicao = true
	
	var tween_saida = create_tween()
	tween_saida.tween_property(fundo_preto, "color:a",1.0, duracao)
	await tween_saida.finished
	
	get_tree().change_scene_to_file("res://fase_1.tscn")
	
	await get_tree().process_frame
	var tween_entrada = create_tween()
	tween_entrada.tween_property(fundo_preto, "color:a",0.0, duracao)
	await tween_entrada.finished
	
	em_transicao = false
	
