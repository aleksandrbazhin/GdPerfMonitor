extends Control

onready var monitor = $Monitor

var last_usec: int = 0
func get_frame_time() -> float:
	var usec_delta: int = OS.get_ticks_usec() - last_usec
	last_usec += usec_delta
	return float(usec_delta) / 1000000.0

func _ready():
	# draws OS frame time, not interpolated
	monitor.add_funcref_monitor(funcref(self, "get_frame_time"), [], "OS time / frame, s", 
		Color(0.6, 0.4, 0.9, 0.6), false, false, 0.0)
	monitor.add_perf_monitor(Performance.TIME_PROCESS, "Time process, s", 
		Color(0.2, 0.6, 0.95, 0.4), false, false, 0.0)
	monitor.add_perf_monitor(Performance.TIME_FPS, "FPS")
#	monitor.add_perf_monitor(Performance.MEMORY_DYNAMIC, "Dyn mem", 
#		Color(0.8, 0.7, 0.2, 0.4), true)
#	monitor.add_perf_monitor(Performance.MEMORY_STATIC, "Stat mem", 
#		Color(0.2, 0.5, 0.8, 0.4), true, 360)	
#	var render_info_funcref: FuncRef = funcref(VisualServer, "get_render_info")
##	monitor.add_funcref_monitor(render_info_funcref, [VisualServer.INFO_TEXTURE_MEM_USED], 
##		"Texture mem", Color(0.9, 0.9, 0.9, 0.6), true)
#	# consider, that by default each monitor has 180 draw calls in this unoptimized version
#	monitor.add_funcref_monitor(render_info_funcref, [VisualServer.INFO_2D_DRAW_CALLS_IN_FRAME], 
#		"Draw calls", Color(0.2, 0.5, 0.8, 0.4))
