---------------------------------------------------------------------->
-- �ű�����:	scripts/NpcAssisted/EquipStrength.lua
-- ����ʱ��:	2022/6/17 16:09:43
-- �����û�:	qinfupi
-- �ű�˵��:	
----------------------------------------------------------------------<

--scripts/Include/UIscript/UIscript_Hero.lua��Ҳ�����Ʒ��ֵ������ǿ����ʱ�򵯳�����ȷ�Ͽ�
local nCurSeasonLevel = 13750	--��ǰ����������װ��Ʒ�ʣ��������Ʒ�ʣ�����װ����ʯ�������ۣ��Ҳ����������������ȼ���

--���װ����þ�ʯ������
local nDisCount = 0.1			--��������Ʒ�ʣ�����װ����ʯ�����ۿ�
local nGoldPerEqrip = 0	--���ÿ��װ���ļ۸񣬵�λͭ
--local tLv2Exp = {600, 600, 600, 600, 600, 600, 600, 600, 600}	--����װ���ȼ��Ծ�ʯ�ļӳɽ��
local nMaxStrenghtLv = 8	--���ǿ���ȼ�

--���װ�������㷵�����پ�ʯ�����Ľ��
function GetSmeltAddValue(nEquipLevel, nStrengthLevel)
	local nSmeltValue = 600
	--ǿ���ȼ����㾧ʯ��2022.6.29�޸�Ϊȫ������0������
	--if tLv2Exp[nStrengthLevel+1] then
		--nSmeltValue = tLv2Exp[nStrengthLevel + 1]		
	--end
	--��������װ����⾧ʯ����
	if nEquipLevel < nCurSeasonLevel then
		nSmeltValue = nSmeltValue * nDisCount		
	end
	--��Ҫ�Ľ�Ǯ����ʱ��ҪǮ��
	local nNeedMoney = nGoldPerEqrip
	return nSmeltValue, nNeedMoney
end

--ǿ��װ�����ĵĽ�Һ;���ֵ�Ĺ�ϵ
local nGoldPerExp = 0.068182 --ÿ����һװ��������Ҫ�Ľ����������λ��
function GetStrengthMoneyCost(nStrengthCostValue)
	return nStrengthCostValue * nGoldPerExp*10000
end

--1.װ�������ɹ��Ļص����������ÿ��һ��Ҳ�������
--2.StrengthNpcEquipLevelUp(dwEquipID, nStrengthLevel)����ӿ�ֱ�����õĻ�Ҳ��ص�����Ľӿڣ���������Ҳֻ����һ��
--ֱ�Ӱ�ĳ��װ��������ĳ���ȼ�
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
	if nStrengthLevel > nCurSeasonStrengthLv and nStrengthLevel <= nMaxStrenghtLv then	--һ���������8�Σ�ˢ������ʱ����	
		player.SetCustomUnsigned1(PLAYER_CUSTOM_VALUE.HERO_EQUIP_LV, nStrengthLevel)	--��¼ǿ��װ������ߵȼ�
		player.SendSystemMessage(string.format(GetEditorString(23, 2382), nStrengthLevel))
		RemoteCallToClient(player.dwID, "OnSendSystemAnnounce", string.format(GetEditorString(24, 4668), nStrengthLevel), "yellow")		
		if nStrengthLevel >= 8  and not player.IsAchievementAcquired(10289) then	--�����˼��ĳɾ�
			player.AcquireAchievement(10289)
		end
		--�����ٻ���Ӣ����ȫ���գ�����װ�����Ը���������
		player.DestroyAllSummoned()		
		--��ʼ������������������װ��
		local tEquipList = player.GetAllNpcEquip()
		for nEquipPos, infoList in pairs(tEquipList) do
			if infoList.nStrengthLevel and infoList.nStrengthLevel < nStrengthLevel then
				player.StrengthNpcEquipLevelUp(infoList.dwEquipID, nStrengthLevel)	--ֱ�Ӳ�ǿ����߾����ȼ�							
			end
		end
	end
end