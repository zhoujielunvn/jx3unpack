---------------------------------------------------------------------->
-- 脚本名称:	scripts/MiniGame/Mahjong/xueliuchenghe/xueliuchengheTableMgr.lua
-- 更新时间:	2020/3/27 15:21:23
-- 更新用户:	KING-20200219SB
-- 脚本说明:	
----------------------------------------------------------------------<
Include("scripts/MiniGame/Mahjong/xueliuchenghe/xueliuchenghePlayerMgr.lua")
Include("scripts/MiniGame/Mahjong/xueliuchenghe/xueliuchengheCards.lua")
Include("scripts/MiniGame/Mahjong/xueliuchenghe/IdentityCustomValueName.lua")
Include("scripts/Map/世界奇遇/兔江湖/include/兔江湖_data.lua")
Include("scripts/Include/CustomFunction.lua")

--[[
OFFSET = 0
CURPTR = 1
GANG = 2
ABANDON = 3
tMemCardsPtr = {
	[OFFSET] = 0,
	[CURPTR] = 0,
	[GANG] = 0,
	[ABANDON] = 0,
}
tMemAllCards = {}

CHAIRMAN = 0
CUR_PLAYER = 1
CUR_PLAYER_STATE = 2
TABLE_MGR_STATE = 3
LAST_GANG_PLAYER = 4
ALL_PLAYER_CASH_FLOW = 5
tMemPlayerData = {
	[CHAIRMAN] = 0,
	[CUR_PLAYER] = 0,
	[CUR_PLAYER_STATE] = 0,
	[TABLE_MGR_STATE] = 0,
	[LAST_GANG_PLAYER] = 0,
	[ALL_PLAYER_CASH_FLOW] = {}
}
tMemAllPlayer = {}
function MemAddPlayer(id)
	tMemAllPlayer[id] = id
end

STATE = 0
EXCHANGE_CARD = 1
LACK = 2
OPERATE_MASK = 3
DATA_IN_HAND = 4
BONUS_TABLE = 5
HU_RECORD = 6
TING_LIST = 7
LAST_CARD = 8
CUR_OPERATE_CARD = 9
tMemPlayerCards = {
	[1] = {
		[STATE] = 0, --是否第一张摸牌,是否锁牌，是否托管
		[EXCHANGE_CARD] = {},
		[LACK] = 2,
		[OPERATE_MASK] = 0,
		[DATA_IN_HAND] = {
			[0x01] = 0, [0x02] = 0, [0x03] = 0, [0x04] = 0, [0x05] = 0, [0x06] = 0, [0x07] = 0, [0x08] = 0, [0x09] = 0,
			[0x11] = 0, [0x12] = 0, [0x13] = 0, [0x14] = 0, [0x15] = 0, [0x16] = 0, [0x17] = 0, [0x18] = 0, [0x19] = 0,
			[0x21] = 0, [0x22] = 0, [0x23] = 0, [0x24] = 0, [0x25] = 0, [0x26] = 0, [0x27] = 0, [0x28] = 0, [0x29] = 0,
		},
		[BONUS_TABLE] = {}, --最大4个
		[HU_RECORD] = {}, --9莲宝灯比较多
		[TING_LIST] = {}, --最多9个
		[LAST_CARD] = 0, --刚摸上来的牌
	},
	[2] = {
		[STATE] = 0, --是否第一张摸牌,是否锁牌，是否托管
		[EXCHANGE_CARD] = {},
		[LACK] = 2,
		[OPERATE_MASK] = 0,
		[DATA_IN_HAND] = {
			[0x01] = 0, [0x02] = 0, [0x03] = 0, [0x04] = 0, [0x05] = 0, [0x06] = 0, [0x07] = 0, [0x08] = 0, [0x09] = 0,
			[0x11] = 0, [0x12] = 0, [0x13] = 0, [0x14] = 0, [0x15] = 0, [0x16] = 0, [0x17] = 0, [0x18] = 0, [0x19] = 0,
			[0x21] = 0, [0x22] = 0, [0x23] = 0, [0x24] = 0, [0x25] = 0, [0x26] = 0, [0x27] = 0, [0x28] = 0, [0x29] = 0,
		},
		[BONUS_TABLE] = {},
		[HU_RECORD] = {},
		[TING_LIST] = {},
		[LAST_CARD] = 0, --刚摸上来的牌
	},
	[3] = {
		[STATE] = 0, --是否第一张摸牌,是否锁牌，是否托管
		[EXCHANGE_CARD] = {},
		[LACK] = 1,
		[OPERATE_MASK] = 0,
		[DATA_IN_HAND] = {
			[0x01] = 0, [0x02] = 0, [0x03] = 0, [0x04] = 0, [0x05] = 0, [0x06] = 0, [0x07] = 0, [0x08] = 0, [0x09] = 0,
			[0x11] = 0, [0x12] = 0, [0x13] = 0, [0x14] = 0, [0x15] = 0, [0x16] = 0, [0x17] = 0, [0x18] = 0, [0x19] = 0,
			[0x21] = 0, [0x22] = 0, [0x23] = 0, [0x24] = 0, [0x25] = 0, [0x26] = 0, [0x27] = 0, [0x28] = 0, [0x29] = 0,
		},
		[BONUS_TABLE] = {},
		[HU_RECORD] = {},
		[TING_LIST] = {},
		[LAST_CARD] = 0, --刚摸上来的牌
	},
	[4] = {
		[STATE] = 0, --是否第一张摸牌,是否锁牌，是否托管
		[EXCHANGE_CARD] = {},
		[LACK] = 0,
		[OPERATE_MASK] = 0,
		[DATA_IN_HAND] = {
			[0x01] = 0, [0x02] = 0, [0x03] = 0, [0x04] = 0, [0x05] = 0, [0x06] = 0, [0x07] = 0, [0x08] = 0, [0x09] = 0,
			[0x11] = 0, [0x12] = 0, [0x13] = 0, [0x14] = 0, [0x15] = 0, [0x16] = 0, [0x17] = 0, [0x18] = 0, [0x19] = 0,
			[0x21] = 0, [0x22] = 0, [0x23] = 0, [0x24] = 0, [0x25] = 0, [0x26] = 0, [0x27] = 0, [0x28] = 0, [0x29] = 0,
		},
		[BONUS_TABLE] = {},
		[HU_RECORD] = {},
		[TING_LIST] = {},
		[LAST_CARD] = 0, --刚摸上来的牌
	},
	[CUR_OPERATE_CARD] = 0,
}
--]]
--[[
CONST_TABLE_STATE_WAIT_CS_SEND = 0;
CONST_PLAYER_STATE_WAIT_OPERATE = 1;
function SendAndSetTableMgrState(state)
	tMemPlayerData[TABLE_MGR_STATE] = state
end

function GetTableMgrState()
	return tMemPlayerData[TABLE_MGR_STATE]
end
--]]

--[[
1.总对局数（历史的不算当前进行的这一把，每把打完才加）- int
2.胜率：（赢钱就算胜，不以结算收益为准） - 计算出来
3.最高连胜（玩家对局中间连胜局数，同样以胡过1次即为胜）
4.历史胜局数（同理胡过1次即为胜）
5.最大番数（即胡牌时结算的倍数）
6.最大番型（即胡牌时最大的牌型，例如碰碰胡，平湖这种）

连胜：
是否处于连胜状态 - byte 1
当前连胜场数 - short 2
历史最高连胜场数 - short 2

胜率：
总对局数 - int 4
总胜场数 - int 4

历史最大番数 - int 4
历史最大番型 - byte 1

隐藏分 - int 4
雀神点数 - int 4
--]]

local miniGameMgr1 = GetMiniGameMgr()
local homeMgr = GetHomelandMgr()

--[[	
function CalcHideScore(hideScore, deltaW)
	return hideScore + deltaW
end

function CalcHideScoreDeltaW(K, W, We)
	return K * (W - We)
end

function CalcHideScoreWe(DeltaAB)
	local scoreWe = 0
	if DeltaAB > 0 then
		if DeltaAB <= 3 then
			scoreWe = 50
		elseif DeltaAB <= 735 then
			scoreWe = 3 * math.pow(DeltaAB, 3) / 100000000 - 1469 * math.pow(DeltaAB, 2) / 10000000 + 16 * DeltaAB / 100 + 49
		else
			scoreWe = 100
		end
	else
		if DeltaAB <= 3 then
			scoreWe = 50
		elseif DeltaAB <= 735 then
			scoreWe = -3 * math.pow(DeltaAB, 3) / 100000000 + 15 * math.pow(DeltaAB, 2) / 100000 - 161 * DeltaAB / 1000 + 51
		else
			scoreWe = 0
		end
	end
	return scoreWe / 100
end

function CalcHideScoreK(K0, S, L0)
	return K0 * S * L0 * 2
end

function CalcHideScoreK0(score)
	return math.min(math.max(130 - score / 20, 10), 30)
end

function CalcHideScoreL0(score, winResult)
	if winResult  == 0 then --失败方
		if score <= 1600 then
			return 0.4
		elseif score <= 1800 then
			return 0.5
		elseif score <= 2000 then
			return 0.6
		else
			return 0.8
		end
	else --胜利
		if score <= 1600 then
			return 0.8
		else
			return 0.6
		end
	end
end

function FixHideScoreL0(L0, winResult, winResultAll)
	if winResultAll == 1 then
		if winResult == 1 then
			return L0 * 1
		end
		return L0 * 0.67
	elseif winResultAll == 2 then
		return L0
	elseif winResultAll == 3 then
		if winResult == 1 then
			return L0 * 0.67
		end
		return L0 * 2
	else
		return 0
	end
end

function CalcPlayerHideScoreRank(score)
	return math.floor((score - 1000)/100)
end

function CalcCashHonorWeight(rank)
	if rank <= 6 then
		return 1.4 + rank / 1500
	elseif rank <= 8 then
		return 1.8 + (rank - 6) / 750
	elseif rank <= 10 then
		return 2.067 + (rank - 8) / 500
	else
		return 2.467 + (rank - 10) / 300
	end
end
--]]
-- 胡牌对应的成就ID
local tHuAch = {
	[0] = 0,
	[1] = 7909,
	[2] = 7908,
	[3] = 7907,
	[4] = 7906,
	[5] = 7905,
	[6] = 7904,
	[7] = 7903,
	[8] = 7902,
	[9] = 7901,
	[10] = 7900,
	[11] = 7899,
	[12] = 0,
	[13] = 0,	
}

function CalcCashHonorResult(inComeMulti, weight)
	return inComeMulti * weight
end

--CONST_HIDE_SCORE_MIN = 1000
function SettleAccounts()
	if GetNeedSettleAccounts() == 0 then
		return
	end
	SetNeedSettleAccounts(0)
	--[[
	local hideScoreAll = 0
	local playerHideScore = {0, 0, 0, 0}
	local playerHideScoreRank = {0, 0, 0, 0}
	local winResultAll = 0
	local winResults = {0, 0, 0, 0}
	local hideScoreDeltaAB = {0, 0, 0, 0}
	--]]
	for i = 1, CONST_PLAYER_MAX do
		local cashOri = GetPlayerCashOrigin(i)
		local cash = GetPlayerCash(i)
		if cash > cashOri then
			-- TODO: 玩家i胜场+1；玩家i当前连胜场+1，如果当前连胜场大于历史连胜场，写入历史
			local winCount = GetPlayerCurWinCount(i)
			SetPlayerCurWinCount(i, winCount + 1)
			if winCount + 1 > GetPlayerMaxWinCount(i) then
				SetPlayerMaxWinCount(i, winCount + 1)
			end
			SetPlayerWinCount(i, GetPlayerWinCount(i) + 1)
			--[[
			winResults[i] = 1
			winResultAll = winResultAll + 1
			--]]
		else
			--TODO: 通知GS：当前连胜场次清零
			SetPlayerCurWinCount(i, 0)
			--[[
			if cash == cashOri then
				winResults[i] = 1
				winResultAll = winResultAll + 1
			end
			--]]
		end
		--[[
		playerHideScore[i] = GetPlayerHideScore(i)
		playerHideScoreRank[i] = CalcPlayerHideScoreRank(playerHideScore[i])
		hideScoreAll = hideScoreAll + playerHideScore[i]
	--]]

		SetPlayerMatchCount(i, GetPlayerMatchCount(i) + 1)
		--------------法务意见：删除雀神点数--------------
		--local cashHonorAdd = CalcCashHonorResult(GetPlayerIncomeMulti(i), 3)
		--ModifyPlayerCashHonor(i, cashHonorAdd)
		--------------法务意见：删除雀神点数--------------
		--	SetPlayerCashHonor(i, cashHonorAdd)
		WritePlayerMahjongDatas(i)
	end

	--[[
	local averageHideScore = hideScoreAll / 4
	
	for i = 1, CONST_PLAYER_MAX do
		hideScoreDeltaAB[i] = (playerHideScore[i] - averageHideScore) * 4 / 3

		if WRITE_LOG then
			Log(string.format(" player: %d, hideScoreDeltaAB[i]: %f, playerHideScore[i]: %d, averageHideScore: %f, playerHideScoreRank[i]: %d, winResults[i]: %d, winResultAll: %d", i, hideScoreDeltaAB[i], playerHideScore[i], averageHideScore, playerHideScoreRank[i], winResults[i], winResultAll))
		end
		
		SetPlayerMatchCount(i, GetPlayerMatchCount(i) + 1)

		---------------------隐藏分----------------------
		local K0 = CalcHideScoreK0(playerHideScore[i])
		local L0 = FixHideScoreL0(CalcHideScoreL0(playerHideScore[i], winResults[i]), winResults[i], winResultAll)
		local K = CalcHideScoreK(K0, 1, L0)

		local W = winResults[i]
		local We = CalcHideScoreWe(hideScoreDeltaAB[i])
				
		local deltaW = CalcHideScoreDeltaW(K, W, We)

		if WRITE_LOG then
			Log(string.format(" calcHideScore: player: %d, K0: %f, L0: %f, K: %f, W: %f, We: %f, deltaW: %f", i, K0, L0, K, W, We, deltaW))
		end
		
		SetPlayerHideScore(i, CalcHideScore(playerHideScore[i], deltaW)) 
		---------------------隐藏分----------------------

		--------------------雀神点数---------------------
		local cashHonorAdd = CalcCashHonorResult(GetPlayerIncomeMulti(i), CalcCashHonorWeight(playerHideScoreRank[i]))
		if WRITE_LOG then
			Log(string.format(" CalcCashHonorResult: player: %d, GetPlayerIncomeMulti(i): %d, weight: %f", i, GetPlayerIncomeMulti(i), CalcCashHonorWeight(playerHideScoreRank[i])))
		end
		SetPlayerCashHonor(i, cashHonorAdd)
		--------------------雀神点数---------------------
		--TODO: 雀神点数
		--TODO: 通知GS：场次+1 cash cashHonor hideScore 最大番数 最大番型
		--TODO: 玩家 玩家i场次+1
		WritePlayerMahjongDatas(i)
	end
	--]]
	SetPlayerOperateCount(-1, 1) --给次数，下一局摇色子
end

function OnMiniGameEndGame()
	if WRITE_LOG then
		Log(GetEditorString(16, 6367))
	end
	SettleAccounts()
	SendAndSetTableMgrState(CONST_TABLE_STATE_KILL_MAHJONG)
end

function OnMiniGameCreate(nPlayerCount, nValue)
	SendAndSetTableMgrState(CONST_TABLE_STATE_INIT)
	SetCashBase(nValue)
	SetTimer(CONST_TABLE_STATE_INIT, - 1, 0)
	if DEBUG_FOR_YALI_TEST then
		Log(GetEditorString(16, 9861))
	end
	return true
end

function ResetMem()
	--TODO: 重置内存数据
	miniGameMgr1.ClearData()
--	MgrClearData()
end

function startGame(nPlayerID)
	local result = homeMgr.StartMiniGame(1, CONST_PLAYER_MAX, nPlayerID, nPlayerID, nPlayerID, nPlayerID)
end

-- 
function SetTimer(nTimeID, nPlayerID, modifyTime)
	local time = 0
	local timeStamp = 0
	if nTimeID > 0 then
		time = CONST_COUNT_DOWN_TIME[nTimeID]
	end
	if time <= 0 then
		if WRITE_LOG then
			Log(GetEditorString(16, 6010))
		end
		miniGameMgr1.SetTimer()
--		MgrSetTimer()
		timeStamp = SetCountDownTime(0, 0, -1)
	else
		if WRITE_LOG then
			--	Log("**** 开启定时器 " .. nTimeID .. " | " .. nPlayerID .. " | " .. tostring(is5Sec) .. " ****")
			Log(string.format(GetEditorString(17, 623), nTimeID, nPlayerID))
		end
		if nPlayerID > 0 and nPlayerID < 5 then
			if GetPlayerIsAgent(nPlayerID)  == 1 then --挂机状态强行设置时间为5s
				time = CONST_COUNT_DOWN_TIME[CONST_TABLE_STATE_WAIT_CS_SEND_AGENT]
				if nTimeID == CONST_TABLE_STATE_WAIT_CS_SEND then --跳过SEND状态：由于SEND1状态要用作玩家操作超时计数（大于2进入托管状态），所以加一个Agent状态（非真实tableMgr状态，计时器标识）
					nTimeID = CONST_TABLE_STATE_WAIT_CS_SEND_AGENT
					if GetPlayerIsLockTing(nPlayerID)  == 1 then
						time = 1
					end
				elseif nTimeID == CONST_TABLE_STATE_WAIT_OPERATE then
					if WRITE_LOG then
						Log(string.format(" nTimeID == CONST_TABLE_STATE_WAIT_OPERATE: playerID: %d", nPlayerID))
					end
					if GetPlayerIsLockTing(nPlayerID)  == 1 then
						time = CONST_COUNT_DOWN_TIME[CONST_TABLE_STATE_WAIT_OPERATE_LOCKTING]
					end
				end
			end
		end
		if modifyTime > 0 then -- checkOperateMaskForAll等全员操作时，如果只有挂机玩家，强制时间为5s
			time = modifyTime --CONST_COUNT_DOWN_TIME[CONST_TABLE_STATE_WAIT_CS_SEND_AGENT]
		end
		if nTimeID == CONST_TABLE_STATE_WAIT_CS_SEND_AGENT or nTimeID == CONST_TABLE_STATE_WAIT_CS_SEND_1
			or nTimeID == CONST_TABLE_STATE_WAIT_OPERATE or nTimeID == CONST_TABLE_STATE_WAIT_OPERATE_COMBO
			or nTimeID == CONST_TABLE_STATE_WAIT_CS_SEND then
			time = time + 1 -- 挂机出牌和出牌状态、第一轮倒计时，时间增加1s，for网络延迟
		end
		
		miniGameMgr1.SetTimer(time, nTimeID, nPlayerID)
--		MgrSetTimer(time, nTimeID, nPlayerID)
--		if nTimeID == CONST_TABLE_STATE_WAIT_CS_SEND_AGENT then --恢复状态，避免影响客户端
--			nTimeID = CONST_TABLE_STATE_WAIT_CS_SEND
--		end
		timeStamp = SetCountDownTime(time, nTimeID, nPlayerID)
		if WRITE_LOG then
			--	Log(tostring("设置倒计时：timeStamp: " .. timeStamp .. " time：" .. time .. " nTimeID: " .. nTimeID .. " nPlayerID: " .. nPlayerID))
			Log(string.format(GetEditorString(17, 111), timeStamp, time, nTimeID, nPlayerID))
		end
	end
	SendMsg2Client(-1, PLAYER_OPERATE_TIME, nPlayerID, timeStamp, nTimeID)
end

function StealCardFor13(allCards, nPlayerIndex, color, count)
	local index = (nPlayerIndex - 1) * 13 + 1

	if WRITE_LOG then
		Log(string.format("beforeSteal13: nPlyerIndex: %d, cards: %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x",
			nPlayerIndex, allCards[index], allCards[index + 1], allCards[index + 2], allCards[index + 3],
			allCards[index + 4], allCards[index + 5], allCards[index + 6], allCards[index + 7],
			allCards[index + 8], allCards[index + 9], allCards[index + 10], allCards[index + 11], allCards[index + 12]
		))
	end
	
	local outCard = {}
	local outIndex = 1
	for i = index, index + 12 do
		if not (GetColorFromCard(allCards[i]) == color) then
			outCard[outIndex] = i
			outIndex = outIndex + 1
			if outIndex > count then
				break
			end
		end
	end

	index = (CONST_PLAYER_MAX - 1) * 13 + 1
	local inCard = {}
	local inIndex = 1
	for i = index, CONST_CARDS_NUM do
		if GetColorFromCard(allCards[i]) == color then
			if inIndex > #outCard then
				break
			end
			inCard[inIndex] = i
			inIndex = inIndex + 1
		end
	end

	local temp
	for i = 1, #outCard do
		temp = allCards[outCard[i]]
		allCards[outCard[i]] = allCards[inCard[i]]
		allCards[inCard[i]] = temp
	end

	index = (nPlayerIndex - 1) * 13 + 1
	ShuffleSubCards(allCards, index, 13)
	if WRITE_LOG then
		Log(string.format("beforeSteal13: nPlyerIndex: %d, cards: %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x",
			nPlayerIndex, allCards[index], allCards[index + 1], allCards[index + 2], allCards[index + 3],
			allCards[index + 4], allCards[index + 5], allCards[index + 6], allCards[index + 7],
			allCards[index + 8], allCards[index + 9], allCards[index + 10], allCards[index + 11], allCards[index + 12]
		))
	end
end

--确认玩家手上最多的花色和张数
function CalcMaxColorCount(allCards, nPlayerIndex)
	local index = (nPlayerIndex - 1) * 13 + 1
	local colorCount = {[0] = 0, [1] = 0, [2] = 0}
	local color = 0
	if WRITE_LOG then
		Log(string.format("CalcMaxColorCount: nPlayerIndex: %d, index: %d, cardsLenth: %d", nPlayerIndex, index, #allCards))
	end
	for i = index, index + 12 do
		color = GetColorFromCard(allCards[i])
		colorCount[color] = colorCount[color] + 1
	end
	local maxCount = 0
	local maxColor = 0
	for i = 0, 2 do
		if maxCount < colorCount[i] then
			maxCount = colorCount[i]
			maxColor = i
		end
	end
	return maxCount + maxColor * 0x10
end

--确定玩家需要替换的张数
function GetPlayerLuckyNum(nPlayerIndex, maxColor, maxCount)
	local num = math.random(0, 10)
	local fate = math.random(1, 100)
	if fate > 70 then
		if num > 8 then --9/10
			num = 4
		elseif num > 5 then --6/7/8
			num = 3
		elseif num > 1 then --2/3/4/5
			num = 2
		else				 --0/1
			num = 1 
		end

		if maxCount > 8 then
			num = num % 3 --最多换两张
		end
	else
		if num > 9 then --10
			num = 3
		elseif num > 5 then --6/7/8/9
			num = 2
		elseif num > 1 then --2/3/4/5
			num = 1
		else				 --0/1
			num = 0
		end

		if maxCount > 7 then
			num = 0 --num % 2 --不换牌
		end
	end
	return num + maxColor * 0x10
end

--逆天改命，给玩家更好的牌
function RandomPlayerFortune(allCards)
	local color = 0
	local count = 0
	local temp = 0
	for i = 1, CONST_PLAYER_MAX do
		temp = CalcMaxColorCount(allCards, i)
		color = math.floor(temp / 0x10)
		count = temp % 0x10
		if WRITE_LOG then
			Log(string.format("CalcMaxColorCount result: nPlyerIndex: %d, color: %d, count: %d", i, color, count))
		end

		temp = GetPlayerLuckyNum(i, color, count)
		color = math.floor(temp / 0x10)
		count = temp % 0x10
		if WRITE_LOG then
			Log(string.format("GetPlayerLuckyNum result: nPlyerIndex: %d, color: %d, count: %d", i, color, count))
		end

		if count > 0 then
			StealCardFor13(allCards, i, color, count)
		end
	end
end

function ShuffleCardsAndSend13Cards()
	local allCards = Shuffle()
	if WRITE_LOG then
		for k, v in pairs(allCards) do
			--	Log(tostring("ShuffleCards: k: " .. k .. " v: " .. string.format("%#x", v)))
			Log(string.format("befor fortune ShuffleCards: k: %d, v: %#x", k, v))
		end
	end
	--[[
	SetAllCards(allCards, 13*4)
	StealCardGuanxing(0, 0x05)
	allCards = GetAllCards()
	if WRITE_LOG then
		for k, v in pairs(allCards) do
		--	Log(tostring("ShuffleCards: k: " .. k .. " v: " .. string.format("%#x", v)))
			Log(string.format("befor fortune ShuffleCards 0x05: k: %d, v: %#x", k, v))
		end
	end
	SetAllCards(allCards, 13*4)
	StealCardGuanxing(1, 0x13)
	allCards = GetAllCards()
	if WRITE_LOG then
		for k, v in pairs(allCards) do
		--	Log(tostring("ShuffleCards: k: " .. k .. " v: " .. string.format("%#x", v)))
			Log(string.format("befor fortune ShuffleCards 0x13: k: %d, v: %#x", k, v))
		end
	end
	--]]
	if not NO_SHUFFLE then
		RandomPlayerFortune(allCards)
	end
	SetAllCards(allCards, 13*4)
	if WRITE_LOG then
		for k, v in pairs(allCards) do
			--	Log(tostring("ShuffleCards: k: " .. k .. " v: " .. string.format("%#x", v)))
			Log(string.format("ShuffleCards: k: %d, v: %#x", k, v))
		end
	end

	local hand = {
		[0x01] = 0, [0x02] = 0, [0x03] = 0, [0x04] = 0, [0x05] = 0, [0x06] = 0, [0x07] = 0, [0x08] = 0, [0x09] = 0,
		[0x11] = 0, [0x12] = 0, [0x13] = 0, [0x14] = 0, [0x15] = 0, [0x16] = 0, [0x17] = 0, [0x18] = 0, [0x19] = 0,
		[0x21] = 0, [0x22] = 0, [0x23] = 0, [0x24] = 0, [0x25] = 0, [0x26] = 0, [0x27] = 0, [0x28] = 0, [0x29] = 0,
	}
	local ptr = 0
	local chairMan = GetChairMan()
	for i = 1, CONST_PLAYER_MAX do
		--	local card = Get13Card()
		if not(i == 1) then
			for k,v in pairs(hand) do
				hand[k] = 0
			end
		end
		if i == chairMan then
			hand[allCards[13 * 4 + 1]] = hand[allCards[13 * 4 + 1]] + 1 --庄家第14张牌
		end
		for j = 1, 13 do
			hand[allCards[j + ptr]] = hand[allCards[j + ptr]] + 1
		end
		SetPlayerHand(i, hand)
		ptr = ptr + 13
		if WRITE_LOG then
			Log(string.format(GetEditorString(17, 319), i))
		end
		PreExchange(i, hand)
	end

	SetCurCardPtr(13 * 4 + 1)
	if DEBUG_MAHJONG then
		for i = 1, CONST_PLAYER_MAX do
			PeepHand(i)
--			SetPlayerDebugPeepHand(i)
		end
	end
end

function ShuffleCards()
	local allCards = Shuffle()
	SetAllCards(allCards, 0)
	if WRITE_LOG then
		for k, v in pairs(allCards) do
			--	Log(tostring("ShuffleCards: k: " .. k .. " v: " .. string.format("%#x", v)))
			Log(string.format("ShuffleCards: k: %d, v: %#x", k, v))
		end
	end
	if WRITE_LOG then
		PrintChatMsg(GetEditorString(16, 3998))
	end
--	for i = 1, CONST_PLAYER_MAX do
	--tMemPlayerCards[i][LAST_CARD] = 0;
	--tMemPlayerCards[i][HU_RECORD] = {}
--	end
--[[	
	tMemCardsPtr[OFFSET] = 0
	tMemCardsPtr[CURPTR] = 0
	tMemCardsPtr[GANG] = 0
	tMemCardsPtr[ABANDON] = 0
--]]
--	GetPlayer(PlayerID).SendSystemMessage("洗牌啦")
end

--[[
function SetPlayerData(index, data)
	tMemPlayerData[index] = data
end

function GetPlayerData()
	
end
--]]

--initialed = false
function InitPlayerData()
	
end

function SavePlayerData()
	
end

function InitTableMgr()
--	SendAndSetTableMgrState(CONST_TABLE_STATE_INIT)
--	local bRetCode = SetTimer(CONST_TABLE_STATE_INIT, -1) --TODO: 这个是特殊的，回头改掉

	local aliveData = GetPlayerAliveAll()
	for i = 1, CONST_PLAYER_MAX do
		if aliveData[i] == 0 then
			SendMsg2Client(-1, PLAYER_OPERATE_ERROR, -1, ERROR_CODE_PLAYER_INACTIVE_WHEN_INIT, 0)
			return false --有人已经认输
		end
	end

	local chairMan = GetChairMan()
	local firstFireInLast = GetFirstFire()
	local firstWinnerInLast = GetFirstWinner()
--	local playerCash = {}
	local cashBase = GetCashBase()
	
	ResetMem()
	for i = 1, CONST_PLAYER_MAX do
		ReadPlayerMahjongDatas(i)
	end
							
	--TODO:calc Next chairMan
	if WRITE_LOG then
		Log(string.format(GetEditorString(17, 112), firstFireInLast, firstWinnerInLast, chairMan))
	end
	if firstFireInLast > 0 then
		chairMan = firstFireInLast
	elseif firstWinnerInLast > 0 then
		chairMan = firstWinnerInLast
	else
		chairMan = chairMan + 1
		if chairMan > 4 then
			chairMan = chairMan - 4
		end
	end
	if WRITE_LOG then
		Log(string.format(GetEditorString(17, 112), firstFireInLast, firstWinnerInLast, chairMan))
	end
	ClearPlayerLack()
	SetChairMan(chairMan)
	SetCurOperatePlayer(chairMan)
	SendMsg2Client(-1, PLAYER_OPERATE_SET_CHAIRMAN, chairMan, 0, 0)
	
	local diceNum = Dice()
	SetDiceNum(diceNum)
	local aliveData = {1, 1, 1, 1}
	SetPlayerAliveAll(aliveData)
	SendMsg2Client( - 1, PLAYER_OPERATE_DICE, diceNum, 0, 0)

	--TODO:设置底分和玩家现金
--	for i = 1, CONST_PLAYER_MAX do
--		SetPlayerCash(i, playerCash[i])
--	end
	SetCashBase(cashBase)
	if WRITE_LOG then
		Log(string.format(GetEditorString(17, 113), GetCashBase()))
	end
	SetNeedSettleAccounts(1)
	
	--TODO:换牌/抓牌顺序判定
	ShuffleCardsAndSend13Cards()
--	ShuffleCards()
--	SetPlayerData(CUR_PLAYER, 1)
--	SetCurOperatePlayer(1)
--	SetPlayerData(CHAIRMAN, 1)
--	tMemPlayerData[CUR_PLAYER] = 1
--	tMemPlayerData[CHAIRMAN] = 1
--	ClearTable()
--	Send13Cards()
--	PreExchange()
	SendAndSetTableMgrState(CONST_TABLE_STATE_EXCHANGE)
	SetTimer(CONST_TABLE_STATE_EXCHANGE, -1, 0)
	--TODO:换牌倒计时

	for i = 1, 4 do
		--SetPlayerIsAgent(i, 1)
	end
	if WRITE_LOG then
		for i = 1, 4 do
			local data = GetPlayerHandPure(i)
			Log(string.format("----------- i: %d -----------", i))
			for k, v in pairs(data) do
				Log(string.format(" v: %d", v))
			end
			Log("--------------------------")
		end
	end
	
	return true
end

--[[
function ClearTable()
	for i = 1, CONST_PLAYER_MAX do
		for color = 0x00, 0x20, 0x10 do
			for card = color + 0x01, color + 0x09 do
				tMemPlayerCards[i][DATA_IN_HAND][card] = 0
			end
		end
		tMemPlayerCards[i][EXCHANGE_CARD] = {}
		tMemPlayerCards[i][BONUS_TABLE] = {}
		tMemPlayerCards[i][HU_RECORD] = {}
		tMemPlayerCards[i][TING_LIST] = {}
		tMemPlayerCards[i][LAST_CARD] = 0
	end
end
--]]

--function Send13Cards()
--	for i = 1, CONST_PLAYER_MAX do
--		for j = (i - 1) * 13 + 1, i * 13 do
--			print("i: " .. i .. " j: " .. j .. " card: " .. string.format("%#x", tMemAllCards[j]))
--			tMemPlayerCards[i][DATA_IN_HAND][tMemAllCards[j]] = tMemPlayerCards[i][DATA_IN_HAND][tMemAllCards[j]] + 1
--		end
--	end
--
--	tMemPlayerCards[tMemPlayerData[CHAIRMAN]][DATA_IN_HAND][tMemAllCards[13 * 4 + 1]] = tMemPlayerCards[tMemPlayerData[CHAIRMAN]][DATA_IN_HAND][tMemAllCards[13 * 4 + 1]] + 1
--	tMemCardsPtr[CURPTR] = 13 * 4 + 2
--
--	for i = 1, CONST_PLAYER_MAX do
--		PrintPlayerHands(i)
--	end
--	--TODO: 庄家换完牌要查一下碰杠胡mask
--	tMemPlayerCards[tMemPlayerData[CHAIRMAN]][OPERATE_MASK] = CheckOperateMaskForSingle(tMemPlayerData[CHAIRMAN], tMemPlayerData[CHAIRMAN], false)
--end

function Send13Cards()
--	temp = GetAllCards()
	for i = 1, CONST_PLAYER_MAX do
		local hand = {
			[0x01] = 0, [0x02] = 0, [0x03] = 0, [0x04] = 0, [0x05] = 0, [0x06] = 0, [0x07] = 0, [0x08] = 0, [0x09] = 0,
			[0x11] = 0, [0x12] = 0, [0x13] = 0, [0x14] = 0, [0x15] = 0, [0x16] = 0, [0x17] = 0, [0x18] = 0, [0x19] = 0,
			[0x21] = 0, [0x22] = 0, [0x23] = 0, [0x24] = 0, [0x25] = 0, [0x26] = 0, [0x27] = 0, [0x28] = 0, [0x29] = 0,
		}
		local card = Get13Card()
		
		for j = 1, 13 do
			hand[card[j]] = hand[card[j]] + 1
		end
		SetPlayerHand(i, hand)
	end
	local nextCard = GetNextCard()
	local chairMan = GetChairMan()
	local chairManHand = GetPlayerHand(chairMan)
	if WRITE_LOG then
		PrintPlayerHands(chairMan)
	end
	chairManHand[nextCard] = chairManHand[nextCard] + 1
	SetPlayerHand(chairMan, chairManHand)
	if DEBUG_MAHJONG then
		for i = 1, CONST_PLAYER_MAX do
			PeepHand(i)
--			SetPlayerDebugPeepHand(i)
		end
	end
end

function PrintPlayerHands(nPlayerIndex)
	if WRITE_LOG then
		--	Log(tostring("PlayerHand: id: " .. nPlayerIndex .. StringPlayerHands(nPlayerIndex)))
		Log(string.format("PlayerHand: id: %d, %s", nPlayerIndex, StringPlayerHands(nPlayerIndex)))
	end
end

function StringPlayerHands(nPlayerIndex)
	local stringHand = " hands:"
	local handCards = GetPlayerHand(nPlayerIndex)
	for color = 0x00, 0x20, 0x10 do
		for card = color + 0x01, color + 0x09 do
			if handCards[card] > 0 then
				--	stringHand = stringHand .. string.format("%#x", card) .. ":" .. handCards[card] .. ";"
				stringHand = string.format("%s %#x : %d", stringHand, card, handCards[card])
			end
		end
	end
	return stringHand
end
--[[
PLAYER_OPERATE_PENG = 0
PLAYER_OPERATE_MING_GANG = 1
PLAYER_OPERATE_AN_GANG = 2
PLAYER_OPERATE_HU = 3
PLAYER_OPERATE_JUMP = 4
--]]

--[[
PLAYER_OPERATE_JUMP = 0;
PLAYER_OPERATE_PENG = 1;
PLAYER_OPERATE_MING_GANG = 2;
PLAYER_OPERATE_HU = 3;
--]]
--check是否可以操作，如果可以，直接响应；否则，记录消息，开始计时

--出牌后，check所有玩家对当前出牌的操作（过滤exceptPlayerIndex）
function CheckOperateMaskForAll(exceptPlayerIndex)
	local anyOneNeedOperate = false
	local curPlayer = GetCurOperatePlayer()
	local card = GetCurOperateCard()
	for playerIndex = 1, CONST_PLAYER_MAX do
		local maskData = {}
		local gangData = {}
		local result = 0
		if not (playerIndex == exceptPlayerIndex) then
			result = CheckOperateMaskForSingle(playerIndex, curPlayer, true, maskData, gangData)
			if result > 0 then
				anyOneNeedOperate = true
			end
		end
		SetPlayerOperateMask(playerIndex, maskData, true)
		SetPlayerGangOperate(playerIndex, gangData)
		SendMsg2Client(playerIndex, PLAYER_OPERATE_SYN_OPERATE_MASK, result, card, 0)
	end

	return anyOneNeedOperate
end

function CheckOperateMaskForSingle(playerIndex, cardPlayerIndex, onlyCurCard, maskData, gangData)
	local result = 0
	if GetPlayerAlive(playerIndex) == 0 then
		return result
	end
	
	local analysisTable = {
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0
	}
	local isLockTing = GetPlayerIsLockTing(playerIndex)
	local playerHand = GetPlayerHand(playerIndex)
	local bonusTable = GetPlayerBonus(playerIndex)
	local curOperateCard = GetCurOperateCard()
	local lack = GetPlayerLack(playerIndex)
	local tingList = GetPlayerTingList(playerIndex)
	if WRITE_LOG then
		PrintPlayerHands(playerIndex)
	end
	
--	if #tMemPlayerCards[playerIndex][HU_RECORD] == 0 and CheckPeng(tMemPlayerCards[playerIndex][DATA_IN_HAND], tMemPlayerCards[CUR_OPERATE_CARD], playerIndex, cardPlayerIndex) then
	if isLockTing == 0 and CheckPeng(playerHand, curOperateCard, lack, playerIndex, cardPlayerIndex) then
		-- mask Peng
--		result = SetFlagN(result, PLAYER_OPERATE_PENG)
--		result = SetFlagN(result, PLAYER_OPERATE_JUMP)
		result = 1
		maskData[PLAYER_OPERATE_PENG] = 1
--		maskData[PLAYER_OPERATE_JUMP] = 1
--		GetPlayer(PlayerID).SendSystemMessage("玩家:" .. playerIndex .. "可以碰" .. string.format("%#x", curOperateCard))
		--	PrintChatMsg("玩家:" .. playerIndex .. "可以碰" .. string.format("%#x", curOperateCard))
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 114), playerIndex, curOperateCard))
		end
	end
	--checkGang
	local gangType = -1
	local resultTable = {}
	local resultTableReal = {}
	if onlyCurCard then
		gangType = CheckGangSingleCard(resultTable, playerHand, curOperateCard, bonusTable, lack, playerIndex, cardPlayerIndex)
		gangType = DoubleCheckGangSingleCard(resultTableReal, playerHand, resultTable, gangType, curOperateCard, bonusTable, isLockTing, lack, tingList)
	else
		gangType = CheckGang(resultTable, playerHand, curOperateCard, bonusTable, lack, playerIndex, cardPlayerIndex)
		gangType = DoubleCheckGang(resultTableReal, playerHand, resultTable, bonusTable, isLockTing, lack, tingList)
		if gangType == 0 then
			gangType = -1
		else
			gangType = PLAYER_OPERATE_MING_GANG
		end
	end
	if not (gangType == -1) then
		-- mask Gang
--		result = SetFlagN(result, PLAYER_OPERATE_MING_GANG)
--		result = SetFlagN(result, PLAYER_OPERATE_JUMP)
		result = 1
		maskData[PLAYER_OPERATE_MING_GANG] = 1
--		maskData[PLAYER_OPERATE_JUMP] = 1
--		GetPlayer(PlayerID).SendSystemMessage("玩家:" .. playerIndex .. "可以杠" .. string.format("%#x", curOperateCard))
	end

	if	CheckHu(playerHand, lack, curOperateCard, bonusTable, analysisTable) == 1 then
		-- mask Hu
--		result = SetFlagN(result, PLAYER_OPERATE_HU)
--		result = SetFlagN(result, PLAYER_OPERATE_JUMP)
		result = 1
		maskData[PLAYER_OPERATE_HU] = 1
--		maskData[PLAYER_OPERATE_JUMP] = 1
--		GetPlayer(PlayerID).SendSystemMessage("玩家:" .. playerIndex .. "可以胡" .. string.format("%#x", curOperateCard))
		--	PrintChatMsg("玩家:" .. playerIndex .. "可以胡" .. string.format("%#x", curOperateCard))
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 115), playerIndex, curOperateCard))
		end
	end
	if result > 0 then
		maskData[PLAYER_OPERATE_JUMP] = 1
	end
	--[[
	local count = 1
	for k, v in pairs(resultTableReal) do
		print("resultTableReal: k: " .. k .. " v: " .. v)
		if not (v == 0) then
			gangData[count] = v
			count = count + 1
		end
	end
	--]]
	if WRITE_LOG then
		for k, v in pairs(resultTable) do
			--	PrintChatMsg("玩家:" .. playerIndex .. " resultTable可以杠" .. string.format("%#x", k))
			PrintChatMsg(string.format(GetEditorString(17, 116), playerIndex, k))
		end
	end
	for k, v in pairs(resultTableReal) do
		gangData[k] = v
		--	PrintChatMsg("玩家:" .. playerIndex .. "可以杠" .. string.format("%#x", k))
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 117), playerIndex, k))
		end
	end
--	return mask
	return result
end

CONST_CHECK_OPERATE_CODE_FAIL = -1
CONST_CHECK_OPERATE_CODE_SEND_STEAL = 0
CONST_CHECK_OPERATE_CODE_OPERATE_WAIT = 1
CONST_CHECK_OPERATE_CODE_OPERATE_NOW = 2
--TODO:改变操作牌的数据存储方式（k为牌值，v为操作），涉及bonusTable，gangTable
--check 打出的牌可操作性
function CheckCanOperate(playerIndex, nValue1, nValue2, saveOperateTable)
	if WRITE_LOG then
		--	Log(tostring("CheckCanOperate playerIndex: " .. playerIndex .. "操作：" .. nValue1 .. " card:" .. string.format("%#x", nValue2)))
		Log(string.format(GetEditorString(17, 118), playerIndex, nValue1, nValue2))
	end
	if not (nValue1 == PLAYER_OPERATE_JUMP or CheckLegalCardValue(nValue2)) then
		--	PrintChatMsg("牌值非法 playerIndex: " .. playerIndex .. "操作：" .. nValue1 .. " card:" .. string.format("%#x", nValue2))
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 119), playerIndex, nValue1, nValue2))
		end
		SendMsg2Client(playerIndex, PLAYER_OPERATE_ERROR, playerIndex, ERROR_CODE_PLAYER_CARD_VALUE_INLEGAL, nValue2)
		return CONST_CHECK_OPERATE_CODE_FAIL --cheat
	end
	
	local playerHand = GetPlayerHand(playerIndex)
	local playerMaskData = GetPlayerOperateMask(playerIndex)
	local tRecordMsg = GetPlayerOperateRecordAll()
	local tableMgrState = -1
	
	if nValue1 == PLAYER_OPERATE_CS_SEND then
		if GetPlayerIsLockTing(playerIndex) == 1 then
			return CONST_CHECK_OPERATE_CODE_FAIL
		end
		local curOperateCard = GetCurOperateCard()
		if not (curOperateCard == 0) then
			playerHand[curOperateCard] = playerHand[curOperateCard] + 1
		end
		if playerHand[nValue2] < 1 or playerHand[nValue2] > 4 then
			if WRITE_LOG then
				--	PrintChatMsg("非法出牌 没有这张牌 playerIndex: " .. playerIndex .. " card:" .. nValue2)
				PrintChatMsg(string.format(GetEditorString(17, 120), playerIndex, nValue2))
				PrintPlayerHands(playerIndex)
			end
			SendMsg2Client(playerIndex, PLAYER_OPERATE_ERROR, playerIndex, ERROR_CODE_PLAYER_CARD_NOT_EXIT_WHEN_CSSEND, nValue2)
			return CONST_CHECK_OPERATE_CODE_FAIL --cheat
		else
			local curOperatePlayer = GetCurOperatePlayer()
			tableMgrState = GetTableMgrState()
			if curOperatePlayer == playerIndex and (tableMgrState == CONST_TABLE_STATE_WAIT_CS_SEND or tableMgrState == CONST_TABLE_STATE_WAIT_CS_SEND_1 or tableMgrState == CONST_TABLE_STATE_WAIT_OPERATE) then
				return CONST_CHECK_OPERATE_CODE_SEND_STEAL
			end
			return CONST_CHECK_OPERATE_CODE_FAIL
		end
	end

	if nValue1 == PLAYER_OPERATE_STEAL_CARD then
		return CONST_CHECK_OPERATE_CODE_SEND_STEAL
	end

	tableMgrState = GetTableMgrState()
	
	if nValue1 == PLAYER_OPERATE_MING_GANG or nValue1 == PLAYER_OPERATE_AN_GANG or nValue1 == PLAYER_OPERATE_GANG_AFTER_PENG then
		if tableMgrState == CONST_TABLE_STATE_WAIT_OPERATE or tableMgrState == CONST_TABLE_STATE_WAIT_OPERATE_COMBO then
			local gangData = GetPlayerGangOperate(playerIndex)
			local matchGang = false
	
			for k, v in pairs(gangData) do
				if not (v == 0) then
					if v == nValue1 and k == nValue2 then
						matchGang = true
					end
				end
			end
	
			if not matchGang then
				if WRITE_LOG then
					--	PrintChatMsg("operate 非法操作 playerIndex:" .. playerIndex .. "不可以杠: type: " .. nValue1 .. " value: " .. nValue2)
					PrintChatMsg(string.format(GetEditorString(17, 121), playerIndex, nValue1, nValue2))
				end
				SendMsg2Client(playerIndex, PLAYER_OPERATE_ERROR, playerIndex, ERROR_CODE_PLAYER_CANOT_GANG, nValue2)
				return CONST_CHECK_OPERATE_CODE_FAIL
			end
		else
			return CONST_CHECK_OPERATE_CODE_FAIL
		end
	end
	
	if nValue1 == PLAYER_OPERATE_PENG or nValue1 == PLAYER_OPERATE_HU then
		if tableMgrState == CONST_TABLE_STATE_WAIT_OPERATE or tableMgrState == CONST_TABLE_STATE_WAIT_OPERATE_COMBO then
			if playerMaskData[nValue1] == 0 or (not (nValue2 == GetCurOperateCard())) then --碰杠胡非法操作
				if WRITE_LOG then
					--	PrintChatMsg("operate 非法操作 playerIndex:" .. playerIndex .. " operateType:" .. nValue1)
					PrintChatMsg(string.format(GetEditorString(17, 122), playerIndex, nValue1))
				end
				SendMsg2Client(playerIndex, PLAYER_OPERATE_ERROR, playerIndex, ERROR_CODE_PLAYER_MASK_is0_OR_STATE_WRONG, 0)
				return CONST_CHECK_OPERATE_CODE_FAIL --cheat
			end
		else
			return CONST_CHECK_OPERATE_CODE_FAIL
		end
	end
	
	if nValue1 == PLAYER_OPERATE_JUMP then
		if tableMgrState == CONST_TABLE_STATE_WAIT_OPERATE or tableMgrState == CONST_TABLE_STATE_WAIT_OPERATE_COMBO then
			if playerMaskData[nValue1] == 0 then
				return CONST_CHECK_OPERATE_CODE_FAIL
			end
		else
			return CONST_CHECK_OPERATE_CODE_FAIL
		end
	end

	if not (tRecordMsg[playerIndex] == nil) then --TODO:tRecordMsg
		if WRITE_LOG then
			PrintChatMsg(GetEditorString(16, 3107))
		end
		SendMsg2Client(playerIndex, PLAYER_OPERATE_ERROR, playerIndex, ERROR_CODE_PLAYER_DUPLICATE, 0)
		return CONST_CHECK_OPERATE_CODE_FAIL
	end

	--TODO:小于最高存储 - 弃     其他mask大于等于最高存储 - 等
	local highestOperate = nValue1 --目前已记录的最高操作
	for k, v in pairs(tRecordMsg) do --TODO:tRecordMsg
		if v[2] > highestOperate then
			highestOperate = v[2]
		end
	end

	if highestOperate > nValue1 then
		saveOperateTable[1] = false
	end
--	if highestOperate > nValue1 then
--		print("CheckCanOperate: 操作优先级较低")
--		return 1
--	end
	if WRITE_LOG then
		--	Log(tostring("**** highestOperate: " .. highestOperate .. " nValue1: " .. nValue1))
		Log(string.format("**** highestOperate: %d, nValue1: %d", highestOperate, nValue1))
	end
	for i = 1, CONST_PLAYER_MAX do --check是否有更高优先级的操作
		if (not (i == playerIndex)) and tRecordMsg[i] == nil then
			local otherMaskData = GetPlayerOperateMask(i)
			--TODO:if otherMaskData > highestOperate
			local otherMaskLevel = GetMaxValueInMaskData(otherMaskData)
			if WRITE_LOG then
				--	Log(tostring(" playerID: " .. i .. " otherMaskLevel: " .. otherMaskLevel))
				Log(string.format(" playerID: %d, otherMaskLevel: %d", i, otherMaskLevel))
			end
			if otherMaskLevel >= highestOperate and otherMaskLevel > 0 then
				return CONST_CHECK_OPERATE_CODE_OPERATE_WAIT --record then wait others
			end
		end
	end
--[[	
	local mask = SetFlagN(0, highestOperate)
	for i = 1, CONST_PLAYER_MAX do --check是否有更高优先级的操作
		if not (i == playerIndex) then
			if playerMask >= mask and tRecordMsg[i] == nil then --TODO:tRecordMsg
				return 1 --record then wait others
			end
		end
	end
--]]
	return CONST_CHECK_OPERATE_CODE_OPERATE_NOW --record then operate now
end

function GetMaxValueInMaskData(maskData)
	local result = -1
	for k, v in pairs(maskData) do
		if v > 0 and k > result then
			result = k
		end
	end
	return result
end

function SortHuRecordMsg(tRecordMsg, curPlayer)
	local scoreTable = {}
	local count = 0
	for k, v in pairs(tRecordMsg) do
		if v[2] == PLAYER_OPERATE_HU then
			count = count + 1
		end
	end

	if WRITE_LOG then
		--	Log(tostring(" SortHuRecordMsg: count: " .. count))
		Log(string.format(" SortHuRecordMsg: count: %d", count))
	end
	
	if count <= 1 then
		return nil
	end

	local curCardPtr = GetCurCardPtr()
	local scoreTableIndex = 1
	for k, v in pairs(tRecordMsg) do
		if v[2] == PLAYER_OPERATE_HU then
			
			--ServerOperate(v[1], v[2], v[3], huCashAll, huIndex * 8 + huCount * 2 + haveGang)
			local dataInhand = GetPlayerHand(v[1])
			local lack = GetPlayerLack(v[1])
			local bonusData = GetPlayerBonus(v[1])
			local isFirstCircle = false
			if GetPlayerIsFirstCircle(v[1]) == 1 then
				isFirstCircle = true
			end
			local analysisTable = {
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 0
			}
			if CheckHu(dataInhand, lack, v[3], bonusData, analysisTable) == 1 then
				CheckHuPlus(dataInhand, lack, v[3], bonusData, analysisTable, v[1], curPlayer, isFirstCircle, curCardPtr) --只为根据番数排序，后面的参数不用太精确
				scoreTable[scoreTableIndex] = {CalcHuCashScore(analysisTable), v[1]}
				scoreTableIndex = scoreTableIndex + 1
			end
		end
	end

	if WRITE_LOG then
		for k,v in pairs(scoreTable) do
			--	Log(tostring(" beforeSort scoreTable ===== k: " .. k .. " v[1](score): " .. v[1] .. " v[2](k): " .. v[2]))
			Log(string.format(" beforeSort scoreTable ===== k: %d, v[1](score): %d, v[2](k): %d", k, v[1], v[2]))
		end
	end
	
	local sortFunc = function (a, b)
		return a[1] > b[1]
	end
	
	table.sort(scoreTable, sortFunc)

	if WRITE_LOG then
		for k,v in pairs(scoreTable) do
			--	Log(tostring(" afterSort scoreTable ===== k: " .. k .. " v[1](score): " .. v[1] .. " v[2](k): " .. v[2]))
			Log(string.format(" afterSort scoreTable ===== k: %d, v[1](score): %d, v[2](k): %d", k, v[1], v[2]))
		end
	end
	
	local sortRecord = {}
	local score = 0
	local index = 0
	for k, v in pairs(scoreTable) do
		if not (score == v[1]) then
			score = v[1]
			index = index + 1
			sortRecord[index] = {}
		end

		table.insert(sortRecord[index], {v[1], v[2]})
	end

	if WRITE_LOG then
		for k, v in pairs(sortRecord) do
			for k1, v1 in pairs(v) do
				--	Log(tostring(" sortRecord ===== k: " .. k .. " v1[1](score): " .. v1[1] .. " v1[2](k): " .. v1[2]))
				Log(string.format(" sortRecord ===== k: %d, v1[1](score): %d, v1[2](k): %d", k, v1[1], v1[2]))
			end
		end
	end
	
	return sortRecord
end

--TODO: recordMsg存入C++空间
function RecordOperateMsg(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
	if WRITE_LOG then
		--	Log(tostring("RecordOperateMsg nPlayerIndexParam: " .. nPlayerIndex .. " nValue1Param: " .. nValue1 .. " nValue2Param: " .. nValue2 .. " nValue3Param: " .. nValue3 .. " nValue4Param: " .. nValue4))
		Log(string.format("RecordOperateMsg nPlayerIndexParam: %d, nValue1Param: %d, nValue2Param: %d, nValue3Param: %d, nValue4Param: %d", nPlayerIndex, nValue1, nValue2, nValue3, nValue4))
	end
--[[
	if tRecordMsg[nPlayerIndexParam] == nil then
		print("** record! **")
		tRecordMsg[nPlayerIndexParam] = {nPlayerIndex = nPlayerIndexParam, nValue1 = nValue1Param, nValue2 = nValue2Param, nValue3 = nValue3Param, nValue4 = nValue4Param}
	end
--]]
	SetPlayerOperateRecord(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
end

CONST_EXE_RESULT_JUMP = 1;
CONST_EXE_RESULT_PENG = 2;
CONST_EXE_RESULT_GANG = 3;
CONST_EXE_RESULT_HU = 4;

function ExecuteRecordMsg()
	local executLevel = CONST_EXE_RESULT_JUMP -- 1过 2碰 3杠 4胡
	local lastHuPlayer = -1
	local id = 0
	local curPlayer = GetCurOperatePlayer()
	local tRecordMsg = GetPlayerOperateRecordAll()
	if WRITE_LOG then
		for k, v in pairs(tRecordMsg) do
			--	Log(tostring("== tRecordMsg: k: " .. k .. " ==="))
			Log(string.format("== tRecordMsg: k: %d ===", k))
			--	Log(tostring(" ** v: nPlayerIndex:" .. v[1] .. " nValue1: " .. v[2] .. " nValue2: " .. v[3] .. " nValue3: " .. v[4] .. " nValue4: " .. v[5]))
			Log(string.format(" ** v: nPlayerIndex: %d, nValue1: %d, nValue2: %d, nValue3: %d, nValue4: %d,", v[1], v[2], v[3], v[4], v[5]))
		end
	end
--	for i = 0, 3 do
--		id = ((tMemPlayerData[CUR_PLAYER] + i - 1) % 4) + 1
	for i = 0, 3 do
		id = ((curPlayer + i - 1) % 4) + 1
		if WRITE_LOG then
			--	Log(tostring("=== i: " .. i .. " id: " .. id .. " tMemPlayerData[CUR_PLAYER]: " .. curPlayer .. " ==="))
			Log(string.format("=== i: %d, id: %d, tMemPlayerData[CUR_PLAYER]: %d ===", i, id, curPlayer))
		end
		if tRecordMsg[id] then
			if WRITE_LOG then
				--	Log(tostring("=== i: " .. i .. "id: " .. id .. " ==="))
				Log(string.format("=== i: %d, id: %d ===", i, id))
			end
			if tRecordMsg[id][2] == PLAYER_OPERATE_HU then
				lastHuPlayer = id
			end
			if tRecordMsg[id][2] == PLAYER_OPERATE_HU and executLevel < CONST_EXE_RESULT_HU then
				executLevel = CONST_EXE_RESULT_HU
			elseif tRecordMsg[id][2] == PLAYER_OPERATE_PENG and executLevel < CONST_EXE_RESULT_PENG then
				executLevel = CONST_EXE_RESULT_PENG
--				lastPlayer = -1
			elseif (tRecordMsg[id][2] == PLAYER_OPERATE_MING_GANG or tRecordMsg[id][2] == PLAYER_OPERATE_AN_GANG or tRecordMsg[id][2] == PLAYER_OPERATE_GANG_AFTER_PENG) and executLevel < CONST_EXE_RESULT_GANG then
				executLevel = CONST_EXE_RESULT_GANG
--				lastPlayer = -1
			elseif tRecordMsg[id][2] == PLAYER_OPERATE_JUMP and executLevel < CONST_EXE_RESULT_JUMP then
				executLevel = CONST_EXE_RESULT_JUMP
--				lastPlayer = nPlayerIndex
			end
		end
	end

	local huCount = 0
	local haveGang = 0
	for k, v in pairs(tRecordMsg) do
		if v[2] == PLAYER_OPERATE_MING_GANG or v[2] == PLAYER_OPERATE_AN_GANG or v[2] == PLAYER_OPERATE_GANG_AFTER_PENG then
			haveGang = 1
		elseif executLevel == CONST_EXE_RESULT_HU and v[2] == PLAYER_OPERATE_HU then
			huCount = huCount + 1
		end
	end
	local huIndex = 1
--	local huCashAll = 0
--	local huCashFlowRecordOff = 0
--	local tempHuPlayer = 0	
--	local cashOperatePlayer = 0
--	cashOperatePlayer = GetPlayerCash(curPlayer)
	local sortHuRecord = nil
	if executLevel == CONST_EXE_RESULT_HU then
		sortHuRecord = SortHuRecordMsg(tRecordMsg, curPlayer)
		if sortHuRecord == nil then
			-- 1v1
			for k, v in pairs(tRecordMsg) do
				if v[2] == PLAYER_OPERATE_HU then
					ServerOperate(v[1], v[2], v[3], 0, huIndex * 8 + huCount * 2 + haveGang)
				end
			end
		else
			-- 一炮多响 按照番数依次赔付
			-------取出胡牌玩家ID，发给client-------
			local huPlayers = {0, 0, 0}
			local huPlayersIndex = 1
			for k, v in pairs(tRecordMsg) do
				if v[2] == PLAYER_OPERATE_HU then
					huPlayers[huPlayersIndex] = v[1]
					huPlayersIndex = huPlayersIndex + 1
				end
			end
			SendMsg2Client( - 1, PLAYER_OPERATE_MULTI_FIRE, huPlayers[1], huPlayers[2], huPlayers[3])
			-------取出胡牌玩家ID，发给client-------
			local baseCash = GetCashBase()
			local realTotoalCash = 0
			local originTotalCash = GetPlayerCash(curPlayer)
			local operateCard = GetCurOperateCard()
			for k, v in pairs(sortHuRecord) do
				-- 同番数
				local totalCash = baseCash * v[1][1] * (#v)
				if WRITE_LOG then
					--	Log(tostring(" sortHuRecord : totalCash: " .. totalCash .. "|" .. baseCash .. "|" .. v[1][1] .. "|" .. (#v)))
					Log(string.format(" sortHuRecord : totalCash: %d, baseCash: %d, score: %d, count: %d", totalCash, baseCash, v[1][1], (#v)))
				end
				local cashOperatePlayer = GetPlayerCash(curPlayer)
				if totalCash > cashOperatePlayer then
					totalCash = cashOperatePlayer
				end
				realTotoalCash = realTotoalCash + totalCash
				if WRITE_LOG then
					--	Log(tostring("realTotoalCash: " .. realTotoalCash))
					Log(string.format("realTotoalCash: %d", realTotoalCash))
				end
				local subCash = math.floor((totalCash + 1) / (#v))
				local realCash = 0
				for k1, v1 in pairs(v) do
					-- 同番数下不同个玩家
					if k1 == #v then
						realCash = totalCash - (subCash * (#v - 1))
					else
						realCash = subCash
					end
					ServerOperate(v1[2], PLAYER_OPERATE_HU, operateCard, realCash, huIndex * 8 + huCount * 2 + haveGang)
				end
				SetPlayerCash(curPlayer, cashOperatePlayer - totalCash)
				
			end

			ModifyPlayerCash(curPlayer, 0, originTotalCash - realTotoalCash, - realTotoalCash, operateCard, PLAYER_OPERATE_HU_1_PAO_N_XIANG + 100, 0, 0x10, true, 0)
			if GetFirstFire() == 0 then
				SetFirstFire(curPlayer)
			end
		end
		--[[
		huCashAll = ServerOperate(v[1], v[2], v[3], huCashAll, huIndex * 8 + huCount * 2 + haveGang)
--		huCashFlowRecordOff = huCashFlowRecordOff * 4 + huIndex --记录的是日志流水的偏移值
		if huIndex == huCount and huCount > 1 then
			SetCashFlow(curPlayer, huCount, -huCashAll, v[3], PLAYER_OPERATE_HU_1_PAO_N_XIANG, 0, 0, 0)
			SendMsg2Client( - 1, PLAYER_OPERATE_SYN_CASH, curPlayer, cashOperatePlayer - huCashAll, -huCashAll)
		--	ModifyPlayerCash(GetCurOperatePlayer(), huPlayers, cardPlayerCash - accCashHu, - accCashHu, card, type, nameID, huMask, true)
		end
		huIndex = huIndex + 1
		--]]
	elseif executLevel == CONST_EXE_RESULT_JUMP or executLevel == CONST_EXE_RESULT_PENG or executLevel == CONST_EXE_RESULT_GANG then
		for k, v in pairs(tRecordMsg) do
			if (executLevel == CONST_EXE_RESULT_JUMP and v[2] == PLAYER_OPERATE_JUMP)
				or (executLevel == CONST_EXE_RESULT_PENG and v[2] == PLAYER_OPERATE_PENG)
				or (executLevel == CONST_EXE_RESULT_GANG and (v[2] == PLAYER_OPERATE_MING_GANG or v[2] == PLAYER_OPERATE_AN_GANG or v[2] == PLAYER_OPERATE_GANG_AFTER_PENG)) then
				ServerOperate(v[1], v[2], v[3], v[4], v[5])
			end	
		end
	end
	--[[
	for k, v in pairs(tRecordMsg) do
		if executLevel == CONST_EXE_RESULT_HU and v[2] == PLAYER_OPERATE_HU then
			tempHuPlayer = v[1]
			huCashAll = ServerOperate(v[1], v[2], v[3], huCashAll, huIndex * 8 + huCount * 2 + haveGang)
	--		huCashFlowRecordOff = huCashFlowRecordOff * 4 + huIndex --记录的是日志流水的偏移值
			if huIndex == huCount and huCount > 1 then
				SetCashFlow(curPlayer, huCount, -huCashAll, v[3], PLAYER_OPERATE_HU_1_PAO_N_XIANG, 0, 0, 0)
				SendMsg2Client( - 1, PLAYER_OPERATE_SYN_CASH, curPlayer, cashOperatePlayer - huCashAll, -huCashAll)
			--	ModifyPlayerCash(GetCurOperatePlayer(), huPlayers, cardPlayerCash - accCashHu, - accCashHu, card, type, nameID, huMask, true)
			end
			huIndex = huIndex + 1
		elseif (executLevel == CONST_EXE_RESULT_JUMP and v[2] == PLAYER_OPERATE_JUMP)
			or (executLevel == CONST_EXE_RESULT_PENG and v[2] == PLAYER_OPERATE_PENG)
			or (executLevel == CONST_EXE_RESULT_GANG and (v[2] == PLAYER_OPERATE_MING_GANG or v[2] == PLAYER_OPERATE_AN_GANG or v[2] == PLAYER_OPERATE_GANG_AFTER_PENG)) then
			ServerOperate(v[1], v[2], v[3], v[4], v[5])
		end
	end
	--]]

	ClearPlayerOperateRecordAll()

	if executLevel == CONST_EXE_RESULT_HU then
		SetLastGangPlayer(0)
	end

	if executLevel == CONST_EXE_RESULT_HU then
		return lastHuPlayer
	else
		return -executLevel
	end
end

--[[
function CashMingGang(nPlayerIndex, cardPlayerIndex, cashBase)
	local cash = cashBase * CalcGangCashScore(PLAYER_OPERATE_MING_GANG)
	local cardPlayerCash = GetPlayerCash(cardPlayerIndex)
	local playerCash = GetPlayerCash(nPlayerIndex)
	if cash < cardPlayerCash then
		cash = cardPlayerCash
	end
	if cash > 0 then
		SetPlayerCash(cardPlayerIndex, cardPlayerCash - cash)
		SendMsg2Client( -1, PLAYER_OPERATE_SYN_CASH, cardPlayerIndex, cardPlayerCash - cash, -cash)
		SetPlayerCash(nPlayerIndex, playerCash + cash)
		SendMsg2Client( - 1, PLAYER_OPERATE_SYN_CASH, nPlayerIndex, playerCash + cash, cash)
		if cardPlayerCash - cash == 0 then
			--玩家认输
			SetPlayerAlive(cardPlayerIndex, 0)
		end
	end
end

function CashAnGangAfterPeng(nPlayerIndex, cashBase, type)
	local cashOri = cashBase * CalcGangCashScore(type)
	Cash1vN(nPlayerIndex, cashOri)
end
--]]

function ModifyPlayerCashHonor(nPlayerIndex, cashHonor)
	SetPlayerCashHonor(nPlayerIndex, cashHonor)
	SendMsg2Client( - 1, PLAYER_OPERATE_SYN_CASH_HONOR, nPlayerIndex, cashHonor, cashHonor)
end

--type百位为1时，流水应为负值；百位为0是，流水为正值；for +0/-0，类型对100取余
function ModifyPlayerCash(aimPlayerIndex, srcPlayerIndex, cashSum, cashDelta, card, type, nameID, huMask, setLost, multi)
	SetPlayerCash(aimPlayerIndex, cashSum)
	SetCashFlow(aimPlayerIndex, srcPlayerIndex, cashDelta, card, type, nameID, huMask, multi)
	SendMsg2Client( - 1, PLAYER_OPERATE_SYN_CASH, aimPlayerIndex, cashSum, cashDelta)
	if setLost and cashDelta < 0 and cashSum <= 0 then
		SinglePlayerLost(aimPlayerIndex)
	end
end

CONST_WINNER_CASH_RATE = 0.95
function Cash1v1(nPlayerIndex, cardPlayerIndex, cash, card, type, nameID, huMask, huIndex, huCount, multi)
	if WRITE_LOG then
		--	Log(tostring("Cash1v1: " .. nPlayerIndex .. "|" .. cardPlayerIndex .. "|" .. cash .. "|" .. card .. "|" .. type .. "|" .. nameID .. "|" .. huMask .. "|" .. huIndex .. "|" .. huCount .. "|" .. multi))
		Log(string.format("Cash1v1: nPlayerIndex: %d, cardPlayerIndex: %d, cash: %d, card: %d, type: %d, nameID: %d, huMask: %d, huIndex: %d, huCount: %d, multi: %d", nPlayerIndex, cardPlayerIndex, cash, card, type, nameID, huMask, huIndex, huCount, multi))
	end
	local cardPlayerCash = GetPlayerCash(cardPlayerIndex)
	local playerCash = GetPlayerCash(nPlayerIndex)
	if cash > cardPlayerCash then
		cash = cardPlayerCash
	end
	if cash > 0 or huCount > 1 then
--[[
		SetPlayerCash(cardPlayerIndex, cardPlayerCash - cash)
		SetCashFlow(cardPlayerIndex, nPlayerIndex, -cash, card, type, nameID)
		SendMsg2Client( - 1, PLAYER_OPERATE_SYN_CASH, cardPlayerIndex, cardPlayerCash - cash, - cash)
		SetPlayerCash(nPlayerIndex, playerCash + cash)
		SetCashFlow(nPlayerIndex, cardPlayerIndex, cash, card, type, nameID)
		SendMsg2Client( - 1, PLAYER_OPERATE_SYN_CASH, nPlayerIndex, playerCash + cash, cash)
		if cardPlayerCash - cash == 0 then
			--玩家认输
--			SetPlayerAlive(cardPlayerIndex, 0)
			SinglePlayerLost(cardPlayerIndex)
		end
--]]
		local winnerCash = cash
		if type == PLAYER_OPERATE_HU then
			winnerCash = cash * CONST_WINNER_CASH_RATE
		end
		ModifyPlayerCash(nPlayerIndex, cardPlayerIndex, playerCash + winnerCash, winnerCash, card, type, nameID, huMask, true, multi)
		
		if huCount > 1 then
			--SetPlayerCash(cardPlayerIndex, cardPlayerCash - cash)
		else
			ModifyPlayerCash(cardPlayerIndex, nPlayerIndex, cardPlayerCash - cash, - cash, card, type + 100, nameID, huMask, true, 0)
		end

		if type == PLAYER_OPERATE_MING_GANG then
			if WRITE_LOG then
				--	Log(tostring("写入杠牌流水：playerID： " .. nPlayerIndex .. " data: " .. cardPlayerIndex .. " | " .. cash ))
				Log(string.format(GetEditorString(17, 123), nPlayerIndex, cardPlayerIndex, cash ))
			end
			SetPlayerGangCash(nPlayerIndex, cardPlayerIndex, cash, 0, 0, 0, 0)
		end
	end
	
	--按瑞哥指示处理中途结算问题
	local temp = GetPlayerAliveAll()
	local count = 0
	for i = 1, CONST_PLAYER_MAX do
		count = count + temp[i]
	end
	if count < 2 then
		--TODO:TODO:TODO:TODO:三家起立
		--ReturnMoney()
		if not (GetTableMgrState() == CONST_TABLE_STATE_TUISHUI) then
--			SendAndSetTableMgrState(CONST_TABLE_STATE_TUISHUI)
			if WRITE_LOG then
				PrintChatMsg(GetEditorString(16, 5962))
			end
			ReturnMoney()
--			SendAndSetTableMgrState(CONST_TABLE_STATE_END_GAME)
		end
	end
	
	return cash
end

function Cash1vN(nPlayerIndex, cashOri, card, type, nameID, huMask, multi)
	if WRITE_LOG then
		--	Log(tostring("Cash1vN: " .. nPlayerIndex .. "|" .. cashOri .. "|" .. card .. "|" .. type .. "|" .. nameID .. "|" .. huMask .. "|" .. multi))
		Log(string.format("Cash1vN: %d | %d | %d | %d | %d | %d | %d", nPlayerIndex, cashOri, card, type, nameID, huMask, multi))
	end
	local playerCash = GetPlayerCash(nPlayerIndex)
	local playerCashDelta = 0
	local cashGangData = {0, 0, 0, 0, 0, 0}
	local cashGangIndex = 1
	for i = 1, CONST_PLAYER_MAX do
		if not(i == nPlayerIndex) then
			local cash = cashOri
			local otherPlayerCash = GetPlayerCash(i)
		
			if cash > otherPlayerCash then
				cash = otherPlayerCash
			end
			if cash > 0 then
--[[
				SetPlayerCash(i, otherPlayerCash - cash)
				SetCashFlow(i, nPlayerIndex, -cash, card, type, nameID)
				SendMsg2Client( - 1, PLAYER_OPERATE_SYN_CASH, i, otherPlayerCash - cash, - cash)
				if otherPlayerCash - cash == 0 then
					--玩家认输
--					SetPlayerAlive(i, 0)
					SinglePlayerLost(i)
				end
--]]
				ModifyPlayerCash(i, nPlayerIndex, otherPlayerCash - cash, -cash, card, type + 100, nameID, huMask, true, 0)
				playerCashDelta = playerCashDelta + cash
				if type == PLAYER_OPERATE_AN_GANG or type == PLAYER_OPERATE_GANG_AFTER_PENG then
					cashGangData[cashGangIndex] = i
					cashGangData[cashGangIndex + 1] = cash
					cashGangIndex = cashGangIndex + 2
				end
			end
		end
	end
--[[
	SetPlayerCash(nPlayerIndex, playerCash + playerCashDelta)
	SetCashFlow(nPlayerIndex, -1, playerCashDelta, card, type, nameID)
	SendMsg2Client( - 1, PLAYER_OPERATE_SYN_CASH, nPlayerIndex, playerCash + playerCashDelta, playerCashDelta)
--]]
	local winnerCash = playerCashDelta
	if type == PLAYER_OPERATE_HU then
		winnerCash = playerCashDelta * CONST_WINNER_CASH_RATE
	end
	ModifyPlayerCash(nPlayerIndex, 0, playerCash + winnerCash, winnerCash, card, type, nameID, huMask, true, multi * 3)
	if type == PLAYER_OPERATE_AN_GANG or type == PLAYER_OPERATE_GANG_AFTER_PENG then
		if WRITE_LOG then
			--	Log(tostring("写入杠牌流水：playerID： " .. nPlayerIndex .. " data: " .. cashGangData[1] .. " | " .. cashGangData[2] .. " | " .. cashGangData[3] .. " | " .. cashGangData[4] .. " | " .. cashGangData[5] .. " | " .. cashGangData[6]))
			Log(string.format(GetEditorString(17, 124), nPlayerIndex, cashGangData[1], cashGangData[2], cashGangData[3], cashGangData[4], cashGangData[5], cashGangData[6]))
		end
		SetPlayerGangCash(nPlayerIndex, cashGangData[1], cashGangData[2], cashGangData[3], cashGangData[4], cashGangData[5], cashGangData[6])
	end

	--按瑞哥指示处理中途结算问题
	local temp = GetPlayerAliveAll()
	local count = 0
	for i = 1, CONST_PLAYER_MAX do
		count = count + temp[i]
	end
	if count < 2 then
		--TODO:TODO:TODO:TODO:三家起立
		--ReturnMoney()
		if not (GetTableMgrState() == CONST_TABLE_STATE_TUISHUI) then
--			SendAndSetTableMgrState(CONST_TABLE_STATE_TUISHUI)
			if WRITE_LOG then
				PrintChatMsg(GetEditorString(16, 5962))
			end
			ReturnMoney()
--			SendAndSetTableMgrState(CONST_TABLE_STATE_END_GAME)
		end
	end
	
	return playerCashDelta
end

function CashReturnTax(nPlayerIndex, playersReturnTax, playersReturnTaxCount, cashOri, playerSrcCash, type)
	if WRITE_LOG then
		--	Log(tostring("*#*#*# CashReturnTax() nPlayerIndex: " .. nPlayerIndex .. " cashOri: " .. cashOri .. " playerSrcCash：" .. playerSrcCash .. " type: " .. type))
		Log(string.format("*#*#*# CashReturnTax() nPlayerIndex: %d, cashOri: %d, playerSrcCash: %d, type: %d", nPlayerIndex, cashOri, playerSrcCash, type))
		for k, v in pairs(playersReturnTax) do
			--	Log(tostring("退税： playersReturnTaxCount： " .. playersReturnTaxCount .. " playersReturnTax " .. v))
			Log(string.format(GetEditorString(17, 125), playersReturnTaxCount, v))
		end
	end
	local subCash = math.floor((cashOri + 1) / playersReturnTaxCount)
	local cash = subCash
	local playerCash = 0
	local playerCount = 0
	for i = 1, playersReturnTaxCount do
		if WRITE_LOG then
			--	Log(tostring("*#*#*#*# playersReturnTax[" .. i .. "]: " .. playersReturnTax[i]))
			Log(string.format("*#*#*#*# playersReturnTax[%d]: %d", i, playersReturnTax[i]))
		end
		if i == playersReturnTaxCount then
			cash = cashOri - subCash * (playersReturnTaxCount - 1)
		end
		playerCash = GetPlayerCash(playersReturnTax[i])
--[[
		SetPlayerCash(realList[i], playerCash + cash)
		SetCashFlow(realList[i], nPlayerIndex, cash, 0, type, -1)
		SendMsg2Client( - 1, type, realList[i], playerCash + cash, cash)
--]]
		ModifyPlayerCash(playersReturnTax[i], nPlayerIndex, playerCash + cash, cash, 0, type, 0, 0, false, 0)
		playerCount = playerCount + 1
		--	PrintChatMsg("退税: 退: " .. nPlayerIndex .. " 收: " .. playersReturnTax[i] .. " 钱: " .. cash)
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 126), nPlayerIndex, playersReturnTax[i], cash))
		end
	end
	playerCash = playerSrcCash --GetPlayerCash(nPlayerIndex)
--[[
	SetPlayerCash(nPlayerIndex, playerCash - cashOri)
	SetCashFlow(nPlayerIndex, -1, -cashOri, 0, type, -1)
	SendMsg2Client( - 1, type, nPlayerIndex, playerCash - cashOri, - cashOri)
	if playerCash - cashOri == 0 then
		SinglePlayerLost(nPlayerIndex)
	end
--]]
	if playerCount == 1 then
		ModifyPlayerCash(nPlayerIndex, playersReturnTax[1], playerCash - cashOri, - cashOri, 0, type + 100, 0, 0, false, 0)
	elseif playerCount > 1 then
		ModifyPlayerCash(nPlayerIndex, 0, playerCash - cashOri, - cashOri, 0, type + 100, 0, 0, false, 0)
	end
end

function CashReturnNotTing16(nPlayerIndex, playersNotTing, playersNotTingCount, cashBase, type)
	if WRITE_LOG then
		--	Log(tostring("*#*#*# CashReturnNotTing16() nPlayerIndex: " .. nPlayerIndex))
		Log(string.format("*#*#*# CashReturnNotTing16() nPlayerIndex: %d", nPlayerIndex))
	end
	local cashOri = playersNotTingCount * cashBase * 16
	local playerCash = GetPlayerCash(nPlayerIndex)
	local otherPlayerCash = 0

	if playerCash <= 0 then
		return
	end
	
	if cashOri > playerCash then
		cashOri = playerCash
	end

	local subCash = math.floor((cashOri + 1) / playersNotTingCount)
	local cash = subCash
	local playerCount = 0
	for i = 1, playersNotTingCount do
		if WRITE_LOG then
			--	Log(tostring("*#*#*#*# playersNotTing[" .. i .. "]: " .. playersNotTing[i]))
			Log(string.format("*#*#*#*# playersNotTing[%d]: %d", i, playersNotTing[i]))
		end
		if i == playersNotTingCount then
			cash = cashOri - subCash * (playersNotTingCount - 1)
		end
		otherPlayerCash = GetPlayerCash(playersNotTing[i])
--[[
		SetPlayerCash(playersNotTing[i], otherPlayerCash + cash)
		SetCashFlow(playersNotTing[i], nPlayerIndex, cash, 0, type, -1)
		SendMsg2Client( - 1, type, playersNotTing[i], otherPlayerCash + cash, cash)
--]]
		ModifyPlayerCash(playersNotTing[i], nPlayerIndex, otherPlayerCash + cash, cash, 0, type, 0, 0, false, 16)
		playerCount = playerCount + 1
		--	PrintChatMsg("退16倍: 退: " .. nPlayerIndex .. " 收: " .. playersNotTing[i] .. " 钱: " .. cash)
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 127), nPlayerIndex, playersNotTing[i], cash))
		end
	end
--[[
	SetPlayerCash(nPlayerIndex, playerCash - cashOri)
	SetCashFlow(nPlayerIndex, -1, -cashOri, 0, type, -1)
	SendMsg2Client( - 1, type, nPlayerIndex, playerCash - cashOri, - cashOri)
	if playerCash - cashOri == 0 then
		SinglePlayerLost(nPlayerIndex)
	end
--]]
	if playerCount == 1 then
		ModifyPlayerCash(nPlayerIndex, playersNotTing[1], playerCash - cashOri, - cashOri, 0, type + 100, 0, 0, false, 0)
	elseif playerCount > 1 then
		ModifyPlayerCash(nPlayerIndex, 0, playerCash - cashOri, - cashOri, 0, type + 100, 0, 0, false, 0)
	end
end

function CashReturnNotHuMax(nPlayerIndex, playersNotHu, playersNotHuCount, cashBase, tingList4NotHu, type)
	if WRITE_LOG then
--		Log(tostring("*#*#*#*# CashReturnNotHuMax(): nPlayerIndex: " .. nPlayerIndex))
		Log(string.format("*#*#*#*# CashReturnNotHuMax(): nPlayerIndex: %d", nPlayerIndex))
	end
	local srcPlayerCash = GetPlayerCash(nPlayerIndex)
	if srcPlayerCash <= 0 then
		return
	end

	local playersNotHuMaxScore = {}
	for i = 1, playersNotHuCount do
		if WRITE_LOG then
--			Log(tostring("************CashReturnNotHuMax playersNotHu[" .. i .. "]: " .. playersNotHu[i]))
			Log(string.format("************CashReturnNotHuMax playersNotHu[%d]: %d", i, playersNotHu[i]))
		end
		local handCards = GetPlayerHand(playersNotHu[i])
		local bonusTable = GetPlayerBonus(playersNotHu[i])
		
		--nValue2(cardValue), nValue3(cardPlayerIndex)
		local isFirstCircle = 0
		local curCardPtr = 100 --不是最后一张就行
		--	OperateHu(tMemPlayerCards[nPlayerIndex][DATA_IN_HAND], tMemPlayerCards[nPlayerIndex][LACK], nValue2, tMemPlayerCards[nPlayerIndex][BONUS_TABLE], tMemPlayerCards[nPlayerIndex][HU_RECORD], analysisTable, nPlayerIndex, tMemPlayerData[CUR_PLAYER], isFirstCircle, tMemCardsPtr[CURPTR])
		local lack = GetPlayerLack(playersNotHu[i])
		local maxScore = 0
		for k1, v1 in pairs(tingList4NotHu[playersNotHu[i]]) do
			local analysisTable = {
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 0
			}
			OperateHu(handCards, lack, v1, bonusTable, analysisTable, playersNotHu[i], nPlayerIndex, isFirstCircle, curCardPtr)
			local score = CalcHuCashScore(analysisTable)
			if type == PLAYER_OPERATE_CHECK_COLORPIG and score < 16 then
				score = 16
			end
			if maxScore < score then
				maxScore = score
			end
		end
		playersNotHuMaxScore[i] = {maxScore, playersNotHu[i]}
	end

	local sortFunc = function (a, b)
		return a[1] > b[1]
	end
	
	table.sort(playersNotHuMaxScore, sortFunc)

	local sortTable = {}
	local score = 0
	local index = 0
	for k, v in pairs(playersNotHuMaxScore) do
		if not (score == v[1]) then
			score = v[1]
			index = index + 1
			sortTable[index] = {}
		end

		table.insert(sortTable[index], {v[1], v[2]})
	end

	local realTotoalCash = 0
	local playerCount = 0
	local playerID = 0
	for k, v in pairs(sortTable) do
		-- 同番数
		local totalCash = cashBase * v[1][1] * (#v)
		playerID = v[1][2]
		
		local cashOperatePlayer = GetPlayerCash(nPlayerIndex)
		if totalCash > cashOperatePlayer then
			totalCash = cashOperatePlayer
		end
		realTotoalCash = realTotoalCash + totalCash
		if WRITE_LOG then
			Log(tostring("realTotoalCash: " .. realTotoalCash))
		end
		local subCash = math.floor((totalCash + 1) / (#v))
		local realCash = 0
		for k1, v1 in pairs(v) do
			-- 同番数下不同个玩家
			if k1 == #v then
				realCash = totalCash - (subCash * (#v - 1))
			else
				realCash = subCash
			end
			local playerCash = GetPlayerCash(v1[2])
			ModifyPlayerCash(v1[2], nPlayerIndex, playerCash + realCash, realCash, 0, type, 0, 0, false, v1[1])
			playerCount = playerCount + 1
			--	PrintChatMsg("退最大番数: 退: " .. nPlayerIndex .. " 收: " .. v1[2] .. " 钱: " .. realCash)
			if WRITE_LOG then
				PrintChatMsg(string.format(GetEditorString(17, 128), nPlayerIndex, v1[2], realCash))
			end
		end
		SetPlayerCash(nPlayerIndex, cashOperatePlayer - totalCash)
	end
	if playerCount == 1 then
		ModifyPlayerCash(nPlayerIndex, playerID, srcPlayerCash - realTotoalCash, - realTotoalCash, 0, type + 100, 0, 0, false, 0)
	elseif playerCount > 1 then
		ModifyPlayerCash(nPlayerIndex, 0, srcPlayerCash - realTotoalCash, - realTotoalCash, 0, type + 100, 0, 0, false, 0)
	end
		
	--[[
	local cash = 0
	local srcPlayerCashDelta = 0

	for k, v in pairs(playersNotHuMaxScore) do
		cash = v[1] * cashBase
		if srcPlayerCash - srcPlayerCashDelta < cash then
			cash = srcPlayerCash - srcPlayerCashDelta
		end
		if cash > 0 then
			local playerCash = GetPlayerCash(v[2])
			ModifyPlayerCash(v[2], nPlayerIndex, playerCash + cash, cash, 0, type, 0, 0, false, v[1])
			PrintChatMsg("退最大番数: 退: " .. nPlayerIndex .. " 收: " .. v[2] .. " 钱: " .. cash)
			srcPlayerCashDelta = srcPlayerCashDelta + cash
		end
	end
	ModifyPlayerCash(nPlayerIndex, 0, srcPlayerCash - srcPlayerCashDelta, -srcPlayerCashDelta, 0, type, 0, 0, false, 0)
	--]]
--[[	
	for i = 1, playersNotHuCount do
		cash = playersNotHuMaxScore[i][1] * cashBase
		if srcPlayerCash - srcPlayerCashDelta < cash then
			cash = srcPlayerCash - srcPlayerCashDelta
		end
		if cash > 0 then
			local playerCash = GetPlayerCash(playersNotHuMaxScore[i][2])
			ModifyPlayerCash(playersNotHuMaxScore[i][2], nPlayerIndex, playerCash + cash, cash, 0, type, - 1, false)
			srcPlayerCashDelta = srcPlayerCashDelta + cash
		end
	end
--]]
end

function SinglePlayerLost(nPlayerIndex)
	SetPlayerAlive(nPlayerIndex, 0)
	SendMsg2Client( - 1, PLAYER_OPERATE_OUT_OF_MONEY, nPlayerIndex, 0, 0)
--	PrintChatMsg("玩家: " .. nPlayerIndex .. "认输")
	if WRITE_LOG then
		PrintChatMsg(string.format(GetEditorString(17, 129), nPlayerIndex))
	end
	
	--[[
	local temp = GetPlayerAliveAll()
	local count = 0
	for i = 1, CONST_PLAYER_MAX do
		count = count + temp[i]
	end
	if count < 2 then
		--TODO:TODO:TODO:TODO:三家起立
		--ReturnMoney()
		if not (GetTableMgrState() == CONST_TABLE_STATE_TUISHUI) then
--			SendAndSetTableMgrState(CONST_TABLE_STATE_TUISHUI)
			if WRITE_LOG then
				PrintChatMsg("三家起立 牌局结束")
			end
			ReturnMoney()
--			SendAndSetTableMgrState(CONST_TABLE_STATE_END_GAME)
		end
	end
	--]]
end

function CashGang(nPlayerIndex, cardPlayerIndex, type, card)
	local multi = CalcGangCashScore(type)
	local cash = GetCashBase() * multi
	if type == PLAYER_OPERATE_MING_GANG then
		Cash1v1(nPlayerIndex, cardPlayerIndex, cash, card, type, 0, 0, 0, 0, 0)
		SetPlayerIncomeMulti(nPlayerIndex, multi)
	else
		Cash1vN(nPlayerIndex, cash, card, type, 0, 0, 0)
		SetPlayerIncomeMulti(nPlayerIndex, multi * 3)
	end
end

CONST_HU_MAX_MULTI = 128
function CashHu(nPlayerIndex, cardPlayerIndex, huMaskTable, card, nameID, huMask, huIndex, huCount, maxCash)
	local multi = CalcHuCashScore(huMaskTable)
	local cash = 0
	if multi > CONST_HU_MAX_MULTI then
		cash = GetCashBase() * CONST_HU_MAX_MULTI
	else
		cash = GetCashBase() * multi
	end
	if maxCash > 0 then
		cash = maxCash --一炮多响提前计算，传入扣取的钱数（为了平均分配）
	end
--	local realCash = 0 --一炮多响累积
	if nPlayerIndex == cardPlayerIndex then
--		realCash = Cash1vN(nPlayerIndex, cash, card, PLAYER_OPERATE_HU, nameID, huMask, multi)
		Cash1vN(nPlayerIndex, cash, card, PLAYER_OPERATE_HU, nameID, huMask, multi)
		multi = multi * 3
	else
--		realCash = Cash1v1(nPlayerIndex, cardPlayerIndex, cash, card, PLAYER_OPERATE_HU, nameID, huMask, huIndex, huCount, multi)
		Cash1v1(nPlayerIndex, cardPlayerIndex, cash, card, PLAYER_OPERATE_HU, nameID, huMask, huIndex, huCount, multi)
	end
	if multi > GetPlayerMaxHuCash(nPlayerIndex) then
		SetPlayerMaxHuCash(nPlayerIndex, multi)
	end
	local historyMaxHuNameID = GetPlayerMaxHuNameID(nPlayerIndex)
	if nameID < historyMaxHuNameID or historyMaxHuNameID == 0 then
		SetPlayerMaxHuNameID(nPlayerIndex, nameID)
	end
	SetPlayerIncomeMulti(nPlayerIndex, multi)
--	return realCash
end

function ServerOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
	if WRITE_LOG then
		--	Log(tostring("ServerOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4): nPlayerIndex: " .. nPlayerIndex .. " nValue1: " .. nValue1 .. " nValue2: " .. nValue2 .. " nValue3: " .. nValue3 .. " nValue4: " .. nValue4))
		Log(string.format("ServerOperate(nPlayerIndex: %d, nValue1: %d, nValue2: %d, nValue3: %d, nValue4: %d)", nPlayerIndex, nValue1, nValue2, nValue3, nValue4))
	end

--	local huCash = 0
	
	local handCards = GetPlayerHand(nPlayerIndex)
	local bonusTable = GetPlayerBonus(nPlayerIndex)
	if nValue1 == PLAYER_OPERATE_PENG then
		--清理CUR_OPERATE_CARD
		SetCurOperateCard(0) --curOperateCard = 0
--		local bonusPengGang = SetDataWithFlagN(nValue2, nValue1, CONST_MASK_N_BONUSDATA_TYPE) --check的时候检测过合法性了
--		OperatePengGang(handCards, nValue2, bonusTable, bonusPengGang)
		OperatePengGang(handCards, nValue2, bonusTable, nValue1)
		SetPlayerHand(nPlayerIndex, handCards)
		--	tMemPlayerData[CUR_PLAYER] = nPlayerIndex
		if DEBUG_MAHJONG then
--			SetPlayerDebugPeepHand(nPlayerIndex)
			PeepHand(nPlayerIndex)
		end
		SetCurOperatePlayer(nPlayerIndex) --SetPlayerData(CUR_PLAYER, nPlayerIndex)
		SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_CS_SEND)
--		SetPlayerBonus(nPlayerIndex, bonusTable, nValue2, bonusPengGang)
		SetPlayerBonus(nPlayerIndex, bonusTable)
		--	SetBonus(nPlayerIndex, nValue2, SetDataWithFlagN(nValue2, CONST_BONUS_TYPE_PENG, CONST_MASK_N_BONUSDATA_TYPE))
--		GetPlayer(PlayerID).SendSystemMessage("玩家:" .. nPlayerIndex .. "碰" .. string.format("%#x", nValue2))
--		PrintChatMsg("玩家:" .. nPlayerIndex .. "碰" .. string.format("%#x", nValue2))
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 130), nPlayerIndex, nValue2))
		end
		--TODO:清理玩家operateMask
	elseif nValue1 == PLAYER_OPERATE_MING_GANG or nValue1 == PLAYER_OPERATE_AN_GANG or nValue1 == PLAYER_OPERATE_GANG_AFTER_PENG then
		--清理CUR_OPERATE_CARD
		local curOperateCard = GetCurOperateCard()
		local curPlayer = GetCurOperatePlayer() 

		if curOperateCard > 0 then
			handCards[curOperateCard] = handCards[curOperateCard] + 1
			if handCards[curOperateCard] > 4 then
				handCards[curOperateCard] = 4
			end
			SetCurOperateCard(0) --tMemPlayerCards[CUR_OPERATE_CARD] = 0
		end
--		local bonusPengGang = -1
--		bonusPengGang = SetDataWithFlagN(nValue2, nValue1, CONST_MASK_N_BONUSDATA_TYPE) --check的时候检测过合法性了
--		OperatePengGang(handCards, nValue2, bonusTable, bonusPengGang)
		OperatePengGang(handCards, nValue2, bonusTable, nValue1)
		SetPlayerHand(nPlayerIndex, handCards)
		if DEBUG_MAHJONG then
--			SetPlayerDebugPeepHand(nPlayerIndex)
			PeepHand(nPlayerIndex)
		end
		CashGang(nPlayerIndex, curPlayer, nValue1, nValue2)
		--tMemPlayerData[LAST_GANG_PLAYER] = nPlayerIndex
--		SetPlayerData(LAST_GANG_PLAYER, nPlayerIndex)
		SetLastGangPlayer(nPlayerIndex)
		--tMemPlayerData[CUR_PLAYER] = nPlayerIndex
		--	SetPlayerData(CUR_PLAYER, nPlayerIndex)
		SetCurOperatePlayer(nPlayerIndex)
--		PrintChatMsg("设置操作玩家:" .. nPlayerIndex .. " --杠后")
		local tableState = GetTableMgrState()
		if not(tableState == CONST_TABLE_STATE_END_GAME) then
			SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_CS_SEND)
		end
		SetPlayerBonus(nPlayerIndex, bonusTable)
--		PrintChatMsg("玩家:" .. nPlayerIndex .. " 杠:" .. string.format("%#x", nValue2) .. " 类型:" .. nValue1)
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 132), nPlayerIndex, nValue2, nValue1))
		end
--		if nValue1 == PLAYER_OPERATE_MING_GANG then
		--	SetPlayerBonus(nPlayerIndex, bonusTable, nValue2, SetDataWithFlagN(nValue2, PLAYER_OPERATE_MING_GANG, CONST_MASK_N_BONUSDATA_TYPE))
		--	SetBonus(nPlayerIndex, nValue2, SetDataWithFlagN(nValue2, CONST_BONUS_TYPE_MINGGANG, CONST_MASK_N_BONUSDATA_TYPE))
--			GetPlayer(PlayerID).SendSystemMessage("玩家:" .. nPlayerIndex .. "明杠" .. string.format("%#x", nValue2))
--		elseif nValue1 == PLAYER_OPERATE_AN_GANG then
		--	SetPlayerBonus(nPlayerIndex, bonusTable, nValue2, SetDataWithFlagN(nValue2, PLAYER_OPERATE_AN_GANG, CONST_MASK_N_BONUSDATA_TYPE))
		--	SetBonus(nPlayerIndex, nValue2, SetDataWithFlagN(nValue2, CONST_BONUS_TYPE_ANGANG, CONST_MASK_N_BONUSDATA_TYPE))
--			GetPlayer(PlayerID).SendSystemMessage("玩家:" .. nPlayerIndex .. "暗杠" .. string.format("%#x", nValue2))
--		elseif nValue1 == PLAYER_OPERATE_GANG_AFTER_PENG then
		--	SetPlayerBonus(nPlayerIndex, bonusTable, nValue2, SetDataWithFlagN(nValue2, PLAYER_OPERATE_GANG_AFTER_PENG, CONST_MASK_N_BONUSDATA_TYPE))
		--	SetBonus(nPlayerIndex, nValue2, SetDataWithFlagN(nValue2, CONST_BONUS_TYPE_ANGANG, CONST_MASK_N_BONUSDATA_TYPE))
--			GetPlayer(PlayerID).SendSystemMessage("玩家:" .. nPlayerIndex .. "碰后杠" .. string.format("%#x", nValue2))
--		end
--		AddGangCout()
		--	tMemCardsPtr[GANG] = tMemCardsPtr[GANG] + 1
	elseif nValue1 == PLAYER_OPERATE_HU then
		local analysisTable = {
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0
		}
		--nValue2(cardValue), nValue3(cardPlayerIndex)
		local isFirstCircle = GetPlayerIsFirstCircle(nPlayerIndex)
--[[
		local chairMan = GetChairMan()
		if nPlayerIndex == chairMan then
			isFirstCircle = -1
		end
--]]
		local curPlayer = GetCurOperatePlayer()
		local curCardPtr = GetCurCardPtr()
		--	OperateHu(tMemPlayerCards[nPlayerIndex][DATA_IN_HAND], tMemPlayerCards[nPlayerIndex][LACK], nValue2, tMemPlayerCards[nPlayerIndex][BONUS_TABLE], tMemPlayerCards[nPlayerIndex][HU_RECORD], analysisTable, nPlayerIndex, tMemPlayerData[CUR_PLAYER], isFirstCircle, tMemCardsPtr[CURPTR])
		local lack = GetPlayerLack(nPlayerIndex)
		local huResult = OperateHu(handCards, lack, nValue2, bonusTable, analysisTable, nPlayerIndex, curPlayer, isFirstCircle, curCardPtr)
		local qiangGangHu = nValue4 % 2
		nValue4 = math.floor(nValue4 / 2)
		local huCount = nValue4 % 4
		local huIndex = math.floor(nValue4 / 4)
		local huMaskHuCount = 0
		if huCount > 1 then
			huMaskHuCount = 1
		else
			huMaskHuCount = 0
		end
		
		analysisTable[CONST_HUMASK_N_QIANG_GANG_HU] = qiangGangHu
		if huResult == 1 then
			if GetFirstWinner() == 0 then
				SetFirstWinner(nPlayerIndex)
			end
			--	CheckHu(tMemPlayerCards[nPlayerIndex][DATA_IN_HAND], tMemPlayerCards[nPlayerIndex][LACK], nValue2, tMemPlayerCards[nPlayerIndex][BONUS_TABLE], analysisTable, true)
			--	CheckHuPlus(tMemPlayerCards[nPlayerIndex][DATA_IN_HAND], tMemPlayerCards[nPlayerIndex][LACK], nValue2, tMemPlayerCards[nPlayerIndex][BONUS_TABLE], analysisTable, nPlayerIndex, tMemPlayerData[CUR_PLAYER])
			if GetPlayerIsLockTing(nPlayerIndex) == 0 then
				--	CheckTing(tMemPlayerCards[nPlayerIndex][TING_LIST], tMemPlayerCards[nPlayerIndex][DATA_IN_HAND], tMemPlayerCards[nPlayerIndex][LACK], tMemPlayerCards[nPlayerIndex][BONUS_TABLE])
				local tingList = {}
				local scoreTable = {}
				CheckTing(tingList, handCards, lack, bonusTable, false, scoreTable)
				SetPlayerTingList(nPlayerIndex, tingList)
				SetPlayerIsLockTing(nPlayerIndex, 1)
				SetPlayerIsAgent(nPlayerIndex, 1)
				SendMsg2Client( - 1, PLAYER_OPERATE_SET_AGENT, nPlayerIndex, 1, 0)
				--			GetPlayer(PlayerID).SendSystemMessage("玩家:" .. nPlayerIndex .. "第一次胡")
				--	PrintChatMsg("玩家:" .. nPlayerIndex .. "第一次胡")
				if WRITE_LOG then
					PrintChatMsg(string.format(GetEditorString(17, 133), nPlayerIndex))
				end
			end
			AddPlayerHuCount(nPlayerIndex)
			--特殊番型名称id
			local nameID = GetHuPlusNameID(analysisTable)
			local huMask = analysisTable[CONST_HUMASK_N_HU_AFTER_GANG]
			+ analysisTable[CONST_HUMASK_N_ZIMO] * 2
			+ analysisTable[CONST_HUMASK_N_MOON] * 4
			+ analysisTable[CONST_HUMASK_N_QIANG_GANG_HU] * 8
			+ huMaskHuCount * 16
			+ analysisTable[CONST_HUMASK_N_GENS] * 32
			CashHu(nPlayerIndex, curPlayer, analysisTable, nValue2, nameID, huMask, huIndex, huCount, nValue3)
--[[
			huCash = CashHu(nPlayerIndex, curPlayer, analysisTable, nValue2, nameID, huMask, huIndex, huCount)
			if huMaskHuCount == 1 then
				huCash = huCash + nValue3 --一炮多响赔钱累计
			else
				if huCash > GetPlayerMaxHuCash(nPlayerIndex) then
					SetPlayerMaxHuCash(nPlayerIndex, huCash)
				end
			end
--]]
			SetHuRecord(nPlayerIndex, nValue2)
			PlayPlayerSoundHu(nPlayerIndex, curPlayer, nValue2)
			SendMsg2Client( - 1, PLAYER_OPERATE_HU, nameID * 100 + nPlayerIndex * 10 + curPlayer, nValue2, huMask)
			local dwHuPlayer = GetPlayerDWID(nPlayerIndex)
			local HuPlayer = GetPlayer(dwHuPlayer)
			if huMaskHuCount > 0 then
				--TODO:成就 curPlayer就是一炮多响的放炮者啦(1234)
				local dwFangPaoPlayer = GetPlayerDWID(curPlayer)
				local FangPaoPlayer = GetPlayer(dwFangPaoPlayer)
				if FangPaoPlayer and not FangPaoPlayer.IsAchievementAcquired(7910) then
					FangPaoPlayer.AcquireAchievement(7910)
				end
			end
			if analysisTable[CONST_HUMASK_N_HU_AFTER_GANG] == 1 and analysisTable[CONST_HUMASK_N_ZIMO] == 1 then
				--TODO:成就 nPlayerIndex杠上开花啦(1234)
				if HuPlayer and not HuPlayer.IsAchievementAcquired(7911) then
					HuPlayer.AcquireAchievement(7911)
				end
			end
			if analysisTable[CONST_HUMASK_N_MOON] == 1 then
				--TODO:成就 nPlayerIndex海底捞月啦(1234)
				if HuPlayer and not HuPlayer.IsAchievementAcquired(7912) then
					HuPlayer.AcquireAchievement(7912)
				end
			end
			
			--TODO:成就 根据nameID判断牌型啦（清一色~清十八罗汉）
			local nAchID = tHuAch[nameID]
			if HuPlayer and nAchID ~= 0 and not HuPlayer.IsAchievementAcquired(nAchID) then
				HuPlayer.AcquireAchievement(nAchID)
			end
		else
			SendMsg2Client(nPlayerIndex, PLAYER_OPERATE_ERROR, nPlayerIndex, ERROR_CODE_PLAYER_CANOT_HU, huResult)
			return 0
		end
		--	table.insert(tMemPlayerData[ALL_PLAYER_CASH_FLOW], analysisTable[0]);
--		GetPlayer(PlayerID).SendSystemMessage("玩家:" .. nPlayerIndex .. "胡" .. string.format("%#x", nValue2))
		if DEBUG_MAHJONG then
--			SetPlayerDebugPeepHand(nPlayerIndex)
			PeepHand(nPlayerIndex)
		end
		--	PrintChatMsg("玩家:" .. nPlayerIndex .. "胡" .. string.format("%#x", nValue2))
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 134), nPlayerIndex, nValue2))
		end
	elseif nValue1 == PLAYER_OPERATE_JUMP then
		--此牌没人要
--		GetPlayer(PlayerID).SendSystemMessage("玩家:" .. nPlayerIndex .. "跳过")
		--	PrintChatMsg("玩家:" .. nPlayerIndex .. "跳过")
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 135), nPlayerIndex))
		end
	elseif nValue1 == PLAYER_OPERATE_CS_SEND then
		--nValue2(out) operateCard入手牌
		local curOperateCard = GetCurOperateCard()
		
--		GetPlayer(PlayerID).SendSystemMessage("玩家:" .. nPlayerIndex .. "出牌" .. string.format("%#x", nValue2))
		--	PrintChatMsg("玩家:" .. nPlayerIndex .. "出牌" .. string.format("%#x", nValue2))
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 136), nPlayerIndex, nValue2))
		end
		OperateSendCard(handCards, curOperateCard, nValue2)
		SetPlayerHand(nPlayerIndex, handCards)
		SetCurOperateCard(nValue2) --tMemPlayerCards[CUR_OPERATE_CARD] = nValue2
		if DEBUG_MAHJONG then
--			SetPlayerDebugPeepHand(nPlayerIndex)
			PeepHand(nPlayerIndex)
		end
		SetChairManOperateCard(GetChairMan(), 0)
		SendMsg2Client(-1, nValue1, nPlayerIndex, nValue2, nValue3)
		if CheckOperateMaskForAll(nPlayerIndex) then
			--operate定时，等待其他玩家操作
			--	GetScene(MemSceneID).SetTimer(TIMER_CS_OPERATE * GLOBAL.GAME_FPS, "scripts/Map/家园系统/miniGame/majhong/xueliuchenghe1/xueliuchengheTableMgr.lua", TIMER_CS_OPERATE, 0)
			local isAgent = 0
			local isAllAgent = true
			local isLockTing = 0
			local isAllLocking = true
			for i = 1, CONST_PLAYER_MAX do
				if not (i == nPlayerIndex) then
					local operateMask = GetPlayerOperateMask(i)
					if operateMask[PLAYER_OPERATE_JUMP] == 1 then
						isAgent = GetPlayerIsAgent(i)
						if isAgent == 0 then
							isAllAgent = false
							isAllLocking = false
						else
							isLockTing = GetPlayerIsLockTing(i)
							if isLockTing == 0 then
								isAllLocking = false
							end
						end
					end
				end
			end
			if isAllLocking then
				SetTimer(CONST_TABLE_STATE_WAIT_OPERATE, - 1, CONST_COUNT_DOWN_TIME[CONST_TABLE_STATE_WAIT_OPERATE_LOCKTING])
			elseif 	isAllAgent then
				SetTimer(CONST_TABLE_STATE_WAIT_OPERATE, - 1, CONST_COUNT_DOWN_TIME[CONST_TABLE_STATE_WAIT_CS_SEND_AGENT])
			else
				SetTimer(CONST_TABLE_STATE_WAIT_OPERATE, - 1, 0)
			end
			SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_OPERATE)
			--	tMemPlayerData[CUR_PLAYER] = nPlayerIndex
			--SetPlayerData(CUR_PLAYER, nPlayerIndex)
			--	SetCurOperatePlayer(nPlayerIndex)

			--[[	
			local isAgent = 0
			for i = 1, CONST_PLAYER_MAX do
			--	if i == nPlayerIndex then
					isAgent = GetPlayerIsAgent(i)
					if isAgent == 1 then
						AutoOperate(i, true)
					end
			--	end
			end
		--]]
		else
			--此牌没人要，进入弃牌区
			SetAbandonCard(nPlayerIndex, nValue2)
--			GetPlayer(PlayerID).SendSystemMessage("玩家:" .. nPlayerIndex .. "出的牌" .. string.format("%#x", nValue2) .. "没人要")
			--	PrintChatMsg("玩家:" .. nPlayerIndex .. "出的牌" .. string.format("%#x", nValue2) .. "没人要")
			if WRITE_LOG then
				PrintChatMsg(string.format(GetEditorString(17, 374), nPlayerIndex, nValue2))
			end
			NextPlayer(0)
			SendCard()
--			ServerOperate(tMemPlayerData[CUR_PLAYER], PLAYER_OPERATE_SC_SEND, tMemAllCards[tMemCardsPtr[CURPTR]], 0, 0)
		end
	elseif nValue1 == PLAYER_OPERATE_STEAL_CARD then
		if DEBUG_MAHJONG then
			if nValue4 > 0 then
				if WRITE_LOG then
					PrintPlayerHands(nValue4)
				end
				StealCard(nValue4, nValue2, nValue3)
				PeepHand(nValue4)
				if WRITE_LOG then
					PrintPlayerHands(nValue4)
				end
			else
				if WRITE_LOG then
					PrintPlayerHands(nPlayerIndex)
				end
				StealCard(nPlayerIndex, nValue2, nValue3)
				PeepHand(nPlayerIndex)
				if WRITE_LOG then
					PrintPlayerHands(nPlayerIndex)
				end
			end
			--SetPlayerDebugPeepHand(curPlayer)
			SendMsg2Client(nPlayerIndex, nValue1, 0, 0, 0)
		end
	end
	if nValue1 > PLAYER_OPERATE_JUMP and nValue1 < PLAYER_OPERATE_HU then
		SendMsg2Client( - 1, nValue1, nPlayerIndex, nValue2, nValue3)
	end
--	return huCash
--	miniGameMgr1.Operate(nPlayerIndex - 1, nValue1, nValue2, nValue3, nValue4)
end

function PeepHand(nPlayerIndex)
	SetPlayerDebugPeepHand(nPlayerIndex)
	SendMsg2Client(-1, PLAYER_OPERATE_DEBUG_PEEP_OTHER_HAND, nPlayerIndex, 0, 0)
end

function FindNextAlive(nPlayerIndex)
	local newOperatePlayer = nPlayerIndex
	local aliveData = GetPlayerAliveAll()
	local search = true
	local offset = 1
	while search do
		newOperatePlayer = nPlayerIndex + offset
		if newOperatePlayer > 4 then
			newOperatePlayer = newOperatePlayer - 4
		end
		if aliveData[newOperatePlayer] == 1 then
			search = false
		else
			offset = offset + 1
			if offset > 3 then
				search = false
			end
		end
	end
	return newOperatePlayer
end

function NextPlayer(executResult)
	local curPlayer = GetCurOperatePlayer()
	local lastGangPlayer = GetLastGangPlayer()
	if WRITE_LOG then
		--	Log(tostring("调用nextPlayer: executResult: " .. executResult .. " curPlayer: " .. curPlayer .. " lastGangPlayer: " .. lastGangPlayer))
		Log(string.format(GetEditorString(17, 138), executResult, curPlayer, lastGangPlayer))
	end
	local newOperatePlayer = curPlayer
	if executResult > 0 then --胡牌
		newOperatePlayer = FindNextAlive(executResult)
		SetCurOperatePlayer(newOperatePlayer)
--		PrintChatMsg("设置操作玩家:" .. newOperatePlayer .. " --胡牌")
	elseif executResult == -1 or executResult == 0 then --过牌 or 出牌没人要
		--	tMemPlayerData[CUR_PLAYER] = (tMemPlayerData[CUR_PLAYER] % 4) + 1
		--	SetPlayerData(CUR_PLAYER, (tMemPlayerData[CUR_PLAYER] % 4) + 1)
		newOperatePlayer = FindNextAlive(curPlayer)
		
		SetCurOperatePlayer(newOperatePlayer)

		--	PrintChatMsg("设置操作玩家:" .. newOperatePlayer .. " --过牌，出牌没人要")
	elseif executResult == -2 or executResult == -3 then --碰牌杠牌不变
		--tMemPlayerData[CUR_PLAYER] = tMemPlayerData[CUR_PLAYER]
--		SetCurOperatePlayer(curPlayer)    --ServerOperate 已调用
	end

	if not (newOperatePlayer == lastGangPlayer) then
		--	tMemPlayerData[LAST_GANG_PLAYER] = 0
		--SetPlayerData(LAST_GANG_PLAYER, 0)
		SetLastGangPlayer(0)
	end
--	print("NextPlayer tMemPlayerData[CUR_PLAYER]: " .. tMemPlayerData[CUR_PLAYER])

--	GetPlayer(PlayerID).SendSystemMessage(StringPlayerHands(GetCurOperatePlayer()))
	return newOperatePlayer
end

function OnClientOperate(nPlayer, nValue1, nValue2, nValue3, nValue4)

end

function SendAndSetTableMgrState(state)
	if WRITE_LOG then
		if state == CONST_TABLE_STATE_TUISHUI then
			Log("*****************CONST_TABLE_STATE_TUISHUI*****************")
		elseif state == CONST_TABLE_STATE_END_GAME then
			Log("*****************CONST_TABLE_STATE_END_GAME*****************")
		end
	end
	SetTableMgrState(state)
	if state == CONST_TABLE_STATE_END_GAME then
		miniGameMgr1.SetGameState(0)
	elseif state == CONST_TABLE_STATE_INIT or state == CONST_TABLE_STATE_EXCHANGE then
		miniGameMgr1.SetGameState(1)
	end
	SendMsg2Client(-1, PLAYER_OPERATE_TABLE_STATE, state, 0, 0)
end

function ExchangeAllCard()
	local exchangeCard = {}
	local playerHand = {}
	for i = 1, CONST_PLAYER_MAX do
		exchangeCard[i] = GetPlayerExchangeCard(i)
		playerHand[i] = GetPlayerHand(i)
	end

	SetExchangePlayers(255)
	
	local diceNum = GetDiceNum()
	diceNum = diceNum % 10
	diceNum = math.ceil(diceNum / 2) -- 1顺,2对,3逆
	if NO_EXCHANGE then
		diceNum = 0
	end

	local chairMan = GetChairMan()
	local n = 0
	for j = 1, CONST_PLAYER_MAX do
		n = j + diceNum
		if n > 4 then
			n = n - 4
		end
		SetPlayerExchangeCardBack(j, exchangeCard[n][1], exchangeCard[n][2], exchangeCard[n][3])
		for k = 1, 3 do
			if GetPlayerHaveCommitExchange(j) == 0 then
				playerHand[j][exchangeCard[j][k]] = playerHand[j][exchangeCard[j][k]] - 1
			end
			playerHand[j][exchangeCard[n][k]] = playerHand[j][exchangeCard[n][k]] + 1
		end
--		if j == chairMan then
--			playerHand[j][exchangeCard[n][3]] = playerHand[j][exchangeCard[n][3]] - 1
--			SetCurOperateCard(exchangeCard[n][3])
--		end
		SetPlayerHand(j, playerHand[j])
		if DEBUG_MAHJONG then
--			SetPlayerDebugPeepHand(j)
			PeepHand(j)
		end
		SendMsg2Client(j, PLAYER_OPERATE_EXCHANGE, exchangeCard[n][1], exchangeCard[n][2], exchangeCard[n][3])
		if WRITE_LOG then
			--	PrintChatMsg("玩家:" .. j .. "换出牌: " .. string.format("%#x", exchangeCard[j][1]) .. ", " .. string.format("%#x", exchangeCard[j][2]) .. ", " .. string.format("%#x", exchangeCard[j][3]))
			PrintChatMsg(string.format(GetEditorString(17, 139), j, exchangeCard[j][1], exchangeCard[j][2], exchangeCard[j][3]))
			--	PrintChatMsg("玩家:" .. j .. "换回牌: " .. string.format("%#x", exchangeCard[n][1]) .. ", " .. string.format("%#x", exchangeCard[n][2]) .. ", " .. string.format("%#x", exchangeCard[n][3]))
			PrintChatMsg(string.format(GetEditorString(17, 140), j, exchangeCard[n][1], exchangeCard[n][2], exchangeCard[n][3]))
		end
	end
	SendAndSetTableMgrState(CONST_TABLE_STATE_SET_LACK)
	SetTimer(CONST_TABLE_STATE_SET_LACK, -1, 0)
end

function SynAllLack()
	SetLackPlayers(255)
	SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_CS_SEND) --因为客户端收到setLack协议会取tableState，为了C端显示，这里设置一个假状态
	for i = 1, CONST_PLAYER_MAX do
		SendMsg2Client( - 1, PLAYER_OPERATE_SET_LACK, i, GetPlayerLack(i), 0)
		--	PrintChatMsg("玩家:" .. i .. "定缺: " .. GetPlayerLack(i))
		if WRITE_LOG then
			PrintChatMsg(string.format(GetEditorString(17, 141), i, GetPlayerLack(i)))
		end
	end
end

function StartRealGame()
	local chairMan = GetChairMan()
	local maskData = {}
	local gangData = {}
--	SetCurOperatePlayer(chairMan)
--	PrintChatMsg("设置操作玩家:" .. chairMan .. " --庄家")
	if WRITE_LOG then
		PrintChatMsg(string.format(GetEditorString(17, 142), chairMan))
	end
	for i = 1, CONST_PLAYER_MAX do
		if chairMan == i then
			SetPlayerIsFirstCircle(i, 1)
		else
			SetPlayerIsFirstCircle(i, 255)
		end
	end
--[[
	local chairManHand = GetPlayerHand(chairMan)
	for k, v in pairs(chairManHand) do
		if v > 0 then
			chairManHand[k] = chairManHand[k] - 1
			SetCurOperateCard(k)
			SetChairManOperateCard(chairMan, k)
			SetPlayerHand(chairMan, chairManHand)
			break
		end
	end
--]]
	SynAllLack()

	for i = 1, CONST_PLAYER_MAX do
		if GetPlayerCash(i) <= 0 then
			SinglePlayerLost(i)
		end
	end

	if not (GetTableMgrState() == CONST_TABLE_STATE_END_GAME) then
		local result = 0
		result = CheckOperateMaskForSingle(chairMan, chairMan, false, maskData, gangData)
		SetPlayerOperateMask(chairMan, maskData, false)
		SetPlayerGangOperate(chairMan, gangData)
		if result > 0 then
			SendMsg2Client(chairMan, PLAYER_OPERATE_SYN_OPERATE_MASK, result, GetCurOperateCard(), 0)
			SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_OPERATE)
			SetTimer(CONST_TABLE_STATE_WAIT_OPERATE, chairMan, 0)
		else
			SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_CS_SEND)
			SetTimer(CONST_TABLE_STATE_WAIT_CS_SEND, chairMan, 0)
		end
	end
end

function PreExchange(nPlayerIndex, hand)
	--set ExchangeCard for all players
	local score = {[0] = 0, [1] = 0, [2] = 0}
	local color = -1
	local minScore = 255
	local exchangeCard = {}

	if WRITE_LOG then
		for m,n in pairs(hand) do
			--	Log(tostring(" 推荐玩家：" .. i .. " 手牌: " .. string.format("%#x", m) .. " : " .. n))
			Log(string.format(GetEditorString(17, 143), nPlayerIndex, m, n))
		end
	end
		
	local offset = 0
	for j = 0, 2 do
		offset = j * 0x10
		for k = 1, 9 do
			score[j] = score[j] + hand[offset + k]
		end
		if score[j] > 2 then
			for k = 1, 9 do
				if hand[offset + k] > 1 then
					score[j] = score[j] + hand[offset + k] * (hand[offset + k] - 1) / 2
				end
			end
			if minScore > score[j] then
				color = j
				minScore = score[j]
			end
		end
	end
--		Log(tostring(" 分数：" .. score[0] .. " | " .. score[1] .. " | " .. score[2] .. " | " .. " min: " .. minScore .. " color: " .. color))
	offset = color * 0x10
--		Log(tostring(" offset：" .. offset))

	--TODO:分析牌型 优先给最少数字的
	local analysisTable = {[1] = {}, [2] = {}, [3] = {}, [4] = {}}
	for k = 1,9 do
		if hand[offset + k] > 0 then
			table.insert(analysisTable[hand[offset + k]], offset + k)
			if WRITE_LOG then
				--	Log(tostring("换牌数组分析： " .. hand[offset + k] .. "|" .. offset + k))
				Log(string.format(GetEditorString(17, 322), hand[offset + k], offset + k))
			end
		end
	end

	local id = 1
	for j = 1, 4 do
		if id > 3 then
			break
		end
		for i = 1, j do
			if id > 3 then
				break
			end
			for k, v in pairs(analysisTable[j]) do
				exchangeCard[id] = v
				id = id + 1
				if id > 3 then
					break
				end
			end
		end
	end

--		Log(tostring(" id: " .. id .. " sycle: " .. sycle))
	SetPlayerExchangeCard(nPlayerIndex, exchangeCard[1], exchangeCard[2], exchangeCard[3])
	SendMsg2Client(nPlayerIndex, PLAYER_OPERATE_PRE_EXCHANGE, exchangeCard[1], exchangeCard[2], exchangeCard[3])
--		PrintChatMsg("推荐玩家:" .. i .. "换牌: " .. string.format("%#x", exchangeCard[1]) .. ", " .. string.format("%#x", exchangeCard[2]) .. ", " .. string.format("%#x", exchangeCard[3]))
	if WRITE_LOG then
		PrintChatMsg(string.format(GetEditorString(17, 145), nPlayerIndex, exchangeCard[1], exchangeCard[2], exchangeCard[3]))
	end
--		miniGameMgr1.Operate(i - 1, PLAYER_OPERATE_PRE_EXCHANGE, exchangeCard[1], exchangeCard[2], exchangeCard[3])
	SetPlayerOperateCount(-1, 1)
end

--[[
function PreExchange()
	--set ExchangeCard for all players
	for i = 1, CONST_PLAYER_MAX do
		local hand = GetPlayerHand(i)
		local score = {[0] = 0, [1] = 0, [2] = 0}
		local color = -1
		local minScore = 255
		local exchangeCard = {}

		if WRITE_LOG then
			for m,n in pairs(hand) do
			--	Log(tostring(" 推荐玩家：" .. i .. " 手牌: " .. string.format("%#x", m) .. " : " .. n))
				Log(string.format(" 推荐玩家：%d 手牌: %#x, count: %d", i, m, n))
			end
		end
		
		local offset = 0
		for j = 0, 2 do
			offset = j * 0x10
			for k = 1, 9 do
				score[j] = score[j] + hand[offset + k]
			end
			if score[j] > 2 then
				for k = 1, 9 do
					if hand[offset + k] > 1 then
						score[j] = score[j] + hand[offset + k] * (hand[offset + k] - 1) / 2
					end
				end
				if minScore > score[j] then
					color = j
					minScore = score[j]
				end
			end
		end
--		Log(tostring(" 分数：" .. score[0] .. " | " .. score[1] .. " | " .. score[2] .. " | " .. " min: " .. minScore .. " color: " .. color))
		offset = color * 0x10
--		Log(tostring(" offset：" .. offset))

		--TODO:分析牌型 优先给最少数字的
		local analysisTable = {[1] = {}, [2] = {}, [3] = {}, [4] = {}}
		for k = 1,9 do
			if hand[offset + k] > 0 then
				table.insert(analysisTable[hand[offset + k] ], offset + k)
				if WRITE_LOG then
				--	Log(tostring("换牌数组分析： " .. hand[offset + k] .. "|" .. offset + k))
					Log(string.format("换牌数组分析：hand[offset + k]: %d, (offset + k): %d", hand[offset + k], offset + k))
				end
			end
		end

		local id = 1
		for j = 1, 4 do
			if id > 3 then
				break
			end
			for i = 1, j do
				if id > 3 then
					break
				end
				for k, v in pairs(analysisTable[j]) do
					exchangeCard[id] = v
					id = id + 1
					if id > 3 then
						break
					end
				end
			end
		end

--		Log(tostring(" id: " .. id .. " sycle: " .. sycle))
		SetPlayerExchangeCard(i, exchangeCard[1], exchangeCard[2], exchangeCard[3])
		SendMsg2Client(i, PLAYER_OPERATE_PRE_EXCHANGE, exchangeCard[1], exchangeCard[2], exchangeCard[3])
--		PrintChatMsg("推荐玩家:" .. i .. "换牌: " .. string.format("%#x", exchangeCard[1]) .. ", " .. string.format("%#x", exchangeCard[2]) .. ", " .. string.format("%#x", exchangeCard[3]))
		PrintChatMsg(string.format("推荐玩家: %d, 换牌: %#x, %#x, %#x", i, exchangeCard[1], exchangeCard[2], exchangeCard[3]))
--		miniGameMgr1.Operate(i - 1, PLAYER_OPERATE_PRE_EXCHANGE, exchangeCard[1], exchangeCard[2], exchangeCard[3])
	end
	SetPlayerOperateCount(-1, 1)
end
--]]

function PreLack()
	--setLack for all players
	for i = 1, CONST_PLAYER_MAX do

		local hand = GetPlayerHand(i)
		local score = {[0] = 0, [1] = 0, [2] = 0}
		local minScore = 255
		
		local minScore = 255
		local color = -1
		for j = 0, 2 do
			for k = 1, 9 do
				score[j] = score[j] + hand[j * 0x10 + k]
				if hand[j * 0x10 + k] > 1 then
					score[j] = score[j] + hand[j * 0x10 + k] * (hand[j * 0x10 + k] - 1) / 2
				end
			end
			if minScore > score[j] then
				color = j
				minScore = score[j]
			end
		end
		SetPlayerLack(i, color)
		SendMsg2Client(i, PLAYER_OPERATE_PRE_LACK, color, 0, 0)
--		miniGameMgr1.Operate(i - 1, PLAYER_OPERATE_PRE_LACK, color)
		--	PrintChatMsg("推荐玩家:" .. i .. "定缺: " .. color)
		if WRITE_LOG then
			PrintPlayerHands(i)
			PrintChatMsg(string.format(GetEditorString(17, 146), i,  color))
		end
	end
	SetPlayerOperateCount(-1, 1)
end

function OnNoCostOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
	nPlayerIndex = nPlayerIndex + 1
	if WRITE_LOG then
		--	Log(tostring("收消息: 不扣次数: " .. nPlayerIndex .. ":" .. nValue1 .. ":" .. nValue2 .. ":" .. nValue3 .. ":" .. nValue4))
		Log(string.format(GetEditorString(17, 147), nPlayerIndex, nValue1, nValue2, nValue3, nValue4))
	end

	if DEBUG_MAHJONG then
		if nValue1 == PLAYER_OPERATE_DEBUG_PEEP_OTHER_HAND then
			if nValue2 < 1 or nValue2 > 4 then
				return
			end
--		SetPlayerDebugPeepHand(nValue2)
--		SendMsg2Client(nPlayerIndex, PLAYER_OPERATE_DEBUG_PEEP_OTHER_HAND, nValue2, 0, 0)
			PeepHand(nValue2)
			return
		end
		
		if nValue1 == PLAYER_OPERATE_STEAL_CARD then
			if not (CheckLegalCardValue(nValue2) and CheckLegalCardValue(nValue3))then
				if WRITE_LOG then
					--	PrintChatMsg("牌值非法 playerIndex: " .. nPlayerIndex .. "操作：" .. nValue1 .. " card:" .. nValue2 .. " card:" .. nValue3)
					PrintChatMsg(string.format(GetEditorString(17, 148), nPlayerIndex, nValue1, nValue2, nValue3))
				end
				SendMsg2Client(nPlayerIndex, PLAYER_OPERATE_ERROR, nPlayerIndex, ERROR_CODE_PLAYER_CARD_VALUE_INLEGAL, nValue2)
				SendMsg2Client(nPlayerIndex, PLAYER_OPERATE_ERROR, nPlayerIndex, ERROR_CODE_PLAYER_CARD_VALUE_INLEGAL, nValue3)
				return --cheat
			end
			ServerOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
			return
		end

		if nValue1 == PLAYER_OPERATE_DEBUG_SET_PLAYER_DATA then
			--	if nValue2 < 1 or nValue2 > 4 then
			--		return
			--	end
			if nValue3 == CONST_PLAYER_CASH then
				local tempCash = GetPlayerCash(nValue2)
				SetPlayerCash(nValue2, nValue4)
				SendMsg2Client( - 1, PLAYER_OPERATE_SYN_CASH, nValue2, nValue4, nValue4 - tempCash)
				--------------法务意见：删除雀神点数--------------
				--elseif nValue3 == CONST_PLAYER_CASH_HONOR then
				--	ModifyPlayerCashHonor(nValue2, nValue4)
				--------------法务意见：删除雀神点数--------------
				--[[
			elseif nValue3 == CONST_PLAYER_HIDE_SCORE then
				local tempHideScore = GetPlayerHideScore(nValue2)
				SetPlayerHideScore(nValue2, nValue4)
			elseif nValue3 == CONST_PLAYER_SHAPE then
				SetPlayerShape(nValue2, nValue4)
			--]]
			elseif nValue3 == CONST_PLAYER_ACCENT then
				SetPlayerAccent(nValue2, nValue4)
			elseif nValue3 == CONST_PLAYER_AGENT then
				if GetPlayerIsLockTing(nValue2) == 1 then
					return
				end
				SetPlayerIsAgent(nValue2, nValue4)
				SendMsg2Client( - 1, PLAYER_OPERATE_SET_AGENT, nValue2, nValue4, 0)
			elseif nValue3 == CONST_PAUSE then
				local isPause = GetIsMiniGamePause()
				SetIsMiniGamePause(nValue4)
				if isPause == 1 and nValue4 == 0 then --解除pause
					local miniGameParam = GetMiniGameTimerParam()
					if miniGameParam[1] > 0 then
						OnMiniGameTimer(miniGameParam[1], miniGameParam[2])
					end
				elseif isPause == 0 and nValue4 == 1 then --设置pause
					SetMiniGameTimerParam(0, 0)
				end
			elseif nValue3 == CONST_RESTART_GAME then
				for i = 1, CONST_PLAYER_MAX do
					WritePlayerMahjongDatas(i)
				end
				InitTableMgr()
			elseif nValue3 == CONST_FAST_END then
				SetCurCardPtr(CONST_CARDS_NUM)
			elseif nValue3 == CONST_GUANXING then
				StealCardGuanxing(nValue2, nValue4)
			end
		end
	end
	
	if nValue1 == PLAYER_OPERATE_SET_AGENT then
		if GetPlayerIsLockTing(nPlayerIndex) == 1 then
			return
		end
		if nValue2 > 1 then
			nValue2 = 1
		elseif
			nValue2 < 0 then
			nValue2 = 0
		end
		SetPlayerIsAgent(nPlayerIndex, nValue2)
		SendMsg2Client( - 1, PLAYER_OPERATE_SET_AGENT, nPlayerIndex, nValue2, 0)
		if nValue2 == 1 then
			--	PrintChatMsg("玩家: " .. nPlayerIndex .. "挂机")
			if WRITE_LOG then
				PrintChatMsg(string.format(GetEditorString(17, 149), nPlayerIndex))
			end
		else
			--	PrintChatMsg("玩家: " .. nPlayerIndex .. "取消挂机")
			if WRITE_LOG then
				PrintChatMsg(string.format(GetEditorString(17, 150), nPlayerIndex))
			end
		end
		return
	end

	if nValue1 == PLAYER_OPERATE_SET_ACCENT then
		
		if nValue2 >= 0 and nValue2 <= #tSound then
			SetPlayerAccent(nPlayerIndex, nValue2)
		end
	
		if WRITE_LOG then
			local playerdwID = GetPlayerDWID(nPlayerIndex)
			Log(string.format("GetPlayerDWID: nPlayerIndex: %d, dwID: %d", nPlayerIndex, playerdwID))
			if not (playerdwID == nil) then
				local player = GetPlayer(playerdwID)
				if not (player == nil) then
					--	Log(tostring("玩家语音: " .. nValue2 .. " 体型: " .. player.nRoleType))
					Log(string.format(GetEditorString(17, 323), nValue2, player.nRoleType, #tSound))
				else
					--	Log("player: id: " .. nPlayerIndex .. " is " .. tostring(player))
					Log(string.format("player: id: %d is nil", nPlayerIndex))
				end
			end
		end
		
		return
	end
	
	if nValue1 == PLAYER_OPERATE_SYN_CUR_CARD then
		local tableMgr = GetTableMgrState()
		local curCard = GetCurOperateCard()
		local curPlayer = GetCurOperatePlayer()
		local card = 0
		if tableMgr == CONST_TABLE_STATE_WAIT_OPERATE or tableMgr == CONST_TABLE_STATE_WAIT_OPERATE_COMBO then
			card = curCard
		elseif (tableMgr == CONST_TABLE_STATE_WAIT_CS_SEND or tableMgr == CONST_TABLE_STATE_WAIT_CS_SEND_1) and nPlayerIndex == curPlayer then
			card = curCard
		end
		if WRITE_LOG then
			Log(string.format(GetEditorString(17, 1182), tableMgr, curCard, curPlayer, nPlayerIndex, card))
		end
		SendMsg2Client(nPlayerIndex, PLAYER_OPERATE_SYN_CUR_CARD, curPlayer, card, tableMgr) 
		return
	end

	if nValue1 == PLAYER_OPERATE_HEART_BEAT then
		if WRITE_LOG then
			--	Log(tostring("heart beat: nPlayerIndex: " .. nPlayerIndex))
			Log(string.format("heart beat: nPlayerIndex: %d", nPlayerIndex))
		end
		return
	end

	if nValue1 == PLAYER_OPERATE_CLOSE_UI then
		if WRITE_LOG then
			--	Log(tostring("heart beat: nPlayerIndex: " .. nPlayerIndex))
			Log(string.format("closeUI: %d", nPlayerIndex))
		end
		--[[
		if GetTableMgrState() == CONST_TABLE_STATE_END_GAME then
			if WRITE_LOG then
				Log(string.format("玩家: %d 离开 麻将结束", nPlayerIndex))
			end
			miniGameMgr1.EndGame()
		end
		--]]
		return
	end
end

function OnNoCheckOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
	OnNoCostOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
end

function OnServerOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
	nPlayerIndex = nPlayerIndex + 1
	if WRITE_LOG then
		--	Log(tostring("收消息: 扣次数: " .. nPlayerIndex .. ":" .. nValue1 .. ":" .. nValue2 .. ":" .. nValue3 .. ":" .. nValue4))
		Log(string.format(GetEditorString(17, 152), nPlayerIndex, nValue1, nValue2, nValue3, nValue4))
	end
	OnServerOperateLogic(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
end

function OnServerOperateLogic(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
	local tableMgrState = GetTableMgrState()
	if WRITE_LOG then
		PrintPlayerHands(nPlayerIndex)
	end
	if WRITE_LOG then
		--	Log(tostring("OnServerOperateLogic: 扣次数: " .. nPlayerIndex .. ":" .. nValue1 .. ":" .. nValue2 .. ":" .. nValue3 .. ":" .. nValue4))
		Log(string.format(GetEditorString(17, 1563), nPlayerIndex, nValue1, nValue2, nValue3, nValue4))
	end
--	if nValue1 == PLAYER_OPERATE_SHUFFLE_CARD then
	if nValue1 == PLAYER_OPERATE_DICE then
		if not (tableMgrState == CONST_TABLE_STATE_INIT or tableMgrState == CONST_TABLE_STATE_END_GAME or tableMgrState == CONST_TABLE_STATE_KILL_MAHJONG) then
			return
		end
		InitTableMgr()
		return
	end
	
	if nValue1 == PLAYER_OPERATE_EXCHANGE then
		if not (tableMgrState == CONST_TABLE_STATE_EXCHANGE) then
			return
		end
		local badExchange = false
		local handCardForExchange = GetPlayerHand(nPlayerIndex)
		if not (CheckLegalCardValue(nValue2) and CheckLegalCardValue(nValue3) and CheckLegalCardValue(nValue4)) then
			badExchange = true
		end

		if not badExchange then
			if handCardForExchange[nValue2] < 1 or handCardForExchange[nValue2] > 4  then
				badExchange = true
			elseif handCardForExchange[nValue3] < 1 or handCardForExchange[nValue3] > 4  then
				badExchange = true
			elseif handCardForExchange[nValue4] < 1 or handCardForExchange[nValue4] > 4  then
				badExchange = true
			end
		end

		local color1 = GetColorFromCard(nValue2)
		local color2 = GetColorFromCard(nValue3)
		local color3 = GetColorFromCard(nValue4)

		if not (color1 == color2 and color2 == color3) then
			badExchange = true
		end

		if badExchange then
			SendMsg2Client(nPlayerIndex, PLAYER_OPERATE_EXCHANGE_CONFIRM, 0, 0, 0)
			return
		end
		
		SetPlayerExchangeCard(nPlayerIndex, nValue2, nValue3, nValue4)
		SetPlayerHaveCommitExchange(nPlayerIndex, 1)
		handCardForExchange[nValue2] = handCardForExchange[nValue2] - 1
		handCardForExchange[nValue3] = handCardForExchange[nValue3] - 1
		handCardForExchange[nValue4] = handCardForExchange[nValue4] - 1
		SetPlayerHand(nPlayerIndex, handCardForExchange)
		
		SendMsg2Client(nPlayerIndex, PLAYER_OPERATE_EXCHANGE_CONFIRM, nValue2, nValue3, nValue4)
		
		local mask = GetExchangePlayers()
		--	mask = SetDataWithFlagN(mask, 1, nPlayerIndex - 1)
		mask = SetFlagN(mask, nPlayerIndex - 1)
		if mask == 0x0F then
			--TODO:all commited
			ExchangeAllCard()
			--TODO:preLack
			PreLack()
		else
			SetExchangePlayers(mask)
		end
		return
	end

	if nValue1 == PLAYER_OPERATE_SET_LACK then
		if not (tableMgrState == CONST_TABLE_STATE_SET_LACK) then
			return
		end
		if nValue2 == 0 or nValue2 == 1 or nValue2 == 2 then
			SetPlayerLack(nPlayerIndex, nValue2)
			local mask = GetLackPlayers()
			--	mask = SetDataWithFlagN(mask, 1, nPlayerIndex - 1)
			mask = SetFlagN(mask, nPlayerIndex - 1)
			if mask == 0x0F then
--				SynAllLack() --在StartRealGame()里调用
				StartRealGame()
			else
				SetLackPlayers(mask)
			end
		end
		return
	end

	local saveOperateTable = {true}
	local operateCode = CheckCanOperate(nPlayerIndex, nValue1, nValue2, saveOperateTable)
	
	if WRITE_LOG then
		--	Log(tostring("检测操作类型 operateCode: " .. operateCode .. " 参数：" .. nPlayerIndex .. "|" .. nValue1 .. "|" .. nValue2 .. "|" .. tostring(saveOperateTable[1])))
		Log(string.format(GetEditorString(17, 153), operateCode, nPlayerIndex, nValue1, nValue2, tostring(saveOperateTable[1])))
	end

	if nValue1 <= PLAYER_OPERATE_HU and (not (operateCode == CONST_CHECK_OPERATE_CODE_FAIL))then
		local maskData = {}
		SetPlayerOperateMask(nPlayerIndex, maskData, true)
		local gangData = {}
		SetPlayerGangOperate(nPlayerIndex, gangData)
		SendMsg2Client(nPlayerIndex, PLAYER_OPERATE_SYN_OPERATE_MASK, 0, nValue2, 0)
		SetPlayerOverTimeCount(nPlayerIndex, 0)
	end
	
	if operateCode == CONST_CHECK_OPERATE_CODE_SEND_STEAL then --only for sendCard
		ServerOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
	elseif operateCode == CONST_CHECK_OPERATE_CODE_OPERATE_WAIT then --需要等待其他玩家
		--operate定时
		--	GetScene(MemSceneID).SetTimer(TIMER_CS_OPERATE_WAIT * GLOBAL.GAME_FPS, "scripts/Map/家园系统/miniGame/majhong/xueliuchenghe1/xueliuchengheTableMgr.lua", TIMER_CS_OPERATE_WAIT, 0)
		SetTimer(CONST_TABLE_STATE_WAIT_OPERATE_COMBO, - 1, 0)
		if saveOperateTable[1] then
			RecordOperateMsg(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
		end
	elseif operateCode == CONST_CHECK_OPERATE_CODE_OPERATE_NOW then
		if nPlayerIndex == GetCurOperatePlayer() and nValue1 == PLAYER_OPERATE_JUMP then
			--自己跳过，强行设置还是自己操作
			SetCurOperatePlayer(nPlayerIndex)
			--	PrintChatMsg("设置操作玩家:" .. nPlayerIndex .. " --自己跳过")
			if WRITE_LOG then
				PrintChatMsg(string.format(GetEditorString(17, 154), nPlayerIndex))
			end
			SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_CS_SEND)
			SetTimer(CONST_TABLE_STATE_WAIT_CS_SEND, nPlayerIndex, 0)
		else
			if saveOperateTable[1] then
				RecordOperateMsg(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
			end
			ExecutRecordMsgAndChangeState()
		end

		--------------慧姐改这里----------------
		--TODO: 这里清理所有玩家的OperateMask
		return operateCode
		--------------慧姐改这里----------------
	end
	if WRITE_LOG then
--		Log(tostring("====== OnClientOperate: nPlayerIndex: " .. nPlayerIndex .. " nValue1: " .. nValue1 .. " nValue2: " .. nValue2 .. " nValue3: " .. nValue3 .. "======="))
		Log(string.format("====== OnClientOperate: nPlayerIndex: %d, nValue1: %d, nValue2: %d, nValue3: %d =======", nPlayerIndex, nValue1, nValue2, nValue3))
		PrintPlayerHands(nPlayerIndex)
		Log("==========================")
	end
end

--TIMER_CS_SENDCARD = 20
--TIMER_CS_OPERATE = 15
--TIMER_CS_OPERATE_WAIT = 10
function ExecutRecordMsgAndChangeState()
	local executResult = ExecuteRecordMsg()
	if WRITE_LOG then
		--	Log(tostring("操作结果: executResult: " .. executResult))
		Log(string.format(GetEditorString(17, 89), executResult))
	end
	local tableState = GetTableMgrState()
	if tableState == CONST_TABLE_STATE_END_GAME then
		-- 三家起立
		return
	end
	local curPlayer = 0
	if executResult == -CONST_EXE_RESULT_JUMP then --过牌
		--进入弃牌区
		curPlayer = GetCurOperatePlayer()
		local curOperateCard = GetCurOperateCard()
		--	SetAbandonCard(tMemPlayerData[CUR_PLAYER], tMemPlayerCards[CUR_OPERATE_CARD])
		SetAbandonCard(curPlayer, curOperateCard)
	end
	curPlayer = NextPlayer(executResult)
	if executResult == -CONST_EXE_RESULT_PENG then --碰牌等待玩家出牌
		--出牌定时
		SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_CS_SEND)
		SetTimer(CONST_TABLE_STATE_WAIT_CS_SEND, curPlayer, 0)
		--[[	
		local maskData = {}
		local gangData = {}
		local result = CheckOperateMaskForSingle(curPlayer, curPlayer, false, maskData, gangData)
		if result > 0 then
			SetPlayerOperateMask(curPlayer, maskData, false)
			SetPlayerGangOperate(curPlayer, gangData)
			SendMsg2Client(curPlayer, PLAYER_OPERATE_SYN_OPERATE_MASK, result, GetCurOperateCard(), 0)
			SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_OPERATE)
			SetTimer(CONST_TABLE_STATE_WAIT_OPERATE, curPlayer, false)
		else
			SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_CS_SEND)
			SetTimer(CONST_TABLE_STATE_WAIT_CS_SEND, curPlayer, false)
		end
	--]]
	else
		SendCard()
	end
end

--TODO: 换掉计时器
--function TickTableMgrTimer()
--	--获取倒计时时间，未到直接return
--	if GetTableMgrState() == CONST_TABLE_STATE_WAIT_CS_SEND then
--		if tMemPlayerCards[CUR_OPERATE_CARD] > 0 then
--			print("TickTableMgrTimer() 出掉抓牌")
--			ServerOperate(tMemPlayerData[CUR_PLAYER], PLAYER_OPERATE_CS_SEND, tMemPlayerCards[CUR_OPERATE_CARD], 0, 0)
--		else
--			print("TickTableMgrTimer() 出掉lack")
--			local lackCard = 0
--			local maxCard = 0
--			for color = 0x00, 0x20, 0x10 do
--				for card = color + 0x01, color + 0x09 do
--					if tMemPlayerCards[tMemPlayerData[CUR_PLAYER]][DATA_IN_HAND][card] > 0 then
--						maxCard = card
--						if color == tMemPlayerCards[tMemPlayerData[CUR_PLAYER]][LACK] * 0x10 then
--							lackCard = card
--						end
--					end
--				end
--			end
--			if lackCard > 0 then
--				ServerOperate(tMemPlayerData[CUR_PLAYER], PLAYER_OPERATE_CS_SEND, lackCard, 0, 0)
--			elseif maxCard > 0 then
--				ServerOperate(tMemPlayerData[CUR_PLAYER], PLAYER_OPERATE_CS_SEND, maxCard, 0, 0)
--			end
--		end
--		return
--	end
--
--	if GetTableMgrState() == CONST_PLAYER_STATE_WAIT_OPERATE then
--		print("TickTableMgrTimer() 操作Operate")
--		ExecuteRecordMsg()
--		return
--	end
--end

function AutoCSSendCard(nPlayerIndex)
	local curOperateCard = GetCurOperateCard()
--	if isAgentBool then
--		if DEBUG_MAHJONG then
--			print("AutoSendCard() 出掉抓牌 isAgent: " .. tostring(isAgentBool) .. " card: " .. curOperateCard)
--		end
--		ServerOperate(nPlayerIndex, PLAYER_OPERATE_CS_SEND, curOperateCard, 0, 0)
--	else
	local handCards = GetPlayerHand(nPlayerIndex)
	local lack = GetPlayerLack(nPlayerIndex)
	local lackCard = 0
	local maxCard = 0
	for color = 0x00, 0x20, 0x10 do
		for card = color + 0x01, color + 0x09 do
			if handCards[card] > 0 then
				maxCard = card
				if color == lack * 0x10 then
					lackCard = card
				end
			end
		end
	end
	if lackCard > 0 then
		ServerOperate(nPlayerIndex, PLAYER_OPERATE_CS_SEND, lackCard, 0, 0)
	elseif curOperateCard > 0 then
		ServerOperate(nPlayerIndex, PLAYER_OPERATE_CS_SEND, curOperateCard, 0, 0)
	elseif maxCard > 0 then
		ServerOperate(nPlayerIndex, PLAYER_OPERATE_CS_SEND, maxCard, 0, 0)
	end
--	end
end

function AutoOperateForSingle(nPlayerIndex)
	local operateCode = CONST_CHECK_OPERATE_CODE_FAIL
	if GetPlayerOperateCount(nPlayerIndex) > 0 then
		local isLockTing = GetPlayerIsLockTing(nPlayerIndex)
		local isAgent = GetPlayerIsAgent(nPlayerIndex)
		local maskData = GetPlayerOperateMask(nPlayerIndex)
		--	if isLockTing == 1 then
		if isAgent == 1 then
			if maskData[PLAYER_OPERATE_HU] > 0 then --能胡立刻胡
				local curOperateCard = GetCurOperateCard()
				if curOperateCard > 0 then
					operateCode = OnServerOperateLogic(nPlayerIndex, PLAYER_OPERATE_HU, curOperateCard, 0, 0) 
				end
			elseif isLockTing == 1 and maskData[PLAYER_OPERATE_MING_GANG] > 0 then --能杠立刻杠
				local gangData = GetPlayerGangOperate(nPlayerIndex)
				local gangSuccess = false
				for k, v in pairs(gangData) do
					if CheckLegalCardValue(k) then
						operateCode = OnServerOperateLogic(nPlayerIndex, v, k, 0, 0)
						gangSuccess = true
						break
					end
				end

				if not gangSuccess then
					operateCode = AutoJump(nPlayerIndex, maskData)
				end
			else
				operateCode = AutoJump(nPlayerIndex, maskData)
			end
		else
			operateCode = AutoJump(nPlayerIndex, maskData)
		end				
	end
	return operateCode
end

function AutoJump(nPlayerIndex, maskData)
	local operateCode = CONST_CHECK_OPERATE_CODE_FAIL
	if maskData[PLAYER_OPERATE_JUMP] > 0 then
		local overTimeCount = GetPlayerOverTimeCount(nPlayerIndex)
		--	Log(tostring("关闭autoOperate 跳过"))
		operateCode = OnServerOperateLogic(nPlayerIndex, PLAYER_OPERATE_JUMP, 0, 0, 0)
		SetPlayerOverTimeCount(nPlayerIndex, overTimeCount)
	end
	return operateCode
end

function AutoOperate(nPlayerIndex)
	local tableMgrState = GetTableMgrState()
	if WRITE_LOG then
		--	Log(tostring("自动操作: nPlayerIndex " .. nPlayerIndex .. " isAgentBool: " .. tostring(isAgentBool) .. " tableMgrState: " .. tableMgrState))
		Log(string.format(GetEditorString(17, 90), nPlayerIndex, tostring(isAgentBool), tableMgrState))
	end
	if not (tableMgrState == CONST_TABLE_STATE_WAIT_OPERATE or tableMgrState == CONST_TABLE_STATE_WAIT_OPERATE_COMBO) then
		return 
	end
	if nPlayerIndex == -1 then
		local operateCode = CONST_CHECK_OPERATE_CODE_FAIL
		for i = 1, CONST_PLAYER_MAX do
			if operateCode == CONST_CHECK_OPERATE_CODE_OPERATE_NOW then
				break
			else
				operateCode = AutoOperateForSingle(i)
			end
		end
	else
		AutoOperateForSingle(nPlayerIndex)
	end
end

function OnMiniGameTimer(nValue1, nValue2)
	--[[
	local isAgent = false
	if nValue2 > 0 and nValue2 < 5 then
		if GetPlayerIsAgent(nValue2) == 1 then
			isAgent = true
		end
	end
	--]]
	if	WRITE_LOG then
		--	Log(tostring("************ 时间到：" .. nValue1 .. " | " .. nValue2 .. " ************"))
		Log(string.format(GetEditorString(17, 1176), nValue1, nValue2))
	end
	if DEBUG_MAHJONG then
		local isPause = GetIsMiniGamePause()
		if isPause == 1 then
			SetMiniGameTimerParam(nValue1, nValue2)
			return
		end
	end

	if nValue1 == CONST_TABLE_STATE_INIT then
		if WRITE_LOG then
			Log("************ init game ************")
		end
		SetPlayerOperateCount(-1, 1)
--[[
	local bRetCode = false
	bRetCode = miniGameMgr1.ChangePlayerOperateCount(0, 1)
	print("miniGameMgr1.ChangePlayerOperateCount(0, 1): " .. tostring(bRetCode))
	bRetCode = miniGameMgr1.ChangePlayerOperateCount(1, 1)
	print("miniGameMgr1.ChangePlayerOperateCount(1, 1): " .. tostring(bRetCode))
	bRetCode = miniGameMgr1.ChangePlayerOperateCount(2, 1)
	print("miniGameMgr1.ChangePlayerOperateCount(2, 1): " .. tostring(bRetCode))
	bRetCode = miniGameMgr1.ChangePlayerOperateCount(3, 1)
	print("miniGameMgr1.ChangePlayerOperateCount(3, 1): " .. tostring(bRetCode))
--]]
--		SetCashBase(10) --TODO: 临时设置的底分
		local aliveData = {1, 1, 1, 1}
		SetPlayerAliveAll(aliveData)
		--InitTableMgr()
		--OnServerOperate(1, PLAYER_OPERATE_DICE, 0, 0, 0)
	
		--TODO: 读入玩家数据
		InitTableMgr()
		--	miniGameMgr1.EndGame()
	elseif nValue1 == CONST_TABLE_STATE_WAIT_CS_SEND then
		SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_CS_SEND_1)
		SetTimer(CONST_TABLE_STATE_WAIT_CS_SEND_1, nValue2, 0)
		PlayPlayerSound(-1, PLAYER_OPERATE_WAIT, nValue2, 0, 0)
	elseif nValue1 == CONST_TABLE_STATE_WAIT_CS_SEND_1 then
--		GetPlayerHandPure(nValue2)
		--	AutoCSSendCard(nValue2, isAgent)
		AutoCSSendCard(nValue2)
		if nValue2 > 0 and nValue2 <= CONST_PLAYER_MAX then
			local overTimeCount = GetPlayerOverTimeCount(nValue2)
			overTimeCount = overTimeCount + 1
			if WRITE_LOG then
				--	Log(tostring("玩家：" .. nValue2 .. " overTimeCount: " .. overTimeCount))
				Log(string.format(GetEditorString(17, 92), nValue2, overTimeCount))
			end
			if overTimeCount >= 2 then
				overTimeCount = 0
				if WRITE_LOG then
					--	Log(tostring("设置玩家：" .. nValue2 .. " 挂机"))
					Log(string.format(GetEditorString(17, 93), nValue2))
				end
				SetPlayerIsAgent(nValue2, 1)
				SendMsg2Client( - 1, PLAYER_OPERATE_SET_AGENT, nValue2, 1, 0)
			end
			SetPlayerOverTimeCount(nValue2, overTimeCount)
		end
--		GetPlayerHandPure(nValue2)
	elseif nValue1 == CONST_TABLE_STATE_WAIT_CS_SEND_AGENT then
		--	AutoCSSendCard(nValue2, isAgent)
		AutoCSSendCard(nValue2)
	elseif nValue1 == CONST_TABLE_STATE_WAIT_OPERATE then
		--	AutoOperate(nValue2, isAgent)
		AutoOperate(nValue2)
		--[[
		if nValue2 == -1 then
			for i = 1, CONST_PLAYER_MAX do
				if GetPlayerIsAgent(i) == 1 then
					AutoOperate(i, true)
				end
			end
			AutoOperate( - 1, false)
		else
--			GetPlayerHandPure(nValue2)
--			AutoCSSendCard(nValue2, isAgent)
			if GetPlayerIsAgent(nValue2) == 1 then
				AutoOperate(nValue2, true)
			else
				SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_CS_SEND)
				SetTimer(CONST_TABLE_STATE_WAIT_CS_SEND, nValue2, false)
			end
			local maskData = {}
			SetPlayerOperateMask(nValue2, maskData, true)
			local gangData = {}
			SetPlayerGangOperate(nValue2, gangData)
			SendMsg2Client(nValue2, PLAYER_OPERATE_SYN_OPERATE_MASK, 0, GetCurOperateCard(), 0)
			
--			GetPlayerHandPure(nValue2)
		end
--		ExecuteRecordMsg()
		--]]
	elseif nValue1 == CONST_TABLE_STATE_WAIT_OPERATE_COMBO then
		--	AutoOperate( - 1, isAgent)
		AutoOperate(-1)
--		ExecuteRecordMsg()
	elseif nValue1 == CONST_TABLE_STATE_EXCHANGE then
		
--		for i = 1, CONST_PLAYER_MAX do
--			if GetPlayerHaveCommitExchange(i) == 0 then
--				Log(tostring("XXXXX GetPlayerHaveCommitExchange(i) == 0 | i: " .. i))
--				local handCardForExchange = GetPlayerHand(i)
--				local exchangeCards = GetPlayerExchangeCard(i)
--				handCardForExchange[exchangeCards[1]] = handCardForExchange[exchangeCards[1]] - 1
--				handCardForExchange[exchangeCards[2]] = handCardForExchange[exchangeCards[2]] - 1
--				handCardForExchange[exchangeCards[3]] = handCardForExchange[exchangeCards[3]] - 1
--
--				SetPlayerHand(i, handCardForExchange)
--			end
--		end
		
		ExchangeAllCard()
		PreLack()
	elseif nValue1 == CONST_TABLE_STATE_SET_LACK then
--		SynAllLack() --在StartRealGame()里调用
		StartRealGame()
	elseif nValue1 == CONST_TABLE_STATE_END_GAME then
		if DEBUG_FOR_YALI_TEST then
			Log(GetEditorString(16, 9862))
		end
		miniGameMgr1.EndGame()
--		MgrEndGame()
		--TODO: 初始化牌桌，设置状态
	end
--	SetTimer(-1, -1)
end

--=======================================
--TODO: 临时代码 要删掉！！！
--[[
MemSceneID = 0
function SetScene(dwID)
	MemSceneID = dwID
end
PlayerID = 0
function SetPlayer(dwID)
	PlayerID = dwID
end
--]]
--=======================================

function CheckAlive(nPlayerIndex, aliveData)
	if nPlayerIndex < 1 or nPlayerIndex > 4 then
		return false
	end
	return (aliveData[nPlayerIndex] == 1)
end

function ReturnMoney()
	--处理结算后最后一张牌会显示在下家的手牌中
	SetCurOperateCard(0)  --curOperateCard = 0
	
--	if DEBUG_MAHJONG then
	for i = 1, CONST_PLAYER_MAX do
		--	SetPlayerDebugPeepHand(i)
		PeepHand(i)
	end
	SendMsg2Client(-1, PLAYER_OPERATE_DEBUG_PEEP_OTHER_HAND, -1, 0, 0)
--	end

	SetLastGangPlayer(0)
	SendAndSetTableMgrState(CONST_TABLE_STATE_TUISHUI)
	SetTimer(CONST_TABLE_STATE_TUISHUI, -1, 0)
	
	local tingList = {}
	local handCards = {}
	local lack = -1
	local bonusTable = {}
	local analysisData = {
		{0, 0, 0},
		{0, 0, 0},
		{0, 0, 0},
		{0, 0, 0}
	}
	local ting = 1
	local colorPig = 2
	local hu = 3
	local tingList4NotHu = {[1] = {}, [2] = {}, [3] = {}, [4] = {}}
	local aliveData = GetPlayerAliveAll()
--		for j = 1, 3 do
--			if (not(temp[j] == 0)) and aliveData[temp[j]] == 0 then
--				temp[j] = 0
--			end
--		end
	for i = 1, CONST_PLAYER_MAX do
		if CheckAlive(i, aliveData) then
			if GetPlayerIsLockTing(i) == 0 then
				--没有胡牌
				handCards = GetPlayerHand(i)
				lack = GetPlayerLack(i)
				bonusTable = GetPlayerBonus(i)
				local scoreTable = {}
				if CheckTing(tingList4NotHu[i], handCards, lack, bonusTable, false, scoreTable) > 0 then
					SetPlayerIsTing(i, 1)
					analysisData[i][ting] = 1
				end
				if CheckLack(handCards, bonusTable, lack) == false then
					SetPlayerIsColorPig(i, 1)
					analysisData[i][colorPig] = 1
				end
			else
				SetPlayerIsTing(i, 1)
				analysisData[i][ting] = 1
				analysisData[i][hu] = 1
			end
		end
	end

	--退税
	if WRITE_LOG then
		PrintChatMsg(GetEditorString(16, 5976))
	end
	for i = 1, CONST_PLAYER_MAX do
		if WRITE_LOG then
			--	Log(tostring("退税：player： " .. i))
			Log(string.format(GetEditorString(17, 94), i))
		end
		if CheckAlive(i, aliveData) then
			if analysisData[i][ting] == 0 then
				local playerCash = GetPlayerCash(i)
				local gangCashData = GetPlayerGangCash(i)
				local playersReturnTax = {}
				
				for k, v in pairs(gangCashData) do
					if WRITE_LOG then
						--	Log(tostring("退税：player： " .. i .. " k: " .. k .. " v: " .. v[1] .. " | " .. v[2] .. " | " .. v[3] .. " | " .. v[4] .. " | " .. v[5] .. " | " .. v[6]))
						Log(string.format(GetEditorString(17, 95), i, k, v[1], v[2], v[3], v[4], v[5], v[6]))
					end
					local totalCash = 0
					local playersReturnTaxCount = 0
					for j = 1, 5, 2 do
						if v[j] > 0 then
							if CheckAlive(v[j], aliveData) then
								totalCash = totalCash + v[j + 1]
								playersReturnTaxCount = playersReturnTaxCount + 1
								playersReturnTax[playersReturnTaxCount] = v[j]
							end
						end
					end
					
					if totalCash > playerCash then
						totalCash = playerCash
					end

					if totalCash > 0 then
						CashReturnTax(i, playersReturnTax, playersReturnTaxCount, totalCash, playerCash, PLAYER_OPERATE_TUISHUI)
						playerCash = playerCash - totalCash
					end
				end

				--[[
				for k, v in pairs(gangCashData) do
					playersReturnTax = {}
					playersReturnTaxCount = 0
					lostCount = 0
					for j = 1, 3 do
						if not (v[j * 2 - 1] == 0) then
							if CheckAlive(v[j * 2 - 1], aliveData) then
								playersReturnTaxCount = playersReturnTaxCount + 1
								playersReturnTax[playersReturnTaxCount] = v[j * 2 - 1]
							else
								lostCount = lostCount + 1
							end
								totalCash = totalCash + v[j * 2]
						end
					end
					
					if totalCash < playerCash then
						totalCash = playerCash
					end

					cashOri = math.floor(totalCash * playersReturnTaxCount / (playersReturnTaxCount + lostCount))

					CashReturnTax(i, playersReturnTax, playersReturnTaxCount, cashOri, playerCash, PLAYER_OPERATE_TUISHUI)
					playerCash = playerCash - cashOri
				end
				--]]
			end
		end
	end
--	SendMsg2Client( - 1, PLAYER_OPERATE_TUISHUI, 0, 0, 0)

	local cashBase = GetCashBase()
	
	--查花猪
	if WRITE_LOG then
		PrintChatMsg(GetEditorString(16, 5977))
	end
	for i = 1, CONST_PLAYER_MAX do
		if CheckAlive(i, aliveData) then
			if analysisData[i][colorPig] == 1 then  --花猪
				local playersNotTing = {}
				local playersNotTingCount = 0
				local playersNotHu = {}
				local playersNotHuCount = 0
				for j = 1, CONST_PLAYER_MAX do
					if (not (i == j)) and CheckAlive(j, aliveData) then
						if analysisData[j][ting] == 1 then
							if analysisData[j][hu] == 0 then
								playersNotHuCount = playersNotHuCount + 1
								playersNotHu[playersNotHuCount] = j
							end
						else
							if analysisData[j][colorPig] == 0 then
								playersNotTingCount = playersNotTingCount + 1
								playersNotTing[playersNotTingCount] = j
							end
						end
					end
				end
				--TODO: 退未胡牌玩家最大可能倍数 playersNotHu
				if playersNotHuCount > 0 then
					CashReturnNotHuMax(i, playersNotHu, playersNotHuCount, cashBase, tingList4NotHu, PLAYER_OPERATE_CHECK_COLORPIG)
				end
				--TODO: 退未听牌玩家16倍 playersNotTing
				if playersNotTingCount > 0 then
					CashReturnNotTing16(i, playersNotTing, playersNotTingCount, cashBase, PLAYER_OPERATE_CHECK_COLORPIG)
				end
			end
		end
	end

--	SendMsg2Client( - 1, PLAYER_OPERATE_CHECK_COLORPIG, 0, 0, 0)

	--查大叫
	if WRITE_LOG then
		PrintChatMsg(GetEditorString(16, 5982))
	end
	for i = 1, CONST_PLAYER_MAX do
		if CheckAlive(i, aliveData) then
			if analysisData[i][colorPig] == 0 and analysisData[i][ting] == 0 then  --大叫
				local playersNotHu = {}
				local playersNotHuCount = 0
				for j = 1, CONST_PLAYER_MAX do
					if (not (i == j)) and CheckAlive(j, aliveData) and analysisData[j][ting] == 1 and analysisData[j][hu] == 0 then
						playersNotHuCount = playersNotHuCount + 1
						playersNotHu[playersNotHuCount] = j
					end
				end
				--TODO: 退未胡牌玩家最大可能倍数 playersNotHu
				if playersNotHuCount > 0 then
					CashReturnNotHuMax(i, playersNotHu, playersNotHuCount, cashBase, tingList4NotHu, PLAYER_OPERATE_CHECK_DAJIAO)
				end
			end
		end
	end

--	SendMsg2Client( - 1, PLAYER_OPERATE_CHECK_DAJIAO, 0, 0, 0)

	--TODO: 刷新认输 重置挂机
	for i = 1, CONST_PLAYER_MAX do
		if GetPlayerCash(i) > 0 then
			aliveData[i] = 1
		else
			if aliveData[i] == 1 then
				SendMsg2Client(-1, PLAYER_OPERATE_OUT_OF_MONEY, i, 0, 0)
			end
			aliveData[i] = 0
		end
		SetPlayerIsAgent(i, 0)
		SendMsg2Client( - 1, PLAYER_OPERATE_SET_AGENT, i, 0, 0)
	end
	SetPlayerAliveAll(aliveData)

	SettleAccounts()
	SendAndSetTableMgrState(CONST_TABLE_STATE_END_GAME)
	SetTimer(CONST_TABLE_STATE_END_GAME, -1, 0)
end

function SendCard()
--	local tableState = GetTableMgrState()
--	if tableState == CONST_TABLE_STATE_END_GAME or tableState == CONST_TABLE_STATE_TUISHUI then
--		-- 三家起立
--		return
--	end
	local card = GetNextCard()
	if card == 0 then
--		SendAndSetTableMgrState(CONST_TABLE_STATE_TUISHUI)
		ReturnMoney()
--		SendAndSetTableMgrState(CONST_TABLE_STATE_END_GAME)
		return
	end
	SetCurOperateCard(card)
	local curPlayer = GetCurOperatePlayer()
	for i = 1, CONST_PLAYER_MAX do
		if i == curPlayer then
			SendMsg2Client(curPlayer, PLAYER_OPERATE_SC_SEND, curPlayer, card, GetCurCardPtr())
		else
			SendMsg2Client(i, PLAYER_OPERATE_SC_SEND, curPlayer, 0, GetCurCardPtr())
		end
	end
	local isFirstCircle = GetPlayerIsFirstCircle(curPlayer)
	if isFirstCircle == 255 then
		SetPlayerIsFirstCircle(curPlayer, 1)
	elseif isFirstCircle == 1 then
		SetPlayerIsFirstCircle(curPlayer, 0)
	end
	if DEBUG_MAHJONG then
--		SetPlayerDebugPeepHand(curPlayer)
		PeepHand(curPlayer)
	end
--	SendMsg2Client( - 1, PLAYER_OPERATE_SC_SEND, curPlayer, 0, 0)
--	SendMsg2Client(curPlayer, PLAYER_OPERATE_SC_SEND, curPlayer, card, 0)
--	ServerOperate(tMemPlayerData[CUR_PLAYER], PLAYER_OPERATE_SC_SEND, tMemPlayerCards[CUR_OPERATE_CARD], 0, 0)
--	tMemPlayerCards[tMemPlayerData[CUR_PLAYER]][OPERATE_MASK] = CheckOperateMaskForSingle(tMemPlayerData[CUR_PLAYER], tMemPlayerData[CUR_PLAYER], false)
	local maskData = {}
	local gangData = {}
	local result = 0
	for i = 1, CONST_PLAYER_MAX do
		if not (i == curPlayer) then
			SetPlayerOperateMask(i, maskData, true)
			SetPlayerGangOperate(i, gangData)
			SendMsg2Client(i, PLAYER_OPERATE_SYN_OPERATE_MASK, result, card, 0)
		end
	end
	result = CheckOperateMaskForSingle(curPlayer, curPlayer, false, maskData, gangData)
	SetPlayerOperateMask(curPlayer, maskData, true)
	if WRITE_LOG then
		--	Log(tostring("SendCard SetPlayerGangOperate(curPlayer, gangData[1], gangData[2], gangData[3], gangData[4]) result: " .. result))
		Log(string.format("SendCard SetPlayerGangOperate(curPlayer, gangData[1], gangData[2], gangData[3], gangData[4]) result: %d", result))
		for k,v in pairs(gangData) do
			--	Log(tostring(" gangData:   k:" .. k .. " v:" .. v))
			Log(string.format("gangData: k: %d, v: %d", k, v))
		end
	end
	SetPlayerGangOperate(curPlayer, gangData)
	--TODO TODO TODO 检测完操作，入手牌，清空curCard  TODO:纠正，不清空curCard，超时要帮玩家出牌
	--tMemPlayerCards[tMemPlayerData[CUR_PLAYER]][DATA_IN_HAND][tMemPlayerCards[CUR_OPERATE_CARD]] = tMemPlayerCards[tMemPlayerData[CUR_PLAYER]][DATA_IN_HAND][tMemPlayerCards[CUR_OPERATE_CARD]] + 1
	--tMemPlayerCards[CUR_OPERATE_CARD] = 0
	--GetPayer(PlayerID).SendSystemMessage("发牌: 玩家:" .. curPlayer .. " card: " .. string.format("%#x", card))
--	PrintChatMsg("给玩家:" .. curPlayer .. "发牌 card: " .. string.format("%#x", card))
	if WRITE_LOG then
		PrintChatMsg(string.format(GetEditorString(17, 96), curPlayer, card))
	end
	SendMsg2Client(curPlayer, PLAYER_OPERATE_SYN_OPERATE_MASK, result, card, 0)
	--TODO:清理玩家operateMask
	
--	local isAgent = GetPlayerIsAgent(curPlayer)
	if result > 0 then
		SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_OPERATE)
		--	operate定时
		--	GetScene(MemSceneID).SetTimer(TIMER_CS_OPERATE_WAIT * GLOBAL.GAME_FPS, "scripts/Map/家园系统/miniGame/majhong/xueliuchenghe1/xueliuchengheTableMgr.lua", TIMER_CS_OPERATE_WAIT, 0)
		SetTimer(CONST_TABLE_STATE_WAIT_OPERATE, curPlayer, 0)
--		if isAgent == 1 then
--			AutoOperate(curPlayer, true)
--		end
	else
		SendAndSetTableMgrState(CONST_TABLE_STATE_WAIT_CS_SEND)
		--	出牌定时
		--	GetScene(MemSceneID).SetTimer(TIMER_CS_SENDCARD * GLOBAL.GAME_FPS, "scripts/Map/家园系统/miniGame/majhong/xueliuchenghe1/xueliuchengheTableMgr.lua", TIMER_CS_SENDCARD, 0)
		SetTimer(CONST_TABLE_STATE_WAIT_CS_SEND, curPlayer, 0)
--		if isAgent == 1 then
--			AutoCSSendCard(curPlayer, true)
--		end
	end
end

function ClientOperate(nValue1, nValue2, nValue3, nValue4)
	
end

function SendMsg2Client(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
	if WRITE_LOG then
		if nValue1 == PLAYER_OPERATE_CS_SEND then
			--	Log(tostring("时间: " .. miniGameMgr1.GetGameTime() .. " MSG: " .. nPlayerIndex .. "收到 | 玩家" .. nValue2 .. " 出牌" .. string.format("%#x", nValue3)))
			Log(string.format(GetEditorString(17, 97), miniGameMgr1.GetGameTime(), nPlayerIndex, nValue2, nValue3))
		elseif nValue1 == PLAYER_OPERATE_SC_SEND then
			--	Log(tostring("时间: " .. miniGameMgr1.GetGameTime() .. " MSG: " .. nPlayerIndex .. "收到 | 发牌给玩家" .. nValue2 .. " 发牌" .. string.format("%#x", nValue3)))
			Log(string.format(GetEditorString(17, 563), miniGameMgr1.GetGameTime(), nPlayerIndex, nValue2, nValue3))
		end
		--	Log(tostring("时间: " .. miniGameMgr1.GetGameTime() .. " 发消息: "  .. tostring(nPlayerIndex) .. " | " .. tostring(nValue1) .. " | " .. tostring(nValue2) .. " | " .. tostring(nValue3) .. " | " .. tostring(nValue4)))
		Log(string.format(GetEditorString(17, 99), miniGameMgr1.GetGameTime(), nPlayerIndex, nValue1, nValue2, nValue3, nValue4))
	end
	if not (nPlayerIndex == -1) then
		nPlayerIndex = nPlayerIndex - 1
	end
--	MgrOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
	miniGameMgr1.Operate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
	PlayPlayerSound(nPlayerIndex, nValue1, nValue2, nValue3, nValue4)
end

--弃牌记录
function SetAbandonCard(nPlayerIndex, card)
--	card = SetDataWithFlagN(card, nPlayerIndex - 1, CONST_MASK_N_BONUSDATA_CARD_LEN)
--	tMemAllCards[tMemCardsPtr[ABANDON]] = card
--	tMemCardsPtr[ABANDON] = tMemCardsPtr[ABANDON] + 1
	SetPublicAbandonCard(nPlayerIndex, card)
end

--[[
--玩家杠牌区记录
function SetBonus(nPlayerIndex, bonusCard, bonusCode)
	tMemPlayerCards[nPlayerIndex][BONUS_TABLE][bonusCard] = bonusCode
end

function ClearBonus(nPlayerIndex)
	tMemPlayerCards[nPlayerIndex][BONUS_TABLE] = {}
end
--]]

function StealCardGuanxing(offset, inCard)
	local tempCard = 0
	local allCards = GetAllCards()
	local curCardPtr = GetCurCardPtr()
	
	if offset + curCardPtr + 1 > 108 then
		if WRITE_LOG then
			Log(GetEditorString(17, 306))
		end
		return
	end
	if allCards[curCardPtr + 1 + offset] == inCard then
		return
	end
	for index = curCardPtr + 1 + offset + 1, CONST_CARDS_NUM do
		if allCards[index] == inCard then
			SetSingleCard(index, allCards[curCardPtr + 1 + offset])
			SetSingleCard(curCardPtr + 1 + offset, inCard)
			return
		end
	end
	if WRITE_LOG then
		--	Log(tostring("StealCardGuanxing: " .. inCard .. " 卡池没有了!!"))
		Log(string.format(GetEditorString(17, 100), inCard))
	end
end

function StealCard(nPlayerIndex, outCard, inCard)
	if WRITE_LOG then
		--	Log(tostring("StealCard: nPlayerIndex: " .. nPlayerIndex .. " outCard: " .. outCard .. " inCard: " .. inCard))
		Log(string.format("StealCard: nPlayerIndex: %d, outCard: %#x, inCard: %#x", nPlayerIndex, outCard, inCard))
	end
	local handCard = GetPlayerHand(nPlayerIndex)
	local curCardPtr = GetCurCardPtr()
	local allCards = GetAllCards()
	local result = false
	if handCard[outCard] > 0 then
		for index = curCardPtr + 1, CONST_CARDS_NUM do
			if allCards[index] == inCard then
				allCards[index] = outCard
				handCard[outCard] = handCard[outCard] - 1
				handCard[inCard] = handCard[inCard] + 1
				SetSingleCard(index, outCard)
				result = true
				break
			end
		end
		if DEBUG_MAHJONG then
			if result then
				SetPlayerHand(nPlayerIndex, handCard)
				if WRITE_LOG then
					Log(GetEditorString(16, 6633))
				end
			else
				--	Log(tostring("StealCard: " .. inCard .. " 卡池没有了!!"))
				if WRITE_LOG then
					Log(string.format(GetEditorString(17, 101), inCard))
				end
			end
		end
	else
		if WRITE_LOG then
			--	Log(tostring("StealCard: " .. outCard .. " 不存在"))
			Log(string.format(GetEditorString(17, 102), outCard))
		end
	end
end

function PrintChatMsg(str)
	if WRITE_LOG then
		Log(str)
		for i = 1, CONST_PLAYER_MAX do
			local playerdwID = GetPlayerDWID(i)
			Log(string.format("GetPlayerDWID: nPlayerIndex: %d, playerdwID: %d", i, playerdwID))
			if not (playerdwID == nil) then
				local player = GetPlayer(playerdwID)
				if not (player == nil) then
					player.SendSystemMessage(str)
				else
					--	Log("player: id: " .. i .. " is " .. tostring(player))
					Log(string.format("player: id: %d is nil", i))
				end
			end
		end
	end
end

tRoleType2Shape = {[1] = 0, [2] = 1, [5] = 2, [6] = 3}

SOUND_TYPE_MANDARIN = 0
SOUND_TYPE_SICHUAN = 1

SOUND_OFFSET = 1
SOUND_SENDCARD = 2
SOUND_PENG = 3
SOUND_PENG_THIRD = 4
SOUND_MING_GANG = 5
SOUND_AN_GANG = 6
SOUND_GANG_AFTER_PENG = 7
SOUND_HU = 8
SOUND_HU_SAME_CARD = 9
SOUND_HU_ZIMO = 10
SOUND_HU_THIRD = 11
SOUND_WAIT = 12

tSound = {
	[SOUND_TYPE_MANDARIN] = {
		[SOUND_OFFSET] = {21596, 50},
		[SOUND_SENDCARD] = {
			[0x01] = {0,0}, [0x02] = {1,1}, [0x03] = {2,2}, [0x04] = {3,3}, [0x05] = {4,4}, [0x06] = {5,5}, [0x07] = {6,6}, [0x08] = {7,7}, [0x09] = {8,8},
			[0x11] = {9,9}, [0x12] = {10,10}, [0x13] = {11,11}, [0x14] = {12,12}, [0x15] = {13,13}, [0x16] = {14,14}, [0x17] = {15,15}, [0x18] = {16,16}, [0x19] = {17,17},
			[0x21] = {18,18}, [0x22] = {19,19}, [0x23] = {20,20}, [0x24] = {21,21}, [0x25] = {22,22}, [0x26] = {23,23}, [0x27] = {24,24}, [0x28] = {25,25}, [0x29] = {26,26}
		},
		[SOUND_PENG] = {27, 30},
		[SOUND_PENG_THIRD] = {31, 32},
		[SOUND_MING_GANG] = {33, 34},
		[SOUND_AN_GANG] = {35, 36},
		[SOUND_GANG_AFTER_PENG] = {37, 38},
		[SOUND_HU] = {39, 41},
		[SOUND_HU_SAME_CARD] = {42, 43},
		[SOUND_HU_ZIMO] = {44, 46},
		[SOUND_HU_THIRD] = {47, 47},
		[SOUND_WAIT] = {48, 49}
	},
	
	[SOUND_TYPE_SICHUAN] = {
		[SOUND_OFFSET] = {21796, 94},
		[SOUND_SENDCARD] = {
			[0x01] = {0,2}, [0x02] = {3,5}, [0x03] = {6,8}, [0x04] = {9,11}, [0x05] = {12,14}, [0x06] = {15,15}, [0x07] = {16,16}, [0x08] = {17,17}, [0x09] = {18,19},
			[0x11] = {20,23}, [0x12] = {24,29}, [0x13] = {30,30}, [0x14] = {31,32}, [0x15] = {33,34}, [0x16] = {35,36}, [0x17] = {37,38}, [0x18] = {39,42}, [0x19] = {43,45},
			[0x21] = {46,49}, [0x22] = {50,52}, [0x23] = {53,55}, [0x24] = {56,58}, [0x25] = {59,61}, [0x26] = {62,62}, [0x27] = {63,64}, [0x28] = {65,67}, [0x29] = {68,70}
		},
		[SOUND_PENG] = {71, 74},
		[SOUND_PENG_THIRD] = {75, 76},
		[SOUND_MING_GANG] = {77, 78},
		[SOUND_AN_GANG] = {79, 80},
		[SOUND_GANG_AFTER_PENG] = {81, 82},
		[SOUND_HU] = {83, 85},
		[SOUND_HU_SAME_CARD] = {86, 87},
		[SOUND_HU_ZIMO] = {88, 90},
		[SOUND_HU_THIRD] = {91, 91},
		[SOUND_WAIT] = {92, 93}
	}
}

tSVT_SENDCARD_CARD = 1

tSVT_PNEG_COUNT = 1

tSVT_HU_IS_ZIMO = 1
tSVT_HU_COUNT = 2
tSVT_HU_IS_SAME = 3

function GetSoundID(typeAccent, typeOperation, valueTable, shape)
	local result = -1
	local soundData = tSound[typeAccent]
	if typeOperation == PLAYER_OPERATE_CS_SEND then
		if CheckLegalCardValue(valueTable[tSVT_SENDCARD_CARD]) then
			local card = valueTable[tSVT_SENDCARD_CARD]
			result = math.random(soundData[SOUND_SENDCARD][card][1], soundData[SOUND_SENDCARD][card][2])
		end
	elseif typeOperation == PLAYER_OPERATE_PENG then
		if valueTable[tSVT_PNEG_COUNT] > 2 then
			result = math.random(soundData[SOUND_PENG_THIRD][1], soundData[SOUND_PENG_THIRD][2])
		else
			result = math.random(soundData[SOUND_PENG][1], soundData[SOUND_PENG][2])
		end
	elseif typeOperation == PLAYER_OPERATE_MING_GANG then
		result = math.random(soundData[SOUND_MING_GANG][1], soundData[SOUND_MING_GANG][2])
	elseif typeOperation == PLAYER_OPERATE_AN_GANG then
		result = math.random(soundData[SOUND_AN_GANG][1],soundData[SOUND_AN_GANG][2])
	elseif typeOperation == PLAYER_OPERATE_GANG_AFTER_PENG then
		result = math.random(soundData[SOUND_GANG_AFTER_PENG][1], soundData[SOUND_GANG_AFTER_PENG][2])
	elseif typeOperation == PLAYER_OPERATE_HU then
		local sound = {}
		local soundCount = 1
		if valueTable[tSVT_HU_COUNT] > 2 then
			sound[soundCount] = math.random(soundData[SOUND_HU_THIRD][1], soundData[SOUND_HU_THIRD][2])
			soundCount = soundCount + 1
		end
		if valueTable[tSVT_HU_IS_ZIMO] == 1 then
			sound[soundCount] = math.random(soundData[SOUND_HU_ZIMO][1], soundData[SOUND_HU_ZIMO][2])
			soundCount = soundCount + 1
		else
			if valueTable[tSVT_HU_IS_SAME] == 1 then 
				sound[soundCount] = math.random(soundData[SOUND_HU_SAME_CARD][1], soundData[SOUND_HU_SAME_CARD][2])
				soundCount = soundCount + 1
			else
				sound[soundCount] = math.random(soundData[SOUND_HU][1], soundData[SOUND_HU][2])
				soundCount = soundCount + 1
			end
		end
		local id = math.random(1, soundCount - 1)
		result = sound[id]
	elseif typeOperation == PLAYER_OPERATE_WAIT then
		result = math.random(soundData[SOUND_WAIT][1], soundData[SOUND_WAIT][2])
	end
	if result == -1 then
		return - 1
	else
		return result + soundData[SOUND_OFFSET][1] +  soundData[SOUND_OFFSET][2] * shape
	end
end

function PlayPlayerSound(msgReceiver, nValue1, nValue2, nValue3, nValue4)
	local valueTable = {}
	local needSound = false
	if nValue1 == PLAYER_OPERATE_CS_SEND then
		valueTable[tSVT_SENDCARD_CARD] = nValue3
		needSound = true
	elseif nValue1 == PLAYER_OPERATE_PENG then
		valueTable[tSVT_PNEG_COUNT] = GetPlayerPengCount(nValue2)
		needSound = true
	elseif nValue1 == PLAYER_OPERATE_MING_GANG or nValue1 == PLAYER_OPERATE_AN_GANG or nValue1 == PLAYER_OPERATE_GANG_AFTER_PENG or  nValue1 == PLAYER_OPERATE_WAIT then
		needSound = true
	end
	if needSound then
		local playerdwID = GetPlayerDWID(nValue2)
		if WRITE_LOG then
			Log(string.format("GetPlayerDWID: nPlayerIndex: %d, playerdwID: %d", nValue2, playerdwID))
		end
		if playerdwID == nil then
			return
		end
		local player = GetPlayer(playerdwID)
		if player == nil then
			return
		end

		local soundID = GetSoundID(GetPlayerAccent(nValue2), nValue1, valueTable, tRoleType2Shape[player.nRoleType])
		
		player.PlayCharacterSound(soundID)
		if WRITE_LOG then
			--	Log(tostring("**喊话: play sound: " .. soundID .. " 类型: " .. nValue1 .. " **"))
			Log(string.format(GetEditorString(17, 103), soundID, nValue1))
		end
	end
end

function PlayPlayerSoundHu(nPlayerIndex, cardPlayer, huCard)
	local valueTable = {0, 0, 0}
	if nPlayerIndex == cardPlayer then
		valueTable[tSVT_HU_IS_ZIMO] = 1
	end
	local huRecord = GetHuRecord(nPlayerIndex)
	local huRecordCount = #huRecord
	huRecordCount = math.floor(huRecordCount / 2)
	for i = 1, huRecordCount do
		if huRecord[i * 2 - 1] == nPlayerIndex then
			valueTable[tSVT_HU_COUNT] = valueTable[tSVT_HU_COUNT] + 1
			if huRecord[i * 2] == huCard then
				valueTable[tSVT_HU_IS_SAME] = 1
			end
		end
	end
	local playerdwID = GetPlayerDWID(nPlayerIndex)
	if WRITE_LOG then
		Log(string.format("GetPlayerDWID: nPlayerIndex: %d, playerdwID: %d", nPlayerIndex, playerdwID))
	end
	if playerdwID == nil then
		return
	end
	local player = GetPlayer(playerdwID)
	if player == nil then
		return
	end
	local soundID = GetSoundID(GetPlayerAccent(nPlayerIndex), PLAYER_OPERATE_HU, valueTable, tRoleType2Shape[player.nRoleType])
	player.PlayCharacterSound(soundID)
	if WRITE_LOG then
		--	Log(tostring("**胡牌喊话: play sound: " .. soundID .. " **"))
		Log(string.format(GetEditorString(17, 104), soundID))
	end
end
--[[
function OnTimer(scene, nParam1, nParam2)
	print("OnTimer(scene, nParam1, nParam2): nParam1: " .. nParam1)
	TickTableMgrTimer()
end
--]]

function WritePlayerMahjongDatas(nPlayerIndex)
	local dwID = GetPlayerDWID(nPlayerIndex)
	if WRITE_LOG then
		Log(string.format("GetPlayerDWID: nPlayerIndex: %d, dwID: %d", nPlayerIndex, dwID))
	end
	local player = GetPlayer(dwID)
	local historyMaxCashName = GetPlayerMaxHuNameID(nPlayerIndex)
	local curContinueWinCount = GetPlayerCurWinCount(nPlayerIndex)
	local historyContinueWinCount = GetPlayerMaxWinCount(nPlayerIndex)
	local historyMaxCash = GetPlayerMaxHuCash(nPlayerIndex)
	local historyMatchCount = GetPlayerMatchCount(nPlayerIndex)
	local historyWinCount = GetPlayerWinCount(nPlayerIndex)
	local hideScore = 0 --GetPlayerHideScore(nPlayerIndex)
	local cashHonor = GetPlayerCashHonor(nPlayerIndex)
	local cash = GetPlayerCash(nPlayerIndex)
	local huCount = GetPlayerHuCount(nPlayerIndex)

	if WRITE_LOG then
		--	Log(tostring("WritePlayerMahjongDatas nPlayerIndex: " .. nPlayerIndex .. "|" .. "历史最大番ID: " .. historyMaxCashName  .. "|" .. "当前连胜: " .. curContinueWinCount .. "|" .. "历史最大连胜: " .. historyContinueWinCount .. "|" .. "历史最大番数: " .. historyMaxCash .. "|" .. "总场次: " .. historyMatchCount .. "|" .. " 总胜场: " .. historyWinCount .. "|" .. " 隐藏分: " .. hideScore .. "|" .. " 荣誉值: " .. cashHonor .. "|" .. " 欢乐豆: " .. cash))
		Log(string.format(GetEditorString(17, 906),nPlayerIndex, historyMaxCashName, curContinueWinCount, historyContinueWinCount, historyMaxCash, historyMatchCount, historyWinCount, hideScore, cashHonor, cash))
	end

	--Log(tostring("XXXXXXXXXXX WritePlayerMahjongDatas: " .. tostring(player) .. "|" .. tostring(player.HaveRemoteData(MAHJONG_DATAS_REMOTE_ID)) .. "|" .. tostring(player.bExtDataLoadFinish)))
	
	if player and player.HaveRemoteData(MAHJONG_DATAS_REMOTE_ID) and player.bExtDataLoadFinish then
		--TODO: 写入玩家数据
		player.SetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HISTORY_MAX_CASH_NAME[1], REMOTE_MAHJONG_DATAS.HISTORY_MAX_CASH_NAME[2], historyMaxCashName)
		player.SetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.CUR_CONTINUE_WIN_COUNT[1], REMOTE_MAHJONG_DATAS.CUR_CONTINUE_WIN_COUNT[2], curContinueWinCount)
		player.SetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HISTORY_CONTINUE_WIN_COUNT[1], REMOTE_MAHJONG_DATAS.HISTORY_CONTINUE_WIN_COUNT[2], historyContinueWinCount)
		player.SetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HISTORY_MAX_CASH[1], REMOTE_MAHJONG_DATAS.HISTORY_MAX_CASH[2], historyMaxCash)
		player.SetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HISTORY_MATCH_COUNT[1], REMOTE_MAHJONG_DATAS.HISTORY_MATCH_COUNT[2], historyMatchCount)
		player.SetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HISTORY_WIN_COUNT[1], REMOTE_MAHJONG_DATAS.HISTORY_WIN_COUNT[2], historyWinCount)
		--	player.SetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HIDE_SCORE[1], REMOTE_MAHJONG_DATAS.HIDE_SCORE[2], hideScore)
		--	player.SetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.CASH_HONOR[1], REMOTE_MAHJONG_DATAS.CASH_HONOR[2], cashHonor)

		--TODO:特别注意 如果玩家不在线 这里进不来 如果需要离线也OK 我这边需要稍作调整 请通知我
		if huCount > 0 then
			local huMatchCount = player.GetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HU_MATCH_COUNT[1], REMOTE_MAHJONG_DATAS.HU_MATCH_COUNT[2])
			player.SetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HU_MATCH_COUNT[1], REMOTE_MAHJONG_DATAS.HU_MATCH_COUNT[2], huMatchCount + 1)
			--TODO:成就 huMatchCount+1 就是有胡牌的局数
			local tMatchWinCountAch = {7895, 7896, 7927, 7897, 9032}
			local nMatchWinCountAch = player.GetAchievementCount(7895)
			for i =1, #tMatchWinCountAch do
				nMatchWinCountAch = math.max(nMatchWinCountAch, player.GetAchievementCount(tMatchWinCountAch[i]))
				
			end
			if historyWinCount > nMatchWinCountAch then
				local nAddWinCount = historyWinCount - nMatchWinCountAch
				player.AddAchievementCount(7895, nAddWinCount)
			else
				player.AddAchievementCount(7895, 1)
			end			
			--TODO:成就 huCount 就是这一局的胡牌次数
			if huCount >= 10 and not player.IsAchievementAcquired(7898) then
				player.AcquireAchievement(7898)
			end
		end

		--TODO:成就 historyMatchCount就是总对局数
		local tMatchCountAch = {7892, 7893, 7894, 9031, 10847}
		local nMatchCountAch = player.GetAchievementCount(7892)
		for i =1, #tMatchCountAch do
			nMatchCountAch = math.max(nMatchCountAch, player.GetAchievementCount(tMatchCountAch[i]))
				
		end		
		if historyMatchCount > nMatchCountAch then
			local nAddCount = historyMatchCount - nMatchCountAch
			player.AddAchievementCount(7892, nAddCount)
		else
			player.AddAchievementCount(7892, 1)
		end
		local tRate = Adventure_TuJiangHu.GetRateTable(13)
		local nActiveCount = CustomFunction.GetMinuToTomorrow7()
		Adventure_TuJiangHu.GiveStartItem(player, tRate.nAchievementID, tRate.nRateType, 17629, 1, 2, nActiveCount,5)
		--TODO:任务周常判断玩家每周接取任务后的胡牌局数
		local nQuestIndex = player.GetQuestIndex(21924)
		local nQuestPhase = player.GetQuestPhase(21924)
		if nQuestIndex  and nQuestPhase <=1 then
			player.SetQuestValue(nQuestIndex, 0, player.GetQuestValue(nQuestIndex,0)+1)
		end

		local buff = player.GetBuff(19818, 0) --每日监控buff
		if buff then
			player.DelBuff(19818, 1)
		end
	else
		--TODO:玩家不在线，怎么存储
		if WRITE_LOG then
			--	Log(tostring("WritePlayerMahjongDatas 失败 nPlayerIndex: " .. nPlayerIndex))
			Log(string.format(GetEditorString(17, 106), nPlayerIndex))
		end
	end

	WriteItem(player, dwID, CONST_HUANLEDOU_ID, cash, GetEditorString(16, 8297), GetEditorString(17, 932), GetEditorString(17, 1352))

--	local cashHonorOri = player.GetItemAmountInPackage(ITEM_TABLE_TYPE.OTHER, CONST_CASH_HONOR_ID)
--	local cashHonorTemp = cashHonor - cashHonorOri
	--------------法务意见：删除雀神点数--------------
	--if cashHonor > 0 then
	--	WriteItem(player, dwID, CONST_CASH_HONOR_ID, cashHonor, "居业行", "雀神点数道具邮寄", "见信好！  侠士您先前因个人原因，寄存在我这儿的雀神点数，还请查收。下次请多多收拾行囊，且勿匆匆离去，否则严丫头我就要收保管费啦！。  万年居业行严丫头")
	--end
	--------------法务意见：删除雀神点数--------------
	
end

function WriteItem(player, dwID, itemID, cash, str1, str2, str3)
	local maxDurability = GetItemInfo(ITEM_TABLE_TYPE.OTHER, itemID).nMaxDurability
	local realCash = 0
	local mailCash = {}
--	Log(tostring("WriteItem itemID: " .. itemID .. " cash: " .. cash .. " maxDurability: " .. maxDurability .. " str: " .. str1 .. " | " .. str2 .. " | " .. str3))
	while cash > 0 do
		if cash > maxDurability then
			realCash = maxDurability
		else
			realCash = cash
		end
		cash = cash - realCash
		if player then
			local canAddResult = player.CanAddItem(ITEM_TABLE_TYPE.OTHER, itemID, realCash)
			--		Log(string.format("writeItem: canAddResult: %d, itemID: %d, realCash: %d", canAddResult, itemID, realCash))
			if canAddResult == ADD_ITEM_RESULT_CODE.SUCCESS then
				player.AddItem(ITEM_TABLE_TYPE.OTHER, itemID, realCash, "Mahjong")
				Log(string.format("Mahjong AddItem: playerDwID: %d, itemID: %d, count: %d", dwID, itemID, realCash))
			else			
				table.insert(mailCash, realCash)
			end
		else			
			table.insert(mailCash, realCash)
		end
	end

	local mailMaxCount = 8
	local tSendList = {}
	for k,v in pairs(mailCash) do
		table.insert(tSendList, {ITEM_TABLE_TYPE.OTHER, itemID, v, 0})	--可以继续插，最多8个每封信		
		if #tSendList == mailMaxCount then
			--	SendSystemMail("发件人姓名（如麻将馆）", dwID, "邮件标题", "邮件内容", 0, tSendList)	--中间有个0是金币，尽量不填
			if player then
				player.SendSystemMessage(GetEditorString(17, 1452))
				RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", GetEditorString(17, 1452), 5)
			end
			SendSystemMail(str1, dwID, str2, str3, 0, tSendList)	--中间有个0是金币，尽量不填
			tSendList = {}
		end
	end
	if #tSendList > 0 then
		--	SendSystemMail("发件人姓名（如麻将馆）", dwID, "邮件标题", "邮件内容", 0, tSendList)	--中间有个0是金币，尽量不填
		if player then
			player.SendSystemMessage(GetEditorString(17, 1452))
			RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", GetEditorString(17, 1452), 5)
		end		
		SendSystemMail(str1, dwID, str2, str3, 0, tSendList)	--中间有个0是金币，尽量不填
	end
end

function ReadPlayerMahjongDatas(nPlayerIndex)
	local dwID = GetPlayerDWID(nPlayerIndex)
	if WRITE_LOG then
		Log(string.format("GetPlayerDWID: nPlayerIndex: %d, dwID: %d", nPlayerIndex, dwID))
	end
	local player = GetPlayer(dwID)
	if not player then
		--TODO: 强关游戏
		return false
	end
	
	if player and player.HaveRemoteData(MAHJONG_DATAS_REMOTE_ID) and player.bExtDataLoadFinish then
		--	local isContinueWin = player.GetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.CUR_CONTINUE_WIN_STATE[1], REMOTE_MAHJONG_DATAS.CUR_CONTINUE_WIN_STATE[2])
		local historyMaxCashName = player.GetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HISTORY_MAX_CASH_NAME[1], REMOTE_MAHJONG_DATAS.HISTORY_MAX_CASH_NAME[2])
		local curContinueWinCount = player.GetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.CUR_CONTINUE_WIN_COUNT[1], REMOTE_MAHJONG_DATAS.CUR_CONTINUE_WIN_COUNT[2])
		local historyContinueWinCount = player.GetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HISTORY_CONTINUE_WIN_COUNT[1], REMOTE_MAHJONG_DATAS.HISTORY_CONTINUE_WIN_COUNT[2])
		local historyMaxCash = player.GetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HISTORY_MAX_CASH[1], REMOTE_MAHJONG_DATAS.HISTORY_MAX_CASH[2])
		local historyMatchCount = player.GetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HISTORY_MATCH_COUNT[1], REMOTE_MAHJONG_DATAS.HISTORY_MATCH_COUNT[2])
		local historyWinCount = player.GetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HISTORY_WIN_COUNT[1], REMOTE_MAHJONG_DATAS.HISTORY_WIN_COUNT[2])
		local hideScore = 0 --player.GetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.HIDE_SCORE[1], REMOTE_MAHJONG_DATAS.HIDE_SCORE[2])
--		if hideScore < CONST_HIDE_SCORE_MIN then
--			hideScore = CONST_HIDE_SCORE_MIN
--		end
		--	local cashHonor = player.GetRemoteArrayUInt(MAHJONG_DATAS_REMOTE_ID, REMOTE_MAHJONG_DATAS.CASH_HONOR[1], REMOTE_MAHJONG_DATAS.CASH_HONOR[2])
--		local shape = tRoleType2Shape[player.nRoleType]

		local cash = player.GetItemAmountInPackage(ITEM_TABLE_TYPE.OTHER, CONST_HUANLEDOU_ID)
		if cash > 0 then
			local cashResult = player.CostItem(ITEM_TABLE_TYPE.OTHER, CONST_HUANLEDOU_ID, cash, "Mahjong")
			if cashResult then
				Log(string.format("Mahjong CostItem: playerDwID: %d, itemID: %d, count: %d", dwID, CONST_HUANLEDOU_ID, cash))
			else
				--	Log(tostring("上桌扣除道具失败: playerid: " .. dwID .. " nPlayerIndex: " .. nPlayerIndex .. " cash: " .. cash))
				Log(string.format(GetEditorString(17, 107), dwID, nPlayerIndex, cash))
				cash = 0 --如果扣除失败，cash回到初始化状态，写入小游戏内存的值亦为初始化值0，系统判定玩家认输，不会进行流水结算，不污染玩家原始数据
			end
		end

		SetPlayerMaxHuNameID(nPlayerIndex, historyMaxCashName)
		SetPlayerCurWinCount(nPlayerIndex, curContinueWinCount)
		SetPlayerMaxWinCount(nPlayerIndex, historyContinueWinCount)
		SetPlayerMaxHuCash(nPlayerIndex, historyMaxCash)
		SetPlayerMatchCount(nPlayerIndex, historyMatchCount)
		SetPlayerWinCount(nPlayerIndex, historyWinCount)
		--	SetPlayerHideScore(nPlayerIndex, hideScore)
--		SetPlayerCashHonor(nPlayerIndex, cashHonor)
		SetPlayerCash(nPlayerIndex, cash)
		SetPlayerCashOrigin(nPlayerIndex, cash)
--		SetPlayerShape(nPlayerIndex, shape)

		if WRITE_LOG then
			--------------法务意见：删除雀神点数--------------
			--local cashHonor = player.GetItemAmountInPackage(ITEM_TABLE_TYPE.OTHER, CONST_CASH_HONOR_ID)
			--------------法务意见：删除雀神点数--------------
			Log(string.format(GetEditorString(17, 1033), nPlayerIndex, historyMaxCashName, curContinueWinCount, historyContinueWinCount, historyMaxCash, historyMatchCount, historyWinCount, hideScore, cash))
		end

		--增加唯一上桌判定的buff
		local buff = player.GetBuff(19818, 0) --每日监控buff
		if not buff then
			player.AddBuff(player.dwID, player.nLevel, 19818, 1, 6)
		end

		return true
	else
		if WRITE_LOG then
			--	Log(tostring("ReadPlayerMahjongDatas 失败 nPlayerIndex: " .. nPlayerIndex))
			Log(string.format(GetEditorString(17, 109), nPlayerIndex))
		end
	end
end

function GetPersonalData(dwPlayerID)
	
end
