package obsydia;

import data.AnimationData.AtlasType;
import data.Generic.Vector2;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import lime.app.Event;

// me when i steal from my fnf engine haha
class Sprite extends FlxSprite
{
	public var tag:String = ""; // so its findable via hscript or lua or whatevs idk lol

	public var nextAnimMap(default, null):Map<String, String> = [];

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		onAnimFinished.add(function(anim:String)
		{
			if (nextAnimMap.exists(anim))
				playAnim(anim, true);
		});

		animation.finishCallback = onAnimFinish;
	}

	public function onAnimFinish(anim:String)
	{
		onAnimFinished.dispatch(anim);
	}

	public var animationOffsets(default, null):Map<String, FlxPoint> = [];

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
	{
		onAnimPlayed.dispatch(AnimName);
		animation.play(AnimName, Force, Reversed, Frame);

		if (animationOffsets.exists(AnimName))
			offset.set(animationOffsets[AnimName].x, animationOffsets[AnimName].y);
		else
			offset.set(0, 0);
	}

	private var framesMap:Map<String, FlxAtlasFrames> = [];
	private var frameTypeMap:Map<String, AtlasType> = [];

	/**
		Used to assign frames to the sprite. Please use this instead of accessing the frames variable.
		@param frames   The frames for the sprite.
		@param path     The path to the frames for the sprite.
		@param type     The type of atlas.
	**/
	public function assignFrames(frames:FlxAtlasFrames, path:String, type:AtlasType)
	{
		framesMap.set(path, frames);
		frameTypeMap.set(path, type);
		this.frames = frames;
	}

	private var animPrefixes:Map<String, String> = [];
	private var animIndices:Map<String, Array<Int>> = [];

	/**
	 * Adds a new animation to the sprite. (Please use this instead of animation.addByPrefix)
	 *
	 * @param   Name        What this animation should be called (e.g. `"run"`).
	 * @param   Prefix      Common beginning of image names in atlas (e.g. `"tiles-"`).
	 * @param   FrameRate   The speed in frames per second that the animation should play at (e.g. `40` fps).
	 * @param   Looped      Whether or not the animation is looped or just plays once.
	 * @param   FlipX       Whether the frames should be flipped horizontally.
	 * @param   FlipY       Whether the frames should be flipped vertically.
	 */
	public function addAnimByPrefix(Name:String, Prefix:String, FrameRate:Int = 30, Looped:Bool = true, FlipX:Bool = false, FlipY:Bool = false)
	{
		animPrefixes.set(Name, Prefix);
		animation.addByPrefix(Name, Prefix, FrameRate, Looped, FlipX, FlipY);
	}

	/**
	 * Adds a new animation to the sprite. (Please use this instead of animation.addByIndices)
	 *
	 * @param   Name        What this animation should be called (e.g. `"run"`).
	 * @param   Prefix      Common beginning of image names in the atlas (e.g. "tiles-").
	 * @param   Indices     An array of numbers indicating what frames to play in what order (e.g. `[0, 1, 2]`).
	 * @param   Postfix     Common ending of image names in the atlas (e.g. `".png"`).
	 * @param   FrameRate   The speed in frames per second that the animation should play at (e.g. `40` fps).
	 * @param   Looped      Whether or not the animation is looped or just plays once.
	 * @param   FlipX       Whether the frames should be flipped horizontally.
	 * @param   FlipY       Whether the frames should be flipped vertically.
	 */
	public function addAnimByIndices(Name:String, Prefix:String, Indices:Array<Int>, Postfix:String, FrameRate:Int = 30, Looped:Bool = true,
			FlipX:Bool = false, FlipY:Bool = false)
	{
		animPrefixes.set(Name, Prefix);
		animIndices.set(Name, Indices);
		animation.addByIndices(Name, Prefix, Indices, Postfix, FrameRate, Looped, FlipX, FlipY);
	}

	// heres a buncha callbacks if u need em
	public var onAnimPlayed(default, null):Event<String->Void> = new Event<String->Void>();
	public var onAnimFinished(default, null):Event<String->Void> = new Event<String->Void>();
}
