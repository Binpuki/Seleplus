package states.editor;

import data.AnimationData.Animation;
import data.AnimationData.AtlasType;
import data.LevelData;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUIText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import obsydia.Sprite;

class EditorState extends BaseState
{
	private var levelData:LevelData;
	private var mainUI:FlxUITabMenu;

	private var camFollow:FlxObject;

	// IM SORRY I MESSED UP BUT I DONT HAVE TIME RN GRASHHHHH
	private var curSprite:EditorSprite;

	private var curSelSprData(get, null):LevelSprite;

	function get_curSelSprData():LevelSprite
		return curSprite.data;

	private var disableInputs:Bool = false;

	override function create()
	{
		super.create();

		bgColor = FlxColor.fromRGB(100, 149, 237);

		camFollow = new FlxObject();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		levelData = new LevelData();

		mainUI = new FlxUITabMenu(null, [
			{name: "Object", label: 'Object'},
			{name: "Collision", label: 'Collision'},
			{name: "Spawnpoint", label: 'Spawnpoint'},
			{name: "Save", label: 'Save'}
		], true);

		mainUI.resize(300, 400);
		mainUI.x = FlxG.width - mainUI.width - 10;
		mainUI.y = 10;
		mainUI.scrollFactor.set();
		add(mainUI);

		createObjectTab();
	}

	var removeAtlas:FlxUIDropDownMenu;
	var removeAnim:FlxUIDropDownMenu;

	private function createObjectTab()
	{
		var tabGroup:FlxUI = new FlxUI(null, mainUI);
		tabGroup.name = "Object";

		// ADD ATLAS SECTION

		var atlasLabel:FlxUIText = new FlxUIText(10, 10, 0, "Atlas Section");
		tabGroup.add(atlasLabel);

		var atlasPath:FlxUIInputText = new FlxUIInputText(10, 25, 100, "");
		tabGroup.add(atlasPath);

		var atlasType:FlxUIDropDownMenu = new FlxUIDropDownMenu(atlasPath.width + 30, 25,
			FlxUIDropDownMenu.makeStrIdLabelArray(["SPARROW", "PACKER", "NONE"]));
		tabGroup.add(atlasType);

		var addAtlas:FlxUIButton = new FlxUIButton(10, 45, "Add Atlas", function()
		{
			var _atlasType:AtlasType = cast(atlasType.selectedLabel, AtlasType);

			switch (_atlasType)
			{
				case SPARROW:
					curSprite.assignFrames(FlxAtlasFrames.fromSparrow(atlasPath.text + ".png", atlasPath.text + ".xml"), atlasPath.text, _atlasType);
				case PACKER:
					curSprite.assignFrames(FlxAtlasFrames.fromSpriteSheetPacker(atlasPath.text + ".png", atlasPath.text + ".txt"), atlasPath.text, _atlasType);
				default:
					curSprite.loadGraphic(atlasPath.text + ".png");
					@:privateAccess
					curSprite.frameTypeMap.set(atlasPath.text, _atlasType);
			}

			curSelSprData.atlas.push(atlasPath.text);
			curSelSprData.atlasType.push(_atlasType);
			updateSpriteTab();
		});
		tabGroup.add(addAtlas);

		var removeAtlasLabel:FlxUIText = new FlxUIText(10, 70, 0, "Remove Atlas");
		tabGroup.add(removeAtlasLabel);

		removeAtlas = new FlxUIDropDownMenu(10, 90, null, function(atlasPath)
		{
			var daIndex = curSelSprData.atlas.indexOf(atlasPath);

			curSelSprData.atlas.remove(atlasPath);
			curSelSprData.atlasType.remove(curSelSprData.atlasType[daIndex]);

			updateSpriteTab();
		});
		tabGroup.add(removeAtlas);

		// anim label

		var animLabel:FlxUIText = new FlxUIText(10, 115, 0, "Animation Section");
		tabGroup.add(animLabel);

		var animName:FlxUIInputText = new FlxUIInputText(10, 130, 120, "name");
		tabGroup.add(animName);

		var animPrefix:FlxUIInputText = new FlxUIInputText(animName.x + animName.width + 10, 130, 120, "prefix");
		tabGroup.add(animPrefix);

		var animLoop:FlxUICheckBox = new FlxUICheckBox(10, 160, null, null, "Loop Anim?", 100, null);
		tabGroup.add(animLoop);

		var animFrameRate:FlxUINumericStepper = new FlxUINumericStepper(100, 160, 1, 24);
		tabGroup.add(animFrameRate);

		var addAnim:FlxUIButton = new FlxUIButton(10, 180, "Add Animation", function()
		{
			var daName:String = animName.text;

			for (anim in curSelSprData.animations)
				if (anim.name == daName)
					daName += " copy";

			var daAnim:Animation = {
				frameRate: Std.int(animFrameRate.value),
				name: animName.text,
				prefix: animPrefix.text,
				loop: animLoop.checked
			};

			curSelSprData.animations.push(daAnim);
			updateSpriteTab();
		});
		tabGroup.add(addAnim);

		removeAnim = new FlxUIDropDownMenu(10, 210, null, function(_animName)
		{
			for (anim in curSelSprData.animations)
			{
				if (anim.name == _animName)
				{
					curSelSprData.animations.remove(anim);
					break;
				}
			}
			updateSpriteTab();
		});
		tabGroup.add(removeAnim);

		// add a sprite in general

		var createSprite:FlxUIButton = new FlxUIButton(10, 270, "Create New Sprite", function()
		{
			var sprite:EditorSprite = new EditorSprite();

			add(sprite);
			curSprite = sprite;
		});
		tabGroup.add(createSprite);

		mainUI.addGroup(tabGroup);
	}

	private function updateSpriteTab()
	{
		if (curSelSprData.atlas.length > 0)
			removeAtlas.setData(FlxUIDropDownMenu.makeStrIdLabelArray(curSelSprData.atlas));
		else
			removeAtlas.setData(FlxUIDropDownMenu.makeStrIdLabelArray([""]));

		var daAnimArray:Array<String> = [];
		for (anim in curSelSprData.animations)
			daAnimArray.push(anim.name);

		if (daAnimArray.length > 0)
			removeAnim.setData(FlxUIDropDownMenu.makeStrIdLabelArray(daAnimArray));
		else
			removeAnim.setData(FlxUIDropDownMenu.makeStrIdLabelArray([""]));
	}

	private var camSpeed:Float = 10;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.F5)
			disableInputs = !disableInputs;

		atrociousMovementControls();
	}

	// im honestly just considering switching to like Unity after this LOL
	private function atrociousMovementControls()
	{
		if (disableInputs)
			return;

		var camKeys:Array<Bool> = [
			FlxG.keys.pressed.W,
			FlxG.keys.pressed.A,
			FlxG.keys.pressed.S,
			FlxG.keys.pressed.D
		];

		if (camKeys.contains(true))
		{
			if (camKeys[1])
				camFollow.x -= camSpeed;

			if (camKeys[3])
				camFollow.x += camSpeed;

			if (camKeys[0])
				camFollow.y -= camSpeed;

			if (camKeys[2])
				camFollow.y += camSpeed;
		}

		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.1;

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.1;

		var moveKeys:Array<Bool> = [
			FlxG.keys.pressed.I,
			FlxG.keys.pressed.J,
			FlxG.keys.pressed.K,
			FlxG.keys.pressed.L
		];

		var curSelectedObj:FlxObject = (mainUI.selected_tab_id == "Object" ? cast(curSprite, FlxObject) : mainUI.selected_tab_id == "Collision" ? null : null);

		if (moveKeys.contains(true) && curSelectedObj != null)
		{
			if (moveKeys[1])
				curSelectedObj.x -= 10;

			if (moveKeys[3])
				curSelectedObj.x += 10;

			if (moveKeys[0])
				curSelectedObj.y -= 10;

			if (moveKeys[2])
				curSelectedObj.y += 10;
		}
	}
}

class EditorSprite extends Sprite
{
	public var data:LevelSprite;

	public function new()
	{
		super();

		data = new LevelSprite();
	}
}
