extends Node

enum TRIGGER_TYPE {
    NONE       =  -1
    DIALOG     =   1,
    CHECKPOINT =   2,
    SAVE       =  10,
    NEXT_LEVEL = 100   
}

enum ENEMY_TYPE {
    NONE       = -1
    SPIKE      =  5,
    BIG_ONION  = 10,
    PINEAPPLE  = 20,
    RADDISH    = 30
}

enum PICKUP_TYPE {
    NONE         = -1,
    BANANA_THROW = 10,
    
    GAS_MASK     = 20,
    HIGH_JUMP    = 21,
    SPIKE_ARMOR  = 22
    
    HEALTH       = 90
}
