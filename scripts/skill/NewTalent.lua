---------------------------------------------------------------------->
-- 脚本名称:	scripts/skill/NewTalent.lua
-- 更新时间:	2019/5/25 16:43:16
-- 更新用户:	wangsongtao-pc
-- 脚本说明:
----------------------------------------------------------------------<
-----------------------------------------------
-- 文件名    :  Talent.lua
-- 创建人    :  Wangtao
-- 创建时间  :  2013-04-26
-- 用途(模块):  新天赋系统
-- 用途  	 :  Server端新天赋操作
------------------------------------------------
Include("scripts/Map/世界通用/include/禁止切换奇穴相关.lh")

local szWrongMsg1 = GetEditorString(15, 6958)
local szWrongMsg2 = GetEditorString(14, 5477)

function DoSelectPoint(player, dwPoint, nSelectIndex, dwKungfuID, nSetIndex)
	--player.SelectNewTalentPoint(dwPoint, nSelectIndex)
	local bCanChange, nReasonBuffID = CheckIfCanChangeQiXue(player)	
	if bCanChange then
		if nSetIndex == -1 then
			player.CastSkillXYZ(6191, 1, dwPoint, nSelectIndex, 0)
			player.PlaySfx(512, player.nX, player.nY, player.nZ)
			player.AddBuff(0, 99, 6004, 1, 1)
		else
			player.PresetNewTalentPoint(dwPoint, nSelectIndex, dwKungfuID, nSetIndex)
		end
	else		
		if nReasonBuffID == 11840 then	--JJC的奇怪提示
			local scene = player.GetScene()
			if not scene then
				return
			end
			local szWrongMsg = szWrongMsg1
			if scene.GetCustomUnsigned1(SCENE_CUSTOM_VALUE_NAME.TSSBG.CHANGE_QX) == 0 then	--不满足切奇穴条件
				szWrongMsg = szWrongMsg2
			end
			player.SendSystemMessage(szWrongMsg)
			RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", szWrongMsg, 4)
		end		
	end
end

function DoChangeSet(player, nNewSetIndex)
	local bCanChange, nReasonBuffID = CheckIfCanChangeQiXue(player)	
	if bCanChange then
		player.AddBuff(0, 99, 6004, 1, 5)
		if player.IsHaveBuff(6004, 1) then
			local nbuff = player.GetBuff(6004, 1)
			nbuff.nCustomValue = nNewSetIndex
		end

		if player.nSkillPlatformType == SKILL_PLATFORM_TYPE.MOBILE then
			player.CastSkill(101164, 1)
		else
			player.CastSkill(9092, 1)
			player.PlaySfx(512, player.nX, player.nY, player.nZ)
		end
	else		
		if nReasonBuffID == 11840 then	--JJC的奇怪提示
			local scene = player.GetScene()
			if not scene then
				return
			end
			local szWrongMsg = szWrongMsg1
			if scene.GetCustomUnsigned1(SCENE_CUSTOM_VALUE_NAME.TSSBG.CHANGE_QX) == 0 then	--不满足切奇穴条件
				szWrongMsg = szWrongMsg2
			end
			player.SendSystemMessage(szWrongMsg)
			RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_RED", szWrongMsg, 4)
		end		
	end
	--player.ChangeNewTalentSet(nNewSetIndex)
end
