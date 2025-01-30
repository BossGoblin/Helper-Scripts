@tool
extends EditorScript

var disable_all: bool = false

# List of all GDScript warning settings:
var warning_settings = [
	"unsafe_call_argument",
	"unsafe_method_access",
	"unsafe_property_access",
	"unsafe_cast",
	"unsafe_call",
	"unsafe_return",
	"unused_variable",
	"unused_argument",
	"unused_signal",
	"standalone_expression",
	"redundant_await",
	"shadowed_variable",
	"incompatible_ternary",
	"integer_division",
	"unused_class_variable",
	"unused_constant",
	"unused_enum",
	"unused_parameter",
	"unused_local_variable",
	"unused_private_class_variable",
	"unreachable_code",
	"return_value_discarded",
	"confusable_identifier",
	"narrowing_conversion",
	"infinite_loop",
	"static_called_on_instance",
	"redundant_static_unload",
	"deprecated_keyword",
	"unsafe_cast_to_node",
	"unsafe_call_argument_node",
	"unsafe_method_access_node",
	"unsafe_property_access_node",
	"unsafe_call_node",
	"unsafe_return_node",
	"unsafe_cast_node",
]

func set_warnings():
	if disable_all == true:
		disable_all_warnings()
		print("All GDScript warnings have been disabled.")
	else:
		var warnings_to_disable = [
			"integer_division",
			"unused_variable",
			]
		disable_specific_warnings(warnings_to_disable)
		print("Specified warnings have been disabled.")

# Function to disable all warnings
func disable_all_warnings():
	for warning in warning_settings:
		if ProjectSettings.has_setting("debug/gdscript/warnings/" + warning):
			ProjectSettings.set_setting("debug/gdscript/warnings/" + warning, false)
		else:
			print("Warning setting not found: ", warning)
	ProjectSettings.save()

# Function to disable specific warnings
func disable_specific_warnings(warnings_to_disable: Array):
	for warning in warnings_to_disable:
		if ProjectSettings.has_setting("debug/gdscript/warnings/" + warning):
			ProjectSettings.set_setting("debug/gdscript/warnings/" + warning, false)
		else:
			print("Warning setting not found: ", warning)
	ProjectSettings.save()

func set_dispaly_and_rendering():
	# Display:
	ProjectSettings.set_setting("display/window/size/viewport_width", 256)
	ProjectSettings.set_setting("display/window/size/viewport_height", 240)
	ProjectSettings.set_setting("display/window/size/window_width_override", 256 * 3)
	ProjectSettings.set_setting("display/window/size/window_height_override", 240 * 3)
	ProjectSettings.set_setting("display/window/size/sharp_corners", true)
	ProjectSettings.set_setting("display/window/stretch/aspect", "keep")
	ProjectSettings.set_setting("display/window/stretch/mode", "viewport")
	# Rendering:
	ProjectSettings.set_setting("rendering/2d/snap/snap_2d_transforms_to_pixel", true)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa", 0)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/use_taa", false)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/fxaa", false)
	ProjectSettings.set_setting("rendering/textures/default_filters/filter_mode", "nearest")
	
	ProjectSettings.save()
	print("display/rendering set.")

func set_custom_input_map() -> void:
	var input_enter: InputEventKey = InputEventKey.new()
	input_enter.keycode = KEY_ENTER
	var input_space: InputEventKey = InputEventKey.new()
	input_space.keycode = KEY_SPACE
	var input_shift: InputEventKey = InputEventKey.new()
	input_shift.keycode = KEY_SHIFT
	var input_controller_a: InputEventJoypadButton = InputEventJoypadButton.new()
	input_controller_a.button_index = JOY_BUTTON_A
	var input_controller_b: InputEventJoypadButton = InputEventJoypadButton.new()
	input_controller_b.button_index = JOY_BUTTON_B
	ProjectSettings.set_setting('input/ui_accept', {'deadzone':0.2, 'events':[input_enter, input_space, input_controller_a]})
	ProjectSettings.set_setting('input/ui_select', {'deadzone':0.2, 'events':[input_enter, input_space, input_controller_a]})
	ProjectSettings.set_setting('input/ui_cancel', {'deadzone':0.2, 'events':[input_shift, input_controller_b]})
	ProjectSettings.save()

# Run via File -> Run
func _run():
	set_warnings()
	set_dispaly_and_rendering()
	set_custom_input_map()
	print_debug("/// settings tool finished. ///")
