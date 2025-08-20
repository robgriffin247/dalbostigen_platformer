# Setup

1. Download asset pack
1. Download, install and open Godot
1. Create a new project (give it a name, choose a suitable location and create)




# A Controllable Player

The aim is to create a player including a sprite, where the player can be controlled to walk side to side and to jump.
This will require a player scene, player script, and a playground scene to place the player in.

1. Create a Playground scene
	- Create a 2D Scene
	- Change name (F2) to ``Playground``
	- Save (ctrl + S) to the project root in a scene called ``playground.tscn``
	- Run the project (F5) and set the playground scene to be the main scene

1. Create the Player scene
	- Add a child node to ``Playground``
	- Set type to ``CharacterBody2D``
	- Change name of the node to ``Player``
	- Right-click node and *save branch as scene*
	- Open the player scene (will open a new tab in the main pane)
	- Add a ``Sprite2D`` node as a child of ``Player``
	- Drag player sprite sheet into the texture in the inspector
	- Adjust Animation/Hframes and Vframes to suit (8x8)
	- Go to Project Settings and set Texture Rendering, Default Texture Filter to *Nearest*
	- Switch to move-mode (W) and move the sprite so the feet are on the red/purple horizontal line (return to select-mode (Q))
	- Add a ``CollisionShape2D`` node to the ``Player``
	- Add a suitable shape in the inspector and adjust shape and position
	- Add an ``AnimationPlayer`` node to ``Player``
	- Create new animation called ``idle``
	- Set length to 0.4 seconds and snap to 0.1 seconds
	- Enable looping and autoplay
	- Select the ``Sprite2D`` then key the Animation/Frame
	- Preview the animation to make sure it works
	- Add a script to the ``Player`` node, using the basic movement template and saving to player folder
	- Add ``class_name Player `` before ``extends CharacterBody2D``
	- Change ``ui_accept``, ``ui_left`` and ``ui_right`` to ``jump``, ``left`` and ``right`` respectively
	- In Project Settings/Input Map, add jump, left and right actions
	- Assign keys to the actions

1. Add something to walk on
	- In the Playground scene, move the player (W) to near the middle
	- Run the game; 
		- The player will fall off the screen
		- The CollisionShape2D needs something to collide with
		- ``if not is_on_floor():`` evaluates to ``true``
	- In the ``Playground`` scene, add a child node of type ``StaticBody2D``
	- Add a child to the ``StaticBody2D`` of ``CollisionShape2D``
	- Set shape to WorldBoundaryShape2D
	- Position the ``StaticBody2D`` just under the player and run the game
		- Player should now land on the (invisible) boundary and can walk/jump
	- Now delete the ``StaticBody2D`` node; the next step is to build a world



# Worldbuilding

The aim here is to create a world, or level, with land to walk on, water hazards, trees and decorations.
This will be done by creating a reusable tilemap, then using that to build levels.

1. Create a new WorldTileSet scene
	- Create a new scene
	- Set type to TileMapLayer
	- Set the name to WorldTileset
	- In the inspector, create a new TileSet
	- In the bottom pane, go to the TileSet tab
	- Drag the world_tileset.png into the pane
	- Allow to automatically make tiles, but correct any that need (hold shift to create larger)
	- In the TileSet in the inspector, add an element to physics layers
	- In the TileSet pane, go to paint and select Physics Layer 0
	- Paint the tiles that the player should not be able to ove through
	- Save the scene in ``./WorldBuilding/TileSets``

1. Create a new Level01 scene
	- Create Node2D scene
	- Change the name to ``Level``
	- Add a ``Node2D`` as a child, call it Tiles
	- Drag the WorldTileSet scene into the Tiles node
	- Change the name to ``Background``
	- Duplicate the scene (ctrl + D) twice
	- Rename the duplicates to ``Midground`` and ``Foreground``
	- In the ``Foreground``, set CanvasItem/Ordering Z-Index to 10
	- Select ``Midground`` and draw some tiles for the player to walk on
	- Add some tiles to decorate in ``Background``, ``Midground`` and ``Foreground``
	- Save the scene as ``./Worlds/World01/level_01.tscn``
	
1. Add the Level01 scene to the Playground
	- Drag the ``Level01`` scene into the ``Playground`` above ``Player``
	- Position the ``Player`` so they spawn just over the terrain
	- Run the game; the level will be off in the corner - needs a camera to follow the player
	- Add a ``Camera2D`` as a child of ``Player``
	- Set Zoom to 4:4
	- Position the ``Camera2D`` nicely over the player
	- Run the game; the camera should follow the player



# Dying

The aim is to add ways for the player to die.
We will be creating a hit/hurtbox system allowing the player to get hurt/die, enemies and a game over screen allowing the player to restart the game.

1. Create a GameOver UI
	- Create a CanvasLayer scene
	- Rename it GameOver
	- Add a ``Control`` node as a child
	- Anchor to fullscreen
	- Add a ``ColorRect`` node as a child of the ``Control``, also anchoring to fullscreen
	- In Visibility, modulate the colour and alpha to suit
	- Add a ``Label`` node as a child of ``Control``
	- Save ``Label`` as a scene called ``./UI/Labels/label_bold.tscn``
	- Open the label_bold scene
		- Drag in the bold font from the assets to Theme Overrides/Fonts
		- Set font size to 8px
		- Set horizontal and vertical align to center
	- Duplicate the scene and rename to label_regular, changing font to the regular font and save
	- Return the GameOver scene, and in the ``Label``
		- Set text to "GAME OVER"
		- Adjust font size
		- Reposition the label
		- Rename the ``Label`` node to ``GameOverLabel``
	- Add a ``Button`` as a child of ``Control``
	- As with ``Label``, save this as a scene and set the font/font size
	- In the GameOver scene, on the ``Button``
		- Change text to "RETRY"
		- Change font size to suit
		- Position the button
		- Rename the ``Button`` node to ``RetryButton``
	- Add a script to the GameOver node
		- Add an onready reference to the retry button (ctrl + click & drag)
		- Set ``visible`` to ``false`` and connect the button pressed to a ``_reload_level()`` function
		- Create a ``_reload_level()`` function
			```
			extends CanvasLayer

			@onready var retry_button: Button = $Control/RetryButton

			func _ready() -> void:
				visible = false
				retry_button.pressed.connect(_reload_level)

			func _reload_level() -> void:
				get_tree().reload_current_scene()
				visible = false
			```
	- Save the scene in ``./UI/GameOver/``
	- Add to Project Settings/Globals

1. Create a HitBox scene (hitbox will be where the player becomes vulnerable to being hit by enemies or colliding with boundary)
	- ``Area2D`` node
	- Rename to ``HitBox``
	- Save in ``./General/HitBox/``
	- Attach a script
		```
		class_name HitBox extends Area2D

		signal hit(damage: int)

		func _take_hit(_damage: int) -> void:
			hit.emit(_damage)
		```
	- Set monitoring to false
	- Set collision layer to 3 and mask to null (rename layers 1, 2 and 3 to player, playerhurt and enemy playerhit)
		- Default to 3 because most often on things hurting player enemies etc. but override when adding to player to layer 2
	
1. Create a HurtBox
	- Monitoring but not monitorable
	- Mask to 2 (playerhit layer)
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
1. Modify the player script
	- Add the following parts:	
		```
		@onready var hit_box: HitBox = $HitBox

		var max_hp: int = 1
		var hp: int
		
		func _ready() -> void:
			hp = max_hp
			hit_box.hit.connect(_take_hit)
			
		...
		
		func _take_hit(_damage: int) -> void:
			hp -= _damage
			if hp<=0:
				GameOver.show()
				hp = max_hp
		```

1. Implement hit-hurt boxes to create world boundary at map bottom
	- Add a hitbox with suitable ``CollisionShape2D`` to the player
		- Override this specific hitbox layer to 2 (playerhurt)
	- Add and position a hurtbox with worldboundary ``CollisionShape2D`` to the level
	- Test the game, the player should die if they fall down

1. Add wandering enemy
	- Create a new scene with a Node2D
	- Name it Enemy
	- Add ``Sprite2D`` and sprites
	- Add ``AnimationPlayer`` and create move animation
	- Add HurtBox and child-``CollisionShape2D``
	- Add an Enemy to the Level01; test that the player dies on contact
	- Return to the enemy scene and add a script
	- Add a RayCast2D to the Enemy; position/adjust suitably
		```
		class_name Enemy extends Node2D

		@onready var ray_cast: RayCast2D = $RayCast2D
		var direction : int = 1

		func _process(delta: float) -> void:
			position.x += 40 * delta * direction
			if ray_cast.is_colliding():
				direction *= -1
				scale.x *= -1
		```
	- Set CollisionMask of RayCast2D to layer 3 (enemy)
	- Add Physics Layers/Collision Layer to 3 in world_tile_set scene

 -->
	kill enemies;
	- add hurtbox to player and collision shape
	- add hitbox to enemy and collision shape
	- add to enemy script to connect a take_hit function on ready and to execute when hit_box emits hit signal (needs hp and onready var)
	- add an animation (queue_free() the hurtbox at 0, queue_free() the enemy at the end, sprites and fade to suit + direction to 0 in code)
	
<!--

# Dying
[x] HurtBox/HitBox
[x] GameOver screen
[ ] Enemies

# Pickups
- Add coin pickup
- HUD

# Improve the Player
- Animations
- Direction flip
- State machine
- Set ``SPEED`` to ``100.0``
- Set ``JUMP_VELOCITY`` to ``-320.0``

# Improve Levels
- Add Platforms
- Set Camera Limits
- Add Portals (and more levels)

# Other
- Splash screen
- Main menu
- High scores

-->
