--- ʹ��˵��----
--[[

�ù����������ƶ�μ��ܵ���ʾ�Ͳ���ʾ

SetSkillNoDependentBuff(dwSkillID, dwBuffID[, nBuffStack])
SetSkillDependentBuff(dwSkillID, dwBuffID[, nBuffStack])
���������ֱ������ü�������buff�Ͳ�����buff����

tSkillChange �����ڸ�֪UI��Щ��������ͬһ����λ����ʼĸ�������ĸ�

���ܻ���ͨ�����buff��CD�������ͷ�˳��ͽ��࣬�������

������
����1  NotDependent Buff_A
����2  Dependent Buff_A, NotDependent Buff_B
����3  Dependent Buff_B, NotDependent Buff_C
ע��������ܽ���������ui�ϼ��ܵ���ʾ, ʵ�ʼ����Ķ��ܷ��Ķβ��ܷ��߻���ԭ�м��ܻ�����ʵ��

ʵ��ĳ�������Ƿ���ʾ, ���ж�DependentBuff����������, Ȼ��NoDependentBuffҲ��������, ������ʾ
UI ����tSkillChange˳�򣬴�ͷɨ�裬�ҵ���һ������ Dependent �� NotDependent �ļ��ܾ���ʾ
�ο�ui�ű����function GetMultiStageSkillCanCastID(dwSkillID,player)
]]
-----------------
local tSkillChange = {
	[64295] = {64296, 64457, 64459},
	[64297] = {64298, 64457, 64459}, 
	[64299] = {64300, 64457, 64459}, 
	[64301] = {64302, 64457, 64459},
	[64303] = {64304, 64457, 64459}, 
	[64305] = {64457, 64459}, 
	[64307] = {64308,64309,64313, 64457, 64459}, 
	[64310] = {64311, 64457, 64459},
	[64735] = {64736,64737, 64457, 64459},
	[64343] = {64358},
	[64448] = {64458},
	[64848] = {64887},
	[35388] = {35392, 64457, 64459},
	[35546] = {35544, 35545, 64457, 64459}

}
function InitSkillChangeInfo()	

	SetSkillNoDependentBuff(64295, 50919)
	SetSkillNoDependentBuff(64296, 50919)
	SetSkillNoDependentBuff(64297, 50919)
	SetSkillNoDependentBuff(64298, 50919)
	SetSkillNoDependentBuff(64299, 50919)
	SetSkillNoDependentBuff(64300, 50919)
	SetSkillNoDependentBuff(64301, 50919)
	SetSkillNoDependentBuff(64302, 50919)
	SetSkillNoDependentBuff(64303, 50919)
	SetSkillNoDependentBuff(64304, 50919)
	SetSkillNoDependentBuff(64305, 50919)
	SetSkillNoDependentBuff(64306, 50919)
	SetSkillNoDependentBuff(64307, 50919)
	SetSkillNoDependentBuff(64308, 50919)
	SetSkillNoDependentBuff(64309, 50919)
	SetSkillNoDependentBuff(64310, 50919)
	SetSkillNoDependentBuff(64311, 50919)
	SetSkillNoDependentBuff(64313, 50919)
	SetSkillNoDependentBuff(64735, 50919)
	SetSkillNoDependentBuff(64736, 50919)
	SetSkillNoDependentBuff(64737, 50919)
	
	SetSkillNoDependentBuff(35388, 50919)
	SetSkillNoDependentBuff(35392, 50919)
	SetSkillNoDependentBuff(35546, 50919)
	SetSkillNoDependentBuff(35544, 50919)
	SetSkillNoDependentBuff(35545, 50919)
	
	SetSkillNoDependentBuff(35384, 50919)
	SetSkillNoDependentBuff(35399, 50919)
	SetSkillNoDependentBuff(35480, 50919)
	SetSkillNoDependentBuff(35597, 50919)

	SetSkillDependentBuff(64457, 50919)
	SetSkillNoDependentBuff(64457, 50920)
	SetSkillDependentBuff(64459, 50919)
	SetSkillDependentBuff(64459, 50920)

	SetSkillNoDependentBuff(64448, 50919)
	SetSkillDependentBuff(64458, 50919)

	SetSkillNoDependentBuff(64295, 50547)
	SetSkillDependentBuff(64296, 50547)

	SetSkillNoDependentBuff(64297, 50549)
	SetSkillDependentBuff(64298, 50549)

	SetSkillNoDependentBuff(64299, 50551)
	SetSkillDependentBuff(64300, 50551)

	SetSkillNoDependentBuff(64301, 50555)
	SetSkillDependentBuff(64302, 50555)

	SetSkillNoDependentBuff(64303, 50557)
	SetSkillDependentBuff(64304, 50557)
	
	SetSkillDependentBuff(64308, 50619)
	SetSkillDependentBuff(64309, 50620)
	SetSkillDependentBuff(64313, 50810)
	SetSkillNoDependentBuff(64307, 50619)
	SetSkillNoDependentBuff(64307, 50620)
	SetSkillNoDependentBuff(64307, 50810)
	SetSkillNoDependentBuff(64308, 50620)
	SetSkillNoDependentBuff(64308, 50810)
	SetSkillNoDependentBuff(64309, 50810)
	SetSkillNoDependentBuff(64313, 50620)

	SetSkillNoDependentBuff(64310, 50562)
	SetSkillDependentBuff(64311, 50562)

	SetSkillNoDependentBuff(64343, 10064301)
	SetSkillDependentBuff(64358, 10064301)

	SetSkillNoDependentBuff(64735, 50988)
	SetSkillNoDependentBuff(64735, 50990, 2)
	SetSkillDependentBuff(64736, 50988)
	SetSkillNoDependentBuff(64736, 50990, 2)
	SetSkillDependentBuff(64737, 50990, 2)

	SetSkillNoDependentBuff(64848, 51210)
	SetSkillDependentBuff(64887, 51210)
	
	SetSkillNoDependentBuff(35388, 26583)
	SetSkillDependentBuff(35392, 26583)
	
	SetSkillNoDependentBuff(35546, 26646)
	SetSkillNoDependentBuff(35546, 26647)
	SetSkillNoDependentBuff(35546, 26647)
	SetSkillDependentBuff(35544, 26646)
	SetSkillDependentBuff(35545, 26647)

end
function GetSkillChangeTableList()
	return tSkillChange
end