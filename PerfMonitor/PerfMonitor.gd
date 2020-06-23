extends CanvasLayer


const DEFAULT_DATA_LEN: = 180 # in frames of _process calls
const DEFAULT_PLOT_COLOR: = Color(0.2, 1, 0.2, 0.5)
const DEFAULT_PLOT_SIZE: = Vector2(180, 80)
const DEFAULT_DATA_MAX: = 1.0


onready var plot_scene_perf: PackedScene = preload("MonitorPlotPanelPerf.tscn")
onready var plot_scene_custom: PackedScene = preload("MonitorPlotPanelObjParam.tscn")
onready var plot_scene_funcref: PackedScene = preload("MonitorPlotPanelFuncref.tscn")


func _ready():
	add_perf_monitor(Performance.TIME_FPS, "FPS")
#	add_perf_monitor(Performance.TIME_PROCESS, "Time process, s", 
#		Color(0.9, 0.9, 0.9, 0.6), false, false, 0.0001)
#	add_perf_monitor(Performance.MEMORY_DYNAMIC, "Dyn mem", 
#		Color(0.8, 0.7, 0.2, 0.4), true)
#	add_perf_monitor(Performance.MEMORY_STATIC, "Stat mem", 
#		Color(0.2, 0.5, 0.8, 0.4), true, 360)	
#	var render_info_funcref: FuncRef = funcref(VisualServer, "get_render_info")
#	add_funcref_monitor(render_info_funcref, [VisualServer.INFO_TEXTURE_MEM_USED], 
#		"Texture mem", Color(0.9, 0.9, 0.9, 0.6), true)
#	add_funcref_monitor(render_info_funcref, [VisualServer.INFO_2D_DRAW_CALLS_IN_FRAME], 
#		"Draw calls", Color(0.2, 0.5, 0.8, 0.4))


func add_perf_monitor(param_key: int, 
					label: String = "",  
					color: Color = DEFAULT_PLOT_COLOR, 
					humanise: bool = false, 
					is_data_int: bool = true, 
					max_value: float = DEFAULT_DATA_MAX,
					data_len: int = DEFAULT_DATA_LEN, 
					size_px: Vector2 = DEFAULT_PLOT_SIZE):
	var new_plot: MonitorPlotPanel = plot_scene_perf.instance()
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
	var new_plot: MonitorPlotPanel = plot_scene_custom.instance()
	$Margin/HBox.add_child(new_plot)
	new_plot.setup_plot(obj, param_name, label, max_value, data_len, color, size_px, is_data_int, humanise)


func add_funcref_monitor(function_ref: FuncRef, function_params: Array = [], 
					label: String = "",  
					color: Color = DEFAULT_PLOT_COLOR, 
					humanise: bool = false, 
					is_data_int: bool = true, 
					max_value: float = DEFAULT_DATA_MAX,
					data_len: int = DEFAULT_DATA_LEN, 
					size_px: Vector2 = DEFAULT_PLOT_SIZE):
	var new_plot: MonitorPlotPanel = plot_scene_funcref.instance()
	$Margin/HBox.add_child(new_plot)
	new_plot.setup_plot(function_ref, function_params, label, max_value, data_len, color, size_px, is_data_int, humanise)
