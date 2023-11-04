---------------------------------------------------------------------->
-- �ű�����:	scripts/Include/HomeLandDaily.lua
-- ����ʱ��:	2020/5/15 14:53:45
-- �����û�:	GUOGE
-- �ű�˵��:	
----------------------------------------------------------------------<
DailyBuff = {
	dwBuffId = 17293,
	nLevel = 1,
}
WeekilyBuff = {
	dwBuffId = 17295,
	nLevel = 1,
}
--ÿ���ռʮ���Ƶ�һλ���ID����λ�� ---�Ѿ����˲����ټ���
tActivityReward = {
	[1] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 7431)},--ÿ��˯������,20210406�ĳ�0
	[2] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 8355)},	--ÿ������ܽ���,20210406�ĳ�0
	[3] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 7460)},	  --ÿ����������,20210406�ĳ�0
	[4] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 7461)},	  --ÿ����ױ̨����,20210406�ĳ�0
	[5] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 7595)},--ÿ���״ε�½��С����Ծ��
	[6] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 8287)},--ϴ��,20210406�ĳ�0
	[7] = {nTime = 1, nHomeReward = 0,szActivityName = "nil"},--�״γ������
	[8] = {nTime = 1, nHomeReward = 0,szActivityName = "nil"},--ÿ���һ�����
	[9] = {nTime = 5, nHomeReward = 0,szActivityName = "nil"},--ÿ���������
	[10] =  {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 3100)},--ÿ���һ�κȲ�
	--����10λ���Ѿ����� �����ټ���
}
tWeekActivityReward = {
	[1] = {nTime = 5, nHomeReward = 1800,szActivityName = GetEditorString(16, 8267)},--��������
	[2] = {nTime = 1, nHomeReward = 0,szActivityName = "nil"},--С��ÿ�ܵ�һ�ν�����������������Ҫ�����ֵ��
	[3] = {nTime = 5, nHomeReward = 180,szActivityName = GetEditorString(7, 1824)},--�ͻ�  522��ֻ��90����˼һ�� ��5����CD byС��
}
--С��ÿ����Դ��
tlandlevelreward = {
	[1] = 2000,
	[2] = 3000,
	[3] = 4000,
	[4] = 5000,
	[5] = 6000,
	[6] = 7500,
	[7] = 9000,
	}
function UpdateDailyBuff(player, nActivityID)
	local bResult = false
	local tRewardList = tActivityReward[nActivityID]
	if not tRewardList then
		return bResult
	end
	if not player.IsHaveBuff(DailyBuff.dwBuffId, DailyBuff.nLevel) then
		--���㵽����7������� ���ж���һ����
		local nNowHour = GetCurrentHour()
		local nNowMinute = GetCurrentMinute()
		local nRequireMinute = 0
		if nNowHour >= 7 then
			nRequireMinute = (24 + 6 - nNowHour) * 60
		end
		if nNowHour >= 0 and nNowHour < 7 then
			nRequireMinute = (6 - nNowHour) * 60
		end
		nRequireMinute = nRequireMinute + 60 - nNowMinute
		player.AddBuff(0, 99, DailyBuff.dwBuffId, DailyBuff.nLevel, nRequireMinute)
		local buffDaily = player.GetBuff(DailyBuff.dwBuffId, DailyBuff.nLevel)
		buffDaily.nCustomValue = 0
		--���»����
		local nNowTime = CustomFunction.GetValueByTenBit(buffDaily.nCustomValue, nActivityID)
		if nNowTime < tRewardList.nTime then
			buffDaily.nCustomValue = CustomFunction.SetValueByTenBit(buffDaily.nCustomValue, nActivityID, nNowTime + 1)
			player.AddArchitecture(tRewardList.nHomeReward,GetEditorString(16, 8778)..tRewardList.szActivityName)
			bResult = true
			return bResult
		end
		return bResult
	end
	local buffDaily = player.GetBuff(DailyBuff.dwBuffId, DailyBuff.nLevel)
	local nNowTime = CustomFunction.GetValueByTenBit(buffDaily.nCustomValue, nActivityID)
	if nNowTime < tRewardList.nTime then
		buffDaily.nCustomValue = CustomFunction.SetValueByTenBit(buffDaily.nCustomValue, nActivityID, nNowTime + 1)
		player.AddArchitecture(tRewardList.nHomeReward,GetEditorString(16, 8778)..tRewardList.szActivityName)
		bResult = true
		if tRewardList.szActivityName ~= "nil" and tRewardList.nHomeReward ~= 0 then
			RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_GREEN", GetEditorString(6, 8437)..tRewardList.szActivityName..GetEditorString(16, 8268), 4)
		end
		return bResult
	end
	return bResult
end

function UpdateWeeklyBuff(player, nActivityID)
	local bResult = false
	local tRewardList = tWeekActivityReward[nActivityID]
	if not tRewardList then
		return bResult
	end
	if not player.IsHaveBuff(WeekilyBuff.dwBuffId, WeekilyBuff.nLevel) then
		--���㵽������һ7������� ���ж���һ����
		--local nNowHour = GetCurrentHour()
		--local nNowMinute = GetCurrentMinute()
		--local nNowWeek = GetCurrentWeekDay()
		--local nRequireMinute = 0
		--if nNowHour >= 7 then
			--nRequireMinute = (24 + 6 - nNowHour) * 60
		--end
		--if nNowHour >= 0 and nNowHour < 7 then
			--nRequireMinute = (6 - nNowHour) * 60
		--end
		--if nNowWeek == 0 then
			--nNowWeek = 7
		--end
		--if nNowWeek >= 1 and nNowWeek <= 7 then
			--nRequireMinute = nRequireMinute + (7 - nNowWeek) * 24 * 60
		--end
		local nRequireMinute = CustomFunction.GetMinuToNextWeek7()
		player.AddBuff(0, 99, WeekilyBuff.dwBuffId, WeekilyBuff.nLevel, nRequireMinute)
		local buffWeekly = player.GetBuff(WeekilyBuff.dwBuffId, WeekilyBuff.nLevel)
		buffWeekly.nCustomValue = 0
		--���»����
		local nNowTime = CustomFunction.GetValueByTenBit(buffWeekly.nCustomValue, nActivityID)
		if nNowTime < tRewardList.nTime then
			buffWeekly.nCustomValue = CustomFunction.SetValueByTenBit(buffWeekly.nCustomValue, nActivityID, nNowTime + 1)
			player.AddArchitecture(tRewardList.nHomeReward,GetEditorString(16, 8779)..tRewardList.szActivityName)
			bResult = true
			return bResult
		end
		return bResult
	end
	local buffWeekly = player.GetBuff(WeekilyBuff.dwBuffId, WeekilyBuff.nLevel)
	local nNowTime = CustomFunction.GetValueByTenBit(buffWeekly.nCustomValue, nActivityID)
	--print(nNowTime)
	--print(tRewardList.nTime)
	if nNowTime < tRewardList.nTime then
		buffWeekly.nCustomValue = CustomFunction.SetValueByTenBit(buffWeekly.nCustomValue, nActivityID, nNowTime + 1)
		player.AddArchitecture(tRewardList.nHomeReward,GetEditorString(16, 8779)..tRewardList.szActivityName)
		bResult = true
		return bResult
	else
		if tRewardList.szActivityName ~= "nil" and tRewardList.nHomeReward ~= 0 then
			RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_GREEN", GetEditorString(16, 7433)..tRewardList.szActivityName..GetEditorString(16, 8268), 4)
		end
	end
	return bResult
end

function CheckDailyState(player, nActivityID)
	local bResult = false
	local tRewardList = tActivityReward[nActivityID]
	if not tRewardList then
		return bResult
	end
	if not player.IsHaveBuff(DailyBuff.dwBuffId, DailyBuff.nLevel) then
		bResult = true
		return bResult
	end
	local buffDaily = player.GetBuff(DailyBuff.dwBuffId, DailyBuff.nLevel)
	local nValue = buffDaily.nCustomValue
	local nNowTime = CustomFunction.GetValueByTenBit(buffDaily.nCustomValue, nActivityID)
	if nNowTime < tRewardList.nTime then
		bResult = true
		return bResult
	end
end
