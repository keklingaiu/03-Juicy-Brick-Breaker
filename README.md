# Exercise-03c-Music-and-Sound
Exercise for MSCH-C220, 1 October 2020

This exercise is designed to explore adding music, sound, a ball trail, and a face (as well as a few other effects) to our boring brick breaker game (in the spirit of "Juice it or Lose it"). This builds on the last two exercises (that added colors, particles, tweening, and screen shake).

Fork this repository. When that process has completed, make sure that the top of the repository reads [your username]/Exercise-03c-Music-and-Sound. *Edit the LICENSE and replace BL-MSCH-C220-F20 with your full name.* Commit your changes.

Clone the repository to a Local Path on your computer.

Open Godot. Import the project.godot file and open the "Music and Sound" project.

You should see a very basic brick-breaker game with a HUD that will control certain effects: adding color, particles, adding dynamism to the bricks, camera, and paddle. Now, we will be adding the ball trail, the paddle face, music, and sound effects.

The first part of the assignment is to record three (short) sound effect in Audacity. Save them as paddle.wav, wall.wav, and brick.wav, and copy them into the Assets folder for the project.

You will then need to write a simple melody in MuseScore. It doesn't have to be pretty or elaborate. Export the music as an Ogg Vorbis file (music.ogg) and copy it into the Assets folder for the project.

The signals have all been connected, and much of the code should basically be in place. Your assignment is to set up the WorldEnvironment, place the elements of the face, and edit the following scripts, completing the HUD.* if statements:

 * /Audio/Music.gd
 * /Ball/Ball.gd
 * /Ball/Trail_Container.gd
 * /Camera/WorldEnvrionment.gd
 * /Paddle/Face.gd


We will talk in detail in class how to complete this exercise. 


In /Ball/Ball.gd, replace lines 48–49 with the following:
```
	if HUD.ball_trail:
		var c = $Color.duplicate()
		c.rect_global_position = global_position
		c.color = c.color.darkened(0.4)
		get_node("/root/Game/Trail_Container").add_child(c)
```

Then, in /Ball/Trail_Container.gd, the `_physics_process(_delta)` function should be as follows:
```
func _physics_process(_delta):
	for ch in get_children():
		ch.rect_position.x += (randf()-0.5)
		ch.rect_position.y += (randf()-0.5)
		
		ch.rect_size *= (1-shrink_amount)
		ch.color = ch.color.from_hsv(ch.color.h+hue_amount, ch.color.s-desaturate_amount, ch.color.v-darken_amount, ch.color.a-fade_amount)
		if ch.color.a <= 0:
			ch.queue_free()
```

Now it is time to create the face. With all of these nodes, please note the spelling:

 * As a child of the /Paddle_Container/Paddle/Face node, create a Sprite and rename it "Eye_left". Update its position to -35, -10 and set the texture as /Assets/eye.png.
 * Duplicate Eye_left and rename it Eye_right. Set its position to 35, -10
 * As a child of /Paddle_Container/Paddle/Face, create a Node2D and rename it "Pupil_left". Set its position -35, -10. Duplicate it, and name the new Node2D "Pupil_right". Set its position 35, -10.
 * In both Pupil_left and Pupil_right, add Sprite nodes and apply /Assets/pupil.png as the texture. Set the position for both images as 10, 0
 * Finally, as a child of the Face node, create a Sprite and name it "Mouth". Set its position to 0, 20, and set the texture /Assets/mouth.png.

In /Paddle/Face.gd, set up `_physics_process(_delta)` as the following:
```
func _physics_process(_delta):
	if get_node("/root/Game/Ball_Container").has_node("Ball"):
		var ball = get_node("/root/Game/Ball_Container/Ball")
		$Pupil_left/Sprite.position.x = 10
		$Pupil_right/Sprite.position.x = 10
		$Pupil_left.look_at(ball.position)
		$Pupil_right.look_at(ball.position)
		var d = ((($Mouth.global_position.y - ball.global_position.y)/height)-0.2)*2
		d = clamp(d, -1, 1)
		$Mouth.scale.y = d
	else:
		$Pupil_left/Sprite.position.x = 0
		$Pupil_right/Sprite.position.x = 0
		$Mouth.scale.y = 1
```

Drag your music (/Assets/music.ogg) into the Stream property in the Music node. Add the corresponding sound effects to Effect_Paddle, Effect_Wall, and Effect_Brick.

In /Audio/Music.gd, the play_music() function should be as follows:
```
func play_music():
	if HUD.audio_music and playing:
		pass
	elif HUD.audio_music and not playing:
		playing = true
	else:
		playing = false
```
Attach a finished() signal to the script. The resulting `_on_music_finished()` method should contain just one line:
```
func _on_Music_finished():
	play_music()
```

Now, it is time to set up the WorldEnvironment node. Select it, and in the Inspector->WorldEnvironment->Environment, add a new Environment. Then edit it.

Set the properties as follows:

 * Dof Near Blur->Enabled = true
 * Dof Near Blur->Distance = 1.3
 * Glow->Enabled = true
 * Glow->Bloom = 0.15
 * Glow->Blend Mode->Additive
 * Glow->Hdr Threshold->0
 * Glow->Bicubic Upscale->On

In the beginning, it won't have any affect (since the Background->Mode is set to Clear Color). We will enable and disable it in GDScript.

Speaking of which, in /Camera/WorldEnviornment.gd, we are going to allow the menu switch to turn on and off the glow and blur. The `show()` and `hide()` functions should appear as follows:
```
func show():
	if HUD.effects_blur:
		environment.background_mode = Environment.BG_CANVAS
	else:
		environment.background_mode = Environment.BG_CLEAR_COLOR	
```
```
func hide():
	environment.background_mode = Environment.BG_CLEAR_COLOR
```


Test the project. You should be able to turn on and off the effects using the Menu (press Esc to activate).

Quit Godot. In GitHub desktop, add a summary message, commit your changes and push them back to GitHub. If you return to and refresh your GitHub repository page, you should now see your updated files with the time when they were changed.

Now edit the README.md file. When you have finished editing, commit your changes, and then turn in the URL of the main repository page (https://github.com/[username]/Exercise-03c-Music-and-Sound) on Canvas.

The final state of the file should be as follows (replacing the "Created by" information with your name):
```
# Exercise-03c-Music-and-Sound
Exercise for MSCH-C220, 1 October 2020

The third part in a series exploring the "Juice it or Lose it" GDC 2012 presentation in Godot.

## Implementation
Built using Godot 3.2.2
Typeface: [Datalegreya](https://fontlibrary.org/en/font/datalegreya) by Figs Lab
[Smoke particles](https://kenney.nl/assets/smoke-particles) provided by kenney.nl
All other sprites created by Jason Francis in Photoshop
Music and sound effects created by the author

## References
[Juice it or Lose it](https://www.youtube.com/watch?v=Fy0aCDmgnxg)

## Future Development
None

## Created by 
Jason Francis

```
