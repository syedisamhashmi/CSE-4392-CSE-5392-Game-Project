extends Node

enum TRIGGER_TYPE {
    NONE       =  -1
    DIALOG     =   1,
    CHECKPOINT =   2,
    SAVE       =  10,
    MUSIC      =  20,
    NEXT_LEVEL = 100   
}

enum ENEMY_TYPE {
    NONE       = -1
    SPIKE      =  5,
    BIG_ONION  = 10,
    PINEAPPLE  = 20,
    RADDISH    = 30,
    BROCCOLI   = 40,
    BABY_ONION = 50,
    POTATO     = 60,
    CARROT     = 70,
    BANANA_MAN = 80,
    CABBAGE    = 90,
    CORN       = 100,
    CAULIFLOWER= 110
}

enum PICKUP_TYPE {
    NONE           = -1,
    BANANA_THROW   = 10,
    BFG9000        = 11,
    BANANA_BLASTER = 12,
    
    GAS_MASK     = 20,
    HIGH_JUMP    = 21,
    SPIKE_ARMOR  = 22
    
    HEALTH       = 90
}

enum SPAWNER_TYPE {
    NONE       = -1
    SPIKE      = 10,
    POISON     = 20,
}
