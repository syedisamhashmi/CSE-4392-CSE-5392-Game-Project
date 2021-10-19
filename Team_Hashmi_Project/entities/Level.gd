extends Node2D

func _enter_tree() -> void:
    # warning-ignore:return_value_discarded
    Signals.connect("player_health_changed", self, "playerHealthChanged")
    # warning-ignore:return_value_discarded
    Signals.connect("player_weapon_changed", self, "playerWeaponChanged")
    # warning-ignore:return_value_discarded
    Signals.connect("player_ammo_changed", self, "playerAmmoChanged")

func playerHealthChanged(health) -> void:
    $HUD/HUD_BG/HPValue.set_text(str(health))
    
func playerWeaponChanged(weaponId) -> void:
    $HUD/HUD_BG/CurrentWeaponValue.set_text(str(weaponId))

func playerAmmoChanged(ammo) -> void:
    $HUD/HUD_BG/AmmoValue.set_text(str(ammo))

#region ForFunsies
# Code made ugly ON PURPOSE to keep EVERYONE OUT.
# Not my best attempt to hide stuff. 
# But try to figure it out. AFTER TRYING IN GAME :)
var t = [87,89,65,67,73,86,70,77,85,66,82,78,69,81,68,74,72,75,84,80,83,71,88,90,76,79]
var xt = [2,9,3,14,12,6,21,16,4,15,17,24,7,11,25,19,13,10,20,18,8,5,0,22,1,23]
# If you are considering it.
var kc = PoolByteArray([])
# Don't debug for the answer.
func _input(event: InputEvent) -> void:
    # You will be a horrible person.
    if !event is InputEventKey: return
    # I will never forgive you.
    var eventKey = event as InputEventKey
    # Seriously?
    if(eventKey.pressed or eventKey.scancode < 65 or eventKey.scancode > 90): return
    # Does my begging mean nothing to you?
    kc.append(t[xt[eventKey.scancode - 65]])
    # Quit looking at the code. Go play the game.
    var c = null
    # You don't HAVE to understand every piece of code.
    if kc.size() > 100: kc = PoolByteArray([])
    if Utils.n(rxt(Globals.x)) in Utils.n(kc):c = Globals.x
    # If you got this far, you obviously don't care.
    if Utils.n(rxt(Globals.y)) in Utils.n(kc):c = Globals.y
    # Stop. Reading. This. Code.
    if c != null: Signals.emit_signal("pc", c)
    # Fine. You're a bad person. 
    if c != null: kc = PoolByteArray([])
    #Get a life.
func rxt(a: PoolByteArray) -> PoolByteArray:
    # If you are reading this, you HAVE to give me an A, Dr. Dalio.
    var j = PoolByteArray([])
    for i in a: j.append(t[xt[i]])
    # If you are still reading this. It has to be in ALL classes
    return j
#endregion
