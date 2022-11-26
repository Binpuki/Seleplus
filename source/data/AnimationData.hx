package data;

import data.Generic.Vector2;
import flixel.FlxSprite;
import flixel.animation.FlxAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxPoint;
import obsydia.Sprite;

class AnimationData
{
	public var atlas:Array<String>;
	public var atlasType:Array<AtlasType>;

	public var scale:Float = 1;

	public var animations:Array<Animation> = [];

	@:optional public var antialiasing:Bool = true;
	@:optional public var flipX:Bool = false;

	public function new() {}

	public static function encode(sprite:Sprite)
	{
		var animData:AnimationData = new AnimationData();

		// atlas shit
		var stupidAtlasPaths:Array<String> = [];
		var stupidAtlasTypes:Array<AtlasType> = [];

		@:privateAccess
		for (path in sprite.frameTypeMap.keys())
		{
			stupidAtlasPaths.push(path);
			stupidAtlasTypes.push(sprite.frameTypeMap.get(path));
		}

		animData.atlas = stupidAtlasPaths;
		animData.atlasType = stupidAtlasTypes;

		var animArray:Array<Animation> = [];

		// anim shit
		for (anim in sprite.animation.getNameList())
		{
			var curAnim:FlxAnimation = sprite.animation.getByName(anim);

			var daOffset:FlxPoint = sprite.animationOffsets.get(anim);
			var validOffset:Bool = sprite.animationOffsets.exists(anim);
			var jsonOffset:Vector2 = {x: (validOffset ? daOffset.x : 0), y: (validOffset ? daOffset.y : 0)}

			@:privateAccess
			var dataShit:Animation = {
				frameRate: Std.int(curAnim.frameRate),
				name: anim,
				prefix: sprite.animPrefixes.get(anim),
				offset: jsonOffset,
				indices: sprite.animIndices.get(anim),
				loop: curAnim.looped,
				next: sprite.nextAnimMap.get(anim)
			}

			animArray.push(dataShit);
		}

		// the rest of the shit
		animData.scale = sprite.width / sprite.frameWidth;
		animData.flipX = sprite.flipX;
		animData.antialiasing = sprite.antialiasing;

		return animData;
	}

	public static function parse(sprite:Sprite, data:AnimationData):Void
	{
		for (i in 0...data.atlas.length)
		{
			var atlas:String = data.atlas[i];
			var atlasType:AtlasType = data.atlasType[i];

			// Assign frames
			switch (atlasType)
			{
				case SPARROW:
					sprite.assignFrames(FlxAtlasFrames.fromSparrow(atlas + ".png", atlas + ".xml"), atlas, atlasType);
				case PACKER:
					sprite.assignFrames(FlxAtlasFrames.fromSpriteSheetPacker(atlas + ".png", atlas + ".txt"), atlas, atlasType);
				default: // ik im a genius
					sprite.loadGraphic(atlas + ".png");
					@:privateAccess
					sprite.frameTypeMap.set(atlas, atlasType);
			}

			sprite.antialiasing = data.antialiasing;

			// handle animations, skip if cant find
			for (anim in data.animations)
			{
				var hasIndices:Bool = anim.indices != null && anim.indices.length > 0;
				var isLoopin:Bool = anim.loop != null ? anim.loop : false;

				if (hasIndices)
				{
					var frameIndices:Array<Int> = [];
					@:privateAccess
					sprite.animation.byIndicesHelper(frameIndices, anim.prefix, anim.indices, "");

					if (frameIndices.length > 0)
						sprite.addAnimByIndices(anim.name, anim.prefix, anim.indices, "", anim.frameRate, isLoopin);
					else
						continue;
				}
				else
				{
					var tempFrames:Array<FlxFrame> = [];

					for (frame in sprite.frames.frames)
						if (frame.name != null && StringTools.startsWith(frame.name, anim.prefix))
							tempFrames.push(frame);

					if (tempFrames.length > 0)
						sprite.addAnimByPrefix(anim.name, anim.prefix, anim.frameRate, isLoopin);
					else
						continue;
				}

				if (anim.offset != null)
					sprite.animationOffsets.set(anim.name, FlxPoint.get(anim.offset.x, anim.offset.y));
			}

			sprite.setGraphicSize(Std.int(sprite.width * data.scale));
			sprite.updateHitbox();
		}
	}
}

@:enum abstract AtlasType(String)
{
	var SPARROW = "SPARROW";
	var PACKER = "PACKER";
	var NONE = "NONE";
}

typedef Animation =
{
	public var frameRate:Int;

	public var name:String;
	public var prefix:String;
	@:optional public var offset:Vector2;
	@:optional public var indices:Array<Int>;
	@:optional public var loop:Bool;
	@:optional public var next:String;
}
