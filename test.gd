extends Control
# This script demonstrates how to alter StyleBoxes at runtime.
# Custom theme item properties aren't considered Object properties per se.
# This means that you should use `add_theme_stylebox_override("normal", ...)`
# instead of `set("custom_styles/normal", ...)`.

@onready var label = $Panel/MarginContainer/VBoxContainer/Label
@onready var button = $Panel/MarginContainer/VBoxContainer/TabContainer/Principal/Button
@onready var button2 = $Panel/MarginContainer/VBoxContainer/TabContainer/Principal/Button2
@onready var reset_all_button = $Panel/MarginContainer/VBoxContainer/TabContainer/Principal/ResetAllButton
@onready var button4 = $Panel/MarginContainer/VBoxContainer/TabContainer/Principal/Button4
@onready var resultado = null

@onready var tab_container = $Panel/MarginContainer/VBoxContainer/TabContainer
@onready var classificacao_texto = $"Panel/MarginContainer/VBoxContainer/TabContainer/Temporada Atual/ClassificacaoTexto"
# --- NOVAS REFERÊNCIAS DE ABAS DENTRO DO TABCONTAINER ---
@onready var main_menu_container = $"Panel/MarginContainer/VBoxContainer/TabContainer/Menu Principal"
@onready var btn_start_game = $"Panel/MarginContainer/VBoxContainer/TabContainer/Menu Principal/BtnStartGame"
@onready var btn_load_game = $"Panel/MarginContainer/VBoxContainer/TabContainer/Menu Principal/BtnLoadGame"
@onready var btn_options = $"Panel/MarginContainer/VBoxContainer/TabContainer/Menu Principal/BtnOptions"

@onready var modal_setup = $"Panel/MarginContainer/VBoxContainer/TabContainer/Configuração Inicial"
@onready var opt_ano = $"Panel/MarginContainer/VBoxContainer/TabContainer/Configuração Inicial/OptAno"
@onready var opt_equipe = $"Panel/MarginContainer/VBoxContainer/TabContainer/Configuração Inicial/OptEquipe"
@onready var opt_piloto_player = $"Panel/MarginContainer/VBoxContainer/TabContainer/Configuração Inicial/OptPilotoPlayer"
@onready var lbl_preview_pilotos = $"Panel/MarginContainer/VBoxContainer/TabContainer/Configuração Inicial/LblPreviewPilotos"
@onready var btn_confirmar_setup = $"Panel/MarginContainer/VBoxContainer/TabContainer/Configuração Inicial/BtnConfirmarSetup"

# --- CONFIGURAÇÃO DE CONTROLE E ABAS ---
var equipe_controlada: String = ""
var piloto_controlado: String = ""
@onready var seletor_piloto = $"Panel/MarginContainer/VBoxContainer/TabContainer/Histórico da Carreira/SeletorPiloto"
@onready var historico_texto = $"Panel/MarginContainer/VBoxContainer/TabContainer/Histórico da Carreira/HistoricoTexto"

var corrida_atual = 1
#TODO melhoria: adicionar mais corridas por temporada, incrementando ate 20 ou 22, para maior realismo
#TODO mover para um arquivo fatores_simulacao.json
var total_corridas = 16

var noticias = []
var simulação_em_massa = false

var recorde_vitorias = 0
var recordista_vitorias = ""

var recorde_abandonos = 0
var recordista_abandonos = ""

#TODO melhoria: adicionar pontuação para construtores
#TODO melhoria: adicionar pontuação extra para pole position, volta mais rápida, etc.
#TODO melhoria: mover pontuação para um arquivo fatores_simulacao.json
#var pontuacao = [25,18,15,12,10,8,6,4,2,1]
var pontuacao = [10,6,4,3,2,1,0,0,0,0]
# Variáveis que armazenarão os dados carregados dos arquivos externos
var construtores : Dictionary = {}
var poolPilotos : Array = []
var pilotos : Array = []
var fatores_simulacao : Dictionary = {}

# Caminhos dos arquivos de configuração
# TODO melhoria proposta adcionar pool de construtores e mecanica relacionada a construtores
# TODO melhoria budget de construtores e impacto no desempenho, evolução dos carros, etc.
const CAMINHO_CONSTRUTORES = "res://construtores.txt"
#const CAMINHO_POOL_PILOTOS = "res://pool_pilotos.json"
const CAMINHO_POOL_PILOTOS = "res://pool_pilotos.txt"
# TODO melhoria evolução dos pilotos, impacto da idade, evolução do potencial, etc.
const CAMINHO_PILOTOS = "res://pilotos.txt"
#const CAMINHO_PILOTOS = "res://pilotos.json"
#  TODO O arquivo de fatores de simulação pode conter dados como: 
	#influência do clima, características das pistas, evolução dos pilotos, etc.
	# outros fatores cambio, motor, velocidade, consistencia, agressividade
	# outros fatores psicologicos como: pressão, motivação, etc.
	# outros fatores externos como: acidentes, estratégias de equipe, etc.
	# outros fatores como: evolução tecnológica, mudanças nas regras, etc.
	# outros fatores como: evolução dos carros, desenvolvimento, etc.
	# outros fatores como: evolução dos motores, confiabilidade, etc.
	# outros fatores como: evolução dos aerodinâmicos, downforce, etc.
	# outros fatores como: evolução dos sistemas de suspensão, aderência, etc.
	# outros fatores como: evolução dos sistemas de freios, eficiência, etc.
	# outros fatores como: evolução dos sistemas de transmissão, tração, etc.
	# outros fatores como: evolução dos sistemas de eletrônica, controle, etc.
	# outros fatores como: evolução dos sistemas de telemetria, análise de dados, etc.
	# outros fatores como: evolução dos sistemas de segurança, proteção, etc.
	# outros fatores como: desempenho da equipe, mecanicos, lideres de equipe, etc.
	# outros fatores como: desempenho dos rivais, rivalidades, etc.
	# outros fatores como: evolução dos pneus, desgaste, etc.

	# outros fatores como: evolução dos sistemas de comunicação, coordenação, etc.
	# outros fatores como: evolução dos sistemas de estratégia, tomada de decisão, etc.
	# outros fatores como: evolução dos sistemas de treinamento, preparação física, etc.
	# outros fatores como: lesões, saúde dos pilotos, etc.
	# outros fatores como: sorte, azar, etc.
const CAMINHO_FATORES = "res://fatores_simulacao.txt"

var ano_atual = 1990
var pilotos_aposentados = []

# Função genérica para carregar arquivos de texto/JSON
func carregar_dados_json(caminho_arquivo: String):
	if not FileAccess.file_exists(caminho_arquivo):
		push_error("Arquivo não encontrado: " + caminho_arquivo)
		return null
		
	var arquivo = FileAccess.open(caminho_arquivo, FileAccess.READ)
	var conteudo = arquivo.get_as_text()
	arquivo.close()
	
	var dados = JSON.parse_string(conteudo)
	if dados == null:
		push_error("Erro ao processar o formato do arquivo: " + caminho_arquivo)
		return null
		
	return dados

# Nova função genérica para carregar dados estruturados a partir de arquivos TXT/CSV
func carregar_dados_txt(caminho_arquivo: String):
	if not FileAccess.file_exists(caminho_arquivo):
		push_error("Arquivo não encontrado: " + caminho_arquivo)
		return null
		
	var arquivo = FileAccess.open(caminho_arquivo, FileAccess.READ)
	var linhas: Array = []
	
	# Lê a primeira linha como o cabeçalho das propriedades (ex: nome,idade,velocidade)
	var cabecalho_linha = arquivo.get_line().strip_edges()
	var chaves = cabecalho_linha.split(",")
	
	# Percorre o resto do arquivo linha por linha
	while not arquivo.eof_reached():
		var linha = arquivo.get_line().strip_edges()
		if linha == "":
			continue # Ignora linhas vazias
			
		var valores = linha.split(",")
		var item_dicionario = {}
		
		# Associa as colunas aos nomes das propriedades mapeadas no cabeçalho
		for i in range(min(chaves.size(), valores.size())):
			var chave = chaves[i].strip_edges()
			var valor_texto = valores[i].strip_edges()
			
			# Converte automaticamente para número se aplicável, mantendo a tipagem correta
			if valor_texto.is_valid_int():
				item_dicionario[chave] = valor_texto.to_int()
			elif valor_texto.is_valid_float():
				item_dicionario[chave] = valor_texto.to_float()
			else:
				item_dicionario[chave] = valor_texto
				
		linhas.append(item_dicionario)
		
	arquivo.close()
	return linhas

# Função auxiliar para converter o Array de construtores do arquivo em formato de Dicionário indexado pelo nome
func carregar_construtores_txt(caminho_arquivo: String) -> Dictionary:
	var lista = carregar_dados_txt(caminho_arquivo)
	var dicionario_resultado = {}
	if lista:
		for item in lista:
			if item.has("nome"):
				var nome_equipe = item["nome"]
				dicionario_resultado[nome_equipe] = item
	return dicionario_resultado

# Função auxiliar para carregar fatores únicos de simulação em formato de Dicionário
func carregar_fatores_txt(caminho_arquivo: String) -> Dictionary:
	var lista = carregar_dados_txt(caminho_arquivo)
	if lista and lista.size() > 0:
		return lista[0] # Retorna a primeira linha mapeada
	return {}

# Função responsável por popular as variáveis do jogo no início
func inicializar_dados_do_jogo():
	# Configura conexões de botões e seletores do menu
	configurar_conexoes_menu()
	
	# Bloqueia as abas de jogo para impedir cliques antes da hora
	for i in range(2, tab_container.get_tab_count()):
		tab_container.set_tab_disabled(i, true)
	tab_container.current_tab = 0
	
	# --- ALTERE AS LINHAS ABAIXO PARA USAR AS FUNÇÕES DE TXT ---
	construtores = carregar_construtores_txt(CAMINHO_CONSTRUTORES)
	pilotos = carregar_dados_txt(CAMINHO_PILOTOS)
	poolPilotos = carregar_dados_txt(CAMINHO_POOL_PILOTOS)
	fatores_simulacao = carregar_fatores_txt(CAMINHO_FATORES)
	
	print("Todos os dados externos foram carregados com sucesso!")

func _ready():

	# Carrega os dados externos antes de qualquer outra lógica de interface ou simulação
	inicializar_dados_do_jogo()
	resultado = $Panel/MarginContainer/VBoxContainer/TabContainer/Principal/Label2
	resultado.visible = true
	resultado.text = ("Jogo iniciado")
	
	# Desconecta conexões residuais antigas para evitar o erro de duplicados
	if button.pressed.is_connected(_on_button_pressed): button.pressed.disconnect(_on_button_pressed)
	if button2.pressed.is_connected(_on_button2_pressed): button2.pressed.disconnect(_on_button2_pressed)
	if reset_all_button.pressed.is_connected(_on_reset_all_button_pressed): reset_all_button.pressed.disconnect(_on_reset_all_button_pressed)
	if button4.pressed.is_connected(_on_button_4_pressed): button4.pressed.disconnect(_on_button_4_pressed)
	
	# Força as conexões corretas via código
	button.pressed.connect(_on_button_pressed)
	button2.pressed.connect(_on_button2_pressed)
	reset_all_button.pressed.connect(_on_reset_all_button_pressed)
	button4.pressed.connect(_on_button_4_pressed)
	
	button.grab_focus()
	print("JOGO INICIOU COM SUCESSO")

	# Conecta os sinais de mudança de aba e seleção do menu drop-down
	tab_container.tab_changed.connect(_on_tab_changed)
	seletor_piloto.item_selected.connect(_on_piloto_selecionado)
	
	# Preenche a lista de pilotos pela primeira vez
	atualizar_menu_pilotos()

	# Configura conexões com segurança contra erros de duplicidade
	configurar_conexoes_menu()
	
	# Garante que o container de abas permaneça visível para o fluxo funcionar
	tab_container.visible = true

	#var resultado = get_node("VBoxContainer/RichTextLabel")
	#resultado.text = "Jogo iniciado"

	#var botao = get_node("VBoxContainer/Button")
	#botao.pressed.connect(_clicou)

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
	
	if corrida_atual > total_corridas:
		finalizar_temporada()
		resultado.text = "NOVA TEMPORADA INICIADA (" + str(ano_atual) + ")\n\nClique novamente em Simular para correr o GP 1."
		return

	var resultado_corrida = []
	for piloto in pilotos:
		# TODO melhorar mecanica piloto/equipe selecionada
		# Aplicação do Buff de 2.5% em tempo real caso seja o piloto ou equipe selecionada
		var multiplicador_velocidade: float = 1.0
		var multiplicador_confiabilidade: float = 1.0
		
		if piloto.nome == piloto_controlado:
			multiplicador_velocidade += 0.025
		if piloto.equipe == equipe_controlada:
			multiplicador_confiabilidade += 0.025

		var status = "OK"

		# Quebra de motor (Confiabilidade afetada positivamente pelo multiplicador da equipe)
		if randi_range(1,1000) > (piloto.motor * 10) * multiplicador_confiabilidade:
			status = "MOTOR"

		# Quebra de câmbio
		elif randi_range(1,1000) > (piloto.cambio * 10) * multiplicador_confiabilidade:
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

		# Velocidade base (Afetada positivamente pelo bônus de 2.5% se for o piloto controlado)
		var desempenho = piloto.velocidade * multiplicador_velocidade

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
		piloto.corridas += 1
		if i == 0:

			piloto.vitorias += 1
			piloto.vitorias_seguidas += 1

			if piloto.vitorias_seguidas == 5:

				noticias.append(
					piloto.nome +
					" vive uma sequência histórica de 5 vitórias consecutivas."
				)
		if i < 3:
			piloto.podios += 1

		construtores[piloto.equipe].pontos += pontuacao[i]
		if i == 0:
			piloto.vitorias += 1

	var texto = ""

	# Cabeçalho indicando a corrida atual e o ano vigente do campeonato
	texto += "CORRIDA " + str(corrida_atual) + "/" + str(total_corridas) + " (" + str(ano_atual) + ")"
	texto += "\n\n"

	texto += "RESULTADO\n\n"
	
	# Listagem do resultado da corrida com formatação especial para o pódio
	for i in range(resultado_corrida.size()):
		var piloto = resultado_corrida[i].ref

		if resultado_corrida[i].status != "OK":
			texto += str(i+1) + "º - " + piloto.nome + " - " + resultado_corrida[i].status + "\n"
		else:
			var emoji_podio = ""
			if i == 0:
				emoji_podio = " 🏆" # Troféu dourado para o 1º
			elif i == 1:
				emoji_podio = " 🥈" # Troféu prateado para o 2º
			elif i == 2:
				emoji_podio = " 🥉" # Troféu de bronze para o 3º
				
			texto += str(i+1) + "º - " + piloto.nome + emoji_podio + "\n"

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
			"idade":25,"potencial":90, "nome": equipe,
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
	gerar_noticias()
	if noticias.size() > 0:

		texto += "\n\nNOTÍCIAS\n\n"

		for noticia in noticias:

			texto += "- "
			texto += noticia
			texto += "\n"

		resultado.text = texto

	for piloto in pilotos:
		if piloto != resultado_corrida[0].ref:
			piloto.vitorias_seguidas = 0

	corrida_atual += 1

	if not simulação_em_massa:
		resultado.text = texto
		print(texto)

func finalizar_temporada():

	var campeonato = pilotos.duplicate()

	campeonato.sort_custom(func(a,b):
		return a.pontos > b.pontos
	)

	if campeonato.size() == 0:

		noticias.append(
			"Erro: temporada encerrada sem pilotos."
		)

		return
	var campeao = campeonato[0]
	ano_atual += 1

	if campeao.titulos == 0:

		noticias.append(
			campeao.nome +
			" conquista o primeiro campeonato da carreira."
		)

	campeao.titulos += 1
	if campeao.titulos == 1:

		noticias.append(
			campeao.nome +
			" conquista seu primeiro título mundial."
		)

	elif campeao.titulos == 5:

		noticias.append(
			campeao.nome +
			" alcança a marca de 5 títulos mundiais."
		)

	elif campeao.titulos == 7:

		noticias.append(
			campeao.nome +
			" alcança histórico de 7 títulos."
		)

	# --- NOVO: Atualiza a idade dos pilotos que ainda estão no POOL ---
	for piloto_pool in poolPilotos:
		piloto_pool.idade += 1
	var pilotos_remover = []

	for piloto in pilotos:
		## atualisa idade e qualidade dos pilots
		piloto.idade += 1
		if piloto.idade >= 34:

			piloto.velocidade -= randi_range(0,1)

		if piloto.idade >= 37:

			piloto.velocidade -= randi_range(0,2)
			piloto.consistencia -= randi_range(0,1)

		piloto.velocidade = max(50,piloto.velocidade)
		piloto.consistencia = max(50,piloto.consistencia)
		
		var chance_aposentadoria = 0

		if piloto.idade == 37:
			chance_aposentadoria = 10
		elif piloto.idade == 38:
			chance_aposentadoria = 25
		elif piloto.idade == 39:
			chance_aposentadoria = 50
		elif piloto.idade == 40:
			chance_aposentadoria = 75
		elif piloto.idade >= 41:
			chance_aposentadoria = 100
		var qualidade = (
			piloto.velocidade +
			piloto.consistencia +
			(piloto.titulos * 2)
		) / 2
		if qualidade >= 95:
			chance_aposentadoria -= 25
		elif qualidade >= 90:
			chance_aposentadoria -= 15
		elif qualidade >= 85:
			chance_aposentadoria -= 10
		chance_aposentadoria = max(chance_aposentadoria,0)

		if randi() % 100 < chance_aposentadoria:
			noticias.append(
				piloto.nome +
				" anuncia aposentadoria."
			)
			pilotos_aposentados.append(piloto)
			pilotos_remover.append(piloto)

	for piloto in pilotos_remover:
		pilotos.erase(piloto)
		
	# Executa a entrada de novos pilotos para preencher as vagas abertas
	var vagas = pilotos_remover.size()
	for i in range(vagas):
		adicionar_novato()
		
	# Evolui os atributos dos jovens que ficaram
	evoluir_pilotos()

	# --- RESET PARA A NOVA TEMPORADA ---
	corrida_atual = 1 # Reseta o contador para permitir novas simulações corrida a corrida
	
	# Limpa os pontos e abandonos dos construtores para o novo ano
	for equipe in construtores.keys():
		construtores[equipe]["pontos"] = 0
		construtores[equipe]["abandonos"] = 0
		construtores[equipe]["vitorias"] = 0
		construtores[equipe]["podios"] = 0
		construtores[equipe]["corridas"] = 0
		
	# Limpa os pontos e dados temporários dos pilotos que continuam ativos
	for piloto in pilotos:
		piloto["pontos"] = 0
		piloto["abandonos"] = 0
		piloto["vitorias_seguidas"] = 0
		
	# Limpa o console do Godot para a nova temporada não poluir o terminal
	limpar_console_godot()

# Função que limpa o console do editor do Godot 4
func limpar_console_godot():
	if OS.is_stdout_verbose() or true:
		print("\u001b[2J\u001b[H") # Código ANSI para limpar tela e resetar cursor

func adicionar_novato():
	var candidatos = []
	for piloto_pool in poolPilotos:
		if piloto_pool.anoPool <= ano_atual:
			candidatos.append(piloto_pool)

	if candidatos.size() == 0:
		return
	var escolhido = candidatos.pick_random()
	poolPilotos.erase(escolhido)
	var equipes_disponiveis = []
	for equipe in construtores.keys():
		var quantidade = 0
		for piloto in pilotos:
			if piloto.equipe == equipe:
				quantidade += 1
		if quantidade < 2:
			equipes_disponiveis.append({
				"nome": equipe,
				"forca": construtores[equipe].pontos
			})
	equipes_disponiveis.sort_custom(func(a,b):
		return a.forca > b.forca
	)
	## pilotos fortes do pool tentam entrar em equipes fortes
	if equipes_disponiveis.size() == 0:
		return
	if escolhido.potencial >= 95:
		escolhido.equipe = equipes_disponiveis[0].nome
	elif escolhido.potencial >= 85:
		escolhido.equipe = equipes_disponiveis[
			min(1,equipes_disponiveis.size()-1)
		].nome
	else:
		escolhido.equipe = equipes_disponiveis.pick_random().nome
		
	pilotos.append(escolhido)
	noticias.append(
		escolhido.nome +
		" estreia na Fórmula 1 pela equipe " +
		escolhido.equipe +
		"."
	)

func evoluir_pilotos():
	for piloto in pilotos:
		if piloto.idade <= 30:
			if piloto.velocidade < piloto.potencial:
				piloto.velocidade += randi_range(0,2)
			if piloto.consistencia < piloto.potencial:
				piloto.consistencia += randi_range(0,1)
			piloto.velocidade = min(
				piloto.velocidade,
				piloto.potencial
			)
			piloto.consistencia = min(
				piloto.consistencia,
				piloto.potencial
			)

func simular_10_temporadas():
	simulação_em_massa = true # Ativa o modo silencioso para não travar o console
	
	for temporada in range(10):
		# Garante que a temporada vai rodar todas as corridas do zero
		corrida_atual = 1
		
		# Limpa as pontuações e abandonos dos construtores para o novo ano
		for equipe in construtores.keys():
			construtores[equipe]["pontos"] = 0
			construtores[equipe]["abandonos"] = 0
			construtores[equipe]["vitorias"] = 0
			construtores[equipe]["podios"] = 0
			construtores[equipe]["corridas"] = 0
			
		# Limpa os pontos acumulados da temporada anterior dos pilotos ativos
		for piloto in pilotos:
			piloto["pontos"] = 0
			piloto["abandonos"] = 0
			piloto["vitorias_seguidas"] = 0
			
		# Simula as corridas da temporada atual
		while corrida_atual <= total_corridas:
			_on_button_pressed()
			
		# --- CORREÇÃO DO BUG: Encontra o Campeão ANTES de resetar os dados na virada de ano ---
		var campeao_temporada = null
		var maior_pontuacao = -1
		for piloto in pilotos:
			if piloto["pontos"] > maior_pontuacao:
				maior_pontuacao = piloto["pontos"]
				campeao_temporada = piloto
				
		# --- RELATÓRIO DETALHADO DA TEMPORADA ---
		print("\n==================================================")
		print("🏆 FIM DA TEMPORADA DE: ", ano_atual)
		print("==================================================")
		
		if campeao_temporada != null:
			print("🥇 CAMPEÃO MUNDIAL: ", campeao_temporada["nome"])
			print("⭐ Pontos no Ano: ", maior_pontuacao, " pts")
			print("🏎️  Equipe: ", campeao_temporada.get("equipe", "Sem equipe"))
			print("🏁 Vitórias Totais na Carreira: ", campeao_temporada.get("vitorias", 0))
			print(" podiums Pódios Totais na Carreira: ", campeao_temporada.get("podios", 0))
			
		# Executa a lógica de encerramento (aposentadorias, contratações, avança o ano e ZERA os pontos)
		if has_method("finalizar_temporada"):
			finalizar_temporada()
		
		# Exibe o restante das notícias (Estreias, Aposentadorias, etc.)
		print("\n📰 NOTÍCIAS DA TEMPORADA:")
		if noticias.size() > 0:
			for noticia in noticias:
				# Evita duplicar o texto se você já tiver colocado o campeão nas notícias
				if not "campeonato" in noticia and not "título mundial" in noticia:
					print(" - ", noticia)
			noticias.clear() # Limpa para a próxima temporada
		else:
			print(" - Nenhuma notícia relevante este ano.")
			
		print("==================================================\n")
		
	simulação_em_massa = false # Desativa o modo silencioso após o término das 10 temporadas

func gerar_noticias():
	noticias.clear()
	for piloto in pilotos:

		if piloto.vitorias > recorde_vitorias:

			recorde_vitorias = piloto.vitorias
			recordista_vitorias = piloto.nome

			noticias.append(
				piloto.nome +
				" se torna o novo recordista de vitórias com " +
				str(piloto.vitorias)
			)

		if piloto.abandonos > recorde_abandonos and piloto.abandonos >= 3:

			recorde_abandonos = piloto.abandonos
			recordista_abandonos = piloto.nome

			noticias.append(
				piloto.nome +
				" assume o recorde de abandonos da temporada."
			)

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
			"idade":25,"potencial":90, "nome": equipe,
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


func _on_button_4_pressed() -> void:
	simular_10_temporadas()

	resultado.text = (
		"ANO ATUAL: " +
		str(ano_atual) +
		"\n\nPilotos ativos: " +
		str(pilotos.size())
	)

func _on_tab_changed(tab_index: int):
	if tab_index == 1:
		gerar_estatisticas_temporada_atual()
	elif tab_index == 2:
		atualizar_menu_pilotos()
		_on_piloto_selecionado(seletor_piloto.selected)

func atualizar_menu_pilotos():
	var item_selecionado_atual = seletor_piloto.selected
	var nome_salvo = ""
	if item_selecionado_atual != -1:
		nome_salvo = seletor_piloto.get_item_metadata(item_selecionado_atual)
	
	seletor_piloto.clear()
	
	# Criamos uma lista combinada pura
	var lista_base = pilotos + pilotos_aposentados
	
	# DUPLICAMOS a lista em um novo array para que a ordenação não mexa nos índices do jogo original
	var lista_ordenada = lista_base.duplicate()
	
	# Ordenação tripla: 1º Títulos, 2º Vitórias, 3º Pódios
	lista_ordenada.sort_custom(func(a, b):
		if a.titulos != b.titulos:
			return a.titulos > b.titulos
		if a.vitorias != b.vitorias:
			return a.vitorias > b.vitorias
		return a.podios > b.podios
	)
	
	for i in range(lista_ordenada.size()):
		var p = lista_ordenada[i]
		var sufixo = ""
		if p in pilotos_aposentados:
			sufixo = " (Aposentado)"
		seletor_piloto.add_item(p.nome + sufixo, i)
		# Guarda o nome real do piloto dentro do item para busca precisa
		seletor_piloto.set_item_metadata(i, p.nome)
		
		if p.nome == nome_salvo:
			seletor_piloto.select(i)
			
	if seletor_piloto.selected == -1 and seletor_piloto.item_count > 0:
		seletor_piloto.select(0)

func gerar_estatisticas_temporada_atual():
	var texto = "ESTATÍSTICAS DA TEMPORADA ATUAL / ÚLTIMA TEMPORADA (" + str(ano_atual) + ")\n"
	texto += "================================================================\n\n"
	
	var campeonato_temp = pilotos.duplicate()
	campeonato_temp.sort_custom(func(a, b):
		return a.pontos > b.pontos
	)
	
	for i in range(campeonato_temp.size()):
		var p = campeonato_temp[i]
		texto += str(i+1) + "º " + p.nome + " - Equipe: " + p.equipe + "\n"
		texto += "   Pontos no campeonato: " + str(p.pontos) + " pts\n"
		texto += "   Vitórias este ano: " + str(p.vitorias) + "\n"
		texto += "   Pódios este ano: " + str(p.podios) + "\n"
		texto += "   Abandonos este ano: " + str(p.abandonos) + "\n"
		texto += "----------------------------------------------------------------\n"
	
	classificacao_texto.text = texto

func _on_piloto_selecionado(index: int):
	if index == -1:
		historico_texto.text = "Nenhum piloto selecionado."
		return
		
	# Obtém o nome real do piloto associado a essa linha selecionada
	var nome_buscado = seletor_piloto.get_item_metadata(index)
	
	var todos_os_pilotos = pilotos + pilotos_aposentados
	var p = null
	
	# Busca o piloto correto pelo nome correspondente
	for piloto in todos_os_pilotos:
		if piloto.nome == nome_buscado:
			p = piloto
			break
			
	if p == null:
		historico_texto.text = "Erro ao carregar dados do piloto."
		return
	
	var texto = "HISTÓRICO COMPLETO DA CARREIRA - STATS ACUMULADAS\n"
	texto += "Nome do Piloto: " + p.nome + "\n"
	texto += "Idade Atual: " + str(p.idade) + " anos\n"
	
	if p in pilotos_aposentados:
		texto += "Situação: APOSENTADO da categoria\n"
	else:
		texto += "Equipe Atual: " + p.equipe + "\n"
		
	texto += "----------------------------------------------------------------\n"
	texto += "• Títulos Mundiais Conquistados: " + str(p.titulos) + " 🏆\n"
	texto += "• Total de Grandes Prêmios disputados: " + str(p.corridas) + "\n"
	texto += "• Vitórias totais na carreira: " + str(p.vitorias) + "\n"
	texto += "• Pódios totais na carreira: " + str(p.podios) + "\n"
	texto += "• Total de vezes que abandonou (Quebras/Acidentes): " + str(p.abandonos) + "\n"
	texto += "----------------------------------------------------------------\n"
	texto += "ATRIBUTOS DE PILOTAGEM:\n"
	texto += " -> Velocidade base: " + str(p.velocidade) + "\n"
	texto += " -> Consistência: " + str(p.consistencia) + "\n"
	texto += " -> Agressividade: " + str(p.agressividade) + "\n"
	texto += "================================================================\n"
	
	historico_texto.text = texto

# --- SISTEMA DE FLUXO POR ABAS (MENU PRINCIPAL) ---

func configurar_conexoes_menu():
	# Verifica se o nó existe e se o sinal já não foi conectado previamente (via Editor) antes de conectar por código
	if btn_start_game and not btn_start_game.pressed.is_connected(_on_start_game_pressed): 
		btn_start_game.pressed.connect(_on_start_game_pressed)
		
	if opt_equipe and not opt_equipe.item_selected.is_connected(_on_equipe_menu_selected): 
		opt_equipe.item_selected.connect(_on_equipe_menu_selected)
		
	if btn_confirmar_setup and not btn_confirmar_setup.pressed.is_connected(_on_confirmar_setup_pressed): 
		btn_confirmar_setup.pressed.connect(_on_confirmar_setup_pressed)

func _on_start_game_pressed():
	# Configurar Ano Único no OptionButton
	opt_ano.clear()
	opt_ano.add_item("1990")
	
	# Configurar Lista de Equipes no OptionButton
	opt_equipe.clear()
	opt_equipe.add_item("Selecione uma Equipe...")
	for eq in construtores.keys():
		opt_equipe.add_item(eq)
		
	# Move o jogador para a segunda aba (Configuração Inicial)
	tab_container.current_tab = 1

func _on_equipe_menu_selected(index: int):
	if index <= 0:
		lbl_preview_pilotos.text = "Selecione uma equipe para ver os pilotos."
		opt_piloto_player.clear()
		return
		
	var eq_nome = opt_equipe.get_item_text(index)
	var pilotos_da_equipe: Array = []
	
	opt_piloto_player.clear()
	for p in pilotos:
		if p.equipe == eq_nome:
			pilotos_da_equipe.append(p.nome)
			opt_piloto_player.add_item(p.nome)
			
	lbl_preview_pilotos.text = "Pilotos na " + eq_nome + ":\n• " + "\n• ".join(pilotos_da_equipe)

func _on_confirmar_setup_pressed():
	if opt_equipe.selected <= 0 or opt_piloto_player.item_count == 0:
		return
		
	equipe_controlada = opt_equipe.get_item_text(opt_equipe.selected)
	piloto_controlado = opt_piloto_player.get_item_text(opt_piloto_player.selected)
	ano_atual = int(opt_ano.get_item_text(opt_ano.selected))
	
	# Desbloqueia as abas de jogo da simulação
	for i in range(2, tab_container.get_tab_count()):
		tab_container.set_tab_disabled(i, false)
		
	# Bloqueia as abas de menu para o jogador não voltar nelas no meio do campeonato
	tab_container.set_tab_disabled(0, true)
	tab_container.set_tab_disabled(1, true)
	
	# Move o jogador automaticamente para a aba "Principal" (Índice 2) para começar as corridas
	tab_container.current_tab = 2
	print("Jogo Inicializado! Buffs aplicados para " + piloto_controlado + " e equipe " + equipe_controlada)
