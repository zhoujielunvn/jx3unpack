---------------------------------------------------------------------->
-- 脚本名称:	scripts/MiniGame/DouDiZhu/for3players/doudizhu3playersCards.lua
-- 更新时间:	2021/4/1 11:07:27
-- 更新用户:	caoqing-PC
-- 脚本说明:	
----------------------------------------------------------------------<

--脚本废弃，逻辑移动至doudizhu3playersPlayerMgr.lua

--Include("scripts/MiniGame/DouDiZhu/for3players/doudizhu3playersInclude.lua")
--Include("scripts/MiniGame/DouDiZhu/for3players/IdentityCustomValueName.lua")
--Include("scripts/MiniGame/DouDiZhu/for3players/doudizhu3playersPlayerMgr.lua")

-- 出牌时，byte高4位为癞子牌原值，低4位为avart值

--DDZ_tCardsAll = {
	--0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
	--0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
	--0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
	--0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D,
	--0x0E, 0x0F
--}

--普通洗牌
--function DDZ_NormalShuffle()
	--local cards = {}

	--local temp
	--local x
	--for i = 1, DDZ_CONST_CARDS_NUM - 1 do
		--x = math.random(i, DDZ_CONST_CARDS_NUM)
		--temp = cards[i]
		--cards[i] = cards[x]
		--cards[x] = temp
	--end

	--写入服务端牌组
	--return cards
--end

--function DDZ_NoShuffle(tCardsPile)
	--local tCardsReturn = {}

	--切牌逻辑，随机指定一个值为发牌起点
	--local r = math.random(1, DDZ_CONST_CARDS_NUM)
	--for i = 1, DDZ_CONST_CARDS_NUM do
		--n = r + i
		--if n > DDZ_CONST_CARDS_NUM then
			--n = n - DDZ_CONST_CARDS_NUM
		--end
		--tCardsReturn[i] = tCardsPile[n]
	--end

	--return tCardsReturn
--end

--function DDZ_CardsValue2LaiziValue(allCards, laizi)
	--if type(allCards) ~= "table" then
		--if DDZ_WRITE_LOG then
			--Log(string.format("****** 卡牌数组类型有误：table: %s ******", type(allCards)))
		--end
		--return allCards
	--end

	--没有癞子牌
	--if (laizi[1] + laizi[2]) == 0 then
		--return allCards
	--end

	--for i = 1, DDZ_CONST_CARDS_NUM do
		--判断allCards[i]是否为赖子牌
		--if GetCardValueFromLaiziCard(allCards[i]) == GetCardValueFromLaiziCard(laizi[1]) then
			--cards本身带了花色信息，直接修改最高两位既可
			--allCards[i] = allCards[i] + GetLaziIDFromLaiziCard(laizi[1]) * 0x40
		--elseif GetCardValueFromLaiziCard(cards[i]) == GetCardValueFromLaiziCard(laizi[2]) then
			--allCards[i] = allCards[i] + GetLaziIDFromLaiziCard(laizi[2]) * 0x40
		--end
	--end

	--return allCards
--end

--function RandomLaizi()
	--随机两个赖子
	--local cards = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D}

	--local temp
	--当前只随机两个赖子，随机好后交换位置写入cards前两位
	--for i = 1, 2 do
		--local x = math.random(i, #cards)
		--temp = cards[i]
		--cards[i] = cards[x]
		--cards[x] = temp
	--end

	--local laizi = {}
	--laizi[1] = cards[1] + math.random(4, 7) * 0x10  --天赖子byte前两位为01
	--laizi[2] = cards[2] + math.random(8, 11) * 0x10 --地赖子byte前两位为10

	--return laizi
--end