function loadAnimations()
{
	addByPrefix('idle', "idle spirit_", 24, false);
	addByPrefix('singUP', "up_", 24, false);
	addByPrefix('singRIGHT', "right_", 24, false);
	addByPrefix('singLEFT', "left_", 24, false);
	addByPrefix('singDOWN', "spirit down_", 24, false);

	addOffset("idle", -220, -280);
	addOffset("singDOWN", -150, -200);
	addOffset("singRIGHT", -220, -280);
	addOffset("singUP", -220, -240);
	addOffset("singLEFT", -200, -280);

	setGraphicSize(get('width') * 6);
	set('antialiasing', false);

	playAnim('idle');

	setCamOffsets(100, 50);
	setBarColor([255, 60, 110]);
}
