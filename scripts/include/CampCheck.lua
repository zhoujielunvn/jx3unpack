---------------------------------------------------------------------->
-- �ű�����:	scripts/Include/CampCheck.lua
-- ����ʱ��:	2017/7/10 15:48:57
-- �����û�:	zhengfeng6
-- �ű�˵��:	����ű�ֻ����PVP����Ӫ���
----------------------------------------------------------------------<
local CAMP = CAMP
local nNewServerLimit = 2000 -- ˫����Ӫ�����������ֵ����Ϊ���·�
local nPermitRate = 4 / 5
local nGameWorldStartTime = GetGameWorldStartTime() -- �������״ο�����ʱ��
--local nGameWorldChargeTime = GetGlobalSystemValueCache().nGameWorldChargeTime -- ��������ʼ�Ʒѵ�ʱ��

-- PVP����ѯ�ɼ�����Ӫ�����������ֵΪ���Ƿ�ɼ�������ˣ��Ƿ�ɼ�����˹�
function GetCampJoinInfo()
	if nGameWorldStartTime == 0 then
		nGameWorldStartTime = GetGameWorldStartTime()
	end
	local CampInfo = GetCampInfo()
	if not CampInfo then
		return false, false
	end

	local nCountHQM = CampInfo.GetRealActivePlayerCount(1) -- ���������ܻ�Ծ����
	local nCountERG = CampInfo.GetRealActivePlayerCount(2) -- ���˹����ܻ�Ծ����

	-- ǰ�������������ֵΪ��Ӫ��������
	if GetCurrentTime() - nGameWorldStartTime <= 1209600 then
		nCountHQM = CampInfo.nGoodTotalCount -- ��������Ӫ��������
		nCountERG = CampInfo.nEvilTotalCount -- ���˹���Ӫ��������
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

-- ��һ�μ�����Ӫ�������Ǳ�
local tCampQuest = { -- ����Ӫ������ID������Ӫ��ʾ��
	[CAMP.GOOD] = {4633, GetEditorString(0, 2388), },
	[CAMP.EVIL] = {4632, GetEditorString(0, 5728), },
}
local string_CAMP_JOIN0 = GetEditorString(11, 7241)
local string_CAMP_JOIN1 = GetEditorString(11, 7242)
local string_CAMP_JOIN2 = GetEditorString(1, 929)
local string_CAMP_JOIN3 = GetEditorString(11, 7243)
local string_CAMP_JOIN4 = GetEditorString(11, 7244)

local nTitlePointBuffID = 7649 -- ����Buff����¼ս�׻���
local nTitlePointBuffLevel = 1
local nPantaoBuffID = 1306 -- ������buff

-- PVP�����波�Լ�����Ӫ
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

	player.SetCamp(nOpCampID) -- ������Ӫ	
	
	if player.CanOpenCampFlag() then
		player.OpenCampFlag()
	end

	local nActiveCount = math.floor(OnGetNextMondaySevenPassTime() / 60)		-- Buffÿ��60S
	local buff = player.GetBuff(nTitlePointBuffID, nTitlePointBuffLevel)		-- ����Buff����¼ս�׻���
	if not buff then
		player.AddBuff(0, 99, nTitlePointBuffID, nTitlePointBuffLevel, nActiveCount)
	elseif buff.nLeftActiveCount <= 1 then
		player.AddBuff(0, 99, nTitlePointBuffID, nTitlePointBuffLevel, nActiveCount)
		buff.nCustomValue = 0
	end

	-- �����һ������Ӫ�ж�����������???

end
-- PVP�������Ӫ�������
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
	-- ǰ�������������ֵΪ��Ӫ��������
	if GetCurrentTime() - nGameWorldStartTime <= 1209600 then
		if nOpCampID == CAMP.GOOD then
			nCountOp = CampInfo. nGoodTotalCount -- ��������Ӫ��������
			nCountElse = CampInfo. nEvilTotalCount -- ���˹���Ӫ��������
		else
			nCountOp = CampInfo.nEvilTotalCount  -- ��������Ӫ��������
			nCountElse = CampInfo.nGoodTotalCount  -- ���˹���Ӫ��������
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
