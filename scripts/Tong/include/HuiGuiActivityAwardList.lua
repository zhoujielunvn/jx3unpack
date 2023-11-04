---------------------------------------------------------------------->
-- 脚本名称:	scripts/Tong/include/HuiGuiActivityAwardList.lua
-- 更新时间:	2019/11/25 16:34:16
-- 更新用户:	wangjunyao
-- 脚本说明:	
----------------------------------------------------------------------<
Include("scripts/Include/FormatLinkString.lh")

local tTongAwardList = {
	--[1] = {nTongAward = , szText="", bIsActiv = FALSE}, --勤修不辍·传功
	--[2] = {nTongAward = , szText="", bIsActiv = FALSE}, --勤修不辍·打坐
	--[3] = {nTongAward = , szText="", bIsActiv = FALSE}, --勤修不辍·演武
	--[4] = {nTongAward = , szText="", bIsActiv = FALSE}, --勤修不辍
	[5] = {nTongAward = 2, szText=GetEditorString(15, 7620), bIsActiv = FALSE}, --沧海云帆闻茶香
	--[6] = {nTongAward = , szText="", bIsActiv = FALSE}, --科举省试
	--[7] = {nTongAward = , szText="", bIsActiv = FALSE}, --科举会试
	--[8] = {nTongAward = , szText="", bIsActiv = FALSE}, --美人图
	--[9] = {nTongAward = 9, szText="协助回归隐侠完成美人图·潜行，增加帮会同归值。", bIsActiv = FALSE}, --美人图·潜行
	--[10] = {nTongAward = 10, szText="协助回归隐侠完成寻龙勘脉窥天机，增加帮会同归值。", bIsActiv = FALSE}, --寻龙勘脉窥天机
	--[11] = {nTongAward = 11, szText="协助回归隐侠完成游历瞿塘采仙草，增加帮会同归值。", bIsActiv = FALSE}, --游历瞿塘采仙草
	--[12] = {nTongAward = 12, szText="和回归隐侠共同完成菜园保卫战，增加帮会同归值。", bIsActiv = FALSE}, --菜园保卫战
	--[13] = {nTongAward = , szText="", bIsActiv = FALSE}, --签到
	--[14] = {nTongAward = , szText="", bIsActiv = FALSE}, --帮会领地特殊活动
	--[15] = {nTongAward = , szText="", bIsActiv = FALSE}, --修习生活技能
	--[16] = {nTongAward = , szText="", bIsActiv = FALSE}, --挖宝
	[17] = {nTongAward = 4, szText=GetEditorString(15, 7621), bIsActiv = FALSE}, --秘境日常（任务）
	[18] = {nTongAward = 2, szText=GetEditorString(15, 7622), bIsActiv = FALSE}, --武林通鉴·秘境（任务）
	[19] = {nTongAward = 4, szText=GetEditorString(15, 7623), bIsActiv = FALSE}, --武林通鉴·团队秘境（任务）
	[20] = {nTongAward = 5, szText=GetEditorString(15, 7624), bIsActiv = FALSE}, --25人英雄秘境（单boss）
	[21] = {nTongAward = 8, szText=GetEditorString(15, 7625), bIsActiv = FALSE}, --25人挑战秘境（单boss）
	[22] = {nTongAward = 2, szText=GetEditorString(15, 7626), bIsActiv = FALSE}, --公共任务
	[23] = {nTongAward = 4, szText=GetEditorString(15, 7627), bIsActiv = TRUE}, --世界首领
	[24] = {nTongAward = 4, szText=GetEditorString(15, 7628), bIsActiv = FALSE}, --道源蓝晶起波涛
	[25] = {nTongAward = 1, szText=GetEditorString(15, 7629), bIsActiv = FALSE}, --据点贸易（每天三次）
	--[26] = {nTongAward = 4, szText="协助回归隐侠参与阴山商路活动，增加帮会同归值。", bIsActiv = TRUE}, --阴山商路
	--[27] = {nTongAward = 27, szText="协助回归隐侠参与阵营出征祭祀活动，增加帮会同归值。", bIsActiv = TRUE}, --阵营出征祭祀
	[28] = {nTongAward = 4, szText=GetEditorString(15, 7630), bIsActiv = FALSE}, --攻防前置
	[29] = {nTongAward = 8, szText=GetEditorString(15, 7631), bIsActiv = TRUE}, --逐鹿中原
	[30] = {nTongAward = 8, szText=GetEditorString(15, 7632), bIsActiv = TRUE}, --阵营攻防战
	[31] = {nTongAward = 6, szText=GetEditorString(15, 7633), bIsActiv = FALSE}, --战场胜利
	[32] = {nTongAward = 2, szText=GetEditorString(15, 7634), bIsActiv = FALSE}, --名剑大会胜利
	[33] = {nTongAward = 6, szText=GetEditorString(15, 7635), bIsActiv = FALSE}, --龙门绝境并进入前十名
	--[34] = {nTongAward = , szText="", bIsActiv = FALSE}, --李渡鬼域并进入前50%
	--[35] = {nTongAward = , szText="", bIsActiv = FALSE}, --野外钓鱼
	[36] = {nTongAward = 6, szText=GetEditorString(15, 7636), bIsActiv = FALSE}, --moba战场胜利
	--[37] = {nTongAward = , szText="", bIsActiv = FALSE}, --有杀怪和采集doodad的任务
}
local nMaxDis = 32 * 64

-- 检查是否和同帮会队友在附近
function CheckTongMemberNearby(player, nTongAwardType)
	if not IsActivityOn(568) then
		return
	end
	if player.dwTongID == 0 then
		return
	end
	if not player.IsHaveBuff(16421, 1) then
		return
	end
	if not player.IsInParty() then
		return
	end
	if player.bNewFarmerFlag then --筛除工作室
		return
	end
	local tplayerlist = player.GetPartyMemberList() --获得队伍中的人
	local tTongMemberList = {}
	if not tplayerlist then
		return
	end
	if not tTongAwardList[nTongAwardType] then
		return
	end
	local nAward = tTongAwardList[nTongAwardType].nTongAward
	local szText = tTongAwardList[nTongAwardType].szText
	--if not player.GetBuff(16421, 1) then
	--for i = 1, #tplayerlist do
	--local dwPartyMember = tplayerlist[i]
	--local player_Target = GetPlayer(dwPartyMember)
	--local nTongID = player_Target.dwTongID
	--if dwPartyMember ~= player.dwID and nTongID == player.dwTongID and player_Target and player_Target.GetBuff(16421, 1) then
	--if CustomFunction.GetSpace3D(player_Target, player) <= nMaxDis then
	--player_Target.SendSystemMessage(szText)
	--table.insert(tTongMemberList, dwPartyMember)
	--end
	--end
	--end
	--else
	for i = 1, #tplayerlist do
		local dwPartyMember = tplayerlist[i]
		local player_Target = GetPlayer(dwPartyMember)
		if dwPartyMember ~= player.dwID and player_Target and player_Target.dwTongID == player.dwTongID then
			if CustomFunction.GetSpace3D(player_Target, player) <= nMaxDis then
				player_Target.SendSystemMessage(szText)
				table.insert(tTongMemberList, dwPartyMember)
			end
		end
	end
	if #tTongMemberList < 1 then
		return
	end
	--玩家加个人爱心分
	if player.IsHaveBuff(16402, 1) then
		local buff_Personal = player.GetBuff(16402, 1)
		buff_Personal.nCustomValue = buff_Personal.nCustomValue + nAward
	end

	for j = 1, #tTongMemberList do
		local playerMember = GetPlayer(tTongMemberList[j])
		local buff_TeamMember = playerMember.GetBuff(16402, 1)
		if buff_TeamMember then
			buff_TeamMember.nCustomValue = buff_TeamMember.nCustomValue + nAward
		end
	end

	--检测回归玩家剩余可以加的同归值，并传到center去加帮会分
	local buff_WeeklyLimit = player.GetBuff(16421, 1)
	local nWeeklyLimit = 160 - buff_WeeklyLimit.nCustomValue --周上限160
	if nWeeklyLimit > nAward then
		RemoteCallToCenter("On_Tong_AddHuiGuiAward", player.dwID, nAward)
		buff_WeeklyLimit.nCustomValue = buff_WeeklyLimit.nCustomValue + nAward
	elseif nAward >= nWeeklyLimit and nWeeklyLimit > 0 then
		RemoteCallToCenter("On_Tong_AddHuiGuiAward", player.dwID, nWeeklyLimit)
		buff_WeeklyLimit.nCustomValue = 160
	else
		player.SendSystemMessage(GetEditorString(15, 7078))
		return
	end
end

-- 检查是否和同帮会队友在同地图
function CheckTongMemberInMap(player, nTongAwardType)
	if not IsActivityOn(568) then
		return
	end
	if player.dwTongID == 0 then
		return
	end
	if not player.IsHaveBuff(16421, 1) then
		return
	end
	if player.bNewFarmerFlag then --筛除工作室
		return
	end
	if not player.IsInParty() then
		return
	end
	local tplayerlist = player.GetPartyMemberList() --获得队伍中的人
	local tTongMemberList = {}
	if not tplayerlist then
		return
	end
	if not tTongAwardList[nTongAwardType] then
		return
	end
	local nAward = tTongAwardList[nTongAwardType].nTongAward
	local szText = tTongAwardList[nTongAwardType].szText
	--if not player.GetBuff(16421, 1) then
	--for i = 1, #tplayerlist do
	--local dwPartyMember = tplayerlist[i]
	--local player_Target = GetPlayer(dwPartyMember)
	--local nTongID = player_Target.dwTongID
	--if dwPartyMember ~= player.dwID and nTongID == player.dwTongID and player_Target and player_Target.GetBuff(16421, 1) then
	--if player_Target.GetMapID() == player.GetMapID() then
	--player_Target.SendSystemMessage(szText)
	--table.insert(tTongMemberList, dwPartyMember)
	--end
	--end
	--end
	--else
	for i = 1, #tplayerlist do
		local dwPartyMember = tplayerlist[i]
		local player_Target = GetPlayer(dwPartyMember)
		if dwPartyMember ~= player.dwID and player_Target and player_Target.dwTongID == player.dwTongID then
			if player_Target.GetMapID() == player.GetMapID() then
				player_Target.SendSystemMessage(szText)
				table.insert(tTongMemberList, dwPartyMember)
			end
		end
	end

	if #tTongMemberList < 1 then
		return
	end

	--回归玩家和他的同帮队友加个人爱心分
	--玩家加个人爱心分
	if player.IsHaveBuff(16402, 1) then
		local buff_Personal = player.GetBuff(16402, 1)
		buff_Personal.nCustomValue = buff_Personal.nCustomValue + nAward
	end
	for j = 1, #tTongMemberList do
		local playerMember = GetPlayer(tTongMemberList[j])
		if playerMember.IsHaveBuff(16402, 1) then
			local buff_TeamMember = playerMember.GetBuff(16402, 1)
			buff_TeamMember.nCustomValue = buff_TeamMember.nCustomValue + nAward
		end
	end

	--检测回归玩家剩余可以加的同归值，并传到center去加帮会分
	local buff_WeeklyLimit = player.GetBuff(16421, 1)
	local nWeeklyLimit = 160 - buff_WeeklyLimit.nCustomValue --临时数值，记得改
	if nWeeklyLimit > nAward then
		RemoteCallToCenter("On_Tong_AddHuiGuiAward", player.dwID, nAward)
		buff_WeeklyLimit.nCustomValue = buff_WeeklyLimit.nCustomValue + nAward
	elseif nAward >= nWeeklyLimit and nWeeklyLimit > 0 then
		RemoteCallToCenter("On_Tong_AddHuiGuiAward", player.dwID, nWeeklyLimit)
		buff_WeeklyLimit.nCustomValue = 160
	else
		player.SendSystemMessage(GetEditorString(15, 7078))
		return
	end
end

-- 跨服活动前标记帮会关系
function CheckTongRelationInTeam(player, nTongAwardType)
	if not IsActivityOn(568) then
		return
	end
	if player.dwTongID == 0 then
		return
	end
	if not player.IsHaveBuff(16421, 1) then
		return
	end
	if player.bNewFarmerFlag then --筛除工作室
		return
	end
	if not player.IsInParty() then
		return
	end
	local tplayerlist = player.GetPartyMemberList()
	--local tTongMemberList = {}
	if not tplayerlist then
		return
	end

	for i = 1, #tplayerlist do
		local dwPartyMember = tplayerlist[i]
		local player_Target = GetPlayer(dwPartyMember)
		if player_Target then
			if dwPartyMember ~= player.dwID and player_Target.dwTongID == player.dwTongID then
				if not player_Target.IsHaveBuff(16401, 1) then
					player_Target.AddBuff(player.dwID, 99, 16401, 1, 10)
					--table.insert(tTongMemberList, dwPartyMember)
					local buff_Helper = player_Target.GetBuff(16401, 1)
					if buff_Helper then
						buff_Helper.nCustomValue = player_Target.dwTongID
					end
				end
				if not player.IsHaveBuff(16400, 1) then
					player.AddBuff(player.dwID, 99, 16400, 1, 10)
					local buff_Huigui = player.GetBuff(16400, 1)
					if buff_Huigui then
						buff_Huigui.nCustomValue = player.dwTongID
					end
				end
			end
		end
	end
end

--local tTongHuiGuiBuffList = {
--16400,16401,
--}

-- 跨服玩法结算时增加帮会活动积分标记，有回归玩家的加标记，获胜时看同帮会的还在不在；同帮会协助者加标记，获胜时看帮助的人还在不在
function CheckTongRelationInBF(player, nTongAwardType)
	--if not IsActivityOn(568) then
	--return
	--end
	if not player.IsHaveBuff(16421, 1) then
		return
	end
	if player.bNewFarmerFlag then
		return
	end
	if not player.IsInParty() then
		return
	end
	if not player.IsHaveBuff(16400, 1) then
		return
	end
	local buff_Huigui = player.GetBuff(16400, 1) -- 回归者
	local dwTongID = buff_Huigui.nCustomValue
	local tTeamMember = player.GetPartyMemberList()
	player.DelBuff(16400, 1)
	player.AddBuff(0, 99, 16400, 1, 10)
	buff_Huigui = player.GetBuff(16400, 1)
	if buff_Huigui then
		buff_Huigui.nCustomValue = nTongAwardType
	end
	for i = 1, #tTeamMember do
		if tTeamMember[i] ~= player.dwID then
			local player_Helper = GetPlayer(tTeamMember[i])
			if player_Helper and player_Helper.IsHaveBuff(16401, 1) then
				local buff_Helper = player_Helper.GetBuff(16401, 1)
				if buff_Helper.nCustomValue == dwTongID then
					--player.DelBuff(16400, 1)
					--player.AddBuff(0, 100, 16400, 1)
					--buff_Huigui = player.GetBuff(16400, 1)
					--if buff_Huigui then
					--buff_Huigui.nCustomValue = nTongAwardType
					--end
					player_Helper.DelBuff(16401, 1)
					player_Helper.AddBuff(player.dwID, 100, 16401, 1, 10)
					buff_Helper = player_Helper.GetBuff(16401, 1)
					if buff_Helper then
						buff_Helper.nCustomValue = nTongAwardType
					end
				end
			end
		end
	end
end

local tBFMapList = {
	[277] = true,
	[127] = true,
	[128] = true,
	[362] = true,
	[238] = true,
	[129] = true,
	[38] = true,
	[48] = true,
	[50] = true,
	[52] = true,
	[135] = true,
	[186] = true,
	[296] = true,
	[297] = true,
	[410] = true,
	[412] = true,
	[512] = true,
}

-- 跨服玩法出来过图时增加积分奖励（统计后发给center统一加）
function SendTongAwardInTongInfo(player)
	if not IsActivityOn(568) then
		return
	end
	if player.bNewFarmerFlag then --筛除工作室
		return
	end
	if tBFMapList[player.GetMapID()] then		--进入的是战场
		return
	end
	-- 这里要把之前的标记buff都记得删除，先用它们判一下关系，然后加一下给helper的奖励标记再删除
	local buff_Helper = player.GetBuff(16401, 1)
	local buff_Huigui = player.GetBuff(16400, 1)
	if not (buff_Helper or buff_Huigui)then
		player.DelBuff(16400, 1)
		player.DelBuff(16401, 1)
		return
	end
	--local dwHuiguiID = buff_Helper.dwSkillSrcID  --应该不用再做判断了，只要带着buff出来的，就可以开始发奖励了
	--if dwHuiguiID == player.dwID then
	--player.DelBuff(16401, 1)
	--return
	--end

	if buff_Helper then
		local nTongAwardType = buff_Helper.nCustomValue
		if not tTongAwardList[nTongAwardType] then
			player.DelBuff(16401, 1)
			return
		end
		local nAward = tTongAwardList[nTongAwardType].nTongAward
		local szText = tTongAwardList[nTongAwardType].szText
		player.SendSystemMessage(szText)
		player.DelBuff(16401, 1)
		--if not player.IsHaveBuff(16402, 1) then 
		--player.AddBuff(16402, 1)
		--end
		if player.IsHaveBuff(16402, 1) then
			local buff_Personal = player.GetBuff(16402, 1)
			buff_Personal.nCustomValue = buff_Personal.nCustomValue + nAward
		end
	end
	if buff_Huigui then
		local nTongAwardType = buff_Huigui.nCustomValue
		if not tTongAwardList[nTongAwardType] then
			player.DelBuff(16400, 1)
			return
		end
		local nAward = tTongAwardList[nTongAwardType].nTongAward
		player.DelBuff(16400, 1)
		--if not player.IsHaveBuff(16402, 1) then 
		--player.AddBuff(0, 99, 16402, 1, 720)
		--end
		if player.IsHaveBuff(16402, 1) then
			local buff_Personal = player.GetBuff(16402, 1)
			buff_Personal.nCustomValue = buff_Personal.nCustomValue + nAward
		end

		local buff_WeeklyLimit = player.GetBuff(16421, 1)
		local nWeeklyLimit = 160 - buff_WeeklyLimit.nCustomValue --临时数值，记得改
		if nWeeklyLimit > nAward then
			RemoteCallToCenter("On_Tong_AddHuiGuiAward", player.dwID, nAward)
			buff_WeeklyLimit.nCustomValue = buff_WeeklyLimit.nCustomValue + nAward
		elseif nAward >= nWeeklyLimit and nWeeklyLimit > 0 then
			RemoteCallToCenter("On_Tong_AddHuiGuiAward", player.dwID, nWeeklyLimit)
			buff_WeeklyLimit.nCustomValue = 160
		else
			player.SendSystemMessage(GetEditorString(15, 7078))
			return
		end
	end
end

--帮会大事记加log
local tClientIP = {
	["113.106.106.98" ] = true, --"公司电信出口"
	["113.106.106.99" ] = true, --"公司电信出口"
	["113.106.106.117"] = true, --"公司电信出口"
	["221.4.212.137"  ] = true, --"公司网通出口"
	["221.4.212.138"  ] = true, --"公司网通出口"
	["221.4.212.139"  ] = true,  --"公司网通出口"
	["182.139.133.135"] = true,  --"成都公司电信出口"
	["221.10.5.90"    ] = true,  --"成都公司网通出口"
	["221.10.5.89"    ] = true,  --"成都公司网通出口"
}
function AddTongLog(player)
	local dwTongID = player.dwTongID
	if dwTongID == 0 then
		return
	end
	--for i = 1, #tClientIP do
		--if player.szClientIP == tClientIP[i] then
			--return
		--end
	--end
	if tClientIP[player.szClientIP] then
		return
	end
	local szLog = FormatLinkString(GetEditorString(0, 1752), "") .. FormatLinkString(player.szName, tFontColor.orange) .. FormatLinkString(GetEditorString(15, 6971), "")
	AddTongCustomRecording(dwTongID, szLog)
	--print("记录log" .. szLog .. "记录帮会ID" .. dwTongID)
end