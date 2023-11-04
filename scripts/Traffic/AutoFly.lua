---------------------------------------------------------------------->
-- �ű�����:	scripts/Traffic/AutoFly.lua
-- ����ʱ��:	2015-10-22 9:35:40
-- �����û�:	meizhu-PC
-- �ű�˵��:	�߼��Ͻ�ͨǰ�ĵ��ã�trueΪ���Գ˽�ͨ��falseΪ������
----------------------------------------------------------------------<
Include("scripts/Map/��¹��ԭ/include/�ݵ�����_Data.lh")
Include("scripts/Traffic/Include/����������Ӧ��.lua")

function CanAutoFly(player, dwFromMapID, dwToMapID) --2023��10�°汾 �����������������2����ͼID ���������е��ǲ��ǿ��ͼ��ͨ
	--2023��10�°汾 ���������ж� �������С�����Ŷ��ڼ�ȥ��������ս���� ����ʱ������
	local tCastleMaps = CastleFight.GetMapActivityState()
	if IsActivityOn(608) and tCastleMaps[dwToMapID] then
		player.SendSystemMessage(GetEditorString(28, 5752))
		return false
	end
	if IsActivityOn(490) and (dwToMapID == 25 or dwToMapID == 27) then
		player.SendSystemMessage(GetEditorString(28, 5772))
		return false
	end
	if player.dwShapeShiftID ~= 0 then	-- ��ҳ����ؾ�״̬
		return false
	end
	if player.GetBuff(7732, 1) then
		player.SendSystemMessage(GetEditorString(6, 5293))
		return false
	end
	if player.GetBuff(9982, 1) then
		player.SendSystemMessage(GetEditorString(8, 6807))
		return false
	end
	if player.GetBuff(13096, 0) then
		player.SendSystemMessage(GetEditorString(8, 6807))
		return false
	end
	if player.GetBuff(9506, 1) then
		player.SendSystemMessage(GetEditorString(8, 9045))
		return false
	end
	--˫�˶����������׶��Ͻ�ͨ�ı��ִ���
	if player.GetBuff(9219, 1) then
		player.SendSystemMessage(GetEditorString(8, 9045))
		return false
	end
	--ͨ�ý�ֹ����BUFF
	if player.GetBuff(10826, 1) then
		player.SendSystemMessage(GetEditorString(8, 9045))
		return false
	end
	if CheckTrafficRepresent(player) == 1 then
		local szTixing = {[1] = GetEditorString(0, 1752), [2] = GetEditorString(0, 1754), [3] = GetEditorString(0, 1752), [4] = GetEditorString(0, 1754), [5] = GetEditorString(1, 615), [6] = GetEditorString(1, 615)}
		local npc = player.GetSelectCharacter()
		if npc and GetNpc(npc.dwID) ~= nil and GetDistanceSq(npc.nX, npc.nY, npc.nZ, player.nX, player.nY, player.nZ) <= 147456 then
			npc.YellTo(player.dwID, GetEditorString(10, 2982) .. player.szName .. szTixing[player.nRoleType] .. GetEditorString(13, 8394))
		end
	end
	return true
end

function AutoFlyEnd(player, bNormalEnd)
	if player.IsHaveBuff(TRAFFIC_BUFF_ID, 1) then
		player.DelBuff(TRAFFIC_BUFF_ID, 1)
	end

	--�������½�ͨ���磺Ŀ���ͼ����
	if not bNormalEnd then
		player.AddBuff(player.dwID, player.nLevel, 16727, 1, 3)  --3����9���ˤ��
	end
end