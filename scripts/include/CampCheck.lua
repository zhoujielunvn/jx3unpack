---------------------------------------------------------------------->
-- 脚本名称:	scripts/Include/CampCheck.lua
-- 更新时间:	2017/7/10 15:48:57
-- 更新用户:	zhengfeng6
-- 脚本说明:	这个脚本只处理PVP入阵营相关
----------------------------------------------------------------------<
local CAMP = CAMP
local nNewServerLimit = 2000 -- 双方阵营人数少于这个值则认为是新服
local nPermitRate = 4 / 5
local nGameWorldStartTime = GetGameWorldStartTime() -- 服务器首次开启的时间
--local nGameWorldChargeTime = GetGlobalSystemValueCache().nGameWorldChargeTime -- 服务器开始计费的时间

-- PVP服查询可加入阵营的情况。返回值为：是否可加入浩气盟，是否可加入恶人谷
function GetCampJoinInfo()
	if nGameWorldStartTime == 0 then
		nGameWorldStartTime = GetGameWorldStartTime()
	end
	local CampInfo = GetCampInfo()
	if not CampInfo then
		return false, false
	end

	local nCountHQM = CampInfo.GetRealActivePlayerCount(1) -- 浩气盟上周活跃人数
	local nCountERG = CampInfo.GetRealActivePlayerCount(2) -- 恶人谷上周活跃人数

	-- 前两个星期这个数值为阵营绝对人数
	if GetCurrentTime() - nGameWorldStartTime <= 1209600 then
		nCountHQM = CampInfo.nGoodTotalCount -- 浩气盟阵营绝对人数
		nCountERG = CampInfo.nEvilTotalCount -- 恶人谷阵营绝对人数
	end

	if nCountHQM <= nNewServerLimit and nCountERG <= nNewServerLimit then
		return true, true
	end

	local bCanJoinHQM = false
	local bCanJoinERG = false

	if nCountHQM / nCountERG >= nPermitRate then
		bCanJoinERG = true
	end

	if nCountERG / nCountHQM >= nPermitRate then
		bCanJoinHQM = true
	end

	return bCanJoinHQM, bCanJoinERG
end

local tString =
{
	[CAMP.GOOD] = GetEditorString(11, 7237),
	[CAMP.EVIL] = GetEditorString(11, 7238),
}
local string1 = GetEditorString(4, 7888)
local string2 = GetEditorString(4, 823)

-- 第一次加入阵营的任务标记表
local tCampQuest = { -- 入阵营任务标记ID，入阵营提示，
	[CAMP.GOOD] = {4633, GetEditorString(0, 2388), },
	[CAMP.EVIL] = {4632, GetEditorString(0, 5728), },
}
local string_CAMP_JOIN0 = GetEditorString(11, 7241)
local string_CAMP_JOIN1 = GetEditorString(11, 7242)
local string_CAMP_JOIN2 = GetEditorString(1, 929)
local string_CAMP_JOIN3 = GetEditorString(11, 7243)
local string_CAMP_JOIN4 = GetEditorString(11, 7244)

local nTitlePointBuffID = 7649 -- 隐藏Buff，记录战阶积分
local nTitlePointBuffLevel = 1
local nPantaoBuffID = 1306 -- 叛逃者buff

-- PVP服界面尝试加入阵营
function TryJoinCamp(player, nOpCampID)
	--print("nOpCampID" .. nOpCampID)
	local nFlag = GetCampJoinInfoByID(player, nOpCampID)
	if not nFlag then
		return
	end

	if not tString[nOpCampID] then
		return
	end
	--print(222222)
	--RemoteCallToClient(player.dwID, "OnMessageBoxRequest", 40, tString[nOpCampID], string1, string2, nOpCampID, false, 0, 0)

	if not tCampQuest[nOpCampID] then
		return
	end

	if player.nLevel < 18 then
		player.SendSystemMessage(string.format(string_CAMP_JOIN1, tCampQuest[nOpCampID][2]))
		return
	end

	if player.nCamp ~= 0 then
		player.SendSystemMessage(string_CAMP_JOIN2)
		return
	end

	--if player.GetReputeLevel(RELATION_FORCE.HAOQIMENG) < 3 then
	--player.SendSystemMessage(string.format(string_CAMP_JOIN3, tCampQuest[nOpCampID][2]))
	--return
	--end

	--if player.IsHaveBuff(nPantaoBuffID, 1) then
	--player.SendSystemMessage(string.format(string_CAMP_JOIN4, tCampQuest[nOpCampID][2]))
	--return
	--end

	if player.dwTeamID ~= 0 then
		RemoteCallToCenter("On_ZhanChang_LeaveTeam", player.dwID)
	end

	player.SetCamp(nOpCampID) -- 加入阵营	
	
	if player.CanOpenCampFlag() then
		player.OpenCampFlag()
	end

	local nActiveCount = math.floor(OnGetNextMondaySevenPassTime() / 60)		-- Buff每跳60S
	local buff = player.GetBuff(nTitlePointBuffID, nTitlePointBuffLevel)		-- 隐藏Buff，记录战阶积分
	if not buff then
		player.AddBuff(0, 99, nTitlePointBuffID, nTitlePointBuffLevel, nActiveCount)
	elseif buff.nLeftActiveCount <= 1 then
		player.AddBuff(0, 99, nTitlePointBuffID, nTitlePointBuffLevel, nActiveCount)
		buff.nCustomValue = 0
	end

	-- 处理第一次入阵营有额外威望奖励???

end
-- PVP服检查阵营人数情况
function GetCampJoinInfoByID(player, nOpCampID)
	if nOpCampID == CAMP.NEUTRAL then
		player.SendSystemMessage(GetEditorString(11, 7239))
		return false
	end

	local CampInfo = GetCampInfo()
	if not CampInfo then
		return false
	end

	local nCountOp = CampInfo.GetRealActivePlayerCount(nOpCampID)
	local nCountElseID = CAMP.GOOD
	if nOpCampID == CAMP.GOOD then
		nCountElseID = CAMP.EVIL
	end
	local nCountElse = CampInfo.GetRealActivePlayerCount(nCountElseID)
	-- 前两个星期这个数值为阵营绝对人数
	if GetCurrentTime() - nGameWorldStartTime <= 1209600 then
		if nOpCampID == CAMP.GOOD then
			nCountOp = CampInfo. nGoodTotalCount -- 浩气盟阵营绝对人数
			nCountElse = CampInfo. nEvilTotalCount -- 恶人谷阵营绝对人数
		else
			nCountOp = CampInfo.nEvilTotalCount  -- 浩气盟阵营绝对人数
			nCountElse = CampInfo.nGoodTotalCount  -- 恶人谷阵营绝对人数
		end
	end
	
	if nCountOp <= nNewServerLimit then
		return true
	end

	if nCountOp <= nNewServerLimit and nCountElse <= nNewServerLimit then
		return true		
	end

	if nCountElse / nCountOp >= nPermitRate then		
		return true
	else		
		player.SendSystemMessage(GetEditorString(11, 7240))
		return false
	end
	
end
