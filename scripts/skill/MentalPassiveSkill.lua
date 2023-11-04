---------------------------------------------------------------------->
-- 脚本名称:	scripts/skill/MentalPassiveSkill.lua
-- 更新时间:	2021/2/20 18:46:00
-- 更新用户:	xueyan11
-- 脚本说明:	
----------------------------------------------------------------------<
Include("scripts/Map/龙门寻宝/include/CheckTreasureBattleFieldMap.lua")
--------------脚本文件开始------------------------------------------------
local TRAIN_COST = 5000		--切换秘籍消耗修为
local tSkillToKungfuMount =	--藏剑的不判断
{
	[26443] = 10014,
	[26444] = 10014,
	[26445] = 10015,
	[26446] = 10015,
	[26447] = 10021,
	[26448] = 10021,
	[26449] = 10028,
	[26450] = 10028,
	[26451] = 10002,
	[26452] = 10002,
	[26453] = 10003,
	[26454] = 10003,
	[26455] = 10062,
	[26456] = 10062,
	[26457] = 10026,
	[26458] = 10026,
	[26459] = 10081,
	[26460] = 10081,
	[26461] = 10080,
	[26462] = 10080,
--	[26463] = 10144;10145,
--	[26464] = 10144;10145,
	[26465] = 10175,
	[26466] = 10175,
	[26467] = 10176,
	[26468] = 10176,
	[26469] = 10225,
	[26470] = 10225,
	[26471] = 10224,
	[26472] = 10224,
	[26473] = 10243,
	[26474] = 10243,
	[26475] = 10242,
	[26476] = 10242,
	[26477] = 10268,
	[26478] = 10268,
	[26479] = 10389,
	[26480] = 10389,
	[26481] = 10390,
	[26482] = 10390,
	[26483] = 10447,
	[26484] = 10447,
	[26485] = 10448,
	[26486] = 10448,
	[26487] = 10464,
	[26488] = 10464,
	[26489] = 10533,
	[26490] = 10533,
	[26491] = 10585,
	[26492] = 10585,
	[26493] = 10615,
	[26494] = 10615,
}

function DoUpdateLevel(player)
	local nCurrentSkillID = player.GetCurrentActiveMentalPassiveSkillAndLevel().dwSkillID
	if nCurrentSkillID and nCurrentSkillID ~= 0 then
		if player.MentalPassiveSkillCanLevelUP() then
			player.CastSkill(26531, 1)
		end
	else
		local szWrongMsg = GetEditorString(18, 8026)
		player.SendSystemMessage(szWrongMsg)
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", szWrongMsg, 4)
		return
	end
end

function DoSetCurrentSkill(player, dwSkillID)
	local scene = player.GetScene()
	if not scene then
		return
	end
	if IsTreasureBattleFieldMap(scene.dwMapID) or scene.dwMapID == 412 then
		local szWrongMsg = GetEditorString(18, 8813)
		player.SendSystemMessage(szWrongMsg)
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", szWrongMsg, 2)
		return
	end
	if player.nMoveState == MOVE_STATE.ON_DEATH or player.bFightState then
		local szWrongMsg = GetEditorString(18, 8033)
		player.SendSystemMessage(szWrongMsg)
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", szWrongMsg, 2)
		return
	end
	local nKungfuID = player.GetKungfuMountID()
	if tSkillToKungfuMount[dwSkillID] and tSkillToKungfuMount[dwSkillID] ~= nKungfuID then
		local szWrongMsg = GetEditorString(18, 8089)
		player.SendSystemMessage(szWrongMsg)
		RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", szWrongMsg, 4)
		return
	end
	if dwSkillID == 26463 or dwSkillID == 26464 then--藏剑特判
		if nKungfuID ~= 10144 and nKungfuID ~= 10145 then
			local szWrongMsg = GetEditorString(18, 8089)
			player.SendSystemMessage(szWrongMsg)
			RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", szWrongMsg, 4)
			return
		end
	end
	local nCurrentSkillID = player.GetCurrentActiveMentalPassiveSkillAndLevel().dwSkillID
	if nCurrentSkillID and nCurrentSkillID ~= 0 then
		if player.nCurrentTrainValue >= TRAIN_COST then
			player.AddTrain(0 - TRAIN_COST)
		else
			local szWrongMsg = GetEditorString(18, 8027)
			player.SendSystemMessage(szWrongMsg)
			RemoteCallToClient(player.dwID, "OnOutputWarningMessage", "MSG_NOTICE_YELLOW", szWrongMsg, 4)
			return
		end
	end
	if not player.IsAchievementAcquired(9111) then
		player.AcquireAchievement(9111)
	end
	player.SetCurrentMentalPassiveSkill(dwSkillID)
	RemoteCallToClient(player.dwID, "PlayChangeMentalSkillSFX")
	--大侠之路教学秘籍
	local nQuestid = 23262
	local nQuestIndex2 = player.GetQuestIndex(nQuestid)
	local nQuestPhase2 = player.GetQuestPhase(nQuestid)
	if nQuestIndex2 and nQuestPhase2 == 1 then
		player.SetQuestValue(nQuestIndex2, 0, 1)
	end
end

--置空心法秘籍
function ZhiKongSkill(player)
	if not player then
		return
	end
	if not player.IsHaveBuff(19123, 1) then
		player.AddBuff(0, 99, 19123, 1, 60 * 60 * 2)
		local buffXFMJ = player.GetBuff(19123, 1)
		local skill = player.GetCurrentActiveMentalPassiveSkillAndLevel()
		local nKungfuID = player.GetKungfuMountID()
		if nKungfuID == 10144 then
			if skill and skill.dwSkillID ~= 0  then
				buffXFMJ.nCustomValue = skill.dwSkillID
				player.SetCurrentMentalPassiveSkill(0)
			end
			player.AddBuff(0, 99, 19125, 1, 60 * 60 * 2)
			local buffXFMJ2 = player.GetBuff(19125, 1)
			player.MountKungfu(10145, player.GetSkillLevel(10144))
			local skill2 = player.GetCurrentActiveMentalPassiveSkillAndLevel()
			if skill2 and skill2.dwSkillID ~= 0  then
				buffXFMJ2.nCustomValue = skill2.dwSkillID
				player.SetCurrentMentalPassiveSkill(0)
			end
			player.MountKungfu(10144, player.GetSkillLevel(10144))
		elseif nKungfuID == 10145  then
			player.AddBuff(0, 99, 19125, 1, 60 * 60 * 2)
			local buffXFMJ2 = player.GetBuff(19125, 1)
			local skill2 = player.GetCurrentActiveMentalPassiveSkillAndLevel()
			if skill2 and skill2.dwSkillID ~= 0  then
				buffXFMJ2.nCustomValue = skill2.dwSkillID
				player.SetCurrentMentalPassiveSkill(0)
			end
			player.MountKungfu(10144, player.GetSkillLevel(10145))
			if skill and skill.dwSkillID ~= 0  then
				buffXFMJ.nCustomValue = skill.dwSkillID
				player.SetCurrentMentalPassiveSkill(0)
			end
			player.MountKungfu(10145, player.GetSkillLevel(10145))
		else
			if skill and skill.dwSkillID ~= 0  then
				buffXFMJ.nCustomValue = skill.dwSkillID
				player.SetCurrentMentalPassiveSkill(0)
			end
		end

	end
end

--回滚心法秘籍
function ReSetSkill(player)
	if not player then
		return
	end
	local scene = player.GetScene()
	if not scene then
		return
	end
	if IsTreasureBattleFieldMap(scene.dwMapID) or scene.dwMapID == 412 then
	else
		local buffXFMJ = player.GetBuff(19123, 1)
		local buffXFMJ2 = player.GetBuff(19125, 1)
		if not buffXFMJ then
			return
		end
		local nKungfuID = player.GetKungfuMountID()
		if nKungfuID == 10144 then
			if buffXFMJ and buffXFMJ.nCustomValue ~= 0 then
				player.SetCurrentMentalPassiveSkill(buffXFMJ.nCustomValue)
			end
			player.MountKungfu(10145, player.GetSkillLevel(10144))
			if buffXFMJ2 and buffXFMJ2.nCustomValue ~= 0 then
				player.SetCurrentMentalPassiveSkill(buffXFMJ2.nCustomValue)
			end
			player.MountKungfu(10144, player.GetSkillLevel(10144))
		elseif nKungfuID == 10145  then
			if buffXFMJ2 and buffXFMJ2.nCustomValue ~= 0 then
				player.SetCurrentMentalPassiveSkill(buffXFMJ2.nCustomValue)
			end
			player.MountKungfu(10144, player.GetSkillLevel(10145))
			if buffXFMJ and buffXFMJ.nCustomValue ~= 0 then
				player.SetCurrentMentalPassiveSkill(buffXFMJ.nCustomValue)
			end
			player.MountKungfu(10145, player.GetSkillLevel(10145))
		else
			if buffXFMJ and buffXFMJ.nCustomValue ~= 0 then
				player.SetCurrentMentalPassiveSkill(buffXFMJ.nCustomValue)
			end
		end

		player.DelBuff(19123, 1)
		player.DelBuff(19125, 1)
	end

end