class_name CamaraJuego
extends Camera2D

# atributos
var zoom_original:Vector2
var puede_hacer_zoom:bool = true setget set_puede_hacer_zoom


## variables export
export var variacion_zoom:float = 0.1
export var zoom_minimo:float = 0.8
export var zoom_maximo:float = 1.5

# variables onready
onready var tween_zoom:Tween = $TweenZoom

## Setters y getters
func set_puede_hacer_zoom(puede: bool) -> void:
	puede_hacer_zoom = puede

## metodos

func _ready() -> void:
	zoom_original = zoom


## metodos custom

func devolver_zoom_original() -> void:
	puede_hacer_zoom = false
	zoom_suavizado(zoom_original.x, zoom_original.y, 1.5)
	
	
	
func zoom_suavizado(nuevo_zoom_x: float, nuevo_zoom_y: float, tiempo_transicion: float) -> void:
	tween_zoom.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(nuevo_zoom_x, nuevo_zoom_y),
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT)
	tween_zoom.start()
