---------------------------------------------------------------------->
-- �ű�����:	scripts/MiniGame/Mahjong/xueliuchenghe/xueliuchengheCards.lua
-- ����ʱ��:	2020/3/27 15:22:20
-- �����û�:	KING-20200219SB
-- �ű�˵��:	
----------------------------------------------------------------------<

Include("scripts/MiniGame/Mahjong/xueliuchenghe/xueliuchengheInclude.lua")
Include("scripts/MiniGame/Mahjong/xueliuchenghe/IdentityCustomValueName.lua")

--�����ʼ��
function InitCards()
	--д���ʼֵ����������飩
end

--ϴ��
function Shuffle()
	local cards = {}
	--ϴ������
	for i = 1, CONST_CARDS_NUM do
		cards[i] = tCardsAll[i]
	end
	
	math.random(1, CONST_CARDS_NUM)
	math.random(1, CONST_CARDS_NUM)
	math.random(1, CONST_CARDS_NUM)
	--��ʼϴ��
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
	--д����������
	return cards
end

function ShuffleSubCards(cards, offset, lenth)
	--��ʼϴ��
	local temp
	local x;
	for i = offset, offset + lenth - 1 do
		x = math.random(offset, offset + lenth)
		temp = cards[i];
		cards[i] = cards[x]
		cards[x] = temp
	end
end

--ҡɫ��
function Dice()
	math.random(1, 6)
	math.random(1, 6)
	math.random(1, 6)
	local diceNum = math.random(1, 6)
	diceNum = diceNum * 10 + math.random(1, 6);
	return diceNum
--����ץ��offset
--���û��ƶԼ�
--������Ϣ
end

--[[
--��������ת��Ϊ����ֵ
function switch2CardValue(index)
	--local color = bit.lshift(floor(index / 9), 4)
	local data = 0;
	data = SetDataWithFlagN(0, floor(index / 9), 4)
	return SetDataWithFlagN(data, (index % 9 + 1), 0)
end

--����ֵת��Ϊ��������
function switch2CardIndex(value)
	local color = GetDataWithFlagN(value, CONST_MASK_N_VALUE, 4)
	color = color * 9
	local num = GetDataWithFlagN(value, CONST_MASK_N_COLOR, 4) - 1
	return color + num
end
--]]

--��ȡ��һ����
--[[
function GetNextCard(curIndex, start)
	--��ȡcurIndexָ�����ֵ��ע��߽��⣩

	if start then --����ץ��
		--cardTopIndex++
	else -- ����ץ��
		--cardBottomIndex--
	end
end

--���������ʼ��
function InitAbandonCards()
	--д���ʼֵ������������飩
end

--д������
function SetAbandonCard(value, playerIndex)
	--��ȡabandonCurIndex
	--local hyperValue = bit.lshift(playerIndex, 6)
	--hyperValue = bit.bor(hyperValue, value)
--	local hyperValue = setDataWithFlag(value, playerIndex, 6)
	local hyperValue = SetDataWithFlagN(value, playerIndex, 6)
	--д��hyperValue
	--д��abandonCurIndex
end
--]]