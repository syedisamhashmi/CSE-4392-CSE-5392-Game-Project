extends Node

func _input(_event: InputEvent) -> void:
    # TODO:
    # ! This should go to a pause menu, and 
    # ! an exit button should trigger this!
    if (Input.is_action_pressed("ui_cancel")):
        # Emit an exit signal picked up by:
        # - globals, to save player stats 
        #   TODO: maybe make multiple save game states with separate stats
        Signals.emit_signal("exit_game")
        # Exit program
        get_tree().quit(0)
