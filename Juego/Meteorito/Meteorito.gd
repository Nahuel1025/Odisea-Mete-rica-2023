class_name Meteorito
extends RigidBody2D


## Atributos Export

export var vel_lineal_base:Vector2 = Vector2(300.0, 300.0)
export var vel_ang_base:float = 3.0
export var hitpoints_base:float = 10.0

onready var impacto_SFX: AudioStreamPlayer2D = $ImpactoSFX
onready var impacto: AnimationPlayer = $AnimationPlayer


## Atributos

var hitpoints:float
var esta_en_sector:bool = true setget set_esta_en_sector
var pos_sapwn_original:Vector2
var vel_spawn_original:Vector2
var esta_destruido:bool = false

## Metodos

func _ready() -> void:
	angular_velocity = vel_ang_base
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if esta_en_sector:
		return
		
	var mi_transform := state.get_transform()
	mi_transform.origin = pos_sapwn_original
	linear_velocity = vel_spawn_original
	state.set_transform(mi_transform)
	esta_en_sector = true
	
	
## Setters y Getters
func set_esta_en_sector(valor: bool) -> void:
	esta_en_sector = valor

## Constructor

func crear(pos: Vector2, dir:Vector2, tamanio: float) -> void:
	position = pos
	pos_sapwn_original = position
	## Calcular Masa, Tamaño de sprite y colisionador
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	#radio = diametro /2
	var radio:int = int($Sprite.texture.get_size().x/2.3*tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	#calcular Velocidades
	linear_velocity = (vel_lineal_base * dir / tamanio) * aleatorizar_velocidad()
	vel_spawn_original = linear_velocity
	angular_velocity = (vel_ang_base / tamanio) * aleatorizar_velocidad()
	#Calcular Hitpoints
	hitpoints = hitpoints_base * tamanio
	#solo debug
	print("hitpoints: ", hitpoints)
	
	
	
	
## Metodos Custom

func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	if hitpoints <= 0 and not esta_destruido:
		esta_destruido = true
		destruir()
	$AnimationPlayer.play("impacto")
	impacto_SFX.play()
	
func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("meteorito_destruido", global_position)
	queue_free()
	
func aleatorizar_velocidad() -> float:
	randomize()
	return rand_range(1.1, 1.4)
