---------------------------------------------------------------------->
-- 脚本名称:	scripts/Include/PushRoleCountMap.lua
-- 更新时间:	2017/7/15 10:32:53
-- 更新用户:	zhengfeng6
-- 脚本说明:   注册地图为系统自动同步当前阵营人数
-- GCCommand("RegisterPushRoleCountMap(" .. scene.dwMapID .. ")", false) --  dwMapID 地图ID, bInRate 是否以比例方式显示
-- GCCommand("UnregisterPushRoleCountMap(" .. scene.dwMapID .. ")")
----------------------------------------------------------------------<
local tPushRoleCountMap_List = {
	
	--[3] = {是否需要设阵营人数上限，"排队活动ID"},  237：小攻防 436：世界BOSS
	[9] =   {true, 237}, -- "洛道",
	[10] =  {true, 0}, -- "寇岛",
	[12] =  {true, 237}, -- "枫华谷",
	[13] =  {true, 237}, -- "金水镇",
	[21] =  {true, 237}, -- "巴陵县",
	[22] =  {true, 237}, -- "南屏山",
	[23] =  {true, 237}, -- "龙门荒漠",
	[25] =  {true, 237}, -- "浩气盟",
	[27] =  {true, 237}, -- "恶人谷",
	[30] =  {true, 237}, -- "昆仑",
	[35] =  {true, 237}, -- "瞿塘峡",	
	[100] = {true, 237}, -- "白龙口",
	[101] = {true, 237}, -- "无量山",
	[103] = {true, 237}, -- "融天岭",
	[104] = {true, 237}, -- "黑龙沼",
	[105] = {true, 237}, -- "苍山洱海",
	[139] = {true, 237}, -- "枫华谷·战乱",
	[151] = {true, 436}, -- "洛阳·战乱",
	[152] = {true, 0}, -- "大唐监狱",
	[153] = {true, 237}, -- "马嵬驿",
	[156] = {true, 436}, -- "长安·战乱",
	[214] = {true, 436}, -- "五台山",
	[215] = {true, 436}, -- "千岛湖",
	[216] = {true, 0}, -- "阴山大草原",
	[217] = {false, 0}, -- "黑戈壁",
}
function PushRoleCountMap(scene)
	if GetServerType() == SERVER_TYPE.PVP then
		if tPushRoleCountMap_List[scene.dwMapID] then
			if not IsActivityOn(tPushRoleCountMap_List[scene.dwMapID][2]) and tPushRoleCountMap_List[scene.dwMapID][1] then
				GCCommand("SetMapMaxPlayerCountByCamp(" .. scene.dwMapID .. ", 1, 400)")
				GCCommand("SetMapMaxPlayerCountByCamp(" .. scene.dwMapID .. ", 2, 400)")
			end 
			GCCommand("RegisterPushRoleCountMap(" .. scene.dwMapID .. ", " .. scene.nCopyIndex .. ", true)") --  dwMapID 地图ID, nCopyIndex(23.8.28新增参数), bInRate 是否以比例方式显示
		end		

	end	
end