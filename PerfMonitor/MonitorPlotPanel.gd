extends Panel

class_name MonitorPlotPanel

const DEFAULT_SIZE: Vector2 = Vector2(180, 120)
const DEFAULT_LEN: int = 180
const DEFAULT_COLOR: Color = Color(0.2, 1, 0.2, 0.5)
const BG_COLOR: Color = Color(0.27, 0.32, 0.35, 0.91)


var plot_data_int: PoolIntArray = []
var plot_data_float: PoolRealArray = []
var plot_len: int = DEFAULT_LEN
var plot_pointer: int = 0
var plot_last_data: float = 0
var plot_color: Color = DEFAULT_COLOR
var is_mem_size: bool = false

var data_label: String = "FPS"
var graph_size: Vector2 = DEFAULT_SIZE
var perf_data_max: float = 0.0
var data_scale: float = 2.0
var range_scale: float = 1.0

var plot_offset: int = 0
var plot_image: Image
var plot_image_texture: ImageTexture
var plot_image_blit_rect: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)


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
	
	plot_image = Image.new()
	plot_image.create(int(rect_min_size.x), int(rect_min_size.y), false, Image.FORMAT_RGBA8)
	plot_image_texture = ImageTexture.new()
	plot_image_texture.create_from_image(plot_image)
	plot_image_blit_rect.size = Vector2(rect_min_size.x - 1.0, rect_min_size.y)
	plot_image_blit_rect.position = Vector2(1.0, 0.0)



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

	plot_image.lock()
	plot_image.blit_rect(plot_image, plot_image_blit_rect, Vector2.ZERO)
	var line_start = graph_size.y + plot_offset - data_scale*plot_data_array[plot_pointer - 1]
	for i in range(graph_size.y):
		if i > line_start:
			plot_image.set_pixel(179, i, plot_color)
		else:
			plot_image.set_pixel(179, i, BG_COLOR)
	plot_image.unlock()
	plot_image_texture.set_data(plot_image)
	draw_texture(plot_image_texture, Vector2.ZERO)
