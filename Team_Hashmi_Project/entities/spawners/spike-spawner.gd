extends "res://entities/spawners/base-spawner.gd"

func setUpObj(newObj):
    newObj.physOverride = true
    newObj.rotation_degrees = 180
    newObj.deployed = true
    newObj.scale.x = .4
    newObj.scale.y = .4
    return newObj
