extends Node

# warning-ignore:unused_signal
signal exit_game()

# warning-ignore:unused_signal
signal banana_throw_pickup_get(pickupId)
# warning-ignore:unused_signal
signal gas_mask_pickup_get(pickupId)
# warning-ignore:unused_signal
signal health_pickup_get(pickupId)    
# warning-ignore:unused_signal
signal high_jump_pickup_get(pickupId)
    
 # warning-ignore:unused_signal
signal player_location_changed(position)
    
# warning-ignore:unused_signal
signal player_health_changed(health)

# warning-ignore:unused_signal
signal player_weapon_changed(weaponId)

# warning-ignore:unused_signal
signal player_ammo_changed(ammoCount)

# warning-ignore:unused_signal
signal player_damage_dealt(amount)
# warning-ignore:unused_signal
signal player_death()

# warning-ignore:unused_signal
signal displayDialog(dialogText, id)
# warning-ignore:unused_signal
signal checkpoint(id)
# warning-ignore:unused_signal
signal next_level_trigger(levelId)
# warning-ignore:unused_signal
signal next_level_trigger_complete(fromTrigger)

# warning-ignore:unused_signal
signal pc(c)
