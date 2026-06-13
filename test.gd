extends Control
# This script demonstrates how to alter StyleBoxes at runtime.
# Custom theme item properties aren't considered Object properties per se.
# This means that you should use `add_theme_stylebox_override("normal", ...)`
# instead of `set("custom_styles/normal", ...)`.

@onready var label = $Panel/MarginContainer/VBoxContainer/Label
@onready var button = $Panel/MarginContainer/VBoxContainer/Button
@onready var button2 = $Panel/MarginContainer/VBoxContainer/Button2
@onready var reset_all_button = $Panel/MarginContainer/VBoxContainer/ResetAllButton
@onready var resultado = null

var corrida_atual = 1
var total_corridas = 12

var pontuacao = [25,18,15,12,10,8,6,4,2,1]
var construtores = {
	"McLaren":{"pontos":0,"abandonos":0},
	"Ferrari":{"pontos":0,"abandonos":0},
	"Williams":{"pontos":0,"abandonos":0},
	"Benetton":{"pontos":0,"abandonos":0},
	"Tyrrell":{"pontos":0,"abandonos":0},
	"Lotus":{"pontos":0,"abandonos":0},
	"Ligier":{"pontos":0,"abandonos":0},
	"Arrows":{"pontos":0,"abandonos":0},
	"Minardi":{"pontos":0,"abandonos":0},
	"Larrousse":{"pontos":0,"abandonos":0}
}
var pilotos = [

{"nome":"Senna","equipe":"McLaren","velocidade":95,"consistencia":92,"agressividade":90,"motor":95,"cambio":94,"pontos":0,"abandonos":0},
{"nome":"Berger","equipe":"McLaren","velocidade":88,"consistencia":86,"agressividade":80,"motor":92,"cambio":92,"pontos":0,"abandonos":0},

{"nome":"Prost","equipe":"Ferrari","velocidade":94,"consistencia":96,"agressividade":60,"motor":95,"cambio":95,"pontos":0,"abandonos":0},
{"nome":"Mansell","equipe":"Ferrari","velocidade":91,"consistencia":84,"agressividade":88,"motor":90,"cambio":91,"pontos":0,"abandonos":0},

{"nome":"Piquet","equipe":"Williams","velocidade":92,"consistencia":90,"agressividade":75,"motor":94,"cambio":94,"pontos":0,"abandonos":0},
{"nome":"Patrese","equipe":"Williams","velocidade":85,"consistencia":88,"agressividade":70,"motor":93,"cambio":93,"pontos":0,"abandonos":0},

{"nome":"Schumacher","equipe":"Benetton","velocidade":90,"consistencia":82,"agressividade":95,"motor":91,"cambio":91,"pontos":0,"abandonos":0},
{"nome":"Brundle","equipe":"Benetton","velocidade":84,"consistencia":86,"agressividade":72,"motor":91,"cambio":91,"pontos":0,"abandonos":0},

{"nome":"Alesi","equipe":"Tyrrell","velocidade":89,"consistencia":80,"agressividade":92,"motor":87,"cambio":88,"pontos":0,"abandonos":0},
{"nome":"Nakajima","equipe":"Tyrrell","velocidade":77,"consistencia":82,"agressividade":65,"motor":87,"cambio":88,"pontos":0,"abandonos":0},

{"nome":"Herbert","equipe":"Lotus","velocidade":82,"consistencia":79,"agressividade":82,"motor":85,"cambio":85,"pontos":0,"abandonos":0},
{"nome":"Warwick","equipe":"Lotus","velocidade":80,"consistencia":84,"agressividade":70,"motor":85,"cambio":85,"pontos":0,"abandonos":0},

{"nome":"Boutsen","equipe":"Ligier","velocidade":81,"consistencia":85,"agressividade":68,"motor":86,"cambio":86,"pontos":0,"abandonos":0},
{"nome":"Laffite","equipe":"Ligier","velocidade":79,"consistencia":83,"agressividade":65,"motor":86,"cambio":86,"pontos":0,"abandonos":0},

{"nome":"Caffi","equipe":"Arrows","velocidade":78,"consistencia":80,"agressividade":75,"motor":84,"cambio":84,"pontos":0,"abandonos":0},
{"nome":"Suzuki","equipe":"Arrows","velocidade":75,"consistencia":78,"agressividade":70,"motor":84,"cambio":84,"pontos":0,"abandonos":0},

{"nome":"Morbidelli","equipe":"Minardi","velocidade":74,"consistencia":79,"agressividade":68,"motor":82,"cambio":82,"pontos":0,"abandonos":0},
{"nome":"Gugelmin","equipe":"Minardi","velocidade":76,"consistencia":81,"agressividade":72,"motor":82,"cambio":82,"pontos":0,"abandonos":0},

{"nome":"Bernard","equipe":"Larrousse","velocidade":73,"consistencia":77,"agressividade":67,"motor":80,"cambio":80,"pontos":0,"abandonos":0},
{"nome":"Gachot","equipe":"Larrousse","velocidade":72,"consistencia":76,"agressividade":69,"motor":80,"cambio":80,"pontos":0,"abandonos":0}
]

func _ready():
	resultado = $Panel/MarginContainer/VBoxContainer/Label2
	print(resultado)
	resultado.visible = true
	resultado.text = ("Jogo iniciado")
	
	# Focus the first button automatically for keyboard/controller-friendly navigation.
	button.grab_focus()
	print("JOGO INICIOU")
	#var resultado = get_node("VBoxContainer/RichTextLabel")
	#resultado.text = "Jogo iniciado"

	#var botao = get_node("VBoxContainer/Button")
	#botao.pressed.connect(_clicou)
#func _clicou():
	#var resultado = get_node("VBoxContainer/RichTextLabel")
	#resultado.text = "BOTÃO FUNCIONOU!"

func _on_button_pressed():
	# We have to modify the normal, hover and pressed styleboxes all at once
	# to get a correct appearance when the button is hovered or pressed.
	# We can't use a single StyleBox for all of them as these have different
	# background colors.
	var new_stylebox_normal = button.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.border_color = Color(1, 1, 0)
	var new_stylebox_hover = button.get_theme_stylebox("hover").duplicate()
	new_stylebox_hover.border_color = Color(1, 1, 0)
	var new_stylebox_pressed = button.get_theme_stylebox("pressed").duplicate()
	new_stylebox_pressed.border_color = Color(1, 1, 0)

	button.add_theme_stylebox_override("normal", new_stylebox_normal)
	button.add_theme_stylebox_override("hover", new_stylebox_hover)
	button.add_theme_stylebox_override("pressed", new_stylebox_pressed)

	label.add_theme_color_override("font_color", Color(1, 1, 0.5))
	
	var resultado_corrida = []
	if corrida_atual > total_corridas:

		resultado.text = "TEMPORADA ENCERRADA\n\nClique em Ver Classificação"

		return

	for piloto in pilotos:

		var status = "OK"

		# Quebra de motor
		if randi_range(1,1000) > piloto.motor * 10:
			status = "MOTOR"

		# Quebra de câmbio
		elif randi_range(1,1000) > piloto.cambio * 10:
			status = "CAMBIO"

		# Acidente
		elif randi_range(1,100) <= piloto.agressividade / 4:
			status = "ACIDENTE"

		if status != "OK":

			resultado_corrida.append({
				"ref": piloto,
				"status": status,
				"valor": -9999
			})
			piloto.abandonos += 1
			construtores[piloto.equipe].abandonos += 1
			continue

		# Velocidade base
		var desempenho = piloto.velocidade

		# Consistência
		var variacao = randi_range(
			-(100 - piloto.consistencia),
			100 - piloto.consistencia
		)

		desempenho += variacao

		# Agressividade pode render ganho extra
		if randi_range(1,100) <= piloto.agressividade:
			desempenho += randi_range(0,10)

		resultado_corrida.append({
			"ref": piloto,
			"status": status,
			"valor": desempenho
		})
		
	resultado_corrida.sort_custom(func(a,b):
		return a.valor > b.valor
	)
	
	#fim bloco for pilotos
	for i in range(min(10, resultado_corrida.size())):

		if resultado_corrida[i].status != "OK":
			continue

		var piloto = resultado_corrida[i].ref

		piloto.pontos += pontuacao[i]

		construtores[piloto.equipe].pontos += pontuacao[i]

	var texto = ""

	texto += "CORRIDA "
	texto += str(corrida_atual)
	texto += "/"
	texto += str(total_corridas)
	texto += "\n\n"

	texto += "RESULTADO\n\n"
	
	#resultado
	for i in range(resultado_corrida.size()):

		var piloto = resultado_corrida[i].ref

		if resultado_corrida[i].status != "OK":

			texto += piloto.nome
			texto += " - "
			texto += resultado_corrida[i].status
			texto += "\n"

		else:

			texto += str(i+1)
			texto += "º - "
			texto += piloto.nome
			texto += "\n"

	texto += "\nCAMPEONATO\n\n"

	var campeonato = pilotos.duplicate()

	campeonato.sort_custom(func(a,b):
		return a.pontos > b.pontos
	)

	for i in range(campeonato.size()):

		texto += str(i+1)
		texto += "º "
		texto += campeonato[i].nome
		texto += " - "
		texto += str(campeonato[i].pontos)
		texto += " pts"

		texto += " ("
		texto += str(campeonato[i].abandonos)
		texto += " abd)"

		texto += "\n"
	
	texto += "\n\nCONSTRUTORES\n\n"
	var ranking_construtores = []

	for equipe in construtores:

		ranking_construtores.append({
			"nome": equipe,
			"pontos": construtores[equipe].pontos,
			"abandonos": construtores[equipe].abandonos
		})

	ranking_construtores.sort_custom(func(a,b):
		return a.pontos > b.pontos
	)
		
	for i in range(ranking_construtores.size()):

		texto += str(i+1)
		texto += "º "

		texto += ranking_construtores[i].nome

		texto += " - "

		texto += str(ranking_construtores[i].pontos)

		texto += " pts"

		texto += " ("

		texto += str(ranking_construtores[i].abandonos)

		texto += " abd)"

		texto += "\n"
	resultado.text = texto

	corrida_atual += 1

	print(texto)

func mostrar_classificacao_pilotos():

	var texto = "CLASSIFICAÇÃO PILOTOS\n\n"

	var campeonato = pilotos.duplicate()

	campeonato.sort_custom(func(a,b):
		return a.pontos > b.pontos
	)

	for i in range(campeonato.size()):

		texto += str(i+1)
		texto += "º "

		texto += campeonato[i].nome

		texto += " - "

		texto += str(campeonato[i].pontos)

		texto += " pts"

		texto += " ("

		texto += str(campeonato[i].abandonos)

		texto += " abd)"

		texto += "\n"

	resultado.text = texto
func _on_button2_pressed():
	var new_stylebox_normal = button2.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.border_color = Color(0, 1, 0.5)
	var new_stylebox_hover = button2.get_theme_stylebox("hover").duplicate()
	new_stylebox_hover.border_color = Color(0, 1, 0.5)
	var new_stylebox_pressed = button2.get_theme_stylebox("pressed").duplicate()
	new_stylebox_pressed.border_color = Color(0, 1, 0.5)

	button2.add_theme_stylebox_override("normal", new_stylebox_normal)
	button2.add_theme_stylebox_override("hover", new_stylebox_hover)
	button2.add_theme_stylebox_override("pressed", new_stylebox_pressed)

	label.add_theme_color_override("font_color", Color(0.5, 1, 0.75))
	mostrar_classificacao_pilotos()

func mostrar_classificacao_construtores():

	var texto = "CLASSIFICAÇÃO CONSTRUTORES\n\n"

	var ranking_construtores = []

	for equipe in construtores:

		ranking_construtores.append({
			"nome": equipe,
			"pontos": construtores[equipe].pontos,
			"abandonos": construtores[equipe].abandonos
		})

	ranking_construtores.sort_custom(func(a,b):
		return a.pontos > b.pontos
	)

	for i in range(ranking_construtores.size()):

		texto += str(i+1)
		texto += "º "

		texto += ranking_construtores[i].nome

		texto += " - "

		texto += str(ranking_construtores[i].pontos)

		texto += " pts"

		texto += " ("

		texto += str(ranking_construtores[i].abandonos)

		texto += " abd)"

		texto += "\n"

	resultado.text = texto
func _on_reset_all_button_pressed():
	button.remove_theme_stylebox_override("normal")
	button.remove_theme_stylebox_override("hover")
	button.remove_theme_stylebox_override("pressed")

	button2.remove_theme_stylebox_override("normal")
	button2.remove_theme_stylebox_override("hover")
	button2.remove_theme_stylebox_override("pressed")

	label.remove_theme_color_override("font_color")
	
	mostrar_classificacao_construtores()
