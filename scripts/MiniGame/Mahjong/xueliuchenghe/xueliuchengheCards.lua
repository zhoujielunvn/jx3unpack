---------------------------------------------------------------------->
-- 脚本名称:	scripts/MiniGame/Mahjong/xueliuchenghe/xueliuchengheCards.lua
-- 更新时间:	2020/3/27 15:22:20
-- 更新用户:	KING-20200219SB
-- 脚本说明:	
----------------------------------------------------------------------<

Include("scripts/MiniGame/Mahjong/xueliuchenghe/xueliuchengheInclude.lua")
Include("scripts/MiniGame/Mahjong/xueliuchenghe/IdentityCustomValueName.lua")

--牌组初始化
function InitCards()
	--写入初始值（服务端牌组）
end

--洗牌
function Shuffle()
	local cards = {}
	--洗牌数组
	for i = 1, CONST_CARDS_NUM do
		cards[i] = tCardsAll[i]
	end
	
	math.random(1, CONST_CARDS_NUM)
	math.random(1, CONST_CARDS_NUM)
	math.random(1, CONST_CARDS_NUM)
	--开始洗牌
	local temp
	local x;
	for i = 1, CONST_CARDS_NUM - 1 do
		x = math.random(i, CONST_CARDS_NUM)
		temp = cards[i];
		cards[i] = cards[x]
		cards[x] = temp
	end
	
	if NO_SHUFFLE then
		for i = 1, CONST_CARDS_NUM do
			cards[i] = tCardsAll1[i]
		end
	end
	--写入服务端牌组
	return cards
end

function ShuffleSubCards(cards, offset, lenth)
	--开始洗牌
	local temp
	local x;
	for i = offset, offset + lenth - 1 do
		x = math.random(offset, offset + lenth)
		temp = cards[i];
		cards[i] = cards[x]
		cards[x] = temp
	end
end

--摇色子
function Dice()
	math.random(1, 6)
	math.random(1, 6)
	math.random(1, 6)
	local diceNum = math.random(1, 6)
	diceNum = diceNum * 10 + math.random(1, 6);
	return diceNum
--设置抓牌offset
--设置换牌对家
--下行消息
end

--[[
--手牌索引转换为牌面值
function switch2CardValue(index)
	--local color = bit.lshift(floor(index / 9), 4)
	local data = 0;
	data = SetDataWithFlagN(0, floor(index / 9), 4)
	return SetDataWithFlagN(data, (index % 9 + 1), 0)
end

--牌面值转换为手牌索引
function switch2CardIndex(value)
	local color = GetDataWithFlagN(value, CONST_MASK_N_VALUE, 4)
	color = color * 9
	local num = GetDataWithFlagN(value, CONST_MASK_N_COLOR, 4) - 1
	return color + num
end
--]]

--获取下一张牌
--[[
function GetNextCard(curIndex, start)
	--获取curIndex指向的牌值（注意边界检测）

	if start then --正常抓牌
		--cardTopIndex++
	else -- 杠牌抓牌
		--cardBottomIndex--
	end
end

--弃牌数组初始化
function InitAbandonCards()
	--写入初始值（服务端弃牌组）
end

--写入弃牌
function SetAbandonCard(value, playerIndex)
	--获取abandonCurIndex
	--local hyperValue = bit.lshift(playerIndex, 6)
	--hyperValue = bit.bor(hyperValue, value)
--	local hyperValue = setDataWithFlag(value, playerIndex, 6)
	local hyperValue = SetDataWithFlagN(value, playerIndex, 6)
	--写入hyperValue
	--写入abandonCurIndex
end
--]]