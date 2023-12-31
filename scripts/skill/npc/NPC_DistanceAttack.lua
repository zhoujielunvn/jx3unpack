--剑侠情缘网络版三 千秋万载 一统江湖
--武功技能
--NPC-普通攻击
--技能效果简单说明：NPC普通攻击技能
--刘欣	2007-5-23

--------------厚道的分割线-----------------------------------------------------
Include("scripts/Include/Skill.lh")
--批量替换skill脚本Include("scripts/Include/Player.lh")

--设置武功技能级别相关数值
function GetSkillLevelData(skill)

	local bRetCode     = false;
	
	skill.AddAttribute(
        ATTRIBUTE_EFFECT_MODE.EFFECT_TO_DEST_NOT_ROLLBACK, 
        ATTRIBUTE_TYPE.CALL_PHYSICS_DAMAGE, 
        0, 
        0
    );

    ----------------- 设置杂项参数 ----------------------------------------
   
    --攻击半径，也就是攻击的有效距离
    skill.nMaxRadius        = 20.0 * LENGTH_BASE;
    skill.nAngleRange       = 128; 
   
    return true;
end



--对技能执行的特殊条件检查，该函数可以在开始施放技能的时候被调用，以确定是否可以施放该机能
--Player: 技能施放者
--nPreResult: 程序里面按照一般流程判断的结果，注意，最终以脚本返回的结果为准
function CanCast(player, nPreResult)    
--判断玩家的状态，以判断是否可以发出技能
    return nPreResult;
end
