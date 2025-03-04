package states.substates;

import base.KeyFormatter;
import base.MusicBeat;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import funkin.Alphabet;
import states.menus.CreditsMenuState;

using StringTools;

/*
	NOTE to Devs: need to rewrite this
	for it to be more modular, easier to manage,
	and match week 7's Controls Substate
	-gabi
 */
class ControlsSubstate extends MusicBeatSubstate
{
	var curSelection = -1;
	var submenuGroup:FlxTypedGroup<FlxBasic>;
	var submenuoffsetGroup:FlxTypedGroup<FlxBasic>;

	var offsetTemp:Float;
	var lockAccept:Bool = true;

	// the controls class thingy
	override public function create():Void
	{
		// call the options menu
		var bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/base/menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.color = 0xCE64DF;
		bg.antialiasing = !Init.getSetting('Disable Antialiasing');
		add(bg);

		Main.letterOffset = true;

		new FlxTimer().start(0.6, function(timer:FlxTimer)
		{
			lockAccept = false;
		}, 1);

		super.create();

		keyOptions = generateOptions();
		updateSelection();

		submenuGroup = new FlxTypedGroup<FlxBasic>();
		submenuoffsetGroup = new FlxTypedGroup<FlxBasic>();

		submenu = new FlxSprite(0, 0).makeGraphic(FlxG.width - 200, FlxG.height - 200, FlxColor.fromRGB(250, 253, 109));
		submenu.screenCenter();

		// submenu group
		var submenuText = new Alphabet(0, 0, "Press any key to rebind", true, false);
		submenuText.screenCenter();
		submenuText.y -= 32;
		submenuGroup.add(submenuText);

		var submenuText2 = new Alphabet(0, 0, "Escape to Cancel", true, false);
		submenuText2.screenCenter();
		submenuText2.y += 32;
		submenuGroup.add(submenuText2);

		var submenuText3 = new Alphabet(0, 0, "DEL to Delete Key", true, false);
		submenuText3.screenCenter();
		submenuText3.y += 92;
		submenuGroup.add(submenuText3);

		// submenuoffset group
		// this code by codist
		var submenuOffsetText = new Alphabet(0, 0, "Left or Right to edit.", true, false);
		submenuOffsetText.screenCenter();
		submenuOffsetText.y -= 144;
		submenuoffsetGroup.add(submenuOffsetText);

		var submenuOffsetText2 = new Alphabet(0, 0, "Negative is Late", true, false);
		submenuOffsetText2.screenCenter();
		submenuOffsetText2.y -= 80;
		submenuoffsetGroup.add(submenuOffsetText2);

		var submenuOffsetText3 = new Alphabet(0, 0, "Escape to Cancel", true, false);
		submenuOffsetText3.screenCenter();
		submenuOffsetText3.y += 102;
		submenuoffsetGroup.add(submenuOffsetText3);

		var submenuOffsetText4 = new Alphabet(0, 0, "Enter to Save", true, false);
		submenuOffsetText4.screenCenter();
		submenuOffsetText4.y += 164;
		submenuoffsetGroup.add(submenuOffsetText4);

		var submenuOffsetValue:FlxText = new FlxText(0, 0, 0, "< 0ms >", 50, false);
		submenuOffsetValue.screenCenter();
		submenuOffsetValue.borderColor = FlxColor.BLACK;
		submenuOffsetValue.borderSize = 5;
		submenuOffsetValue.borderStyle = FlxTextBorderStyle.OUTLINE;
		submenuoffsetGroup.add(submenuOffsetValue);

		// alright back to my code :ebic:

		add(submenu);
		add(submenuGroup);
		add(submenuoffsetGroup);
		submenu.visible = false;
		submenuGroup.visible = false;
		submenuoffsetGroup.visible = false;
	}

	var keyOptions:FlxTypedGroup<Alphabet>;
	var otherKeys:FlxTypedGroup<Alphabet>;

	function generateOptions()
	{
		keyOptions = new FlxTypedGroup<Alphabet>();

		var arrayTemp:Array<String> = [];
		// re-sort everything according to the list numbers
		for (controlString in Init.gameControls.keys())
		{
			arrayTemp[Init.gameControls.get(controlString)[1]] = controlString;
		}
		// hiding this on neko platforms, as you can't even use offsets on those -Ghost
		#if !neko arrayTemp.push("EDIT OFFSET"); #end // append edit offset to the end of the array

		for (i in 0...arrayTemp.length)
		{
			if (arrayTemp[i] == null)
				arrayTemp[i] = '';
			// generate key options lol
			var optionsText:Alphabet = new Alphabet(0, 0, arrayTemp[i], true, false);
			optionsText.screenCenter();
			optionsText.y += (90 * (i - (arrayTemp.length / 2)));
			optionsText.targetY = i;
			optionsText.disableX = true;
			optionsText.isMenuItem = true;
			optionsText.alpha = 0.6;

			keyOptions.add(optionsText);
		}

		// stupid shubs you always forget this
		add(keyOptions);

		generateExtra(arrayTemp);

		return keyOptions;
	}

	function generateExtra(arrayTemp:Array<String>)
	{
		otherKeys = new FlxTypedGroup<Alphabet>();
		for (i in 0...arrayTemp.length)
		{
			for (j in 0...2)
			{
				var keyString = "";

				if (Init.gameControls.exists(arrayTemp[i]))
					keyString = getStringKey(Init.gameControls.get(arrayTemp[i])[0][j]);

				var secondaryText:Alphabet = new Alphabet(0, 0, keyString, false, false);
				secondaryText.screenCenter();
				secondaryText.y += (90 * (i - (arrayTemp.length / 2)));
				secondaryText.targetY = i;
				secondaryText.disableX = true;
				secondaryText.xTo += ((j + 1) * 420);
				secondaryText.isMenuItem = true;
				secondaryText.alpha = 0.6;

				otherKeys.add(secondaryText);
			}
		}
		add(otherKeys);
	}

	function getStringKey(arrayThingy:Dynamic):String
	{
		var keyString:String = 'none';
		if (arrayThingy != null)
		{
			var keyDisplay:FlxKey = arrayThingy;
			keyString = KeyFormatter.formatKeyName(keyDisplay.toString());
		}

		keyString = keyString.replace(" ", "");

		return keyString;
	}

	function updateSelection(equal:Int = 0)
	{
		if (equal != curSelection)
			FlxG.sound.play(Paths.sound('scrollMenu'));
		var prevSelection:Int = curSelection;
		curSelection = equal;
		// wrap the current selection
		if (curSelection < 0)
			curSelection = keyOptions.length - 1;
		else if (curSelection >= keyOptions.length)
			curSelection = 0;

		for (i in 0...keyOptions.length)
		{
			keyOptions.members[i].alpha = 0.6;
			keyOptions.members[i].targetY = (i - curSelection) / 2;
		}
		keyOptions.members[curSelection].alpha = 1;

		for (i in 0...otherKeys.length)
		{
			otherKeys.members[i].alpha = 0.6;
			otherKeys.members[i].targetY = (((Math.floor(i / 2)) - curSelection) / 2) - 0.25;
		}
		otherKeys.members[(curSelection * 2) + curHorizontalSelection].alpha = 1;

		if (keyOptions.members[curSelection].text == '' && curSelection != prevSelection)
			updateSelection(curSelection + (curSelection - prevSelection));
	}

	var curHorizontalSelection = 0;

	function updateHorizontalSelection()
	{
		var left = controls.UI_LEFT_P;
		var right = controls.UI_RIGHT_P;
		var horizontalControl:Array<Bool> = [left, false, right];

		if (horizontalControl.contains(true))
		{
			for (i in 0...horizontalControl.length)
			{
				if (horizontalControl[i] == true)
				{
					curHorizontalSelection += (i - 1);

					if (curHorizontalSelection < 0)
						curHorizontalSelection = 1;
					else if (curHorizontalSelection > 1)
						curHorizontalSelection = 0;

					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}

			updateSelection(curSelection);
		}
	}

	var submenuOpen:Bool = false;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!submenuOpen)
		{
			var controlArray:Array<Bool> = [
				controls.UI_UP,
				controls.UI_DOWN,
				controls.UI_UP_P,
				controls.UI_DOWN_P,
				FlxG.mouse.wheel == 1,
				FlxG.mouse.wheel == -1
			];

			if (controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if (controlArray[i] == true)
					{
						// up = 2, down = 3
						if (i > 1)
						{
							if (i == 2 || i == 4)
								updateSelection(curSelection - 1);
							else if (i == 3 || i == 5)
								updateSelection(curSelection + 1);
						}
					}
				}
			}

			updateHorizontalSelection();

			if (controls.ACCEPT || FlxG.mouse.justPressed)
			{
				if (!lockAccept)
				{
					submenuOpen = true;

					if (submenuOpen)
						openSubmenu();
				}
			}
			else if (controls.BACK || FlxG.mouse.justPressedRight)
				close();
		}
		else
			subMenuControl();
	}

	override public function close()
	{
		Main.letterOffset = false;
		Init.saveControls(); // for controls
		Init.saveSettings(); // for offset
		super.close();
	}

	var submenu:FlxSprite;

	function openSubmenu()
	{
		offsetTemp = Init.trueSettings['Offset'];

		submenu.visible = true;
		if (curSelection != keyOptions.length - 1)
			submenuGroup.visible = true;
		else
			submenuoffsetGroup.visible = true;
	}

	function closeSubmenu()
	{
		submenuOpen = false;

		submenu.visible = false;

		submenuGroup.visible = false;
		submenuoffsetGroup.visible = false;
	}

	function subMenuControl()
	{
		// I dont really like hardcoded shit so I'm probably gonna change this lmao
		if (curSelection != keyOptions.length - 1)
		{
			// be able to close the submenu
			if (FlxG.keys.justPressed.ESCAPE)
				closeSubmenu();
			else if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.PRINTSCREEN)
			{
				// loop through existing keys and see if there are any alike
				var checkKey = FlxG.keys.getIsDown()[0].ID;

				FlxG.sound.play(Paths.sound('scrollMenu'));

				// now check if its the key we want to change
				Init.gameControls.get(keyOptions.members[curSelection].text)[0][curHorizontalSelection] = checkKey;
				otherKeys.members[(curSelection * 2) + curHorizontalSelection].text = getStringKey(checkKey);

				if (FlxG.keys.justPressed.DELETE)
				{
					Init.gameControls.get(keyOptions.members[curSelection].text)[0][curHorizontalSelection] = null;
					otherKeys.members[(curSelection * 2) + curHorizontalSelection].text = getStringKey(null);
				}

				// refresh keys
				controls.loadKeyboardScheme();

				// close the submenu
				closeSubmenu();
			}
		}
		else
		{
			if (controls.ACCEPT || FlxG.mouse.justPressed && !lockAccept)
			{
				Init.trueSettings['Offset'] = offsetTemp;
				closeSubmenu();
			}
			else if (controls.BACK)
				closeSubmenu();

			var move = 0;

			var left = controls.UI_LEFT_P;
			var right = controls.UI_RIGHT_P;
			var leftP = controls.UI_LEFT;
			var rightP = controls.UI_RIGHT;
			var shiftP = FlxG.keys.pressed.SHIFT;

			if (left || leftP && shiftP)
				move = -1;
			else if (right || rightP && shiftP)
				move = 1;

			offsetTemp += move * 0.1;

			submenuoffsetGroup.forEachOfType(FlxText, str ->
			{
				str.text = "< " + Std.string(Math.floor(offsetTemp * 10) / 10) + " >";
				str.screenCenter(X);
			});
		}
	}
}
