class_name DialogController
extends Node

@onready var voice_player: AudioStreamPlayer = $VoicePlayer
@onready var menu_player : AudioStreamPlayer = $MenuPlayer
@export var current_chunk : DialogChunk
@export var body_ui_label : RichTextLabel
@export var speaker_label : RichTextLabel
@export var progress_ui : Control 
@export var options_container : Control 
@export var wolf_character : AnimatedSprite2D
@export var heart : PlayerHeart
@export var level_complete_controller : LevelCompleteController
var body_idx : int 
var str_idx : int 
var crawl_timer : float = 0.0 
var current_fragment : DialogFragment:
	get:
		return current_chunk.fragments[body_idx]
var current_string : String: 
	get:
		return current_chunk.fragments[body_idx].text
const CRAWL_SPEED : float = 0.04
 
var chars_on_current_line : int 
const CHARS_PER_LINE : int = 40

const SPR_NEXT = preload("uid://btw03ce8dq41o")
const SPR_FAST = preload("uid://8wu6pqciuj7x")
const SND_TYPE_FALLBACK = preload("uid://bpct7a65ntamc")
const SND_TYPE_END = preload("uid://dyw2hs3i8o2cj")
const SND_AUTO = preload("uid://bbtyrdm4plnju")


enum State
{
	Standby,
	Crawl,
	Option,
	PauseAuto 
}
@export var current_state : State
func go_to_state(next_state : State):
	match current_state:
		State.Option:
			options_container.visible = false
			body_ui_label.visible = true 
	current_state = next_state
	match current_state:
		State.Crawl:
			# CLEANUP 
			str_idx = 0 
			crawl_timer = 0 
			chars_on_current_line = 0
			body_ui_label.clear()
			# JOLT 
			if current_fragment.heart_jolt != 0: 
				heart.change_bpm(current_fragment.heart_jolt)
			# SET SPEAKER NAME 
			if current_fragment.speaker.remove_chars(' ') != '':
				speaker_label.text = current_fragment.speaker 
			# HEART SLIDE 
			if current_fragment.heart_slide_reset:
					heart.set_slide(0)
			elif current_fragment.heart_slide_value != 0:
				heart.set_slide(current_fragment.heart_slide_value)
			# AUTO BEHAVIOR 
			if current_fragment.auto:
				progress_ui.visible = true 
				progress_ui.texture = SPR_FAST
				pass
			else:
				progress_ui.visible = false 
				progress_ui.texture = SPR_NEXT
				pass 
			# UPDATE CHARACTER SPRITE 
			if current_fragment.character_animation_name in wolf_character.sprite_frames.get_animation_names():
				wolf_character.play(current_fragment.character_animation_name)
			# SOUND 
			if current_fragment.type_sound != null:
				voice_player.stream = current_fragment.type_sound
		State.Option:
			for i in current_chunk.branches.size():
				var branch := current_chunk.branches[i]
				var btn := Button.new()
				btn.text = branch.option_name
				btn.pressed.connect( self._option_selected.bind(i) )
				options_container.add_child(btn)
			body_ui_label.visible = false 
			options_container.visible = true 
		State.PauseAuto:
			print('AUTO PAUSE')
			await get_tree().create_timer(1.0).timeout
			_terminate_current_string()

func _unhandled_input(event: InputEvent) -> void:
	match current_state:
		State.Standby:
			if event.is_action_pressed("ui_accept"):
				_terminate_current_string()

func _terminate_current_string():
	if current_fragment.script_on_complete:
		await current_fragment.script_on_complete.new().execute(self)
	
	if body_idx >= current_chunk.fragments.size()-1:
		if current_chunk.branches.size() >= 2:
			progress_ui.visible = false 
			go_to_state(State.Option)
		elif current_chunk.branches.size() == 1:
			current_chunk = current_chunk.branches[0].chunk
			voice_player.stream = SND_TYPE_FALLBACK
			body_idx = 0 
			go_to_state(State.Crawl)
		else:
			level_complete_controller.complete_level()
	else:
		body_idx += 1 
		go_to_state(State.Crawl)
		progress_ui.visible = false 
	pass 

func _option_selected(idx : int) -> void:
	print('Selected option #', idx)
	var new_chunk := current_chunk.branches[idx].chunk
	current_chunk = new_chunk
	body_idx = 0
	go_to_state(State.Crawl)
	pass 

func _is_letter(char_str: String) -> bool:
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+")
	return regex.search(char_str) != null

func _ready() -> void:
	go_to_state(current_state)

func _on_crawl_completed() -> void: 
	
	if current_fragment.auto:
		menu_player.stream = SND_AUTO
		go_to_state(State.PauseAuto)
	else:
		menu_player.stream = SND_TYPE_END
		progress_ui.texture = SPR_NEXT 
		progress_ui.visible = true
		go_to_state(State.Standby)
	
	menu_player.play()

func _process(delta: float) -> void:
	
	if current_fragment.auto:
		progress_ui.visible = (Time.get_ticks_msec()/600)%2 == 0
	
	match current_state:
		State.Crawl:
			crawl_timer += delta
			if crawl_timer >= CRAWL_SPEED:
				crawl_timer = 0.0 
				#print(str_idx, ' / ', current_string)
				body_ui_label.add_text( current_string[str_idx] )
				if current_string[str_idx] == '\n': 
					chars_on_current_line = 0
				if current_string[str_idx] != ' ':
					voice_player.play()   
				str_idx += 1
				chars_on_current_line += 1
				if str_idx >= current_string.length(): 
					_on_crawl_completed()
				# lookahead to prevent wrapping mid-crawl 
				elif current_string[str_idx] in [' ', '.', ',', ':', ';', '?', '!']: 
					var lookahead_size : int = 0 
					for i in range(str_idx+1, current_string.length()): 
						if not _is_letter( current_string[i] ): break
						lookahead_size += 1
					var projected_char_count := chars_on_current_line + lookahead_size
					if projected_char_count > CHARS_PER_LINE:
						body_ui_label.add_text("\n")
						str_idx += 1 
						chars_on_current_line = 0
						if str_idx >= current_string.length():
							_on_crawl_completed()
