---------------------------------------------------------------------->
-- �ű�����:	scripts/Include/ClearSpecialSkillBuff.lua
-- ����ʱ��:	2017/12/12 17:29:37
-- �����û�:	wangsongtao-pc
-- �ű�˵��:	������ʱ�������CD��BUFF�����������Ч����
--				Ŀǰ��������JJC������Ѱ���
----------------------------------------------------------------------<
Include("scripts/Include/ClearCoolID.lh")

-- �������CD��ֻ�ڱ�����ʽ��ʼǰ���볡��ʱ�Ż����
function ClearSpecialSkillCD(player)
	player.CastSkill(7525, 1) --  ��Ҫ�õ�������ܵ��õ�ħ�����ԣ��������ȷ�����ս��Ҳ�õ�������������CD ������ò�Ҫ��������ܡ������Ҫ����Ҫȫ������һ�顣���� ����������ɡ���
	--for i = 1, #tCoolID do	--���CD
		--if tCoolID[i] ~= 152 and tCoolID[i] ~= 153 and tCoolID[i] ~= 155 and tCoolID[i] ~= 154 and tCoolID[i] ~= 157 and tCoolID[i] ~= 156 and tCoolID[i] ~= 452 and tCoolID[i] ~= 493 and tCoolID[i] ~= 565 and tCoolID[i] ~= 339 then  --�������ڹ��л�
			--player.ClearCDTime(tCoolID[i])
		--end
	--end
	ClearCoolIDFromTable(player)
	player.DelBuff(10050, 1) -- ��ˮ��Ӱ����CD
end

-- �������ͨ������BUFF��ְҵ������BUFF
local tCommonBuffID = {3369, 3370, 3371, 3372, 3373, 3387, 3388, 3389, 3390, 3391, 3392, 3913};

-- ����ʱ��ν�����������������
function ClearSpecialSkillBuffCommon(player)
	-- �иñ��BUFF���JJC�ص�����ʱ���������CD
	player.AddBuff(0, 99, 3602, 1)
	
	-- �������ͨ������BUFF��ְҵ������BUFF
	--local tCommonBuffID = {3369, 3370, 3371, 3372, 3373, 3387, 3388, 3389, 3390, 3391, 3392, 3913};
	for i = 1, 5 do
		for n = 1, #tCommonBuffID do
			player.AddBuff(0, 99, tCommonBuffID[n], 1)
		end
	end

	--����ʱ���ɵ���buff
	for i = 1, #tCanAccumulateBuffID do
		player.DelMultiGroupBuffByID(tCanAccumulateBuffID[i])
	end
	player.DelBuff(11268, 1) -- �̻��ɷ�CD
	player.DelBuff(1594, 1) --����
	player.DelBuff(1594, 2) --����
	player.DelBuff(316, 1)  --��¶��
	player.DelBuff(2313, 1) --��˹�
	player.DelBuff(1171, 1) --̴��
	player.DelBuff(1172, 1) --ȵβ
	player.DelBuff(731, 1) --�Ի�
	player.DelBuff(6381, 1) --ؤ����������
	player.DelBuff(6127, 1) --�������
	player.DelBuff(10020, 1)  --ˮ����-�Һ���
	player.DelBuff(10021, 1) --ˮ����-�Һ���
	player.DelBuff(10022, 1) --ˮ����-�Һ���
	player.DelBuff(10100, 1) --ˮ����-��������˫
	player.DelBuff(305, 1)--������
	player.DelGroupBuff(2307, 1)
	player.DelGroupBuff(2308, 1)
	player.DelGroupBuff(2309, 1)
	player.DelGroupBuff(1091, 1)	
	player.DelGroupBuff(1094, 1)
	player.DelGroupBuff(2682, 1)
	
	for m = 2560, 2574 do	--������
		player.DelBuff(m, 1)
	end

	--for a = 1, 8 do 				--��������
		--player.DelBuff(134, a)
		--player.DelBuff(2749, a)
	--end
	player.DelMultiGroupBuffByID(134)
	player.DelMultiGroupBuffByID(2749)
	player.DelMultiGroupBuffByID(8867)
	player.DelMultiGroupBuffByID(8868)
	player.DelMultiGroupBuffByID(6090)
	player.DelBuff(6125, 1) --7.12����BUFF
	player.DelBuff(6183, 1)
	player.DelBuff(4482, 1)--9.23��ħ���������cd
	player.DelBuff(4482, 2)
	--for b = 1, 4 do
		--player.DelBuff(3203, b)
	--end
	player.DelMultiGroupBuffByID(3203)
	local nKungfuID = player.GetKungfuMountID()
	if nKungfuID then
		if nKungfuID == 10002 or nKungfuID == 10003 then --������
			player.AddBuff(0, 99, 3891, 1)
		end
	
		if nKungfuID == 10014 or nKungfuID == 10015 then --�Ӷ���
			player.AddBuff(0, 99, 3891, 2)
		end
	
		if nKungfuID == 10242 or nKungfuID == 10243 then --����������
			player.nSunPowerValue = 0
			player.nMoonPowerValue = 0
		end
	end
	
	if player.dwForceID == 21 then --���ƽ�JJC������
		player.nCurrentEnergy = player.nMaxEnergy
	end

	--for i = 1, 6 do
		--player.DelBuff(136, i)
		--player.DelGroupBuff(1241, 2) -- �¹�����
		--player.DelGroupBuff(1241, 6) -- �¹�����
	--end
	player.DelMultiGroupBuffByID(136)
	player.DelGroupBuff(1241, 2) -- �¹�����
	player.DelGroupBuff(1241, 6) -- �¹�����
	player.DelGroupBuff(10000,1) --����Ӱ�Ӽ���
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
	--player.DelBuff(9319, 1)--�����ĸ���������
	--player.DelBuff(9320, 1)
	--player.DelBuff(9321, 1)
	--player.DelBuff(9322, 1)
	player.DelGroupBuff(3426, 1)
	player.DelBuff(8867, 10)
	player.DelGroupBuff(11001, 1) -- �Ե��齭��
	player.DelGroupBuff(11001, 2) -- �Ե��齭��
	player.DelGroupBuff(11206, 1) -- �Ե���Х˲��
	player.DelGroupBuff(9801, 1) -- ��������
	player.DelGroupBuff(9719, 1) -- ������
	player.DelBuff(10618, 1)   --ɾ������
	player.DelBuff(11294, 1)
	player.DelBuff(15083, 1)
	player.DelGroupBuff(15253, 1)
	player.DelGroupBuff(14316, 1)
	player.DelBuff(8665, 1)
	player.DelBuff(18105, 1)--ɾ����Ƿ�ֹ��ͼ�����ҽ�ͼ���debuff
	player.DelBuff(18106, 1)--�������cd
	player.DelBuff(21646, 1)--�ؽ��ѱ�
	player.DelBuffByID(24368)
	player.DelGroupBuff(24056,1)
	player.DelGroupBuff(23955,1)
	player.DelBuff(24104, 1)
	player.DelBuff(24105, 1)
	player.DelBuff(24106, 1)
	player.DelBuff(24107, 1)
	player.DelBuff(26135, 1) --��������
	player.DelBuff(24476, 1) -- ҩ�̼���
end