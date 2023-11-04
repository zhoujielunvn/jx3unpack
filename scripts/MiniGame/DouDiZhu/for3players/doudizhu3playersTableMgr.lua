---------------------------------------------------------------------->
-- �ű�����:	scripts/MiniGame/DouDiZhu/for3players/doudizhu3playersTableMgr.lua
-- ����ʱ��:	2021/6/15 14:55:01
-- �����û�:	caoqing-PC
-- �ű�˵��:	
----------------------------------------------------------------------<
Include("scripts/MiniGame/DouDiZhu/for3players/doudizhu3playersPlayerMgr.lua")
Include("scripts/MiniGame/DouDiZhu/for3players/IdentityCustomValueName.lua")
Include("scripts/MiniGame/DouDiZhu/for3players/doudizhu3playersInclude.lua")
Include("scripts/Include/Time.lh")
Include("scripts/Include/LandCondition.lh")

--��������Ӫ�����ҵ�Ҷ����ֳ�������
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

	--�������ô���С��Ϸ
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
		--������ʼ������,�������������
		DDZ_InitTableMgr() --������1s����������ʼ��
		local nLaiziNum = DDZ_GetLaiZiNum()
		local laizi = DDZ_GetPrivateLaiZi()

		--�ж��Ƿ�������������
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
				--���ֽ����׶Σ���ղ�������
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

		--����
		local nShuffleType = DDZ_GetShuffleType()
		DDZ_ShuffleCardsAndSendCards(nShuffleType)
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_LAIZI_TIAN, laizi[1], 0, 0, 0, 0)

		if nLaiziNum == 2 then
			--�㲥�����,�������������������
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
		--�ж�����
		local nPlayerMingpaiState = {0, 0, 0}
		for i = 1, DDZ_CONST_PLAYER_MAX do
			nPlayerMingpaiState[i] = DDZ_GetPlayerMingPaiState(i)
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(18, 6287), i, nPlayerMingpaiState[i]))
			end
			if nPlayerMingpaiState[i] == DDZ_CONST_TABLE_STATE_INIT then
				local tHandCards = DDZ_GetPlayerHand(i)
				DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_MINGPAI_STATE_INIT, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_MINGPAI_STATE_INIT])	--��ʼ���Ʒ�4��
				DDZ_SetPublicPlayerHandCards(i, tHandCards) --���õ�ǰ���������Ϊ�������ݲ�����
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(18, 6276), i, nPlayerMingpaiState[i]))
				end

				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_MINGPAI_END, i, 0, 0, 0, 0)
			end
		end

		--���ƽ׶ν����������������滻
		DDZ_ReplaceLaizi(1)

		--���ƽ׶ν������������Ƚе����ж�,�����һ����ʤ�ߣ�ָ��ʤ��Ϊ��һ���е�������
		local nChairMan = DDZ_ChairManFirst()
		--����һ������·��е���״̬(��ʼ״̬0���е���1��������2�������ɹ���3���������ɹ���4������5������6)
		local nWinner = DDZ_GetPlayerWinner()
		if nWinner ~= 0 then
			nChairMan = nWinner
		end
		DDZ_SetPlayerChairManType(nChairMan, 1)  --������������Ƿ���Խе���

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
			--�����ͬ���������ı䷢���Ʋ��ı���ֵ����PrivateLaiZi ��Ϊ��������
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
		--������滻�׶�
		DDZ_ReplaceLaizi(2)
		DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_SHOW_CHAIRMAN, DDZ_CONST_TABLE_STATE_DOUBLE)
		DDZ_SetTimer(DDZ_CONST_TABLE_STATE_DOUBLE, - 1)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_DOUBLE then
		--�ӱ��׶ν������������ƽ׶�
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
		--����ѡ�������������ƽ׶�
		local nChairMan = DDZ_GetChairMan()  --��ȡ�������ݵ���״̬

		--���ƽ׶ν��������г��ƽ׶Σ��趨������һ������
		DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI, DDZ_CONST_TABLE_STATE_WAIT_CS_SEND)
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4758), nChairMan))
		end

		if DDZ_AUTO_TEST and DEBUG_DOUDIZHU then
			for i = 1, 3 do
				DDZ_SetPlayerIsAgent(i, 1)
			end
		end

		DDZ_SetCurOperatePlayer(nChairMan)	--������ҳ���
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CUR_PLAYER, nChairMan, 0, 0, 0, 0)
		DDZ_SetTimer(DDZ_CONST_TABLE_STATE_WAIT_CS_SEND, nChairMan)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_WAIT_CS_SEND then
		--��ʱ�����˱�ʾ��������������߼�д�ڳ���֮���OnServerOperate��
		if nValue2 > 0 and nValue2 <= DDZ_CONST_PLAYER_MAX then
			local nOverTimeCount = DDZ_GetPlayerOverTimeCount(nValue2)
			nOverTimeCount = nOverTimeCount + 1

			if WRITE_LOG then
				Log(string.format(GetEditorString(17, 92), nValue2, nOverTimeCount))
			end

			--����й�״̬
			if nOverTimeCount >= 2 then
				nOverTimeCount = 0
				if WRITE_LOG then
					--	Log(tostring("������ң�" .. nValue2 .. " �һ�"))
					Log(string.format(GetEditorString(17, 93), nValue2))
				end
				DDZ_SetPlayerIsAgent(nValue2, 1)
				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_AGENT, nValue2, 1, 0, 0, 0)
				DDZ_SetPlayerOverTimeCount(nValue2, nOverTimeCount)

				--��ǰ���������Լ���������û����������
				if DDZ_GetCardOwner() == 0 then
					DDZ_SendMinCards(nValue2)
				else
					DDZ_AutoSendCards(nValue2)
				end

				return
			end

			--��������
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
		--�жϵ�ǰ�������Ƿ�Ϊ�Լ�
		if DDZ_GetCardOwner() == 0 then
			DDZ_SendMinCards(nValue2)
			return
		else
			DDZ_AutoSendCards(nValue2)
			return
		end

		--���������ж����ݴ���
		OnServerOperate(nValue2 - 1, DDZ_PLAYER_OPERATE_JUMP, 0, 0, 0, 0, 0)
		return
	elseif nValue1 == DDZ_CONST_TABLE_STATE_SETTLEMENT then
		--��������
		DDZ_WinnerCash()

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8267)))
		end

		--�Ծֽ�������ʣ�µ����Ƽ��뵽��¼��
		for i = 1, DDZ_CONST_PLAYER_MAX do
			local tCardsPile = DDZ_GetPrivateCardsPile()
			local tHandCards = DDZ_GetPlayerHand(i)
			local nLenCardsPile = 0
			local temp = {}
			local blaizi = false --�������Ҫ�޸ĵ�����

			for k, v in pairs(tCardsPile) do

				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(20, 8427), i, k, v))
				end

				--���������ֵ�˻�Ϊ��ͨ��
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

			--�޸������������
			if blaizi then
				DDZ_SetPrivateCardsPile(tCardsPile, 0)
			end

			for k, v in pairs(tHandCards) do
				if v ~= 0 then
					--���������ֵ�˻�Ϊ��ͨ��
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

		--�������ϴ����
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
			--���ֽ����׶Σ���ղ�������
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

		--����������������õ���������
		for i = 1, DDZ_CONST_PLAYER_MAX do
			local tHandCards = DDZ_GetPlayerHand(i)
			DDZ_SetPublicPlayerHandCards(i, tHandCards) --���õ�ǰ���������Ϊ�������ݲ�����

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

		--��������
		local tCardsChange = {}
		tCardsChange[1] = {}
		tCardsChange[2] = {}

		--nValue2 ������������˫��id �����1ID *10 + ���2 ID������3��2 �������ƣ���nValue2 = 3 *10 + 2 = 32
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

		--������ֵ
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

		--��������������
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

		if nTableMgrState ~= DDZ_CONST_TABLE_STATE_WAIT_CS_SEND then --�ж�����״̬
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		if DDZ_GetCurOperatePlayer() ~= nPlayerIndex then --��������ƣ���������
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		local nNextPlayer = DDZ_NextPlayer(nPlayerIndex)
		local nCardOwner = DDZ_GetCardOwner()

		--��ǰ���˳��ƣ��Զ���һ����С��ֵ����
		if nCardOwner == 0 then
			DDZ_SendMinCards(nPlayerIndex)
			return
		end

		--����������ǣ�ע��Ҫ�� nCardOwner == nNextPlayer ֮ǰ��
		DDZ_SetPlayerOperateJump(nPlayerIndex, 1)
		DDZ_SetPlayerOperateJump(nNextPlayer, 0)

		if nCardOwner == nNextPlayer then
			--��������һ�������֮ǰ�ĳ����ˣ���ʾ�¼ҵ�������趨��ǰ����Ϊ�գ��¼ҿ����������
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(18, 9397), nPlayerIndex, nNextPlayer))
			end

			local	tDumpCardData = {
				0, 0, 0, 0, 0,
				0, 0, 0, 0, 0,
				0, 0, 0, 0, 0,
				0, 0, 0, 0, 0
			}

			DDZ_SetCardOwner(0)	--��ǰ���˳���
			DDZ_SetCurOperateCard(tDumpCardData)
			DDZ_SetCurOperateCardType(0, 0, 0)
			for i = 1, 3 do
				--��������������
				DDZ_SetPlayerOperateJump(i, 0)
			end

			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_TABLE_END_ROUND, nNextPlayer, 0, 0, 0, 0)
		end

		--������һ�����Ƶ����
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
		--�жϵ�ǰ����Ƿ��������
		local nPlayerMingpaiState = DDZ_GetPlayerMingPaiState(nPlayerIndex)

		if nPlayerMingpaiState > 0 then --�Ѿ����ƹ��ˣ���������
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 3880), nPlayerIndex, nPlayerMingpaiState))
			end

			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end
		--���ƿ�ʼ״̬�����жϵ�ǰ��������Ƿ�Ϊ��
		local testdata = IsNilHandCard(nPlayerIndex)
		local tHandCards = DDZ_GetPlayerHand(nPlayerIndex)

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 3900), testdata))
		end

		if nTableMgrState == DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI then
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_MINGPAI_STATE_SHUFFLE, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_MINGPAI_STATE_SHUFFLE])  --����ǰ�׶�����2��
			DDZ_SetPlayerMingPaiState(nPlayerIndex, DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI)
			DDZ_SetPublicMingPaiState(nPlayerIndex, DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI)
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(18, 6276), nPlayerIndex, nPlayerMingpaiState))
			end
			DDZ_SetPublicPlayerHandCards(nPlayerIndex, tHandCards) --���õ�ǰ���������Ϊ�������ݲ�����
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_MINGPAI_END, nPlayerIndex, 0, 0, 0, 0)
			return
		end

	elseif nValue1 == DDZ_PLAYER_OPERATE_CHAIRMAN_TYPE then

		--��ҽе������ж��Ƿ��не������ʸ�
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
			local nNextPlayer = DDZ_NextPlayer(nPlayerIndex)			--�¼�index

			if nPlayerType == 1 and nChairMan == 0 then
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4318), nPlayerIndex))
				end

				DDZ_SetChairMan(nPlayerIndex)
				DDZ_SetPlayerChairManType(nPlayerIndex, 3)
				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nPlayerIndex, 3, 0, 0, 0)

				DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_CHAIRMAN_CALL, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_CHAIRMAN_CALL])  --�е���1��
				DDZ_OverSetChairMan(nPlayerIndex)
				return
			else
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4290), nChairMan))
				end

				DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
				return
			end

			--���������
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

				DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_CHAIRMAN_ROB, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_CHAIRMAN_ROB])  --������1��
				DDZ_OverSetChairMan(nPlayerIndex)
				return
			else
				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4291), nChairMan))
				end
				DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

				return
			end

			--��Ҳ���
		elseif nValue2 == 5 then
			--��֤��������ǰ�����ǲ��Ǳ���Ϣ�ˣ����ǲſ��Բ���
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
				--ͬ����Ҳ��е���
				DDZ_SetPlayerChairManType(nPlayerIndex, 5)		--���õ�ǰ���Ϊ����
				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nPlayerIndex, 5, 0, 0, 0)

				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(17, 4201), nPlayerIndex, nNextPlayer))
				end

				if nNextType == 5 then
					--��һ�����Ϊ����,û���˽е���,���жϵ����Ƿ��б�����Ƶ����
					local tChairManNum = {}
					local nMaxNum = 0
					local nMaxIndex = 0
					local bChairmanCompare = false

					for i = 1, 3 do
						tChairManNum[i] = DDZ_GetPlayeChairmanCompare(i)

						--�ҵ����� nMaxNum
						if tChairManNum[i] > nMaxNum then
							nMaxNum = tChairManNum[i]
							nMaxIndex = i
						end
					end

					--2ը��ChairmanCompare = 51 ������ChairmanCompareʱע��ͬ���޸�
					if nMaxNum > 50 then
						bChairmanCompare = true
					end

					--�������·��ƴ���
					local nReStart = DDZ_GetReStartNum()
					nReStart = nReStart + 1
					DDZ_SetReStartNum(nReStart)

					if DDZ_WRITE_LOG then
						Log(string.format(GetEditorString(17, 4218), nReStart))
					end

					if nReStart >= 3 or bChairmanCompare then
						if bChairmanCompare then
							--��nNextPlayer ���¸�ֵ
							nNextPlayer = nMaxIndex
							if DDZ_WRITE_LOG then
								Log(string.format(GetEditorString(19, 8016), nNextPlayer, nMaxNum))
							end
						else
							if DDZ_WRITE_LOG then
								Log(string.format(GetEditorString(17, 6019), nNextPlayer))
							end
						end

						--ֻ���·�3��,֮���趨��һ����Ϊ����,�����������׶�.��ʱ��һ����ΪnNextPlayer
						DDZ_SetChairMan(nNextPlayer)
						DDZ_SetPlayerChairManType(nNextPlayer, 3)
						DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_CHAIRMAN_CALL, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_CHAIRMAN_CALL])  --�е���1��
						DDZ_OverChairMan(nNextPlayer)
						DDZ_SendAndSetTableMgrState(DDZ_PLAYER_OPERATE_SET_CHAIRMAN, DDZ_CONST_TABLE_STATE_SHOW_CHAIRMAN)
						DDZ_SetTimer(DDZ_CONST_TABLE_STATE_SHOW_CHAIRMAN, - 1)
						return
					else
						--�ط�<3,���·���
						DDZ_SettleAccounts() --Ҷ�����
						DDZ_SetPlayerWinner(0) --��ʼ��ʤ�����
						DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN, DDZ_CONST_TABLE_STATE_INIT)
						DDZ_SetTimer(DDZ_CONST_TABLE_STATE_INIT, - 1)

						return
					end
				end

				DDZ_SetPlayerChairManType(nNextPlayer, 1)  --������һ���������Ϊ�Ƿ���Խе���

				DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN, DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN)
				DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nNextPlayer, 1, 0, 0, 0)
				DDZ_SetTimer(DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN, nNextPlayer)
				return
			end

			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
			return
			--��Ҳ���
		elseif nValue2 == 6 then
			--��֤��������ǰ�����ǲ��Ǳ���Ϣ�ˣ����ǲſ��Բ���
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
		--���ѡ��ӱ�
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
			--��ͨ�ӱ�
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4514), nPlayerIndex))
			end
			DDZ_SetPlayerDoubleType(nPlayerIndex, 1)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_DOUBLE_PLAYER, nPlayerIndex, 1, 0, 0, 0) --�㲥��ͨ�ӱ�
			DDZ_AddCardsTimes(nPlayerIndex, DDZ_CONST_TIMES_DOUBLE_TYPE_NORMAL, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_TYPE_NORMAL])  --��ͨ�ӱ�

			return
		elseif nValue2 == 2 then
			--�����ӱ�
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4515), nPlayerIndex))
			end
			DDZ_SetPlayerDoubleType(nPlayerIndex, 2)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_DOUBLE_PLAYER, nPlayerIndex, 2, 0, 0, 0) --�㲥��ͨ�ӱ�
			DDZ_AddCardsTimes(nPlayerIndex, DDZ_CONST_TIMES_DOUBLE_TYPE_SUPER, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_TYPE_SUPER])  --�����ӱ�

			return
		elseif nValue2 == 3 then
			--���ѡ�񲻼ӱ�
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4516), nPlayerIndex))
			end
			DDZ_SetPlayerDoubleType(nPlayerIndex, 3)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_DOUBLE_PLAYER, nPlayerIndex, 3, 0, 0, 0) --�㲥���ӱ�

			return
		else
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
			return
		end

	elseif nValue1 == DDZ_PLAYER_OPERATE_CS_SEND then
		--�ж�����״̬����������Ʋ��ܳ���
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4863), DDZ_GetCurOperatePlayer(), nPlayerIndex))
		end

		if nTableMgrState ~= DDZ_CONST_TABLE_STATE_WAIT_CS_SEND then --�ж�����״̬
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		if DDZ_GetCurOperatePlayer() ~= nPlayerIndex then  --���������,���ܳ���
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end
		local nNextPlayer = DDZ_NextPlayer(nPlayerIndex)
		local nPreviousPlayer = DDZ_NextPlayer(nNextPlayer)		--�ϼ�index
		local nHandCardsNum = DDZ_GetPlayerCardsNum(nPlayerIndex)
		local tHandCards = DDZ_GetPlayerHand(nPlayerIndex)
		local tOperateCards = DDZ_CardMSG2Talbe(nValue2, nValue3, nValue4, nValue5, nValue6) --����ֵ֮��ᱻ���ǣ��ͻ����������ϳ�����Ϊδ�޸ĵ���ֵ��������tCurOperateCard
		local tCurOperateCard = DDZ_CardMSG2Talbe(nValue2, nValue3, nValue4, nValue5, nValue6)
		local nCardLen = #tOperateCards
		local tCardType = DDZ_GetCardType(tOperateCards)  --����ǰ��ת����������
		local tCurType = DDZ_GetCurOperateCardType()			--��һ�ֳ��Ƶ�����
		local nCardsFirst = DDZ_GetPlayerCardsFirst(nPlayerIndex)
		local nPlayerMingpaiState = DDZ_GetPlayerMingPaiState(nPlayerIndex)
		local tCardsLast = DDZ_GetPublicCardsLast()
		local laizi = DDZ_GetPrivateLaiZi()
		local nTableSettingType = DDZ_GetTableSettingType()
		local nCardsLastNum = 0 --��ǰ��������ʣ������
		local tAllCardsType = DDZ_OperateLaiziType(nTableSettingType, nCardLen)
		local bDebug = DDZ_GetPublicDebug()
		local bNotCardsType = true
		local nChairMan = DDZ_GetChairMan()
		local nAchievementBomb = DDZ_GetAchievementBomb(nPlayerIndex)
		local nAchievementSpring = DDZ_GetAchievementSpring(nPlayerIndex)

		if not tCardType or tCardType[1] == DDZ_CONST_CARD_TYPE_ERROR then --��������쳣���ر���
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4931)))
			end
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		--�ж������Ƿ������һ��
		if not tAllCardsType or #tAllCardsType == 0 then
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(19, 6885)))
			end
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		--�ж������Ƿ���涨����һ��
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

		--��������
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4935), tCardType[1], tCardType[2], tCardType[3]))
		end
		--���ƴ�С�ж������һ���Ʊȵ�ǰ���ƴ�,���ܳ���,���ҳ�����Ҳ�����һ�ֵĳ�����ң��������б��˳����ƣ�
		if DDZ_CompareCardType(tCardType, tCurType) and nPlayerIndex ~= DDZ_GetCardOwner() then
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4936), DDZ_GetCardOwner(), tCurType[1], tCurType[2]))
			end
			DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)

			return
		end

		--���㵱ǰ���һ������������ƣ�������Ҫ��tCardsLast�޸�֮ǰ
		nCardsLastNum = DDZ_CONST_CARDS_NUM - DDZ_TableSum(tCardsLast)
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 6011), nCardsLastNum))
		end

		--�������п۳���ǰ���ƣ����Ƚ��������滻��ԭ��ֵ�۳�
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
				--������ƣ�ͬ���޸�PublicData����
				DDZ_SetPublicPlayerHandCards(nPlayerIndex, tHandCards)
			end

			if bDebug == 1 then
				--��ҽ���debug״̬
				DDZ_SetPublicPlayerHandCards(nPlayerIndex, tHandCards)
			end

		else
			--����ֵ�Ƿ�
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4875)))
			end
			return
		end

		--������ֵ����
		local nSoundID = 0
		local tSound = {}
		if DDZ_SOUND_CARD[tCardType[1]] and type(DDZ_SOUND_CARD[tCardType[1]]) == "table" then
			if tCardType[1] == DDZ_CONST_CARD_TYPE_SINGLE or tCardType[1] == DDZ_CONST_CARD_TYPE_DOUBLE then
				local temp = DDZ_SOUND_CARD[tCardType[1]][tCardType[2]]
				if temp then
					table.insert(tSound, temp)
				end
			elseif tCardType[1] == DDZ_CONST_CARD_TYPE_TRIPLE_SINGLE or tCardType[1] == DDZ_CONST_CARD_TYPE_TRIPLE_DOUBLE then
				--����1������2 ��Ҫ���������Ƿɻ����߼�
				if tCardType[3] == 1 then
					local temp = DDZ_SOUND_CARD[tCardType[1]][1]
					if temp then
						table.insert(tSound, temp)
					end
				else
					for i = 1, 2 do
						--DDZ_SOUND_CARD �������index=2��3 ��ʾ���ַɻ�������
						local temp = DDZ_SOUND_CARD[tCardType[1]][i + 1]
						if temp then
							table.insert(tSound, temp)
						end
						--�ɻ��������ֵ�ж�д������
						if tCardType[2] == 0x0c then
							temp = DDZ_SOUND_SEND[2][1]
							if temp then
								table.insert(tSound, temp)
							end
						end
					end
				end
			else
				--�����������������
				for k, v  in pairs(DDZ_SOUND_CARD[tCardType[1]]) do
					if v then
						table.insert(tSound, v)
					end
				end
			end

			--ͨ�ó�����������
			if #tSound ~= 0 then
				local ntempRandom = math.random(DDZ_SOUND_RANDOM[1])
				if ntempRandom < DDZ_SOUND_RANDOM[2] and tCurType[2] ~= 0 and tCardType[1] ~= DDZ_CONST_CARD_TYPE_ROCKET then
					table.insert(tSound, DDZ_SOUND_SEND[1][1])
				end
			end

			--������ֵ���룬ע���������ֵΪ0x0c���������ֵΪ0x0d
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

			--�պ�ѹ�������
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

		--��ʣ������
		if nHandCardsNum == 2 then
			nSoundID = DDZ_SOUND_SEND[4][1]
		end

		--���Ƴɹ��㲥��ǰ����,�趨���������ݣ���ǰ�����ˡ�����ֵ����ǰ��������
		DDZ_SetCardOwner(nPlayerIndex)    --��ǰ������
		DDZ_SetCurOperateCard(tCurOperateCard)   --����ֵ��ע�ⲻ����tOperateCards����ʱtOperateCards�ѱ��滻
		DDZ_SetCurOperateCardType(tCardType[1], tCardType[2], tCardType[3]) --��������
		DDZ_SetPrivateCardsPile(tOperateCards, nCardsLastNum)
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_CUR_CARD, nPlayerIndex, nSoundID, 0, 0, 0)

		--�����¼ҵ��������
		DDZ_SetPlayerOperateJump(nNextPlayer, 0)

		--ը������
		if tCardType[1] == DDZ_CONST_CARD_TYPE_ROCKET then --��ը
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_DOUBLE_BOMB_ROCKET, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_BOMB_ROCKET])
			nAchievementBomb = nAchievementBomb + 1
		end

		if tCardType[1] == DDZ_CONST_CARD_TYPE_BOMB4_BIG then --Ӳը
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_DOUBLE_BOMB_BIG, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_BOMB_BIG])
			nAchievementBomb = nAchievementBomb + 1
		end

		if tCardType[1] == DDZ_CONST_CARD_TYPE_BOMB4 then --��ը
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_DOUBLE_BOMB_LAIZI, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_BOMB_LAIZI])
			nAchievementBomb = nAchievementBomb + 1
		end

		if tCardType[1] > DDZ_CONST_CARD_TYPE_BOMB4_BIG and tCardType[1] < DDZ_CONST_CARD_TYPE_ROCKET then		--����ը��
			for i = 1, (tCardType[1] - DDZ_CONST_CARD_TYPE_BOMB4_BIG) do
				--��DDZ_CONST_CARD_TYPE ö���㣬ÿ��һ��ӱ�һ��
				DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_DOUBLE_BOMB_LAIZI, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_DOUBLE_BOMB_LAIZI])
			end
			nAchievementBomb = nAchievementBomb + 1
		end

		--�ɾ����
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

		--��¼��һ�γ��Ƶ�����
		if nCardsFirst == 0 then
			nCardsFirst = nCardLen
			DDZ_SetPlayerCardsFirst(nPlayerIndex, nCardsFirst)
		end

		--��ת���������
		if nHandCardsNum == 0 then
			--��Ұ��ƴ��꣬�������
			DDZ_SendAndSetTableMgrState(DDZ_CONST_TABLE_STATE_WAIT_CS_SEND, DDZ_CONST_TABLE_STATE_SETTLEMENT)
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 4762), nPlayerIndex))
			end

			--����ʱ���������������Ϊ����
			for i = 1, DDZ_CONST_PLAYER_MAX do
				local tHandCards = DDZ_GetPlayerHand(i)
				DDZ_SetPublicPlayerHandCards(i, tHandCards)

				if WRITE_LOG then
					Log(string.format(GetEditorString(19, 8106), i))
				end
			end

			--�㲥ʤ�����
			DDZ_SetPlayerWinner(nPlayerIndex)
			DDZ_SetPlayerWinnerBool(nPlayerIndex, 1)

			--ũ��ʤ��ʱ����Ҫ�趨����һ����Ҳʤ��
			if nNextPlayer == nChairMan then
				DDZ_SetPlayerWinnerBool(nPreviousPlayer, 1)
			else
				if nPreviousPlayer == nChairMan then
					DDZ_SetPlayerWinnerBool(nNextPlayer, 1)
				end
			end

			--���㴺��
			DDZ_EndingSpring(nChairMan, nPlayerIndex)

			--UIҪ��ʤ��Ҳ��Ҫ����һ���¸����
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
	--��ȡ��¼����
	local cashBase = DDZ_GetCashBase()
	local nReStart = DDZ_GetReStartNum() --����ϴ����
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
	--�������
	ResetMem()

	--��ʼ����¼����
	DDZ_SetCashBase(cashBase)  --��ʼ���׷�
	DDZ_SetReStartNum(nReStart)   --��ʼ�����·�����
	DDZ_SetLaiZiNum(nLaiziNum)    --�������
	DDZ_SetShuffleType(nShuffleType)    --�Ƿ�ϴ��ģʽ
	DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_INITIAL_CARDS, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_INITIAL_CARDS]) --��ʼ���趨
	DDZ_SetTableSettingType(nTableSettingType)
	DDZ_SetPlayerWinner(nWinner)

	for i = 1, DDZ_CONST_PLAYER_MAX do
		DDZ_AddCardsTimes( i, DDZ_CONST_TIMES_INITIAL_CARDS, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_INITIAL_CARDS]) --��ʼ���趨
		ReadPlayerDouDiZhuDatas(i)
		DDZ_SetPlayerMingPaiState(i, nPlayerMingpaiState[i])   --��������״̬
		DDZ_SetPublicMingPaiState(i, nPlayerMingpaiState[i])

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 6289), i, nPlayerMingpaiState[i]))
		end

		--���ó�ʼ
		DDZ_SetPublicCardsNum(i, 17)
		DDZ_SetPlayerCardsNum(i, 17)
	end

	if nShuffleType ~= 1 then  --��ϴ��ģʽ
		DDZ_SetPrivateCardsPile(tCardsPile, 0)
	end

	--���Ʒ���
	DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS]) --���Ʒ��趨

	--���������,���������
	DDZ_RandomAndSetLaiZi(nLaiziNum)

	--��ʼ��������
	DDZ_SetPublicCardsLast(DDZ_CONST_TABLE_CARDS_LAST)

	--���ó�ʼͨѶ����
	DDZ_SetPlayerOperateCount( - 1, 1)

	--���ý������
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

	if nShuffleType == 1 then  --ϴ��ģʽ
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
			--��¼��ֵ���
			local tNilCards = {}
			for i = 1, 54 do
				tNilCards[i] = 0
			end
			DDZ_SetPrivateCardsPile(tNilCards, 0)
		else
			allCards = DDZ_NormalShuffle()
		end
	end

	--��������
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
	--�������е��������ֵ�滻
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

		--��������ݴ�
		local temp = 0
		for k, v in pairs(tReplace) do
			if v > 0x40 then
				temp = temp + 1
			end
		end
		--��ӳɾ�
		if nAchLaiziNum >= 4 or temp >= 4 then
			DDZ_Achievement(i, 9432, 0)
		end

		if nAchLaiziNum >= 8 or temp >= 8 then
			DDZ_Achievement(i, 9433, 0)
		end

		--���ͻ��˷���Ϣ
		DDZ_SendMsg2Client(i, DDZ_PLAYER_OPERATE_PLAYERHAND, 0, 0, 0, 0, 0)
	end
	local tBottomCard = DDZ_GetPrivateBottomCards()
	local tBottomReplace = DDZ_CardsValue2LaiziValue(tBottomCard, laizi[nLaiziIndex])
	DDZ_SetPrivateBottomCards(tBottomReplace, 1)
end

function DDZ_SendAndSetTableMgrState(state_end, state_begin)
	--�ӿڲ���˳��Ϊ����һ����������״̬����һ����������״̬����A��B״̬
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
			if DDZ_GetPlayerIsAgent(nPlayerID) == 1 then --�һ�״̬ǿ������ʱ��Ϊ5s
				time = DDZ_CONST_COUNT_DOWN_TIME[DDZ_CONST_TABLE_STATE_WAIT_CS_SEND_AGENT]
				if nTimeID == DDZ_CONST_TABLE_STATE_WAIT_CS_SEND then --����SEND״̬������SEND1״̬Ҫ������Ҳ�����ʱ����������2�����й�״̬�������Լ�һ��Agent״̬������ʵtableMgr״̬����ʱ����ʶ��
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
			--������Ҷ������ˣ����ƽ׶α�Ϊ1s
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

		--�����Ƿ���Ҫ��ĳЩ�׶�����1s��ʱ
		--if nTimeID == CONST_TABLE_STATE_WAIT_CS_SEND_AGENT then
		--time = time + 1 -- �һ����ƺͳ���״̬����һ�ֵ���ʱ��ʱ������1s��for�����ӳ�
		--end

		miniGameMgr1.SetTimer(time, nTimeID, nPlayerID)
		timeStamp = DDZ_SetCountDownTime(time, nTimeID, nPlayerID)
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 111), timeStamp, time, nTimeID, nPlayerID))
		end
	end

	--��Ҫͬ������ʱ�Ľ׶�
	if nTimeID == DDZ_CONST_TABLE_STATE_CALL_CHAIRMAN or nTimeID == DDZ_CONST_TABLE_STATE_SET_CHAIRMAN or nTimeID == DDZ_CONST_TABLE_STATE_DOUBLE
		or nTimeID == DDZ_CONST_TABLE_STATE_SHUFFLE_MINGPAI or nTimeID == DDZ_CONST_TABLE_STATE_WAIT_CS_SEND or nTimeID == DDZ_CONST_TABLE_STATE_WAIT_CS_SEND_AGENT then
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_TIME, nPlayerID, timeStamp, nTimeID, 0, 0)
	end

end

function DDZ_AddCardsTimes(nPlayerIndex, state, nTimes)
	local nLaiziNum = DDZ_GetLaiZiNum()  --��ȡ����淨���
	local nTableStateTime = DDZ_GetPublicTimesTableState(state)
	--�ӱ�����
	DDZ_SetPublicTimesTableState(state, nTableStateTime + 1)
	--�жϵ�ǰ������״̬�����Ӷ�Ӧ�ķ���
	if nPlayerIndex == -1 then
		local nPublicCardsTimes = DDZ_GetPublicCardsTimes()
		if nPublicCardsTimes == 0  then
			nPublicCardsTimes = 1 --���˹�ϵ���趨��ʼֵΪ1
		end

		nPublicCardsTimes = nPublicCardsTimes * nTimes

		if nPublicCardsTimes > DDZ_CONST_MAX_TIMES then
			--���������ݱ���
			nPublicCardsTimes = DDZ_CONST_MAX_TIMES
		end

		DDZ_SetPublicCardsTimes(nPublicCardsTimes)
		--����������nValue2��ֵΪ4

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 5670), state, nTimes, nPublicCardsTimes))
		end
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_CAERDS_TIMES, 4, state, nTimes, nPublicCardsTimes, 0)  --ÿ�η���������ͻ��˷���Ϣ��Я����������ǰ��ҡ��������͡���ǰ���ӵķ�������ǰ�ܷ���
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

--�ж���ҵ������Ƿ�ȫΪ0�����Ƽ��
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

--�ж���ҵĳ�ʼ���ƣ�����˭�ǵ���
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

	--�ҵ�����ֵ����nPlayerIndex ������
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
	--ȷ������֮�󣬵�����ũ�����ͳ�ʼ��
	local nNextPlayer = DDZ_NextPlayer(nChairMan)			--�¼�index	
	local nPreviousPlayer = DDZ_NextPlayer(nNextPlayer)		--�ϼ�index
	local tBottomCard = DDZ_GetPrivateBottomCards() 		--��ȡ����
	local tBottomCardMerge = DDZ_CardTable2MSG(tBottomCard) --����תΪ��Ϣ�Ƹ�ʽ
	local nPlayerMingpaiState = DDZ_GetPlayerMingPaiState(nChairMan)

	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(17, 4273), nChairMan))
	end

	--��ȡ���ƣ������ƹ����������Ƹ����������е��Ʒ����ж�
	DDZ_SetPublicBottomCards(tBottomCard, 1)
	DDZ_SetBottom2PlayerHand(nChairMan, tBottomCard)
	DDZ_BottomCardTimes(tBottomCard)

	--�жϵ����Ƿ����ƣ�ͬ���޸�PublicData����
	if nPlayerMingpaiState > 0 then
		local tHandCards = DDZ_GetPlayerHand(nChairMan)
		DDZ_SetPublicPlayerHandCards(nChairMan, tHandCards)
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_MINGPAI_END, nChairMan, 0, 0, 0, 0)
	end

	--������ҳ�ʼ��������,����20,����17
	DDZ_SetPlayerCardsNum(nChairMan, 20)
	DDZ_SetPlayerCardsNum(nNextPlayer, 17)
	DDZ_SetPlayerCardsNum(nPreviousPlayer, 17)
	--�����Ƿ�һ��ʼ��չʾ������ʣ������
	DDZ_SetPublicCardsNum(nChairMan, 20)
	DDZ_SetPublicCardsNum(nNextPlayer, 17)
	DDZ_SetPublicCardsNum(nPreviousPlayer, 17)

	--�����ж��������趨����,������������,�㲥����
	DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_SET_CHAIRMAN, nChairMan, 0, 0, 0, 0) --�����趨�����β�������
	DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_BOTTOM_CARD, tBottomCardMerge[1], 0, 0, 0, 0)
	DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_PLAYERHAND, 0, 0, 0, 0, 0)

	--�ɾͣ�������һ���ĵ���
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

	local tAnsBottomCard = {}  --ֻ����ֵ�ĵ��ƣ����ڷ������Ʒ���
	local tLineBottomCard = {} --����������
	local bJoker = {false, false}

	for k, v in pairs(tBottomCard) do
		local temp = GetCardValueFromLaiziCard(v)
		table.insert(tAnsBottomCard, temp) 		--������ת��Ϊ��ֵ
		if temp == 0x0E then
			bJoker[1] = true
		end
		if temp == 0x0F then
			bJoker[2] = true
		end
	end

	if bJoker[1] == true and bJoker[2] == true then
		DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_ROCKET, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_ROCKET]) --���������Ϊ˫��
		return
	end

	if bJoker[1] == true and bJoker[2] == false then
		DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_SJOKER, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_SJOKER]) --��С������
	end

	if bJoker[1] == false and bJoker[2] == true then
		DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_BJOKER, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_BJOKER]) --����������
	end

	--ͬ���жϣ�ͬ����������
	if bJoker[1] == false and bJoker[2] == false then
		if GetCardColorFromLaiziCard(tBottomCard[1]) == GetCardColorFromLaiziCard(tBottomCard[2]) and GetCardColorFromLaiziCard(tBottomCard[1]) == GetCardColorFromLaiziCard(tBottomCard[3]) then
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_FLUSH, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_FLUSH]) --��������Ϊͬ��
		end
	end

	table.sort(tAnsBottomCard)		--�������򷽱�Ƚ�
	if tAnsBottomCard[1] == tAnsBottomCard[2] then
		if tAnsBottomCard[2] == tAnsBottomCard[3] then
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_TRIPLE, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_TRIPLE]) --��������һ��
			return
		else
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_DOUBLE, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_DOUBLE])	--���ƶ���
			return
		end
	elseif tAnsBottomCard[2] == tAnsBottomCard[3] then
		DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_DOUBLE, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_DOUBLE])		--���ƶ���
		return
	end

	local bLineResult = CheckInLine(tAnsBottomCard, 1, tLineBottomCard)
	if bLineResult then
		DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_BOTTOM_CARDS_LINE, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_BOTTOM_CARDS_LINE])		--����3��
		return
	end
end

function DDZ_WinnerCash()
	--���㹫ʽΪ�� �ƾֵ׷� * �������� * ���˷��� * �������� = ������ˮ DDZ_GetCashBase() *  DDZ_GetPublicCardsTimes() * DDZ_GetPlayerCardsTimes(nNextPlayer) * DDZ_GetPlayerCardsTimes(nWinner)
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
		table.insert(tPlayerCash, 0) --PlayerCash ��ʼ��

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
		--����ʤ��
		if tPlayerCash[nNextPlayer] > tPlayerOriginCash[nNextPlayer] then
			tPlayerCash[nNextPlayer] = tPlayerOriginCash[nNextPlayer]	--�����������Ϊ0
		end

		if tPlayerCash[nPreviousPlayer] > tPlayerOriginCash[nPreviousPlayer] then
			tPlayerCash[nPreviousPlayer] = tPlayerOriginCash[nPreviousPlayer] --�����������Ϊ0
		end

		tPlayerCash[nChairMan] = tPlayerCash[nPreviousPlayer] + tPlayerCash[nNextPlayer] --���µ�����ˮ
		tPlayerCash[nChairMan] = math.floor(tPlayerCash[nChairMan] * DDZ_CONST_TAX_RATE) --ʤ�߿�˰

		--�����Ҷ����Ϊ��
		tPlayerEndCash[nChairMan] = tPlayerOriginCash[nChairMan] + tPlayerCash[nChairMan]
		tPlayerEndCash[nNextPlayer] = tPlayerOriginCash[nNextPlayer] - tPlayerCash[nNextPlayer]
		tPlayerEndCash[nPreviousPlayer] = tPlayerOriginCash[nPreviousPlayer] - tPlayerCash[nPreviousPlayer]

		--���������
		if tPlayerRemote.nHisMaxCash[nChairMan] < nPublicCardsTimes * tPlayerCardsTimes[nChairMan] * (tPlayerCardsTimes[nPreviousPlayer] + tPlayerCardsTimes[nNextPlayer]) then
			tPlayerRemote.nHisMaxCash[nChairMan] = nPublicCardsTimes * tPlayerCardsTimes[nChairMan] * (tPlayerCardsTimes[nPreviousPlayer] + tPlayerCardsTimes[nNextPlayer])
		end
	else
		--ũ��ʤ��
		if tPlayerCash[nChairMan] > tPlayerOriginCash[nChairMan] then
			tPlayerCash[nChairMan] = tPlayerOriginCash[nChairMan]  --�����������Ϊ0

			--�������������ߵ�����
			tPlayerCash[nNextPlayer] = math.floor(tPlayerCash[nChairMan] * tPlayerCardsTimes[nNextPlayer] / (tPlayerCardsTimes[nNextPlayer] + tPlayerCardsTimes[nPreviousPlayer]))
			tPlayerCash[nPreviousPlayer] = tPlayerCash[nChairMan] - tPlayerCash[nNextPlayer]
		end
		--ʤ�߿�˰
		tPlayerCash[nNextPlayer] = math.floor(tPlayerCash[nNextPlayer] * DDZ_CONST_TAX_RATE)
		tPlayerCash[nPreviousPlayer] = math.floor(tPlayerCash[nPreviousPlayer] * DDZ_CONST_TAX_RATE)

		--�����Ҷ����Ϊ��
		tPlayerEndCash[nChairMan] = tPlayerOriginCash[nChairMan] - tPlayerCash[nChairMan]
		tPlayerEndCash[nNextPlayer] = tPlayerOriginCash[nNextPlayer] + tPlayerCash[nNextPlayer]
		tPlayerEndCash[nPreviousPlayer] = tPlayerOriginCash[nPreviousPlayer] + tPlayerCash[nPreviousPlayer]

		if tPlayerRemote.nHisMaxCash[nNextPlayer] < nPublicCardsTimes * tPlayerCardsTimes[nNextPlayer] * tPlayerCardsTimes[nChairMan] then
			tPlayerRemote.nHisMaxCash[nNextPlayer] = nPublicCardsTimes * tPlayerCardsTimes[nNextPlayer] * tPlayerCardsTimes[nChairMan]
		end

		--ũ�������
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

	--���Զ������
	for i = 1, DDZ_CONST_PLAYER_MAX do
		local bPlayerWin = DDZ_GetPlayerWinnerBool(i)
		--���ӳ�������
		tPlayerRemote.nHisMatchCount[i] = tPlayerRemote.nHisMatchCount[i] + 1

		--���ӳ��γɾ�
		DDZ_Achievement(i, 9421, 1)

		--���ӳ�������
		DDZ_WeekQuest(i)

		--���ӻ����
		DDZ_SummerAct(i)

		--ʤ���ж�
		if bPlayerWin == 1 then
			--������ʤ����
			tPlayerRemote.nCurContinueWin[i] = tPlayerRemote.nCurContinueWin[i] + 1
			tPlayerRemote.nHisWinCount[i] = tPlayerRemote.nHisWinCount[i] + 1
			if tPlayerRemote.nHisContinueWin[i] < tPlayerRemote.nCurContinueWin[i] then
				tPlayerRemote.nHisContinueWin[i] = tPlayerRemote.nCurContinueWin[i]
			end

			--����ʤ���ɾ�
			DDZ_Achievement(i, 9416, 1)

			--�����ʤ���ɾ�
			if DDZ_GetAchievementLaiNum(i) == 0 and DDZ_GetLaiZiNum() > 0 then
				DDZ_Achievement(i, 9434, 0)
			end
		else
			--��ʤ���
			tPlayerRemote.nCurContinueWin[i] = 0
		end

		DDZ_SetCurContinueWin(i, tPlayerRemote.nCurContinueWin[i])    --��ǰ����ʤ��¼
		DDZ_SetHisContinueWin(i, tPlayerRemote.nHisContinueWin[i])     --��ʷ����ʤ��¼
		DDZ_SetHisMatchCount(i, tPlayerRemote.nHisMatchCount[i])      --��ʷ�ܳ���
		DDZ_SetHisWinCount(i, tPlayerRemote.nHisWinCount[i])             --��ʷ��ʤ��
		DDZ_SetHisMaxCash(i, tPlayerRemote.nHisMaxCash[i])               --��ʷ�����

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8674), i, tPlayerRemote.nHisMatchCount[i], tPlayerRemote.nCurContinueWin[i], tPlayerRemote.nHisContinueWin[i], tPlayerRemote.nHisWinCount[i], tPlayerRemote.nHisMaxCash[i]))
		end
	end

	--�Ծֽ�����������������ɾ��߼�
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
				local nBusnessType = 1 --������type

				if DDZ_WRITE_LOG then
					Log(string.format(GetEditorString(20, 8710), dwOwnerID, 9435, 1))
				end
				if player then
					player.AddAchievementCount(9435, 1)

					--�������ߣ��ж��Ƿ��������ҷ�˰�ս���
					--if DDZ_WRITE_LOG then
					--local btemp = CheckHomeLandBusnessType(scene.dwMapID, scene.nCopyIndex, nLandIndex, nBusnessType)
					--Log(string.format("************ ����������ж���%s ************", tostring(btemp)))
					--end
					if IfLandBusnessTypeOpen(scene.dwMapID, scene.nCopyIndex, nLandIndex, GDENUM_HOMELAND_MARKET_TYPE.CARD) then
						nHomelandCash = math.floor(tPlayerCash[nChairMan] * DDZ_CONST_HOMELAND_RATE) --���˻���
						local nCurWeekNum = DDZ_GetWeeklyIncome(player)	--��ȡ���ܵ�����
						local nIncome = 0
						if (nHomelandCash + nCurWeekNum) <= nMaxWeeklyIncome then
							nIncome = nHomelandCash
						else
							nIncome = nMaxWeeklyIncome - nCurWeekNum
						end
						if nIncome > 0 then
							DDZ_SetWeeklyIncome(player, nIncome + nCurWeekNum)	--��¼�µ�����
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
	--��table1 - table2 ��ֵ��ע��˳�򣬴󼯺�Ϊtable1,����ǰ����Ϊtable1����ǰ����Ϊtable2����������ֵΪtable3
	local tEqual = {}   --��¼table1���Ƿ���table2�ı�����������#table2 == #tEqual
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

				table.insert(tEqual, k1) --����ͬ��index����
				break
			end
		end
	end

	if #tEqual == #table2 then
		for k, v in pairs(tEqual) do
			local nCardValue = GetCardValueFromLaiziCard(table1[v])
			table1[v] = 0 --��table1(����)�е���������
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(18, 7650), v, nCardValue, table3[nCardValue] ))
			end

			if table3[nCardValue] > 0 then
				table3[nCardValue] = table3[nCardValue] - 1 --��������Ӧ����ֵ-1
			end
		end
		return true
	else
		--����
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 4770), #tEqual, #table2))
		end
		DDZ_SendMsg2Client( nPlayerIndex, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)
		--��ʹ��flase��table1��ֵҲ�޸��ˣ���Ҫ��Ҫ�޸�������Ƶ�����
		return false
	end
end

function DDZ_SendMsg2Client(nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)
	if nValue5 == nil then --�ɰ汾����
		nValue5 = 0
	end
	if nValue6 == nil then --�ɰ汾���޼���
		nValue6 = 0
	end
	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(17, 5202), nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6))
	end
	if not (nPlayerIndex == -1) then
		nPlayerIndex = nPlayerIndex - 1
	end
	miniGameMgr1.Operate(nPlayerIndex, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)

	--������������߼�����
	if nValue1 == DDZ_PLAYER_OPERATE_SET_CHAIRMAN and nValue4 == 2 then
		--�ڶ���������
		nValue3 = 7
	end
	DDZ_PlayPlayerSound(nValue1, nValue2, nValue3)
end

function DDZ_PlayPlayerSound(nTableState, nPlayerIndex, nValue3)
	local nSoundID = 0
	--��Щ��ϢnValue3== 0���趨����Ϊ1
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
	--��Щ��ϢnValue3== 0���趨����Ϊ1
	if nValue3 == 0 then
		nValue3 = 1
	end

	--��ȡSONUDID
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
	--nValue ����Ϊ���׷֡��Ƿ���ӡ��Ƿ�ϴ�ơ�����player*3
	local math = math
	local nPlayerMingPai = {0, 0, 0}
	local nCashBase = 1
	local nTableType = 1
	local nShuffleType = 1
	--�쳣���ݼ��
	if nValue > 100000 and nValue < 400000 then
		nCashBase = math.floor(nValue / 100000 )
		nTableType = math.floor(nValue / 10000 ) - nCashBase * 10
		nShuffleType = math.floor(nValue / 1000 ) - nCashBase * 100 - nTableType * 10
		nPlayerMingPai[1] = math.floor(nValue / 100 ) - nCashBase * 1000 - nTableType * 100 - nShuffleType * 10
		nPlayerMingPai[2] = math.floor(nValue / 10 ) - nCashBase * 10000 - nTableType * 1000 - nShuffleType * 100 - nPlayerMingPai[1] * 10
		nPlayerMingPai[3] = math.floor(nValue % 10 )
	else
		DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_ERROR, 0, 0, 0, 0, 0)  --�������ݺͼ�ʱ�����ݲ�һ��
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 6280), nValue))
		end
	end

	if DDZ_WRITE_LOG then
		Log(string.format(GetEditorString(19, 6886), nCashBase, nTableType, nShuffleType, nPlayerMingPai[1], nPlayerMingPai[2], nPlayerMingPai[3]))
	end
	DDZ_SetCashBase(DDZ_CONST_BOTTOM_SCORE[nCashBase])	--���õ׷֣�������GetHomelandMgr().StartMiniGame����
	DDZ_SetTableSettingType(nTableType) --���������������ͣ�1����Ұ����ӣ�2��Ұ����ӣ�3��Ұ˫��ӣ�4����ģʽ����3��2��4��2�ԣ�
	DDZ_SetShuffleType(nShuffleType) --����ϴ��ģʽ

	if nTableType == 1 or nTableType == 2 then
		DDZ_SetLaiZiNum(0) 	--����������������ͻ����ϴ�Ϊ1��2��3��
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(19, 6907), DDZ_GetLaiZiNum()))
		end
	end

	if nTableType == 3 then
		DDZ_SetLaiZiNum(1) 	--����������������ͻ����ϴ�Ϊ1��2��3��
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(19, 6907), DDZ_GetLaiZiNum()))
		end
	end

	if nTableType == 4  then
		DDZ_SetLaiZiNum(2) 	--����������������ͻ����ϴ�Ϊ1��2��3��
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(19, 6907), DDZ_GetLaiZiNum()))
		end
	end

	for k, v in pairs(nPlayerMingPai) do
		--�ж��Ƿ�����
		if v > 0  then
			DDZ_SetPlayerMingPaiState(k, DDZ_CONST_TABLE_STATE_INIT) --���õ�ǰ�������״̬
		end
	end
end

function DDZ_OverSetChairMan(nPlayerIndex)
	--������״̬�������������յ���״̬�ж�
	local nChairMan = DDZ_GetChairMan()  --��ȡ�������ݵ���״̬
	local laizi = DDZ_GetPrivateLaiZi()
	local nPlayerSetChairMan = nPlayerIndex --�����������ʸ��nPlayerIndex
	local tPlayerType = {[1] = 9, [2] = 9, [3] = 9}

	for i = 1, 3 do
		local temp = DDZ_NextPlayer(nPlayerIndex + i - 1)
		tPlayerType[temp] = DDZ_GetPlayerChairManType(temp)
	end

	for i = 1, 3 do
		--û�й���������ҿ��Խе���
		local temp = DDZ_NextPlayer(nPlayerIndex + i - 1)
		if tPlayerType[temp] == 0  then
			nPlayerSetChairMan = temp
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(18, 9171), nPlayerSetChairMan))
			end
			break
		end
		--��һ���е������ˣ����ж�ʣ���������Ƿ�����������
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

	--��һ���е����ġ�û�нй������Ļ�������һ��
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

	--�趨������������ҳ�ʼ״̬
	DDZ_OverChairMan(nChairMan)

	DDZ_SendAndSetTableMgrState(DDZ_PLAYER_OPERATE_SET_CHAIRMAN, DDZ_CONST_TABLE_STATE_SHOW_CHAIRMAN)
	DDZ_SetTimer(DDZ_CONST_TABLE_STATE_SHOW_CHAIRMAN, - 1)
end

function DDZ_SendMinCards(nPlayerIndex)
	local tHandCards = DDZ_GetPlayerHand(nPlayerIndex)
	local tOperateCards = 0

	--�ҵ���������С�ĵ��ƴ��
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
		--�����ֵ��С����
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(18, 9398), nPlayerIndex, tOperateCards))
		end
		OnServerOperate(nPlayerIndex - 1, DDZ_PLAYER_OPERATE_CS_SEND, tOperateCards, 0, 0, 0, 0)
	end
end

function DDZ_AutoSendCards(nPlayerIndex)
	--��ȡ�����ϵ��ƣ���ȡ������ƣ�������ʾ������ת����ֵ����OnServerOperate
	local tHandCards = DDZ_GetPlayerHand(nPlayerIndex)		--��������
	local tCurType = DDZ_GetCurOperateCardType()			--��һ�ֳ��Ƶ�����
	local tOperateCards = DDZ_GetCurOperateCard()			--��һ�ֳ��Ƶ�����
	local _, nOperateCardsNum = DDZ_ServerCards2UI(tOperateCards)
	local laizi = DDZ_GetPrivateLaiZi()
	if DDZ_WRITE_LOG then
		Log(string.format("************ nOperateCardsNum :%d ************", nOperateCardsNum))
	end
	local tTipsType, tTipsCards = DDZ_OperateLaiziCard(tCurType, nOperateCardsNum, tHandCards, laizi[1], laizi[2], 1)
	if tTipsCards and #tTipsCards[1] ~= 0 then
		--��ʾ��ֵ�Ϸ�������ʾ��ֵ����
		local tServerOperate = DDZ_UICards2Server(tTipsCards[1])
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(19, 6847), tServerOperate[1], tServerOperate[2], tServerOperate[3], tServerOperate[4], tServerOperate[5]))
		end
		OnServerOperate(nPlayerIndex - 1, DDZ_PLAYER_OPERATE_CS_SEND, tServerOperate[1], tServerOperate[2], tServerOperate[3], tServerOperate[4], tServerOperate[5])
	else
		OnServerOperate(nPlayerIndex - 1, DDZ_PLAYER_OPERATE_JUMP, 0, 0, 0, 0, 0)
	end
end

--��Ϸ������������·�Ҷ����
function DDZ_WriteItem(player, dwID, itemID, cash, str1, str2, str3)
	if cash < 1 then
		return
	end
	local maxDurability = GetItemInfo(ITEM_TABLE_TYPE.OTHER, itemID).nMaxDurability
	local nYeZiLingID_20000 = 40373	--Ҷ���ʢID��ÿ����20000Ҷ����
	local nScale = 20000	--�һ�����
	
	if player then	--������ߣ�����Ľ������		
		local nCurNum = player.GetItemAmountInAllPackages(ITEM_TABLE_TYPE.OTHER, itemID)
		local nPreTotal = nCurNum + cash	--���ν���󣬰����Ԥ������
		local tSendList = {}
		local nSendNum = 0		
		if nPreTotal <= maxDurability then
			if player.CanAddItem(ITEM_TABLE_TYPE.OTHER, itemID, cash) == ADD_ITEM_RESULT_CODE.SUCCESS then			
				player.AddItem(ITEM_TABLE_TYPE.OTHER, itemID, cash)	--�ܽ�����ֱ�ӽ���
			else
				table.insert(tSendList, {ITEM_TABLE_TYPE.OTHER, itemID, cash, 0})
				nSendNum = nSendNum + cash				
			end
		else
			local nConvert = 0
			for i = 1, 100 do	--���ѭ��100��				
				nPreTotal = nPreTotal - nScale	--תһ��
				nConvert = nConvert + 1
				if nPreTotal <= maxDurability then	--������������װ����,��ô��ʼ����
					local nOffset = nPreTotal - nCurNum		--��ֵ,���ܿ۳����߲���
					--��ͷ�������ĺϲ�������ٲ�
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
					--��Ҷ����
					if nConvert > 0 then
						if player.CanAddItem(ITEM_TABLE_TYPE.OTHER, nYeZiLingID_20000, nConvert) == ADD_ITEM_RESULT_CODE.SUCCESS then
							player.AddItem(ITEM_TABLE_TYPE.OTHER, nYeZiLingID_20000, nConvert)		--�ۺϵ�����							
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
	else	--��Ҳ����ߣ�ȫ���ʼ���
		local nPreTotal = cash	--���ν����Ԥ�Ʒ�������	
		local nConvert = 0
		for i = 1, 100 do	--���ѭ��100��			
			if nPreTotal > maxDurability then	--������������װ����,��ô��ʼ����
				nPreTotal = nPreTotal - nScale	--תһ��
				nConvert = nConvert + 1
			else
				break
			end
		end
		local tSendList = {}
		if nConvert > 0 then
			table.insert(tSendList, {ITEM_TABLE_TYPE.OTHER, nYeZiLingID_20000, nConvert, 0})
		end
		if nPreTotal > 0 then	--С��50000����ͷ
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
		table.insert(tSendList, {ITEM_TABLE_TYPE.OTHER, itemID, v, 0})	--���Լ����壬���8��ÿ����		
		if #tSendList == mailMaxCount then
			--	SendSystemMail("���������������齫�ݣ�", dwID, "�ʼ�����", "�ʼ�����", 0, tSendList)	--�м��и�0�ǽ�ң���������
			if player then
				player.SendSystemMessage("��ʿ�����Ѵ����޻�Ҷ�����Ѵ����ޣ�����ʿ�Ʋ���������ȡ��")
				RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", "��ʿ�����Ѵ����޻�Ҷ�����Ѵ����ޣ�����ʿ�Ʋ���������ȡ��", 5)
			end
			SendSystemMail(str1, dwID, str2, str3, 0, tSendList)	--�м��и�0�ǽ�ң���������
			tSendList = {}
		end
	end
	if #tSendList > 0 then
		--	SendSystemMail("���������������齫�ݣ�", dwID, "�ʼ�����", "�ʼ�����", 0, tSendList)	--�м��и�0�ǽ�ң���������
		if player then
			player.SendSystemMessage("��ʿ�����Ѵ����޻�Ҷ�����Ѵ����ޣ�����ʿ�Ʋ���������ȡ��")
			RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", "��ʿ�����Ѵ����޻�Ҷ�����Ѵ����ޣ�����ʿ�Ʋ���������ȡ��", 5)
		end
		SendSystemMail(str1, dwID, str2, str3, 0, tSendList)	--�м��и�0�ǽ�ң���������
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
		--ǿ����Ϸ
		return false
	end

	--��ȡ��ɫԶ������
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
				--�۳�ʧ����ˮ��Ϊ0�������������
				cash = 0
			end
		end

		DDZ_SetCurContinueWin(nPlayerIndex, nCurContinueWin)    --��ǰ����ʤ��¼
		DDZ_SetHisContinueWin(nPlayerIndex, nHisContinueWin)     --��ʷ����ʤ��¼
		DDZ_SetHisMatchCount(nPlayerIndex, nHisMatchCount)      --��ʷ�ܳ���
		DDZ_SetHisWinCount(nPlayerIndex, nHisWinCount)             --��ʷ��ʤ��
		DDZ_SetHisMaxCash(nPlayerIndex, nHisMaxCash)               --��ʷ�����
		DDZ_SetPlayerCashOrigin(nPlayerIndex, cash)		--���ó�ʼ�֣��ӱ��������ȡ
		DDZ_SetPlayerCash(nPlayerIndex, cash)			--���ó�ʼ�֣��ӱ��������ȡ

		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(20, 8289), nPlayerIndex, DDZ_GetPlayerCash(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8290), nPlayerIndex, DDZ_GetPlayerCashOrigin(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8675), nPlayerIndex, DDZ_GetCurContinueWin(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8676), nPlayerIndex, DDZ_GetHisContinueWin(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8677), nPlayerIndex, DDZ_GetHisMatchCount(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8678), nPlayerIndex, DDZ_GetHisWinCount(nPlayerIndex)))
			Log(string.format(GetEditorString(20, 8679), nPlayerIndex, DDZ_GetHisMaxCash(nPlayerIndex)))
		end

		--����Ψһ�����ж���buff
		local buff = player.GetBuff(19818, 0) --ÿ�ռ��buff
		if not buff then
			player.AddBuff(player.dwID, player.nLevel, 19818, 1, 6)
		end
	end
end

--д���ɫԶ������
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

		--ɾ��Ψһ�����ж���buff
		local buff = player.GetBuff(19818, 0) --ÿ�ռ��buff
		if buff then
			player.DelBuff(19818, 1)
		end
	end
end

--����
function DDZ_SettleAccounts()
	if DDZ_GetNeedSettleAccounts() == 0 then
		return
	end
	DDZ_SetNeedSettleAccounts(0)

	for i = 1, DDZ_CONST_PLAYER_MAX do
		WritePlayerDouDiZhuDatas(i)
	end
end

--�������
function DDZ_EndingSpring(nChairMan, nWinner)
	local nNextPlayer = DDZ_NextPlayer(nWinner)
	local nPreviousPlayer = DDZ_NextPlayer(nNextPlayer)

	--�жϴ���
	if nWinner == nChairMan then
		--����ʤ��
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 5646)))
		end
		if DDZ_GetPlayerCardsFirst(nNextPlayer) == 0 and DDZ_GetPlayerCardsFirst(nPreviousPlayer) == 0 then
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_ENDINNG_SPRING, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_ENDINNG_SPRING])		--��������
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 5647)))
			end
			DDZ_SetSpringPlayerIndex(nWinner)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_ENDINNG_SPRING, nWinner, 0, 0, 0, 0)

			--����ɾͣ�����3���ڳ���
			if DDZ_GetAchievementSpring(nWinner) <= 3 then
				DDZ_Achievement(nWinner, 9428, 0)
			end
		end

		--������ʤ���ɾͣ��߼��ǵ���ʤ�����ҵ���Ϊ��
		local nPlayerType = DDZ_GetPlayerChairManType(nWinner)
		if nPlayerType == 4 then
			DDZ_Achievement(nWinner, 9426, 0)
		end
	else
		--ũ��ʤ��
		if DDZ_WRITE_LOG then
			Log(string.format(GetEditorString(17, 5648)))
		end
		if DDZ_WRITE_LOG then
			Log(string.format("************ DDZ_GetPlayerCardsFirst : %d , DDZ_GetPlayerCardsNum:%d ************", DDZ_GetPlayerCardsFirst(nChairMan), DDZ_GetPlayerCardsNum(nChairMan)))
		end
		if DDZ_GetPlayerCardsFirst(nChairMan) + DDZ_GetPlayerCardsNum(nChairMan) == 20 then  --������һ�γ��ƺ͵�ǰ���ƺ�Ϊ20 
			DDZ_AddCardsTimes( - 1, DDZ_CONST_TIMES_ENDINNG_SPRING, DDZ_CONST_CAERDS_TIMES[DDZ_CONST_TIMES_ENDINNG_SPRING])    --ũ����
			if DDZ_WRITE_LOG then
				Log(string.format(GetEditorString(17, 5649)))
			end
			DDZ_SetSpringPlayerIndex(nWinner)
			DDZ_SendMsg2Client( - 1, DDZ_PLAYER_OPERATE_ENDINNG_SPRING, nWinner, 0, 0, 0, 0)

			--ũ�������
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
		local buff_1 = player.GetBuff(19797, 0) --ÿ�ռ��buff
		local buff_2 = player.GetBuff(19796, 0) --ȫ�����buff
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

--��������Ӫ�����ҵ�Ҷ����ֳ�������
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