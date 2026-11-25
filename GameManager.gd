extends Node

signal estrelas_globais_mudaram(total:int)
var total_estrelas : int = 0:
	set (valor):
		total_estrelas = valor
		estrelas_globais_mudaram.emit(total_estrelas)
		
func adicionar_estrelas(qtd: int) -> void:
	total_estrelas += qtd
