extends Node

# Likely can use these as multipliers to reduce 
# player damage and increase enemy health
const DIFFICULTIES_I = [1,2,3,4] 
const DIFFICULTIES_STR = [
    "",
    "Can I Play, Daddy?", 
    "I'm too squishy to die!",
    "Bruise Me Plenty",
    "I Am Banana Incarnate!"
    ]
# If you get this throwback, we can be friends :)
const DIFFICULTIES = {
    CAN_I_PLAY_DADDY      = "Can I Play, Daddy?",      # Easy
    IM_TOO_SQUISHY_TO_DIE = "I'm too squishy to die!", # Medium
    BRUISE_ME_PLENTY      = "Bruise Me Plenty",        # Hard
    I_AM_BANANA_INCARNATE = "I Am Banana Incarnate!",  # Nightmare   
}
const DIFFICULTIES_DESCRIPTIONS = [
    """Gameplay for babies. (i.e. Dr. Dalio)
    - Forgiving gameplay
    - Slow and methodical, 
      large damage cooldown after being hit.
    - Lots of health pickups
    - Lots of ammo pickups 
    """,
    """
    If you heard the saying "If you can't handle the heat, get out of the kitchen". 
    You probably left the kitchen...
    - Enemies are not so kind.
    - Smaller damage cooldowns.
    - Lots of health pickups
    - Lots of ammo pickups
    """,
    
    """So, you think you are worthy... This is a challenge.
    - Enemies are aggresive
    - No rushing, but you might want to be in a hurry.
    - Fewer health pickups
    - Fewer ammo pickups
    """,
    
    """This is a literal nightmare.
    - Enemies are potassium-thirsty and aggressive.
    - Damage cooldown is practically non-existent.
    - Health pickups are rare. Be wise.
    - Ammo pickups are rare. Be wise.
    """   
]

const ExitMessages = [
    "Don't leave yet -- There's a banana around that corner!",
    "Are you sure you want to quit this amazing game?",
    "Look, man. You leave now and you forfeit your stats!",
    "Just leave. When you come back, I'll be waiting with a banana.",
    "You're lucky I don't delete your save game for thinking about leaving.",
    "Get outta here and go back to your boring life."
]
