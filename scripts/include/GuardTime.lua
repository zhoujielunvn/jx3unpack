---------------------------------------------------------------------->
-- 脚本名称:	scripts/Include/GuardTime.lua
-- 更新时间:	2020/6/23 16:29:51
-- 更新用户:	GUOGE
-- 脚本说明:	
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
