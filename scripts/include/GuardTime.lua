---------------------------------------------------------------------->
-- �ű�����:	scripts/Include/GuardTime.lua
-- ����ʱ��:	2020/6/23 16:29:51
-- �����û�:	GUOGE
-- �ű�˵��:	
----------------------------------------------------------------------<

function IsGuarding()
	local nNowWeek = GetCurrentWeekDay()
	if nNowWeek == 1 then
		return true
	elseif not IsActivityOn(553) and not IsActivityOn(599) then
		return true
	else
		return false
	end
end
