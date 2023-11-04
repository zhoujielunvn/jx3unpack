---------------------------------------------------------------------->
-- 脚本名称:	scripts/Traffic/AutoFly.lua
-- 更新时间:	2015-10-22 9:35:40
-- 更新用户:	meizhu-PC
-- 脚本说明:	逻辑上交通前的调用，true为可以乘交通，false为不可以
----------------------------------------------------------------------<
Include("scripts/Map/逐鹿中原/include/据点争夺_Data.lh")
Include("scripts/Traffic/Include/场景声望对应表.lua")

function CanAutoFly(player, dwFromMapID, dwToMapID) --2023年10月版本 堡主新增导出后面多2个地图ID 这样可以判到是不是跨地图交通
	--2023年10月版本 江南新增判定 如果是在小攻防排队期间去往攻防开战场景 则暂时不允许
	local tCastleMaps = CastleFight.GetMapActivityState()
	if IsActivityOn(608) and tCastleMaps[dwToMapID] then
		player.SendSystemMessage(GetEditorString(28, 5752))
		return false
	end
	if IsActivityOn(490) and (dwToMapID == 25 or dwToMapID == 27) then
		player.SendSystemMessage(GetEditorString(28, 5772))
		return false
	end
	if player.dwShapeShiftID ~= 0 then	-- 玩家乘坐载具状态
		return false
	end
	if player.GetBuff(7732, 1) then
		player.SendSystemMessage(GetEditorString(6, 5293))
		return false
	end
	if player.GetBuff(9982, 1) then
		player.SendSystemMessage(GetEditorString(8, 6807))
		return false
	end
	if player.GetBuff(13096, 0) then
		player.SendSystemMessage(GetEditorString(8, 6807))
		return false
	end
	if player.GetBuff(9506, 1) then
		player.SendSystemMessage(GetEditorString(8, 9045))
		return false
	end
	--双人动作在锁定阶段上交通的表现处理
	if player.GetBuff(9219, 1) then
		player.SendSystemMessage(GetEditorString(8, 9045))
		return false
	end
	--通用禁止传送BUFF
	if player.GetBuff(10826, 1) then
		player.SendSystemMessage(GetEditorString(8, 9045))
		return false
	end
	if CheckTrafficRepresent(player) == 1 then
		local szTixing = {[1] = GetEditorString(0, 1752), [2] = GetEditorString(0, 1754), [3] = GetEditorString(0, 1752), [4] = GetEditorString(0, 1754), [5] = GetEditorString(1, 615), [6] = GetEditorString(1, 615)}
		local npc = player.GetSelectCharacter()
		if npc and GetNpc(npc.dwID) ~= nil and GetDistanceSq(npc.nX, npc.nY, npc.nZ, player.nX, player.nY, player.nZ) <= 147456 then
			npc.YellTo(player.dwID, GetEditorString(10, 2982) .. player.szName .. szTixing[player.nRoleType] .. GetEditorString(13, 8394))
		end
	end
	return true
end

function AutoFlyEnd(player, bNormalEnd)
	if player.IsHaveBuff(TRAFFIC_BUFF_ID, 1) then
		player.DelBuff(TRAFFIC_BUFF_ID, 1)
	end

	--非正常下交通，如：目标地图已满
	if not bNormalEnd then
		player.AddBuff(player.dwID, player.nLevel, 16727, 1, 3)  --3跳，9秒防摔死
	end
end