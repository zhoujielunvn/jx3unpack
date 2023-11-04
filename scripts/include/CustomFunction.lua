---------------------------------------------------------------------->
-- �ű�����:	scripts/Include/CustomFunction.lua
-- ����ʱ��:	2022/10/21 16:33:22
-- �����û�:	dingwenyue
-- �ű�˵��:	
----------------------------------------------------------------------<
function AppendCustomFunctionToGlobal()
	_G.CustomFunction = CustomFunction
end
CustomFunction = CustomFunction or {}

-- ������	: CustomFunction.Jx3Log
-- ��������	: ��DEBUG��DEBUG_LEVELֵ���ʱprint��������
-- �����б�	: DEBUG, DEBUG_LEVEL, ...
-- ����ֵ	: ��
-- ��ע		: ����ʱ������DEBUG == DEBUG_LEVEL,��ʽ�ύʱ����ȼ���
function CustomFunction.Jx3Log(DEBUG, DEBUG_LEVEL, ... )
	if DEBUG and DEBUG == DEBUG_LEVEL then
		print( ... )
	end
end
-- ������	: CustomFunction.CheckMapTraffic
-- ��������	: ���NPC�Ƿ�����н�ͨ����
-- �����б�	: npc, player
-- ����ֵ	: ����ֵ
-- ��ע		:
function CustomFunction.CheckMapTraffic(npc, player)
	if player.IsHaveBuff(7049, 1) then
		player.SendSystemMessage(GetEditorString(6, 872))
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", GetEditorString(6, 872), 4)
		player.OpenWindow(TARGET.NPC, npc.dwID,
			npc.GetAutoDialogString(player.dwID) ..
			GetEditorString(6, 873)
		)
		return false
	end
	if player.IsHaveBuff(7732, 1) then
		player.SendSystemMessage(GetEditorString(6, 4449))
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", GetEditorString(6, 4449), 4)
		player.OpenWindow(TARGET.NPC, npc.dwID,
			npc.GetAutoDialogString(player.dwID) ..
			GetEditorString(6, 4450)
		)
		return false
	end

	if player.dwShapeShiftID ~= 0 then
		player.OpenWindow(TARGET.NPC, npc.dwID,
			npc.GetAutoDialogString(player.dwID) ..
			GetEditorString(6, 4682)
		)
		return false
	end

	if player.IsHaveBuff(7525, 0) or player.IsHaveBuff(7561, 0) then
		player.SendSystemMessage(GetEditorString(6, 4727))
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", GetEditorString(6, 4727), 4)
		player.OpenWindow(TARGET.NPC, npc.dwID,
			npc.GetAutoDialogString(player.dwID) ..
			GetEditorString(6, 4728)
		)
		return false
	end

	local scene = player.GetScene()
	if not scene then
		return false
	end

	return true
end
-- ������	: CustomFunction.MapTrafficByID
-- ��������	: �����ڲ���ͨNPCͨ�ú�����ͨ��ID����
-- �����б�	: npc, player, tNPC, dwMapID, dwWorldNpcID, nNodeID
-- ����ֵ	: ��
-- ��ע		:local tNPC = {[2136] = 1, [2137] = 2,}
--			dwMapID������ID��, dwWorldNpcID�����罻ͨNPCID��, nNodeID����ͨID��
function CustomFunction.MapTrafficByID(npc, player, tNPC, dwMapID, dwWorldNpcID, nNodeID)
	if not CustomFunction.CheckMapTraffic(npc, player) then
		return
	end

	local scene = player.GetScene()
	if not scene then
		return
	end

	if scene.dwMapID ~= dwMapID then
		return
	end

	if not tNPC[npc.dwTemplateID] then
		player.OpenWindow(TARGET.NPC, npc.dwID,
			npc.GetAutoDialogString(player.dwID)
		)
		if npc.dwTemplateID == dwWorldNpcID then
			player.OpenWindow(TARGET.NPC, npc.dwID,
				npc.GetAutoDialogString(player.dwID) ..
				"<U " .. nNodeID .. " " .. GetEditorString(6, 553) .. ">"
			)
		end
	else
		if npc.dwTemplateID == dwWorldNpcID then
			player.OpenWindow(TARGET.NPC, npc.dwID,
				npc.GetAutoDialogString(player.dwID) ..
				"<MT " .. tNPC[npc.dwTemplateID] .. GetEditorString(6, 493) .. "\n\n" ..
				"<U " .. nNodeID .. " " .. GetEditorString(6, 553) .. ">"
			)
		else
			player.OpenWindow(TARGET.NPC, npc.dwID,
				npc.GetAutoDialogString(player.dwID) ..
				"<MT " .. tNPC[npc.dwTemplateID] .. GetEditorString(6, 493)
			)
		end
	end
end
-- ������	: CustomFunction.MapTrafficByName
-- ��������	: �����ڲ���ͨNPCͨ�ú�����ͨ��NickName����
-- �����б�	: npc, player, tNPC, dwMapID, szWorldNpcName, nNodeID
-- ����ֵ	: ��
-- ��ע		:local tNPC = {["nickName1"] = 1, ["nickName2"] = 2,}
--			dwMapID������ID��, szWorldNpcName�����罻ͨNPC������, nNodeID����ͨID��
function CustomFunction.MapTrafficByName(npc, player, tNPC, dwMapID, szWorldNpcName, nNodeID)
	if not CustomFunction.CheckMapTraffic(npc, player) then
		return
	end

	local scene = player.GetScene()
	if not scene then
		return
	end

	if scene.dwMapID ~= dwMapID then
		return
	end

	if not tNPC[npc.szName] then
		player.OpenWindow(TARGET.NPC, npc.dwID,
			npc.GetAutoDialogString(player.dwID)
		)
		if npc.szName == szWorldNpcName then
			player.OpenWindow(TARGET.NPC, npc.dwID,
				npc.GetAutoDialogString(player.dwID) ..
				"<U " .. nNodeID .. " " .. GetEditorString(6, 553) .. ">"
			)
		end
	else
		if npc.szName == szWorldNpcName then
			player.OpenWindow(TARGET.NPC, npc.dwID,
				npc.GetAutoDialogString(player.dwID) ..
				"<MT " .. tNPC[npc.szName] .. GetEditorString(6, 493) .. "\n\n" ..
				"<U " .. nNodeID .. " " .. GetEditorString(6, 553) .. ">"
			)
		else
			player.OpenWindow(TARGET.NPC, npc.dwID,
				npc.GetAutoDialogString(player.dwID) ..
				"<MT " .. tNPC[npc.szName] .. GetEditorString(6, 493)
			)
		end
	end
end
-- ������	: CustomFunction.FindTarget
-- ��������	: ���Ҷ���ĵ�ǰĿ�꣨npc����player��������ָ�����͡�
-- �����б�	: npc, nType
-- ����ֵ	: Ŀ�����
-- ��ע		:����ΪTARGET.NPC����Ŀ����npc����ʱ���أ�����Ϊfalse
--			����ΪTARGET.PLAYER����Ŀ����player����ʱ���أ�����Ϊfalse
--			����Ϊ����ֵʱ���ص�ǰĿ����󣬲�����npc����player��û��Ŀ���򷴻�false��
function CustomFunction.FindTarget(cObject, nType)
	local cNpc = false
	local cPlayer = false
	local pTargetType, pTargetID = cObject.GetTarget()
	if pTargetType == TARGET.PLAYER then
		cPlayer = GetPlayer(pTargetID)
	elseif pTargetType == TARGET.NPC then
		cNpc = GetNpc(pTargetID)
	end
	if nType == TARGET.PLAYER then
		return cPlayer
	elseif nType == TARGET.NPC then
		return cNpc
	else
		return false
	end
end
-- ������	: CustomFunction.GetSpace2D
-- ��������	: ������������֮���2D���롣
-- �����б�	: npc, player
-- ����ֵ	: ����(��λ��,64��Ϊ1��||��)
-- ��ע		:������npc,player,doodad����{nX = 1, nY = 1, nZ = 1}��Table
function CustomFunction.GetSpace2D(npc, player)
	local x, y = npc.nX, npc.nY
	local TargetX, TargetY = player.nX, player.nY

	local nDeltaX = TargetX - x
	local nDeltaY = TargetY - y

	return math.sqrt(nDeltaX * nDeltaX + nDeltaY * nDeltaY)
end
-- ������	: CustomFunction.GetDistance2D
-- ��������	: ������������֮���2D���롣
-- �����б�	: npc, player
-- ����ֵ	: ����(��λ��,64��Ϊ1��||��)
-- ��ע		:������npc,player,doodad����{nX = 1, nY = 1, nZ = 1}��Table
CustomFunction.GetDistance2D = CustomFunction.GetSpace2D
-- ������	: CustomFunction.GetSpace3D
-- ��������	: ������������֮���3D���롣
-- �����б�	: npc, player
-- ����ֵ	: ����(��λ��,64��Ϊ1��||��)
-- ��ע		:������npc,player
function CustomFunction.GetSpace3D(npc, player)
	return GetCharacterDistance(npc.dwID, player.dwID)
	--[[
	local x, y, z = npc.nX, npc.nY, npc.nZ
	local TargetX, TargetY, TargetZ = player.nX, player.nY, player.nZ
	
	local nDeltaX = TargetX - x
	local nDeltaY = TargetY - y
	local nDeltaZ = (TargetZ - z) / 8
	
	return math.sqrt(nDeltaX * nDeltaX + nDeltaY * nDeltaY + nDeltaZ * nDeltaZ)
	--]]
end
-- ������	: CustomFunction.GetAllPlayer
-- ��������	: ��ȡ������������ҡ�
-- �����б�	: scene, bDeath
-- ����ֵ	: ��Ҷ���table��û����ҷ���false
-- ��ע		:bDeath���Ƿ������������ң�
--			ֻ������ս�����߸�������������Ұ�ⳡ����
function CustomFunction.GetAllPlayer(scene, bDeath)
	if scene.nType ~= MAP_TYPE.DUNGEON and scene.nType ~= MAP_TYPE.BATTLE_FIELD then
		return false
	end
	local tTatget = {}
	local tPlayer = scene.GetAllPlayer()
	if tPlayer then
		for i = 1, #tPlayer do
			local cPlayer = GetPlayer(tPlayer[i])
			if cPlayer and (bDeath or cPlayer.nMoveState ~= MOVE_STATE.ON_DEATH) then
				tTatget[#tTatget + 1] = cPlayer
			end
		end
		if #tTatget == 0 then
			return false
		else
			return tTatget
		end
	end
end
-- ������	: CustomFunction.GetRandomPlayer
-- ��������	: �����ȡ�����ڵļ�����ҡ�
-- �����б�	: scene, bDeath, nCount
-- ����ֵ	: ��Ҷ���table��û����ҷ���false
-- ��ע		:bDeath���Ƿ������������ң�, nCount��������������
--			ֻ������ս�����߸�������������Ұ�ⳡ����
--			�����Ҳ����ظ���
function CustomFunction.GetRandomPlayer(scene, bDeath, nCount)
	local tTarget = {}
	local tPlayer = CustomFunction.GetAllPlayer(scene, bDeath)
	if not tPlayer then
		return false
	end
	for i = 1, nCount do
		local cTarget = table.remove(tPlayer, Random(1, #tPlayer))
		tTarget[#tTarget + 1] = cTarget
	end
	if #tTarget > 0 then
		return tTarget
	else
		return false
	end
end

-- ������	: CustomFunction.GetRandomPlayerAdvanced
-- ��������	: �����ȡ�����ڵļ�����ҡ�(�Ľ��棬�������nCount���ܱȳ���������ʱ��Random���������)
-- �����б�	: scene, bDeath, nCount
-- ����ֵ	: ��Ҷ���table��û����ҷ���false
-- ��ע		:bDeath���Ƿ������������ң�, nCount��������������
--			ֻ������ս�����߸�������������Ұ�ⳡ����
--			�����Ҳ����ظ���
--			������������������nCount����ʱ���򾡿��ܵط������е�����б�
function CustomFunction.GetRandomPlayerAdvanced(scene, bDeath, nCount)
	local tTarget = {}
	local tPlayer = CustomFunction.GetAllPlayer(scene, bDeath)
	if not tPlayer then
		return false
	end
	if nCount > #tPlayer then
		return tPlayer
	end
	for i = 1, nCount do
		local cTarget = table.remove(tPlayer, Random(1, #tPlayer))
		tTarget[#tTarget + 1] = cTarget
	end
	if #tTarget > 0 then
		return tTarget
	else
		return false
	end
end
-- ������	: CustomFunction.GetAngle
-- ��������	: ������������֮��ĽǶȣ���npcת��(ת��)����ǶȺ������player��
-- �����б�	: npc, player
-- ����ֵ	: �Ƕ�ֵ
-- ��ע		:������npc,player,doodad����{nX = 1, nY = 1, nZ = 1}��Table
function CustomFunction.GetAngle(npc, Target)
	return GetLogicDirection(Target.nX - npc.nX, Target.nY - npc.nY)
	--local xxNpc_2D_X = npc.nX - Target.nX
	--local xxNpc_2D_Y = npc.nY - Target.nY
	--local xxNpc_3D_X = math.sqrt(xxNpc_2D_X ^ 2 + xxNpc_2D_Y ^ 2)
	--local xxNpc_Angle = math.deg(math.asin(math.abs(xxNpc_2D_X) / math.abs(xxNpc_3D_X)))
	--if xxNpc_2D_X < 0 and xxNpc_2D_Y < 0 then
	--xxNpc_Angle = 90 - xxNpc_Angle
	--elseif xxNpc_2D_X >= 0 and xxNpc_2D_Y <= 0 then
	--xxNpc_Angle = xxNpc_Angle + 90
	--elseif xxNpc_2D_X >= 0 and xxNpc_2D_Y >= 0 then
	--xxNpc_Angle = 90 - xxNpc_Angle + 180
	--elseif xxNpc_2D_X <= 0 and xxNpc_2D_Y >= 0 then
	--xxNpc_Angle = xxNpc_Angle + 270
	--end
	--return math.floor(xxNpc_Angle / 360 * 255)
end
-- ������	: CustomFunction.CreatNpcAndDooadaInAllMaps
-- ��������	: ���ݴ���ı���npc��
-- �����б�	: tScene
-- ����ֵ	: û�С�
-- ��ע		:������server����������ֻ�ܴ����������������ĵ�ͼ�������ڻ����������ʹ�á�
--			����ʹ�ñ�������һ��centerԶ�̵�����ʽRemoteCallToCenter("On_Activity_CCreatNPC",tScene)��ȷ�������ɹ���
--			tScene��д��
--			local tScene = {
--				[1] = {
--					��ʽ��npcID��x, y, z, dir, nickname, type��trueΪnpc  falseΪdoodad��,nDisAppearFrame(ȱʡ��Ϊ�����)
--					{2590, 3633, 31138, 1068736, 188, "qm_gongpin_1", false},
--					{11721, 2735, 30349, 1068800, 66, "qm_wangyifengsuicong", true},
--				}, --"�����",
--			}
function CustomFunction.CreatNpcAndDooadaInAllMaps(tScene)
	if not tScene then
		return
	end
	local scene = nil
	for dwMapID in pairs(tScene) do
		local tCopyIndexList = GetAllCopyIndexByMapID(dwMapID)
		if  tCopyIndexList then
			for _, nCopyIndex in ipairs(tCopyIndexList) do
				scene = GetSceneByMapIDAndIndex(dwMapID, nCopyIndex)
				if scene then
					if tScene[dwMapID] then
						for i = 1, #tScene[dwMapID] do
							if tScene[dwMapID][i][7] then		--npc
								if not scene.IsNickNameNpcAlive(tScene[dwMapID][i][6]) then
									local npc = scene.CreateNpc(tScene[dwMapID][i][1], tScene[dwMapID][i][2], tScene[dwMapID][i][3], tScene[dwMapID][i][4], tScene[dwMapID][i][5], - 1, tScene[dwMapID][i][6])
									if npc and tScene[dwMapID][i][8] then
										npc.SetDisappearFrames(tScene[dwMapID][i][8])
									end
								end
							else								--doodad
								if not scene.IsNickNameDoodadAlive(tScene[dwMapID][i][6]) then
									local doodad = scene.CreateDoodad(tScene[dwMapID][i][1], tScene[dwMapID][i][2], tScene[dwMapID][i][3], tScene[dwMapID][i][4], tScene[dwMapID][i][5], tScene[dwMapID][i][6])
									if doodad and tScene[dwMapID][i][8] then
										doodad.SetDisappearFrames(tScene[dwMapID][i][8])
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
-- ������	: CustomFunction.DelActNpcAndDooadaInAllMaps
-- ��������	: ���ݴ���ı�ɾ��npc��ɾ����Ӧ������npc��doodad.ֻ�б���������Ϊ��Ҫ�Ĳ�����
-- �����б�	: tScene
-- ����ֵ	: û�С�
-- ��ע		:������server����������ֻ��ɾ���������������ĵ�ͼ�������ڻ����������ʹ�á�
--			tScene��д��
--			local tScene = {
--				[1] = {
--					��ʽ��npcID��x, y, z, dir, nickname, type��trueΪnpc  falseΪdoodad��,nDisAppearFrame(ȱʡ��Ϊ�����)
--					{2590, 3633, 31138, 1068736, 188, "qm_gongpin_1", false}, --��������Ĺ
--				}, --"�����",
--			}
function CustomFunction.DelActNpcAndDooadaInAllMaps(tScene)
	if not tScene then
		return
	end
	local scene = nil
	for dwMapID in pairs(tScene) do
		local tCopyIndexList = GetAllCopyIndexByMapID(dwMapID)
		if  tCopyIndexList then
			for _, nCopyIndex in ipairs(tCopyIndexList) do
				scene = GetSceneByMapIDAndIndex(dwMapID, nCopyIndex)
				if  scene then
					if tScene[dwMapID] then
						local npcid = nil
						local doodadid = nil
						for i = 1, #tScene[dwMapID] do
							if tScene[dwMapID][i][7] then		--npc
								npcid = scene.GetNpcIDByNickName(tScene[dwMapID][i][6])
								if npcid then
									scene.DestroyNpc(npcid)
								end
							else								--doodad
								doodadid = scene.GetDoodadIDByNickName(tScene[dwMapID][i][6])
								if doodadid then
									scene.DestroyDoodad(doodadid)
								end
							end
						end
					end
				end
			end
		end
	end
end
-- ������	: CustomFunction.GetPos
-- ��������	: ����ĳ���ǶȾ���ĵ�����ꡣ
-- �����б�	: nAngle, nSpace
-- ����ֵ	: �Ƕ�ֵ������ֵ
-- ��ע		: nAngle��λΪ�߼��Ƕ� 256���ͻ��˻�ȡ�ĽǶ�/360*256)
function CustomFunction.GetPos(nAngle, nSpace)
	return GetLogicRaycastHit(0, 0, nAngle, nSpace)
--[[ԭ����
	nAngle = nAngle - 270
	if nAngle < 0 then
		nAngle = 360 + nAngle
	end
	nAngle = 360 - nAngle
	local nx, ny = 0, 0
	if nAngle == 0 then
		nx = 0
		ny = - nSpace
	elseif nAngle > 0 and nAngle < 90 then
		nx = - math.sin(math.rad(nAngle)) * nSpace
		ny = - math.cos(math.rad(nAngle)) * nSpace
	elseif nAngle == 90 then
		nx = - nSpace
		ny = 0
	elseif nAngle > 90 and nAngle < 180 then
		nx = - math.cos(math.rad(nAngle - 90)) * nSpace
		ny = math.sin(math.rad(nAngle - 90)) * nSpace
	elseif nAngle == 180 then
		nx = 0
		ny = nSpace
	elseif nAngle > 180 and nAngle < 270 then
		nx = math.sin(math.rad(nAngle - 180)) * nSpace
		ny = math.cos(math.rad(nAngle - 180)) * nSpace
	elseif nAngle == 270 then
		nx = nSpace
		ny = 0
	elseif nAngle > 270 and nAngle < 360 then
		nx = math.cos(math.rad(nAngle - 270)) * nSpace
		ny = - math.sin(math.rad(nAngle - 270)) * nSpace
	elseif nAngle == 360 then
		nx = 0
		ny = - nSpace
	else
		nx = 0
		ny = 0
	end
	return nx, ny
--]]
end

-- ������	: CustomFunction.GetOffsetPos
-- ��������	: ����ĳ��������ĳ���Ƕ�ƫ��ĳ���������
-- �����б�	: ĳ����, ƫ�ƽǶ�(��Ϸ��2����256��), ƫ�ƾ���
-- ����ֵ	: X����, Y����
-- ��ע		: nAngle��λΪ�߼��Ƕ�256,����Ϊ0/256
function CustomFunction.GetOffsetPos(KTarget, nAngle, nDistance)
	return GetLogicRaycastHit(KTarget.nX, KTarget.nY, KTarget.nFaceDirection + nAngle, nDistance)
--[[ԭ����
	local nDir = KTarget.nFaceDirection + nAngle
	if nDir > 256 then
		nDir = nDir % 256
	end
	nDir = 360 * nDir / 256
	local nX = math.cos(math.rad(nDir)) * nDistance
	local nY = math.sin(math.rad(nDir)) * nDistance
	return KTarget.nX + nX, KTarget.nY + nY
--]]
end

-- ������	: CustomFunction.GetOffsetPosByXY
-- ��������	: ����ĳ��ָ���ĵ㣬��ĳ���Ƕ�ƫ��ĳ���������
-- �����б�	: ���ĵ�X�����ĵ�Y, Ŀǰ��nFace��ƫ�ƽǶ�(��Ϸ��2����256��), ƫ�ƾ���
-- ����ֵ	: X����, Y����
-- ��ע		: nAngle��λΪ�߼��Ƕ� 256,ǰ��Ϊ0������Ϊ64����Ϊ128, ����Ϊ198
function CustomFunction.GetOffsetPosByXYFA(nX, nY, nFace, nAngle, nDistance)
	return GetLogicRaycastHit(nX, nY, nFace + nAngle, nDistance)
--[[ԭ����
	local nDir = nFace + nAngle
	if nDir > 256 then
		nDir = nDir % 256
	end
	nDir = 360 * nDir / 256
	local nOffsetX = math.cos(math.rad(nDir)) * nDistance
	local nOffsetY = math.sin(math.rad(nDir)) * nDistance
	return nX + nOffsetX, nY + nOffsetY
--]]
end

-- ������	: CustomFunction.AddQuestValue
-- ��������	: �����������ֵ��
-- �����б�	: player, dwQuestID, nIndex, bTeam, [nSpace]
-- ����ֵ	: û�С�
-- ��ע		:player����Ҷ���, dwQuestID������ID��, nIndex������λ��, bTeam�������Ƿ�Ҳ�ӣ�, [nSpace������ͬ������,��λ��,Ĭ��Ϊ32�ߣ�]
function CustomFunction.AddQuestValue(player, dwQuestID, nIndex, bTeam, nSpace)
	local nQuestIndexPlayer = player.GetQuestIndex(dwQuestID)
	if not nQuestIndexPlayer then
		return
	end
	local nQuestPhase = player.GetQuestPhase(dwQuestID)
	if nQuestPhase == 1 or nQuestPhase == 2 then
		if not bTeam then
			if nQuestPhase == 1 then
				local nQuestIndex = player.GetQuestIndex(dwQuestID)
				if nQuestIndex then
					local nValue = player.GetQuestValue(nQuestIndex, nIndex)
					player.SetQuestValue(nQuestIndex, nIndex, nValue + 1)
				end
			end
		else
			local tPartyMember = player.GetPartyMemberList()
			if tPartyMember then
				local scene = player.GetScene()
				if not scene then
					return
				end
				local nPartyMemberCount = #tPartyMember
				local dwMapID = scene.dwMapID
				local nShareDistance = 2048
				if nSpace then
					nShareDistance = nSpace * 64
				end
				for i = 1, nPartyMemberCount do
					local member = GetPlayer(tPartyMember[i])
					if member then
						local memberScene = member.GetScene()
						local dwMemberMapID = memberScene.dwMapID
						nQuestPhase = member.GetQuestPhase(dwQuestID)
						if nQuestPhase == 1 then
							if dwMapID == dwMemberMapID then
								local nDistance = GetCharacterDistance(player.dwID, member.dwID)
								if nDistance <= nShareDistance then
									local nQuestIndex = member.GetQuestIndex(dwQuestID)
									if nQuestIndex then
										local nValue = member.GetQuestValue(nQuestIndex, nIndex)
										member.SetQuestValue(nQuestIndex, nIndex, nValue + 1)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

-- ������	: CustomFunction.GetFrontNpcPosition
-- ��������	: ���ĳ����ǰ��nDis��������꣬
-- �����б�	: nX,nY��nDir����ǰ������ͷ���nDis1����
-- ����ֵ	: tMidFollow = {nX = xxx, nY = xxx, nDir = 222}
-- ��ע		:
function CustomFunction.GetFrontNpcPosition(nX, nY, nDir, nDis1)
	if not nX or not nY or not nDir or nX < 0 or nY < 0 or nDir < 0 then
		return 0;
	end
	nDis1 = nDis1 or 200;
	local nMaxDir = 256;
	local nC = 3.14159 * nDir * 2 / nMaxDir;
	local tMidFollow = {};
	local nDoorNpcDir = nDir + nMaxDir / 2;
	tMidFollow.nDir = nDoorNpcDir < nMaxDir  and nDoorNpcDir or (nDoorNpcDir - nMaxDir)
	if nDir <= nMaxDir / 4 then
		tMidFollow.nX = nX + nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY + nDis1 * math.abs(math.sin(nC));
	elseif nDir <= nMaxDir / 2 then
		tMidFollow.nX = nX - nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY + nDis1 * math.abs(math.sin(nC));
	elseif nDir <= nMaxDir * 3 / 4 then
		tMidFollow.nX = nX - nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY - nDis1 * math.abs(math.sin(nC));
	else
		tMidFollow.nX = nX + nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY - nDis1 * math.abs(math.sin(nC));
	end
	return tMidFollow;
end

-- ������	: CustomFunction.GetFrontNpcPositionAnyDir
-- ��������	: ���ĳ����ǰ��nDis��������꣬�����������0�ͳ���255��nDirֵ
-- �����б�	: nX,nY��nDir����ǰ������ͷ���nDis1����
-- ����ֵ	: tMidFollow = {nX = xxx, nY = xxx, nDir = 222}
-- ��ע		:
function CustomFunction.GetFrontNpcPositionAnyDir(nX, nY, nDir, nDis1)
	if not nX or not nY or not nDir or nX < 0 or nY < 0 then
		return 0;
	end
	if nDir < 0 then
		nDir = nDir % 255
	elseif nDir > 255 then
		nDir = nDir % 255
	end
	nDis1 = nDis1 or 200;
	local nMaxDir = 256;
	local nC = 3.14159 * nDir * 2 / nMaxDir;
	local tMidFollow = {};
	local nDoorNpcDir = nDir + nMaxDir / 2;
	tMidFollow.nDir = nDoorNpcDir < nMaxDir  and nDoorNpcDir or (nDoorNpcDir - nMaxDir)
	if nDir <= nMaxDir / 4 then
		tMidFollow.nX = nX + nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY + nDis1 * math.abs(math.sin(nC));
	elseif nDir <= nMaxDir / 2 then
		tMidFollow.nX = nX - nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY + nDis1 * math.abs(math.sin(nC));
	elseif nDir <= nMaxDir * 3 / 4 then
		tMidFollow.nX = nX - nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY - nDis1 * math.abs(math.sin(nC));
	else
		tMidFollow.nX = nX + nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY - nDis1 * math.abs(math.sin(nC));
	end
	return tMidFollow;
end

-- ������	: CustomFunction.GetFollowsPosition
-- ��������	: ���ĳ������nDis�����3�����棨npc�������꣬
-- �����б�	: nX,nY��nDir����ǰ������ͷ���;nDis1�ࣺ���м�λ�õĸ��棨npc���뵱ǰ����ľ��룻a: ����2�����棨npc�����м���棨npc���ľ���
-- ����ֵ	: tMidFollow = {nX = xxx, nY = xxx}�� tLeftFollow = {nX = xxx, nY = xxx,}��tRightFollow = {nX = xxx, nY = xxx}
-- ��ע		:
function CustomFunction.GetFollowsPosition(nX, nY, nDir, nDis1, a)
	if not nX or not nY or not nDir or nX < 0 or nY < 0 or nDir < 0 then
		return 0;
	end
	nDis1 = nDis1 or 500;
	a = a or 500;
	local nMaxDir = 256;
	local nC = 3.14159 * nDir * 2 / nMaxDir;
	local tMidFollow, tLeftFollow, tRightFollow = {}, {}, {};
	if nDir <= nMaxDir / 4 then
		tMidFollow.nX = nX - nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY - nDis1 * math.abs(math.sin(nC));
		tRightFollow.nX = tMidFollow.nX + a * math.abs(math.sin(nC));
		tRightFollow.nY = tMidFollow.nY - a * math.abs(math.cos(nC));
		tLeftFollow.nX = tMidFollow.nX - a * math.abs(math.sin(nC));
		tLeftFollow.nY = tMidFollow.nY + a * math.abs(math.cos(nC));
	elseif nDir <= nMaxDir / 2 then
		tMidFollow.nX = nX + nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY - nDis1 * math.abs(math.sin(nC));
		tRightFollow.nX = tMidFollow.nX + a * math.abs(math.sin(nC));
		tRightFollow.nY = tMidFollow.nY + a * math.abs(math.cos(nC));
		tLeftFollow.nX = tMidFollow.nX - a * math.abs(math.sin(nC));
		tLeftFollow.nY = tMidFollow.nY - a * math.abs(math.cos(nC));
	elseif nDir <= nMaxDir * 3 / 4 then
		tMidFollow.nX = nX + nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY + nDis1 * math.abs(math.sin(nC));
		tRightFollow.nX = tMidFollow.nX - a * math.abs(math.sin(nC));
		tRightFollow.nY = tMidFollow.nY + a * math.abs(math.cos(nC));
		tLeftFollow.nX = tMidFollow.nX + a * math.abs(math.sin(nC));
		tLeftFollow.nY = tMidFollow.nY - a * math.abs(math.cos(nC));
	else
		tMidFollow.nX = nX - nDis1 * math.abs(math.cos(nC));
		tMidFollow.nY = nY + nDis1 * math.abs(math.sin(nC));
		tRightFollow.nX = tMidFollow.nX + a * math.abs(math.sin(nC));
		tRightFollow.nY = tMidFollow.nY + a * math.abs(math.cos(nC));
		tLeftFollow.nX = tMidFollow.nX - a * math.abs(math.sin(nC));
		tLeftFollow.nY = tMidFollow.nY - a * math.abs(math.cos(nC));
	end

	return tMidFollow, tLeftFollow, tRightFollow;
end

-- ������	: CustomFunction.GetValueByBit
-- ��������	: ������ֵ�ĳһ����λֵ
-- �����б�	:  nValue��ֵ��nBit��ȡֵ��Χ[0,31]
-- ����ֵ	: 1 or 0
-- ��ע		: CustomFunction.GetValueByBit(10, 31)����ʾ��ȡ���֡�10���ĵ�31��Bitλ��ֵ��
function CustomFunction.GetValueByBit(nValue, nBit)
	if nBit > 31 or nBit < 0 then
		print(">>>>>>>CustomFunction.GetValueByBit Arg ERROR!!!!!BitIndex error")
		--return nValue
	end
	return GetValueByBits(nValue, nBit, 1)
	--return math.floor(nValue / 2 ^ nBit) % 2
end

-- ������	: CustomFunction.SetValueByBit
-- ��������	: ��ĳ��ֵ��ĳһ����λֵ����Ϊ0����1
-- �����б�	:  nValue��ֵ��nBit��ȡֵ��Χ[0,31]��nNewBit��ֻ��Ϊ0����1
-- ����ֵ	: ������bit֮�����ֵ
-- ��ע		: CustomFunction.SetValueByBit(10,31,1)����ʾ�����֡�10���ĵ�31��Bitλ��ֵ��Ϊ1
function CustomFunction.SetValueByBit(nValue, nBit, nNewBitValue)
	if nNewBitValue > 1 or nNewBitValue < 0 then
		print(">>>>>>>CustomFunction.SetValueByBit Arg ERROR!!!!!nNewBit Must be 0 or 1,")
		return nValue
	end
	if nBit > 31 or nBit < 0 then
		print(">>>>>>>CustomFunction.SetValueByBit Arg ERROR!!!!!BitIndex error")
		return nValue
	end
	return SetValueByBits(nValue, nBit, 1, nNewBitValue)
	--���Ҫ���õ���ֵ�;�ֵһ������ôֵ���䣬ֱ�ӷ���
	--if math.floor(nValue / 2 ^ nBit) % 2 == nNewBitValue then
		--return nValue
	--end
	--�����������ȷ��ô
	--if nNewBitValue > 1 or nNewBitValue < 0 or nBit > 31 or nBit < 0 then
		--print(">>>>>>>CustomFunction.SetValueByBit Arg ERROR!!!!!nBit=[] nNewBit Must be 0 or 1,")
		--return nValue
	--end
	--0���1��ֵ��1���0��ֵ
	--print("SetValueByBit="..nNewBitValue)
	--if nNewBitValue == 1 then
		--return nValue + 2 ^ nBit
	--else
		--return nValue - 2 ^ nBit
	--end
end

-- ������	: CustomFunction.IfStartAdventure
-- ��������	: �Ƿ���/����ĳ������.
-- ��ʵ�ǳ��Զ���ҷ���ָ����������˼��һ�������������cd�оͻ᳢�Զ���ҷ�����������Ҫ�����˵�on_qiyu.lua�������ñ��������ʹ�á�-xutong
-- �����б�	:  player��nAdventureID������ ui/Scheme/Case/Adventure.txt��
-- ����ֵ	: ��
-- ��ע		:
function CustomFunction.IfStartAdventure(player, nAdventureID, bTianshu)	--�ߵ����ﲻ����һ�������������ڴ�֮ǰ���÷������򷢹��棬����ƨ���Լ���
	if not player or not nAdventureID or nAdventureID <= 0 then
		return false
	end
	if player.GetBuff(9186, 1) then
		return false
	end
	--�鿴����Ƿ������ϣ�û������ϵĻ�ȡ��������״̬
	if not player.bExtDataLoadFinish then
		return false
	end
	player.AddBuff(0, 99, 9186, 1)
	if player.GetCustomUnsigned2(387) == 0 then
		RemoteCallToCenter("On_QiYu_CheckCD", player.dwID, nAdventureID, bTianshu)
		print("IfStartAdventure")
		return true
	end
end

local tAdventureQuestList = {
	[1] = {nTryQuestID = 18090, dwAcceptID = 1, dwAchiID = 7154}, --��ɽ�ĺ�
	[2] = {nTryQuestID = 18091, dwAcceptID = 391, dwAchiID = 7155}, --�������
	[3] = {nTryQuestID = 18092, dwAcceptID = 151, dwAchiID = 7156}, --��������
	[4] = {nTryQuestID = 18094, dwAcceptID = 81, dwAchiID = 7157}, --�ڰ�·������
	[5] = {nTryQuestID = 18093, dwAcceptID = 95, dwAchiID = 7158}, --�ڰ�·������
	[6] = {nTryQuestID = 18095, dwAcceptID = 231, dwAchiID = 7159}, --������
	[7] = {nTryQuestID = 18096, dwAcceptID = 301, dwAchiID = 7160}, --�����Ե
	[8] = {nTryQuestID = 18097, dwAcceptID = 367, dwAchiID = 7161}, --�����С����˹�
	[9] = {nTryQuestID = 18098, dwAcceptID = 377, dwAchiID = 7162}, --�����С�������
	[10] = {nTryQuestID = 18099, dwAcceptID = 519, dwAchiID = 7163}, --��������
	[11] = {nTryQuestID = 18100, dwAcceptID = 559, dwAchiID = 7164}, --�������
	[12] = {nTryQuestID = 18101, dwAcceptID = 589, dwAchiID = 7165}, --������
	[13] = {nTryQuestID = 18102, dwAcceptID = 631, dwAchiID = 7166}, --ʤ����
	[14] = {nTryQuestID = 18103, dwAcceptID = 671, dwAchiID = 7167}, --����·
	[15] = {nTryQuestID = 18104, dwAcceptID = 711, dwAchiID = 7168}, --���־�
	[16] = {nTryQuestID = 18105, dwAcceptID = 731, dwAchiID = 7169}, --���¸�
	[17] = {nTryQuestID = 18106, dwAcceptID = 771, dwAchiID = 7170}, --׽����
	[18] = {nTryQuestID = 18107, dwAcceptID = 801, dwAchiID = 7171}, --��ͯ��
	[19] = {nTryQuestID = 18108, dwAcceptID = 843, dwAchiID = 7172}, --��粶��
	[20] = {nTryQuestID = 18109, dwAcceptID = 841, dwAchiID = 7173}, --��ҡ����
	[21] = {nTryQuestID = 18110, dwAcceptID = 865, dwAchiID = 7174}, --���ⱦ��
	[22] = {nTryQuestID = 18111, nQuestID = 14833, dwAchiID = 7175}, --�����޹�
	[23] = {nTryQuestID = 18112, dwAcceptID = 913, dwAchiID = 0}, --��������
	[25] = {nTryQuestID = 18113, dwAcceptID = 993, dwAchiID = 7176}, --ɳ��ҥ
	[26] = {nTryQuestID = 18114, dwAcceptID = 1009, dwAchiID = 7177}, --ʯ�ҵ�
	[27] = {nTryQuestID = 18115, dwAcceptID = 1025, dwAchiID = 7178}, --�����
	[28] = {nTryQuestID = 18116, dwAcceptID = 1053, dwAchiID = 7179}, --������
	[29] = {nTryQuestID = 18117, dwAcceptID = 1067, dwAchiID = 7180}, --������
	[30] = {nTryQuestID = 18118, dwAcceptID = 1079, dwAchiID = 7181}, --����
	[31] = {nTryQuestID = 18119, dwAcceptID = 1099, dwAchiID = 7182}, --���Ӳ���
	[32] = {nTryQuestID = 18120, dwAcceptID = 1119, dwAchiID = 7183}, --��Хɽ��
	[33] = {nTryQuestID = 18121, dwAcceptID = 1162, dwAchiID = 7184}, --�����輧
	[34] = {nTryQuestID = 18122, dwAcceptID = 1125, dwAchiID=7185}, --������
	[35] = {nTryQuestID = 18123, dwAcceptID = 1177, dwAchiID=7186}, --������
	[36] = {nTryQuestID = 18124, dwAcceptID = 1205, dwAchiID=7187}, --��ݸ�
	[37] = {nTryQuestID = 18125, dwAcceptID = 1237, dwAchiID=7188}, --������
	[40] = {nTryQuestID = 18126, nQuestID = 16393, dwAchiID=7189}, --ѩɽ����
	[41] = {nTryQuestID = 18127, dwAcceptID = 1255, dwAchiID=7190}, --ƽ����Ը
	[42] = {nTryQuestID = 18128, dwAcceptID = 1283, dwAchiID=7191}, --������
	[43] = {nTryQuestID = 18129, nQuestID = 16882, dwAchiID=7192}, --������
	[44] = {nTryQuestID = 18130, nQuestID = 16886, dwAchiID=7193}, --������
	[46] = {nTryQuestID = 18131, dwAcceptID = 1311, dwAchiID=7194}, --��԰����
	[47] = {nTryQuestID = 18132, dwAcceptID = 1313, dwAchiID=7195}, --��âչ
	[48] = {nTryQuestID = 18133, dwAcceptID = 1339, dwAchiID=7196}, --�����
	[49] = {nTryQuestID = 18134, dwAcceptID = 1357, dwAchiID=7197}, --��Ů��
	[50] = {nTryQuestID = 18135, nQuestID = 17885, dwAchiID=7198}, --�ػ���
	[54] = {nTryQuestID = 18136, dwAcceptID = 1373, dwAchiID=7199}, --�ͽ�Ů
	[55] = {nTryQuestID = 18137, dwAcceptID = 1379, dwAchiID=7200}, --һ���
	[56] = {nTryQuestID = 18138, dwAcceptID = 1385, dwAchiID=7201}, --�����
	[57] = {nTryQuestID = 18139, dwAcceptID = 1391, dwAchiID=7202}, --��ѩ��
	[58] = {nTryQuestID = 18140, dwAcceptID = 1401, dwAchiID=7203}, --�̻�Ϸ����
	[59] = {nTryQuestID = 18141, dwAcceptID = 1407, dwAchiID=7204}, --�̻�Ϸ����
	[60] = {nTryQuestID = 18142, dwAcceptID = 1413, dwAchiID=7205}, --�̻�Ϸ����
	[61] = {nTryQuestID = 18143, dwAcceptID = 1419, dwAchiID=7206}, --�̻�Ϸ����
	[62] = {nTryQuestID = 18153, dwAcceptID = 1425, dwAchiID=7207}, --�鰲־����
	[63] = {nTryQuestID = 18152, dwAcceptID = 1435, dwAchiID=7208}, --�鰲־����
	[64] = {nTryQuestID = 18154, dwAcceptID = 1445, dwAchiID=7209}, --�鰲־��־
	[65] = {nTryQuestID = 18144, nQuestID = 18081, dwAchiID=7210}, --��ͷɱ
	[66] = {nTryQuestID = 18145, nQuestID = 18163, dwAchiID=7211}, --�ò���
	[67] = {nTryQuestID = 18146, dwAcceptID = 1455, dwAchiID=7212}, --̫�е�
	[68] = {nTryQuestID = 18147, dwAcceptID = 1475, dwAchiID=7213}, --�ر�ͼ
	[69] = {nTryQuestID = 18148, dwAcceptID = 1501, dwAchiID=7214}, --�ͽ���
	[70] = {nTryQuestID = 18149, dwAcceptID = 1517, dwAchiID=7215}, --��ˮ��
	[71] = {nTryQuestID = 18150, dwAcceptID = 1527, dwAchiID=7216}, --������
	[72] = {nTryQuestID = 18151, dwAcceptID = 1539, dwAchiID=7217}, --�׺���
	[73] = {nTryQuestID = 18155, dwAcceptID = 1547, dwAchiID=7453}, --Ե���ᡤ��
	[74] = {nTryQuestID = 18156, dwAcceptID = 1557, dwAchiID=7454}, --Ե���ᡤ��
	[75] = {nTryQuestID = 18157, dwAcceptID = 1567, dwAchiID=7455}, --����¼
	[76] = {nTryQuestID = 18158, dwAcceptID = 1571, dwAchiID=7609}, --������
	[77] = {nTryQuestID = 21696, dwAcceptID = 1573, dwAchiID=7800}, --¶԰��
	[78] = {nTryQuestID = 21604, nQuestID = 21605, dwAchiID=7502}, --�ý���
	[79] = {nTryQuestID = 21694, nQuestID = 21657, dwAchiID=7601}, --������
	[80] = {nTryQuestID = 21756, dwAcceptID = 1595, dwAchiID=7801}, --Ḭ̄��
	[81] = {nTryQuestID = 21757, dwAcceptID = 1621, dwAchiID=7802}, --�����
	[82] = {nTryQuestID = 21874, nQuestID = 21837, dwAchiID=7879}, --Ȱѧ��
	[83] = {nTryQuestID = 21873, nQuestID = 21853, dwAchiID=7880}, --100����
	[85] = {nTryQuestID = 23051, dwAcceptID = 1635,dwAchiID=9028}, --������
	[86] = {nTryQuestID = 23052, dwAcceptID = 1645,dwAchiID=9029}, --�����
	[87] = {nTryQuestID = 23053, dwAcceptID = 1653,dwAchiID=9030}, --������
	[88] = {nTryQuestID = 23236, nQuestID = 23212, dwAchiID=9109}, --���Ї�;
	[89] = {nTryQuestID = 23471, dwAcceptID = 1665,dwAchiID=9142}, --һ֦��
	[90] = {nTryQuestID = 23371, nQuestID = 23372, dwAchiID=9363}, --�������
	[91] = {nTryQuestID = 23626, dwAcceptID = 1677,dwAchiID=9143}, --�����
	[92] = {nTryQuestID = 23638, dwAcceptID = 1691,dwAchiID=9144}, --׽����
	[93] = {nTryQuestID = 23688, nQuestID = 23689, dwAchiID=9443}, --Ѱè�ǣ��ɾ�δ��
	[94] = {nTryQuestID = 24036, nQuestID = 23831, dwAchiID=9592}, --����л�
	[95] = {nTryQuestID = 23947, dwAcceptID = 1711,dwAchiID=9683}, --ͯ��־
	[96] = {nTryQuestID = 23853, dwAcceptID = 1699,dwAchiID=9684}, --�����
	[97] = {nTryQuestID = 23967, dwAcceptID = 1731,dwAchiID=9685}, --������
	[98] = {nTryQuestID = 24201, nQuestID = 23975,dwAchiID=9731}, --������
	[99] = {nTryQuestID = 24214, nQuestID = 24163,dwAchiID=9733}, --�����ġ����˹�
	[100] = {nTryQuestID = 24260, nQuestID = 24189,dwAchiID=9733}, --�����ġ�������
	[101] = {nTryQuestID = 24360, nQuestID = 24361,dwAchiID=10033}, --��������
	[102] = {nTryQuestID = 24510, dwAcceptID = 1747,dwAchiID=10141}, --�ȸ��
	[103] = {nTryQuestID = 24692, dwAcceptID = 1761, dwAchiID=10142}, --�ĺ���
	[104] = {nTryQuestID = 24599, nQuestID = 24591, dwAchiID=10147}, --���鵱��
	[105] = {nTryQuestID = 24691, dwAcceptID = 1773, dwAchiID=10143}, --��̾��
	[106] = {nTryQuestID = 24738, nQuestID = 24739, dwAchiID=10181}, --110����
	[107] = {nTryQuestID = 25347, dwAcceptID = 1789,dwAchiID=10657}, --��ҹ��
	[108] = {nTryQuestID = 25438, dwAcceptID = 1803, dwAchiID=10655}, --�����
	[109] = {nTryQuestID = 25471, dwAcceptID = 1817, dwAchiID=10656}, --�����
	[110] = {nTryQuestID = 25599, nQuestID = 25549, dwAchiID=10804}, --�쳾����
	[111] = {nTryQuestID = 25622, nQuestID = 25623, dwAchiID=10814}, --׷���
	[112] = {nTryQuestID = 25650, nQuestID = 25651, dwAchiID = 10812}, --��������
	[113] = {nTryQuestID = 25704, nQuestID = 25706, dwAchiID=10833}, --�ݴ���
	[114] = {nTryQuestID = 25902, nQuestID = 25783, dwAchiID = 11028}, --Ī�����ġ����˹�
	[115] = {nTryQuestID = 25821, dwAcceptID = 1833, dwAchiID=10994}, --ҹ����
	[116] = {nTryQuestID = 25858, dwAcceptID = 1879, dwAchiID=10995}, --�Һ��
	[117] = {nTryQuestID = 25847, dwAcceptID = 1847, dwAchiID=10996}, --���̲�
	[118] = {nTryQuestID = 25903, nQuestID = 25884, dwAchiID = 11028}, --Ī�����ġ�������
	[119] = {nTryQuestID = 26347, dwAcceptID = 1887, dwAchiID = 11299}, --������
	[120] = {nTryQuestID = 26323, dwAcceptID = 1905, dwAchiID = 11298}, --������
	[121] = {nTryQuestID = 26322, nQuestID = 26307, dwAchiID = 11214}, --���Թ�
	[122] = {nTryQuestID = 26350, dwAcceptID = 1921, dwAchiID = 11297}, --Ԣ����
}
-- ������	: CustomFunction.IfStartAdventureBeforeRandom
-- ��������	: ����������ʼ�������Ը��ʴ����������������
-- �����б�	:  player��nAdventureID������ ui/Scheme/Case/Adventure.txt��
-- ����ֵ	: ��
-- ��ע		:
function CustomFunction.IfStartAdventureBeforeRandom(player, nAdventureID)
	if not player or not nAdventureID or nAdventureID <= 0 then
		return
	end
	if  not tAdventureQuestList[nAdventureID] then
		return
	end
	if  tAdventureQuestList[nAdventureID].nQuestID and tAdventureQuestList[nAdventureID].nQuestID ~= 0 then
		if player.GetQuestPhase(tAdventureQuestList[nAdventureID].nQuestID) == 3 then
			return
		end
	end

	if  tAdventureQuestList[nAdventureID].dwAcceptID and tAdventureQuestList[nAdventureID].dwAcceptID ~= 0 then
		if player.GetAdventureFlag(tAdventureQuestList[nAdventureID].dwAcceptID ) then
			return
		end
	end

	if tAdventureQuestList[nAdventureID].nTryQuestID and tAdventureQuestList[nAdventureID].nTryQuestID ~= 0 then
		print(GetEditorString(12, 8551), nAdventureID)
		player.ForceFinishQuest(tAdventureQuestList[nAdventureID].nTryQuestID)
	else
		print(GetEditorString(12, 8536), nAdventureID)
	end
	--��¼�������Դ���
	if tAdventureQuestList[nAdventureID].dwAchiID and tAdventureQuestList[nAdventureID].dwAchiID ~= 0 then
		player.AddAchievementCount(tAdventureQuestList[nAdventureID].dwAchiID, 1)
	end
end

-- ������� �ɾ�
local tAdventureAchList = {
	[1] = 4605, -- ��ɽ�ĺ�
	[2] = 4606, -- �������
	[3] = 4607, -- ��������
	[4] = 4608, -- �ڰ�·
	[5] = 4608, -- �ڰ�·
	[6] = 4609, -- ������
	[7] = 4610, -- �����Ե
	[8] = 4611, -- ̸�д�ʦ
	[9] = 4611, -- ̸�д�ʦ
	[10] = 5176, -- ��������
	[19] = 5177, -- ������
	[20] = 5178, -- ÷��׮
	[21] = 5179, -- ��������
	[22] = 5187, -- �����޹�
	[31] = 5445, -- ���Ӳ���
	[32] = 5446, -- ��Хɽ��
	[33] = 5447, -- �����輧
	--��������
	[12] = 5198, -- ������
	[13] = 5199, -- ʤ����
	[14] = 5200, -- ����·
	[15] = 5194, -- ���־�
	[16] = 5195, -- ���¸�
	[17] = 5197, -- ׽����
	[18] = 5196, -- ��ͯ��
	[25] = 5329, --ɳ��ҥ
	[26] = 5330, --ʯ�ҵ�
	[27] = 5328, --�����
	[28] = 5441, --������
	[29] = 5442, --������
	[30] = 5443, --����
	[34] = 5448, --������
	[35] = 5659, --������
	[36] = 5658, --��ݸ�
	[37] = 5657, --������
	[40] = 5690, --�澭����¼
	[41] = 5691, --ƽ����Ը
	--[43] = 5691,--������	,ID����
	[46] = 5837, -- ��԰����
	[47] = 6018, --��âչ
	[48] = 6019, --�����
	[49] = 6020, --��Ů��
	[50] = 5997,
	[54] = 6035, --�ͽ�Ů
	[55] = 6032, --һ���
	[56] = 6034, --�����
	[57] = 6033, --��ѩ��
	[58] = 6029, --�̻�Ϸ����
	[59] = 6030, --�̻�Ϸ����
	[60] = 6028, --�̻�Ϸ����
	[61] = 6031, --�̻�Ϸ����
	[62] = 6188, --�鰲־����
	[63] = 6187, --�鰲־����
	[64] = 6189, --�鰲־��־
	[65] = 6208, --��������ͷɱ
	[66] = 6271, --�ò���
	[67] = 6695, --̫�е�
	[68] = 6696, --�ر�ͼ
	[69] = 6697, --�ͽ���
	[70] = 7103, --��ˮ��
	[71] = 7102, --������
	[72] = 7104, --�׺���
	[73] = 7445, --Ե���ᡤ��
	[74] = 7446, --Ե���ᡤ��
	[75] = 7447, --����¼
	[76] = 7494, --������
	[77] = 7797, --¶԰��
	[78] = 7874, --�ý���
	[79] = 7873, --������
	[80] = 7798, --Ḭ̄��
	[81] = 7799, --�����
	[82] = 7890, --Ȱѧ��
	[83] = 7891, --�����⹳
	[85] = 9022, --������
	[86] = 9023, --�����
	[87] = 9024, --������
	[88] = 9110, --���Ї�;
	[89] = 9145, --һ֦��
	[90] = 9307, --�������
	[91] = 9146, --�����
	[92] = 9147, --׽����
	[93] = 9442, --Ѱè��
	[94] = 9593, --����л�
	[95] = 9680, --ͯ��־
	[96] = 9681, --�����
	[97] = 9682, --������
	[98] = 9757, --������
	[99] = 9732, --�����ġ����˹�
	[100] = 9732, --�����ġ�������
	[101] = 10034, --��������
	[102] = 10138, --ͯ��־
	[103] = 10139, --�ĺ���
	[104] = 10148, --���鵱��
	[105] = 10140, --��̾��
	[106] = 10182, --ǧ����
	[107] = 10653, --��ҹ��
	[108] = 10652, --�����
	[109] = 10654, --�����
	[110] = 10803, --�쳾����
	[111] = 10813, --׷���
	[112] = 10811, --��������
	[113] = 10832, --�ݴ���
	[114] = 11027, --Ī�����ġ����˹�
	[115] = 10991, --ҹ����
	[116] = 10992, --�Һ��
	[117] = 10993, --���̲�
	[118] = 11027, --Ī�����ġ�������
	[119] = 11296, --������
	[120] = 11295, --������
	[121] = 11213, --���Թ�
	[122] = 11294, --Ԣ����
}

local tAdventureRewardItemList = {
	[70] = {
		{8, 22562, 1 },
	}, --��ˮ��
	[72] = {
		{8, 22561, 1},
	}, --�׺���
	[85] = {
		{8, 27932, 1}
	}, --������
	[86] = {
		{8, 27933, 1}
	}, --�����
	[87] = {
		{8, 27935, 1}
	}, --������
	[89] = {
		{8, 27947, 1}
	}, --һ֦��
	[91] = {
		{8, 27946, 1}
	}, --�����
	[92] = {
		{8, 27948, 1}
	}, --׽����
	[95] = {
		{8, 27957, 1}
	}, --ͯ��־
	[96] = {
		{8, 27956, 1}
	},--�����
	[97] = {
		{8, 27958, 1}
	}, -- ������
	[102] = {
		{8, 27987, 1}
	},--�ȸ��
	[103] = {
		{8, 27986, 1}
	}, -- �ĺ���
	[105] = {
		{8, 27985, 1}
	}, -- ��̾��
	[107] = {
		{8, 28003, 1}
	},--��ҹ��
	[108] = {
		{8, 28001, 1}
	},-- �����
	[109] = {
		{8, 28002, 1}
	}, -- �����
	[115] = {
		{8, 35944, 1}
	}, --ҹ����
	[116] = {
		{8, 35945, 1}
	},--�Һ��
	[117] = {
		{8, 35946, 1}
	}, -- ���̲�
	[119] = {
		{8, 35962, 1}
	}, -- ������
	[120] = {
		{8, 35961, 1}
	}, --������
	[122] = {
		{8, 35963, 1}
	}, --Ԣ����
}

-- ������	: CustomFunction.GetAdventureAch
-- ��������	: ���ĳ�������߶�Ӧ����ɳɾ�
-- �����б�	: nAdventureID������ ui/Scheme/Case/Adventure.txt��
-- ����ֵ	: nAchievementID
-- ��ע		:
function CustomFunction.GetAdventureAch(nAdventureID)
	return tAdventureAchList[nAdventureID] or 0
end

-- ������	: CustomFunction.FinishAdventure
-- ��������	: ���ĳ��������
-- �����б�	:  player��nAdventureID������ ui/Scheme/Case/Adventure.txt��
-- ����ֵ	: ��
-- ��ע		:
function CustomFunction.FinishAdventure(player, nAdventureID)
	if not player or not nAdventureID or nAdventureID <= 0 then
		return
	end
	player.SetCustomUnsigned2(387, 0)
	player.SetCustomUnsigned4(383, 0)
	RemoteCallToClient(player.dwID, "OpenAdventure", nAdventureID, true)

	if tAdventureAchList[nAdventureID] then
		player.AddAchievementCount(tAdventureAchList[nAdventureID], 1)
	end

	if tAdventureRewardItemList[nAdventureID] then
		local tAItem = tAdventureRewardItemList[nAdventureID]
		local nNum = player.GetFreeRoomSize()
		if nNum < #tAItem then
			player.SendSystemMessage(GetEditorString(14, 9034))
			RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_REWARD_GREEN", GetEditorString(14, 9035), 5)
			local szMail = player.szName .. GetEditorString(11, 3302) ..
			GetEditorString(14, 9036)
			SendSystemMail(GetEditorString(14, 9037), player.szName, GetEditorString(7, 7057), szMail, 0, tAItem)
		else
			for i = 1, #tAItem do
				player.AddItem(tAItem[i][1], tAItem[i][2], tAItem[i][3])
			end
		end
	end

	for i = 0, 7 do
		player.SetCustomBitValue(45, i, false)
	end

	player.DelBuff(9186, 1)	--ɾ������CD BUFF����ֹ��Щ�������̣������¸�����
end

--[[
-- ������	: CustomFunction.StartAdventure
-- ��������	: ����ĳ��������
-- �����б�	:  player��nAdventureID������ ui/Scheme/Case/Adventure.txt.
-- ����ֵ	: ��
-- ��ע		:
function CustomFunction.StartAdventure(player, nAdventureID)
	if not player or not nAdventureID or nAdventureID <= 0 then
		return
	end
	player.SetCustomUnsigned2(383, nAdventureID)
	RemoteCallToClient(player.dwID, "OpenAdventure", nAdventureID, false)
end
--]]

-- ������	: CustomFunction.CheckMapForRepresentApply
-- ��������	: �����ر��֣�����ҹĻ�Ǻӣ��ܷ��ڵ�ǰ��ͼչʾ
-- �����б�	: player
-- ����ֵ	: true or false
-- ��ע		: �������µĵ�ͼ��Ҫ���⴦��������ֱ�Ӵ����OK
function CustomFunction.CheckMapForRepresentApply(scene)
	if (scene.nType == MAP_TYPE.DUNGEON and scene.dwMapID ~= 246 and scene.dwMapID ~= 258 and scene.dwMapID ~= 261 and scene.dwMapID ~= 274) or scene.nType == MAP_TYPE.BATTLE_FIELD or scene.dwMapID == 25 or scene.dwMapID == 27 then
		return false
	end
	--����С�ݵ��ڼ�
	local npcZk1 = scene.GetNpcByNickName("CastleFight" .. scene.dwMapID .. 1)
	local npcZk2 = scene.GetNpcByNickName("CastleFight" .. scene.dwMapID .. 2)
	local bFightCastle1 = false
	local bFightCastle2 = false
	if npcZk1 and npcZk1.GetCustomBoolean(5) then
		bFightCastle1 = true
	end
	if npcZk2 and npcZk2.GetCustomBoolean(5) then
		bFightCastle2 = true
	end
	if bFightCastle1 or bFightCastle2 then
		return false
	end

	return true
end

-- ������	: CustomFunction.CheckPlayerForRepresentApply
-- ��������	: �����ҵ�ǰ״̬�ܷ�ʹ����ر��֣�����ҹĻ�Ǻӣ�
-- �����б�	: player
-- ����ֵ	: true or false
-- ��ע		:
function CustomFunction.CheckPlayerForRepresentApply(player)
	if player.dwIdentityVisiableID ~= 0 then
		player.SendSystemMessage(GetEditorString(10, 9476))
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", GetEditorString(10, 9477), 4)
		return false
	end
	return true
end

-- ������	: CustomFunction.GetExtChangedBite
-- ��������	: ���ݴ������չ��ֵ�ı仯�Լ�ռ��λ�ĳ��ȼ������ĸ�λ��д��
-- �����б�	: player, tBitChangedList��
-- ����ֵ	: nChangedBite
-- ��ע		: ֻ֧�ֵ�����չ������λ��ռ�ó�����һ�������
function CustomFunction.GetExtChangedBite(playplayer, nLastValue, nCurrentValueer)
	local nValueChanged = nCurrentValue - nLastValue
	if nValueChanged < 1 then
		return nil
	end

	local nBitChanged = 0
	if nValueChanged > 1 then
		while(nTemp > 1) do	--����䶯��bitλ��ֻ������0��1���������
			nValueChanged = nValueChanged / 2
			nBitChanged = nBitChanged + 1
		end
	end

	if player.dwIdentityVisiableID ~= 0 then
		player.SendSystemMessage(GetEditorString(10, 9476))
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", GetEditorString(10, 9477), 4)
		return false
	end
	return true
end
-- ������	: CustomFunction.IsEXPServer
-- ��������	: �����ǲ������
-- �����б�	:
-- ����ֵ	: һ������ֵ��true��������� false�����������
-- ��ע		: ��������ܲ��ο���ÿ�������ɾ������ʱ�����뼰ʱά������ά���ܿ��ܵ���ˢǮˢ���ϵ��ش�bug��[901,999] ����Ϊ���

function CustomFunction.IsEXPServer()
	local nIndex = GetServerIndex()
	if not nIndex then
		return false
	end
	if nIndex >= 901 and nIndex <= 999 then
		return true
	end
	return false
end

-----------------------------------------
--DLC����������
-----------------------------------------
--MapInfo.tab�� ɸѡ NeedDeleteΪ0  ����  bIsMenPaiDungeon��Ϊ1
local tDLCMapID = {45, 37, 41, 43, 36, 26, 40, 28, 44, 33, 42, 34, 47, 62, 111, 112, 115, 114, 113, 125, 141, 157, 162,
	163, 170, 179, 184, 187, 195, 200, 224, 227, 228, 229, 225, 242, 257, 262, 285, 292, 32, 60, 61, 67, 68, 109, 120, 131, 134, 136, 140,
	160, 164, 175, 177, 182, 191, 192, 220, 221, 240, 241, 263, 264, 283, 284, 298, 299, 341, 347, 364, 368, 426, 452, 356, 355, 357, 359, 343, 406, 432, 482, 518, 559, 573,
	490, 480, 478, 481, 469, 564, 521,-- 69, 70,
	586,636,
}
-- ������	: CustomFunction.IsInDLCMap
-- ��������	: ����Ƿ���DLC���ø���������
-- �����б�	: target
-- ����ֵ	: ����ֵ
-- ��ע		:
function CustomFunction.IsInDLCMap(target)
	local scene = target.GetScene()
	if not scene then
		return false
	end
	for k, v in ipairs(tDLCMapID) do
		if scene.dwMapID == v then
			return true
		end
	end
	return false
end

local tDLCTankLife = {
	[26] = {2772,520000},
	[28] = {3659,520000},
	[32] = {30000,460000},
	[33] = {23289,520000},
	[34] = {3696,520000},
	[36] = {18484,520000},
	[37] = {18484,520000},
	[40] = {25877,520000},
	[41] = {17466,520000},
	[42] = {22180,520000},
	[43] = {21625,520000},
	[44] = {20793,520000},
	[45] = {20332,520000},
	[47] = {36968,520000},
	[60] = {90000,460000},
	[61] = {66666,460000},
	[62] = {34560,520000},
	[67] = {35184,460000},
	[68] = {33862,460000},
	[109] = {49100,460000},
	[111] = {101932,520000},
	[112] = {77838,520000},
	[113] = {90348,520000},
	[114] = {72278,520000},
	[115] = {81545,520000},
	[120] = {51500,460000},
	[125] = {80238,520000},
	[131] = {90000,460000},
	[134] = {51500,460000},
	[136] = {51500,460000},
	[140] = {95000,460000},
	[141] = {92132,520000},
	[157] = {70245,520000},
	[160] = {111500,460000},
	[162] = {167250,520000},
	[163] = {100350,520000},
	[164] = {101333,460000},
	[170] = {117075,520000},
	[175] = {245714,460000},
	[177] = {200000,460000},
	[179] = {149600,520000},
	[182] = {180000,460000},
	[184] = {208000,520000},
	[187] = {235200,520000},
	[191] = {160000,460000},
	[192] = {160000,460000},
	[195] = {264600,520000},
	[200] = {392000,520000},
	[220] = {34057,460000},
	[221] = {34559,460000},
	[224] = {40950,520000},
	[225] = {30420,520000},
	[227] = {42900,520000},
	[228] = {48750,520000},
	[229] = {25350,520000},
	[240] = {15714,460000},
	[241] = {55000,460000},
	[242] = {46800,520000},
	[257] = {52650,520000},
	[262] = {40950,520000},
	[263] = {25385,460000},
	[264] = {50771,460000},
	[283] = {50771,460000},
	[284] = {80771,460000},
	[285] = {56550,520000},
	[292] = {39000,520000},
	[298] = {116875,460000},
	[299] = {107888,460000},
	[341] = {110773,460000},
	[347] = {110773,460000},
	[364] = {105000,460000},
	[368] = {105000,460000},
	[426] = {110000,460000},
	[452] = {110000,460000},
	[356] = {105000,520000},
	[355] = {105000,520000},
	[357] = {105000,520000},
	[359] = {105000,520000},
	[343] = {105000,520000},
	[406] = {105000,520000},
	[432] = {105000,520000},
	[482] = {230000,460000},
	[518] = {270000,460000},
	[559] = {280000,460000},
	[573] = {280000,460000},
	[490] = {280000,520000},
	[480] = {280000,520000},
	[478] = {280000,520000},
	[481] = {280000,520000},
	[469] = {280000,520000},
	[564] = {280000,520000},
	[521] = {280000,520000},
	[586] = {385000,460000},
	[636] = {410000,460000},
}
local tDLCDpsLife = {
	[26] = {1264,370000},
	[28] = {1668,370000},
	[32] = {14285,330000},
	[33] = {10623,370000},
	[34] = {1686,370000},
	[36] = {8432,370000},
	[37] = {7588,370000},
	[40] = {11804,370000},
	[41] = {7967,370000},
	[42] = {10118,370000},
	[43] = {10961,370000},
	[44] = {9485,370000},
	[45] = {9275,370000},
	[47] = {16864,370000},
	[60] = {57103,330000},
	[61] = {13000,330000},
	[62] = {14602,370000},
	[67] = {27777,330000},
	[68] = {20833,330000},
	[109] = {25000,330000},
	[111] = {47850,370000},
	[112] = {36540,370000},
	[113] = {42412,370000},
	[114] = {33930,370000},
	[115] = {38280,370000},
	[120] = {25000,330000},
	[125] = {36811,370000},
	[131] = {57103,330000},
	[134] = {34501,330000},
	[136] = {30562,330000},
	[140] = {39000,330000},
	[141] = {41400,370000},
	[157] = {37800,370000},
	[160] = {60000,330000},
	[162] = {90000,370000},
	[163] = {54000,370000},
	[164] = {60000,330000},
	[170] = {63000,370000},
	[175] = {124286,330000},
	[177] = {100000,330000},
	[179] = {70400,370000},
	[182] = {80000,330000},
	[184] = {104000,370000},
	[187] = {134400,370000},
	[191] = {90000,330000},
	[192] = {90000,330000},
	[195] = {151200,370000},
	[200] = {252000,370000},
	[220] = {25000,330000},
	[221] = {25000,330000},
	[224] = {22050,370000},
	[225] = {16380,370000},
	[227] = {23100,370000},
	[228] = {26250,370000},
	[229] = {13650,370000},
	[240] = {17333,330000},
	[241] = {26000,330000},
	[242] = {25200,370000},
	[257] = {28350,370000},
	[262] = {22050,370000},
	[263] = {20666,330000},
	[264] = {24800,330000},
	[283] = {24800,330000},
	[284] = {38153,330000},
	[285] = {30450,370000},
	[292] = {21000,370000},
	[298] = {61285,330000},
	[299] = {58456,330000},
	[341] = {57230,330000},
	[347] = {57230,330000},
	[364] = {62000,330000},
	[368] = {62000,330000},
	[426] = {65000,330000},
	[452] = {70000,330000},
	[356] = {60000,370000},
	[355] = {60000,370000},
	[357] = {60000,370000},
	[359] = {60000,370000},
	[343] = {60000,370000},
	[406] = {60000,370000},
	[432] = {60000,370000},
	[482] = {160000,330000},
	[518] = {175000,330000},
	[559] = {190000,330000},
	[573] = {190000,330000},
	[490] = {190000,370000},
	[480] = {190000,370000},
	[478] = {190000,370000},
	[481] = {190000,370000},
	[469] = {190000,370000},
	[564] = {190000,370000},
	[521] = {190000, 370000},
	[586] = {270000,330000},
	[636] = {290000,330000},
}
local tDLCNpcLife = {
	-- [NpcID] = OldLife
	[16436] = 17335,
	[43113] = 4781449,
	[43112] = 4781449,
	[16770] = 45000,
	[23332] = 17250000,
	[7448] = 460000,
	[37077] = 3017000,
	[18916] = 1000,
	[16381] = 40000,
	[16327] = 4725000,
	[36864] = 48000000,
	[26787] = 480000,
}
-- ������	: CustomFunction.GetDLCMapTargetLifePercent
-- ��������	: ��ԭѪ��ֵת��ΪDLC��Ѫ��ֵ
-- �����б�	: target, nOldLife, bTank(��ѡ)
-- ����ֵ	: Ѫ��ֵ
-- ��ע		: ֮��Ҫ�����DLC��������ֵ��0.14
function CustomFunction.GetDLCMapTargetLifePercent(target, nOldLife, bTank)
	local dwMapID = target.GetMapID()
	if not dwMapID then
		return nOldLife
	end
	local bDLC = CustomFunction.IsInDLCMap(target)
	if bDLC then
		if IsPlayer(target.dwID) then
			if bTank and bTank == 1 then
				if tDLCTankLife[dwMapID] then
					return nOldLife / tDLCTankLife[dwMapID][1] * tDLCTankLife[dwMapID][2]
				end
			else
				if tDLCDpsLife[dwMapID] then
					return nOldLife / tDLCDpsLife[dwMapID][1] * tDLCDpsLife[dwMapID][2]
				end
			end
		else
			if tDLCNpcLife[target.dwTemplateID] then
				return nOldLife / tDLCNpcLife[target.dwTemplateID] * target.nMaxLife
			end
			---�ű���ֱ�Ӳ���NPC��nCurrentLife�ĵط����ᾭ���������ת��������ֵ������ת������������NPC����ʷѪ�������LOG�����ҳ���©����ЩNPC��Ϣ�����ֻ��ҳ�������tDLCNpcLife����
			Log("************************************************************************")
			Log(GetEditorString(13, 4886) .. target.dwTemplateID .. "\t" .. target.szName)
			Log("************************************************************************")
			--local filepath = "C:\\DLCNpcList.txt"
			--local file = io.open(filepath, "a")
			--if file then
			--file:write("����DLC��ֵ������©NpcID��\t" .. target.dwTemplateID .. "\t" .. target.szName .. "\n")
			--file:close()
			--end
		end
	else
		return nOldLife
	end
	return nOldLife
end

-- ������	: CustomFunction.GetDLCMapTargetManaPercent
-- ��������	: ��ԭ����ֵת��ΪDLC������ֵ
-- �����б�	: target, nOldMana, bTank(��ѡ)
-- ����ֵ	: ����ֵ
-- ��ע		: ֮��Ҫ�����DLC��������ֵ��0.14
function CustomFunction.GetDLCMapTargetManaPercent(target, nOldMana, bTank)
	local dwMapID = target.GetMapID()
	if not dwMapID then
		return nOldMana
	end
	local bDLC = CustomFunction.IsInDLCMap(target)
	if bDLC then
		if IsPlayer(target.dwID) then
			if bTank and bTank == 1 then
				if tDLCTankLife[dwMapID] then
					return nOldMana / (tDLCTankLife[dwMapID][1] * 0.8) * tDLCTankLife[dwMapID][2]
				end
			else
				if tDLCDpsLife[dwMapID] then
					return nOldMana / (tDLCDpsLife[dwMapID][1] * 0.8) * tDLCDpsLife[dwMapID][2]
				end
			end
		else
			return nOldMana
		end
	else
		return nOldMana
	end
	return nOldMana
end
local tDLCMapIDtoBuff = {
	-- [MapID] = {buffID, buffLevel}
	[14] = {13926, 1},--����Ͽ
	[17] = {13926, 2},--�칤��
	[18] = {13926, 3},--���ε�
	[19] = {13926, 4}, --�����
	[20] = {13926, 5}, --���������
	[46] = {13926, 6},--Ӣ��ս������
	[51] = {13926, 7}, --��ڣ
	[65] = {13926, 8}, --25����ͨ�ֹ�������
	[66] = {13926, 8}, --Ӣ�۳ֹ�������
	[63] = {13926, 9}, --Ӣ�۹��������ż�
	[64] = {13926, 9}, --25����ͨ���������ż�
	[73] = {13926, 10}, --Ӣ��ݶ������ɽ
	[69] = {13926, 11}, --10��Ӣ��ݶ��ʥ��
	[70] = {13926, 11}, --25����ͨݶ��ʥ��
	[72] = {13926, 11},--25��Ӣ��ݶ��ʥ��
	[116] = {13926, 12}, --�ͼ�������
	[71] = {13926, 12}, --������
	[75] = {13926, 13},--�����
	[106] = {13926, 14},--������
	[107] = {13926, 15},--������
	[117] = {13926, 16}, --25��Ӣ����Ԩ��
	[118] = {13926, 16},--25����ͨ��Ԩ��
	[119] = {13926, 16},--10��Ӣ����Ԩ��
	[110] = {13926, 17},--������
	[130] = {13926, 18},--Ӣ��ݶ������
	[123] = {13926, 19},--�ͼ���������
	--[126] = {13926, 20},
	[148] = {13926, 21}, --Ӣ�۳ֹ�����¼
	[133] = {13926, 22}, --25��Ӣ��������
	[138] = {13926, 23},--25��Ӣ�ۻ�ս����
	[155] = {13926, 24},--Ӣ����گ�ʹ�
	[142] = {13926, 25},--�ͼ��������ص�
	[167] = {13926, 26},--һ����
	[171] = {13926, 27},--Ӣ��ս����е��
	[161] = {13926, 28},--���幬
	[165] = {13926, 29},--Ӣ�۴�����
	[169] = {13926, 30},--���뵺
	[176] = {13926, 31},--Ӣ��Ѫս���
	[178] = {13926, 32},--Ӣ�۷�ѩ�����
	[183] = {13926, 33},--Ӣ���ػ���
	[198] = {13926, 34}, --Ӣ��̫ԭ֮ս_ҹ�ع³�
	[205] = {13926, 34}, --��ս̫ԭ֮ս_ҹ�ع³�
	[211] = {13926, 34}, --10����ս̫ԭ֮ս_ҹ�ع³�
	[199] = {13926, 35}, --Ӣ��̫ԭ֮ս_������
	[206] = {13926, 35}, --��ս̫ԭ֮ս_������
	[212] = {13926, 35},--10����ս̫ԭ֮ս_������
	[196] = {13926, 36}, --��ͨ���Ź�֮��
	[222] = {13926, 37}, --��ս貴亣��
	[203] = {13926, 38}, --������
	[204] = {13926, 39}, --��ɽʥȪ
	[209] = {13926, 40}, --�����Ժ
	[218] = {13926, 41},--����ˮ�
	[219] = {13926, 42},--΢ɽ��Ժ
	[231] = {13926, 43},--Ӣ�������й�_����ͥ԰
	[232] = {13926, 43},--��������й�_����ͥ԰
	[234] = {13926, 43}, --10����ս�����й�_����ͥ԰
	[236] = {13926, 43},--25����ս�����й�_����ͥ԰
	[230] = {13926, 44},--Ӣ�������й�_���±�Ժ
	[233] = {13926, 44},--��������й�_���±�Ժ
	[235] = {13926, 44},--10����ս�����й�_���±�Ժ
	[237] = {13926, 44},--25����ս�����й�_���±�Ժ
	[248] = {13926, 45},--Ӣ��������_�۷��
	[250] = {13926, 45},--���������_�۷��
	[249] = {13926, 46}, --Ӣ��������_˫��ͤ
	[251] = {13926, 46}, --���������_˫��ͤ
	[244] = {13926, 47}, --��ս�׵�ˮ��
	[256] = {13926, 48}, --Ϧ�ո�
	[260] = {13926, 48}, --��սϦ�ո�
	[275] = {13926, 49},--��ս���ֺ���
	[271] = {13926, 50},--Ӣ�۷��׵���_�͵���
	[273] = {13926, 50},--�����׵���_�͵���
	[270] = {13926, 51}, --Ӣ�۷��׵���_ǧ�׵�
	[272] = {13926, 51}, --�����׵���_ǧ�׵�
	[286] = {13926, 52}, --Ӣ��������_ս��ɽ
	[288] = {13926, 52}, --���������_ս��ɽ
	[287] = {13926, 53}, --Ӣ��������_��Ȼ��
	[289] = {13926, 53}, --���������_��Ȼ��
	[290] = {13926, 54}, --��ս�����
	[291] = {13926, 55}, --��������
	[295] = {13926, 55}, --��ս��������
	[300] = {13926, 56}, --Ӣ��������_����ǵ
	[323] = {13926, 56}, --���������_����ǵ
	[301] = {13926, 57}, --Ӣ��������_�����
	[324] = {13926, 57}, --���������_�����
	[354] = {13926, 58}, --Ӣ�۱���_��Ѫ·
	[360] = {13926, 58}, --��ս����_��Ѫ·
	[348] = {13926, 59}, --Ӣ�۱���_������
	[349] = {13926, 59}, --��ս����_������
	[365] = {13926, 60}, --Ӣ�۳��麣_��ڤ��
	[366] = {13926, 60}, --��ս���麣_��ڤ��
	[369] = {13926, 61},--Ӣ�۳��麣_���Ѷ�
	[370] = {13926, 61},--��ս���麣_���Ѷ�
	[427] = {13926, 62},--25����ͨ������
	[428] = {13926, 62},--25��Ӣ�۰�����
	[453] = {13926, 63},--25����ͨ����ҹ��
	[454] = {13926, 63}, --25��Ӣ�۷���ҹ��
	[337] = {13926, 64}, --��������
	[339] = {13926, 65}, --������˿��
	[340] = {13926, 66}, --������
	[342] = {13926, 67}, --�ű��
	[358] = {13926, 68}, --��Ԩ��
	[407] = {13926, 69},--��ս������
	[431] = {13926, 70},--���ױ�Ժ
	[483] = {13926, 71},--25����ͨ��Ħ��
	[484] = {13926, 72},--25��Ӣ�۴�Ħ��
	[519] = {13926, 73},--25����ͨ�׵۽���
	[520] = {13926, 74},--25��Ӣ�۰׵۽���
	[560] = {13926, 75},--25����ͨ�������
	[561] = {13926, 76},--25��Ӣ���������
	
	[574] = {13926, 77},--25����ͨ����֮ս
	[575] = {13926, 78},--25��Ӣ�ۺ���֮ս
	[489] = {13926, 79}, --��������
	[479] = {13926, 80}, --�޺���
	[477] = {13926, 81}, --��ͩɽׯ
	[476] = {13926, 82}, --���浺
	[468] = {13926, 83}, --��ڣ����
	[563] = {13926, 84},--���ϱ�Ժ
	[522] = {13926, 85}, --��ս��ˮ��·
	[587] = {13926, 86}, --25����ͨ�����
	[588] = {13926, 86}, --25��Ӣ�������
	[637] = {13926, 87}, --25����ͨ��������
	[638] = {13926, 87}, --25��Ӣ����������

}
-- ������	: CustomFunction.AddDLCMapDefenceBuff
-- ��������	: ��DLC�ľ����������Ϊ��Һͳ��ﲹ����
-- �����б�	: target
-- ����ֵ	: ��
-- ��ע		:
function CustomFunction.AddDLCMapDefenceBuff(target)
	local dwMapID = target.GetMapID()
	if not dwMapID then
		return
	end
	local nDefenceBuffID = 0
	local nDefenceBuffLevel = 0
	--print("DLC����buff��ִ�м���ͼID�Ƿ�ΪDLC")
	if tDLCMapIDtoBuff[dwMapID] then
		--print("DLC����buff���ҵ���ӦBuff" .. tDLCMapIDtoBuff[k][1] .. "�ȼ�" .. tDLCMapIDtoBuff[k][2])
		nDefenceBuffID = tDLCMapIDtoBuff[dwMapID][1]
		nDefenceBuffLevel = tDLCMapIDtoBuff[dwMapID][2]
	end
	if nDefenceBuffID == 0 then
		target.DelMultiGroupBuffByID(13926)
	else
		target.AddBuff(target.dwID, target.nLevel, nDefenceBuffID, nDefenceBuffLevel)
	end
end
-- ������	: CustomFunction.DelDLCMapDefenceBuff
-- ��������	: ɾ��Ŀ���DLC�����ϸ�����δ������������BUFF
-- �����б�	: target
-- ����ֵ	: ��
-- ��ע		:
function CustomFunction.DelDLCMapDefenceBuff(target)
	if target then
		return
	end

	local scene = target.GetScene()
	if not scene then
		return
	end

	target.DelMultiGroupBuffByID(13926)
end

t10DLCWindowID = {15, 16, 18, 20, 22, 24, 27, 28, 29, 42, 43, 44, 45, 48, 50, 54, 56, 58, 59, 179, 218, 219, 252, 265, 267, 274, 275, 287, 296, 302, 303, 304, 309, 312, 319, 323, 327, 328, 329, 335, 339}
t5DLCWindowID = {10, 13, 14, 17, 19, 21, 23, 25, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 46, 47, 49, 51, 52, 53, 54, 55, 56, 57, 215, 224, 241, 242, 243, 244, 246, 248, 250, 251, 252, 253, 254, 255, 271, 286, 291, 305, 316, 330, 333, 334}
-- ������	: CustomFunction.OpenSwitchMapWindowDLCtest
-- ��������	: 201810���������10��RAID���
-- �����б�	: player, dwWindowID, TargetType, dwTargetID
-- ����ֵ	: ��
-- ��ע		:
function CustomFunction.OpenSwitchMapWindowDLCtest(player, dwWindowID, TargetType, dwTargetID)
	local nTime = GetCurrentTime()
	local nStartTime = DateToTime(2018, 10, 29, 0, 0, 0)
	local nEndTime = DateToTime(2018, 11, 29, 0, 0, 0)
	local b10DLC = false
	local b5DLC = false
	for i = 1, #t10DLCWindowID do
		if dwWindowID == t10DLCWindowID[i] then
			b10DLC = true
		end
	end
	for i = 1, #t5DLCWindowID do
		if dwWindowID == t5DLCWindowID[i] then
			b5DLC = true
		end
	end

	if CustomFunction.IsEXPServer() then
		if b10DLC then
			if nTime < nStartTime then
				if dwWindowID == 179 then
					player.OpenSwitchMapWindow(365)
				else
					player.SendSystemMessage(GetEditorString(13, 6478))
				end
			elseif nTime <= nEndTime then
				--ͬʱ����5��10�˵ı�������ֻ��5�˱��Ĵ���
				if dwWindowID == 54 then
					player.OpenSwitchMapWindow(363)
				elseif dwWindowID == 56 then
					player.OpenSwitchMapWindow(362)
				elseif dwWindowID == 252 then
					player.OpenSwitchMapWindow(364)
				elseif dwWindowID == 179 then
					player.OpenSwitchMapWindow(365)
				else
					player.SendSystemMessage(GetEditorString(13, 6479))
				end
			else
				player.OpenSwitchMapWindow(dwWindowID)
			end
		elseif b5DLC then
			if nTime < nStartTime then
				player.SendSystemMessage(GetEditorString(13, 6480))
			else
				player.OpenSwitchMapWindow(dwWindowID)
			end
		else
			player.OpenSwitchMapWindow(dwWindowID)
		end
	else
		if TargetType and dwTargetID then
			player.OpenSwitchMapWindow(dwWindowID, TargetType, dwTargetID)
		else
			player.OpenSwitchMapWindow(dwWindowID)
		end
	end
end
local tOldDungeonID = {
	[46] = true,
	[65] = true,
	[66] = true,
	[63] = true,
	[64] = true,
	[73] = true,
	[69] = true,
	[70] = true,
	[72] = true,
	[71] = true,
	[75] = true,
	[106] = true,
	[107] = true,
	[117] = true,
	[118] = true,
	[119] = true,
	[110] = true,
	[130] = true,
	[148] = true,
	[133] = true,
	[138] = true,
	[155] = true,
	[167] = true,
	[171] = true,
	[161] = true,
	[165] = true,
	[176] = true,
	[178] = true,
	[183] = true,
	[198] = true,
	[205] = true,
	[211] = true,
	[199] = true,
	[206] = true,
	[212] = true,
	[222] = true,
	[203] = true,
	[204] = true,
	[209] = true,
	[218] = true,
	[231] = true,
	[234] = true,
	[236] = true,
	[230] = true,
	[235] = true,
	[237] = true,
	[248] = true,
	[249] = true,
	[244] = true,
	[260] = true,
	[275] = true,
	[271] = true,
	[270] = true,
	[286] = true,
	[287] = true,
	[290] = true,
	[291] = true,
	[295] = true,
	[300] = true,
	[301] = true,
	[337] = true,
	[339] = true,
	[340] = true,
	[358] = true,
	[407] = true,
	[354] = true,
	[360] = true,
	[348] = true,
	[349] = true,
	[365] = true,
	[366] = true,
	[369] = true,
	[370] = true,
	[427] = true,
	[428] = true,
	[453] = true,
	[454] = true,
	[468] = true,
	[477] = true,
	[479] = true,
	[483] = true,
	[484] = true,
	[489] = true,
	[519] = true,
	[520] = true,
	[522] = true,
	[560] = true,
	[561] = true,
	[574] = true,
	[575] = true,
}
-- ������	: CustomFunction.SwitchMapOldDungeon
-- ��������	: ������ɴ������ǰ���ؾ�����ʱ�ص�����ɴ�
-- �����б�	: player, dwMapID, nX, nY, nZ
-- ����ֵ	: ��
-- ��ע		:
function CustomFunction.SwitchMapOldDungeon(player, dwMapID, nX, nY, nZ)
	local scene = player.GetScene()
	if not scene then
		return
	end
	if tOldDungeonID[scene.dwMapID] then
		player.SwitchToLastEntry()
	else
		player.SwitchMap(dwMapID, nX, nY, nZ)
	end
end

-- ������	: CustomFunction.GetSecondToTomorrow7()
-- ��������	: ������ڵ�������7����������������������賿0:00~6:59����ô�ǵ�����07:00��
-- �����б�	:
-- ����ֵ	: ʣ�������
function CustomFunction.GetSecondToTomorrow7()
	local nCurTime = GetCurrentTime()
	local nCurrentDate = TimeToDate(nCurTime)
	local nToday7 = DateToTime(nCurrentDate.year, nCurrentDate.month, nCurrentDate.day, 7, 0, 0)
	local nTommorrow7 = 1
	if GetCurrentHour() < 7 then
		nTommorrow7 = nToday7
	else
		nTommorrow7 = nToday7 + 86400--����һ�������
	end
	return nTommorrow7 - nCurTime	
end

-- ������	: CustomFunction.GetMinuToTomorrow7()
-- ��������	: ������ڵ�������7�������õ�ʣ����ӣ�����������賿0:00~6:59����ô�ǵ�����07:00��
-- �����б�	:
-- ����ֵ	: ʣ����ٷ��ӣ���Ϊ������Ĩ�㲻�Ǻܾ�ȷ������ȡ�����������෵��һ���ӡ���Ҫ��ȷ������
function CustomFunction.GetMinuToTomorrow7()
	local nHour = GetCurrentHour()
	local nMinu = GetCurrentMinute()
	local nLeftHour = 31 - nHour - 1	--�ҽ��ڶ����7����Ϊ31:00���� -1����ΪҪ�������
	if nLeftHour >= 24 then	--�賿0:00֮��06:59��ʱ��Ҫ�����24
		nLeftHour = nLeftHour - 24
	end
	local nLeftMinu = 60 - nMinu	--����1Сʱ�ķ��ӣ�����
	return nLeftHour * 60 + nLeftMinu	--��ʤbuffһ����һ����Сʱת��Ϊbuff����������ս������12��ſ�����������Ҳ����ν	
end

-- ������	: CustomFunction.GetMinuToNextWeek7()
-- ��������	: ������ڵ�����һ����7�������õ�ʣ����ӣ�����������賿0:00~6:59����ô�ǵ�����07:00��
-- �����б�	:
-- ����ֵ	: ʣ����ٷ��ӣ���Ϊ������Ĩ�㲻�Ǻܾ�ȷ������ȡ�����������෵��һ���ӡ���Ҫ��ȷ������
function CustomFunction.GetMinuToNextWeek7()
	local nTime = GetCurrentTime()
	local tTime = TimeToDate(nTime)
	local nPassTime = 0
	local nSevenTime = DateToTime(tTime.year, tTime.month, tTime.day, 7, 0, 0)
	if tTime.weekday == 0 then
		nPassTime = 24 * 3600 + nSevenTime - nTime
	elseif tTime.weekday == 1 and tTime.hour < 7 then
		nPassTime = nSevenTime - nTime
	else
		nPassTime = (8 - tTime.weekday) * 24 * 3600 + nSevenTime - nTime
	end

	return math.ceil(nPassTime / 60)
end

-- ������	: CustomFunction.GetValueByTenBit()
-- ��������	: ���ĳ�����ֵ�N��ʮ����λ�ϵ�ֵ����5123��ȡ����λ�ϵ�ֵΪ5
-- �����б�	: (value, bit) ֵ���ڼ�λ
-- ����ֵ	: ����0~9
-- ��ע		: CustomFunction.GetValueByTenBit(5123, 4)����5123��ȡ����λ�ϵ�ֵΪ5
function CustomFunction.GetValueByTenBit(value, bit)
	if bit <= 0 then
		return
	end
	return  math.floor((value % (10 ^ bit)) / (10 ^ (bit - 1)))
end

-- ������	: CustomFunction.SetValueByTenBit()
-- ��������	: ����ĳ�����ֵ�N��ʮ����λ�ϵ�ֵ����5123�����õ���λ�ϵ�ֵΪ6�����Ϊ6123
-- �����б�	: (value, bit, newBitValue) ֵ���ڼ�λ��������ֵ
-- ����ֵ	: ���ú����ֵ
-- ��ע		: CustomFunction.SetValueByTenBit(5123, 6)����5123��ȡ����λ�ϵ�ֵΪ5
function CustomFunction.SetValueByTenBit(value, bit, newBitValue)
	if bit <= 0 or newBitValue < 0 or newBitValue > 9 then
		return
	end
	local nOldValue = CustomFunction.GetValueByTenBit(value, bit)
	return value + (newBitValue - nOldValue) * 10 ^ (bit - 1)
end

-- ������	: CustomFunction.GetPointToLineLenght()
-- ��������	: 2D�ռ䣬��ȡĳ���㵽ĳ��ֱ�ߵ���̾��룬һ������������ԭ·��ƫ�ƶ��پ��룬����С��ƫ��Ѳ��·��
-- �����б�	: (xPoint, yPoint, xLine1, yLine1, xLine2, yLine2) �����ֱ꣬�����������������
-- ����ֵ	: ���ú����ֵ
-- ��ע		: CustomFunction.SetValueByTenBit(5123, 6)����5123��ȡ����λ�ϵ�ֵΪ5
function CustomFunction.GetPointToLineLenght(xPoint, yPoint, xLine1, yLine1, xLine2, yLine2)
	if xPoint and yPoint and xLine1 and yLine1 and xLine2 and yLine2 then
		--���躯����ʽΪAx + By + C = 0������ú�����ʽ
		local nA_agr = yLine2 - yLine1
		local nB_agr = xLine1 - xLine2
		local nC_agr = xLine2 * yLine1 - xLine1 * yLine2
		--�㵽ֱ�ߵĹ�ʽΪ d=|Ax+By+C|/ sqrt(A*A+B*B)
		return math.abs(nA_agr * xPoint + nB_agr * yPoint + nC_agr) / math.sqrt(nA_agr * nA_agr + nB_agr * nB_agr)
	else
		return 0
	end
end

-- ������	: CustomFunction.GetPoint2PointDis()
-- ��������	: 2D�ռ䣬��ȡ����֮��ľ���
-- �����б�	: (x1, y1, x2, y2) ������
-- ����ֵ	: ��(��)
-- ��ע		: ����ʹ�� GetDistanceSq(x1, y1, z1, x2, y2, z2) ���Ż�,z��0����
function CustomFunction.GetPoint2PointDis(x1, y1, x2, y2)
	local Npc_2D_X = x1 - x2
	local Npc_2D_Y = y1 - y2
	local nDis2D = math.sqrt(Npc_2D_X ^ 2 + Npc_2D_Y ^ 2) / 64
	return nDis2D
end

-- ������	: CustomFunction.GetPoint2PointDis2()
-- ��������	: 3D�ռ䣬��ȡ����֮��ľ����ƽ��
-- �����б�	: (x1, y1, z1, x2, y2, z2) ������
-- ����ֵ	: ��λ�����ص��ƽ��  (64��=1��(��))
-- ��ע		: xyz��Ϊ�ͻ���ֱ��ȡ��������
function CustomFunction.GetPoint2PointDis2(x1, y1, z1, x2, y2, z2)
	return GetDistanceSq(x1, y1, z1, x2, y2, z2)
end

-- ������	: CustomFunction.SetCurFunitureInfo(player, nModuleID, nLandIndex, nObjectID, nObjectPos)
-- ��������	: ��ʱ�洢��ǰ�����ļҾ���Ϣ���ƶ�����ͼ�������߻�����
-- �����б�	: player
-- ����ֵ	: ��
-- ��ע		:
function CustomFunction.SetCurFunitureInfo(player, nModuleID, nLandIndex, nObjectID, nObjectPos)
	local nBuffLandPosID = 17160 --��nLandIndex*100+nObjectPos
	local nBuffModuleID = 17161	--��nModuleID
	local nBuffObjectID = 17162	--nObjectID

	if not player.IsHaveBuff(nBuffLandPosID, 1) then
		player.AddBuff(0, 99, nBuffLandPosID, 1)
	end
	if not player.IsHaveBuff(nBuffModuleID, 1) then
		player.AddBuff(0, 99, nBuffModuleID, 1)
	end
	if not player.IsHaveBuff(nBuffObjectID, 1) then
		player.AddBuff(0, 99, nBuffObjectID, 1)
	end
	local buffLandPosID = player.GetBuff(nBuffLandPosID, 1)
	if buffLandPosID then
		buffLandPosID.nCustomValue = nLandIndex * 100 + nObjectPos
	end
	local buffModuleID = player.GetBuff(nBuffModuleID, 1)
	if buffModuleID then
		buffModuleID.nCustomValue = nModuleID
	end
	local buffObjectID = player.GetBuff(nBuffObjectID, 1)
	if buffObjectID then
		buffObjectID.nCustomValue = nObjectID
	end
end

-- ������	: CustomFunction.GetCurFunitureInfo(player)
-- ��������	: ��ȡ��ǰ�����ļҾ���Ϣ
-- �����б�	: player
-- ����ֵ	: nModuleID, nLandIndex, nObjectID, nObjectPos
-- ��ע		:
function CustomFunction.GetCurFunitureInfo(player)
	local nBuffLandPosID = 17160 --��nLandIndex*100+nObjectPos
	local nBuffModuleID = 17161	--��nModuleID
	local nBuffObjectID = 17162	--nObjectID
	
	local nModuleID = 0
	local nLandIndex = 0
	local nObjectID = 0
	local nObjectPos = 0
	local bMiss = false

	--ȡlandIndex��pos
	local buffLandPosID = player.GetBuff(nBuffLandPosID, 1)
	if buffLandPosID then
		nObjectPos = buffLandPosID.nCustomValue % 100
		nLandIndex = (buffLandPosID.nCustomValue - nObjectPos) / 100
	else
		bMiss = true
	end
	--ȡModuleID
	local buffModuleID = player.GetBuff(nBuffModuleID, 1)
	if buffModuleID then
		nModuleID = buffModuleID.nCustomValue
	else
		bMiss = true
	end
	--ȡObjectID
	local buffObjectID = player.GetBuff(nBuffObjectID, 1)
	if buffObjectID then
		nObjectID = buffObjectID.nCustomValue
	else
		bMiss = true
	end

	if bMiss then
		player.SendSystemMessage(GetEditorString(16, 6342))
	end
	print("GetCurFunitureInfo", nModuleID, nLandIndex, nObjectID, nObjectPos)
	return nModuleID, nLandIndex, nObjectID, nObjectPos
end

-- ������	: CustomFunction.SetSceneFilter(player, dwMapID, nBitIndex, bVisible)
-- ��������	: ���ó����ɼ�������
-- �����б�	: player, dwMapID, nBitIndex, bVisible
-- ����ֵ	: ��
-- ��ע		: �����ɫ���ڳ���dwMapID���������������Ч����ֹ����
function CustomFunction.SetSceneFilter(player, dwMapID, nBitIndex, bVisible)
	if not player.HaveSceneFilter() then
		return
	end
	local nCurrentMapID = player.GetMapID()
	if not nCurrentMapID then
		return
	end
	if nCurrentMapID ~= dwMapID then
		return
	end
	player.SetSceneFilter(nBitIndex, bVisible)
	return
end

-- ������	: CustomFunction.SetSceneFilterByTable(player, dwMapID, tFilterInfo)
-- ��������	: ����table���ø��������ɼ�������
-- �����б�	: player, dwMapID, tFilterInfo
-- ����ֵ	: ��
-- ��ע		: �����ɫ���ڳ���dwMapID���������������Ч����ֹ����tFilterInfo��ʽ��local tFilterInfo = {{nBitIndex, bVisible},{nBitIndex, bVisible}, ...}
function CustomFunction.SetSceneFilterByTable(player, dwMapID, tFilterInfo)
	if not player.HaveSceneFilter() then
		return
	end
	local nCurrentMapID = player.GetMapID()
	if not nCurrentMapID then
		return
	end
	if nCurrentMapID ~= dwMapID then
		return
	end
	for i = 1, #tFilterInfo do
		player.SetSceneFilter(tFilterInfo[i][1], tFilterInfo[i][2])
	end
	return
end

tAsuraMapId = {517}
-- ������	: CustomFunction.IsAsuraMapID(dwMapID)
-- ��������	: �ж��Ƿ�Ϊ������ս��ͼ
-- �����б�	: dwMapID
-- ����ֵ	: bIsAsura
-- ��ע		: 
function CustomFunction.IsAsuraMapID(dwMapID)
	local bIsAsura = false
	for _, v in pairs(tAsuraMapId) do
		if dwMapID == v then
			bIsAsura = true
			break
		end
	end
	return bIsAsura
end