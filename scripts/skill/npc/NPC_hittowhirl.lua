--������Ե������� ǧ������ һͳ����
--�书����
--NPC����-����
--����Ч����˵����ʹ���ѣ��2�룬�κι���������ѣ��Ч��
--���� 2006-8-17

--------------����ķָ���-----------------------------------------------------


Include("scripts/Include/Skill.lh")
--�����滻skill�ű�Include("scripts/Include/Player.lh")

--�����书���ܼ��������ֵ
function GetSkillLevelData(skill)
    
    ----------------- ����Buff---------------------------------------------
    
	skill.AddAttribute(
		ATTRIBUTE_EFFECT_MODE.EFFECT_TO_DEST_NOT_ROLLBACK,
		ATTRIBUTE_TYPE.CALL_BUFF,
		415,
		1	
	);

	
    ----------------- ����Cool down ---------------------------------------
    
    --SetPublicCoolDown(id)���ù���CD��SetNormalCoolDown(posi, id)���ü���CD������posiΪCoolDownλ(��3λ)��id��Ҫ��CoolDownList.tab
    
    --skill.SetNormalCoolDown(1, 7);
    
    ----------------- ����������� ----------------------------------------
  
    --��������
    --skill.nCostMana         = tSkillData.nCostMana;
    --�����뾶��Ҳ���ǹ�������Ч����
    skill.nMaxRadius        = 2 * LENGTH_BASE;
    skill.nAngleRange       = 128; 
    --����֡��
    skill.nPrepareFrames    = 0;
    --�ӵ��ٶ�
    skill.nBulletVelocity   = 0;
    --����ϵĸ���
    skill.nBreakRate        = 1000;
   
    return true;
end



--�Լ���ִ�е�����������飬�ú��������ڿ�ʼʩ�ż��ܵ�ʱ�򱻵��ã���ȷ���Ƿ����ʩ�Ÿû���
--Player: ����ʩ����
--nPreResult: �������水��һ�������жϵĽ����ע�⣬�����Խű����صĽ��Ϊ׼
function CanCast(player, nPreResult)    
--�ж���ҵ�״̬�����ж��Ƿ���Է�������
    return nPreResult;
end