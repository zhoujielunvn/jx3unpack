function Load()
    local param = GetSkillGlobalParam()
	param.fPlayerCriticalCof			= 0.75
    param.fCriticalStrikeParam          = 9.530 
    param.fCriticalStrikePowerParam     = 3.335 
    param.fDefCriticalStrikeParam       = 9.530
    param.fDecriticalStrikePowerParam   = 1.380 
    param.fHitValueParam                = 6.931 
    param.fDodgeParam                   = 3.703
    param.fParryParam                   = 4.345
    param.fInsightParam                 = 9.189
    param.fPhysicsShieldParam           = 5.091 
    param.fMagicShieldParam             = 5.091
	param.fOvercomeParam         		= 9.530
	param.fHasteRate                    = 11.695
    param.fToughnessDecirDamageCof		= 2.557
    param.fSurplusParam                 = 13.192
    param.fAssistedPowerCof             = 9.53

    Log("[Skill]Global Param Init Successful.")
end
