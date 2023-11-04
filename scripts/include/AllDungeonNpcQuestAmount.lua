---------------------------------------------------------------------->
-- 脚本名称:	scripts/Include/AllDungeonNpcQuestAmount.lua
-- 更新时间:	2021/7/14 14:24:30
-- 更新用户:	KING-20190116LV
-- 脚本说明:	
----------------------------------------------------------------------<
Include("scripts/Map/Act_运营活动通用/iclude/活动组抄作业用.lua")
Include("scripts/Map/世界通用/include/DLC副本信息.lh")
Include("scripts/Map/世界通用/include/活力精力回复_data.lh")
Include("scripts/Map/个人进度/个人进度_data.lua")
Include("scripts/Map/Act_运营活动通用/iclude/BattlePass代币头文件.lua")
Include("scripts/Tong/include/HuiGuiActivityAwardList.lua")
Include("scripts/Map/新大侠之路/include/大侠之路完成任务触发.lua")
Include("scripts/Map/Act_运营活动通用/iclude/江湖行记头文件.lua")
Include("scripts/Map/帮会领地/include/加帮会资金data.lua")
Include("scripts/Map/Act_运营活动通用/iclude/BattlePass代币头文件_书契.lua")
local tDlc5RandGroup = {{19199, 14211}, {19265, 14211}, {19622, 14211}}	--5人DLC周常的随机任务组{firstQust,npcID}

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

tWeeklyMapQuest = {--num代表boss数量
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
local nZhuZhan_Rate_book = 18	--4个一共0.00018
local nTeaRoll = 0
local nExpRoll = 0
local nBookRoll = 0

-----单刷模式npc的位置 索引为地图ID 子表为x，y，x，ndir，必填
tNpcCreate = {
	[26] = {18200, 3514, 1113920, 235},			--荻花前山		
	[28] = {44592, 17623, 1063936, 129},			--日轮山城		
	[33] = {31100, 54185, 1076288, 21},			--天子峰
	[34] = {36542, 20013, 1047296, 58},			--风雨稻香村
	[36] = {21002, 4081, 1049536, 194},			--英雄天地三才阵	
	[37] = {8030, 3101, 1051136, 185},			--英雄天工坊	
	[40] = {18200, 3514, 1113920, 235},			--英雄荻花前山		
	[41] = {20714, 7251, 1057280, 193},			--英雄无盐岛
	[42] = {31100, 54185, 1076288, 21},			--英雄天子峰
	[43] = {6952, 4237, 1113920, 155},			--英雄空雾峰
	[44] = {27080, 15365, 1062784, 192},			--英雄日轮山城		
	[45] = {33099, 6971, 1048896, 152},			--英雄灵霄峡		
	[47] = {38103, 34954, 1063872, 131},			--英雄风雨稻香村		
	[62] = {16232, 32206, 1080512, 205},			--英雄剑冢		
	[111] = {13558, 9858, 1074240, 101},			--英雄仙踪林
	[112] = {9038, 5906, 1058752, 134},			--英雄毒神殿
	[113] = {2619, 16530, 1055040, 175},			--英雄寂灭厅
	[114] = {28788, 5497, 1051776, 126},			--英雄无量山
	[115] = {4595, 3608, 1091968, 92},  			--英雄法王窟
	[125] = {12271, 11212, 1091200, 138},  		--唐门密室
	[141] = {15277, 31464, 1207744, 0},			--光明顶隧道
	[157] = {9549, 8693, 1079296, 175},			--英雄一线天
	[162] = {32804, 19424, 1048896, 1},			--英雄华清宫
	[163] = {46117, 36594, 1048576, 127},			--华清宫回忆录
	[170] = {24030, 16558, 1055168, 1},			--英雄琉璃岛
	[179] = {5392, 31358, 1050624, 71},			--直城门
	[184] = {32071, 28924, 1131008, 251},		--墨家秘殿
	[187] = {61644, 34376, 1050624, 67},		--春明门
	[195] = {38421, 16841, 1081024, 11},		--雁门关之役
	[200] = {29908, 22758, 1119040, 127},		--璨翠海厅
	[224] = {9089, 27560, 1088960, 73},			--英雄天泣林	
	[225] = {9160, 2492, 1048704, 118},			--英雄微山书院
	[227] = {26917, 3023, 1051392, 20},			--英雄阴山圣泉
	[228] = {4916, 7386, 1062848, 83},			--英雄梵空禅院
	[229] = {8223, 25974, 1051584, 125},			--英雄引仙水榭
	[242] = {20168, 4402, 1065280, 124},			--白帝水宫
	[257] = {6185, 4304, 1164864, 250},			--英雄夕颜阁
	[262] = {25034, 2135, 1754944, 13},			--刀轮海厅
	[285] = {5445, 53373, 1063552, 60},		--银雾湖
	[292] = {29227, 22684, 1047552, 194},		--英雄稻香秘事
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
						--赛季初师徒加速活动
						if IsActivityOn(538) and player.IsHaveBuff(15318, 0) and not tRaid10Putong[scene.dwMapID] then
							player.AddJustice(13, "DLCShitu")
							player.SendSystemMessage(GetEditorString(22, 7717))
						end
						player.AddVigor(tVigorAddValue.DlcQuest10, "DLCQuest")
					elseif bWeeklyQuest and player.GetQuestValue(nQuestIndex, k) == 0 then
						player.AddJustice(260, "DLCQuest")
						--赛季初师徒加速活动
						if IsActivityOn(538) and player.IsHaveBuff(15318, 0) and not tRaid10Putong[scene.dwMapID] then
							player.AddJustice(13, "DLCShitu")
							player.SendSystemMessage(GetEditorString(22, 7717))
						end
						--BattlePass活动
						if IsActivityOn(556) then
							BattlePass_SendReward(player, 4, GetEditorString(15, 1980), false)
						end
						if IsActivityOn(894) then
							BattlePass_SendReward_ShuQi(player, 4, GetEditorString(15, 1980), false)
						end

						--江湖行记
						TravelNotes_AddEXP(player, 22)
						--帮会回归活动（10人DLC）
						CheckTongMemberNearby(player, 19)
						--帮会资金
						ActiveAddTongFondIndex(player, 6, "RaidBoss10")						
						player.AddVigor(tVigorAddValue.DlcQuest10, "DLCQuest")
					elseif bDailyQuest and player.GetQuestValue(nQuestIndex, k) == 0 then
						player.AddJustice(160, "DLCQuest")
						player.AddMoney(50, 0, 0, "DLCQuest")
						--赛季初师徒加速活动
						if IsActivityOn(538) and player.IsHaveBuff(15318, 0) and not tRaid10Putong[scene.dwMapID] then
							player.AddJustice(8, "DLCShitu")
							player.SendSystemMessage(GetEditorString(22, 7717))
						end
						player.AddVigor(tVigorAddValue.DlcQuest5, "DLCQuest")
						--BattlePass活动
						if IsActivityOn(556) then
							BattlePass_SendReward(player, 2, GetEditorString(15, 1980), false)
						end
						if IsActivityOn(894) then
							BattlePass_SendReward_ShuQi(player, 2, GetEditorString(15, 1980), false)
						end
						--江湖行记
						TravelNotes_AddEXP(player, 21)
						--帮会回归活动（5人DLC）
						CheckTongMemberNearby(player, 18)
						--帮会资金
						ActiveAddTongFondIndex(player, 5, "RaidBoss5")						
						--5人增加迟来的钦佩奖励
						if player.CanAddItem(ITEM_TABLE_TYPE.OTHER, 31379, 1) == ADD_ITEM_RESULT_CODE.SUCCESS then
							player.AddItem(ITEM_TABLE_TYPE.OTHER, 31379, 1)
						else
							local szMessage_Login = player.szName .. GetEditorString(14, 4792)
							SendSystemMail(GetEditorString(7, 7878), player.szName, GetEditorString(7, 7934), szMessage_Login, 0, ITEM_TABLE_TYPE.OTHER, 31379, 1)
							player.SendSystemMessage(GetEditorString(14, 4918))
						end
						--5人增加锡制宝箱奖励
						if player.CanAddItem(ITEM_TABLE_TYPE.OTHER, 6254, 1) == ADD_ITEM_RESULT_CODE.SUCCESS then
							player.AddItem(ITEM_TABLE_TYPE.OTHER, 6254, 1)
						else
							local szMessage_Login = player.szName .. GetEditorString(14, 4792)
							SendSystemMail(GetEditorString(7, 7878), player.szName, GetEditorString(7, 7934), szMessage_Login, 0, ITEM_TABLE_TYPE.OTHER, 6254, 1)
							player.SendSystemMessage(GetEditorString(14, 4919))
						end
						--5人增加助战道具掉落
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
	--当前场景是随机到的任务场景才给宝箱
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
	--击杀DLC10人最终BOSS的log
	Log(GetEditorString(14, 3126) .. GetEditorString(14, 3173) .. scene.dwMapID .. "\t" .. GetEditorString(14, 3174) .. scene.nCopyIndex .. "\t" .. GetEditorString(14, 3175) .. npc.dwTemplateID .. "\t" .. GetEditorString(14, 3176) .. npc.szName)
	if bAward then
		local playerlist = scene.GetAllPlayer()
		if not playerlist then
			return
		end
		for i = 1, #playerlist do
			--大侠之路周常任务接入
			local dwSubModuleID = 6
			local player = GetPlayer(playerlist[i])
			On_DaXiaZhiLu_XinFinishQuest(player, dwSubModuleID)
		end
		--击杀本周DLC10人最终BOSS的log
		Log(GetEditorString(14, 3127) .. GetEditorString(14, 3173) .. scene.dwMapID .. "\t" .. GetEditorString(14, 3174) .. scene.nCopyIndex .. "\t" .. GetEditorString(14, 3175) .. npc.dwTemplateID .. "\t" .. GetEditorString(14, 3176) .. npc.szName)
		local npcBX = scene.GetNpcByNickName("DLCRaidChest")
		if npcBX then
			npcBX.CopyDropTarget(npc.dwID)
			local x, y, z = npcBX.GetCustomInteger4(0), npcBX.GetCustomInteger4(4), npcBX.GetCustomInteger4(8)
			npcBX.SetPosition(x, y, z)
			--DLC宝箱LOG
			Log(GetEditorString(14, 3125) .. GetEditorString(14, 3173) .. scene.dwMapID .. "\t" .. GetEditorString(14, 3174) .. scene.nCopyIndex .. "\t" .. GetEditorString(14, 3175) .. npc.dwTemplateID .. "\t" .. GetEditorString(14, 3176) .. npc.szName .. "\t" .. GetEditorString(14, 3177) .. npcBX.dwDropTargetPlayerID)
			npcBX.Die()
		end

	end
end

--检查是否是5人DLC周常本
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
			scene.CreateNpc(69469, value[1], value[2], value[3], value[4], - 1, "9627Tools")			---工具人
		end
	end
end
