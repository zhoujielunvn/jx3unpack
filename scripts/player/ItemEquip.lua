---------------------------------------------------------------------->
-- 脚本名称:	scripts/player/ItemEquip.lua
-- 更新时间:	2017/12/28 23:20:19
-- 更新用户:	wangsongtao-pc
-- 脚本说明:
----------------------------------------------------------------------<
function OnEquip(player, item, dwDestBox, dwDestX)
	--print("OnEquip",player.szName, item,item.szName, dwDestBox, dwDestX)
	-- local nCurrentEquipID = player.GetEquipIDArray(0)
	-- if nCurrentEquipID == 6 then
		-- return player.GetMapID() == 296 or player.GetMapID() == 297
	-- end
    return true
end
