
extends Panel

class_name MonitorPlotPanel

const SIZE: Vector2 = Vector2(180, 80)
const DEFAULT_COLOR: Color = Color(0.2, 1, 0.2, 0.5)
const BG_COLOR: Color = Color(0.27, 0.32, 0.35, 0.91)

var plot_last_data: float = 0
var plot_color: Color = DEFAULT_COLOR
var is_mem_size: bool = false

var data_label: String = ""
var plot_data_max: float = 0.0
var data_scale: float = 1.0

var plot_image: Image
var plot_image_texture: ImageTexture
var plot_image_blit_rect: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)
var plot_bar_image: Image
var plot_bar_bg_image: Image
var plot_bar_rect: Rect2
var bg_image: Image

var plot_resize_acc: float = 0.0 # some value that accumulautes resizes less than 1 pixel

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
	bg_image = Image.new()
	bg_image.create(int(SIZE.x), int(SIZE.y), false, Image.FORMAT_RGBA8)
	bg_image.fill(BG_COLOR)
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
	plot_data_max = data_max
	data_scale = SIZE.y / float(plot_data_max)
	$LabelMax.text = "max: " + get_data_str(plot_data_max)


func get_data():
	return 0.0


func resize_plot_image(new_height: float):
	var resized: Image = Image.new()
	resized.copy_from(plot_image)
	resized.resize(int(SIZE.x), int(new_height), Image.INTERPOLATE_NEAREST)
	plot_image.copy_from(bg_image)
	plot_image.blit_rect(resized, 
		Rect2(Vector2.ZERO, Vector2(SIZE.x, new_height)),
		Vector2(0, SIZE.y - new_height))


func _process(_delta):
	plot_last_data = get_data()
	if plot_last_data > plot_data_max:
		var resize_height: float = SIZE.y * plot_data_max / plot_last_data
		reset_max_data(plot_last_data)
		if int(resize_height) > 0:
			var y_offset: float = SIZE.y - resize_height
			if y_offset < 1.0:
				if y_offset + plot_resize_acc > 1.0:
					resize_plot_image(SIZE.y - 1.0)
					plot_resize_acc = y_offset + plot_resize_acc - 1.0
				else:
					plot_resize_acc += y_offset
			else:
				plot_resize_acc = resize_height - floor(resize_height)
				resize_plot_image(floor(resize_height))
		else:
			plot_image.copy_from(bg_image)
	label_node.text = "%s: " % data_label + get_data_str(plot_last_data)
	update()
	

func _draw():
	plot_image.blit_rect(plot_image, plot_image_blit_rect, Vector2.ZERO)
	plot_image.blit_rect(plot_bar_bg_image, plot_bar_rect, Vector2(SIZE.x - 1, 0))
	var line_height: float = floor(data_scale * plot_last_data)
	plot_image.blit_rect(plot_bar_image, 
		Rect2(Vector2.ZERO, Vector2(1, line_height)), 
		Vector2(SIZE.x - 1, SIZE.y - line_height))
	plot_image_texture.set_data(plot_image)
	draw_texture(plot_image_texture, Vector2.ZERO)
