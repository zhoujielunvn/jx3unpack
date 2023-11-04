---------------------------------------------------------------------->
-- 脚本名称:	scripts/Exterior/CoinShopCheckToyScript.lua
-- 更新时间:	2021/3/2 11:09:37
-- 更新用户:	WUYUMO
-- 脚本说明:	
----------------------------------------------------------------------<
Include("scripts/Map/世界通用/include/玩具箱信息大全.lua")
function OnCheckToyAlreadyHave(player, dwItemType, dwItemIndex)
	--print("OnCheckToyAlreadyHave " .. tostring(dwItemIndex))
	--Log("OutputCheckToyReturn:" .. tostring(IsToyCollected_CoinShop(player, dwItemIndex)))
	return IsToyCollected_CoinShop(player, dwItemIndex)
end