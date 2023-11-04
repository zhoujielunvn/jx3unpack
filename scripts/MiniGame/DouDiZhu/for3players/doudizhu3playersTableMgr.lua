---------------------------------------------------------------------->
-- 脚本名称:	scripts/MiniGame/DouDiZhu/for3players/doudizhu3playersTableMgr.lua
-- 更新时间:	2021/6/15 14:55:01
-- 更新用户:	caoqing-PC
-- 脚本说明:	
----------------------------------------------------------------------<
Include("scripts/MiniGame/DouDiZhu/for3players/doudizhu3playersPlayerMgr.lua")
Include("scripts/MiniGame/DouDiZhu/for3players/IdentityCustomValueName.lua")
Include("scripts/MiniGame/DouDiZhu/for3players/doudizhu3playersInclude.lua")
Include("scripts/Include/Time.lh")
Include("scripts/Include/LandCondition.lh")

--斗地主经营棋牌室的叶子令分成周上限
local nMaxWeeklyIncome = 50000

local miniGameMgr1 = GetMiniGameMgr()
local homeMgr = GetHomelandMgr()

function OnMiniGameEndGame()
	if DDZ_WRITE_LOG then
		Log(GetEditorString(16, 6367))
	end
	DDZ_SettleAccounts()
	DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_END_GAME, DDZ_CONST_TABLE_STATE_KILL_DOUDIZHU)
end

function OnMiniGameCreate(nPlayerCount, nValue)
	if DDZ_WRITE_LOG then
		Log(GetEditorString(17, 3405))
	end

	--开局设置带入小游戏
	DDZ_GameCreateValueAnalysis(nValue)

	DDZ_SetTimer(DDZ_CONST_TABLE_STATE_INIT, - 1)
	DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_INIT, DDZ_CONST_TABLE_STATE_INIT)
	return true
end

function OnMiniGameTimer(nValue1, nValue2)
	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(17, 91), nValue1, nValue2))
	end
	if nValue1 == DDZ_CONST_TABLE_STATE_INIT then
		--牌桌初始化结束,进行天赖子随机
		DDZ_InitTableMgr() --启动后1s进行牌桌初始化
		local nLaiziNum = DDZ_GetLaiZiNum()
		local laizi = DDZ_GetPrivateLaiZi()

		--判断是否满足上桌条件
		for i = 1, DDZ_CONST_PLAYER_MAX do
			local nPlayerCashOrigin = DDZ_GetPlayerCashOrigin(i)
			local bOnTable = 0
			if nLaiziNum == 0 and nPlayerCashOrigin < 2000 then
				bOnTable = 1
			end
			if nLaiziNum > 0 and nPlayerCashOrigin < 20000 then
				bOnTable = 2
			end

			if nPlayerCashOrigin == 0 then
				bOnTable = 3
			end

			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(20, 8942), i, nPlayerCashOrigin, nLaiziNum, bOnTable))
			end
			if bOnTable > 0 then
				--单局结束阶段，清空部分数据
				for i = 1, DDZ_CONST_PLAYER_MAX do
					DDZ_SetPlayerMingPaiState(i, 0)
					local playerdwID = DDZ_GetPlayerDWID(i)
					local player = GetPlayer(playerdwID)
					if player then
						if bOnTable == 1 then
							RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", GetEditorString(20, 8823), 4)
						end
						if bOnTable == 2 then
							RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", GetEditorString(20, 8824), 4)
						end
						if bOnTable == 3 then
							RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", GetEditorString(20, 9052), 4)
						end
					end
				end

				DDZ_SettleAccounts()
				DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_INIT, DDZ_CONST_TABLE_STATE_END_GAME)
				DDZ_SetTimer(DDZ_CONST_TABLE_STATE_END_GAME, - 1)
				return
			end
		end

		--发牌
		local nShuffleType = DDZ_GetShuffleType()
		DDZ_ShuffleCardsAndSendCards(nShuffleType)
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_LAIZI_TIAN, laizi[1], 0, 0, 0, 0)

		if nLaiziNum == 2 then
			--广播天癞子,设置癞子牌至公共数据
			DDZ_SetPublicLaiZi(laizi[1], 0)
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 9539), laizi[1]))
			end

			DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_INIT, DDZ_CONST_TABLE_STATE_SHOW_LAIZI_TIAN)
			DDZ_SetTimer(DDZ_CONST_TABLE_STATE_SHOW_LAIZI_TIAN, - 1)
		else
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(20, 8865)))
			end

			DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_INIT, DDZ_CONST_TABLE_STATE_SEND_CARD)
			DDZ_SetTimer(DDZ_CONST_TABLE_STATE_SEND_CARD, - 1)
		end

		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_SHOW_LAIZI_TIAN then
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8864)))
		end

		DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_SHOW_LAIZI_TIAN, DDZ_CONST_TABLE_STATE_SEND_CARD)
		DDZ_SetTimer(DDZ_CONST_TABLE_STATE_SEND_CARD, - 1)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_SEND_CARD then
		--判断明牌
		local nPlayerMingpaiState = {0, 0, 0}
		for i = 1, DDZ_CONST_PLAYER_MAX do
			nPlayerMingpaiState[i] = DDZ_GetPlayerMingPaiState(i)
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(18, 6287), i, nPlayerMingpaiState[i]))
			end
			if nPlayerMingpaiState[i] == DDZ_CONST_TABLE_STATE_INIT then
				local tHandCards = DDZ_GetPlayerHand(i)
				DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_MINGPAI_STATE_INIT, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_MINGPAI_STATE_INIT])	--起始明牌翻4倍
				DDZ_SetPublicPlayerHandCards(i, tHandCards) --设置当前玩家手牌设为公有数据并公开
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(18, 6276), i, nPlayerMingpaiState[i]))
				end

				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_MINGPAI_END, i, 0, 0, 0, 0)
			end
		end

		--发牌阶段结束，进行天籁子替换
		DDZ_ReplaceLaizi(1)

		--发牌阶段结束，进行优先叫地主判定,如果上一把有胜者，指定胜者为第一个叫地主的人
		local nChairMan = DDZ_ChairManFirst()
		--给第一个玩家下发叫地主状态(初始状态0、叫地主1、抢地主2、地主成功后3、抢地主成功后4、不叫5、不抢6)
		local nWinner = DDZ_GetPlayerWinner()
		if nWinner ~= 0 then
			nChairMan = nWinner
		end
		DDZ_SetPlayerChairManType(nChairMan, 1)  --设置玩家数据是否可以叫地主

		DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_SEND_CARD, DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN)
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nChairMan, 1, 0, 0, 0)
		DDZ_SetTimer(DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN, nChairMan)
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4270), nChairMan))
		end
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN then
		if DDZ_AUTO_TEST and DEBUG_DOUDIZHU then
			OnServerOperate(nValue2 - 1, DDZ_PLAYER_OPERATE_CHAIRMAN_TYPE, 1, 0, 0, 0, 0)
			return
		end

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 9133), nValue2))
		end
		OnServerOperate(nValue2 - 1, DDZ_PLAYER_OPERATE_CHAIRMAN_TYPE, 5, 0, 0, 0, 0)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_SET_CHAIRMAN then
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 9134), nValue2))
		end
		OnServerOperate(nValue2 - 1, DDZ_PLAYER_OPERATE_CHAIRMAN_TYPE, 6, 0, 0, 0, 0)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_SHOW_CHAIRMAN then
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8896)))
		end
		local laizi = DDZ_GetPrivateLaiZi()
		local nLaiziNum = DDZ_GetLaiZiNum()

		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_LAIZI_DI, laizi[2], 0, 0, 0, 0)

		if nLaiziNum > 0 then
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 3630), laizi[2]))
			end
			--地癞子同步结束，改变发底牌并改变牌值，将PrivateLaiZi 设为公共数据
			DDZ_SetPublicLaiZi(laizi[1], laizi[2])
			DDZ_SendAndSetTableMgrState(DDZ_PLAYER_OPERATE_SET_CHAIRMAN, DDZ_CONST_TABLE_STATE_SHOW_LAIZI_DI)
			DDZ_SetTimer(DDZ_CONST_TABLE_STATE_SHOW_LAIZI_DI, - 1)
		else
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4511)))
			end
			DDZ_SendAndSetTableMgrState(DDZ_PLAYER_OPERATE_SET_CHAIRMAN, DDZ_CONST_TABLE_STATE_DOUBLE)
			DDZ_SetTimer(DDZ_CONST_TABLE_STATE_DOUBLE, - 1)
		end
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_SHOW_LAIZI_DI then
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8897)))
		end
		--地癞子替换阶段
		DDZ_ReplaceLaizi(2)
		DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_SHOW_CHAIRMAN, DDZ_CONST_TABLE_STATE_DOUBLE)
		DDZ_SetTimer(DDZ_CONST_TABLE_STATE_DOUBLE, - 1)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_DOUBLE then
		--加倍阶段结束，进入明牌阶段
		for i = 1, 3 do
			OnServerOperate(i - 1, DDZ_PLAYER_OPERATE_DOUBLE_TYPE, 3, 0, 0, 0, 0)
		end

		DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_DOUBLE, DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI)
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 9540)))
		end
		DDZ_SetTimer(DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI, - 1)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI then
		--明牌选择结束，进入出牌阶段
		local nChairMan = DDZ_GetChairMan()  --获取公共数据地主状态

		--明牌阶段结束，进行出牌阶段，设定地主第一个出牌
		DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI, DDZ_CONST_TABLE_STATE_WAIT_CS_SEND)
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4758), nChairMan))
		end

		if DDZ_AUTO_TEST and DEBUG_DOUDIZHU then
			for i = 1, 3 do
				DDZ_SetPlayerIsAgent(i, 1)
			end
		end

		DDZ_SetCurOperatePlayer(nChairMan)	--设置玩家出牌
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CUR_PLAYER, nChairMan, 0, 0, 0, 0)
		DDZ_SetTimer(DDZ_CONST_TABLE_STATE_WAIT_CS_SEND, nChairMan)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_WAIT_CS_SEND then
		--计时器到了表示玩家跳过，结算逻辑写在出牌之后的OnServerOperate里
		if nValue2 > 0 and nValue2 <= DDZ_CONST_PLAYER_MAX then
			local nOverTimeCount = DDZ_GetPlayerOverTimeCount(nValue2)
			nOverTimeCount = nOverTimeCount + 1

			if WRITE_LOG then
				Log(string.format(GetEditorString(17, 92), nValue2, nOverTimeCount))
			end

			--玩家托管状态
			if nOverTimeCount >= 2 then
				nOverTimeCount = 0
				if WRITE_LOG then
					--	Log(tostring("设置玩家：" .. nValue2 .. " 挂机"))
					Log(string.format(GetEditorString(17, 93), nValue2))
				end
				DDZ_SetPlayerIsAgent(nValue2, 1)
				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_AGENT, nValue2, 1, 0, 0, 0)
				DDZ_SetPlayerOverTimeCount(nValue2, nOverTimeCount)

				--当前出牌人是自己，牌桌上没有其他的牌
				if DDZ_GetCardOwner() == 0 then
					DDZ_SendMinCards(nValue2)
				else
					DDZ_AutoSendCards(nValue2)
				end

				return
			end

			--正常跳过
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(18, 9405), nValue2))
			end
			DDZ_SetPlayerOverTimeCount(nValue2, nOverTimeCount)
			OnServerOperate(nValue2 - 1, DDZ_PLAYER_OPERATE_JUMP, 0, 0, 0, 0, 0)
		end
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_WAIT_CS_SEND_AGENT then
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(19, 6846), DDZ_GetCardOwner()))
		end
		--判断当前出牌人是否为自己
		if DDZ_GetCardOwner() == 0 then
			DDZ_SendMinCards(nValue2)
			return
		else
			DDZ_AutoSendCards(nValue2)
			return
		end

		--增加跳过判定的容错处理
		OnServerOperate(nValue2 - 1, DDZ_PLAYER_OPERATE_JUMP, 0, 0, 0, 0, 0)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_SETTLEMENT then
		--奖励结算
		DDZ_WinnerCash()

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8267)))
		end

		--对局结束，将剩下的手牌加入到记录中
		for i = 1, DDZ_CONST_PLAYER_MAX do
			local tCardsPile = DDZ_GetPrivateCardsPile()
			local tHandCards = DDZ_GetPlayerHand(i)
			local nLenCardsPile = 0
			local temp = {}
			local blaizi = false --如果有需要修改的数据

			for k, v in pairs(tCardsPile) do

				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(20, 8427), i, k, v))
				end

				--将癞子牌牌值退回为普通牌
				tCardsPile[k] = GetCardColorFromLaiziCard(v) * 0x10 + GetCardValueFromLaiziCard(v)
				if tCardsPile[k] ~= v then
					blaizi = true
				end

				if v == 0 then
					nLenCardsPile = k
					if DDZ_WRITE_LOG then
						Log(string.format(GetEditorString(20, 8428), nLenCardsPile))
					end
					break
				end
			end

			--修改完的数据重新
			if blaizi then
				DDZ_SetPrivateCardsPile(tCardsPile, 0)
			end

			for k, v in pairs(tHandCards) do
				if v ~= 0 then
					--将癞子牌牌值退回为普通牌
					local nCardsVlaue = GetCardColorFromLaiziCard(v) * 0x10 + GetCardValueFromLaiziCard(v)
					table.insert(temp, nCardsVlaue)
				end
			end

			if #temp ~= 0 then
				DDZ_SetPrivateCardsPile(temp, nLenCardsPile - 1)
			end
		end

		if DDZ_WRITE_LOG then
			local tCardsPile = DDZ_GetPrivateCardsPile()
			for k, v in pairs(tCardsPile) do
				Log(string.format(GetEditorString(20, 8429), k, v))
			end
		end

		--清空重新洗牌数
		DDZ_SetReStartNum(0)

		DDZ_SettleAccounts()

		DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_SETTLEMENT, DDZ_CONST_TABLE_STATE_END_GAME)
		DDZ_SetTimer(DDZ_CONST_TABLE_STATE_END_GAME, - 1)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_END_GAME then

		DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_END_GAME, DDZ_CONST_TABLE_STATE_KILL_DOUDIZHU)
		DDZ_SetTimer(DDZ_CONST_TABLE_STATE_KILL_DOUDIZHU, - 1)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_KILL_DOUDIZHU then
		miniGameMgr1.EndGame()
		return
	end
end

function OnClientOperate(nPlayer, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)

end

function OnNoCostOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)
	nPlayerIndex = nPlayerIndex + 1
	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(19, 8169), nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6))
	end

	local nTableMgrState = DDZ_GetTableMgrState()

	if nValue1 == DDZ_PLAYER_OPERATE_RESTART  then
		if nTableMgrState == DDZ_CONST_TABLE_STATE_END_GAME then
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(20, 8074)))
			end
			--单局结束阶段，清空部分数据
			for i = 1, DDZ_CONST_PLAYER_MAX do
				DDZ_SetPlayerMingPaiState(i, 0)
				DDZ_SetPublicMingPaiState(i, 0)
			end

			DDZ_GameCreateValueAnalysis(nValue2)

			DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_INIT, DDZ_CONST_TABLE_STATE_INIT)
			DDZ_SetTimer(DDZ_CONST_TABLE_STATE_INIT, - 1)
		else
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(20, 8073), nTableMgrState))
			end
		end
		return
	end

	if nValue1 == DDZ_PLAYER_OPERATE_SET_AGENT then
		if nValue2 > 1 then
			nValue2 = 1
		elseif
			nValue2 < 0 then
			nValue2 = 0
		end
		DDZ_SetPlayerIsAgent(nPlayerIndex, nValue2)
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_AGENT, nPlayerIndex, nValue2, 0, 0, 0)
		if nValue2 == 1 then
			if WRITE_LOG then
				Log(string.format(GetEditorString(17, 149), nPlayerIndex))
			end
		else
			if WRITE_LOG then
				Log(string.format(GetEditorString(17, 150), nPlayerIndex))
			end
		end
		return
	elseif nValue1 == DDZ_PLAYER_OPERATE_DEBUG_BEGIN then
		if not DEBUG_DOUDIZHU then
			if WRITE_LOG then
				Log(string.format(GetEditorString(19, 8113)))
			end
			return
		end

		local bDebug = DDZ_GetPublicDebug()
		if bDebug == 0  then
			if WRITE_LOG then
				Log(string.format(GetEditorString(19, 8094), nPlayerIndex))
			end

			bDebug = 1
			DDZ_SetPublicDebug(bDebug)
		else
			if WRITE_LOG then
				Log(string.format(GetEditorString(19, 8105)))
			end
		end

		--将玩家手牌数据设置到公共区域
		for i = 1, DDZ_CONST_PLAYER_MAX do
			local tHandCards = DDZ_GetPlayerHand(i)
			DDZ_SetPublicPlayerHandCards(i, tHandCards) --设置当前玩家手牌设为公有数据并公开

			if WRITE_LOG then
				Log(string.format(GetEditorString(19, 8106), i))
			end
		end

		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_DEBUG_END, 0, 0, 0, 0, 0)
		return

	elseif nValue1 == DDZ_PLAYER_OPERATE_CHANGE_CARDS then
		local bDebug = DDZ_GetPublicDebug()

		if bDebug == 0  then
			if WRITE_LOG then
				Log(string.format(GetEditorString(19, 8114)))
			end
			return
		end

		if not DEBUG_DOUDIZHU then
			if WRITE_LOG then
				Log(string.format(GetEditorString(19, 8113)))
			end
			return
		end

		--解析数据
		local tCardsChange = {}
		tCardsChange[1] = {}
		tCardsChange[2] = {}

		--nValue2 解析：交互的双方id （玩家1ID *10 + 玩家2 ID），如3、2 交换手牌，则nValue2 = 3 *10 + 2 = 32
		tCardsChange[1].nPlayerIndex = nPlayerIndex
		tCardsChange[2].nPlayerIndex = nValue2

		tCardsChange[1].tChangeCards = DDZ_CardMSG2Talbe(nValue3, nValue4, 0, 0, 0)
		tCardsChange[2].tChangeCards = DDZ_CardMSG2Talbe(nValue5, nValue6, 0, 0, 0)

		tCardsChange[1].nLen = #tCardsChange[1].tChangeCards
		tCardsChange[2].nLen = #tCardsChange[2].tChangeCards

		if WRITE_LOG then
			Log(string.format(GetEditorString(19, 8142), tCardsChange[1].nPlayerIndex, tCardsChange[2].nPlayerIndex))
			Log(string.format(GetEditorString(19, 8143), tCardsChange[1].nLen, tCardsChange[2].nLen))
		end

		tCardsChange[1].tHand = DDZ_GetPlayerHand(tCardsChange[1].nPlayerIndex)
		tCardsChange[2].tHand = DDZ_GetPlayerHand(tCardsChange[2].nPlayerIndex)

		--交换赋值
		for i = 1, tCardsChange[1].nLen do
			for m = 1, #tCardsChange[1].tHand do
				if tCardsChange[1].tChangeCards[i] == tCardsChange[1].tHand[m] then
					tCardsChange[1].tHand[m] = tCardsChange[2].tChangeCards[i]
					break
				end
			end

			for n = 1, #tCardsChange[2].tHand do
				if tCardsChange[2].tChangeCards[i] == tCardsChange[2].tHand[n] then
					tCardsChange[2].tHand[n] = tCardsChange[1].tChangeCards[i]
					break
				end
			end
		end

		--交换完成设回数据
		for i = 1, 2 do
			DDZ_SetPlayerHand(tCardsChange[i].nPlayerIndex, tCardsChange[i].tHand)
			DDZ_SetPublicPlayerHandCards(tCardsChange[i].nPlayerIndex, tCardsChange[i].tHand)
		end

		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_CHANGE_END, 0, 0, 0, 0, 0)
		return
	end
end

function OnNoCheckOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)
	OnNoCostOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)
end

function OnServerOperate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)
	nPlayerIndex = nPlayerIndex + 1
	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(19, 7380), nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6))
	end
	local nTableMgrState = DDZ_GetTableMgrState()
	DDZ_SetPlayerOperateCount(nPlayerIndex, 1)

	if nValue1 == DDZ_PLAYER_OPERATE_JUMP then

		if nTableMgrState ~= DDZ_CONST_TABLE_STATE_WAIT_CS_SEND then --判断牌桌状态
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		if DDZ_GetCurOperatePlayer() ~= nPlayerIndex then --不轮你出牌，不能跳过
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		local nNextPlayer = DDZ_NextPlayer(nPlayerIndex)
		local nCardOwner = DDZ_GetCardOwner()

		--当前无人出牌，自动出一张最小牌值的牌
		if nCardOwner == 0 then
			DDZ_SendMinCards(nPlayerIndex)
			return
		end

		--设置跳过标记，注意要在 nCardOwner == nNextPlayer 之前设
		DDZ_SetPlayerOperateJump(nPlayerIndex, 1)
		DDZ_SetPlayerOperateJump(nNextPlayer, 0)

		if nCardOwner == nNextPlayer then
			--跳过后下一个玩家是之前的出牌人，表示下家的牌最大，设定当前牌桌为空，下家可以任意出牌
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(18, 9397), nPlayerIndex, nNextPlayer))
			end

			local	tDumpCardData = {
				0, 0, 0, 0, 0,
				0, 0, 0, 0, 0,
				0, 0, 0, 0, 0,
				0, 0, 0, 0, 0
			}

			DDZ_SetCardOwner(0)	--当前无人出牌
			DDZ_SetCurOperateCard(tDumpCardData)
			DDZ_SetCurOperateCardType(0, 0, 0)
			for i = 1, 3 do
				--清空所有跳过标记
				DDZ_SetPlayerOperateJump(i, 0)
			end

			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_TABLE_END_ROUND, nNextPlayer, 0, 0, 0, 0)
		end

		--设置下一个出牌的玩家
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4759), nPlayerIndex, nNextPlayer))
		end

		DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_WAIT_CS_SEND, DDZ_CONST_TABLE_STATE_WAIT_CS_SEND)
		DDZ_SetCurOperatePlayer(nNextPlayer)
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_JUMP_OPERATE, nPlayerIndex, 0, 0, 0, 0)
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CUR_PLAYER, nNextPlayer, 0, 0, 0, 0)
		DDZ_SetTimer(DDZ_CONST_TABLE_STATE_WAIT_CS_SEND, nNextPlayer)

		return
	elseif nValue1 == DDZ_PLAYER_OPERATE_MINGPAI then
		--判断当前玩家是否可以明牌
		local nPlayerMingpaiState = DDZ_GetPlayerMingPaiState(nPlayerIndex)

		if nPlayerMingpaiState > 0 then --已经明牌过了，不能明牌
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 3880), nPlayerIndex, nPlayerMingpaiState))
			end

			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end
		--明牌开始状态，需判断当前玩家手牌是否为空
		local testdata = IsNilHandCard(nPlayerIndex)
		local tHandCards = DDZ_GetPlayerHand(nPlayerIndex)

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 3900), testdata))
		end

		if nTableMgrState == DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI then
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_MINGPAI_STATE_SHUFFLE, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_MINGPAI_STATE_SHUFFLE])  --发牌前阶段明牌2倍
			DDZ_SetPlayerMingPaiState(nPlayerIndex, DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI)
			DDZ_SetPublicMingPaiState(nPlayerIndex, DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI)
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(18, 6276), nPlayerIndex, nPlayerMingpaiState))
			end
			DDZ_SetPublicPlayerHandCards(nPlayerIndex, tHandCards) --设置当前玩家手牌设为公有数据并公开
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_MINGPAI_END, nPlayerIndex, 0, 0, 0, 0)
			return
		end

	elseif nValue1 == DDZ_PLAYER_OPERATE_CHAIRMAN_TYPE then

		--玩家叫地主，判断是否有叫地主的资格
		if nValue2 == 1 then
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4317), nPlayerIndex))
			end

			if nTableMgrState ~= DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN then
				DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
				return
			end

			local nPlayerType = DDZ_GetPlayerChairManType(nPlayerIndex)
			local nChairMan = DDZ_GetChairMan()
			local nNextPlayer = DDZ_NextPlayer(nPlayerIndex)			--下家index

			if nPlayerType == 1 and nChairMan == 0 then
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4318), nPlayerIndex))
				end

				DDZ_SetChairMan(nPlayerIndex)
				DDZ_SetPlayerChairManType(nPlayerIndex, 3)
				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nPlayerIndex, 3, 0, 0, 0)

				DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_CHAIRMAN_CALL, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_CHAIRMAN_CALL])  --叫地主1倍
				DDZ_OverSetChairMan(nPlayerIndex)
				return
			else
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4290), nChairMan))
				end

				DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
				return
			end

			--玩家抢地主
		elseif nValue2 == 2 then
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4319), nPlayerIndex))
			end

			if nTableMgrState ~= DDZ_CONST_TABLE_STATE_SET_CHAIRMAN then

				DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
				return
			end
			local nPlayerType = DDZ_GetPlayerChairManType(nPlayerIndex)
			local nChairMan = DDZ_GetChairMan()

			if nPlayerType == 2 and nChairMan ~= nPlayerIndex then
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4320), nPlayerIndex))
				end

				local nNextPlayer = DDZ_NextPlayer(nPlayerIndex)
				local nPreviousPlayer = DDZ_NextPlayer(nNextPlayer)
				local nPreviousType = DDZ_GetPlayerChairManType(nPreviousPlayer)
				local nSoundType = 0

				if nPreviousType == 4 then
					nSoundType = 2
				end

				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(20, 8203), nPreviousPlayer, nPreviousType, nSoundType))
				end

				DDZ_SetChairMan(nPlayerIndex)
				DDZ_SetPlayerChairManType(nPlayerIndex, 4)
				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nPlayerIndex, 4, nSoundType, 0, 0)

				DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_CHAIRMAN_ROB, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_CHAIRMAN_ROB])  --抢地主1倍
				DDZ_OverSetChairMan(nPlayerIndex)
				return
			else
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4291), nChairMan))
				end
				DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

				return
			end

			--玩家不叫
		elseif nValue2 == 5 then
			--验证方法：当前地主是不是本消息人，不是才可以不叫
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4321), nPlayerIndex))
			end

			if nTableMgrState ~= DDZ_CONST_TABLE_STATE_SET_CHAIRMAN and nTableMgrState ~= DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN then
				DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
				return
			end

			local nPlayerType = DDZ_GetPlayerChairManType(nPlayerIndex)
			local nChairMan = DDZ_GetChairMan()
			local nNextPlayer = DDZ_NextPlayer(nPlayerIndex)
			local nNextType = DDZ_GetPlayerChairManType(nNextPlayer)

			if nPlayerIndex == nChairMan and nPlayerType == 5 then
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4540), nChairMan, nPlayerType))
				end
				DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
				return
			else
				--同步玩家不叫地主
				DDZ_SetPlayerChairManType(nPlayerIndex, 5)		--设置当前玩家为不叫
				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nPlayerIndex, 5, 0, 0, 0)

				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4201), nPlayerIndex, nNextPlayer))
				end

				if nNextType == 5 then
					--下一个玩家为不叫,没有人叫地主,先判断底牌是否有必须叫牌的情况
					local tChairManNum = {}
					local nMaxNum = 0
					local nMaxIndex = 0
					local bChairmanCompare = false

					for i = 1, 3 do
						tChairManNum[i] = DDZ_GetPlayeChairmanCompare(i)

						--找到最大的 nMaxNum
						if tChairManNum[i] > nMaxNum then
							nMaxNum = tChairManNum[i]
							nMaxIndex = i
						end
					end

					--2炸的ChairmanCompare = 51 ，调整ChairmanCompare时注意同步修改
					if nMaxNum > 50 then
						bChairmanCompare = true
					end

					--计算重新发牌次数
					local nReStart = DDZ_GetReStartNum()
					nReStart = nReStart + 1
					DDZ_SetReStartNum(nReStart)

					if DDZ_WRITE_LOG then
						Log(string.format(GetEditorString(17, 4218), nReStart))
					end

					if nReStart >= 3 or bChairmanCompare then
						if bChairmanCompare then
							--对nNextPlayer 重新赋值
							nNextPlayer = nMaxIndex
							if DDZ_WRITE_LOG then
								Log(string.format(GetEditorString(19, 8016), nNextPlayer, nMaxNum))
							end
						else
							if DDZ_WRITE_LOG then
								Log(string.format(GetEditorString(17, 6019), nNextPlayer))
							end
						end

						--只重新发3次,之后设定第一个人为地主,跳过抢地主阶段.此时第一个人为nNextPlayer
						DDZ_SetChairMan(nNextPlayer)
						DDZ_SetPlayerChairManType(nNextPlayer, 3)
						DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_CHAIRMAN_CALL, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_CHAIRMAN_CALL])  --叫地主1倍
						DDZ_OverChairMan(nNextPlayer)
						DDZ_SendAndSetTableMgrState(DDZ_PLAYER_OPERATE_SET_CHAIRMAN, DDZ_CONST_TABLE_STATE_SHOW_CHAIRMAN)
						DDZ_SetTimer(DDZ_CONST_TABLE_STATE_SHOW_CHAIRMAN, - 1)
						return
					else
						--重发<3,重新发牌
						DDZ_SettleAccounts() --叶子令返还
						DDZ_SetPlayerWinner(0) --初始化胜利玩家
						DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN, DDZ_CONST_TABLE_STATE_INIT)
						DDZ_SetTimer(DDZ_CONST_TABLE_STATE_INIT, - 1)

						return
					end
				end

				DDZ_SetPlayerChairManType(nNextPlayer, 1)  --设置下一个玩家数据为是否可以叫地主

				DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN, DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN)
				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nNextPlayer, 1, 0, 0, 0)
				DDZ_SetTimer(DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN, nNextPlayer)
				return
			end

			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
			return
			--玩家不抢
		elseif nValue2 == 6 then
			--验证方法：当前地主是不是本消息人，不是才可以不叫
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4321), nPlayerIndex))
			end

			if nTableMgrState ~= DDZ_CONST_TABLE_STATE_SET_CHAIRMAN and nTableMgrState ~= DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN then
				DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
				return
			end

			local nPlayerType = DDZ_GetPlayerChairManType(nPlayerIndex)
			local nChairMan = DDZ_GetChairMan()

			if nPlayerIndex == nChairMan and nPlayerType == 6 then
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4540), nChairMan, nPlayerType))
				end
				DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
				return
			else
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(18, 5233), nPlayerIndex))
				end
				DDZ_SetPlayerChairManType(nPlayerIndex, 6)
				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nPlayerIndex, 6, 0, 0, 0)
				DDZ_OverSetChairMan(nPlayerIndex)
				return
			end

			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
			return
		end

	elseif nValue1 == DDZ_PLAYER_OPERATE_DOUBLE_TYPE then
		--玩家选择加倍
		local nDoubleType = DDZ_GetPlayerDoubleType(nPlayerIndex)

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4513), nPlayerIndex))
		end

		if nTableMgrState ~= DDZ_CONST_TABLE_STATE_DOUBLE then
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
			return
		end

		if nDoubleType ~= 0 then
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
			return
		end

		if nValue2 == 1 then
			--普通加倍
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4514), nPlayerIndex))
			end
			DDZ_SetPlayerDoubleType(nPlayerIndex, 1)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_DOUBLE_PLAYER, nPlayerIndex, 1, 0, 0, 0) --广播普通加倍
			DDZ_AddCardsTimes(nPlayerIndex, DDZ_CONST_TIMES_DOUBLE_TYPE_NORMAL, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_TYPE_NORMAL])  --普通加倍

			return
		elseif nValue2 == 2 then
			--超级加倍
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4515), nPlayerIndex))
			end
			DDZ_SetPlayerDoubleType(nPlayerIndex, 2)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_DOUBLE_PLAYER, nPlayerIndex, 2, 0, 0, 0) --广播普通加倍
			DDZ_AddCardsTimes(nPlayerIndex, DDZ_CONST_TIMES_DOUBLE_TYPE_SUPER, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_TYPE_SUPER])  --超级加倍

			return
		elseif nValue2 == 3 then
			--玩家选择不加倍
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4516), nPlayerIndex))
			end
			DDZ_SetPlayerDoubleType(nPlayerIndex, 3)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_DOUBLE_PLAYER, nPlayerIndex, 3, 0, 0, 0) --广播不加倍

			return
		else
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
			return
		end

	elseif nValue1 == DDZ_PLAYER_OPERATE_CS_SEND then
		--判断牌桌状态，不该你出牌不能出牌
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4863), DDZ_GetCurOperatePlayer(), nPlayerIndex))
		end

		if nTableMgrState ~= DDZ_CONST_TABLE_STATE_WAIT_CS_SEND then --判断牌桌状态
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		if DDZ_GetCurOperatePlayer() ~= nPlayerIndex then  --不该你出牌,不能出牌
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end
		local nNextPlayer = DDZ_NextPlayer(nPlayerIndex)
		local nPreviousPlayer = DDZ_NextPlayer(nNextPlayer)		--上家index
		local nHandCardsNum = DDZ_GetPlayerCardsNum(nPlayerIndex)
		local tHandCards = DDZ_GetPlayerHand(nPlayerIndex)
		local tOperateCards = DDZ_CardMSG2Talbe(nValue2, nValue3, nValue4, nValue5, nValue6) --该牌值之后会被覆盖，客户端用牌桌上出的牌为未修改的牌值，故新增tCurOperateCard
		local tCurOperateCard = DDZ_CardMSG2Talbe(nValue2, nValue3, nValue4, nValue5, nValue6)
		local nCardLen = #tOperateCards
		local tCardType = DDZ_GetCardType(tOperateCards)  --将当前牌转换成牌类型
		local tCurType = DDZ_GetCurOperateCardType()			--上一轮出牌的类型
		local nCardsFirst = DDZ_GetPlayerCardsFirst(nPlayerIndex)
		local nPlayerMingpaiState = DDZ_GetPlayerMingPaiState(nPlayerIndex)
		local tCardsLast = DDZ_GetPublicCardsLast()
		local laizi = DDZ_GetPrivateLaiZi()
		local nTableSettingType = DDZ_GetTableSettingType()
		local nCardsLastNum = 0 --当前记牌器所剩总牌数
		local tAllCardsType = DDZ_OperateLaiziType(nTableSettingType, nCardLen)
		local bDebug = DDZ_GetPublicDebug()
		local bNotCardsType = true
		local nChairMan = DDZ_GetChairMan()
		local nAchievementBomb = DDZ_GetAchievementBomb(nPlayerIndex)
		local nAchievementSpring = DDZ_GetAchievementSpring(nPlayerIndex)

		if not tCardType or tCardType[1] == DDZ_CONST_CARD_TYPE_ERROR then --检测牌形异常返回报错
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4931)))
			end
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		--判断牌型是否与规则一致
		if not tAllCardsType or #tAllCardsType == 0 then
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(19, 6885)))
			end
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		--判断牌型是否与规定牌型一致
		for k, v in pairs(tAllCardsType) do
			if v[1] == tCardType[1] then
				bNotCardsType = false
				break
			end
		end

		if bNotCardsType then
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(19, 7405)))
			end
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		--正常出牌
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4935), tCardType[1], tCardType[2], tCardType[3]))
		end
		--出牌大小判定如果上一轮牌比当前出牌大,不能出牌,并且出牌玩家不是上一轮的出牌玩家（牌桌上有别人出的牌）
		if DDZ_CompareCardType(tCardType, tCurType) and nPlayerIndex ~= DDZ_GetCardOwner() then
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4936), DDZ_GetCardOwner(), tCurType[1], tCurType[2]))
			end
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		--计算当前玩家一共打出多少张牌，计算需要在tCardsLast修改之前
		nCardsLastNum = DDZ_CONST_CARDS_NUM - DDZ_TableSum(tCardsLast)
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 6011), nCardsLastNum))
		end

		--从手牌中扣除当前出牌，首先将赖子牌替换成原牌值扣除
		for k, v in pairs(tOperateCards) do
			tOperateCards[k] = GetRealValueFromLaiziCard(v, laizi)
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4943), k, tOperateCards[k]))
			end
		end

		if DDZ_WRITE_LOG then
			for k, v in pairs(tCardsLast) do
				Log(string.format(GetEditorString(18, 7647), k, v))
			end
		end

		if DDZ_TalbeComplement(tHandCards, tOperateCards, tCardsLast, nPlayerIndex) then
			nHandCardsNum = nHandCardsNum - nCardLen
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4760)))
				for k, v in pairs(tHandCards) do
					Log(string.format(GetEditorString(17, 4938), k, v))
				end
				Log(string.format(GetEditorString(17, 4847), nPlayerIndex, nHandCardsNum))
				for k, v in pairs(tCardsLast) do
					Log(string.format(GetEditorString(18, 5932), k, v))
				end
			end
			DDZ_SetPlayerCardsNum(nPlayerIndex, nHandCardsNum)
			DDZ_SetPublicCardsNum(nPlayerIndex, nHandCardsNum)
			DDZ_SetPlayerHand(nPlayerIndex, tHandCards)
			DDZ_SetPublicCardsLast(tCardsLast)

			if nPlayerMingpaiState > 0 then
				--玩家明牌，同步修改PublicData数据
				DDZ_SetPublicPlayerHandCards(nPlayerIndex, tHandCards)
			end

			if bDebug == 1 then
				--玩家进入debug状态
				DDZ_SetPublicPlayerHandCards(nPlayerIndex, tHandCards)
			end

		else
			--出牌值非法
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4875)))
			end
			return
		end

		--出牌牌值语音
		local nSoundID = 0
		local tSound = {}
		if DDZ_SOUND_CARD[tCardType[1]] and type(DDZ_SOUND_CARD[tCardType[1]]) == "table" then
			if tCardType[1] == DDZ_CONST_CARD_TYPE_SINGLE or tCardType[1] == DDZ_CONST_CARD_TYPE_DOUBLE then
				local temp = DDZ_SOUND_CARD[tCardType[1]][tCardType[2]]
				if temp then
					table.insert(tSound, temp)
				end
			elseif tCardType[1] == DDZ_CONST_CARD_TYPE_TRIPLE_SINGLE or tCardType[1] == DDZ_CONST_CARD_TYPE_TRIPLE_DOUBLE then
				--三带1、三带2 需要处理配音是飞机的逻辑
				if tCardType[3] == 1 then
					local temp = DDZ_SOUND_CARD[tCardType[1]][1]
					if temp then
						table.insert(tSound, temp)
					end
				else
					for i = 1, 2 do
						--DDZ_SOUND_CARD 特殊规则，index=2、3 表示两种飞机的语音
						local temp = DDZ_SOUND_CARD[tCardType[1]][i + 1]
						if temp then
							table.insert(tSound, temp)
						end
						--飞机的最大牌值判断写在这里
						if tCardType[2] == 0x0c then
							temp = DDZ_SOUND_SEND[2][1]
							if temp then
								table.insert(tSound, temp)
							end
						end
					end
				end
			else
				--其余的类型语音加入
				for k, v  in pairs(DDZ_SOUND_CARD[tCardType[1]]) do
					if v then
						table.insert(tSound, v)
					end
				end
			end

			--通用出牌语音加入
			if #tSound ~= 0 then
				local ntempRandom = math.random(DDZ_SOUND_RANDOM[1])
				if ntempRandom < DDZ_SOUND_RANDOM[2] and tCurType[2] ~= 0 and tCardType[1] ~= DDZ_CONST_CARD_TYPE_ROCKET then
					table.insert(tSound, DDZ_SOUND_SEND[1][1])
				end
			end

			--最大出牌值加入，注意连牌最大值为0x0c，其余最大值为0x0d
			if tCardType[1] == DDZ_CONST_CARD_TYPE_SINGLE_LINE or tCardType[1] == DDZ_CONST_CARD_TYPE_DOUBLE_LINE or tCardType[1] == DDZ_CONST_CARD_TYPE_TRIPLE_LINE then
				if tCardType[2] == 0x0c then
					local temp = DDZ_SOUND_SEND[2][1]
					local ntempRandom = math.random(DDZ_SOUND_RANDOM[1])
					if ntempRandom < DDZ_SOUND_RANDOM[3] then
						if temp then
							table.insert(tSound, temp)
						end
					end
				end
			else
				if tCardType[1] ~= DDZ_CONST_CARD_TYPE_ROCKET then
					if tCardType[2] == 0x0d then
						local temp = DDZ_SOUND_SEND[2][1]
						local ntempRandom = math.random(DDZ_SOUND_RANDOM[1])
						if ntempRandom < DDZ_SOUND_RANDOM[3] then
							if temp then
								table.insert(tSound, temp)
							end
						end
					end
				end
			end

			--刚好压过的情况
			if tCardType[2] - tCurType[2] == 1 and tCurType[2] ~= 0 then
				local temp = DDZ_SOUND_SEND[3]
				if temp and type(temp) == "table" then
					for k, v in pairs(temp) do
						local ntempRandom = math.random(DDZ_SOUND_RANDOM[1])
						if ntempRandom < DDZ_SOUND_RANDOM[4] then
							table.insert(tSound, v)
						end
					end
				end
			end

			local nLen = #tSound
			local nRandom = 0
			if nLen ~= 0 then
				nRandom = math.random(nLen)
			end

			nSoundID = tSound[nRandom]

			if DDZ_WRITE_LOG then
				for k, v in pairs(tSound) do
					Log(string.format(GetEditorString(20, 8220), tCardType[1], tCardType[2], v))
				end
				Log(string.format(GetEditorString(20, 8221), nLen, nRandom, nSoundID))
			end
		else
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(20, 8222), tCardType[1], tCardType[2]))
			end
		end

		--还剩两张牌
		if nHandCardsNum == 2 then
			nSoundID = DDZ_SOUND_SEND[4][1]
		end

		--出牌成功广播当前出牌,设定服务器数据，当前出牌人、出牌值、当前出牌类型
		DDZ_SetCardOwner(nPlayerIndex)    --当前出牌人
		DDZ_SetCurOperateCard(tCurOperateCard)   --出牌值，注意不能用tOperateCards，此时tOperateCards已被替换
		DDZ_SetCurOperateCardType(tCardType[1], tCardType[2], tCardType[3]) --出牌类型
		DDZ_SetPrivateCardsPile(tOperateCards, nCardsLastNum)
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_CUR_CARD, nPlayerIndex, nSoundID, 0, 0, 0)

		--重置下家的跳过标记
		DDZ_SetPlayerOperateJump(nNextPlayer, 0)

		--炸弹翻倍
		if tCardType[1] == DDZ_CONST_CARD_TYPE_ROCKET then --王炸
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_DOUBLE_BOMB_ROCKET, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_BOMB_ROCKET])
			nAchievementBomb = nAchievementBomb + 1
		end

		if tCardType[1] == DDZ_CONST_CARD_TYPE_BOMB4_BIG then --硬炸
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_DOUBLE_BOMB_BIG, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_BOMB_BIG])
			nAchievementBomb = nAchievementBomb + 1
		end

		if tCardType[1] == DDZ_CONST_CARD_TYPE_BOMB4 then --软炸
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_DOUBLE_BOMB_LAIZI, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_BOMB_LAIZI])
			nAchievementBomb = nAchievementBomb + 1
		end

		if tCardType[1] > DDZ_CONST_CARD_TYPE_BOMB4_BIG and tCardType[1] < DDZ_CONST_CARD_TYPE_ROCKET then		--多星炸弹
			for i = 1, (tCardType[1] - DDZ_CONST_CARD_TYPE_BOMB4_BIG) do
				--从DDZ_CONST_CARD_TYPE 枚举算，每多一则加倍一次
				DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_DOUBLE_BOMB_LAIZI, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_BOMB_LAIZI])
			end
			nAchievementBomb = nAchievementBomb + 1
		end

		--成就相关
		nAchievementSpring = nAchievementSpring + 1
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8709), nPlayerIndex, nAchievementSpring, nAchievementBomb))
		end

		DDZ_SetAchievementBomb(nPlayerIndex, nAchievementBomb)
		DDZ_SetAchievementSpring(nPlayerIndex, nAchievementSpring)

		if nAchievementBomb >= 4 then
			DDZ_Achievement(nPlayerIndex, 9425, 0)
		end

		if tCardType[1] == DDZ_CONST_CARD_TYPE_SINGLE_LINE and tCardType[3] == 12  then
			DDZ_Achievement(nPlayerIndex, 9429, 0)
		end

		if tCardType[1] == DDZ_CONST_CARD_TYPE_DOUBLE_LINE and tCardType[3] >= 6 then
			DDZ_Achievement(nPlayerIndex, 9430, 0)
		end

		--记录第一次出牌的张数
		if nCardsFirst == 0 then
			nCardsFirst = nCardLen
			DDZ_SetPlayerCardsFirst(nPlayerIndex, nCardsFirst)
		end

		--跳转到结算界面
		if nHandCardsNum == 0 then
			--玩家把牌打完，进入结算
			DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_WAIT_CS_SEND, DDZ_CONST_TABLE_STATE_SETTLEMENT)
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4762), nPlayerIndex))
			end

			--结束时将所有玩家手牌设为公开
			for i = 1, DDZ_CONST_PLAYER_MAX do
				local tHandCards = DDZ_GetPlayerHand(i)
				DDZ_SetPublicPlayerHandCards(i, tHandCards)

				if WRITE_LOG then
					Log(string.format(GetEditorString(19, 8106), i))
				end
			end

			--广播胜利玩家
			DDZ_SetPlayerWinner(nPlayerIndex)
			DDZ_SetPlayerWinnerBool(nPlayerIndex, 1)

			--农民胜利时，需要设定另外一个家也胜利
			if nNextPlayer == nChairMan then
				DDZ_SetPlayerWinnerBool(nPreviousPlayer, 1)
			else
				if nPreviousPlayer == nChairMan then
					DDZ_SetPlayerWinnerBool(nNextPlayer, 1)
				end
			end

			--结算春天
			DDZ_EndingSpring(nChairMan, nPlayerIndex)

			--UI要求胜利也需要设置一下下个玩家
			DDZ_SetCurOperatePlayer(nNextPlayer)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CUR_PLAYER, nNextPlayer, 0, 0, 0, 0)

			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_WINNER, nPlayerIndex, 0, 0, 0, 0)
			DDZ_SetTimer(DDZ_CONST_TABLE_STATE_SETTLEMENT, - 1)
		else
			DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_WAIT_CS_SEND, DDZ_CONST_TABLE_STATE_WAIT_CS_SEND)
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4763), nPlayerIndex, nNextPlayer))
			end
			DDZ_SetCurOperatePlayer(nNextPlayer)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CUR_PLAYER, nNextPlayer, 0, 0, 0, 0)
			DDZ_SetTimer(DDZ_CONST_TABLE_STATE_WAIT_CS_SEND, nNextPlayer)
		end
		return
	end
end

function DDZ_InitTableMgr()
	--获取记录数据
	local cashBase = DDZ_GetCashBase()
	local nReStart = DDZ_GetReStartNum() --重新洗牌数
	local nLaiziNum = DDZ_GetLaiZiNum()
	local nShuffleType = DDZ_GetShuffleType()
	local nPlayerMingpaiState = {0, 0, 0}
	local tPlayerIsAgent = {0, 0, 0}
	local nTableSettingType = DDZ_GetTableSettingType()
	local tCardsPile = DDZ_GetPrivateCardsPile()
	local nWinner = DDZ_GetPlayerWinner()

	for i = 1, DDZ_CONST_PLAYER_MAX do
		nPlayerMingpaiState[i] = DDZ_GetPlayerMingPaiState(i)
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 6288), i, nPlayerMingpaiState[i]))
		end
	end

	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(19, 6906), nLaiziNum))
	end
	--清空数据
	ResetMem()

	--初始化记录数据
	DDZ_SetCashBase(cashBase)  --初始化底分
	DDZ_SetReStartNum(nReStart)   --初始化重新发牌数
	DDZ_SetLaiZiNum(nLaiziNum)    --癞子数量
	DDZ_SetShuffleType(nShuffleType)    --是否洗牌模式
	DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_INITIAL_CARDS, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_INITIAL_CARDS]) --初始番设定
	DDZ_SetTableSettingType(nTableSettingType)
	DDZ_SetPlayerWinner(nWinner)

	for i = 1, DDZ_CONST_PLAYER_MAX do
		DDZ_AddCardsTimes( i, DDZ_CONST_TIMES_INITIAL_CARDS, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_INITIAL_CARDS]) --初始番设定
		ReadPlayerDouDiZhuDatas(i)
		DDZ_SetPlayerMingPaiState(i, nPlayerMingpaiState[i])   --设置明牌状态
		DDZ_SetPublicMingPaiState(i, nPlayerMingpaiState[i])

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 6289), i, nPlayerMingpaiState[i]))
		end

		--设置初始
		DDZ_SetPublicCardsNum(i, 17)
		DDZ_SetPlayerCardsNum(i, 17)
	end

	if nShuffleType ~= 1 then  --不洗牌模式
		DDZ_SetPrivateCardsPile(tCardsPile, 0)
	end

	--底牌番数
	DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS]) --底牌番设定

	--随机赖子牌,先随机赖子
	DDZ_RandomAndSetLaiZi(nLaiziNum)

	--初始化记牌器
	DDZ_SetPublicCardsLast(DDZ_CONST_TABLE_CARDS_LAST)

	--设置初始通讯次数
	DDZ_SetPlayerOperateCount( - 1, 1)

	--设置结算次数
	DDZ_SetNeedSettleAccounts(1)
end

function ResetMem()
	miniGameMgr1.ClearData()
end

function DDZ_RandomAndSetLaiZi(nLaiziNum)
	local laizi = DDZ_GetPrivateLaiZi()
	if laizi[1] == 0 and laizi[2] == 0 then
		laizi = RandomLaizi()
		if nLaiziNum == 2 then
			DDZ_SetPrivateLaiZi(laizi[1], laizi[2])
		elseif nLaiziNum == 1 then
			DDZ_SetPrivateLaiZi(0, laizi[2])
		else
			DDZ_SetPrivateLaiZi(0, 0)
		end
	end
	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(17, 3629), laizi[1]))
		Log(string.format(GetEditorString(17, 3630), laizi[2]))
	end
end

function DDZ_ShuffleCardsAndSendCards(nShuffleType)
	local allCards = {}
	local bShuffle = true

	if nShuffleType == 1 then  --洗牌模式
		allCards = DDZ_NormalShuffle()
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 6283)))
		end
	else
		local tCardsPile = DDZ_GetPrivateCardsPile()
		for k, v in pairs(tCardsPile) do
			if v == 0 then
				bShuffle = false
				break
			end
		end
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8414), tCardsPile[1], tostring(bShuffle)))
		end
		if bShuffle then
			allCards = DDZ_NoShuffle(tCardsPile)
			--记录牌值清空
			local tNilCards = {}
			for i = 1, 54 do
				tNilCards[i] = 0
			end
			DDZ_SetPrivateCardsPile(tNilCards, 0)
		else
			allCards = DDZ_NormalShuffle()
		end
	end

	--测试数据
	--local allCards = {
	--0x01,0x11,0x02,0x12,0x03,0x13,0x04,0x14,0x24,0x05,0x15,0x06,0x16,0x07,0x17,0x09,0x19,
	--0x21,0x22,0x23,0x34,0x25,0x35,0x26,0x36,0x27,0x37,0x08,0x18,0x29,0x39,0x0A,0x1A,0x0B,
	--0x2A,0x3A,0x28,0x38,0x1B,0x2B,0x3B,0x0C,0x1C,0x2C,0x3C,0x0D,0x1D,0x2D,0x31,0x32,0x33,
	--0x3D, 0x0E, 0x0F
	--}

	if DDZ_WRITE_LOG then
		for k, v in pairs(allCards) do
			Log(string.format("ShuffleCards: k: %d, v: %#x", k, v))
		end
	end

	local offset = 0
	for i = 1, 3 do
		offset = (i - 1) * 17 + 1
		local handCard = {}
		for j = offset, offset + 16 do
			handCard[j - offset + 1] = allCards[j]
		end
		DDZ_SetPlayerHand(i, handCard)
	end
	DDZ_SetPrivateBottomCards(allCards, 52)

	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(20, 8215), allCards[52], allCards[53], allCards[54]))
	end
end

function DDZ_ReplaceLaizi(nLaiziIndex)
	--将手牌中的癞子牌牌值替换
	local laizi = DDZ_GetPrivateLaiZi()
	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(20, 8150), nLaiziIndex, laizi[nLaiziIndex]))
	end
	for i = 1, DDZ_CONST_PLAYER_MAX do
		local tHandCards = DDZ_GetPlayerHand(i)
		local tReplace, nLaiziNum = DDZ_CardsValue2LaiziValue(tHandCards, laizi[nLaiziIndex])
		local nAchLaiziNum = DDZ_GetAchievementLaiNum(i)
		nAchLaiziNum = nAchLaiziNum + nLaiziNum

		DDZ_SetAchievementLaiNum(i, nAchLaiziNum)
		DDZ_SetPlayerHand(i, tReplace)

		local nPlayerMingpaiState = DDZ_GetPlayerMingPaiState(i)
		if nPlayerMingpaiState > 0 then
			DDZ_SetPublicPlayerHandCards(i, tReplace)
		end

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 9159), nLaiziIndex, nAchLaiziNum))
		end

		--底牌癞子容错
		local temp = 0
		for k, v in pairs(tReplace) do
			if v > 0x40 then
				temp = temp + 1
			end
		end
		--癞子成就
		if nAchLaiziNum >= 4 or temp >= 4 then
			DDZ_Achievement(i, 9432, 0)
		end

		if nAchLaiziNum >= 8 or temp >= 8 then
			DDZ_Achievement(i, 9433, 0)
		end

		--给客户端发消息
		DDZ_SendMsg2Client(i, DDZ_PLAYER_OPERATE_PLAYERHAND, 0, 0, 0, 0, 0)
	end
	local tBottomCard = DDZ_GetPrivateBottomCards()
	local tBottomReplace = DDZ_CardsValue2LaiziValue(tBottomCard, laizi[nLaiziIndex])
	DDZ_SetPrivateBottomCards(tBottomReplace, 1)
end

function DDZ_SendAndSetTableMgrState(state_end, state_begin)
	--接口参数顺序为，上一个牌桌结束状态、下一个牌桌开启状态即从A到B状态
	DDZ_SetTableMgrState(state_begin)

	if state_begin == DDZ_CONST_TABLE_STATE_KILL_DOUDIZHU or state_begin == DDZ_CONST_TABLE_STATE_END_GAME then
		miniGameMgr1.SetGameState(0)
	elseif state_begin == DDZ_CONST_TABLE_STATE_INIT then
		miniGameMgr1.SetGameState(1)
	end

	DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_TABLE_STATE_END, state_end, 0, 0, 0, 0)
	DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_TABLE_STATE_BEGIN, state_begin, 0, 0, 0, 0)
end

function DDZ_SetTimer(nTimeID, nPlayerID)
	local time = 0
	local timeStamp = 0
	if nTimeID > 0 then
		time = DDZ_CONST_COUNT_DOWN_TIME[nTimeID]
	end
	if time <= 0 then
		if DDZ_WRITE_LOG then
			Log(GetEditorString(16, 6010))
		end
		miniGameMgr1.SetTimer()
		timeStamp = DDZ_SetCountDownTime(0, 0, - 1)
	else
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 623), nTimeID, nPlayerID))
		end

		if nPlayerID > 0 and nPlayerID < 4 then
			if DDZ_GetPlayerIsAgent(nPlayerID) == 1 then --挂机状态强行设置时间为5s
				time = DDZ_CONST_COUNT_DOWN_TIME[DDZ_CONST_TABLE_STATE_WAIT_CS_SEND_AGENT]
				if nTimeID == DDZ_CONST_TABLE_STATE_WAIT_CS_SEND then --跳过SEND状态：由于SEND1状态要用作玩家操作超时计数（大于2进入托管状态），所以加一个Agent状态（非真实tableMgr状态，计时器标识）
					nTimeID = DDZ_CONST_TABLE_STATE_WAIT_CS_SEND_AGENT
				end
			end

			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(19, 8010), DDZ_GetPlayerIsAgent(nPlayerID), time, nTimeID, nPlayerID))
			end
		end

		if DDZ_AUTO_TEST and DEBUG_DOUDIZHU then
			time = 1
		end

		if nTimeID == DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI then
			--三个玩家都明牌了，明牌阶段变为1s
			local bJumpMingPai = true
			for i = 1, DDZ_CONST_PLAYER_MAX do
				local nPlayerMingpaiState = DDZ_GetPlayerMingPaiState(i)
				if nPlayerMingpaiState == 0 then
					bJumpMingPai = false
					break
				end
			end

			if bJumpMingPai then
				time = 1
			end
		end

		--考虑是否需要在某些阶段增加1s延时
		--if nTimeID == CONST_TABLE_STATE_WAIT_CS_SEND_AGENT then
		--time = time + 1 -- 挂机出牌和出牌状态、第一轮倒计时，时间增加1s，for网络延迟
		--end

		miniGameMgr1.SetTimer(time, nTimeID, nPlayerID)
		timeStamp = DDZ_SetCountDownTime(time, nTimeID, nPlayerID)
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 111), timeStamp, time, nTimeID, nPlayerID))
		end
	end

	--需要同步倒计时的阶段
	if nTimeID == DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN or nTimeID == DDZ_CONST_TABLE_STATE_SET_CHAIRMAN or nTimeID == DDZ_CONST_TABLE_STATE_DOUBLE
		or nTimeID == DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI or nTimeID == DDZ_CONST_TABLE_STATE_WAIT_CS_SEND or nTimeID == DDZ_CONST_TABLE_STATE_WAIT_CS_SEND_AGENT then
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_TIME, nPlayerID, timeStamp, nTimeID, 0, 0)
	end

end

function DDZ_AddCardsTimes(nPlayerIndex, state, nTimes)
	local nLaiziNum = DDZ_GetLaiZiNum()  --获取癞子玩法标记
	local nTableStateTime = DDZ_GetPublicTimesTableState(state)
	--加倍次数
	DDZ_SetPublicTimesTableState(state, nTableStateTime + 1)
	--判断当前的牌桌状态，增加对应的番数
	if nPlayerIndex == -1 then
		local nPublicCardsTimes = DDZ_GetPublicCardsTimes()
		if nPublicCardsTimes == 0  then
			nPublicCardsTimes = 1 --连乘关系需设定初始值为1
		end

		nPublicCardsTimes = nPublicCardsTimes * nTimes

		if nPublicCardsTimes > DDZ_CONST_MAX_TIMES then
			--斗地主数据保护
			nPublicCardsTimes = DDZ_CONST_MAX_TIMES
		end

		DDZ_SetPublicCardsTimes(nPublicCardsTimes)
		--公共翻倍的nValue2的值为4

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 5670), state, nTimes, nPublicCardsTimes))
		end
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_CAERDS_TIMES, 4, state, nTimes, nPublicCardsTimes, 0)  --每次番数变更给客户端发消息，携带参数：当前玩家、番数类型、当前增加的番数、当前总番数
	else
		local nPlayerCardsTimes = DDZ_GetPlayerCardsTimes(nPlayerIndex)
		if nPlayerCardsTimes == 0 then
			nPlayerCardsTimes = 1
		end

		nPlayerCardsTimes = nPlayerCardsTimes * nTimes
		DDZ_SetPlayerCardsTimes(nPlayerIndex, nPlayerCardsTimes)

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 5669), nPlayerIndex, state, nTimes, nPlayerCardsTimes))
		end

		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_CAERDS_TIMES, nPlayerIndex, state, nTimes, nPlayerCardsTimes, 0)
	end

end

--判断玩家的手牌是否全为0，手牌检测
function IsNilHandCard(nPlayerIndex)
	local tHandCard = DDZ_GetPlayerHand(nPlayerIndex)
	local nISNil = 0
	for k, v in pairs(tHandCard) do
		if v ~= 0 then
			nISNil = 1
			return nISNil
		end
	end
	return nISNil
end

--判断玩家的初始手牌，决定谁是地主
function DDZ_ChairManFirst()
	local tHandCard = {}
	local tChairManNum = {}
	local laizi = DDZ_GetPrivateLaiZi()
	for nPlayerIndex = 1, 3 do

		tHandCard = DDZ_GetPlayerHand(nPlayerIndex)
		tChairManNum[nPlayerIndex] = DDZ_ChairManCompare(tHandCard, laizi)

		DDZ_SetPlayerChairmanCompare(nPlayerIndex, tChairManNum[nPlayerIndex])

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4148), nPlayerIndex, tChairManNum[nPlayerIndex]))
		end

		tHandCard = {}
	end

	--找到地主值最大的nPlayerIndex 并返回
	local nMax = TableMaxn(tChairManNum)
	for nPlayerIndex = 1, 3 do
		if tChairManNum[nPlayerIndex] == nMax then
			return nPlayerIndex
		end
	end
end

function DDZ_NextPlayer(nPlayerIndex)
	return (nPlayerIndex % 3 + 1)
end

function DDZ_OverChairMan(nChairMan)
	--确定地主之后，地主及农民牌型初始化
	local nNextPlayer = DDZ_NextPlayer(nChairMan)			--下家index	
	local nPreviousPlayer = DDZ_NextPlayer(nNextPlayer)		--上家index
	local tBottomCard = DDZ_GetPrivateBottomCards() 		--获取底牌
	local tBottomCardMerge = DDZ_CardTable2MSG(tBottomCard) --底牌转为信息牌格式
	local nPlayerMingpaiState = DDZ_GetPlayerMingPaiState(nChairMan)

	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(17, 4273), nChairMan))
	end

	--获取底牌，将底牌公开，发底牌给地主，进行底牌番数判定
	DDZ_SetPublicBottomCards(tBottomCard, 1)
	DDZ_SetBottom2PlayerHand(nChairMan, tBottomCard)
	DDZ_BottomCardTimes(tBottomCard)

	--判断地主是否明牌，同步修改PublicData数据
	if nPlayerMingpaiState > 0 then
		local tHandCards = DDZ_GetPlayerHand(nChairMan)
		DDZ_SetPublicPlayerHandCards(nChairMan, tHandCards)
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_MINGPAI_END, nChairMan, 0, 0, 0, 0)
	end

	--设置玩家初始手牌数量,地主20,其他17
	DDZ_SetPlayerCardsNum(nChairMan, 20)
	DDZ_SetPlayerCardsNum(nNextPlayer, 17)
	DDZ_SetPlayerCardsNum(nPreviousPlayer, 17)
	--考虑是否一开始就展示数手牌剩余数据
	DDZ_SetPublicCardsNum(nChairMan, 20)
	DDZ_SetPublicCardsNum(nNextPlayer, 17)
	DDZ_SetPublicCardsNum(nPreviousPlayer, 17)

	--地主判定结束，设定地主,给地主发底牌,广播底牌
	DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nChairMan, 0, 0, 0, 0) --特殊设定，本次不播语音
	DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_BOTTOM_CARD, tBottomCardMerge[1], 0, 0, 0, 0)
	DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_PLAYERHAND, 0, 0, 0, 0, 0)

	--成就，三张是一样的底牌
	local nTableStateTime = DDZ_GetPublicTimesTableState(DDZ_CONST_TIMES_BOTTOM_CARDS_TRIPLE)
	if nTableStateTime >= 1 then
		DDZ_Achievement(nChairMan, 9431, 0)
	end
end

function  DDZ_BottomCardTimes(tBottomCard)
	if type(tBottomCard) ~= "table" then
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8545)))
		end
		return
	end

	local tAnsBottomCard = {}  --只有牌值的底牌，用于分析底牌番数
	local tLineBottomCard = {} --检测底牌连牌
	local bJoker = {false, false}

	for k, v in pairs(tBottomCard) do
		local temp = GetCardValueFromLaiziCard(v)
		table.insert(tAnsBottomCard, temp) 		--将手牌转化为牌值
		if temp == 0x0E then
			bJoker[1] = true
		end
		if temp == 0x0F then
			bJoker[2] = true
		end
	end

	if bJoker[1] == true and bJoker[2] == true then
		DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_ROCKET, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_ROCKET]) --排序后两张为双王
		return
	end

	if bJoker[1] == true and bJoker[2] == false then
		DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_SJOKER, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_SJOKER]) --单小王翻倍
	end

	if bJoker[1] == false and bJoker[2] == true then
		DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_BJOKER, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_BJOKER]) --单大王翻倍
	end

	--同花判断，同花不能是王
	if bJoker[1] == false and bJoker[2] == false then
		if GetCardColorFromLaiziCard(tBottomCard[1]) == GetCardColorFromLaiziCard(tBottomCard[2]) and GetCardColorFromLaiziCard(tBottomCard[1]) == GetCardColorFromLaiziCard(tBottomCard[3]) then
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_FLUSH, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_FLUSH]) --底牌三张为同花
		end
	end

	table.sort(tAnsBottomCard)		--底牌排序方便比较
	if tAnsBottomCard[1] == tAnsBottomCard[2] then
		if tAnsBottomCard[2] == tAnsBottomCard[3] then
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_TRIPLE, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_TRIPLE]) --底牌三张一样
			return
		else
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_DOUBLE, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_DOUBLE])	--底牌对子
			return
		end
	elseif tAnsBottomCard[2] == tAnsBottomCard[3] then
		DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_DOUBLE, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_DOUBLE])		--底牌对子
		return
	end

	local bLineResult = CheckInLine(tAnsBottomCard, 1, tLineBottomCard)
	if bLineResult then
		DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_LINE, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_LINE])		--底牌3连
		return
	end
end

function DDZ_WinnerCash()
	--结算公式为： 牌局底分 * 公共翻倍 * 个人翻倍 * 地主翻倍 = 个人流水 DDZ_GetCashBase() *  DDZ_GetPublicCardsTimes() * DDZ_GetPlayerCardsTimes(nNextPlayer) * DDZ_GetPlayerCardsTimes(nWinner)
	local nWinner = DDZ_GetPlayerWinner()
	local nChairMan = DDZ_GetChairMan()
	local nPublicCardsTimes = DDZ_GetPublicCardsTimes()
	local nCashBase = DDZ_GetCashBase()
	local nNextPlayer = DDZ_NextPlayer(nChairMan)
	local nPreviousPlayer = DDZ_NextPlayer(nNextPlayer)
	local nHomelandCash = 0

	local tPlayerCardsTimes = {}
	local tPlayerOriginCash = {}
	local tPlayerCash = {}
	local tPlayerEndCash = {}
	local math = math
	local tPlayerRemote = {}
	tPlayerRemote.nCurContinueWin = {}
	tPlayerRemote.nHisContinueWin = {}
	tPlayerRemote.nHisMatchCount = {}
	tPlayerRemote.nHisWinCount = {}
	tPlayerRemote.nHisMaxCash = {}

	for i = 1, DDZ_CONST_PLAYER_MAX do
		table.insert(tPlayerCardsTimes, DDZ_GetPlayerCardsTimes(i))
		table.insert(tPlayerOriginCash, DDZ_GetPlayerCashOrigin(i))
		table.insert(tPlayerCash, 0) --PlayerCash 初始化

		tPlayerRemote.nCurContinueWin[i] = DDZ_GetCurContinueWin(i)
		tPlayerRemote.nHisContinueWin[i] = DDZ_GetHisContinueWin(i)
		tPlayerRemote.nHisMatchCount[i] = DDZ_GetHisMatchCount(i)
		tPlayerRemote.nHisWinCount[i] = DDZ_GetHisWinCount(i)
		tPlayerRemote.nHisMaxCash[i] = DDZ_GetHisMaxCash(i)
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8673), i, tPlayerRemote.nHisMatchCount[i], tPlayerRemote.nCurContinueWin[i], tPlayerRemote.nHisContinueWin[i], tPlayerRemote.nHisWinCount[i], tPlayerRemote.nHisMaxCash[i]))
		end
	end

	tPlayerCash[nPreviousPlayer] = nCashBase * nPublicCardsTimes * tPlayerCardsTimes[nPreviousPlayer] * tPlayerCardsTimes[nChairMan]
	tPlayerCash[nNextPlayer] = nCashBase * nPublicCardsTimes * tPlayerCardsTimes[nNextPlayer] * tPlayerCardsTimes[nChairMan]
	tPlayerCash[nChairMan] = tPlayerCash[nPreviousPlayer] + tPlayerCash[nNextPlayer]

	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(17, 6020), nPreviousPlayer, tPlayerCash[nPreviousPlayer]))
		Log(string.format(GetEditorString(17, 6020), nNextPlayer, tPlayerCash[nNextPlayer]))
		Log(string.format(GetEditorString(17, 6020), nChairMan, tPlayerCash[nChairMan]))
	end

	if nWinner == nChairMan then
		--地主胜利
		if tPlayerCash[nNextPlayer] > tPlayerOriginCash[nNextPlayer] then
			tPlayerCash[nNextPlayer] = tPlayerOriginCash[nNextPlayer]	--超过上限则减为0
		end

		if tPlayerCash[nPreviousPlayer] > tPlayerOriginCash[nPreviousPlayer] then
			tPlayerCash[nPreviousPlayer] = tPlayerOriginCash[nPreviousPlayer] --超过上限则减为0
		end

		tPlayerCash[nChairMan] = tPlayerCash[nPreviousPlayer] + tPlayerCash[nNextPlayer] --更新地主流水
		tPlayerCash[nChairMan] = math.floor(tPlayerCash[nChairMan] * DDZ_CONST_TAX_RATE) --胜者扣税

		--结算后叶子令为：
		tPlayerEndCash[nChairMan] = tPlayerOriginCash[nChairMan] + tPlayerCash[nChairMan]
		tPlayerEndCash[nNextPlayer] = tPlayerOriginCash[nNextPlayer] - tPlayerCash[nNextPlayer]
		tPlayerEndCash[nPreviousPlayer] = tPlayerOriginCash[nPreviousPlayer] - tPlayerCash[nPreviousPlayer]

		--地主最大番数
		if tPlayerRemote.nHisMaxCash[nChairMan] < nPublicCardsTimes * tPlayerCardsTimes[nChairMan] * (tPlayerCardsTimes[nPreviousPlayer] + tPlayerCardsTimes[nNextPlayer]) then
			tPlayerRemote.nHisMaxCash[nChairMan] = nPublicCardsTimes * tPlayerCardsTimes[nChairMan] * (tPlayerCardsTimes[nPreviousPlayer] + tPlayerCardsTimes[nNextPlayer])
		end
	else
		--农民胜利
		if tPlayerCash[nChairMan] > tPlayerOriginCash[nChairMan] then
			tPlayerCash[nChairMan] = tPlayerOriginCash[nChairMan]  --超过上限则减为0

			--按比例分配两者的所得
			tPlayerCash[nNextPlayer] = math.floor(tPlayerCash[nChairMan] * tPlayerCardsTimes[nNextPlayer] / (tPlayerCardsTimes[nNextPlayer] + tPlayerCardsTimes[nPreviousPlayer]))
			tPlayerCash[nPreviousPlayer] = tPlayerCash[nChairMan] - tPlayerCash[nNextPlayer]
		end
		--胜者扣税
		tPlayerCash[nNextPlayer] = math.floor(tPlayerCash[nNextPlayer] * DDZ_CONST_TAX_RATE)
		tPlayerCash[nPreviousPlayer] = math.floor(tPlayerCash[nPreviousPlayer] * DDZ_CONST_TAX_RATE)

		--结算后叶子令为：
		tPlayerEndCash[nChairMan] = tPlayerOriginCash[nChairMan] - tPlayerCash[nChairMan]
		tPlayerEndCash[nNextPlayer] = tPlayerOriginCash[nNextPlayer] + tPlayerCash[nNextPlayer]
		tPlayerEndCash[nPreviousPlayer] = tPlayerOriginCash[nPreviousPlayer] + tPlayerCash[nPreviousPlayer]

		if tPlayerRemote.nHisMaxCash[nNextPlayer] < nPublicCardsTimes * tPlayerCardsTimes[nNextPlayer] * tPlayerCardsTimes[nChairMan] then
			tPlayerRemote.nHisMaxCash[nNextPlayer] = nPublicCardsTimes * tPlayerCardsTimes[nNextPlayer] * tPlayerCardsTimes[nChairMan]
		end

		--农民最大番数
		if tPlayerRemote.nHisMaxCash[nPreviousPlayer] < nPublicCardsTimes * tPlayerCardsTimes[nPreviousPlayer] * tPlayerCardsTimes[nChairMan] then
			tPlayerRemote.nHisMaxCash[nPreviousPlayer] = nPublicCardsTimes * tPlayerCardsTimes[nPreviousPlayer] * tPlayerCardsTimes[nChairMan]
		end
	end

	for i = 1, DDZ_CONST_PLAYER_MAX do
		if tPlayerEndCash[i] < 0 then
			tPlayerEndCash[i] = 0
		end
		DDZ_SetPlayerCash(i, tPlayerEndCash[i])
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8525), i, tPlayerOriginCash[i], tPlayerCash[i], tPlayerEndCash[i]))
		end
	end

	--玩家远程数据
	for i = 1, DDZ_CONST_PLAYER_MAX do
		local bPlayerWin = DDZ_GetPlayerWinnerBool(i)
		--增加场次数据
		tPlayerRemote.nHisMatchCount[i] = tPlayerRemote.nHisMatchCount[i] + 1

		--增加场次成就
		DDZ_Achievement(i, 9421, 1)

		--增加场次任务
		DDZ_WeekQuest(i)

		--增加活动奖励
		DDZ_SummerAct(i)

		--胜利判定
		if bPlayerWin == 1 then
			--增加连胜数据
			tPlayerRemote.nCurContinueWin[i] = tPlayerRemote.nCurContinueWin[i] + 1
			tPlayerRemote.nHisWinCount[i] = tPlayerRemote.nHisWinCount[i] + 1
			if tPlayerRemote.nHisContinueWin[i] < tPlayerRemote.nCurContinueWin[i] then
				tPlayerRemote.nHisContinueWin[i] = tPlayerRemote.nCurContinueWin[i]
			end

			--增加胜利成就
			DDZ_Achievement(i, 9416, 1)

			--无癞子胜利成就
			if DDZ_GetAchievementLaiNum(i) == 0 and DDZ_GetLaiZiNum() > 0 then
				DDZ_Achievement(i, 9434, 0)
			end
		else
			--连胜清空
			tPlayerRemote.nCurContinueWin[i] = 0
		end

		DDZ_SetCurContinueWin(i, tPlayerRemote.nCurContinueWin[i])    --当前的连胜记录
		DDZ_SetHisContinueWin(i, tPlayerRemote.nHisContinueWin[i])     --历史的连胜记录
		DDZ_SetHisMatchCount(i, tPlayerRemote.nHisMatchCount[i])      --历史总场次
		DDZ_SetHisWinCount(i, tPlayerRemote.nHisWinCount[i])             --历史总胜场
		DDZ_SetHisMaxCash(i, tPlayerRemote.nHisMaxCash[i])               --历史最大番数

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8674), i, tPlayerRemote.nHisMatchCount[i], tPlayerRemote.nCurContinueWin[i], tPlayerRemote.nHisContinueWin[i], tPlayerRemote.nHisWinCount[i], tPlayerRemote.nHisMaxCash[i]))
		end
	end

	--对局结束，桌子主人特殊成就逻辑
	local OnGameIndex = DDZ_GetPlayerDWID(1)
	local OnGamePlayer = GetPlayer(OnGameIndex)

	if OnGamePlayer then
		local buff = OnGamePlayer.GetBuff(19186, 0)
		local scene = OnGamePlayer.GetScene()

		if buff then
			local nLandIndex = buff.dwSkillSrcID
			if nLandIndex ~= 0 and nLandIndex ~= nil then
				local dwOwnerID = GetHomelandMgr().GetLandOwner(scene.dwMapID, scene.nCopyIndex, nLandIndex)
				local player = GetPlayer(dwOwnerID)
				local nBusnessType = 1 --棋牌室type

				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(20, 8710), dwOwnerID, 9435, 1))
				end
				if player then
					player.AddAchievementCount(9435, 1)

					--主人在线，判断是否开了棋牌室发税收奖励
					--if DDZ_WRITE_LOG then
					--local btemp = CheckHomeLandBusnessType(scene.dwMapID, scene.nCopyIndex, nLandIndex, nBusnessType)
					--Log(string.format("************ 玩家棋牌室判定：%s ************", tostring(btemp)))
					--end
					if IfLandBusnessTypeOpen(scene.dwMapID, scene.nCopyIndex, nLandIndex, GDENUM_HOMELAND_MARKET_TYPE.CARD) then
						nHomelandCash = math.floor(tPlayerCash[nChairMan] * DDZ_CONST_HOMELAND_RATE) --主人获利
						local nCurWeekNum = DDZ_GetWeeklyIncome(player)	--获取本周的上限
						local nIncome = 0
						if (nHomelandCash + nCurWeekNum) <= nMaxWeeklyIncome then
							nIncome = nHomelandCash
						else
							nIncome = nMaxWeeklyIncome - nCurWeekNum
						end
						if nIncome > 0 then
							DDZ_SetWeeklyIncome(player, nIncome + nCurWeekNum)	--记录新的上限
							player.SendSystemMessage(string.format(GetEditorString(20, 9353), nIncome))					
							DDZ_WriteItem(player, dwOwnerID, DDZ_CONST_YEZILING_LITTLE_ID, nIncome, GetEditorString(16, 8297), GetEditorString(17, 932), GetEditorString(17, 1352))
						end
					end
				end
			end
		end
	end

	DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SYN_CASH, 0, 0, 0, 0, 0)
end

function DDZ_TalbeComplement(table1, table2, table3, nPlayerIndex)
	--求table1 - table2 的值，注意顺序，大集合为table1,即当前手牌为table1，当前出牌为table2，记牌器的值为table3
	local tEqual = {}   --记录table1中是否含有table2的变量，最终需#table2 == #tEqual
	if type(table1) ~= "table" or type(table2) ~= "table" or type(table3) ~= "table" then
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 7648), type(table1), type(table2), type(table3)))
		end
		DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

		return false
	end

	for k2, v2 in pairs(table2) do
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4940), v2))
		end
		for k1, v1 in pairs(table1) do
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4941), v1))
			end
			if v1 == v2 then
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4942), k2, k1, v2))
				end

				table.insert(tEqual, k1) --将相同的index记下
				break
			end
		end
	end

	if #tEqual == #table2 then
		for k, v in pairs(tEqual) do
			local nCardValue = GetCardValueFromLaiziCard(table1[v])
			table1[v] = 0 --将table1(手牌)中的数据清零
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(18, 7650), v, nCardValue, table3[nCardValue] ))
			end

			if table3[nCardValue] > 0 then
				table3[nCardValue] = table3[nCardValue] - 1 --记牌器对应的牌值-1
			end
		end
		return true
	else
		--报错
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4770), #tEqual, #table2))
		end
		DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
		--即使是flase，table1的值也修改了，主要不要修改玩家手牌的数据
		return false
	end
end

function DDZ_SendMsg2Client(nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)
	if nValue5 == nil then --旧版本兼容
		nValue5 = 0
	end
	if nValue6 == nil then --旧版本无限兼容
		nValue6 = 0
	end
	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(17, 5202), nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6))
	end
	if not (nPlayerIndex == -1) then
		nPlayerIndex = nPlayerIndex - 1
	end
	miniGameMgr1.Operate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)

	--玩家语音部分逻辑处理
	if nValue1 == DDZ_PLAYER_OPERATE_SET_CHAIRMAN and nValue4 == 2 then
		--第二次抢地主
		nValue3 = 7
	end
	DDZ_PlayPlayerSound(nValue1, nValue2, nValue3)
end

function DDZ_PlayPlayerSound(nTableState, nPlayerIndex, nValue3)
	local nSoundID = 0
	--有些消息nValue3== 0，设定修正为1
	if nValue3 == 0 then
		nValue3 = 1
	end

	if nTableState == DDZ_PLAYER_OPERATE_CUR_CARD  then
		nSoundID = nValue3
	else
		nSoundID = DDZ_GetTableSoundID(nTableState, nValue3)
	end

	if nPlayerIndex and (nPlayerIndex == 1 or nPlayerIndex == 2 or nPlayerIndex == 3) then
		local playerdwID = DDZ_GetPlayerDWID(nPlayerIndex)
		local player = GetPlayer(playerdwID)
		if player == nil then
			return
		end

		if nSoundID ~= 0 then
			local RoleType = player.nRoleType
			if RoleType == 1 then
				nSoundID = nSoundID
			elseif RoleType == 2 then
				nSoundID = nSoundID + 1 * DDZ_CONST_SOUND_LEN
			elseif RoleType == 5 then
				nSoundID = nSoundID + 2 * DDZ_CONST_SOUND_LEN
			elseif RoleType == 6 then
				nSoundID = nSoundID + 3 * DDZ_CONST_SOUND_LEN
			end
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(20, 8258), nSoundID, RoleType))
			end
		else
			return
		end

		player.PlayCharacterSound(nSoundID)
	end
end

function DDZ_GetTableSoundID(nTableState, nValue3)
	local nSoundID = 0
	--有些消息nValue3== 0，设定修正为1
	if nValue3 == 0 then
		nValue3 = 1
	end

	--获取SONUDID
	if DDZ_SOUND_TABLE[nTableState] then
		if DDZ_SOUND_TABLE[nTableState][nValue3] then
			local tSoundList = {}
			if type(DDZ_SOUND_TABLE[nTableState][nValue3]) == "table" then
				local nLen = #DDZ_SOUND_TABLE[nTableState][nValue3]
				local nRandom = math.random(nLen)

				nSoundID = DDZ_SOUND_TABLE[nTableState][nValue3][nRandom]

				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(20, 8204), nLen, nRandom))
					Log(string.format(GetEditorString(20, 8196), nTableState, nValue3, nSoundID))
				end
			end
		end
	end
	return nSoundID
end

function DDZ_GameCreateValueAnalysis(nValue)
	--nValue 解析为：底分、是否癞子、是否洗牌、明牌player*3
	local math = math
	local nPlayerMingPai = {0, 0, 0}
	local nCashBase = 1
	local nTableType = 1
	local nShuffleType = 1
	--异常数据检测
	if nValue > 100000 and nValue < 400000 then
		nCashBase = math.floor(nValue / 100000 )
		nTableType = math.floor(nValue / 10000 ) - nCashBase * 10
		nShuffleType = math.floor(nValue / 1000 ) - nCashBase * 100 - nTableType * 10
		nPlayerMingPai[1] = math.floor(nValue / 100 ) - nCashBase * 1000 - nTableType * 100 - nShuffleType * 10
		nPlayerMingPai[2] = math.floor(nValue / 10 ) - nCashBase * 10000 - nTableType * 1000 - nShuffleType * 100 - nPlayerMingPai[1] * 10
		nPlayerMingPai[3] = math.floor(nValue % 10 )
	else
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)  --公共数据和计时器数据不一致
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 6280), nValue))
		end
	end

	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(19, 6886), nCashBase, nTableType, nShuffleType, nPlayerMingPai[1], nPlayerMingPai[2], nPlayerMingPai[3]))
	end
	DDZ_SetCashBase(DDZ_CONST_BOTTOM_SCORE[nCashBase])	--设置底分，参数从GetHomelandMgr().StartMiniGame传入
	DDZ_SetTableSettingType(nTableType) --设置牌桌规则类型，1：狂野无癞子，2狂野单癞子，3狂野双癞子，4经典模式（无3带2，4带2对）
	DDZ_SetShuffleType(nShuffleType) --设置洗牌模式

	if nTableType == 1 or nTableType == 2 then
		DDZ_SetLaiZiNum(0) 	--设置癞子牌数量（客户端上传为1、2、3）
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(19, 6907), DDZ_GetLaiZiNum()))
		end
	end

	if nTableType == 3 then
		DDZ_SetLaiZiNum(1) 	--设置癞子牌数量（客户端上传为1、2、3）
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(19, 6907), DDZ_GetLaiZiNum()))
		end
	end

	if nTableType == 4  then
		DDZ_SetLaiZiNum(2) 	--设置癞子牌数量（客户端上传为1、2、3）
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(19, 6907), DDZ_GetLaiZiNum()))
		end
	end

	for k, v in pairs(nPlayerMingPai) do
		--判断是否明牌
		if v > 0  then
			DDZ_SetPlayerMingPaiState(k, DDZ_CONST_TABLE_STATE_INIT) --设置当前玩家明牌状态
		end
	end
end

function DDZ_OverSetChairMan(nPlayerIndex)
	--抢地主状态结束，进行最终地主状态判断
	local nChairMan = DDZ_GetChairMan()  --获取公共数据地主状态
	local laizi = DDZ_GetPrivateLaiZi()
	local nPlayerSetChairMan = nPlayerIndex --是有抢地主资格的nPlayerIndex
	local tPlayerType = {[1] = 9, [2] = 9, [3] = 9}

	for i = 1, 3 do
		local temp = DDZ_NextPlayer(nPlayerIndex + i - 1)
		tPlayerType[temp] = DDZ_GetPlayerChairManType(temp)
	end

	for i = 1, 3 do
		--没叫过地主的玩家可以叫地主
		local temp = DDZ_NextPlayer(nPlayerIndex + i - 1)
		if tPlayerType[temp] == 0  then
			nPlayerSetChairMan = temp
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(18, 9171), nPlayerSetChairMan))
			end
			break
		end
		--第一个叫地主的人，需判断剩下两个人是否有人抢地主
		if tPlayerType[i] == 3 then
			for m = 1, 3 do
				if DDZ_WRITE_LOG then
					Log(string.format("************PlayerType[m] : %d  m: %d  ************", tPlayerType[m], m))
				end
				if tPlayerType[m] == 4 then
					nPlayerSetChairMan = i
					if DDZ_WRITE_LOG then
						Log(string.format(GetEditorString(19, 6845), nPlayerSetChairMan))
					end
					break
				end
			end
		end
	end

	--第一个叫地主的、没有叫过地主的还可以抢一次
	if nPlayerSetChairMan ~= nPlayerIndex then
		DDZ_SetPlayerChairManType(nPlayerSetChairMan, 2)

		DDZ_SendAndSetTableMgrState(DDZ_PLAYER_OPERATE_SET_CHAIRMAN, DDZ_CONST_TABLE_STATE_SET_CHAIRMAN)
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nPlayerSetChairMan, 2, 0, 0, 0)
		DDZ_SetTimer(DDZ_CONST_TABLE_STATE_SET_CHAIRMAN, nPlayerSetChairMan)
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4272), nChairMan, nPlayerSetChairMan))
		end
		return
	end

	--设定地主及其他玩家初始状态
	DDZ_OverChairMan(nChairMan)

	DDZ_SendAndSetTableMgrState(DDZ_PLAYER_OPERATE_SET_CHAIRMAN, DDZ_CONST_TABLE_STATE_SHOW_CHAIRMAN)
	DDZ_SetTimer(DDZ_CONST_TABLE_STATE_SHOW_CHAIRMAN, - 1)
end

function DDZ_SendMinCards(nPlayerIndex)
	local tHandCards = DDZ_GetPlayerHand(nPlayerIndex)
	local tOperateCards = 0

	--找到手牌中最小的单牌打出
	for k, v in pairs(tHandCards) do
		if v ~= 0  then
			if tOperateCards == 0 then
				tOperateCards = v
				if DDZ_WRITE_LOG then
					Log(string.format("************ tOperateCards == 0,  tOperateCards : %x ************", tOperateCards))
				end
			else
				if GetCardValueFromLaiziCard(v) <= GetCardValueFromLaiziCard(tOperateCards) then
					tOperateCards = v
					if DDZ_WRITE_LOG then
						Log(string.format("************ v <= tOperateCards,  tOperateCards : %x ************", tOperateCards))
					end
				end
			end
		end
	end

	if tOperateCards ~= 0  then
		--打出牌值最小的牌
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 9398), nPlayerIndex, tOperateCards))
		end
		OnServerOperate(nPlayerIndex - 1, DDZ_PLAYER_OPERATE_CS_SEND, tOperateCards, 0, 0, 0, 0)
	end
end

function DDZ_AutoSendCards(nPlayerIndex)
	--获取牌桌上的牌，获取玩家手牌，调用提示方法，转化牌值调用OnServerOperate
	local tHandCards = DDZ_GetPlayerHand(nPlayerIndex)		--手牌数组
	local tCurType = DDZ_GetCurOperateCardType()			--上一轮出牌的类型
	local tOperateCards = DDZ_GetCurOperateCard()			--上一轮出牌的数组
	local _, nOperateCardsNum = DDZ_ServerCards2UI(tOperateCards)
	local laizi = DDZ_GetPrivateLaiZi()
	if DDZ_WRITE_LOG then
		Log(string.format("************ nOperateCardsNum :%d ************", nOperateCardsNum))
	end
	local tTipsType, tTipsCards = DDZ_OperateLaiziCard(tCurType, nOperateCardsNum, tHandCards, laizi[1], laizi[2], 1)
	if tTipsCards and #tTipsCards[1] ~= 0 then
		--提示牌值合法，出提示牌值的牌
		local tServerOperate = DDZ_UICards2Server(tTipsCards[1])
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(19, 6847), tServerOperate[1], tServerOperate[2], tServerOperate[3], tServerOperate[4], tServerOperate[5]))
		end
		OnServerOperate(nPlayerIndex - 1, DDZ_PLAYER_OPERATE_CS_SEND, tServerOperate[1], tServerOperate[2], tServerOperate[3], tServerOperate[4], tServerOperate[5])
	else
		OnServerOperate(nPlayerIndex - 1, DDZ_PLAYER_OPERATE_JUMP, 0, 0, 0, 0, 0)
	end
end

--游戏结束给玩家重新发叶子令
function DDZ_WriteItem(player, dwID, itemID, cash, str1, str2, str3)
	if cash < 1 then
		return
	end
	local maxDurability = GetItemInfo(ITEM_TABLE_TYPE.OTHER, itemID).nMaxDurability
	local nYeZiLingID_20000 = 40373	--叶子令·盛ID，每个抵20000叶子令
	local nScale = 20000	--兑换比例
	
	if player then	--玩家在线，溢出的结算进包		
		local nCurNum = player.GetItemAmountInAllPackages(ITEM_TABLE_TYPE.OTHER, itemID)
		local nPreTotal = nCurNum + cash	--本次结算后，包里的预计数量
		local tSendList = {}
		local nSendNum = 0		
		if nPreTotal <= maxDurability then
			if player.CanAddItem(ITEM_TABLE_TYPE.OTHER, itemID, cash) == ADD_ITEM_RESULT_CODE.SUCCESS then			
				player.AddItem(ITEM_TABLE_TYPE.OTHER, itemID, cash)	--能进包的直接进包
			else
				table.insert(tSendList, {ITEM_TABLE_TYPE.OTHER, itemID, cash, 0})
				nSendNum = nSendNum + cash				
			end
		else
			local nConvert = 0
			for i = 1, 100 do	--随便循环100次				
				nPreTotal = nPreTotal - nScale	--转一个
				nConvert = nConvert + 1
				if nPreTotal <= maxDurability then	--降到背包可以装下了,那么开始发放
					local nOffset = nPreTotal - nCurNum		--差值,可能扣除或者补充
					--零头与包裹里的合并，多扣少补
					if nOffset > 0 then
						if player.CanAddItem(ITEM_TABLE_TYPE.OTHER, itemID, nOffset) == ADD_ITEM_RESULT_CODE.SUCCESS then
							player.AddItem(ITEM_TABLE_TYPE.OTHER, itemID, nOffset)
						else
							table.insert(tSendList, {ITEM_TABLE_TYPE.OTHER, itemID, nOffset, 0})
							nSendNum = nSendNum + nOffset
						end
					elseif nOffset < 0 then
						player.CostItemInAllPackage(ITEM_TABLE_TYPE.OTHER, itemID, - nOffset)						
					end
					--大叶子令
					if nConvert > 0 then
						if player.CanAddItem(ITEM_TABLE_TYPE.OTHER, nYeZiLingID_20000, nConvert) == ADD_ITEM_RESULT_CODE.SUCCESS then
							player.AddItem(ITEM_TABLE_TYPE.OTHER, nYeZiLingID_20000, nConvert)		--折合的数量							
							player.SendSystemMessage(string.format(GetEditorString(20, 9259), nConvert * nScale, nConvert))
						else
							table.insert(tSendList, {ITEM_TABLE_TYPE.OTHER, nYeZiLingID_20000, nConvert, 0})
							nSendNum = nSendNum + nConvert * nScale
						end
					end
					break
				end
			end
		end
		if #tSendList > 0 then			
			player.SendSystemMessage(string.format(GetEditorString(20, 9328), nSendNum))			
			SendSystemMail(str1, dwID, str2, str3, 0, tSendList)
		end		
	else	--玩家不在线，全额邮件发
		local nPreTotal = cash	--本次结算后，预计发放数量	
		local nConvert = 0
		for i = 1, 100 do	--随便循环100次			
			if nPreTotal > maxDurability then	--降到背包可以装下了,那么开始发放
				nPreTotal = nPreTotal - nScale	--转一个
				nConvert = nConvert + 1
			else
				break
			end
		end
		local tSendList = {}
		if nConvert > 0 then
			table.insert(tSendList, {ITEM_TABLE_TYPE.OTHER, nYeZiLingID_20000, nConvert, 0})
		end
		if nPreTotal > 0 then	--小于50000的零头
			table.insert(tSendList, {ITEM_TABLE_TYPE.OTHER, itemID, nPreTotal, 0})
		end
		if #tSendList > 0 then
			SendSystemMail(str1, dwID, str2, str3, 0, tSendList)
		end
	end

	--Log(tostring("WriteItem itemID: " .. itemID .. " cash: " .. cash .. " maxDurability: " .. maxDurability .. " str: " .. str1 .. " | " .. str2 .. " | " .. str3))
	--[[
	while cash > 0 do
		if cash > maxDurability then
			realCash = maxDurability
		else
			realCash = cash
		end
		cash = cash - realCash
		if player then
			canAddResult = player.CanAddItem(ITEM_TABLE_TYPE.OTHER, itemID, realCash)
			--		Log(string.format("writeItem: canAddResult: %d, itemID: %d, realCash: %d", canAddResult, itemID, realCash))
			if canAddResult == ADD_ITEM_RESULT_CODE.SUCCESS then
				player.AddItem(ITEM_TABLE_TYPE.OTHER, itemID, realCash, "DouDiZhu")
				Log(string.format("DouDiZhu AddItem: playerDwID: %d, itemID: %d, count: %d", dwID, itemID, realCash))
			else
				table.insert(mailCash, realCash)
			end
		else
			table.insert(mailCash, realCash)
		end
	end

	local mailMaxCount = 8
	local tSendList = {}
	for k, v in pairs(mailCash) do
		table.insert(tSendList, {ITEM_TABLE_TYPE.OTHER, itemID, v, 0})	--可以继续插，最多8个每封信		
		if #tSendList == mailMaxCount then
			--	SendSystemMail("发件人姓名（如麻将馆）", dwID, "邮件标题", "邮件内容", 0, tSendList)	--中间有个0是金币，尽量不填
			if player then
				player.SendSystemMessage("侠士背包已达上限或叶子令已达上限，请侠士移步邮箱内提取！")
				RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", "侠士背包已达上限或叶子令已达上限，请侠士移步邮箱内提取！", 5)
			end
			SendSystemMail(str1, dwID, str2, str3, 0, tSendList)	--中间有个0是金币，尽量不填
			tSendList = {}
		end
	end
	if #tSendList > 0 then
		--	SendSystemMail("发件人姓名（如麻将馆）", dwID, "邮件标题", "邮件内容", 0, tSendList)	--中间有个0是金币，尽量不填
		if player then
			player.SendSystemMessage("侠士背包已达上限或叶子令已达上限，请侠士移步邮箱内提取！")
			RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", "侠士背包已达上限或叶子令已达上限，请侠士移步邮箱内提取！", 5)
		end
		SendSystemMail(str1, dwID, str2, str3, 0, tSendList)	--中间有个0是金币，尽量不填
	end
	--]]
end

function ReadPlayerDouDiZhuDatas(nPlayerIndex)
	local dwID = DDZ_GetPlayerDWID(nPlayerIndex)
	if DDZ_WRITE_LOG then
		Log(string.format("GetPlayerDWID: nPlayerIndex: %d, dwID: %d", nPlayerIndex, dwID))
	end
	local player = GetPlayer(dwID)

	if not player then
		--强关游戏
		return false
	end

	--获取角色远程数据
	if player and player.HaveRemoteData(DDZ_CONST_DATAS_REMOTE_ID) and player.bExtDataLoadFinish then

		local nCurContinueWin = player.GetRemoteArrayUInt(DDZ_CONST_DATAS_REMOTE_ID, REMOTE_DOUDIZHU_DATAS.CUR_CONTINUE_WIN_COUNT[1], REMOTE_DOUDIZHU_DATAS.CUR_CONTINUE_WIN_COUNT[2])
		local nHisContinueWin = player.GetRemoteArrayUInt(DDZ_CONST_DATAS_REMOTE_ID, REMOTE_DOUDIZHU_DATAS.HISTORY_CONTINUE_WIN_COUNT[1], REMOTE_DOUDIZHU_DATAS.HISTORY_CONTINUE_WIN_COUNT[2])
		local nHisMatchCount = player.GetRemoteArrayUInt(DDZ_CONST_DATAS_REMOTE_ID, REMOTE_DOUDIZHU_DATAS.HISTORY_MATCH_COUNT[1], REMOTE_DOUDIZHU_DATAS.HISTORY_MATCH_COUNT[2])
		local nHisWinCount = player.GetRemoteArrayUInt(DDZ_CONST_DATAS_REMOTE_ID, REMOTE_DOUDIZHU_DATAS.HISTORY_WIN_COUNT[1], REMOTE_DOUDIZHU_DATAS.HISTORY_WIN_COUNT[2])
		local nHisMaxCash = player.GetRemoteArrayUInt(DDZ_CONST_DATAS_REMOTE_ID, REMOTE_DOUDIZHU_DATAS.HISTORY_MAX_CASH[1], REMOTE_DOUDIZHU_DATAS.HISTORY_MAX_CASH[2])

		local cash = player.GetItemAmountInPackage(ITEM_TABLE_TYPE.OTHER, DDZ_CONST_YEZILING_LITTLE_ID)
		if cash > 0 then
			local cashResult = player.CostItem(ITEM_TABLE_TYPE.OTHER, DDZ_CONST_YEZILING_LITTLE_ID, cash, "DouDiZhu")
			if cashResult then
				if DDZ_WRITE_LOG then
					Log(string.format("DouDiZhu CostItem: playerDwID: %d, itemID: %d, count: %d", dwID, DDZ_CONST_YEZILING_LITTLE_ID, cash))
				end

			else
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 107), dwID, nPlayerIndex, cash))
				end
				--扣除失败流水变为0，不让玩家上桌
				cash = 0
			end
		end

		DDZ_SetCurContinueWin(nPlayerIndex, nCurContinueWin)    --当前的连胜记录
		DDZ_SetHisContinueWin(nPlayerIndex, nHisContinueWin)     --历史的连胜记录
		DDZ_SetHisMatchCount(nPlayerIndex, nHisMatchCount)      --历史总场次
		DDZ_SetHisWinCount(nPlayerIndex, nHisWinCount)             --历史总胜场
		DDZ_SetHisMaxCash(nPlayerIndex, nHisMaxCash)               --历史最大番数
		DDZ_SetPlayerCashOrigin(nPlayerIndex, cash)		--设置初始分，从背包里面获取
		DDZ_SetPlayerCash(nPlayerIndex, cash)			--设置初始分，从背包里面获取

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8289), nPlayerIndex, DDZ_GetPlayerCash(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8290), nPlayerIndex, DDZ_GetPlayerCashOrigin(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8675), nPlayerIndex, DDZ_GetCurContinueWin(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8676), nPlayerIndex, DDZ_GetHisContinueWin(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8677), nPlayerIndex, DDZ_GetHisMatchCount(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8678), nPlayerIndex, DDZ_GetHisWinCount(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8679), nPlayerIndex, DDZ_GetHisMaxCash(nPlayerIndex)))
		end

		--增加唯一上桌判定的buff
		local buff = player.GetBuff(19818, 0) --每日监控buff
		if not buff then
			player.AddBuff(player.dwID, player.nLevel, 19818, 1, 6)
		end
	end
end

--写入角色远程数据
function WritePlayerDouDiZhuDatas(nPlayerIndex)
	local dwID = DDZ_GetPlayerDWID(nPlayerIndex)
	if WRITE_LOG then
		Log(string.format("GetPlayerDWID: nPlayerIndex: %d, dwID: %d", nPlayerIndex, dwID))
	end
	local player = GetPlayer(dwID)
	local cash = DDZ_GetPlayerCash(nPlayerIndex)

	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(20, 8282), nPlayerIndex, cash))
	end

	DDZ_WriteItem(player, dwID, DDZ_CONST_YEZILING_LITTLE_ID, cash, GetEditorString(16, 8297), GetEditorString(17, 932), GetEditorString(17, 1352))

	if player and player.HaveRemoteData(DDZ_CONST_DATAS_REMOTE_ID) and player.bExtDataLoadFinish then
		local nCurContinueWin = DDZ_GetCurContinueWin(nPlayerIndex)
		local nHisContinueWin = DDZ_GetHisContinueWin(nPlayerIndex)
		local nHisMatchCount = DDZ_GetHisMatchCount(nPlayerIndex)
		local nHisWinCount = DDZ_GetHisWinCount(nPlayerIndex)
		local nHisMaxCash = DDZ_GetHisMaxCash(nPlayerIndex)

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8680), nPlayerIndex, nHisMatchCount, nCurContinueWin, nHisContinueWin, nHisWinCount, nHisMaxCash))
		end

		player.SetRemoteArrayUInt(DDZ_CONST_DATAS_REMOTE_ID, REMOTE_DOUDIZHU_DATAS.CUR_CONTINUE_WIN_COUNT[1], REMOTE_DOUDIZHU_DATAS.CUR_CONTINUE_WIN_COUNT[2], nCurContinueWin)
		player.SetRemoteArrayUInt(DDZ_CONST_DATAS_REMOTE_ID, REMOTE_DOUDIZHU_DATAS.HISTORY_CONTINUE_WIN_COUNT[1], REMOTE_DOUDIZHU_DATAS.HISTORY_CONTINUE_WIN_COUNT[2], nHisContinueWin)
		player.SetRemoteArrayUInt(DDZ_CONST_DATAS_REMOTE_ID, REMOTE_DOUDIZHU_DATAS.HISTORY_MATCH_COUNT[1], REMOTE_DOUDIZHU_DATAS.HISTORY_MATCH_COUNT[2], nHisMatchCount)
		player.SetRemoteArrayUInt(DDZ_CONST_DATAS_REMOTE_ID, REMOTE_DOUDIZHU_DATAS.HISTORY_WIN_COUNT[1], REMOTE_DOUDIZHU_DATAS.HISTORY_WIN_COUNT[2], nHisWinCount)
		player.SetRemoteArrayUInt(DDZ_CONST_DATAS_REMOTE_ID, REMOTE_DOUDIZHU_DATAS.HISTORY_MAX_CASH[1], REMOTE_DOUDIZHU_DATAS.HISTORY_MAX_CASH[2], nHisMaxCash)

		--删除唯一上桌判定的buff
		local buff = player.GetBuff(19818, 0) --每日监控buff
		if buff then
			player.DelBuff(19818, 1)
		end
	end
end

--结算
function DDZ_SettleAccounts()
	if DDZ_GetNeedSettleAccounts() == 0 then
		return
	end
	DDZ_SetNeedSettleAccounts(0)

	for i = 1, DDZ_CONST_PLAYER_MAX do
		WritePlayerDouDiZhuDatas(i)
	end
end

--春天结算
function DDZ_EndingSpring(nChairMan, nWinner)
	local nNextPlayer = DDZ_NextPlayer(nWinner)
	local nPreviousPlayer = DDZ_NextPlayer(nNextPlayer)

	--判断春天
	if nWinner == nChairMan then
		--地主胜利
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 5646)))
		end
		if DDZ_GetPlayerCardsFirst(nNextPlayer) == 0 and DDZ_GetPlayerCardsFirst(nPreviousPlayer) == 0 then
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_ENDINNG_SPRING, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_ENDINNG_SPRING])		--地主春天
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 5647)))
			end
			DDZ_SetSpringPlayerIndex(nWinner)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_ENDINNG_SPRING, nWinner, 0, 0, 0, 0)

			--春天成就，必须3轮内出牌
			if DDZ_GetAchievementSpring(nWinner) <= 3 then
				DDZ_Achievement(nWinner, 9428, 0)
			end
		end

		--抢地主胜利成就，逻辑是地主胜利，且地主为抢
		local nPlayerType = DDZ_GetPlayerChairManType(nWinner)
		if nPlayerType == 4 then
			DDZ_Achievement(nWinner, 9426, 0)
		end
	else
		--农民胜利
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 5648)))
		end
		if DDZ_WRITE_LOG then
			Log(string.format("************ DDZ_GetPlayerCardsFirst : %d , DDZ_GetPlayerCardsNum:%d ************", DDZ_GetPlayerCardsFirst(nChairMan), DDZ_GetPlayerCardsNum(nChairMan)))
		end
		if DDZ_GetPlayerCardsFirst(nChairMan) + DDZ_GetPlayerCardsNum(nChairMan) == 20 then  --地主第一次出牌和当前手牌和为20 
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_ENDINNG_SPRING, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_ENDINNG_SPRING])    --农民春天
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 5649)))
			end
			DDZ_SetSpringPlayerIndex(nWinner)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_ENDINNG_SPRING, nWinner, 0, 0, 0, 0)

			--农民春天相关
			local nNextChairMan = DDZ_NextPlayer(nChairMan)
			local nPreviousChairMan = DDZ_NextPlayer(nNextChairMan)
			if DDZ_GetAchievementSpring(nNextChairMan) <= 3 and DDZ_GetAchievementSpring(nPreviousChairMan) <= 3 then
				DDZ_Achievement(nNextChairMan, 9427, 0)
				DDZ_Achievement(nPreviousChairMan, 9427, 0)
			end
		end
	end
end

function DDZ_Achievement(nPlayerIndex, AchNum, nType)
	local playerdwID = DDZ_GetPlayerDWID(nPlayerIndex)
	local player = GetPlayer(playerdwID)

	if player then
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8710), nPlayerIndex, AchNum, nType))
		end
		if nType >= 1 then
			player.AddAchievementCount(AchNum, nType)
		elseif not player.IsAchievementAcquired(AchNum)  then
			player.AcquireAchievement(AchNum)
		end
	end
end

function DDZ_WeekQuest(nPlayerIndex)
	local playerdwID = DDZ_GetPlayerDWID(nPlayerIndex)
	local player = GetPlayer(playerdwID)
	if player then
		local nQuestIndex = player.GetQuestIndex(21924)
		local nQuestPhase = player.GetQuestPhase(21924)

		if nQuestIndex  and nQuestPhase <= 1 then
			player.SetQuestValue(nQuestIndex, 0, player.GetQuestValue(nQuestIndex, 0) + 1)
		end
	end
end

function DDZ_SummerAct(nPlayerIndex)
	local nTime = GetCurrentTime()
	local nStartTime = DateToTime(2021, 6, 7, 7, 0, 0)
	local nEndTime = DateToTime(2021, 6, 24, 7, 0, 0)

	if nTime > nEndTime or nTime < nStartTime then
		return
	end

	local nTomorrow = CustomFunction.GetSecondToTomorrow7()
	local playerdwID = DDZ_GetPlayerDWID(nPlayerIndex)
	local player = GetPlayer(playerdwID)

	if player then
		local buff_1 = player.GetBuff(19797, 0) --每日监控buff
		local buff_2 = player.GetBuff(19796, 0) --全体活动监控buff
		local bReward = false

		if not buff_1 then
			if not buff_2 then
				bReward = true
			else
				if buff_2.nStackNum < 5 then
					bReward = true
				end
			end
		end

		if bReward then
			local min_19797 = math.floor(nTomorrow / 60)
			local min_19796 = math.floor((nEndTime - nTime) / 60)
			player.AddBuff(player.dwID, player.nLevel, 19797, 1, min_19797)
			player.AddBuff(player.dwID, player.nLevel, 19796, 1, min_19796)

			if player.CanAddItem(5, 40387, 1) == ADD_ITEM_RESULT_CODE.SUCCESS then
				player.AddItem(5, 40387, 1, "DDZ_SummerAct")
			else
				local string0 = string.format(GetEditorString(20, 8837), player.szName)
				SendMailByLogType(GetEditorString(16, 8649), player.szName, GetEditorString(20, 8838), string0, 0, {{5, 40387, 1}}, MAIL_LOG_TYPE.HOME_LAND)
				player.SendSystemMessage(GetEditorString(20, 8839))
				RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_GREEN", GetEditorString(20, 8839), 5)
			end
		else
			return
		end
	end
end

--斗地主经营棋牌室的叶子令分成周上限
function DDZ_GetWeeklyIncome(player)
	local nCurWeekNum = 0
	if player.IsHaveBuff(19894, 1) then		
		nCurWeekNum = player.GetBuff(19894, 1).nCustomValue
	else
		local nCount = CustomFunction.GetMinuToNextWeek7()
		player.AddBuff(0, 99, 19894, 1, nCount)		
	end
	return nCurWeekNum
end
function DDZ_SetWeeklyIncome(player, nNewValue)	
	if not player.IsHaveBuff(19894, 1) then		
		local nCount = CustomFunction.GetMinuToNextWeek7()
		player.AddBuff(0, 99, 19894, 1, nCount)		
	end
	local buff = player.GetBuff(19894, 1)
	
	if nNewValue > nMaxWeeklyIncome then
		buff.nCustomValue = nMaxWeeklyIncome
	else
		buff.nCustomValue = nNewValue
	end	
end