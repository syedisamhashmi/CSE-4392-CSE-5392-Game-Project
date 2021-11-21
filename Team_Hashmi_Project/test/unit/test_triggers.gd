extends "res://addons/gut/test.gd"

var DIALOG_TRIGGER        = preload("res://entities/triggers/dialog-trigger/dialog-trigger.tscn")
var CHECKPOINT_TRIGGER    = preload("res://entities/triggers/checkpoint-trigger/checkpoint-trigger.tscn")
var NEXT_LEVEL_TRIGGER    = preload("res://entities/triggers/next-level-trigger/next-level-trigger.tscn")
var MUSIC_TRIGGER         = preload("res://entities/triggers/music-trigger/music-trigger.tscn")

func before_each():
    gut.p("ran setup", 2)

func after_each():
    gut.p("ran teardown", 2)

func before_all():
    assert_eq(Globals.TESTS, false, "TESTS SHOULD BE FALSE")
    # Turn on testing so save files are not read from disk and
    # generated fresh every time
    Globals.TESTS = true 
    PlayerData.saveSlot = 999
    gut.p("ran run setup", 2)

func after_all():
    Globals.TESTS = false
    PlayerData.saveSlot = 0
    gut.p("ran run teardown", 2)

func test_assert_triggers_proper_types():
    var dialog       = DIALOG_TRIGGER.instance()
    var checkpoint   = CHECKPOINT_TRIGGER.instance()
    var nextLevel    = NEXT_LEVEL_TRIGGER.instance()
    var musicTrigger = MUSIC_TRIGGER.instance()
    assert_eq(dialog.type, EntityTypeEnums.TRIGGER_TYPE.DIALOG, "Dialog type should be set properly")
    assert_eq(checkpoint.type, EntityTypeEnums.TRIGGER_TYPE.CHECKPOINT, "Checkpoint type should be set properly")
    assert_eq(nextLevel.type, EntityTypeEnums.TRIGGER_TYPE.NEXT_LEVEL, "NextLevel type should be set properly")
    assert_eq(musicTrigger.type, EntityTypeEnums.TRIGGER_TYPE.MUSIC, "Music type should be set properly")
    
    dialog.queue_free()
    checkpoint.queue_free()
    nextLevel.queue_free()
    musicTrigger.queue_free()
    yield(get_tree().create_timer(1), "timeout")
