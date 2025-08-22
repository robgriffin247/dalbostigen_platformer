# Initial setup 

1. Download and install Godot

1. Create a new project

1. Download asset pack to root folder

1. Create a Playground Node2D scene and run game

# Player

1. Create a Player CharacterBody2D scene
    - Add a Sprite2D as a child of Player
        - Drag in player sprite
        - Set frames in animation
        - Set rendering to nearest in project settings
        - Move the Sprite2D
    - CollisionShape2D with a shape as a child of Player
    - AnimationPlayer with an idle animation as a child of Player
        - Frames 0-3
        - Loop and autoplay
        - Add a run animation
    - Add a Camera2D as a child of Player
        - Set scale to 4:4
        - Add position smoothing
        - Position over player
        - Set project settings display stretch to viewport
    - Add player.gd script to Player node
        - Use basic movement template
        - Add ``class_name Player `` before ``extends``
        - Add onready references to Sprite and AnimationPlayer
        - Modify input from ``ui``
        - Update input map
        - Add ``sprite.scale.x = direction if direction != 0 else sprite.scale.x`` on the line after the direction is assigned
        - Also add flow control for animation play on direction == and != 0
        - Adjust speed and jump_velocity to suit
    - Add Player to the Playground scene
 
 # Worldbuilding

 1. Create a WorldTileSet TileMapLayer scene
    - Add the world_tileset as a TileSet
    - Adjust tiles
    - Add a Physics Layer to the TileSet
    - Rename Layer 1 to Player
    - Paint the TileSet with the Physics Layer

1. Create a Level Node2D scene
    - Add a Node2D called TileSets as a child
    - Add three instances of WorldTileSet to the TileSets node
    - Rename to back-, mid- and fore- ground
    - Set ordering z-index on foreground to 100
    - Draw a midground (and more if wanted)
    - Add the Level to the Playground

# Dying

1. Create a GameOver CanvasLayer scene
    - Save and add to autoloads
    - Add a Control node as child of GameOver and anchor to fullscreen
    - Add a ColorRect node as a child of Control, anchor to fullscreen and style
    - Add a Label node as a child of Control
        - Set font (bold) and fontsize in theme overrides, text alignments etc
        - Save node as scene (label_bold.tscn)
        - Duplicate label_bold.tscn and set regular font
    - Return to Label in GameOver and add text, set position and font_size
    - Repeat process of labels with Button for a Retry
    - Add a GameOver script
        - Add an onready ref to the RetryButton
        - ``hide()`` in _ready()
        - Connect pressed on retry_button to a _reload_level() function
        - _reload_level() to reload current scene from tree and hide GameOver screen again
    
1. Create HitBox Area2D scene
    - Monitoring to false, layer to 9 ("Hazards") and mask to null
    - Add a script
        ```
		class_name HitBox extends Area2D

		signal hit(damage: int)

		func _take_hit(_damage: int) -> void:
			hit.emit(_damage)
		```

1. Create a HurtBox Area2D scene
    - Monitorable to false, mask to 2 ("PlayerHurt") and layer to null
    - Add a script
        ```
        class_name HurtBox extends Area2D

		@export var damage_effect : int = 1

		func _ready() -> void:
			area_entered.connect(_area_entered)

		func _area_entered( _area: Area2D) -> void:
			if _area is HitBox:
				_area._take_hit(damage_effect)
        ```

1. Add a HitBox to Player scene
    - Set layer to 2 (playerhurt)
    - Add a collision shape
    

1. In player.gd, add:
    - on ready ref. to hit_box
    - max_hp and hp variables
    - assign max_hp to hp, and connect hit_box.hit signal to a _take_hit() function in _ready()
    - create a _take_hit() function to test if player dead, show the GameOver UI and reset hp, taking damage value as input from signal

1. Add a HurtBox to the Level01 scene
    - Add a WorldBoundary CollisionShape
    - Position below bottom of the map


# Enemy Slime

1. Create a Slime Node2D
    - Add Sprite2D as a child of Slime, add sprites and position
    - Add an AnimationPlayer as a child of Slime and create move and death animations
    - Add Raycasts (one left and one right) and position; set collision mask to 9 (hazards)
    - (Go to WorldTileSet and add 9 (hazards) to the Collision Layers)
    - Add HurtBox and its CollisionShape to Slime
    - Add a script to Slime
        ```
        class_name Slime extends Node2D

        @onready var sprite: Sprite2D = $Sprite2D
        @onready var ray_cast_right: RayCast2D = $RayCastRight
        @onready var ray_cast_left: RayCast2D = $RayCastLeft

        var direction : int = 1

        func _process(delta: float) -> void:
            
            position.x += 40 * delta * direction
            
            if ray_cast_right.is_colliding():
                direction = -1
            
            if ray_cast_left.is_colliding():
                direction = 1
            
            sprite.scale.x = direction
        ```

1. Add HurtBox to Player
    - Set mask to 9 (hazards)
    - Add collision shape

1. Add HitBox to Slime
    - Add CollisionShape
    - Add hurt_box queue_free at 0s to die animation

1. Modify the slime script:
    ```
    class_name Slime extends Node2D

    @onready var sprite: Sprite2D = $Sprite2D
    @onready var ray_cast_right: RayCast2D = $RayCastRight
    @onready var ray_cast_left: RayCast2D = $RayCastLeft
    @onready var hit_box: HitBox = $HitBox
    @onready var animation_player: AnimationPlayer = $AnimationPlayer

    var direction := 1
    var hp := 1

    func _ready() -> void:
        hit_box.hit.connect(_take_hit)


    func _process(delta: float) -> void:
            
        position.x += 40 * delta * direction * int(hp>0)
        
        if ray_cast_right.is_colliding():
            direction = -1
        
        if ray_cast_left.is_colliding():
            direction = 1
        
        sprite.scale.x = direction


    func _take_hit(_damage: int) -> void:
        hp -= _damage
        if hp <= 0:
            animation_player.play("die")
    ```


# Pickups

- Add Coin Area2d scene
