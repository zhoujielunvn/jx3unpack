--剑侠情缘网络版三 千秋万载 一统江湖
--武功技能
--NPC技能-民兵队长的投毒能力
--技能效果简单说明：给目标一个Debuff
--刘欣 2007-4-6

--------------我不是分割线----------------------------------------------------

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
--批量替换skill脚本Include("scripts/Include/Player.lh")

--设置武功技能相关数值
function GetSkillLevelData(skill)
    
	local dwSkillLevel = skill.dwLevel;
--设置Debuff---------	

	skill.AddAttribute(
        ATTRIBUTE_EFFECT_MODE.EFFECT_TO_DEST_NOT_ROLLBACK, 
        ATTRIBUTE_TYPE.CALL_BUFF, 
        tSkillData[dwSkillLevel].nDebuffID,
        1
    );
	
	
	
--设置cool down------

--SetPublicCoolDown(id)设置公共CD，SetNormalCoolDown(posi, id)设置技能CD，其中posi为CoolDown位(共3位)，id需要查CoolDownList.tab----------------

     --skill.SetNormalCoolDown(1,7);
	
--设置其他参数-------
  
    --内力消耗
    skill.nCostMana         = tSkillData[dwSkillLevel].nCostMana;
    --攻击半径，也就是攻击的有效距离
    skill.nMaxRadius        = tSkillData[dwSkillLevel].nMaxRadius * LENGTH_BASE;
    skill.nAngleRange       = tSkillData[dwSkillLevel].nAngleRange; 
    --吟唱帧数
    skill.nPrepareFrames    = tSkillData[dwSkillLevel].nPrepareFrames;
    --子弹速度
    skill.nBulletVelocity   = tSkillData[dwSkillLevel].nBulletVelocity;
    --被打断的概率
    skill.nBreakRate        = tSkillData[dwSkillLevel].nBreakRate;
   
    return true;
end

function CanLearnSkill(skill, player)
	return true
end

function OnSkillLevelUp(skill, player)
end



--对技能执行的特殊条件检查，该函数可以在开始施放技能的时候被调用，以确定是否可以施放该机能
--npc: 技能施放者
--nPreResult: 程序里面按照一般流程判断的结果，注意，最终以脚本返回的结果为准
function CanCast(npc, nPreResult)    
--判断玩家的状态，以判断是否可以发出技能
    return nPreResult;
end


