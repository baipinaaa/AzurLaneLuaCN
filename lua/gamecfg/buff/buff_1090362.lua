return {
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	desc_get = "",
	name = "",
	init_effect = "",
	time = 4,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 1090362,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 3,
				target = "TargetSelf",
				time = 1,
				skill_id = 1090361
			}
		}
	}
}
