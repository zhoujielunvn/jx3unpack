---------------------------------------------------------------------->
-- �ű�����:	scripts/player/ItemEquip.lua
-- ����ʱ��:	2017/12/28 23:20:19
-- �����û�:	wangsongtao-pc
-- �ű�˵��:
----------------------------------------------------------------------<
function OnEquip(player, item, dwDestBox, dwDestX)
	--print("OnEquip",player.szName, item,item.szName, dwDestBox, dwDestX)
	-- local nCurrentEquipID = player.GetEquipIDArray(0)
	-- if nCurrentEquipID == 6 then
		-- return player.GetMapID() == 296 or player.GetMapID() == 297
	-- end
    return true
end
