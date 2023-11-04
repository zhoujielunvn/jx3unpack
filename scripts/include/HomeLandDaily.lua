---------------------------------------------------------------------->
-- 脚本名称:	scripts/Include/HomeLandDaily.lua
-- 更新时间:	2020/5/15 14:53:45
-- 更新用户:	GUOGE
-- 脚本说明:	
----------------------------------------------------------------------<
DailyBuff = {
	dwBuffId = 17293,
	nLevel = 1,
}
WeekilyBuff = {
	dwBuffId = 17295,
	nLevel = 1,
}
--每个活动占十进制的一位，活动ID就是位数 ---已经满了不能再加了
tActivityReward = {
	[1] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 7431)},--每日睡觉奖励,20210406改成0
	[2] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 8355)},	--每日脸盆架奖励,20210406改成0
	[3] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 7460)},	  --每日书桌奖励,20210406改成0
	[4] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 7461)},	  --每日梳妆台奖励,20210406改成0
	[5] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 7595)},--每日首次登陆加小区活跃度
	[6] = {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 8287)},--洗澡,20210406改成0
	[7] = {nTime = 1, nHomeReward = 0,szActivityName = "nil"},--首次宠物出行
	[8] = {nTime = 1, nHomeReward = 0,szActivityName = "nil"},--每天第一次如厕
	[9] = {nTime = 5, nHomeReward = 0,szActivityName = "nil"},--每天酿造次数
	[10] =  {nTime = 1, nHomeReward = 0,szActivityName = GetEditorString(16, 3100)},--每天第一次喝茶
	--撑死10位，已经满了 不能再加了
}
tWeekActivityReward = {
	[1] = {nTime = 5, nHomeReward = 1800,szActivityName = GetEditorString(16, 8267)},--帮人照料
	[2] = {nTime = 1, nHomeReward = 0,szActivityName = "nil"},--小区每周第一次奖励，用来计数，不要改这个值，
	[3] = {nTime = 5, nHomeReward = 180,szActivityName = GetEditorString(7, 1824)},--送花  522先只给90点意思一下 加5分钟CD by小凤
}
--小区每周资源点
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
		--计算到次日7点的跳数 敏感度是一分钟
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
		--更新活动计数
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
		--计算到下周周一7点的跳数 敏感度是一分钟
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
		--更新活动计数
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
