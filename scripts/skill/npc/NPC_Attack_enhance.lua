--剑侠情缘网络版三 千秋万载 一统江湖
--武功技能
--NPC技能-直接伤害
--技能效果简单说明：直接伤害
--刘欣 2007-4-6

--------------我不是分割线----------------------------------------------------

tSkillData =
{
         {nCostMana = 15, nAPAdd = 200, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC  万花麋鹿、万花仙鹿                       挑刺
	 {nCostMana = 15, nAPAdd = 28, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC  残暴的聋哑人                                   丧心病狂
	 {nCostMana = 15, nAPAdd = 20, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 15, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC  蓬莱青女、蓬莱紫女                        飞刀
	 {nCostMana = 15, nAPAdd = 23, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC  方诗玉                                                冲穴掌
	 {nCostMana = 15, nAPAdd = 23, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC  方诗玉                                                冲穴掌
	 {nCostMana = 15, nAPAdd = 23, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC  方诗玉                                                冲穴掌
	 {nCostMana = 15, nAPAdd = 23, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC  方诗玉                                                冲穴掌
	 {nCostMana = 15, nAPAdd = 23, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC  方诗玉                                                冲穴掌
	 {nCostMana = 15, nAPAdd = 23, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC  方诗玉                                                冲穴掌
     {nCostMana = 15, nAPAdd = 11, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 15, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC  灵猴、花猴                                        石块驱逐
	 {nCostMana = 15, nAPAdd = 50, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC  虚子鳄                                                凶咬
	 {nCostMana = 15, nAPAdd = 50, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC 上古甲兽、龙骨甲兽                         龙兽吐息
	 {nCostMana = 15, nAPAdd = 10, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC 傀儡铁颅、炽焰铁颅                         沉重打击
	 {nCostMana = 15, nAPAdd = 117, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 128, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--万花NPC 忍术·荒武刀的反击
	 {nCostMana = 0, nAPAdd = 100, nDamageRand = 5, nMinRadius = 0, nMaxRadius = 5, nAngleRange = 256, nPrepareFrames = 0, nBulletVelocity = 0, nBreakRate = 1024},--纯阳NPC 纯阳蚀风散 
	 
};

Include("scripts/Include/Skill.lh")
--批量替换skill脚本Include("scripts/Include/Player.lh")

--设置武功技能相关数值
function GetSkillLevelData(skill)
    
	local dwSkillLevel = skill.dwLevel;
--设置伤害---------	

	skill.AddAttribute(
        ATTRIBUTE_EFFECT_MODE.EFFECT_TO_SELF_AND_ROLLBACK, 
        ATTRIBUTE_TYPE.SKILL_PHYSICS_DAMAGE, 
        tSkillData[dwSkillLevel].nAPAdd,
        0
    );
	
	skill.AddAttribute(
        ATTRIBUTE_EFFECT_MODE.EFFECT_TO_SELF_AND_ROLLBACK, 
        ATTRIBUTE_TYPE.SKILL_PHYSICS_DAMAGE_RAND,
        tSkillData[dwSkillLevel].nDamageRand, 
        0
    );

	skill.AddAttribute(
        ATTRIBUTE_EFFECT_MODE.EFFECT_TO_DEST_NOT_ROLLBACK, 
        ATTRIBUTE_TYPE.CALL_PHYSICS_DAMAGE, 
        0,
        0
    );
	
	if skill.dwLevel == 4 then
	skill.AddAttribute(
        ATTRIBUTE_EFFECT_MODE.EFFECT_TO_DEST_NOT_ROLLBACK, 
        ATTRIBUTE_TYPE.CALL_BUFF, 
        461,--减速DEBUFF
        1
    );
	end
	
	if skill.dwLevel == 7 then
	skill.AddAttribute(
        ATTRIBUTE_EFFECT_MODE.EFFECT_TO_DEST_NOT_ROLLBACK, 
        ATTRIBUTE_TYPE.CALL_BUFF, 
        642,--龙兽吐息的DOT
        1
    );
	end
	
	if skill.dwLevel == 8 then
	skill.AddAttribute(
        ATTRIBUTE_EFFECT_MODE.EFFECT_TO_DEST_NOT_ROLLBACK, 
        ATTRIBUTE_TYPE.CALL_BUFF, 
        464,--击晕DEBUFF
        1
    );
	end
	
--设置cool down------

--SetPublicCoolDown(id)设置公共CD，SetNormalCoolDown(posi, id)设置技能CD，其中posi为CoolDown位(共3位)，id需要查CoolDownList.tab----------------

     --skill.SetNormalCoolDown(1,7);
	
--设置其他参数-------
  
    --内力消耗
    skill.nCostMana         = tSkillData[dwSkillLevel].nCostMana;
    --攻击半径，也就是攻击的有效距离
    skill.nMaxRadius        = tSkillData[dwSkillLevel].nMaxRadius * LENGTH_BASE;
	skill.nMinRadius        = tSkillData[dwSkillLevel].nMinRadius * LENGTH_BASE;
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


