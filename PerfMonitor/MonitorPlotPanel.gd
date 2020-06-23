extends Panel

class_name MonitorPlotPanel

const DEFAULT_SIZE: = Vector2(180, 120)
const DEFAULT_LEN: = 180
const DEFAULT_COLOR: = Color(0.2, 1, 0.2, 0.5)

var plot_data_int: PoolIntArray = []
var plot_data_float: PoolRealArray = []
var plot_len: int = DEFAULT_LEN
var plot_pointer: int = 0
var plot_last_data: float = 0
var plot_color: Color = DEFAULT_COLOR
var is_mem_size: bool = false

var data_label: String = "FPS"
#var perf_monitor_key: int = Performance.TIME_FPS
var graph_size: Vector2 = DEFAULT_SIZE
var perf_data_max: = 0.0
var data_scale: = 2.0
var range_scale: = 1.0

var plot_offset: = 0

onready var label_node: Label = $Label
onready var plot_data_array = plot_data_int


func init_plot(label: String, data_max: float, plot_length_frames: int = DEFAULT_LEN, 
		color: Color = DEFAULT_COLOR, size: Vector2 = DEFAULT_SIZE, 
		is_data_int: bool = true, is_humanise_needed: bool = false):
	plot_len = plot_length_frames
	data_label = label
	graph_size = size
	rect_min_size = graph_size
	resize_height()
	plot_color = color
	is_mem_size = is_humanise_needed
	reset_max_data(data_max)
	if is_data_int:
		plot_data_array = plot_data_int
	else:
		plot_data_array = plot_data_float
	init_data_array()


func resize_height():
	if rect_min_size.y < rect_size.y:
		plot_offset = int((rect_size.y - rect_min_size.y) / 2.0)


func get_data_str(data) -> String:
	return str(data) if not is_mem_size else String.humanize_size(data)


func reset_max_data(data_max: float):
	perf_data_max = data_max
	update_scale()
	$LabelMax.text = "max: " + get_data_str(perf_data_max)


func update_scale():
	data_scale = graph_size.y / float(perf_data_max)
	range_scale = graph_size.x / float(plot_len)
	
	
func init_data_array():
	plot_data_array.resize(plot_len)
	for i in range(plot_len):
		plot_data_array[i] = 0

func get_data():
	return 0.0

func _process(_delta):
	resize_height()
	plot_last_data = get_data()
	if plot_last_data > perf_data_max:
		reset_max_data(plot_last_data)
	label_node.text = "%s: " % data_label + get_data_str(plot_last_data)
	if plot_data_array.size() == 0: 
		return
	plot_data_array[plot_pointer] = plot_last_data
	update()
	if plot_pointer < plot_len-1:
		plot_pointer += 1
	else:
		plot_pointer = 0
	

func _draw():
	if plot_data_array.size() == 0:
		print("ERROR: PLOT WAS NOT SET UP ", name)
		return
	var draw_pointer: int = plot_pointer 
	var line_from: Vector2 = Vector2(0, graph_size.y + plot_offset)
	var line_to: Vector2 = Vector2(0, 0)
	for i in range(plot_len):
		line_from.x = (i + 1) * range_scale
		line_to.x = line_from.x
		line_to.y = plot_offset + graph_size.y - data_scale * plot_data_array[draw_pointer]
		draw_line(line_from, line_to, plot_color, range_scale)
		if draw_pointer < plot_len - 1:
			draw_pointer += 1
		else:
			draw_pointer = 0
