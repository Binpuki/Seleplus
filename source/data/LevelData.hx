package data;

import data.Generic.Vector2;

class LevelData
{
	public var collisions:Array<CollisionData>;
	public var sprites:Array<LevelSprite>;

	public function new() {}
}

class CollisionData
{
	public var position:Vector2;
	public var size:Vector2;
	public var type:CollisionType;
}

enum CollisionType
{
	NORMAL;
	PASSTHROUGH;
}

class LevelSprite extends AnimationData
{
	public var position:Vector2;
	public var size:Vector2;
	public var order:Int;
	public var anim:String;

	public var layering:LevelSpriteType;

	public function new()
	{
		super();
	}
}

enum LevelSpriteType
{
	BACKGROUND;
	FOREGROUND;
}
