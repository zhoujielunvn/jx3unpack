--������Ե������� ǧ������ һͳ����
--�书����
--��������-���Σ����Լ��ܣ�
--����Ч����˵������Χ5����ѣ��5�룬�κι���������ѣ��Ч��
--���� 2006-11-28

--------------����ķָ���-----------------------------------------------------

Include("scripts/Include/Skill.lh")
--�����滻skill�ű�Include("scripts/Include/Player.lh")



--�����书���ܼ��������ֵ
function GetSkillLevelData(skill)

    local bRetCode     = false;
	local dwSkillLevel = skill.dwLevel;
	
    skill.AddAttribute(
		ATTRIBUTE_EFFECT_MODE.EFFECT_TO_DEST_NOT_ROLLBACK,
		ATTRIBUTE_TYPE.CALL_BUFF,
		417,
		1
	);

    ----------------- ����Cool down ---------------------------------------
    
    --SetPublicCoolDown(id)���ù���CD��SetNormalCoolDown(posi, id)���ü���CD������posiΪCoolDownλ(��3λ)��id��Ҫ��CoolDownList.tab
    
    --skill.SetNormalCoolDown(1, 1);
	
    ----------------- ����������� ----------------------------------------
   
    --��������
    --skill.dwLevelUpExp      = tSkillData[dwSkillLevel].nLevelUpExp;    

    --�����뾶��Ҳ���ǹ�������Ч����
    skill.nMaxRadius        = 5 * LENGTH_BASE;
    skill.nAngleRange       = 256; 
    --����֡��
    skill.nPrepareFrames    = 0;
    --�ӵ��ٶ�
    --skill.nBulletVelocity   = 
    --����ϵĸ���
    skill.nBreakRate        = 1024;
   
    return true;
end



--�Լ���ִ�е�����������飬�ú��������ڿ�ʼʩ�ż��ܵ�ʱ�򱻵��ã���ȷ���Ƿ����ʩ�Ÿû���
--Player: ����ʩ����
--nPreResult: �������水��һ�������жϵĽ����ע�⣬�����Խű����صĽ��Ϊ׼
function CanCast(player, nPreResult)    
--�ж���ҵ�״̬�����ж��Ƿ���Է�������
    return nPreResult;
end