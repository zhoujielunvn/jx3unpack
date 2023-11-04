---------------------------------------------------------------------->
-- 脚本名称:	scripts/NpcAssisted/EquipStrength.lua
-- 更新时间:	2022/6/17 16:09:43
-- 更新用户:	qinfupi
-- 脚本说明:	
----------------------------------------------------------------------<

--scripts/Include/UIscript/UIscript_Hero.lua下也有这个品质值，决定强化的时候弹出二次确认框
local nCurSeasonLevel = 13750	--当前赛季的主流装备品质，低于这个品质，拆解的装备晶石数量打折，且不会提升赛季精炼等级！

--拆解装备获得晶石的数量
local nDisCount = 0.1			--低于赛季品质，拆解的装备晶石数量折扣
local nGoldPerEqrip = 0	--拆解每件装备的价格，单位铜
--local tLv2Exp = {600, 600, 600, 600, 600, 600, 600, 600, 600}	--拆解的装备等级对晶石的加成结果
local nMaxStrenghtLv = 8	--最高强化等级

--拆解装备，计算返还多少晶石和消耗金币
function GetSmeltAddValue(nEquipLevel, nStrengthLevel)
	local nSmeltValue = 600
	--强化等级折算晶石，2022.6.29修改为全部按照0级计算
	--if tLv2Exp[nStrengthLevel+1] then
		--nSmeltValue = tLv2Exp[nStrengthLevel + 1]		
	--end
	--赛季过期装备拆解晶石打折
	if nEquipLevel < nCurSeasonLevel then
		nSmeltValue = nSmeltValue * nDisCount		
	end
	--需要的金钱（暂时不要钱）
	local nNeedMoney = nGoldPerEqrip
	return nSmeltValue, nNeedMoney
end

--强化装备消耗的金币和经验值的关系
local nGoldPerExp = 0.068182 --每增加一装备经验需要的金币数量，单位金
function GetStrengthMoneyCost(nStrengthCostValue)
	return nStrengthCostValue * nGoldPerExp*10000
end

--1.装备精炼成功的回调，常规操作每升一次也会掉这里
--2.StrengthNpcEquipLevelUp(dwEquipID, nStrengthLevel)这个接口直接设置的话也会回调这里的接口，跳级精炼也只调用一次
--直接把某件装备精炼到某个等级
function StrengthLevelUp(player, dwEquipID, nStrengthLevel)
	local tEquipInfo = player.GetNpcEquipInfo(dwEquipID)
	local KItemInfo = GetItemInfo(11, tEquipInfo.dwItemIndex)
	if KItemInfo.nLevel < nCurSeasonLevel then
		local szNotice = string.format(GetEditorString(24, 4657), nCurSeasonLevel)		
		player.SendSystemMessage(szNotice)
		RemoteCallToClient(player.dwID, "OnSendSystemAnnounce", szNotice, "red")
		return
	end	
	
	local nCurSeasonStrengthLv = player.GetCustomUnsigned1(PLAYER_CUSTOM_VALUE.HERO_EQUIP_LV)
	if nStrengthLevel > nCurSeasonStrengthLv and nStrengthLevel <= nMaxStrenghtLv then	--一个赛季最多8次，刷新上限时调用	
		player.SetCustomUnsigned1(PLAYER_CUSTOM_VALUE.HERO_EQUIP_LV, nStrengthLevel)	--记录强化装备的最高等级
		player.SendSystemMessage(string.format(GetEditorString(23, 2382), nStrengthLevel))
		RemoteCallToClient(player.dwID, "OnSendSystemAnnounce", string.format(GetEditorString(24, 4668), nStrengthLevel), "yellow")		
		if nStrengthLevel >= 8  and not player.IsAchievementAcquired(10289) then	--精炼八级的成就
			player.AcquireAchievement(10289)
		end
		--所有召唤的英雄先全回收，以免装备属性更新有问题
		player.DestroyAllSummoned()		
		--开始遍历备背包处理所有装备
		local tEquipList = player.GetAllNpcEquip()
		for nEquipPos, infoList in pairs(tEquipList) do
			if infoList.nStrengthLevel and infoList.nStrengthLevel < nStrengthLevel then
				player.StrengthNpcEquipLevelUp(infoList.dwEquipID, nStrengthLevel)	--直接补强到最高精炼等级							
			end
		end
	end
end