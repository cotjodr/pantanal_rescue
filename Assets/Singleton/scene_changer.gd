extends CanvasLayer

signal scene_changed()

func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	$TransitionsFX.interpolate_property($Overlay, "progress", 0.0, 1.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$TransitionsFX.start()
	yield($TransitionsFX, "tween_completed")
	assert(get_tree().change_scene(path) == OK)
	$TransitionsFX.interpolate_property($Overlay, "progress", 1.0, 0.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$TransitionsFX.start()
	yield($TransitionsFX, "tween_completed")
	emit_signal("scene_changed")
