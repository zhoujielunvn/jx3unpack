---------------------------------------------------------------------->
-- 脚本名称:	scripts/Include/BackToHome.lua
-- 更新时间:	2020/4/27 19:10:52
-- 更新用户:	GUOGE
-- 脚本说明:	
----------------------------------------------------------------------<

Include("scripts/Include/LandCondition.lh")
local HomeLandMgr = GetHomelandMgr()
function CheckShenxing(player)
	local bCanGo = true
	local scene = player.GetScene()
	if not (scene.nType == 0 or scene.nType == 5 or scene.nType == 1 or scene.nType == 4) then
		if scene.dwMapID ~= 1 then  --稻香村就算了吧
			RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_WARNING_YELLOW", GetEditorString(16, 8534), 5)
			return
		end
	end
	if scene.dwMapID==152 then -- 大唐监狱禁用
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", GetEditorString(16, 9610), 4)
		return
	end	
	if player.nLevel < 100 then -- 这里不能判满级，不然以后开新等级，已经有家园的在满级前就没法玩了
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", GetEditorString(16, 8843), 4)
		return
	end
	if IsRemotePlayer(player.dwID) then
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", GetEditorString(16, 8804), 4)
		return
	end
	if player.GetDynamicSkillGroup() ~= 0 then --处于动态技能栏特殊状态无法回家
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", GetEditorString(16, 6066), 4)
		return
	end
	if player.IsHaveBuff(17327, 0) or player.IsHaveBuff(7732, 1) or player.IsHaveBuff(10826, 1) or player.IsHaveBuff(13149, 1) then
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", GetEditorString(16, 8339), 4)
		return
	end
	if player.IsHaveBuff(9982, 1) then
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", GetEditorString(16, 8770), 4)
		return
	end
	if player.IsHaveBuff(13096, 0) then
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", GetEditorString(16, 8770), 4)
		return
	end
	if InSafeCity(scene) then
		return bCanGo
	end
	
	if player.GetCDLeft(244) ~= 0 and not player.IsSkillRecipeExist(5199, 1) then
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", GetEditorString(16, 5715), 4)
		bCanGo = false
		return bCanGo
	end
	local nLevel = player.GetSkillLevel(81)
	if nLevel <= 0 then
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", GetEditorString(16, 5716), 4)
		bCanGo = false
		return bCanGo		
	end
	return bCanGo
end

function InSafeCity(scene)
	if scene.dwMapID == 8 or scene.dwMapID == 15 or scene.dwMapID == 6 or scene.dwMapID == 108 or scene.dwMapID == 194 or scene.dwMapID == 332 or scene.dwMapID == 172 then
		return true
	end
	if IsHomeMap(scene.dwMapID) then
		return true
	end
	return false
end