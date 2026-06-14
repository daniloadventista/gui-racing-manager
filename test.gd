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

var noticias = []

var recorde_vitorias = 0
var recordista_vitorias = ""

var recorde_abandonos = 0
var recordista_abandonos = ""

var pontuacao = [25,18,15,12,10,8,6,4,2,1]
var construtores = {

	"McLaren":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Ferrari":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Williams":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Benetton":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Tyrrell":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Lotus":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Leyton House":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Ligier":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Arrows":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Minardi":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Larrousse":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"AGS":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Osella":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"EuroBrun":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Coloni":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Life":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0},
	"Onyx":{"pontos":0,"abandonos":0,"vitorias":0,"podios":0,"corridas":0}
}

var poolPilotos = [

	{"anoPool":1991,"idade":22,"potencial":100,"nome":"Michael Schumacher","equipe":"","velocidade":92,"consistencia":82,"agressividade":98,"motor":88,"cambio":88,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1991,"idade":23,"potencial":98,"nome":"Mika Hakkinen","equipe":"","velocidade":90,"consistencia":80,"agressividade":92,"motor":86,"cambio":86,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1991,"idade":25,"potencial":84,"nome":"Mark Blundell","equipe":"","velocidade":83,"consistencia":82,"agressividade":76,"motor":84,"cambio":84,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1991,"idade":28,"potencial":82,"nome":"Erik Comas","equipe":"","velocidade":82,"consistencia":80,"agressividade":78,"motor":84,"cambio":84,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1991,"idade":23,"potencial":75,"nome":"Michael Bartels","equipe":"","velocidade":75,"consistencia":74,"agressividade":72,"motor":80,"cambio":80,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1991,"idade":26,"potencial":74,"nome":"Pedro Chaves","equipe":"","velocidade":74,"consistencia":76,"agressividade":70,"motor":80,"cambio":80,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1991,"idade":28,"potencial":72,"nome":"Naoki Hattori","equipe":"","velocidade":72,"consistencia":74,"agressividade":68,"motor":80,"cambio":80,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1991,"idade":24,"potencial":95,"nome":"Kenny Brack","equipe":"","velocidade":88,"consistencia":88,"agressividade":84,"motor":86,"cambio":86,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1991,"idade":16,"potencial":99,"nome":"Juan Pablo Montoya","equipe":"","velocidade":82,"consistencia":70,"agressividade":95,"motor":75,"cambio":75,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1991,"idade":24,"potencial":96,"nome":"Tom Kristensen","equipe":"","velocidade":87,"consistencia":92,"agressividade":72,"motor":86,"cambio":86,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1991,"idade":21,"potencial":94,"nome":"Allan McNish","equipe":"","velocidade":86,"consistencia":88,"agressividade":80,"motor":85,"cambio":85,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1992,"idade":31,"potencial":90,"nome":"Damon Hill","equipe":"","velocidade":85,"consistencia":90,"agressividade":70,"motor":84,"cambio":84,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1992,"idade":20,"potencial":97,"nome":"Rubens Barrichello","equipe":"","velocidade":87,"consistencia":80,"agressividade":84,"motor":82,"cambio":82,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1992,"idade":25,"potencial":96,"nome":"Heinz Harald Frentzen","equipe":"","velocidade":88,"consistencia":85,"agressividade":82,"motor":84,"cambio":84,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1993,"idade":22,"potencial":99,"nome":"Jacques Villeneuve","equipe":"","velocidade":90,"consistencia":84,"agressividade":90,"motor":85,"cambio":85,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1993,"idade":20,"potencial":95,"nome":"Giancarlo Fisichella","equipe":"","velocidade":86,"consistencia":84,"agressividade":85,"motor":82,"cambio":82,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1994,"idade":18,"potencial":100,"nome":"Kimi Raikkonen","equipe":"","velocidade":88,"consistencia":78,"agressividade":86,"motor":80,"cambio":80,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1994,"idade":17,"potencial":100,"nome":"Fernando Alonso","equipe":"","velocidade":87,"consistencia":82,"agressividade":90,"motor":80,"cambio":80,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1995,"idade":17,"potencial":98,"nome":"Jenson Button","equipe":"","velocidade":84,"consistencia":80,"agressividade":78,"motor":78,"cambio":78,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1996,"idade":15,"potencial":100,"nome":"Lewis Hamilton","equipe":"","velocidade":82,"consistencia":75,"agressividade":88,"motor":75,"cambio":75,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1998,"idade":17,"potencial":97,"nome":"Kimi Raikkonen","equipe":"","velocidade":88,"consistencia":76,"agressividade":84,"motor":78,"cambio":78,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1998,"idade":17,"potencial":95,"nome":"Nick Heidfeld","equipe":"","velocidade":84,"consistencia":82,"agressividade":72,"motor":78,"cambio":78,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1999,"idade":18,"potencial":98,"nome":"Fernando Alonso","equipe":"","velocidade":88,"consistencia":82,"agressividade":90,"motor":80,"cambio":80,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":1999,"idade":18,"potencial":95,"nome":"Pedro de la Rosa","equipe":"","velocidade":83,"consistencia":84,"agressividade":70,"motor":80,"cambio":80,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2000,"idade":15,"potencial":97,"nome":"Lewis Hamilton","equipe":"","velocidade":86,"consistencia":78,"agressividade":88,"motor":76,"cambio":76,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2000,"idade":15,"potencial":98,"nome":"Nico Rosberg","equipe":"","velocidade":84,"consistencia":82,"agressividade":76,"motor":76,"cambio":76,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2001,"idade":14,"potencial":100,"nome":"Sebastian Vettel","equipe":"","velocidade":85,"consistencia":78,"agressividade":86,"motor":74,"cambio":74,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2001,"idade":16,"potencial":96,"nome":"Robert Kubica","equipe":"","velocidade":84,"consistencia":84,"agressividade":82,"motor":76,"cambio":76,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2002,"idade":15,"potencial":97,"nome":"Adrian Sutil","equipe":"","velocidade":82,"consistencia":80,"agressividade":78,"motor":75,"cambio":75,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2003,"idade":14,"potencial":100,"nome":"Daniel Ricciardo","equipe":"","velocidade":84,"consistencia":78,"agressividade":92,"motor":74,"cambio":74,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2003,"idade":14,"potencial":99,"nome":"Sergio Perez","equipe":"","velocidade":83,"consistencia":82,"agressividade":80,"motor":74,"cambio":74,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2004,"idade":14,"potencial":98,"nome":"Nico Hulkenberg","equipe":"","velocidade":84,"consistencia":86,"agressividade":76,"motor":74,"cambio":74,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2005,"idade":14,"potencial":100,"nome":"Max Verstappen","equipe":"","velocidade":88,"consistencia":76,"agressividade":98,"motor":74,"cambio":74,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2005,"idade":13,"potencial":98,"nome":"Carlos Sainz Jr","equipe":"","velocidade":83,"consistencia":84,"agressividade":78,"motor":73,"cambio":73,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2006,"idade":14,"potencial":98,"nome":"Valtteri Bottas","equipe":"","velocidade":83,"consistencia":88,"agressividade":70,"motor":74,"cambio":74,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2007,"idade":14,"potencial":98,"nome":"Charles Leclerc","equipe":"","velocidade":85,"consistencia":82,"agressividade":88,"motor":74,"cambio":74,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2007,"idade":14,"potencial":97,"nome":"George Russell","equipe":"","velocidade":84,"consistencia":86,"agressividade":78,"motor":74,"cambio":74,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2008,"idade":13,"potencial":97,"nome":"Lando Norris","equipe":"","velocidade":84,"consistencia":82,"agressividade":82,"motor":73,"cambio":73,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2008,"idade":13,"potencial":96,"nome":"Alexander Albon","equipe":"","velocidade":82,"consistencia":80,"agressividade":80,"motor":73,"cambio":73,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2009,"idade":13,"potencial":98,"nome":"Oscar Piastri","equipe":"","velocidade":85,"consistencia":88,"agressividade":76,"motor":73,"cambio":73,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"anoPool":2010,"idade":11,"potencial":96,"nome":"Yuki Tsunoda","equipe":"","velocidade":82,"consistencia":74,"agressividade":92,"motor":70,"cambio":70,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0}
]

var pilotos = [

	{"idade":30,"potencial":99,"nome":"Senna","equipe":"McLaren","velocidade":98,"consistencia":95,"agressividade":92,"motor":95,"cambio":94,"pontos":0,"abandonos":0,"vitorias":16,"vitorias_seguidas":0,"titulos":2,"podios":41,"corridas":96},
	{"idade":31,"potencial":90,"nome":"Berger","equipe":"McLaren","velocidade":90,"consistencia":88,"agressividade":82,"motor":92,"cambio":92,"pontos":0,"abandonos":0,"vitorias":4,"vitorias_seguidas":0,"titulos":0,"podios":20,"corridas":100},

	{"idade":35,"potencial":98,"nome":"Prost","equipe":"Ferrari","velocidade":97,"consistencia":99,"agressividade":55,"motor":95,"cambio":95,"pontos":0,"abandonos":0,"vitorias":51,"vitorias_seguidas":0,"titulos":3,"podios":95,"corridas":160},
	{"idade":37,"potencial":92,"nome":"Mansell","equipe":"Ferrari","velocidade":94,"consistencia":85,"agressividade":90,"motor":90,"cambio":91,"pontos":0,"abandonos":0,"vitorias":14,"vitorias_seguidas":0,"titulos":0,"podios":35,"corridas":150},

	{"idade":38,"potencial":94,"nome":"Piquet","equipe":"Benetton","velocidade":93,"consistencia":92,"agressividade":70,"motor":93,"cambio":93,"pontos":0,"abandonos":0,"vitorias":23,"vitorias_seguidas":0,"titulos":3,"podios":60,"corridas":180},
	{"idade":29,"potencial":88,"nome":"Nannini","equipe":"Benetton","velocidade":89,"consistencia":86,"agressividade":84,"motor":92,"cambio":92,"pontos":0,"abandonos":0,"vitorias":1,"vitorias_seguidas":0,"titulos":0,"podios":9,"corridas":60},

	{"idade":36,"potencial":84,"nome":"Patrese","equipe":"Williams","velocidade":86,"consistencia":89,"agressividade":68,"motor":92,"cambio":92,"pontos":0,"abandonos":0,"vitorias":4,"vitorias_seguidas":0,"titulos":0,"podios":20,"corridas":180},
	{"idade":29,"potencial":88,"nome":"Boutsen","equipe":"Williams","velocidade":88,"consistencia":87,"agressividade":72,"motor":92,"cambio":92,"pontos":0,"abandonos":0,"vitorias":2,"vitorias_seguidas":0,"titulos":0,"podios":12,"corridas":80},

	{"idade":26,"potencial":95,"nome":"Alesi","equipe":"Tyrrell","velocidade":91,"consistencia":80,"agressividade":94,"motor":87,"cambio":88,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":2,"corridas":15},
	{"idade":37,"potencial":75,"nome":"Nakajima","equipe":"Tyrrell","velocidade":77,"consistencia":82,"agressividade":65,"motor":87,"cambio":88,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":70},

	{"idade":36,"potencial":80,"nome":"Warwick","equipe":"Lotus","velocidade":81,"consistencia":85,"agressividade":70,"motor":85,"cambio":85,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":4,"corridas":140},
	{"idade":34,"potencial":78,"nome":"Donnelly","equipe":"Lotus","velocidade":80,"consistencia":80,"agressividade":78,"motor":85,"cambio":85,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":10},

	{"idade":29,"potencial":82,"nome":"Capelli","equipe":"Leyton House","velocidade":84,"consistencia":82,"agressividade":76,"motor":88,"cambio":88,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":1,"corridas":70},
	{"idade":30,"potencial":80,"nome":"Gugelmin","equipe":"Leyton House","velocidade":82,"consistencia":81,"agressividade":72,"motor":88,"cambio":88,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":60},

	{"idade":34,"potencial":84,"nome":"Alboreto","equipe":"Arrows","velocidade":84,"consistencia":86,"agressividade":68,"motor":84,"cambio":84,"pontos":0,"abandonos":0,"vitorias":5,"vitorias_seguidas":0,"titulos":0,"podios":23,"corridas":170},
	{"idade":27,"potencial":80,"nome":"Caffi","equipe":"Arrows","velocidade":79,"consistencia":81,"agressividade":75,"motor":84,"cambio":84,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":50},

	{"idade":31,"potencial":82,"nome":"Martini","equipe":"Minardi","velocidade":79,"consistencia":83,"agressividade":70,"motor":82,"cambio":82,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":70},
	{"idade":23,"potencial":85,"nome":"Morbidelli","equipe":"Minardi","velocidade":76,"consistencia":80,"agressividade":68,"motor":82,"cambio":82,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":5},

	{"idade":34,"potencial":78,"nome":"Laffite","equipe":"Ligier","velocidade":79,"consistencia":84,"agressividade":62,"motor":86,"cambio":86,"pontos":0,"abandonos":0,"vitorias":6,"vitorias_seguidas":0,"titulos":0,"podios":32,"corridas":170},
	{"idade":29,"potencial":80,"nome":"Boutsen_Ligier","equipe":"Ligier","velocidade":80,"consistencia":82,"agressividade":68,"motor":86,"cambio":86,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":20},

	{"idade":29,"potencial":82,"nome":"Alliot","equipe":"Larrousse","velocidade":82,"consistencia":80,"agressividade":76,"motor":84,"cambio":84,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":50},
	{"idade":34,"potencial":80,"nome":"Suzuki","equipe":"Larrousse","velocidade":79,"consistencia":81,"agressividade":70,"motor":84,"cambio":84,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":40},

	{"idade":31,"potencial":74,"nome":"Tarquini","equipe":"AGS","velocidade":75,"consistencia":82,"agressividade":68,"motor":78,"cambio":78,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":30},
	{"idade":28,"potencial":72,"nome":"Dalmas","equipe":"AGS","velocidade":74,"consistencia":76,"agressividade":72,"motor":78,"cambio":78,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":20},

	{"idade":30,"potencial":70,"nome":"Grouillard","equipe":"Osella","velocidade":72,"consistencia":74,"agressividade":74,"motor":77,"cambio":77,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":15},
	{"idade":33,"potencial":74,"nome":"Caffi_Osella","equipe":"Osella","velocidade":76,"consistencia":80,"agressividade":72,"motor":77,"cambio":77,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":50},

	{"idade":28,"potencial":70,"nome":"Modena","equipe":"EuroBrun","velocidade":74,"consistencia":75,"agressividade":78,"motor":75,"cambio":75,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":20},
	{"idade":31,"potencial":68,"nome":"Schoen","equipe":"EuroBrun","velocidade":70,"consistencia":72,"agressividade":65,"motor":75,"cambio":75,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":10},

	{"idade":28,"potencial":68,"nome":"Gachot","equipe":"Coloni","velocidade":73,"consistencia":76,"agressividade":70,"motor":74,"cambio":74,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":35},
	{"idade":31,"potencial":64,"nome":"Ravaglia","equipe":"Coloni","velocidade":68,"consistencia":70,"agressividade":66,"motor":74,"cambio":74,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":10},

	{"idade":30,"potencial":55,"nome":"Rosset_Life","equipe":"Life","velocidade":55,"consistencia":60,"agressividade":60,"motor":45,"cambio":50,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":0,"corridas":0},
	{"idade":32,"potencial":70,"nome":"Johansson","equipe":"Onyx","velocidade":77,"consistencia":82,"agressividade":68,"motor":80,"cambio":80,"pontos":0,"abandonos":0,"vitorias":0,"vitorias_seguidas":0,"titulos":0,"podios":12,"corridas":100}

]

var ano_atual = 1990
var pilotos_aposentados = []

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

		finalizar_temporada()

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
	var pilotos_remover = []

	for piloto in pilotos:
		piloto.idade += 1
		
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
	var vagas = pilotos_remover.size()
	for i in range(vagas):
		adicionar_novato()

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
			equipes_disponiveis.append(equipe)
	if equipes_disponiveis.size() == 0:
		return
	escolhido.equipe = equipes_disponiveis.pick_random()
	pilotos.append(escolhido)
	noticias.append(
		escolhido.nome +
		" estreia na Fórmula 1 pela equipe " +
		escolhido.equipe +
		"."
	)

func simular_10_temporadas():

	for temporada in range(10):

		for corrida in range(total_corridas):

			_on_button_pressed()

		finalizar_temporada()

		print("Fim da temporada: ", ano_atual)
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
	#simular_10_temporadas()

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
