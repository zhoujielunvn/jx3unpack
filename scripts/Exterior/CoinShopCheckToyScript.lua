---------------------------------------------------------------------->
-- �ű�����:	scripts/Exterior/CoinShopCheckToyScript.lua
-- ����ʱ��:	2021/3/2 11:09:37
-- �����û�:	WUYUMO
-- �ű�˵��:	
----------------------------------------------------------------------<
Include("scripts/Map/����ͨ��/include/�������Ϣ��ȫ.lua")
function OnCheckToyAlreadyHave(player, dwItemType, dwItemIndex)
	--print("OnCheckToyAlreadyHave " .. tostring(dwItemIndex))
	--Log("OutputCheckToyReturn:" .. tostring(IsToyCollected_CoinShop(player, dwItemIndex)))
	return IsToyCollected_CoinShop(player, dwItemIndex)
end