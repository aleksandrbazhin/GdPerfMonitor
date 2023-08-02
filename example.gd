extends Control

@onready var monitor = $Monitor


func _ready():
	# draws OS time between frames, not interpolated
	monitor.os_time_per_frame()

#	# add_perf_monitor adds anything from Performance Godot object
	monitor.add_perf_monitor(Performance.TIME_PROCESS, "Time process, s", 
		Color(0.2, 0.6, 0.95, 0.4), false, false, 0.0)
	monitor.add_perf_monitor(Performance.TIME_FPS, "FPS")
	monitor.add_perf_monitor(Performance.RENDER_VIDEO_MEM_USED, "Dyn mem", 
		Color(0.8, 0.7, 0.2, 0.4), true)
	monitor.add_perf_monitor(Performance.MEMORY_STATIC, "Stat mem", 
		Color(0.2, 0.5, 0.8, 0.4), true, 360)	
#
	var render_info_funcref: Callable = Callable(RenderingServer, "get_render_info")
	monitor.add_funcref_monitor(render_info_funcref, [RenderingServer.RENDERING_INFO_TEXTURE_MEM_USED], 
		"Texture mem", Color(0.9, 0.9, 0.9, 0.6), true)
# 
#	# consider, that by default each monitor has 180 draw calls in this unoptimized version
	monitor.add_funcref_monitor(render_info_funcref, [RenderingServer.VIEWPORT_RENDER_INFO_DRAW_CALLS_IN_FRAME], 
		"Draw calls", Color(0.2, 0.5, 0.8, 0.4))
#
#	# if we had a Player node we could add something like that provided 
#	# - $Player is already initialized
#	# - $Player has "hitpoints" attribute, which is either float or int
#	monitor.add_custom_monitor($Player, "hitpoints", "Player hp")
