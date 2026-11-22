slot0 = class("BossSingleVariableEnemyData", import(".BossSingleEnemyData"))
slot0.TYPE = {
	EAST = 1,
	HARD = 3,
	NORMAL = 2,
	SP = 4
}

slot0.IsContinuousType = function(slot0)
	return true
end

return slot0
