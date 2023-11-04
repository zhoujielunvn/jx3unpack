---------------------------------------------------------------------->
-- 脚本名称:	scripts/MiniGame/DouDiZhu/for3players/doudizhu3playersInclude.lua
-- 更新时间:	2020/6/6 18:34:31
-- 更新用户:	KING-20200219SB
-- 脚本说明:	
----------------------------------------------------------------------<
Include("scripts/Include/CustomFunction.lua")
-- 0x01 = 3,
-- 0x02 = 4,
-- 0x03 = 5,
-- 0x04 = 6,
-- 0x05 = 7,
-- 0x06 = 8,
-- 0x07 = 9,
-- 0x08 = 10,
-- 0x09 = J,
-- 0x0A = Q,
-- 0x0B = K,
-- 0x0C = A,
-- 0x0D = 2,
-- 0x0E = 小王,
-- 0x0F = 大王,

function CopyTable(srcTable) --copy数据表
	local destTable = {}
	for k, v in pairs(srcTable) do
		destTable[k] = v
	end
	return destTable
end

function TableMaxn(t)
  local mn=nil;
  for k, v in pairs(t) do
    if(mn==nil) then
      mn=v
    end
    if mn < v then
      mn = v
    end
  end
  return mn
end