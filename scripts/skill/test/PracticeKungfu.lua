--剑侠情缘网络版三 千秋万载 一统江湖
--武功技能
--测试武功-练功
--技能效果简单说明：对ID10000号技能进行练习
--王洋 2007-03-12

--------------厚道的分割线-----------------------------------------------------
Include("scripts/Include/Skill.lh")
--批量替换skill脚本Include("scripts/Include/Player.lh")


--设置武功技能级别相关数值
function GetSkillLevelData(skill)

    local bRetCode     = false;
    local dwSkillLevel = skill.dwLevel;
	
    --skill.AddAttribute(
        --ATTRIBUTE_EFFECT_MODE.EFFECT_TO_SELF_NOT_ROLLBACK, 
        --ATTRIBUTE_TYPE.PRACTICE_KUNG_FU, 
        --10000,
        --0
    --);
	

    ----------------- 设置杂项参数 ----------------------------------------
   
    --攻击半径，也就是攻击的有效距离
    skill.nMaxRadius        = 96;
    skill.nAngleRange       = 128; 
    skill.nChannelInterval    = 240;
	skill.nChannelFrame		= 9600;
   
    return true;
end



--对技能执行的特殊条件检查，该函数可以在开始施放技能的时候被调用，以确定是否可以施放该机能
--Player: 技能施放者
--nPreResult: 程序里面按照一般流程判断的结果，注意，最终以脚本返回的结果为准
function CanCast(player, nPreResult)    
--判断玩家的状态，以判断是否可以发出技能
    return nPreResult;
end

function CanLearnSkill(skill, player)
	return true
end

function OnSkillLevelUp(skill, player)
end
