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
	name = "春菜技能回血弹条用",
	time = 1,
	stack = 1,
	color = "blue",
	picture = "",
	id = 111137,
	desc = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 111135
			}
		}
	}
}
