# Performance monitor node for Godot

Simple node for in-game monitoring of FPS, memory usage and such, loosely styled by Three.js's performance monitor.

![Example ](screens\monitor.gif)

It may have some performance overhead (around 180 draw calls per frame, CPU and mem usage is slight), but for FPS or memory monitoring it seems insignificant.

Can display any **numeric** object parameter or function call result.

### Usage

- Install from AssetLib

- Add Monitor node to your scene tree

- Setup what to monitor

  - ```python
      $Monitor.os_time_per_frame()
    ```
  - ```python
      $Monitor.add_perf_monitor(Performance.TIME_FPS, "FPS")
    ```
  - ```python
      $Monitor.add_custom_monitor($Player, "hitpoints", "Player hp")
      # your $Player node must have "hitpoints" attribute, which must be either float or int
    ```
  - ```python  
      var render_info_funcref: FuncRef = funcref(VisualServer, "get_render_info")
      $Monitor.add_funcref_monitor(render_info_funcref, [VisualServer.INFO_TEXTURE_MEM_USED], "Texture mem")
      ```

Also you can set plot size, color, or amount of plot stored data, check out example.gd.

Convenience function `$Monitor.os_time_per_frame()`, creates a monitor to show difference in `OS.get_ticks_usec()` between `_process()` calls.

### Reference


- ```
	os_time_perframe() - creates a plot panel to show difference between OS.get_ticks_usec() calls
  ```


- ```
	add_perf_monitor() - creates a plot panel to monitor one of the built-in Performance enum 
  
	# required
	param_key: int - key from Performance enum 
	
	# optional	
	label: String = "" - label to display
	color: Color = Color(0.2, 1, 0.2, 0.5) - color
	humanise: bool = false - whether to use humanize for large numbers
	is_data_int: bool = true - !important for floats change to false
	max_value: float = 0.0 - maximum value
	data_len: int = 180 
	size_px: Vector2 = Vector2(180, 80)
  ```


- ```
	add_custom_monitor() - creates a plot panel to monitor one of the passed objects' numeric attributes
  
	# required
	obj: Object - object to monitor
	param_name: String - name of numeric attribute of the object above
	
	# optional	
	label: String = "" - label to display
	color: Color = Color(0.2, 1, 0.2, 0.5) - color
	humanise: bool = false - whether to use humanize for large numbers
	is_data_int: bool = true - !important for floats change to false
	max_value: float = 0.0 - maximum value
	data_len: int = 180 
	size_px: Vector2 = Vector2(180, 80)
  ```


- ```
	add_funcref_monitor() - creates a plot panel to monitor results of the calls to the passed function
  
	# required
	function_ref: FuncRef - funcref to a function that will be called every _process()
	
	# optional	
	function_params: Array = [] - array of function param values
	label: String = "" - label to display
	color: Color = Color(0.2, 1, 0.2, 0.5) - color
	humanise: bool = false - whether to use humanize for large numbers
	is_data_int: bool = true - !important for floats change to false
	max_value: float = 0.0 - maximum value
	data_len: int = 180 
	size_px: Vector2 = Vector2(180, 80)
  ```
  

### Other notes

The draw call happens in _process(), so update rate may be not constant.

The plot uses some kind of ring buffer based on PoolIntArray or PoolRealArray for storing data. 

Rendering may be optimized.
