---------------------------------------------------------------------->
-- �ű�����:	scripts/Tong/include/HuiGuiActivityAwardList.lua
-- ����ʱ��:	2019/11/25 16:34:16
-- �����û�:	wangjunyao
-- �ű�˵��:	
----------------------------------------------------------------------<
Include("scripts/Include/FormatLinkString.lh")

local tTongAwardList = {
	--[1] = {nTongAward = , szText="", bIsActiv = FALSE}, --���޲�ꡡ�����
	--[2] = {nTongAward = , szText="", bIsActiv = FALSE}, --���޲�ꡡ�����
	--[3] = {nTongAward = , szText="", bIsActiv = FALSE}, --���޲�ꡡ�����
	--[4] = {nTongAward = , szText="", bIsActiv = FALSE}, --���޲��
	[5] = {nTongAward = 2, szText=GetEditorString(15, 7620), bIsActiv = FALSE}, --�׺��Ʒ��Ų���
	--[6] = {nTongAward = , szText="", bIsActiv = FALSE}, --�ƾ�ʡ��
	--[7] = {nTongAward = , szText="", bIsActiv = FALSE}, --�ƾٻ���
	--[8] = {nTongAward = , szText="", bIsActiv = FALSE}, --����ͼ
	--[9] = {nTongAward = 9, szText="Э���ع������������ͼ��Ǳ�У����Ӱ��ͬ��ֵ��", bIsActiv = FALSE}, --����ͼ��Ǳ��
	--[10] = {nTongAward = 10, szText="Э���ع��������Ѱ����������������Ӱ��ͬ��ֵ��", bIsActiv = FALSE}, --Ѱ�����������
	--[11] = {nTongAward = 11, szText="Э���ع�������������������ɲݣ����Ӱ��ͬ��ֵ��", bIsActiv = FALSE}, --�����������ɲ�
	--[12] = {nTongAward = 12, szText="�ͻع�������ͬ��ɲ�԰����ս�����Ӱ��ͬ��ֵ��", bIsActiv = FALSE}, --��԰����ս
	--[13] = {nTongAward = , szText="", bIsActiv = FALSE}, --ǩ��
	--[14] = {nTongAward = , szText="", bIsActiv = FALSE}, --����������
	--[15] = {nTongAward = , szText="", bIsActiv = FALSE}, --��ϰ�����
	--[16] = {nTongAward = , szText="", bIsActiv = FALSE}, --�ڱ�
	[17] = {nTongAward = 4, szText=GetEditorString(15, 7621), bIsActiv = FALSE}, --�ؾ��ճ�������
	[18] = {nTongAward = 2, szText=GetEditorString(15, 7622), bIsActiv = FALSE}, --����ͨ�����ؾ�������
	[19] = {nTongAward = 4, szText=GetEditorString(15, 7623), bIsActiv = FALSE}, --����ͨ�����Ŷ��ؾ�������
	[20] = {nTongAward = 5, szText=GetEditorString(15, 7624), bIsActiv = FALSE}, --25��Ӣ���ؾ�����boss��
	[21] = {nTongAward = 8, szText=GetEditorString(15, 7625), bIsActiv = FALSE}, --25����ս�ؾ�����boss��
	[22] = {nTongAward = 2, szText=GetEditorString(15, 7626), bIsActiv = FALSE}, --��������
	[23] = {nTongAward = 4, szText=GetEditorString(15, 7627), bIsActiv = TRUE}, --��������
	[24] = {nTongAward = 4, szText=GetEditorString(15, 7628), bIsActiv = FALSE}, --��Դ��������
	[25] = {nTongAward = 1, szText=GetEditorString(15, 7629), bIsActiv = FALSE}, --�ݵ�ó�ף�ÿ�����Σ�
	--[26] = {nTongAward = 4, szText="Э���ع�����������ɽ��·������Ӱ��ͬ��ֵ��", bIsActiv = TRUE}, --��ɽ��·
	--[27] = {nTongAward = 27, szText="Э���ع�����������Ӫ�������������Ӱ��ͬ��ֵ��", bIsActiv = TRUE}, --��Ӫ��������
	[28] = {nTongAward = 4, szText=GetEditorString(15, 7630), bIsActiv = FALSE}, --����ǰ��
	[29] = {nTongAward = 8, szText=GetEditorString(15, 7631), bIsActiv = TRUE}, --��¹��ԭ
	[30] = {nTongAward = 8, szText=GetEditorString(15, 7632), bIsActiv = TRUE}, --��Ӫ����ս
	[31] = {nTongAward = 6, szText=GetEditorString(15, 7633), bIsActiv = FALSE}, --ս��ʤ��
	[32] = {nTongAward = 2, szText=GetEditorString(15, 7634), bIsActiv = FALSE}, --�������ʤ��
	[33] = {nTongAward = 6, szText=GetEditorString(15, 7635), bIsActiv = FALSE}, --���ž���������ǰʮ��
	--[34] = {nTongAward = , szText="", bIsActiv = FALSE}, --��ɹ��򲢽���ǰ50%
	--[35] = {nTongAward = , szText="", bIsActiv = FALSE}, --Ұ�����
	[36] = {nTongAward = 6, szText=GetEditorString(15, 7636), bIsActiv = FALSE}, --mobaս��ʤ��
	--[37] = {nTongAward = , szText="", bIsActiv = FALSE}, --��ɱ�ֺͲɼ�doodad������
}
local nMaxDis = 32 * 64

-- ����Ƿ��ͬ�������ڸ���
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
	if player.bNewFarmerFlag then --ɸ��������
		return
	end
	local tplayerlist = player.GetPartyMemberList() --��ö����е���
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
	--��ҼӸ��˰��ķ�
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

	--���ع����ʣ����Լӵ�ͬ��ֵ��������centerȥ�Ӱ���
	local buff_WeeklyLimit = player.GetBuff(16421, 1)
	local nWeeklyLimit = 160 - buff_WeeklyLimit.nCustomValue --������160
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

-- ����Ƿ��ͬ��������ͬ��ͼ
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
	if player.bNewFarmerFlag then --ɸ��������
		return
	end
	if not player.IsInParty() then
		return
	end
	local tplayerlist = player.GetPartyMemberList() --��ö����е���
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

	--�ع���Һ�����ͬ����ѼӸ��˰��ķ�
	--��ҼӸ��˰��ķ�
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

	--���ع����ʣ����Լӵ�ͬ��ֵ��������centerȥ�Ӱ���
	local buff_WeeklyLimit = player.GetBuff(16421, 1)
	local nWeeklyLimit = 160 - buff_WeeklyLimit.nCustomValue --��ʱ��ֵ���ǵø�
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

-- ����ǰ��ǰ���ϵ
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
	if player.bNewFarmerFlag then --ɸ��������
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

-- ����淨����ʱ���Ӱ�����ֱ�ǣ��лع���ҵļӱ�ǣ���ʤʱ��ͬ���Ļ��ڲ��ڣ�ͬ���Э���߼ӱ�ǣ���ʤʱ���������˻��ڲ���
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
	local buff_Huigui = player.GetBuff(16400, 1) -- �ع���
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

-- ����淨������ͼʱ���ӻ��ֽ�����ͳ�ƺ󷢸�centerͳһ�ӣ�
function SendTongAwardInTongInfo(player)
	if not IsActivityOn(568) then
		return
	end
	if player.bNewFarmerFlag then --ɸ��������
		return
	end
	if tBFMapList[player.GetMapID()] then		--�������ս��
		return
	end
	-- ����Ҫ��֮ǰ�ı��buff���ǵ�ɾ��������������һ�¹�ϵ��Ȼ���һ�¸�helper�Ľ��������ɾ��
	local buff_Helper = player.GetBuff(16401, 1)
	local buff_Huigui = player.GetBuff(16400, 1)
	if not (buff_Helper or buff_Huigui)then
		player.DelBuff(16400, 1)
		player.DelBuff(16401, 1)
		return
	end
	--local dwHuiguiID = buff_Helper.dwSkillSrcID  --Ӧ�ò��������ж��ˣ�ֻҪ����buff�����ģ��Ϳ��Կ�ʼ��������
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
		local nWeeklyLimit = 160 - buff_WeeklyLimit.nCustomValue --��ʱ��ֵ���ǵø�
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

--�����¼Ǽ�log
local tClientIP = {
	["113.106.106.98" ] = true, --"��˾���ų���"
	["113.106.106.99" ] = true, --"��˾���ų���"
	["113.106.106.117"] = true, --"��˾���ų���"
	["221.4.212.137"  ] = true, --"��˾��ͨ����"
	["221.4.212.138"  ] = true, --"��˾��ͨ����"
	["221.4.212.139"  ] = true,  --"��˾��ͨ����"
	["182.139.133.135"] = true,  --"�ɶ���˾���ų���"
	["221.10.5.90"    ] = true,  --"�ɶ���˾��ͨ����"
	["221.10.5.89"    ] = true,  --"�ɶ���˾��ͨ����"
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
	--print("��¼log" .. szLog .. "��¼���ID" .. dwTongID)
end