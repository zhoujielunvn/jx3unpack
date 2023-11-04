---------------------------------------------------------------------->
-- 脚本名称:	scripts/Tong/include/RentPlaceData.lua
-- 更新时间:	2018/12/4 19:36:01
-- 更新用户:	wangsongtao-pc
-- 脚本说明:
----------------------------------------------------------------------<
Include("scripts/Include/Table.lh")
tRentPlaceData = {}
tRentPlaceData.nMoneyForHalfHour = 400
tRentPlaceData.nMoneyForHour = 800
tRentPlaceData.nChoseBuffID = 14245
tRentPlaceData.nInBuffID = 14280 --进入擂台, 1 选手； 2 指挥 1分钟一跳
tRentPlaceData.nEndHour = 24
tRentPlaceData.nVipBuff = 14484 --


tRentPlaceData.NpcCustomValue = {ConvertProxiedTable = ConvertProxiedTable,
	dwUsingTime = {0, 3},
};tRentPlaceData.NpcCustomValue = tRentPlaceData.NpcCustomValue:ConvertProxiedTable()

tRentPlaceData.nNpcBusyCD = 5 -- 5秒

tRentPlaceData.tType = {
	[6] = 219,
	[108] = 220,
	[15] = 221,
}

tRentPlaceData.tPosition = {
	[6] = {nX = 53729, nY = 69286, nZ = 1051904}, -- 扬州
	[15] = {nX = 60099, nY = 89698, nZ = 1061376}, -- 长安
	[108] = {nX = 76425, nY = 64066, nZ = 1072064}, -- 成都
}
--NPC 王富强 64226
--{60599, 89698, 1061376, 215}, --15 长安
--{53068, 69038, 1051904, 35}, -- 扬州 NPC
--{79541, 62603, 1072064, 102}, -- 成都

-- local tRentPlaceData = GetCustomRankList(nRankID)
-- ID = day(1-31)
-- Key = playerID
-- nDay = 20110120 这个没有
-- nRTime 租赁的正确时间
-- nLast = 3600
-- szName = "名字"

tRentPlaceData.tPreRentDay = {
	[0] = {0, 0, GetEditorString(13, 9658)}, --{>=资历， 提前几天预定，对话文字｝
	[1] = {40000, 1, GetEditorString(13, 9577)},
	[2] = {60000, 2, GetEditorString(13, 9578)},
	[3] = {80000, 3, GetEditorString(13, 9579)},
	[4] = {90000, 4, GetEditorString(13, 9580)},
	[5] = {100000, 5, GetEditorString(13, 9581)},
}

function tRentPlaceData.GetCanRentDay(player)
	local nPreDay = 0
	local nAchPoint = player.GetAchievementPoint()
	if nAchPoint < tRentPlaceData.tPreRentDay[1][1] then
		return nPreDay
	end
	for i = #tRentPlaceData.tPreRentDay, 1, - 1 do
		if nAchPoint >= tRentPlaceData.tPreRentDay[i][1] then
			return tRentPlaceData.tPreRentDay[i][2]
		end
	end
end

-- 这一天是否已经被预约了；tTime 预约的时间
function tRentPlaceData.IsAlreadyRent(tTime, nMapID)
	local tData = GetCustomRankListByID(tRentPlaceData.GetRankID(nMapID), tTime.day)
	if not tData then
		return false
	end
	local tT = TimeToDate(tData.nRTime)
	if tT.year == tTime.year and tT.month == tTime.month and tT.day == tTime.day then
		return true
	end
	return false
end

-- 废弃不用
function tRentPlaceData.GetRentDay(tTime)
	local szDay = tTime.year .. tTime.month < 10 and ("0" .. tTime.month) or  tTime.month .. tTime.day < 10 and ("0" .. tTime.day) or  tTime.day
	print("szDay", szDay)
	return tonumber(szDay)
end

function tRentPlaceData.GetRankID(dwMapID)
	return tRentPlaceData.tType[dwMapID]
end

-- 是不是在我的预约时间内
function tRentPlaceData.IsMyRentPlaceDay(player, tData)
	if not tData then
		return false
	end
	if player.dwID ~= tData.nKey then
		return false
	end
	local nCurTime = GetCurrentTime()
	if nCurTime >= tData.nRTime and nCurTime < tData.nRTime + tData.nLast then
		return true
	end
	return false
end

-- NPC是否正忙碌
function tRentPlaceData.IsNpcBusy(npc, nTime)
	local nUseTime = npc.GetCustomUnsigned4(tRentPlaceData.NpcCustomValue.dwUsingTime)
	if nTime - nUseTime < tRentPlaceData.nNpcBusyCD  then
		return true
	end
	return false
end

function tRentPlaceData.SetNpcBusy(npc, nTime)
	npc.SetCustomUnsigned4(tRentPlaceData.NpcCustomValue.dwUsingTime, nTime)
end

function tRentPlaceData.IfKickOut(nMapID, player)
	if GetCurrentHour() < 19 then
		return false
	end
	local buffOwner = player.GetBuff(tRentPlaceData.nInBuffID, 2)
	if buffOwner and buffOwner.nCustomValue == nMapID then
		return false
	end
	local tData = GetCustomRankListByID(tRentPlaceData.GetRankID(nMapID), GetCurrentDay())
	if not tData then
		return false
	end

	local nCurTime = GetCurrentTime()
	local nEndTime = tData.nRTime + tData.nLast
	
	if nCurTime >= tData.nRTime and nCurTime <= nEndTime then
		--在租的期间
		if player.dwID == tData.nKey then
			player.AddBuff(0, 99, tRentPlaceData.nInBuffID, 2, math.ceil((nEndTime - nCurTime)/60))
			buffOwner = player.GetBuff(tRentPlaceData.nInBuffID, 2)
			buffOwner.nCustomValue = nMapID
			return false
		end
		local buff = player.GetBuff(tRentPlaceData.nInBuffID, 1)
		if not buff then
			return true -- 不是嘉宾，要被踢出去
		end
		if tData.nKey ~= buff.nCustomValue then
			return true -- 不是嘉宾也不是主人，要被踢出去
		else
			return false
		end
	end
	return false
end


function tRentPlaceData.CheckVip(player, npc)
	--[[
	if not player.IsHaveBuff(tRentPlaceData.nVipBuff, 1) then
			return false
	end
	--]]
	return true
end