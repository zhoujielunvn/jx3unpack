---------------------------------------------------------------------->
-- 脚本名称:	scripts/Include/ClearSpecialSkillBuff.lua
-- 更新时间:	2017/12/12 17:29:37
-- 更新用户:	wangsongtao-pc
-- 脚本说明:	进场景时清除技能CD、BUFF、生活技能增益效果等
--				目前用于所有JJC、龙门寻宝活动
----------------------------------------------------------------------<
Include("scripts/Include/ClearCoolID.lh")

-- 清除技能CD，只在比赛正式开始前进入场景时才会调用
function ClearSpecialSkillCD(player)
	player.CastSkill(7525, 1) --  需要用到这个技能调用的魔法属性，而其他比方比如战场也用到了这个技能清除CD 所以最好不要动这个技能。。如果要整合要全部整合一遍。算了 就先这样搞吧。。
	--for i = 1, #tCoolID do	--清除CD
		--if tCoolID[i] ~= 152 and tCoolID[i] ~= 153 and tCoolID[i] ~= 155 and tCoolID[i] ~= 154 and tCoolID[i] ~= 157 and tCoolID[i] ~= 156 and tCoolID[i] ~= 452 and tCoolID[i] ~= 493 and tCoolID[i] ~= 565 and tCoolID[i] ~= 339 then  --不重置内功切换
			--player.ClearCDTime(tCoolID[i])
		--end
	--end
	ClearCoolIDFromTable(player)
	player.DelBuff(10050, 1) -- 杯水留影内置CD
end

-- 清除生活通用类型BUFF，职业辅助类BUFF
local tCommonBuffID = {3369, 3370, 3371, 3372, 3373, 3387, 3388, 3389, 3390, 3391, 3392, 3913};

-- 任意时间段进入比赛场景都会调用
function ClearSpecialSkillBuffCommon(player)
	-- 有该标记BUFF则从JJC回到主城时会清除技能CD
	player.AddBuff(0, 99, 3602, 1)
	
	-- 清除生活通用类型BUFF，职业辅助类BUFF
	--local tCommonBuffID = {3369, 3370, 3371, 3372, 3373, 3387, 3388, 3389, 3390, 3391, 3392, 3913};
	for i = 1, 5 do
		for n = 1, #tCommonBuffID do
			player.AddBuff(0, 99, tCommonBuffID[n], 1)
		end
	end

	--处理时长可叠加buff
	for i = 1, #tCanAccumulateBuffID do
		player.DelMultiGroupBuffByID(tCanAccumulateBuffID[i])
	end
	player.DelBuff(11268, 1) -- 奶花荷风CD
	player.DelBuff(1594, 1) --饺子
	player.DelBuff(1594, 2) --饺子
	player.DelBuff(316, 1)  --碧露丹
	player.DelBuff(2313, 1) --凤凰蛊
	player.DelBuff(1171, 1) --檀中
	player.DelBuff(1172, 1) --鹊尾
	player.DelBuff(731, 1) --脑户
	player.DelBuff(6381, 1) --丐帮蛟龙翻江
	player.DelBuff(6127, 1) --天策雷行
	player.DelBuff(10020, 1)  --水煮鱼-乱喊话
	player.DelBuff(10021, 1) --水煮鱼-乱喊话
	player.DelBuff(10022, 1) --水煮鱼-乱喊话
	player.DelBuff(10100, 1) --水煮鱼-加命中无双
	player.DelBuff(305, 1)--飞鱼丸
	player.DelGroupBuff(2307, 1)
	player.DelGroupBuff(2308, 1)
	player.DelGroupBuff(2309, 1)
	player.DelGroupBuff(1091, 1)	
	player.DelGroupBuff(1094, 1)
	player.DelGroupBuff(2682, 1)
	
	for m = 2560, 2574 do	--帮会相关
		player.DelBuff(m, 1)
	end

	--for a = 1, 8 do 				--坐忘无我
		--player.DelBuff(134, a)
		--player.DelBuff(2749, a)
	--end
	player.DelMultiGroupBuffByID(134)
	player.DelMultiGroupBuffByID(2749)
	player.DelMultiGroupBuffByID(8867)
	player.DelMultiGroupBuffByID(8868)
	player.DelMultiGroupBuffByID(6090)
	player.DelBuff(6125, 1) --7.12技能BUFF
	player.DelBuff(6183, 1)
	player.DelBuff(4482, 1)--9.23忏魔伐罪的内置cd
	player.DelBuff(4482, 2)
	--for b = 1, 4 do
		--player.DelBuff(3203, b)
	--end
	player.DelMultiGroupBuffByID(3203)
	local nKungfuID = player.GetKungfuMountID()
	if nKungfuID then
		if nKungfuID == 10002 or nKungfuID == 10003 then --加禅意
			player.AddBuff(0, 99, 3891, 1)
		end
	
		if nKungfuID == 10014 or nKungfuID == 10015 then --加豆豆
			player.AddBuff(0, 99, 3891, 2)
		end
	
		if nKungfuID == 10242 or nKungfuID == 10243 then --清日月能量
			player.nSunPowerValue = 0
			player.nMoonPowerValue = 0
		end
	end
	
	if player.dwForceID == 21 then --苍云进JJC回能量
		player.nCurrentEnergy = player.nMaxEnergy
	end

	--for i = 1, 6 do
		--player.DelBuff(136, i)
		--player.DelGroupBuff(1241, 2) -- 吐故纳新
		--player.DelGroupBuff(1241, 6) -- 吐故纳新
	--end
	player.DelMultiGroupBuffByID(136)
	player.DelGroupBuff(1241, 2) -- 吐故纳新
	player.DelGroupBuff(1241, 6) -- 吐故纳新
	player.DelGroupBuff(10000,1) --长歌影子减伤
	player.DelBuff(9840, 1)
	player.DelBuff(9961, 1)
	player.DelBuff(9784, 1)
	player.DelBuff(9709, 1)
	player.DelBuff(9704, 1)
	player.DelBuff(9990, 1)
	player.DelBuff(9854, 1)
	player.DelBuff(9894, 1)
	player.DelBuff(9886, 1)
	player.DelBuff(10215, 1)
	player.DelBuff(9299, 1)
	player.DelBuff(6236, 1)
	--player.DelBuff(9319, 1)--下面四个长歌曲风
	--player.DelBuff(9320, 1)
	--player.DelBuff(9321, 1)
	--player.DelBuff(9322, 1)
	player.DelGroupBuff(3426, 1)
	player.DelBuff(8867, 10)
	player.DelGroupBuff(11001, 1) -- 霸刀碎江天
	player.DelGroupBuff(11001, 2) -- 霸刀碎江天
	player.DelGroupBuff(11206, 1) -- 霸刀刀啸瞬发
	player.DelGroupBuff(9801, 1) -- 和尚拿云
	player.DelGroupBuff(9719, 1) -- 酒中仙
	player.DelBuff(10618, 1)   --删除雾雨
	player.DelBuff(11294, 1)
	player.DelBuff(15083, 1)
	player.DelGroupBuff(15253, 1)
	player.DelGroupBuff(14316, 1)
	player.DelBuff(8665, 1)
	player.DelBuff(18105, 1)--删除仇非防止过图快的玩家进图后出debuff
	player.DelBuff(18106, 1)--仇非内置cd
	player.DelBuff(21646, 1)--藏剑佳兵
	player.DelBuffByID(24368)
	player.DelGroupBuff(24056,1)
	player.DelGroupBuff(23955,1)
	player.DelBuff(24104, 1)
	player.DelBuff(24105, 1)
	player.DelBuff(24106, 1)
	player.DelBuff(24107, 1)
	player.DelBuff(26135, 1) --蓬莱击落
	player.DelBuff(24476, 1) -- 药奶减疗
end