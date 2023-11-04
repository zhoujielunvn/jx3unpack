---------------------------------------------------------------------->
-- �ű�����:	scripts/Include/AllDungeonNpcQuestAmount.lua
-- ����ʱ��:	2021/7/14 14:24:30
-- �����û�:	KING-20190116LV
-- �ű�˵��:	
----------------------------------------------------------------------<
Include("scripts/Map/Act_��Ӫ�ͨ��/iclude/��鳭��ҵ��.lua")
Include("scripts/Map/����ͨ��/include/DLC������Ϣ.lh")
Include("scripts/Map/����ͨ��/include/���������ظ�_data.lh")
Include("scripts/Map/���˽���/���˽���_data.lua")
Include("scripts/Map/Act_��Ӫ�ͨ��/iclude/BattlePass����ͷ�ļ�.lua")
Include("scripts/Tong/include/HuiGuiActivityAwardList.lua")
Include("scripts/Map/�´���֮·/include/����֮·������񴥷�.lua")
Include("scripts/Map/Act_��Ӫ�ͨ��/iclude/�����м�ͷ�ļ�.lua")
Include("scripts/Map/������/include/�Ӱ���ʽ�data.lua")
Include("scripts/Map/Act_��Ӫ�ͨ��/iclude/BattlePass����ͷ�ļ�_����.lua")
local tDlc5RandGroup = {{19199, 14211}, {19265, 14211}, {19622, 14211}}	--5��DLC�ܳ������������{firstQust,npcID}

tDailyMapQuestID = {
	[45] = 19199,
	[37] = 19243,
	[41] = 19244,
	[43] = 19245,
	[36] = 19246,
	[26] = 19247,
	[40] = 19262,
	[28] = 19248,
	[44] = 19250,
	[33] = 19251,
	[42] = 19252,
	[34] = 19253,
	[47] = 19254,
	[62] = 19264,
	[111] = 19265,
	[112] = 19266,
	[115] = 19267,
	[113] = 19268,
	[114] = 19269,
	[125] = 19270,
	[141] = 19271,
	[157] = 19272,
	[162] = 19273,
	[163] = 19274,
	[170] = 19255,
	[179] = 19256,
	[184] = 19257,
	[187] = 19258,
	[195] = 19259,
	[200] = 19260,
	[224] = 19261,
	[227] = 19263,
	[228] = 19616,
	[229] = 19617,
	[225] = 19618,
	[242] = 19619,
	[257] = 19620,
	[262] = 19621,
	[285] = 19622,
	[292] = 19623,
	[359] = 22943,
	[356] = 22944,
	[357] = 22945,
	[355] = 22946,
	[343] = 22947,
	[432] = 22948,
	[406] = 22949,
	[469] = 25439,
	[478] = 25441,
	[480] = 25442,
	[481] = 25443,
	[490] = 25444,
	[521] = 25445,
	[564] = 25446,
}

tWeeklyMapQuest = {--num����boss����
	[32] = {ID = 19219, NUM = 7},
	[60] = {ID = 19220, NUM = 1},
	[61] = {ID = 19661, NUM = 1},
	[67] = {ID = 19276, NUM = 4},
	[68] = {ID = 19277, NUM = 8},
	[109] = {ID = 19278, NUM = 2},
	[120] = {ID = 19279, NUM = 1},
	[131] = {ID = 19280, NUM = 2},
	[134] = {ID = 19281, NUM = 7},
	[136] = {ID = 19282, NUM = 2},
	[140] = {ID = 19283, NUM = 5},
	[160] = {ID = 19284, NUM = 5},
	[164] = {ID = 19285, NUM = 7},
	[175] = {ID = 19286, NUM = 8},
	[177] = {ID = 19287, NUM = 4},
	[182] = {ID = 19288, NUM = 5},
	[191] = {ID = 19289, NUM = 3},
	[192] = {ID = 19290, NUM = 4},
	[220] = {ID = 19291, NUM = 5},
	[221] = {ID = 19292, NUM = 3},
	[240] = {ID = 19293, NUM = 5},
	[241] = {ID = 19294, NUM = 3},
	[263] = {ID = 19295, NUM = 5},
	[264] = {ID = 19296, NUM = 3},
	[283] = {ID = 19297, NUM = 5},
	[284] = {ID = 19298, NUM = 3},
	[298] = {ID = 19299, NUM = 5},
	[299] = {ID = 19300, NUM = 3},
	[341] = {ID = 19662, NUM = 5},
	[347] = {ID = 20221, NUM = 1},
	[364] = {ID = 20147, NUM = 6},
	[368] = {ID = 20596, NUM = 1},
	[426] = {ID = 20595, NUM = 6},
	[452] = {ID = 21697, NUM = 5},
	[482] = {ID = 22938, NUM = 6},
	[518] = {ID = 23642, NUM = 7},
	[559] = {ID = 24150, NUM = 6},
	[573] = {ID = 24700, NUM = 5},
	[586] = {ID = 25447, NUM = 6},
	[636] = {ID = 25854, NUM = 6},
	[648] = {ID = 26346, NUM = 6},
}

tNewMapQuestID =
{
	--[341] = 19662,
}

tOldWeaponMapQuestID = {
	[20294] = 34,
	[20295] = 34,
	[20296] = 28,
	[20297] = 28,
	[20298] = 26,
	[20299] = 47,
	[20300] = 42,
	[20302] = 44,
	[20303] = 40,
}

local nZhuZHan_Rate_Tea = 89	--0.0089
local nZhuZHan_Rate_Exp = 44	--0.0044
local nZhuZhan_Rate_book = 18	--4��һ��0.00018
local nTeaRoll = 0
local nExpRoll = 0
local nBookRoll = 0

-----��ˢģʽnpc��λ�� ����Ϊ��ͼID �ӱ�Ϊx��y��x��ndir������
tNpcCreate = {
	[26] = {18200, 3514, 1113920, 235},			--ݶ��ǰɽ		
	[28] = {44592, 17623, 1063936, 129},			--����ɽ��		
	[33] = {31100, 54185, 1076288, 21},			--���ӷ�
	[34] = {36542, 20013, 1047296, 58},			--���굾���
	[36] = {21002, 4081, 1049536, 194},			--Ӣ�����������	
	[37] = {8030, 3101, 1051136, 185},			--Ӣ���칤��	
	[40] = {18200, 3514, 1113920, 235},			--Ӣ��ݶ��ǰɽ		
	[41] = {20714, 7251, 1057280, 193},			--Ӣ�����ε�
	[42] = {31100, 54185, 1076288, 21},			--Ӣ�����ӷ�
	[43] = {6952, 4237, 1113920, 155},			--Ӣ�ۿ����
	[44] = {27080, 15365, 1062784, 192},			--Ӣ������ɽ��		
	[45] = {33099, 6971, 1048896, 152},			--Ӣ������Ͽ		
	[47] = {38103, 34954, 1063872, 131},			--Ӣ�۷��굾���		
	[62] = {16232, 32206, 1080512, 205},			--Ӣ�۽�ڣ		
	[111] = {13558, 9858, 1074240, 101},			--Ӣ��������
	[112] = {9038, 5906, 1058752, 134},			--Ӣ�۶����
	[113] = {2619, 16530, 1055040, 175},			--Ӣ�ۼ�����
	[114] = {28788, 5497, 1051776, 126},			--Ӣ������ɽ
	[115] = {4595, 3608, 1091968, 92},  			--Ӣ�۷�����
	[125] = {12271, 11212, 1091200, 138},  		--��������
	[141] = {15277, 31464, 1207744, 0},			--���������
	[157] = {9549, 8693, 1079296, 175},			--Ӣ��һ����
	[162] = {32804, 19424, 1048896, 1},			--Ӣ�ۻ��幬
	[163] = {46117, 36594, 1048576, 127},			--���幬����¼
	[170] = {24030, 16558, 1055168, 1},			--Ӣ��������
	[179] = {5392, 31358, 1050624, 71},			--ֱ����
	[184] = {32071, 28924, 1131008, 251},		--ī���ص�
	[187] = {61644, 34376, 1050624, 67},		--������
	[195] = {38421, 16841, 1081024, 11},		--���Ź�֮��
	[200] = {29908, 22758, 1119040, 127},		--貴亣��
	[224] = {9089, 27560, 1088960, 73},			--Ӣ��������	
	[225] = {9160, 2492, 1048704, 118},			--Ӣ��΢ɽ��Ժ
	[227] = {26917, 3023, 1051392, 20},			--Ӣ����ɽʥȪ
	[228] = {4916, 7386, 1062848, 83},			--Ӣ�������Ժ
	[229] = {8223, 25974, 1051584, 125},			--Ӣ������ˮ�
	[242] = {20168, 4402, 1065280, 124},			--�׵�ˮ��
	[257] = {6185, 4304, 1164864, 250},			--Ӣ��Ϧ�ո�
	[262] = {25034, 2135, 1754944, 13},			--���ֺ���
	[285] = {5445, 53373, 1063552, 60},		--�����
	[292] = {29227, 22684, 1047552, 194},		--Ӣ�۵�������
}

function SetQuestParam(scene, k)
	local nQuestID = 0
	local bWeeklyQuest = false
	local bDailyQuest = false
	local bNewQuest = false
	local bAward = false
	if tDailyMapQuestID[scene.dwMapID] then
		bDailyQuest = true
		nQuestID = tDailyMapQuestID[scene.dwMapID]
	end
	if tWeeklyMapQuest[scene.dwMapID] then
		bWeeklyQuest = true
		nQuestID = tWeeklyMapQuest[scene.dwMapID].ID
	end
	if tNewMapQuestID[scene.dwMapID] then
		bNewQuest = true
		nQuestID = tNewMapQuestID[scene.dwMapID]
	end

	if nQuestID ~= 0 then
		local playerlist = scene.GetAllPlayer()
		if not playerlist then
			return 1
		end

		if bWeeklyQuest == true and k == tWeeklyMapQuest[scene.dwMapID].NUM - 1 then
			--[[
			local npcBX = scene.GetNpcByNickName("DLCRaidChest")
			if npcBX then
				for i = 1, #playerlist do
					local player = GetPlayer(playerlist[i])
					if player then
						npcBX.ModifyThreat(player.dwID, 10)
					end
				end
				local x, y, z = npcBX.GetCustomInteger4(0), npcBX.GetCustomInteger4(4), npcBX.GetCustomInteger4(8)
				npcBX.SetPosition(x, y, z)
				npcBX.Die()
			end
			--]]
		end

		for i = 1, #playerlist do
			local player = GetPlayer(playerlist[i])
			if player then
				local nQuestIndex = player.GetQuestIndex(nQuestID)
				local nQuestPhase = player.GetQuestPhase(nQuestID)
				if nQuestIndex and nQuestPhase == 1 then
					if bNewQuest and player.GetQuestValue(nQuestIndex, k) == 0 then
						player.AddJustice(260, "DLCQuest")
						--������ʦͽ���ٻ
						if IsActivityOn(538) and player.IsHaveBuff(15318, 0) and not tRaid10Putong[scene.dwMapID] then
							player.AddJustice(13, "DLCShitu")
							player.SendSystemMessage(GetEditorString(22, 7717))
						end
						player.AddVigor(tVigorAddValue.DlcQuest10, "DLCQuest")
					elseif bWeeklyQuest and player.GetQuestValue(nQuestIndex, k) == 0 then
						player.AddJustice(260, "DLCQuest")
						--������ʦͽ���ٻ
						if IsActivityOn(538) and player.IsHaveBuff(15318, 0) and not tRaid10Putong[scene.dwMapID] then
							player.AddJustice(13, "DLCShitu")
							player.SendSystemMessage(GetEditorString(22, 7717))
						end
						--BattlePass�
						if IsActivityOn(556) then
							BattlePass_SendReward(player, 4, GetEditorString(15, 1980), false)
						end
						if IsActivityOn(894) then
							BattlePass_SendReward_ShuQi(player, 4, GetEditorString(15, 1980), false)
						end

						--�����м�
						TravelNotes_AddEXP(player, 22)
						--���ع���10��DLC��
						CheckTongMemberNearby(player, 19)
						--����ʽ�
						ActiveAddTongFondIndex(player, 6, "RaidBoss10")						
						player.AddVigor(tVigorAddValue.DlcQuest10, "DLCQuest")
					elseif bDailyQuest and player.GetQuestValue(nQuestIndex, k) == 0 then
						player.AddJustice(160, "DLCQuest")
						player.AddMoney(50, 0, 0, "DLCQuest")
						--������ʦͽ���ٻ
						if IsActivityOn(538) and player.IsHaveBuff(15318, 0) and not tRaid10Putong[scene.dwMapID] then
							player.AddJustice(8, "DLCShitu")
							player.SendSystemMessage(GetEditorString(22, 7717))
						end
						player.AddVigor(tVigorAddValue.DlcQuest5, "DLCQuest")
						--BattlePass�
						if IsActivityOn(556) then
							BattlePass_SendReward(player, 2, GetEditorString(15, 1980), false)
						end
						if IsActivityOn(894) then
							BattlePass_SendReward_ShuQi(player, 2, GetEditorString(15, 1980), false)
						end
						--�����м�
						TravelNotes_AddEXP(player, 21)
						--���ع���5��DLC��
						CheckTongMemberNearby(player, 18)
						--����ʽ�
						ActiveAddTongFondIndex(player, 5, "RaidBoss5")						
						--5�����ӳ��������影��
						if player.CanAddItem(ITEM_TABLE_TYPE.OTHER, 31379, 1) == ADD_ITEM_RESULT_CODE.SUCCESS then
							player.AddItem(ITEM_TABLE_TYPE.OTHER, 31379, 1)
						else
							local szMessage_Login = player.szName .. GetEditorString(14, 4792)
							SendSystemMail(GetEditorString(7, 7878), player.szName, GetEditorString(7, 7934), szMessage_Login, 0, ITEM_TABLE_TYPE.OTHER, 31379, 1)
							player.SendSystemMessage(GetEditorString(14, 4918))
						end
						--5���������Ʊ��佱��
						if player.CanAddItem(ITEM_TABLE_TYPE.OTHER, 6254, 1) == ADD_ITEM_RESULT_CODE.SUCCESS then
							player.AddItem(ITEM_TABLE_TYPE.OTHER, 6254, 1)
						else
							local szMessage_Login = player.szName .. GetEditorString(14, 4792)
							SendSystemMail(GetEditorString(7, 7878), player.szName, GetEditorString(7, 7934), szMessage_Login, 0, ITEM_TABLE_TYPE.OTHER, 6254, 1)
							player.SendSystemMessage(GetEditorString(14, 4919))
						end
						--5��������ս���ߵ���
						nTeaRoll = Random(10000)
						nExpRoll = Random(10000)
						nBookRoll = Random(100000)
						local num_book = Random(7)
						local nZhuZhanItem = {
							[1] = {{5, 45839, 1}},
							[2] = {{5, 44430, 1}},
						}
						local nZhuZhan_book = {
							[1] = {{5, 45798, 1}},
							[2] = {{5, 45800, 1}},
							[3] = {{5, 45802, 1}},
							[4] = {{5, 45804, 1}},
							[5] = {{5, 50598, 1}},
							[6] = {{5, 45792, 1}},
							[7] = {{5, 53899, 1}},
						}
						if nTeaRoll ~= 0 and nTeaRoll <= nZhuZHan_Rate_Tea then
							Act_AddItem2(player, nZhuZhanItem[1], GetEditorString(23, 6229))
							RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_REWARD_GREEN", GetEditorString(23, 6227), 4)
						end
						if nExpRoll ~= 0 and nExpRoll <= nZhuZHan_Rate_Exp then
							Act_AddItem2(player, nZhuZhanItem[2], GetEditorString(23, 6229))
							RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_REWARD_GREEN", GetEditorString(23, 6227), 4)
						end
						if nBookRoll~= 0 and nBookRoll <= nZhuZhan_Rate_book then
							Act_AddItem2(player, nZhuZhan_book[num_book], GetEditorString(23, 6229))
							RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_REWARD_GREEN", GetEditorString(23, 6227), 4)
						end
					end
					player.SetQuestValue(nQuestIndex, k, 1)
					bAward = true
				end
			end
		end
	else
		print("No_Quest:" .. scene.dwMapID .. "No" .. k)
	end
	return bAward
end

function GoDLCChest(scene, npc)
	if not scene then
		return
	end
	--��ǰ����������������񳡾��Ÿ�����
	local bAward = false
	local tPlayerList = scene.GetAllPlayer()
	if #tPlayerList >= 1 then
		local player = GetPlayer(tPlayerList[1])
		if player then
			local _, nQuestID1 = player.RandomByDailyQuest(tDLCGroupToFirstQuest[621], tDLCGroupToNpc[621])
			local _, nQuestID2 = player.RandomByDailyQuest(tDLCGroupToFirstQuest[626], tDLCGroupToNpc[626])
			local _, nQuestID3 = player.RandomByDailyQuest(tDLCGroupToFirstQuest[655], tDLCGroupToNpc[655])
			if scene.dwMapID == tDLCQuestToAcceptMap[nQuestID1] or scene.dwMapID == tDLCQuestToAcceptMap[nQuestID2] or scene.dwMapID == tDLCQuestToAcceptMap[nQuestID3] then
				bAward = true
			end
			Log(GetEditorString(14, 9594) .. GetEditorString(14, 3284) .. tostring(tPlayerList[1]) .. "\t" .. GetEditorString(14, 9595) .. tostring(nQuestID1) .. "\t" .. GetEditorString(14, 9596) .. tostring(nQuestID2) .. "\t" .. GetEditorString(14, 9597) .. tostring(nQuestID3))
		end
	end
	--��ɱDLC10������BOSS��log
	Log(GetEditorString(14, 3126) .. GetEditorString(14, 3173) .. scene.dwMapID .. "\t" .. GetEditorString(14, 3174) .. scene.nCopyIndex .. "\t" .. GetEditorString(14, 3175) .. npc.dwTemplateID .. "\t" .. GetEditorString(14, 3176) .. npc.szName)
	if bAward then
		local playerlist = scene.GetAllPlayer()
		if not playerlist then
			return
		end
		for i = 1, #playerlist do
			--����֮·�ܳ��������
			local dwSubModuleID = 6
			local player = GetPlayer(playerlist[i])
			On_DaXiaZhiLu_XinFinishQuest(player, dwSubModuleID)
		end
		--��ɱ����DLC10������BOSS��log
		Log(GetEditorString(14, 3127) .. GetEditorString(14, 3173) .. scene.dwMapID .. "\t" .. GetEditorString(14, 3174) .. scene.nCopyIndex .. "\t" .. GetEditorString(14, 3175) .. npc.dwTemplateID .. "\t" .. GetEditorString(14, 3176) .. npc.szName)
		local npcBX = scene.GetNpcByNickName("DLCRaidChest")
		if npcBX then
			npcBX.CopyDropTarget(npc.dwID)
			local x, y, z = npcBX.GetCustomInteger4(0), npcBX.GetCustomInteger4(4), npcBX.GetCustomInteger4(8)
			npcBX.SetPosition(x, y, z)
			--DLC����LOG
			Log(GetEditorString(14, 3125) .. GetEditorString(14, 3173) .. scene.dwMapID .. "\t" .. GetEditorString(14, 3174) .. scene.nCopyIndex .. "\t" .. GetEditorString(14, 3175) .. npc.dwTemplateID .. "\t" .. GetEditorString(14, 3176) .. npc.szName .. "\t" .. GetEditorString(14, 3177) .. npcBX.dwDropTargetPlayerID)
			npcBX.Die()
		end

	end
end

--����Ƿ���5��DLC�ܳ���
function CheckIf5pDlcMap(dwMapID, player)
	local bInDlc5Map = false
	if not tDailyMapQuestID[dwMapID] then
		return false
	end
	for k, v in pairs(tDlc5RandGroup) do
		local _, nQuestID = player.RandomByDailyQuest(v[1], v[2])

		if tDailyMapQuestID[dwMapID] == nQuestID then
			bInDlc5Map = true
			break
		end
	end

	return bInDlc5Map
end

function CompleteOldWeapon(scene, nQuestID, k)
	if tOldWeaponMapQuestID[nQuestID] ~= scene.dwMapID then
		return
	end
	if nQuestID ~= 0 then
		local playerlist = scene.GetAllPlayer()
		if not playerlist then
			return 1
		end
		for i = 1, #playerlist do
			local player = GetPlayer(playerlist[i])
			local nQuestIndex = player.GetQuestIndex(nQuestID)
			local nQuestPhase = player.GetQuestPhase(nQuestID)
			if nQuestIndex and nQuestPhase == 1 then
				if player.GetQuestValue(nQuestIndex, k) == 0 then
					player.SetQuestValue(nQuestIndex, k, 1)
				end
			end
		end
	end
end

function InitializingNpc(scene)
	for key, value in pairs(tNpcCreate) do
		if key == scene.dwMapID then
			scene.CreateNpc(69462, value[1], value[2], value[3], value[4], - 1, "RushModeNPC")		---9527
			scene.CreateNpc(69469, value[1], value[2], value[3], value[4], - 1, "9627Tools")			---������
		end
	end
end
