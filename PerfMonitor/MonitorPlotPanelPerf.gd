extends MonitorPlotPanel


var perf_monitor_key: int = Performance.TIME_FPS


func setup_plot(monitor_key: int, label: String, data_max: float, 
		color: Color, is_humanise_needed: bool = false):
	perf_monitor_key = monitor_key
	.init_plot(label, data_max, color, is_humanise_needed)


func get_data():
	return Performance.get_monitor(perf_monitor_key)
