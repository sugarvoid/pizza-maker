extends Node2D


var day_of_week: Array = [
	"Mon", "Tues", "Wed", "Thurs", "Fri"
]

var cost_of_dough: float = 2.0

var cash: float
var is_shift_held: bool 
var break_time: float = 2.0
var time_per_round: float = 6.0

var daily_income: float
var daily_tips: float
var daily_expense: float



onready var pizza: Pizza = get_node("Pizza")
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var trm_next_order: Timer = get_node("TrmNextOrder")
onready var trm_order_time: Timer = get_node("TrmOrderTime")



func _ready() -> void:
	self.animation_player.connect("animation_finished", self, "_on_animation_done")
	self.trm_next_order.connect("timeout", self, "_start_new_round")
	self.trm_order_time.connect("timeout", self, "_end_round")
	self._start_new_round()

func _process(delta: float) -> void:
	self.is_shift_held = Input.is_action_pressed("left_shift")
	$HUD.update_labels(self.is_shift_held)
	

func _unhandled_key_input(event: InputEventKey) -> void:
	
	if !self.animation_player.is_playing():
		if event.is_action_pressed("ui_accept"):
			# $Pizza.pulse()
			if self.is_shift_held:
				self.pizza.cook()
			else:
				# TODO: Prevent spamming of pressing sapce
				self.animation_player.play("slide_pizza_out")
				# start timer to get new order and send in blank pizza
			
		if event.is_action_pressed("up_topping"):
			self.pizza.pulse()
			if self.is_shift_held:
				self.pizza.add_topping(Global.toppings.alt_up)
			else:
				self.pizza.add_topping(Global.toppings.up)
		elif event.is_action_pressed("down_topping"):
			# Trash pizza
			print("trash the pizza")
#			if self.is_shift_held:
#				self.pizza.add_topping(Global.toppings.alt_down)
#			else:
#				self.pizza.add_topping(Global.toppings.down)
		elif event.is_action_pressed("left_topping"):
			self.pizza.pulse()
			if self.is_shift_held:
				self.pizza.add_topping(Global.toppings.alt_left)
			else:
				self.pizza.add_topping(Global.toppings.left)
		elif event.is_action_pressed("right_topping"):
			self.pizza.pulse()
			if self.is_shift_held:
				self.pizza.add_topping(Global.toppings.alt_right)
			else:
				self.pizza.add_topping(Global.toppings.right)
		

func _start_new_day() -> void:
	pass
	# Advnace day
	# Update day of week on HUD

func _start_new_round() -> void:
	# TODO: change to start_new_order
	self.daily_expense += self.cost_of_dough
	self.animation_player.play("slide_pizza_in")

func _trash_pizza() -> void:
	# explode pizza with animation 
	pass
	# Send in new pizza 

func _end_round() -> void:
	print("time ran out, customer left")

func _on_animation_done(anim_name: String):
	match anim_name:
		"slide_pizza_in":
			print("new pizza on table")
		"slide_pizza_out":
			print("pizza has been served")
			self.pizza.reset()
			self.trm_next_order.start(self.break_time)
			# Reset pizza

