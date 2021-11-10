# NOTE Adapted from https://github.com/benbishopnz/godot-credits
# MIT License

extends Control

const section_time := 2.0
const line_time := .7
var base_speed := 50.0
var speed_up_multiplier := 10.0

var scroll_speed := base_speed
var speed_up := false

onready var titleLine := $TitleLine
onready var storyLine := $StoryLine
onready var categoryLine := $CategoryLine
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
    [
        {"txt": "Banana Mania", "type": "t"},     
    ],
    [
        {"txt": "Team H for Hashmi", "type": "t"},
    ],
    [
        {"txt": "Syed Isam Hashmi", "type": "t"},
        
        {"txt":"UI", "type": "c"},
        {"txt":"     - In-Game HUD", "type": "s"},
        {"txt":"     - Main Menu", "type": "s"},
        {"txt":"    - Pause Menu", "type": "s"},
        
        {"txt":"Player Development", "type": "c"},
        {"txt":"    Movement Integration", "type": "c"},
        {"txt":"    Animation Integration", "type": "c"},
        {"txt":"            - Sprites (Engine Work)", "type": "s"},
        {"txt":"            - Run (Engine Work)", "type":"s"},
        {"txt":"            - Run Arms (Engine Work)", "type":"s"},
        {"txt":"            - Idle (Engine Work)", "type":"s"},
        {"txt":"            - Slide (Engine Work)", "type":"s"},
        {"txt":"            - Punch (Engine Work)", "type":"s"},
        
        {"txt":"Player Functionality", "type": "c"},
        {"txt":"        - Banana Throwing", "type": "s"},
        {"txt":"        - Camera", "type": "s"},
        {"txt":"        - Statistic Tracking", "type": "s"},
        {"txt":"        - Weapon Switching System", "type": "s"},
        {"txt":"        - Save / Load System", "type": "s"},
        {"txt":"        - Statistic Tracking", "type": "s"},
        
        {"txt":"Enemies", "type": "c"},
        {"txt":"    Pineapple", "type": "c"},
        {"txt":"            - Enemy Logic", "type": "s"},
        {"txt":"            - Animation Integration (Engine Work)", "type": "s"},
        {"txt":"            - Projectile Integration (Engine Work)", "type": "s"},
        {"txt":"    Raddish", "type": "c"},
        {"txt":"            - Enemy Logic", "type": "s"},
        {"txt":"            - Animation Integration (Engine Work)", "type": "s"},
        {"txt":"    Big Onion", "type": "c"},
        {"txt":"            - Enemy Logic", "type": "s"},
        {"txt":"            - Animation Integration (Engine Work)", "type": "s"},
        {"txt":"            - Poison Integration (Engine Work)", "type": "s"},

        {"txt":"Triggers", "type": "c"},
        {"txt":"        - Checkpoint", "type": "s"},
        {"txt":"        - Dialog", "type": "s"},
        {"txt":"        - Next Level", "type": "s"},
        
        {"txt":"Various Gameplay Mehanics", "type": "c"},
        {"txt":"        - Tile Map Integration", "type": "s"},
        {"txt":"        - Spike Obstacles", "type": "s"},
        {"txt":"        - Destructible Tiles", "type": "s"},
        
        {"txt":"Level Design Tools", "type": "c"},
        
        {"txt":"Release Pipelines / Git Management", "type": "c"},
        {"txt":"This Credits Sequence", "type": "c"},
        {"txt":"    Adapted from https://github.com/benbishopnz/godot-credits", "type": "s"}
        
    ],[
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "Edward Kressler", "type": "t"},
        #TODO: Edward
    ],
    [
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "Assets", "type": "t"},
        {"txt": "Fonts", "type": "c"},
        {"txt": "AreaKilometer50-ow3xB.ttf", "type": "s"},
        {"txt": "        www.fontspace.com/a-area-kilometer-50-font-f53888", "type": "s"},
        {"txt": "        Freeware", "type": "s"},
        
        {"txt": "Audio", "type": "c"},
        {"txt": "87535__whiprealgood__splat", "type": "s"},
        {"txt": "        freesound.org/people/Whiprealgood/sounds/87535", "type": "s"},
        {"txt": "        Creative Commons License 0", "type": "s"},
        {"txt": "253172__suntemple__retro-bonus-pickup-sfx", "type": "s"},
        {"txt": "        freesound.org/people/suntemple/sounds/253172", "type": "s"},
        {"txt": "        Creative Commons License 0", "type": "s"},
                
        {"txt": "Images", "type": "c"},
        {"txt": "explosion_01_strip13.png", "type": "s"},
        {"txt": "        opengameart.org/content/simple-explosion-bleeds-game-art", "type": "s"},
        {"txt": "        Creative Commons License 3", "type": "s"},
        {"txt": "        Attribution: Please check out Bleed - emusprites.carbonmade.com", "type": "s"},
        {"txt": "spikes.png", "type": "s"},
        {"txt": "        opengameart.org/content/spikes-0", "type": "s"},
        {"txt": "        Public Domain CC0", "type": "s"},
        {"txt": "pixel_icons_by_oceansdream.png", "type": "s"},
        {"txt": "        opengameart.org/content/various-inventory-24-pixel-icon-set", "type": "s"},
        {"txt": "        Creative Commons - BY 3.0, Creative Commons - BY-SA 3.0", "type": "s"},
        
        {"txt": "Pixel Art Vegetable Monsters Sprite Pack", "type": "s"},
        {"txt": "        elthen.itch.io/2d-pixel-art-vegetable-monsters-sprite-pack", "type": "s"},
        {"txt": "!PAID!  \"Feel free to use the sprites in commercial/non-commercial projects!\"", "type": "s"},
                
        {"txt": "night-city-street-game-background-tiles", "type": "s"},
        {"txt": "        free-game-assets.itch.io/night-city-street-2d-background-tiles", "type": "s"},
        {"txt": "!PAID!  \"no restrictions on use in commercial projects, \nas well as you can freely use each product in unlimited number of projects\"", "type": "s"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "All purchased assets will be spliced out of git history \nbefore going public before anyone thinks to steal anything. :)", "type": "s"},
    ]
    ,[
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "Special Thanks", "type": "t"},
        {"txt": "My Wife, Sana - Main Menu Difficulty Images <3 - Isam", "type": "s"},
        {"txt": "Edward's Cat, for always meowing on calls and keeping me going. - Isam", "type": "s"},
        # If you want to add any thanks, do it here
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        
        {"txt": "", "type": "t"},
        {"txt": "", "type": "t"},
        {"txt": "", "type": "fin"}
    ],
]


func _process(delta):
    if finished:
        return
    scroll_speed = base_speed * delta
    
    if section_next:
        section_timer += delta * speed_up_multiplier if speed_up else delta 
        if section_timer >= section_time:
            section_timer -= section_time
            
            if credits.size() > 0:
                started = true
                section = credits.pop_front()
                curr_line = 0
                add_line()
    
    else:
        line_timer += delta * speed_up_multiplier if speed_up else delta
        if line_timer >= line_time:
            line_timer -= line_time
            add_line()
    
    if speed_up:
        scroll_speed *= speed_up_multiplier
    
    if lines.size() > 0:
        for l in lines:
            l.rect_position.y -= scroll_speed
    elif started:
        finish()

func _ready():
    Utils.current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
    Globals.load_stats()
    var stats = PlayerData.playerStats
    $stats/punchesThrownCount.set_text(str(stats.punchesThrown))
    $stats/bananasThrownCount.set_text(str(stats.bananasThrown))
    $stats/bfgShotsFiredCount.set_text(str(stats.bfg9000ShotsFired))
    $stats/jumpCount.set_text(str(stats.jumpCount))
    $stats/damageReceivedCount.set_text(str(stats.playerDamageReceived))
    $stats/damageDealtCount.set_text(str(stats.playerDamageDealt))
    $stats/deathCount.set_text(str(stats.playerDeathCount))


func finish():
    if not finished:
        finished = true
        $exitToMenuButton.visible = true
        $exitToMenuButton.disabled = false
        

func add_line():
    var new_line
    var lineToUse = section.pop_front()
    if lineToUse.type == "t":
        new_line = titleLine.duplicate()
        new_line.rect_position.y += 100
    elif lineToUse.type == "c":
        new_line = categoryLine.duplicate()
        new_line.rect_position.y += 160
    elif lineToUse.type == "s":
        new_line = storyLine.duplicate()
        new_line.rect_position.y += 160
    elif lineToUse.type == "fin":
        new_line = storyLine.duplicate()
        finish()
    new_line.rect_position.x = 0
    new_line.text = lineToUse.txt
    lines.append(new_line)
    $rightHalf.add_child(new_line)
    
    if section.size() > 0:
        curr_line += 1
        section_next = false
    else:
        section_next = true


func _unhandled_input(event):
    if event.is_action_pressed("ui_cancel"):
        finish()
    if event.is_action_pressed("jump"):
        speed_up = true
        speed_up_multiplier = 0
    if event.is_action_released("jump"):
        speed_up = false
        speed_up_multiplier = 5
    if event.is_action_pressed("ui_down") and !event.is_echo():
        speed_up = true
        speed_up_multiplier = 5
    if event.is_action_released("ui_down") and !event.is_echo():
        speed_up = false
        speed_up_multiplier = 5
    if event.is_action_released("ui_up") and !event.is_echo():
        speed_up = false
        speed_up_multiplier = 5
    if event.is_action_pressed("ui_up") and !event.is_echo():
        speed_up = true
        speed_up_multiplier = -5


func _on_exitToMenuButton_button_up() -> void:
    Utils.goto_scene("res://entities/MainMenu.tscn")
