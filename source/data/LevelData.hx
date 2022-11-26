package data;

import data.Generic.Vector2;

class LevelData
{
	public var collisions:Array<CollisionData>;
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

class ObjectData
{
	public var position:Vector2;
	public var size:Vector2;
}
