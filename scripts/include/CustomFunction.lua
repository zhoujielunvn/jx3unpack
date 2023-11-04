---------------------------------------------------------------------->
-- 脚本名称:	scripts/Include/CustomFunction.lua
-- 更新时间:	2022/10/21 16:33:22
-- 更新用户:	dingwenyue
-- 脚本说明:	
----------------------------------------------------------------------<
function AppendCustomFunctionToGlobal()
	_G.CustomFunction = CustomFunction
end
CustomFunction = CustomFunction or {}

-- 函数名	: CustomFunction.Jx3Log
-- 函数描述	: 当DEBUG和DEBUG_LEVEL值相等时print出…内容
-- 参数列表	: DEBUG, DEBUG_LEVEL, ...
-- 返回值	: 无
-- 备注		: 调试时将常量DEBUG == DEBUG_LEVEL,正式提交时不相等即可
function CustomFunction.Jx3Log(DEBUG, DEBUG_LEVEL, ... )
	if DEBUG and DEBUG == DEBUG_LEVEL then
		print( ... )
	end
end
-- 函数名	: CustomFunction.CheckMapTraffic
-- 函数描述	: 检查NPC是否可以有交通功能
-- 参数列表	: npc, player
-- 返回值	: 布尔值
-- 备注		:
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
-- 函数名	: CustomFunction.MapTrafficByID
-- 函数描述	: 场景内部交通NPC通用函数，通过ID区分
-- 参数列表	: npc, player, tNPC, dwMapID, dwWorldNpcID, nNodeID
-- 返回值	: 无
-- 备注		:local tNPC = {[2136] = 1, [2137] = 2,}
--			dwMapID（场景ID）, dwWorldNpcID（世界交通NPCID）, nNodeID（交通ID）
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
-- 函数名	: CustomFunction.MapTrafficByName
-- 函数描述	: 场景内部交通NPC通用函数，通过NickName区分
-- 参数列表	: npc, player, tNPC, dwMapID, szWorldNpcName, nNodeID
-- 返回值	: 无
-- 备注		:local tNPC = {["nickName1"] = 1, ["nickName2"] = 2,}
--			dwMapID（场景ID）, szWorldNpcName（世界交通NPC别名）, nNodeID（交通ID）
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
-- 函数名	: CustomFunction.FindTarget
-- 函数描述	: 查找对象的当前目标（npc或者player），可以指定类型。
-- 参数列表	: npc, nType
-- 返回值	: 目标对象
-- 备注		:类型为TARGET.NPC并且目标是npc对象时返回，否则为false
--			类型为TARGET.PLAYER并且目标是player对象时返回，否则为false
--			类型为其他值时返回当前目标对象，不论是npc还是player，没有目标则反回false。
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
-- 函数名	: CustomFunction.GetSpace2D
-- 函数描述	: 计算两个对象之间的2D距离。
-- 参数列表	: npc, player
-- 返回值	: 距离(单位点,64点为1尺||米)
-- 备注		:可以是npc,player,doodad或者{nX = 1, nY = 1, nZ = 1}的Table
function CustomFunction.GetSpace2D(npc, player)
	local x, y = npc.nX, npc.nY
	local TargetX, TargetY = player.nX, player.nY

	local nDeltaX = TargetX - x
	local nDeltaY = TargetY - y

	return math.sqrt(nDeltaX * nDeltaX + nDeltaY * nDeltaY)
end
-- 函数名	: CustomFunction.GetDistance2D
-- 函数描述	: 计算两个对象之间的2D距离。
-- 参数列表	: npc, player
-- 返回值	: 距离(单位点,64点为1尺||米)
-- 备注		:可以是npc,player,doodad或者{nX = 1, nY = 1, nZ = 1}的Table
CustomFunction.GetDistance2D = CustomFunction.GetSpace2D
-- 函数名	: CustomFunction.GetSpace3D
-- 函数描述	: 计算两个对象之间的3D距离。
-- 参数列表	: npc, player
-- 返回值	: 距离(单位点,64点为1尺||米)
-- 备注		:可以是npc,player
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
-- 函数名	: CustomFunction.GetAllPlayer
-- 函数描述	: 获取场景内所有玩家。
-- 参数列表	: scene, bDeath
-- 返回值	: 玩家对象table表，没有玩家返回false
-- 备注		:bDeath（是否包括死亡的玩家）
--			只能用于战场或者副本，不适用于野外场景。
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
-- 函数名	: CustomFunction.GetRandomPlayer
-- 函数描述	: 随机获取场景内的几个玩家。
-- 参数列表	: scene, bDeath, nCount
-- 返回值	: 玩家对象table表，没有玩家返回false
-- 备注		:bDeath（是否包括死亡的玩家）, nCount（随机玩家数量）
--			只能用于战场或者副本，不适用于野外场景。
--			随机玩家不会重复。
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

-- 函数名	: CustomFunction.GetRandomPlayerAdvanced
-- 函数描述	: 随机获取场景内的几个玩家。(改进版，解决传入nCount可能比场景人数多时会Random报错的问题)
-- 参数列表	: scene, bDeath, nCount
-- 返回值	: 玩家对象table表，没有玩家返回false
-- 备注		:bDeath（是否包括死亡的玩家）, nCount（随机玩家数量）
--			只能用于战场或者副本，不适用于野外场景。
--			随机玩家不会重复。
--			如果出现玩家数量不足nCount个数时，则尽可能地返回已有的玩家列表
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
-- 函数名	: CustomFunction.GetAngle
-- 函数描述	: 计算两个对象之间的角度，当npc转向(转到)这个角度后，面对这player。
-- 参数列表	: npc, player
-- 返回值	: 角度值
-- 备注		:可以是npc,player,doodad或者{nX = 1, nY = 1, nZ = 1}的Table
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
-- 函数名	: CustomFunction.CreatNpcAndDooadaInAllMaps
-- 函数描述	: 根据传入的表创建npc。
-- 参数列表	: tScene
-- 返回值	: 没有。
-- 备注		:由于是server函数，所以只能创建本服务器开启的地图。建议在活动开启函数中使用。
--			或者使用本函数的一个center远程调用形式RemoteCallToCenter("On_Activity_CCreatNPC",tScene)来确保创建成功。
--			tScene的写法
--			local tScene = {
--				[1] = {
--					格式：npcID，x, y, z, dir, nickname, type（true为npc  false为doodad）,nDisAppearFrame(缺省则为永久物。)
--					{2590, 3633, 31138, 1068736, 188, "qm_gongpin_1", false},
--					{11721, 2735, 30349, 1068800, 66, "qm_wangyifengsuicong", true},
--				}, --"稻香村",
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
-- 函数名	: CustomFunction.DelActNpcAndDooadaInAllMaps
-- 函数描述	: 根据传入的表删除npc。删除对应别名的npc或doodad.只有别名和类型为必要的参数。
-- 参数列表	: tScene
-- 返回值	: 没有。
-- 备注		:由于是server函数，所以只能删除本服务器开启的地图。建议在活动结束函数中使用。
--			tScene的写法
--			local tScene = {
--				[1] = {
--					格式：npcID，x, y, z, dir, nickname, type（true为npc  false为doodad）,nDisAppearFrame(缺省则为永久物。)
--					{2590, 3633, 31138, 1068736, 188, "qm_gongpin_1", false}, --稻香村大侠墓
--				}, --"稻香村",
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
-- 函数名	: CustomFunction.GetPos
-- 函数描述	: 计算某个角度距离的点的坐标。
-- 参数列表	: nAngle, nSpace
-- 返回值	: 角度值，距离值
-- 备注		: nAngle单位为逻辑角度 256（客户端获取的角度/360*256)
function CustomFunction.GetPos(nAngle, nSpace)
	return GetLogicRaycastHit(0, 0, nAngle, nSpace)
--[[原函数
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

-- 函数名	: CustomFunction.GetOffsetPos
-- 函数描述	: 计算某个对象，向某个角度偏移某距离的坐标
-- 参数列表	: 某对象, 偏移角度(游戏内2π是256度), 偏移距离
-- 返回值	: X坐标, Y坐标
-- 备注		: nAngle单位为逻辑角度256,右手为0/256
function CustomFunction.GetOffsetPos(KTarget, nAngle, nDistance)
	return GetLogicRaycastHit(KTarget.nX, KTarget.nY, KTarget.nFaceDirection + nAngle, nDistance)
--[[原函数
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

-- 函数名	: CustomFunction.GetOffsetPosByXY
-- 函数描述	: 计算某个指定的点，向某个角度偏移某距离的坐标
-- 参数列表	: 中心点X，中心点Y, 目前的nFace，偏移角度(游戏内2π是256度), 偏移距离
-- 返回值	: X坐标, Y坐标
-- 备注		: nAngle单位为逻辑角度 256,前方为0，左手为64，后方为128, 右手为198
function CustomFunction.GetOffsetPosByXYFA(nX, nY, nFace, nAngle, nDistance)
	return GetLogicRaycastHit(nX, nY, nFace + nAngle, nDistance)
--[[原函数
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

-- 函数名	: CustomFunction.AddQuestValue
-- 函数描述	: 增加任务变量值。
-- 参数列表	: player, dwQuestID, nIndex, bTeam, [nSpace]
-- 返回值	: 没有。
-- 备注		:player（玩家对象）, dwQuestID（任务ID）, nIndex（变量位）, bTeam（队友是否也加）, [nSpace（队友同步距离,单位尺,默认为32尺）]
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

-- 函数名	: CustomFunction.GetFrontNpcPosition
-- 函数描述	: 获得某坐标前方nDis距离的坐标，
-- 参数列表	: nX,nY，nDir：当前的坐标和方向；nDis1距离
-- 返回值	: tMidFollow = {nX = xxx, nY = xxx, nDir = 222}
-- 备注		:
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

-- 函数名	: CustomFunction.GetFrontNpcPositionAnyDir
-- 函数描述	: 获得某坐标前方nDis距离的坐标，可以输入低于0和超过255的nDir值
-- 参数列表	: nX,nY，nDir：当前的坐标和方向；nDis1距离
-- 返回值	: tMidFollow = {nX = xxx, nY = xxx, nDir = 222}
-- 备注		:
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

-- 函数名	: CustomFunction.GetFollowsPosition
-- 函数描述	: 获得某坐标点后方nDis距离的3个跟随（npc）的坐标，
-- 参数列表	: nX,nY，nDir：当前的坐标和方向;nDis1距：后方中间位置的跟随（npc）与当前坐标的距离；a: 两边2个跟随（npc）与中间跟随（npc）的距离
-- 返回值	: tMidFollow = {nX = xxx, nY = xxx}， tLeftFollow = {nX = xxx, nY = xxx,}，tRightFollow = {nX = xxx, nY = xxx}
-- 备注		:
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

-- 函数名	: CustomFunction.GetValueByBit
-- 函数描述	: 获得数字的某一比特位值
-- 参数列表	:  nValue：值；nBit：取值范围[0,31]
-- 返回值	: 1 or 0
-- 备注		: CustomFunction.GetValueByBit(10, 31)，表示获取数字“10”的第31个Bit位的值。
function CustomFunction.GetValueByBit(nValue, nBit)
	if nBit > 31 or nBit < 0 then
		print(">>>>>>>CustomFunction.GetValueByBit Arg ERROR!!!!!BitIndex error")
		--return nValue
	end
	return GetValueByBits(nValue, nBit, 1)
	--return math.floor(nValue / 2 ^ nBit) % 2
end

-- 函数名	: CustomFunction.SetValueByBit
-- 函数描述	: 将某个值的某一比特位值设置为0或者1
-- 参数列表	:  nValue：值；nBit：取值范围[0,31]；nNewBit：只能为0或者1
-- 返回值	: 设置完bit之后的新值
-- 备注		: CustomFunction.SetValueByBit(10,31,1)，表示将数字“10”的第31个Bit位的值置为1
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
	--如果要设置的新值和旧值一样，那么值不变，直接返回
	--if math.floor(nValue / 2 ^ nBit) % 2 == nNewBitValue then
		--return nValue
	--end
	--如果参数不正确那么
	--if nNewBitValue > 1 or nNewBitValue < 0 or nBit > 31 or nBit < 0 then
		--print(">>>>>>>CustomFunction.SetValueByBit Arg ERROR!!!!!nBit=[] nNewBit Must be 0 or 1,")
		--return nValue
	--end
	--0设成1加值，1变成0减值
	--print("SetValueByBit="..nNewBitValue)
	--if nNewBitValue == 1 then
		--return nValue + 2 ^ nBit
	--else
		--return nValue - 2 ^ nBit
	--end
end

-- 函数名	: CustomFunction.IfStartAdventure
-- 函数描述	: 是否开启/触发某个奇遇.
-- 其实是尝试对玩家发起指定奇遇的意思，一旦检查奇遇不在cd中就会尝试对玩家发起奇遇，需要在两端的on_qiyu.lua里面配置表才能正常使用。-xutong
-- 参数列表	:  player，nAdventureID：见表 ui/Scheme/Case/Adventure.txt。
-- 返回值	: 无
-- 备注		:
function CustomFunction.IfStartAdventure(player, nAdventureID, bTianshu)	--走到这里不代表一定触发奇遇，在此之前不得发奖励或发公告，否则屁股自己擦
	if not player or not nAdventureID or nAdventureID <= 0 then
		return false
	end
	if player.GetBuff(9186, 1) then
		return false
	end
	--查看玩家是否加载完毕，没加载完毕的话取不到奇遇状态
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
	[1] = {nTryQuestID = 18090, dwAcceptID = 1, dwAchiID = 7154}, --三山四海
	[2] = {nTryQuestID = 18091, dwAcceptID = 391, dwAchiID = 7155}, --三尺青锋
	[3] = {nTryQuestID = 18092, dwAcceptID = 151, dwAchiID = 7156}, --阴阳两界
	[4] = {nTryQuestID = 18094, dwAcceptID = 81, dwAchiID = 7157}, --黑白路·恶人
	[5] = {nTryQuestID = 18093, dwAcceptID = 95, dwAchiID = 7158}, --黑白路·浩气
	[6] = {nTryQuestID = 18095, dwAcceptID = 231, dwAchiID = 7159}, --少年行
	[7] = {nTryQuestID = 18096, dwAcceptID = 301, dwAchiID = 7160}, --茶馆奇缘
	[8] = {nTryQuestID = 18097, dwAcceptID = 367, dwAchiID = 7161}, --生死判·恶人谷
	[9] = {nTryQuestID = 18098, dwAcceptID = 377, dwAchiID = 7162}, --生死判·浩气盟
	[10] = {nTryQuestID = 18099, dwAcceptID = 519, dwAchiID = 7163}, --炼狱厨神
	[11] = {nTryQuestID = 18100, dwAcceptID = 559, dwAchiID = 7164}, --茶馆悬赏
	[12] = {nTryQuestID = 18101, dwAcceptID = 589, dwAchiID = 7165}, --清茗经
	[13] = {nTryQuestID = 18102, dwAcceptID = 631, dwAchiID = 7166}, --胜负局
	[14] = {nTryQuestID = 18103, dwAcceptID = 671, dwAchiID = 7167}, --归乡路
	[15] = {nTryQuestID = 18104, dwAcceptID = 711, dwAchiID = 7168}, --枫林酒
	[16] = {nTryQuestID = 18105, dwAcceptID = 731, dwAchiID = 7169}, --红衣歌
	[17] = {nTryQuestID = 18106, dwAcceptID = 771, dwAchiID = 7170}, --捉妖记
	[18] = {nTryQuestID = 18107, dwAcceptID = 801, dwAchiID = 7171}, --孩童书
	[19] = {nTryQuestID = 18108, dwAcceptID = 843, dwAchiID = 7172}, --清风捕王
	[20] = {nTryQuestID = 18109, dwAcceptID = 841, dwAchiID = 7173}, --扶摇九天
	[21] = {nTryQuestID = 18110, dwAcceptID = 865, dwAchiID = 7174}, --塞外宝驹
	[22] = {nTryQuestID = 18111, nQuestID = 14833, dwAchiID = 7175}, --天涯无归
	[23] = {nTryQuestID = 18112, dwAcceptID = 913, dwAchiID = 0}, --世外奇人
	[25] = {nTryQuestID = 18113, dwAcceptID = 993, dwAchiID = 7176}, --沙海谣
	[26] = {nTryQuestID = 18114, dwAcceptID = 1009, dwAchiID = 7177}, --石敢当
	[27] = {nTryQuestID = 18115, dwAcceptID = 1025, dwAchiID = 7178}, --荆轲刺
	[28] = {nTryQuestID = 18116, dwAcceptID = 1053, dwAchiID = 7179}, --破晓鸣
	[29] = {nTryQuestID = 18117, dwAcceptID = 1067, dwAchiID = 7180}, --竹马情
	[30] = {nTryQuestID = 18118, dwAcceptID = 1079, dwAchiID = 7181}, --至尊宝
	[31] = {nTryQuestID = 18119, dwAcceptID = 1099, dwAchiID = 7182}, --护佑苍生
	[32] = {nTryQuestID = 18120, dwAcceptID = 1119, dwAchiID = 7183}, --虎啸山林
	[33] = {nTryQuestID = 18121, dwAcceptID = 1162, dwAchiID = 7184}, --乱世舞姬
	[34] = {nTryQuestID = 18122, dwAcceptID = 1125, dwAchiID=7185}, --兽王佩
	[35] = {nTryQuestID = 18123, dwAcceptID = 1177, dwAchiID=7186}, --稚子心
	[36] = {nTryQuestID = 18124, dwAcceptID = 1205, dwAchiID=7187}, --青草歌
	[37] = {nTryQuestID = 18125, dwAcceptID = 1237, dwAchiID=7188}, --滇南行
	[40] = {nTryQuestID = 18126, nQuestID = 16393, dwAchiID=7189}, --雪山恩仇
	[41] = {nTryQuestID = 18127, dwAcceptID = 1255, dwAchiID=7190}, --平生心愿
	[42] = {nTryQuestID = 18128, dwAcceptID = 1283, dwAchiID=7191}, --北行镖
	[43] = {nTryQuestID = 18129, nQuestID = 16882, dwAchiID=7192}, --东海客
	[44] = {nTryQuestID = 18130, nQuestID = 16886, dwAchiID=7193}, --关外商
	[46] = {nTryQuestID = 18131, dwAcceptID = 1311, dwAchiID=7194}, --故园风雨
	[47] = {nTryQuestID = 18132, dwAcceptID = 1313, dwAchiID=7195}, --锋芒展
	[48] = {nTryQuestID = 18133, dwAcceptID = 1339, dwAchiID=7196}, --烹调法
	[49] = {nTryQuestID = 18134, dwAcceptID = 1357, dwAchiID=7197}, --儿女事
	[50] = {nTryQuestID = 18135, nQuestID = 17885, dwAchiID=7198}, --韶华故
	[54] = {nTryQuestID = 18136, dwAcceptID = 1373, dwAchiID=7199}, --锻剑女
	[55] = {nTryQuestID = 18137, dwAcceptID = 1379, dwAchiID=7200}, --一念间
	[56] = {nTryQuestID = 18138, dwAcceptID = 1385, dwAchiID=7201}, --戎马边
	[57] = {nTryQuestID = 18139, dwAcceptID = 1391, dwAchiID=7202}, --白雪忆
	[58] = {nTryQuestID = 18140, dwAcceptID = 1401, dwAchiID=7203}, --烟花戏·月
	[59] = {nTryQuestID = 18141, dwAcceptID = 1407, dwAchiID=7204}, --烟花戏·春
	[60] = {nTryQuestID = 18142, dwAcceptID = 1413, dwAchiID=7205}, --烟花戏·秋
	[61] = {nTryQuestID = 18143, dwAcceptID = 1419, dwAchiID=7206}, --烟花戏·风
	[62] = {nTryQuestID = 18153, dwAcceptID = 1425, dwAchiID=7207}, --归安志·安
	[63] = {nTryQuestID = 18152, dwAcceptID = 1435, dwAchiID=7208}, --归安志·归
	[64] = {nTryQuestID = 18154, dwAcceptID = 1445, dwAchiID=7209}, --归安志·志
	[65] = {nTryQuestID = 18144, nQuestID = 18081, dwAchiID=7210}, --摸头杀
	[66] = {nTryQuestID = 18145, nQuestID = 18163, dwAchiID=7211}, --济苍生
	[67] = {nTryQuestID = 18146, dwAcceptID = 1455, dwAchiID=7212}, --太行道
	[68] = {nTryQuestID = 18147, dwAcceptID = 1475, dwAchiID=7213}, --秘宝图
	[69] = {nTryQuestID = 18148, dwAcceptID = 1501, dwAchiID=7214}, --客江干
	[70] = {nTryQuestID = 18149, dwAcceptID = 1517, dwAchiID=7215}, --滴水恩
	[71] = {nTryQuestID = 18150, dwAcceptID = 1527, dwAchiID=7216}, --谜书生
	[72] = {nTryQuestID = 18151, dwAcceptID = 1539, dwAchiID=7217}, --沧海笛
	[73] = {nTryQuestID = 18155, dwAcceptID = 1547, dwAchiID=7453}, --缘来会·瓜
	[74] = {nTryQuestID = 18156, dwAcceptID = 1557, dwAchiID=7454}, --缘来会·铃
	[75] = {nTryQuestID = 18157, dwAcceptID = 1567, dwAchiID=7455}, --江湖录
	[76] = {nTryQuestID = 18158, dwAcceptID = 1571, dwAchiID=7609}, --舞众生
	[77] = {nTryQuestID = 21696, dwAcceptID = 1573, dwAchiID=7800}, --露园事
	[78] = {nTryQuestID = 21604, nQuestID = 21605, dwAchiID=7502}, --兔江湖
	[79] = {nTryQuestID = 21694, nQuestID = 21657, dwAchiID=7601}, --白日梦
	[80] = {nTryQuestID = 21756, dwAcceptID = 1595, dwAchiID=7801}, --莫贪杯
	[81] = {nTryQuestID = 21757, dwAcceptID = 1621, dwAchiID=7802}, --瀛洲梦
	[82] = {nTryQuestID = 21874, nQuestID = 21837, dwAchiID=7879}, --劝学记
	[83] = {nTryQuestID = 21873, nQuestID = 21853, dwAchiID=7880}, --100橙武
	[85] = {nTryQuestID = 23051, dwAcceptID = 1635,dwAchiID=9028}, --话玄虚
	[86] = {nTryQuestID = 23052, dwAcceptID = 1645,dwAchiID=9029}, --白月皎
	[87] = {nTryQuestID = 23053, dwAcceptID = 1653,dwAchiID=9030}, --尘网中
	[88] = {nTryQuestID = 23236, nQuestID = 23212, dwAchiID=9109}, --侠行囧途
	[89] = {nTryQuestID = 23471, dwAcceptID = 1665,dwAchiID=9142}, --一枝栖
	[90] = {nTryQuestID = 23371, nQuestID = 23372, dwAchiID=9363}, --流年如虹
	[91] = {nTryQuestID = 23626, dwAcceptID = 1677,dwAchiID=9143}, --丹青记
	[92] = {nTryQuestID = 23638, dwAcceptID = 1691,dwAchiID=9144}, --捉贼记
	[93] = {nTryQuestID = 23688, nQuestID = 23689, dwAchiID=9443}, --寻猫记：成就未改
	[94] = {nTryQuestID = 24036, nQuestID = 23831, dwAchiID=9592}, --旧宴承欢
	[95] = {nTryQuestID = 23947, dwAcceptID = 1711,dwAchiID=9683}, --童蒙志
	[96] = {nTryQuestID = 23853, dwAcceptID = 1699,dwAchiID=9684}, --念旧林
	[97] = {nTryQuestID = 23967, dwAcceptID = 1731,dwAchiID=9685}, --风雨意
	[98] = {nTryQuestID = 24201, nQuestID = 23975,dwAchiID=9731}, --凌云梯
	[99] = {nTryQuestID = 24214, nQuestID = 24163,dwAchiID=9733}, --度人心·恶人谷
	[100] = {nTryQuestID = 24260, nQuestID = 24189,dwAchiID=9733}, --度人心·浩气盟
	[101] = {nTryQuestID = 24360, nQuestID = 24361,dwAchiID=10033}, --庆舞良宵
	[102] = {nTryQuestID = 24510, dwAcceptID = 1747,dwAchiID=10141}, --鸠雀记
	[103] = {nTryQuestID = 24692, dwAcceptID = 1761, dwAchiID=10142}, --幽海牧
	[104] = {nTryQuestID = 24599, nQuestID = 24591, dwAchiID=10147}, --万灵当歌
	[105] = {nTryQuestID = 24691, dwAcceptID = 1773, dwAchiID=10143}, --枉叹恨
	[106] = {nTryQuestID = 24738, nQuestID = 24739, dwAchiID=10181}, --110橙武
	[107] = {nTryQuestID = 25347, dwAcceptID = 1789,dwAchiID=10657}, --子夜歌
	[108] = {nTryQuestID = 25438, dwAcceptID = 1803, dwAchiID=10655}, --重洋客
	[109] = {nTryQuestID = 25471, dwAcceptID = 1817, dwAchiID=10656}, --故岁辞
	[110] = {nTryQuestID = 25599, nQuestID = 25549, dwAchiID=10804}, --红尘不渡
	[111] = {nTryQuestID = 25622, nQuestID = 25623, dwAchiID=10814}, --追魂骨
	[112] = {nTryQuestID = 25650, nQuestID = 25651, dwAchiID = 10812}, --镜中琴音
	[113] = {nTryQuestID = 25704, nQuestID = 25706, dwAchiID=10833}, --拜春擂
	[114] = {nTryQuestID = 25902, nQuestID = 25783, dwAchiID = 11028}, --莫负初心·恶人谷
	[115] = {nTryQuestID = 25821, dwAcceptID = 1833, dwAchiID=10994}, --夜哀鸣
	[116] = {nTryQuestID = 25858, dwAcceptID = 1879, dwAchiID=10995}, --乱红鸾
	[117] = {nTryQuestID = 25847, dwAcceptID = 1847, dwAchiID=10996}, --醉烟波
	[118] = {nTryQuestID = 25903, nQuestID = 25884, dwAchiID = 11028}, --莫负初心·浩气盟
	[119] = {nTryQuestID = 26347, dwAcceptID = 1887, dwAchiID = 11299}, --破巧言
	[120] = {nTryQuestID = 26323, dwAcceptID = 1905, dwAchiID = 11298}, --解心语
	[121] = {nTryQuestID = 26322, nQuestID = 26307, dwAchiID = 11214}, --入蛟宫
	[122] = {nTryQuestID = 26350, dwAcceptID = 1921, dwAchiID = 11297}, --寓天涯
}
-- 函数名	: CustomFunction.IfStartAdventureBeforeRandom
-- 函数描述	: 满足奇遇初始条件后尝试概率触发奇遇的数据埋点
-- 参数列表	:  player，nAdventureID：见表 ui/Scheme/Case/Adventure.txt。
-- 返回值	: 无
-- 备注		:
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
	--记录奇遇尝试次数
	if tAdventureQuestList[nAdventureID].dwAchiID and tAdventureQuestList[nAdventureID].dwAchiID ~= 0 then
		player.AddAchievementCount(tAdventureQuestList[nAdventureID].dwAchiID, 1)
	end
end

-- 完成奇遇 成就
local tAdventureAchList = {
	[1] = 4605, -- 三山四海
	[2] = 4606, -- 三尺青峰
	[3] = 4607, -- 阴阳两界
	[4] = 4608, -- 黑白路
	[5] = 4608, -- 黑白路
	[6] = 4609, -- 少年行
	[7] = 4610, -- 茶馆奇缘
	[8] = 4611, -- 谈判大师
	[9] = 4611, -- 谈判大师
	[10] = 5176, -- 炼狱厨神
	[19] = 5177, -- 大唐神捕
	[20] = 5178, -- 梅花桩
	[21] = 5179, -- 塞外名驹
	[22] = 5187, -- 天涯无归
	[31] = 5445, -- 护佑苍生
	[32] = 5446, -- 虎啸山林
	[33] = 5447, -- 乱世舞姬
	--宠物奇遇
	[12] = 5198, -- 清茗经
	[13] = 5199, -- 胜负局
	[14] = 5200, -- 归乡路
	[15] = 5194, -- 枫林酒
	[16] = 5195, -- 红衣歌
	[17] = 5197, -- 捉妖记
	[18] = 5196, -- 孩童书
	[25] = 5329, --沙海谣
	[26] = 5330, --石敢当
	[27] = 5328, --荆轲刺
	[28] = 5441, --破晓鸣
	[29] = 5442, --竹马情
	[30] = 5443, --至尊宝
	[34] = 5448, --兽王佩
	[35] = 5659, --稚子心
	[36] = 5658, --青草歌
	[37] = 5657, --滇南行
	[40] = 5690, --奇经恩仇录
	[41] = 5691, --平生心愿
	--[43] = 5691,--东海客	,ID待定
	[46] = 5837, -- 故园风雨
	[47] = 6018, --锋芒展
	[48] = 6019, --烹调法
	[49] = 6020, --儿女事
	[50] = 5997,
	[54] = 6035, --锻剑女
	[55] = 6032, --一念间
	[56] = 6034, --戎马边
	[57] = 6033, --白雪忆
	[58] = 6029, --烟花戏·月
	[59] = 6030, --烟花戏·春
	[60] = 6028, --烟花戏·秋
	[61] = 6031, --烟花戏·风
	[62] = 6188, --归安志·安
	[63] = 6187, --归安志·归
	[64] = 6189, --归安志·志
	[65] = 6208, --忆往昔摸头杀
	[66] = 6271, --济苍生
	[67] = 6695, --太行道
	[68] = 6696, --秘宝图
	[69] = 6697, --客江干
	[70] = 7103, --滴水恩
	[71] = 7102, --谜书生
	[72] = 7104, --沧海笛
	[73] = 7445, --缘来会·瓜
	[74] = 7446, --缘来会·铃
	[75] = 7447, --江湖录
	[76] = 7494, --舞众生
	[77] = 7797, --露园事
	[78] = 7874, --兔江湖
	[79] = 7873, --白日梦
	[80] = 7798, --莫贪杯
	[81] = 7799, --瀛洲梦
	[82] = 7890, --劝学记
	[83] = 7891, --争铸吴钩
	[85] = 9022, --话玄虚
	[86] = 9023, --白月皎
	[87] = 9024, --尘网中
	[88] = 9110, --侠行囧途
	[89] = 9145, --一枝栖
	[90] = 9307, --流年如虹
	[91] = 9146, --丹青记
	[92] = 9147, --捉贼记
	[93] = 9442, --寻猫记
	[94] = 9593, --旧宴承欢
	[95] = 9680, --童蒙志
	[96] = 9681, --念旧林
	[97] = 9682, --风雨意
	[98] = 9757, --凌云梯
	[99] = 9732, --度人心·恶人谷
	[100] = 9732, --度人心·浩气盟
	[101] = 10034, --庆舞良宵
	[102] = 10138, --童蒙志
	[103] = 10139, --幽海牧
	[104] = 10148, --万灵当歌
	[105] = 10140, --枉叹恨
	[106] = 10182, --千秋铸
	[107] = 10653, --子夜歌
	[108] = 10652, --重洋客
	[109] = 10654, --故岁辞
	[110] = 10803, --红尘不渡
	[111] = 10813, --追魂骨
	[112] = 10811, --镜中琴音
	[113] = 10832, --拜春擂
	[114] = 11027, --莫负初心·恶人谷
	[115] = 10991, --夜哀鸣
	[116] = 10992, --乱红鸾
	[117] = 10993, --醉烟波
	[118] = 11027, --莫负初心·浩气盟
	[119] = 11296, --破巧言
	[120] = 11295, --解心语
	[121] = 11213, --入蛟宫
	[122] = 11294, --寓天涯
}

local tAdventureRewardItemList = {
	[70] = {
		{8, 22562, 1 },
	}, --滴水恩
	[72] = {
		{8, 22561, 1},
	}, --沧海笛
	[85] = {
		{8, 27932, 1}
	}, --话玄虚
	[86] = {
		{8, 27933, 1}
	}, --白月皎
	[87] = {
		{8, 27935, 1}
	}, --尘网中
	[89] = {
		{8, 27947, 1}
	}, --一枝栖
	[91] = {
		{8, 27946, 1}
	}, --丹青记
	[92] = {
		{8, 27948, 1}
	}, --捉贼记
	[95] = {
		{8, 27957, 1}
	}, --童蒙志
	[96] = {
		{8, 27956, 1}
	},--念旧林
	[97] = {
		{8, 27958, 1}
	}, -- 风雨意
	[102] = {
		{8, 27987, 1}
	},--鸠雀记
	[103] = {
		{8, 27986, 1}
	}, -- 幽海牧
	[105] = {
		{8, 27985, 1}
	}, -- 枉叹恨
	[107] = {
		{8, 28003, 1}
	},--子夜歌
	[108] = {
		{8, 28001, 1}
	},-- 重洋客
	[109] = {
		{8, 28002, 1}
	}, -- 故岁辞
	[115] = {
		{8, 35944, 1}
	}, --夜哀鸣
	[116] = {
		{8, 35945, 1}
	},--乱红鸾
	[117] = {
		{8, 35946, 1}
	}, -- 醉烟波
	[119] = {
		{8, 35962, 1}
	}, -- 破巧言
	[120] = {
		{8, 35961, 1}
	}, --解心语
	[122] = {
		{8, 35963, 1}
	}, --寓天涯
}

-- 函数名	: CustomFunction.GetAdventureAch
-- 函数描述	: 获得某个奇遇线对应的完成成就
-- 参数列表	: nAdventureID：见表 ui/Scheme/Case/Adventure.txt。
-- 返回值	: nAchievementID
-- 备注		:
function CustomFunction.GetAdventureAch(nAdventureID)
	return tAdventureAchList[nAdventureID] or 0
end

-- 函数名	: CustomFunction.FinishAdventure
-- 函数描述	: 完成某个奇遇线
-- 参数列表	:  player，nAdventureID：见表 ui/Scheme/Case/Adventure.txt。
-- 返回值	: 无
-- 备注		:
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

	player.DelBuff(9186, 1)	--删除奇遇CD BUFF，防止有些奇遇过短，卡到下个奇遇
end

--[[
-- 函数名	: CustomFunction.StartAdventure
-- 函数描述	: 开启某个奇遇线
-- 参数列表	:  player；nAdventureID：见表 ui/Scheme/Case/Adventure.txt.
-- 返回值	: 无
-- 备注		:
function CustomFunction.StartAdventure(player, nAdventureID)
	if not player or not nAdventureID or nAdventureID <= 0 then
		return
	end
	player.SetCustomUnsigned2(383, nAdventureID)
	RemoteCallToClient(player.dwID, "OpenAdventure", nAdventureID, false)
end
--]]

-- 函数名	: CustomFunction.CheckMapForRepresentApply
-- 函数描述	: 检查相关表现（比如夜幕星河）能否在当前地图展示
-- 参数列表	: player
-- 返回值	: true or false
-- 备注		: 后续有新的地图需要特殊处理在这里直接处理就OK
function CustomFunction.CheckMapForRepresentApply(scene)
	if (scene.nType == MAP_TYPE.DUNGEON and scene.dwMapID ~= 246 and scene.dwMapID ~= 258 and scene.dwMapID ~= 261 and scene.dwMapID ~= 274) or scene.nType == MAP_TYPE.BATTLE_FIELD or scene.dwMapID == 25 or scene.dwMapID == 27 then
		return false
	end
	--加判小据点活动期间
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

-- 函数名	: CustomFunction.CheckPlayerForRepresentApply
-- 函数描述	: 检查玩家当前状态能否使用相关表现（比如夜幕星河）
-- 参数列表	: player
-- 返回值	: true or false
-- 备注		:
function CustomFunction.CheckPlayerForRepresentApply(player)
	if player.dwIdentityVisiableID ~= 0 then
		player.SendSystemMessage(GetEditorString(10, 9476))
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", GetEditorString(10, 9477), 4)
		return false
	end
	return true
end

-- 函数名	: CustomFunction.GetExtChangedBite
-- 函数描述	: 根据传入的扩展点值的变化以及占用位的长度计算是哪个位被写了
-- 参数列表	: player, tBitChangedList。
-- 返回值	: nChangedBite
-- 备注		: 只支持单个扩展点所有位的占用长度是一样的情况
function CustomFunction.GetExtChangedBite(playplayer, nLastValue, nCurrentValueer)
	local nValueChanged = nCurrentValue - nLastValue
	if nValueChanged < 1 then
		return nil
	end

	local nBitChanged = 0
	if nValueChanged > 1 then
		while(nTemp > 1) do	--算出变动的bit位，只考虑由0变1的情况……
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
-- 函数名	: CustomFunction.IsEXPServer
-- 函数描述	: 返回是不是体服
-- 参数列表	:
-- 返回值	: 一个布尔值。true：是体服。 false：不是体服。
-- 备注		: 这个函数很不牢靠，每次体服增删服务器时都必须及时维护，不维护很可能导致刷钱刷材料等重大bug。[901,999] 都作为体服

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
--DLC副本重置用
-----------------------------------------
--MapInfo.tab中 筛选 NeedDelete为0  并且  bIsMenPaiDungeon不为1
local tDLCMapID = {45, 37, 41, 43, 36, 26, 40, 28, 44, 33, 42, 34, 47, 62, 111, 112, 115, 114, 113, 125, 141, 157, 162,
	163, 170, 179, 184, 187, 195, 200, 224, 227, 228, 229, 225, 242, 257, 262, 285, 292, 32, 60, 61, 67, 68, 109, 120, 131, 134, 136, 140,
	160, 164, 175, 177, 182, 191, 192, 220, 221, 240, 241, 263, 264, 283, 284, 298, 299, 341, 347, 364, 368, 426, 452, 356, 355, 357, 359, 343, 406, 432, 482, 518, 559, 573,
	490, 480, 478, 481, 469, 564, 521,-- 69, 70,
	586,636,
}
-- 函数名	: CustomFunction.IsInDLCMap
-- 函数描述	: 检查是否在DLC重置副本场景中
-- 参数列表	: target
-- 返回值	: 布尔值
-- 备注		:
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
-- 函数名	: CustomFunction.GetDLCMapTargetLifePercent
-- 函数描述	: 将原血量值转换为DLC的血量值
-- 参数列表	: target, nOldLife, bTank(可选)
-- 返回值	: 血量值
-- 备注		: 之后还要处理非DLC副本的数值乘0.14
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
			---脚本中直接操作NPC的nCurrentLife的地方，会经过这个函数转化处理数值，但这转化函数依赖于NPC的历史血量。这个LOG就是找出遗漏了哪些NPC信息，发现会找出来补到tDLCNpcLife表中
			Log("************************************************************************")
			Log(GetEditorString(13, 4886) .. target.dwTemplateID .. "\t" .. target.szName)
			Log("************************************************************************")
			--local filepath = "C:\\DLCNpcList.txt"
			--local file = io.open(filepath, "a")
			--if file then
			--file:write("副本DLC数值重置遗漏NpcID：\t" .. target.dwTemplateID .. "\t" .. target.szName .. "\n")
			--file:close()
			--end
		end
	else
		return nOldLife
	end
	return nOldLife
end

-- 函数名	: CustomFunction.GetDLCMapTargetManaPercent
-- 函数描述	: 将原蓝量值转换为DLC的蓝量值
-- 参数列表	: target, nOldMana, bTank(可选)
-- 返回值	: 蓝量值
-- 备注		: 之后还要处理非DLC副本的数值乘0.14
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
	[14] = {13926, 1},--灵霄峡
	[17] = {13926, 2},--天工坊
	[18] = {13926, 3},--无盐岛
	[19] = {13926, 4}, --空雾峰
	[20] = {13926, 5}, --天地三才阵
	[46] = {13926, 6},--英雄战宝迦兰
	[51] = {13926, 7}, --剑冢
	[65] = {13926, 8}, --25人普通持国天王殿
	[66] = {13926, 8}, --英雄持国天王殿
	[63] = {13926, 9}, --英雄宫中神武遗迹
	[64] = {13926, 9}, --25人普通宫中神武遗迹
	[73] = {13926, 10}, --英雄荻花宫后山
	[69] = {13926, 11}, --10人英雄荻花圣殿
	[70] = {13926, 11}, --25人普通荻花圣殿
	[72] = {13926, 11},--25人英雄荻花圣殿
	[116] = {13926, 12}, --低级仙踪林
	[71] = {13926, 12}, --仙踪林
	[75] = {13926, 13},--毒神殿
	[106] = {13926, 14},--法王窟
	[107] = {13926, 15},--无量宫
	[117] = {13926, 16}, --25人英雄龙渊泽
	[118] = {13926, 16},--25人普通龙渊泽
	[119] = {13926, 16},--10人英雄龙渊泽
	[110] = {13926, 17},--寂灭厅
	[130] = {13926, 18},--英雄荻花洞窟
	[123] = {13926, 19},--低级唐门密室
	--[126] = {13926, 20},
	[148] = {13926, 21}, --英雄持国回忆录
	[133] = {13926, 22}, --25人英雄烛龙殿
	[138] = {13926, 23},--25人英雄会战唐门
	[155] = {13926, 24},--英雄南诏皇宫
	[142] = {13926, 25},--低级光明顶秘道
	[167] = {13926, 26},--一线天
	[171] = {13926, 27},--英雄战宝军械库
	[161] = {13926, 28},--华清宫
	[165] = {13926, 29},--英雄大明宫
	[169] = {13926, 30},--流离岛
	[176] = {13926, 31},--英雄血战天策
	[178] = {13926, 32},--英雄风雪稻香村
	[183] = {13926, 33},--英雄秦皇陵
	[198] = {13926, 34}, --英雄太原之战_夜守孤城
	[205] = {13926, 34}, --挑战太原之战_夜守孤城
	[211] = {13926, 34}, --10人挑战太原之战_夜守孤城
	[199] = {13926, 35}, --英雄太原之战_逐虎驱狼
	[206] = {13926, 35}, --挑战太原之战_逐虎驱狼
	[212] = {13926, 35},--10人挑战太原之战_逐虎驱狼
	[196] = {13926, 36}, --普通雁门关之役
	[222] = {13926, 37}, --挑战璨翠海厅
	[203] = {13926, 38}, --天泣林
	[204] = {13926, 39}, --阴山圣泉
	[209] = {13926, 40}, --梵空禅院
	[218] = {13926, 41},--引仙水榭
	[219] = {13926, 42},--微山书院
	[231] = {13926, 43},--英雄永王行宫_仙侣庭园
	[232] = {13926, 43},--帮会永王行宫_仙侣庭园
	[234] = {13926, 43}, --10人挑战永王行宫_仙侣庭园
	[236] = {13926, 43},--25人挑战永王行宫_仙侣庭园
	[230] = {13926, 44},--英雄永王行宫_花月别院
	[233] = {13926, 44},--帮会永王行宫_花月别院
	[235] = {13926, 44},--10人挑战永王行宫_花月别院
	[237] = {13926, 44},--25人挑战永王行宫_花月别院
	[248] = {13926, 45},--英雄上阳宫_观风殿
	[250] = {13926, 45},--帮会上阳宫_观风殿
	[249] = {13926, 46}, --英雄上阳宫_双曜亭
	[251] = {13926, 46}, --帮会上阳宫_双曜亭
	[244] = {13926, 47}, --挑战白帝水宫
	[256] = {13926, 48}, --夕颜阁
	[260] = {13926, 48}, --挑战夕颜阁
	[275] = {13926, 49},--挑战刀轮海厅
	[271] = {13926, 50},--英雄风雷刀谷_锻刀厅
	[273] = {13926, 50},--帮会风雷刀谷_锻刀厅
	[270] = {13926, 51}, --英雄风雷刀谷_千雷殿
	[272] = {13926, 51}, --帮会风雷刀谷_千雷殿
	[286] = {13926, 52}, --英雄狼牙堡_战兽山
	[288] = {13926, 52}, --帮会狼牙堡_战兽山
	[287] = {13926, 53}, --英雄狼牙堡_燕然峰
	[289] = {13926, 53}, --帮会狼牙堡_燕然峰
	[290] = {13926, 54}, --挑战银雾湖
	[291] = {13926, 55}, --稻香秘事
	[295] = {13926, 55}, --挑战稻香秘事
	[300] = {13926, 56}, --英雄狼牙堡_辉天堑
	[323] = {13926, 56}, --帮会狼牙堡_辉天堑
	[301] = {13926, 57}, --英雄狼牙堡_狼神殿
	[324] = {13926, 57}, --帮会狼牙堡_狼神殿
	[354] = {13926, 58}, --英雄冰火岛_荒血路
	[360] = {13926, 58}, --挑战冰火岛_荒血路
	[348] = {13926, 59}, --英雄冰火岛_青莲狱
	[349] = {13926, 59}, --挑战冰火岛_青莲狱
	[365] = {13926, 60}, --英雄尘归海_巨冥湾
	[366] = {13926, 60}, --挑战尘归海_巨冥湾
	[369] = {13926, 61},--英雄尘归海_饕餮洞
	[370] = {13926, 61},--挑战尘归海_饕餮洞
	[427] = {13926, 62},--25人普通敖龙岛
	[428] = {13926, 62},--25人英雄敖龙岛
	[453] = {13926, 63},--25人普通范阳夜变
	[454] = {13926, 63}, --25人英雄范阳夜变
	[337] = {13926, 64}, --泥兰洞天
	[339] = {13926, 65}, --大衍盘丝洞
	[340] = {13926, 66}, --镜泊湖
	[342] = {13926, 67}, --九辩馆
	[358] = {13926, 68}, --迷渊岛
	[407] = {13926, 69},--挑战周天屿
	[431] = {13926, 70},--玄鹤别院
	[483] = {13926, 71},--25人普通达摩洞
	[484] = {13926, 72},--25人英雄达摩洞
	[519] = {13926, 73},--25人普通白帝江关
	[520] = {13926, 74},--25人英雄白帝江关
	[560] = {13926, 75},--25人普通雷域大泽
	[561] = {13926, 76},--25人英雄雷域大泽
	
	[574] = {13926, 77},--25人普通河阳之战
	[575] = {13926, 78},--25人英雄河阳之战
	[489] = {13926, 79}, --月落三星
	[479] = {13926, 80}, --罗汉门
	[477] = {13926, 81}, --梧桐山庄
	[476] = {13926, 82}, --集真岛
	[468] = {13926, 83}, --剑冢惊变
	[563] = {13926, 84},--武氏别院
	[522] = {13926, 85}, --挑战漳水南路
	[587] = {13926, 86}, --25人普通西津渡
	[588] = {13926, 86}, --25人英雄西津渡
	[637] = {13926, 87}, --25人普通武狱黑牢
	[638] = {13926, 87}, --25人英雄武狱黑牢

}
-- 函数名	: CustomFunction.AddDLCMapDefenceBuff
-- 函数描述	: 在DLC的经典旧世副本为玩家和宠物补防御
-- 参数列表	: target
-- 返回值	: 无
-- 备注		:
function CustomFunction.AddDLCMapDefenceBuff(target)
	local dwMapID = target.GetMapID()
	if not dwMapID then
		return
	end
	local nDefenceBuffID = 0
	local nDefenceBuffLevel = 0
	--print("DLC防御buff：执行检查地图ID是否为DLC")
	if tDLCMapIDtoBuff[dwMapID] then
		--print("DLC防御buff：找到对应Buff" .. tDLCMapIDtoBuff[k][1] .. "等级" .. tDLCMapIDtoBuff[k][2])
		nDefenceBuffID = tDLCMapIDtoBuff[dwMapID][1]
		nDefenceBuffLevel = tDLCMapIDtoBuff[dwMapID][2]
	end
	if nDefenceBuffID == 0 then
		target.DelMultiGroupBuffByID(13926)
	else
		target.AddBuff(target.dwID, target.nLevel, nDefenceBuffID, nDefenceBuffLevel)
	end
end
-- 函数名	: CustomFunction.DelDLCMapDefenceBuff
-- 函数描述	: 删除目标的DLC经典老副本（未满级）补防御BUFF
-- 参数列表	: target
-- 返回值	: 无
-- 备注		:
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
-- 函数名	: CustomFunction.OpenSwitchMapWindowDLCtest
-- 函数描述	: 201810月体服屏蔽10人RAID入口
-- 参数列表	: player, dwWindowID, TargetType, dwTargetID
-- 返回值	: 无
-- 备注		:
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
				--同时包含5人10人的本，弹个只有5人本的窗口
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
-- 函数名	: CustomFunction.SwitchMapOldDungeon
-- 函数描述	: 从余半仙处进入的前尘秘境出来时回到余半仙处
-- 参数列表	: player, dwMapID, nX, nY, nZ
-- 返回值	: 无
-- 备注		:
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

-- 函数名	: CustomFunction.GetSecondToTomorrow7()
-- 函数描述	: 获得现在到明早上7点整的秒数（如果现在是凌晨0:00~6:59，那么是到今早07:00）
-- 参数列表	:
-- 返回值	: 剩余多少秒
function CustomFunction.GetSecondToTomorrow7()
	local nCurTime = GetCurrentTime()
	local nCurrentDate = TimeToDate(nCurTime)
	local nToday7 = DateToTime(nCurrentDate.year, nCurrentDate.month, nCurrentDate.day, 7, 0, 0)
	local nTommorrow7 = 1
	if GetCurrentHour() < 7 then
		nTommorrow7 = nToday7
	else
		nTommorrow7 = nToday7 + 86400--加上一天的秒数
	end
	return nTommorrow7 - nCurTime	
end

-- 函数名	: CustomFunction.GetMinuToTomorrow7()
-- 函数描述	: 获得现在到明早上7点整重置的剩余分钟（如果现在是凌晨0:00~6:59，那么是到今早07:00）
-- 参数列表	:
-- 返回值	: 剩余多少分钟，因为秒数被抹零不是很精确，向上取整，最大误差会多返回一分钟。需要精确的勿用
function CustomFunction.GetMinuToTomorrow7()
	local nHour = GetCurrentHour()
	local nMinu = GetCurrentMinute()
	local nLeftHour = 31 - nHour - 1	--我将第二天的7点标记为31:00，多 -1是因为要算分钟数
	if nLeftHour >= 24 then	--凌晨0:00之后到06:59，时间要多减掉24
		nLeftHour = nLeftHour - 24
	end
	local nLeftMinu = 60 - nMinu	--不足1小时的分钟，上面
	return nLeftHour * 60 + nLeftMinu	--首胜buff一分钟一跳，小时转换为buff跳数，反正战场中午12点才开，误差点跳数也无所谓	
end

-- 函数名	: CustomFunction.GetMinuToNextWeek7()
-- 函数描述	: 获得现在到下周一早上7点整重置的剩余分钟（如果现在是凌晨0:00~6:59，那么是到今早07:00）
-- 参数列表	:
-- 返回值	: 剩余多少分钟，因为秒数被抹零不是很精确，向上取整，最大误差会多返回一分钟。需要精确的勿用
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

-- 函数名	: CustomFunction.GetValueByTenBit()
-- 函数描述	: 获得某个数字第N个十进制位上的值，如5123，取第四位上的值为5
-- 参数列表	: (value, bit) 值，第几位
-- 返回值	: 数字0~9
-- 备注		: CustomFunction.GetValueByTenBit(5123, 4)，如5123，取第四位上的值为5
function CustomFunction.GetValueByTenBit(value, bit)
	if bit <= 0 then
		return
	end
	return  math.floor((value % (10 ^ bit)) / (10 ^ (bit - 1)))
end

-- 函数名	: CustomFunction.SetValueByTenBit()
-- 函数描述	: 设置某个数字第N个十进制位上的值，如5123，设置第四位上的值为6，最后为6123
-- 参数列表	: (value, bit, newBitValue) 值，第几位，设置新值
-- 返回值	: 设置后的数值
-- 备注		: CustomFunction.SetValueByTenBit(5123, 6)，如5123，取第四位上的值为5
function CustomFunction.SetValueByTenBit(value, bit, newBitValue)
	if bit <= 0 or newBitValue < 0 or newBitValue > 9 then
		return
	end
	local nOldValue = CustomFunction.GetValueByTenBit(value, bit)
	return value + (newBitValue - nOldValue) * 10 ^ (bit - 1)
end

-- 函数名	: CustomFunction.GetPointToLineLenght()
-- 函数描述	: 2D空间，获取某个点到某条直线的最短距离，一般用来计算与原路径偏移多少距离，比如小兵偏离巡逻路径
-- 参数列表	: (xPoint, yPoint, xLine1, yLine1, xLine2, yLine2) 点坐标，直线上任意两点的坐标
-- 返回值	: 设置后的数值
-- 备注		: CustomFunction.SetValueByTenBit(5123, 6)，如5123，取第四位上的值为5
function CustomFunction.GetPointToLineLenght(xPoint, yPoint, xLine1, yLine1, xLine2, yLine2)
	if xPoint and yPoint and xLine1 and yLine1 and xLine2 and yLine2 then
		--假设函数公式为Ax + By + C = 0，先求得函数公式
		local nA_agr = yLine2 - yLine1
		local nB_agr = xLine1 - xLine2
		local nC_agr = xLine2 * yLine1 - xLine1 * yLine2
		--点到直线的公式为 d=|Ax+By+C|/ sqrt(A*A+B*B)
		return math.abs(nA_agr * xPoint + nB_agr * yPoint + nC_agr) / math.sqrt(nA_agr * nA_agr + nB_agr * nB_agr)
	else
		return 0
	end
end

-- 函数名	: CustomFunction.GetPoint2PointDis()
-- 函数描述	: 2D空间，获取两点之间的距离
-- 参数列表	: (x1, y1, x2, y2) 点坐标
-- 返回值	: 米(尺)
-- 备注		: 可以使用 GetDistanceSq(x1, y1, z1, x2, y2, z2) 来优化,z传0即可
function CustomFunction.GetPoint2PointDis(x1, y1, x2, y2)
	local Npc_2D_X = x1 - x2
	local Npc_2D_Y = y1 - y2
	local nDis2D = math.sqrt(Npc_2D_X ^ 2 + Npc_2D_Y ^ 2) / 64
	return nDis2D
end

-- 函数名	: CustomFunction.GetPoint2PointDis2()
-- 函数描述	: 3D空间，获取两点之间的距离的平方
-- 参数列表	: (x1, y1, z1, x2, y2, z2) 点坐标
-- 返回值	: 单位：像素点的平方  (64点=1米(尺))
-- 备注		: xyz均为客户端直接取出的坐标
function CustomFunction.GetPoint2PointDis2(x1, y1, z1, x2, y2, z2)
	return GetDistanceSq(x1, y1, z1, x2, y2, z2)
end

-- 函数名	: CustomFunction.SetCurFunitureInfo(player, nModuleID, nLandIndex, nObjectID, nObjectPos)
-- 函数描述	: 临时存储当前交互的家具信息，移动、切图、上下线会重置
-- 参数列表	: player
-- 返回值	: 无
-- 备注		:
function CustomFunction.SetCurFunitureInfo(player, nModuleID, nLandIndex, nObjectID, nObjectPos)
	local nBuffLandPosID = 17160 --存nLandIndex*100+nObjectPos
	local nBuffModuleID = 17161	--存nModuleID
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

-- 函数名	: CustomFunction.GetCurFunitureInfo(player)
-- 函数描述	: 获取当前交互的家具信息
-- 参数列表	: player
-- 返回值	: nModuleID, nLandIndex, nObjectID, nObjectPos
-- 备注		:
function CustomFunction.GetCurFunitureInfo(player)
	local nBuffLandPosID = 17160 --存nLandIndex*100+nObjectPos
	local nBuffModuleID = 17161	--存nModuleID
	local nBuffObjectID = 17162	--nObjectID
	
	local nModuleID = 0
	local nLandIndex = 0
	local nObjectID = 0
	local nObjectPos = 0
	local bMiss = false

	--取landIndex和pos
	local buffLandPosID = player.GetBuff(nBuffLandPosID, 1)
	if buffLandPosID then
		nObjectPos = buffLandPosID.nCustomValue % 100
		nLandIndex = (buffLandPosID.nCustomValue - nObjectPos) / 100
	else
		bMiss = true
	end
	--取ModuleID
	local buffModuleID = player.GetBuff(nBuffModuleID, 1)
	if buffModuleID then
		nModuleID = buffModuleID.nCustomValue
	else
		bMiss = true
	end
	--取ObjectID
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

-- 函数名	: CustomFunction.SetSceneFilter(player, dwMapID, nBitIndex, bVisible)
-- 函数描述	: 设置场景可见性令牌
-- 参数列表	: player, dwMapID, nBitIndex, bVisible
-- 返回值	: 无
-- 备注		: 如果角色所在场景dwMapID与参数不符，则不生效，防止出错
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

-- 函数名	: CustomFunction.SetSceneFilterByTable(player, dwMapID, tFilterInfo)
-- 函数描述	: 根据table设置复数场景可见性令牌
-- 参数列表	: player, dwMapID, tFilterInfo
-- 返回值	: 无
-- 备注		: 如果角色所在场景dwMapID与参数不符，则不生效，防止出错；tFilterInfo格式：local tFilterInfo = {{nBitIndex, bVisible},{nBitIndex, bVisible}, ...}
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
-- 函数名	: CustomFunction.IsAsuraMapID(dwMapID)
-- 函数描述	: 判断是否为修罗挑战地图
-- 参数列表	: dwMapID
-- 返回值	: bIsAsura
-- 备注		: 
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