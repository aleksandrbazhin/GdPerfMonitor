extends CanvasLayer


const DEFAULT_DATA_LEN: int = 180 # in frames of _process
const DEFAULT_PLOT_COLOR: Color = Color(0.2, 1, 0.2, 0.5)
const DEFAULT_PLOT_SIZE: Vector2 = Vector2(180, 80)
const DEFAULT_DATA_MAX: float = 1.0
#var 

onready var plot_scene: PackedScene = preload("PerfPlotPanel.tscn")

func _ready():
	add_perf_monitor(Performance.TIME_FPS, "FPS")
#	add_perf_monitor(Performance.TIME_PROCESS, "Time process, s", 
#		Color(0.9, 0.9, 0.9, 0.6), false, false, 0.0001)
#	add_perf_monitor(Performance.MEMORY_DYNAMIC, "Dyn mem", 
#		Color(0.8, 0.7, 0.2, 0.4), true)
#	add_perf_monitor(Performance.MEMORY_STATIC, "Stat mem", 
#		Color(0.2, 0.5, 0.8, 0.4), true, 360)

func add_perf_monitor(param_key: int, 
					label: String = "",  
					color: Color = DEFAULT_PLOT_COLOR, 
					humanise: bool = false, 
					is_data_int: bool = true, 
					max_value: float = DEFAULT_DATA_MAX,
					data_len: int = DEFAULT_DATA_LEN, 
					size_px: Vector2 = DEFAULT_PLOT_SIZE):
	var new_plot: PerfPlotPanel = plot_scene.instance()
	$Margin/HBox.add_child(new_plot)
	new_plot.setup_plot(param_key, label, max_value, data_len, color, size_px, is_data_int, humanise)
	
func add_custom_monitor(obj: Object, param_name: String, 
					label: String = "",  
					color: Color = DEFAULT_PLOT_COLOR, 
					humanise: bool = false, 
					is_data_int: bool = true, 
					max_value: float = DEFAULT_DATA_MAX,
					data_len: int = DEFAULT_DATA_LEN, 
					size_px: Vector2 = DEFAULT_PLOT_SIZE):
	var new_plot: PerfPlotPanel = plot_scene.instance()
	$Margin/HBox.add_child(new_plot)
	new_plot.setup_custom_plot(obj, param_name, label, max_value, data_len, color, size_px, is_data_int, humanise)
