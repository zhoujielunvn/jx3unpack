--������Ե������� ǧ������ һͳ����
--�书����
--NPC����-����ӳ���Ͷ������
--����Ч����˵������Ŀ��һ��Debuff
--���� 2007-4-6

--------------�Ҳ��Ƿָ���----------------------------------------------------

tSkillData =
{
   {nCostMana = 15, nDebuffID = 455, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024}, 
	 {nCostMana = 15, nDebuffID = 456, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024}, 
	 {nCostMana = 15, nDebuffID = 457, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
	 {nCostMana = 15, nDebuffID = 458, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
   {nCostMana = 15, nDebuffID = 459, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
	 {nCostMana = 15, nDebuffID = 457, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
	 {nCostMana = 15, nDebuffID = 458, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
   {nCostMana = 15, nDebuffID = 459, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
	 {nCostMana = 15, nDebuffID = 457, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
	 {nCostMana = 15, nDebuffID = 458, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
   {nCostMana = 15, nDebuffID = 459, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
	 {nCostMana = 15, nDebuffID = 460, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
	 {nCostMana = 15, nDebuffID = 460, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
	 {nCostMana = 15, nDebuffID = 460, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
	 {nCostMana = 15, nDebuffID = 468, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},
};

Include("scripts/Include/Skill.lh")
--�����滻skill�ű�Include("scripts/Include/Player.lh")

--�����书���������ֵ
function GetSkillLevelData(skill)
    
	local dwSkillLevel = skill.dwLevel;
--����Debuff---------	

	skill.AddAttribute(
        ATTRIBUTE_EFFECT_MODE.EFFECT_TO_DEST_NOT_ROLLBACK, 
        ATTRIBUTE_TYPE.CALL_BUFF, 
        tSkillData[dwSkillLevel].nDebuffID,
        1
    );
	
	
	
--����cool down------

--SetPublicCoolDown(id)���ù���CD��SetNormalCoolDown(posi, id)���ü���CD������posiΪCoolDownλ(��3λ)��id��Ҫ��CoolDownList.tab----------------

     --skill.SetNormalCoolDown(1,7);
	
--������������-------
  
    --��������
    skill.nCostMana         = tSkillData[dwSkillLevel].nCostMana;
    --�����뾶��Ҳ���ǹ�������Ч����
    skill.nMaxRadius        = tSkillData[dwSkillLevel].nMaxRadius * LENGTH_BASE;
    skill.nAngleRange       = tSkillData[dwSkillLevel].nAngleRange; 
    --����֡��
    skill.nPrepareFrames    = tSkillData[dwSkillLevel].nPrepareFrames;
    --�ӵ��ٶ�
    skill.nBulletVelocity   = tSkillData[dwSkillLevel].nBulletVelocity;
    --����ϵĸ���
    skill.nBreakRate        = tSkillData[dwSkillLevel].nBreakRate;
   
    return true;
end

function CanLearnSkill(skill, player)
	return true
end

function OnSkillLevelUp(skill, player)
end



--�Լ���ִ�е�����������飬�ú��������ڿ�ʼʩ�ż��ܵ�ʱ�򱻵��ã���ȷ���Ƿ����ʩ�Ÿû���
--npc: ����ʩ����
--nPreResult: �������水��һ�������жϵĽ����ע�⣬�����Խű����صĽ��Ϊ׼
function CanCast(npc, nPreResult)    
--�ж���ҵ�״̬�����ж��Ƿ���Է�������
    return nPreResult;
end

