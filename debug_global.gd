extends Node

# debug global node script created by Tampopo Interactive, modified by Dungon Corps.
# to take screenshots in-game, add a folder called "screenshots" to res://

@export var mute_on_start: bool = false ## If [code]true[/code], the master bus is muted at game launch.
@export var print_focus: bool = false ## If [code]true[/code], prints the name of each node the viewport changes focus to.
@export var cap_fps: bool = true ## Caps the engine's max FPS at runtime while [code]true[/code].
@export var _framerate: int = 24 ## FPS will be capped to if [b]Cap FPS[/b] is [code]true[/code].
@export var zoom_out: bool = false ## Creates a debug [b]Camera2D[/b] then zooms out by x4 if [code]true[/code].

@onready var music_bus = AudioServer.get_bus_index("Master")

var confirmation_dialog: ConfirmationDialog = null
var is_fullscreen: bool = false
var is_muted: bool = false
var session_screenshot_count: int = 0

func _init() -> void:
	if cap_fps:
		Engine.max_fps = _framerate
		if OS.is_debug_build():
			print_debug("FPS capped at ", _framerate)

func _ready() -> void:
	if zoom_out:
		var camera = Camera2D.new()
		camera.zoom = Vector2(.25,.25)
		add_child(camera)
		camera.position = Vector2(128, 120)
		camera.make_current()
	get_viewport().gui_focus_changed.connect(_on_viewport_focus_changed)
	if mute_on_start:
		AudioServer.set_bus_mute(music_bus, true)
		is_muted = AudioServer.is_bus_mute(music_bus)
		print_debug("Bus no. ", music_bus, " muted on start.")

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode:
		match event.keycode:
			KEY_F:
				_toggle_fullscreen()
			KEY_M:
				_toggle_mute()
			KEY_P:
				get_tree().paused = !get_tree().paused
				print_debug("paused: ", get_tree().paused)
			KEY_Q:
				_exit_game()
			KEY_R:
				if OS.is_debug_build():
					OS.alert("Reloading current scene.")
					get_tree().reload_current_scene()
					print_debug("reloaded current scene")
				else:
					pass
			KEY_1:
				if OS.is_debug_build():
					_take_screenshot()
				else:
					pass
			KEY_ESCAPE:
				if OS.is_debug_build():
					get_tree().quit()
				else:
					pass
			_:
				pass
		get_viewport().set_input_as_handled()
	else:
		pass

func _toggle_fullscreen() -> void:
	is_fullscreen = !is_fullscreen
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if OS.is_debug_build():
		print_debug("fullscreen toggled: ", is_fullscreen)

func _toggle_mute() -> void:
	var new_value = !is_muted
	is_muted = new_value
	assert(is_muted == new_value)
	AudioServer.set_bus_mute(music_bus, new_value)
	if OS.is_debug_build():
		print_debug("master bus muted: %s"  % is_muted)

func _exit_game() -> void:
	if confirmation_dialog == null:
		confirmation_dialog = ConfirmationDialog.new()
		confirmation_dialog.unresizable = true
		add_child(confirmation_dialog)
		confirmation_dialog.dialog_text = "Quit Game?"
		confirmation_dialog.confirmed.connect(_on_confirmed)
		confirmation_dialog.canceled.connect(_on_cancelled)
		confirmation_dialog.popup_centered()

func _on_confirmed() -> void:
	get_tree().auto_accept_quit = true
	if OS.is_debug_build():
		print_debug("quitting...")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_cancelled() -> void:
	confirmation_dialog.confirmed.disconnect(_on_confirmed)
	confirmation_dialog.canceled.disconnect(_on_cancelled)
	confirmation_dialog = null

func _take_screenshot() -> void:
	var screen: Image = get_viewport().get_texture().get_image()
	var file_path = "res://screenshots/screen_" + Time.get_date_string_from_system() + "_" + str(session_screenshot_count) + ".png"
	screen.save_png(file_path)
	session_screenshot_count += 1
	print_debug("screenshot taken")

func _on_viewport_focus_changed(node: Control) -> void:
	if print_focus:
		print_debug(node.name)
