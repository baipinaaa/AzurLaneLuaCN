return {
	{},
	{},
	{},
	{},
	{},
	time = 3,
	name = "2026撒丁SP活动 皮肤展示",
	init_effect = "",
	stack = 1,
	id = 201691,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201692,
				target = "TargetHarmNearest"
			}
		}
	}
}
