extends Panel

class_name MonitorPlotPanel

const SIZE: Vector2 = Vector2(180, 80)
const DEFAULT_COLOR: Color = Color(0.2, 1, 0.2, 0.5)
const BG_COLOR: Color = Color(0.27, 0.32, 0.35, 0.91)

var plot_last_data: float = 0
var plot_color: Color = DEFAULT_COLOR
var is_mem_size: bool = false

var data_label: String = ""
var perf_data_max: float = 0.0
var data_scale: float = 1.0

var plot_image: Image
var plot_image_texture: ImageTexture
var plot_image_blit_rect: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)
var plot_bar_image: Image
var plot_bar_bg_image: Image
var plot_bar_rect: Rect2

onready var label_node: Label = $Label


func init_plot(label: String, data_max: float, color: Color = DEFAULT_COLOR, 
		is_humanise_needed: bool = false):
	rect_min_size = SIZE
	data_label = label
	plot_color = color
	is_mem_size = is_humanise_needed
	reset_max_data(data_max)

	plot_image = Image.new()
	plot_image.create(int(SIZE.x), int(SIZE.y), false, Image.FORMAT_RGBA8)
	plot_image_texture = ImageTexture.new()
	plot_image_texture.create_from_image(plot_image)
	plot_image_blit_rect.size = Vector2(SIZE.x - 1.0, SIZE.y)
	plot_image_blit_rect.position = Vector2(1.0, 0.0)
	plot_bar_image = Image.new()
	plot_bar_image.create(1, int(SIZE.y), false, Image.FORMAT_RGBA8)
	plot_bar_image.fill(plot_color)
	plot_bar_bg_image = Image.new()
	plot_bar_bg_image.create(1, int(SIZE.y), false, Image.FORMAT_RGBA8)
	plot_bar_bg_image.fill(BG_COLOR)
	plot_bar_rect = Rect2(Vector2.ZERO, Vector2(1, SIZE.y))


func get_data_str(data) -> String:
	return str(data) if not is_mem_size else String.humanize_size(data)


func reset_max_data(data_max: float):
	perf_data_max = data_max
	data_scale = SIZE.y / float(perf_data_max)
	$LabelMax.text = "max: " + get_data_str(perf_data_max)


func get_data():
	return 0.0


func _process(_delta):
	plot_last_data = get_data()
	if plot_last_data > perf_data_max:
		reset_max_data(plot_last_data)
	label_node.text = "%s: " % data_label + get_data_str(plot_last_data)
	update()
	

func _draw():
	plot_image.blit_rect(plot_image, plot_image_blit_rect, Vector2.ZERO)
	plot_image.blit_rect(plot_bar_bg_image, plot_bar_rect, Vector2(SIZE.x - 1, 0))
	var line_height: float = ceil(data_scale * plot_last_data)
	plot_image.blit_rect(plot_bar_image, 
		Rect2(Vector2.ZERO, Vector2(1, line_height)), 
		Vector2(SIZE.x - 1, SIZE.y - line_height))
	plot_image_texture.set_data(plot_image)
	draw_texture(plot_image_texture, Vector2.ZERO)
