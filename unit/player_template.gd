extends Unit
class_name PlayerTemplate

var move_speed:int=200
var move_direction:Vector2=Vector2.ZERO
var dash_duration:float=0.5
var dash_cooldown:float=5
var dash_multiple:float=2
var can_dash:bool=true
var is_dashing:bool=false
var trail_array:Array[Vector2]=[]

var current_weapons:Array[Weapon]=[]
@onready var weapon_container: WeaponContainer = $WeaponContainer

@onready var trail: Line2D = $Trail
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer

func _ready() -> void:
	super._ready()
	move_speed=stats.speed
	dash_timer.timeout.connect(dash_timer_timeout)
	dash_cooldown_timer.timeout.connect(dash_cooldown_timer_timeout)
	
	#equip_weapon(preload("uid://ojova7xjauvd"))
	equip_weapon(preload("uid://cixvftfjvjxsg"))


func _physics_process(delta: float) -> void:
	if Global.game_pause:return
	velocity=move_direction*move_speed
	if is_dashing:
		trail_array.append(global_position)
		if trail_array.size()>8:
			trail_array.pop_front()
		trail.global_position=to_local(global_position)
		trail.points=trail_array
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	move_direction=Input.get_vector("move_left","move_right","move_up","move_down")
	if move_direction.x>0:
		animate.flip_h=false
	elif move_direction.x<0:
		animate.flip_h=true
	if move_direction.length()==0:
		animate.play("idle")
	else :
		animate.play("run")
	if Input.is_action_just_pressed("dash"):
		dash()

func dash()->void:
	if can_dash and is_dashing==false:
		move_speed*=dash_multiple
		modulate.a=0.5
		collision.disabled=true
		dash_timer.start(dash_duration)
		dash_cooldown_timer.start(dash_cooldown)
		can_dash=false
		is_dashing=true
		trail.visible=true

func dash_timer_timeout()->void:
	move_speed/=dash_multiple
	collision.disabled=false
	is_dashing=false
	modulate.a=1
	trail_array.clear()
	trail.visible=false

func dash_cooldown_timer_timeout()->void:
	can_dash=true

func equip_weapon(entity:ItemWeapon)->void:
	var weapon=entity.scene.instantiate() as Weapon
	add_child(weapon)
	weapon.set_weapon(entity)
	current_weapons.append(weapon)
	weapon_container.update_weapon_position(current_weapons)

func update_player_new_wave()->void:
	stats.max_health+=stats.health_increase_per_wave
	stats.health=health.current_health
	#stats.damage+=stats.damage_increase_per_wave
	health.initial(stats)

func _on_hp_regen_timer_timeout() -> void:
	if health.current_health<=0:
		return
	if health.current_health<stats.max_health and Global.game_pause==false:
		var h:=stats.hp_regen
		health.heal(h)
		Global.heal_text.emit(self,h)
