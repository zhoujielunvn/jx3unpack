-- 小游戏创建初始化函数
function OnMiniGameCreate(nPlayerCount)
    Log(string.format("[OnMiniGameCreate] nPlayerCount: %d", nPlayerCount))
    local bRetCode = false
    local Mgr = GetMiniGameMgr()

    if Mgr == nil then
        return false
    end

    bRetCode = Mgr.SetPublicData(MINI_GAME_DATA_SIZE.BOOL, 0, 1)
    Log(string.format("[OnMiniGameCreate] SetPublicDataBOOL: %d", bRetCode))

    bRetCode = Mgr.SetPublicData(MINI_GAME_DATA_SIZE.BYTE, 1, 5)
    Log(string.format("[OnMiniGameCreate] SetPublicDataByte: %d", bRetCode))
    
    bRetCode = Mgr.SetPublicData(MINI_GAME_DATA_SIZE.SHORT, 2, 78)
    Log(string.format("[OnMiniGameCreate] SetPublicDataShort: %d", bRetCode))

    bRetCode = Mgr.SetPublicData(MINI_GAME_DATA_SIZE.INT, 3, 996, 4, 9106)
    Log(string.format("[OnMiniGameCreate] SetPublicDataInt: %d", bRetCode))

    bRetCode = Mgr.SetTimer(300, 1, 2)

    for i = 0, nPlayerCount - 1 do
        Log(string.format("[OnMiniGameCreate] SetPlayerOperateCount %d", i))
        Mgr.ChangePlayerOperateCount(i, 1)
    end

    return true
end

-- 小游戏服务端收到操作
function OnServerOperate(nPlayer, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)
    Log(string.format("[OnServerOperate] nPlayer: %d nValue1: %d nValue2: %d nValue3: %d nValue4: %d", nPlayer, nValue1, nValue2, nValue3, nValue4))

    Log(string.format("[OnServerOperate] SetPlayerOperateCount %d", nPlayer))
    local Mgr = GetMiniGameMgr()
    if Mgr == nil then
        return false
    end

    Mgr.ChangePlayerOperateCount(nPlayer, 1)

    bRetCode = Mgr.SetPlayerData(nPlayer, MINI_GAME_DATA_SIZE.BOOL, 0, 1)
    Log(string.format("[OnServerOperate] SetPlayerDataBOOL: %d PlayerIndex: %d", bRetCode, nPlayer))

    bRetCode = Mgr.SetPlayerData(nPlayer, MINI_GAME_DATA_SIZE.BYTE, 1, 5)
    Log(string.format("[OnServerOperate] SetPlayerDataByte: %d PlayerIndex: %d", bRetCode, nPlayer))
    
    bRetCode = Mgr.SetPlayerData(nPlayer, MINI_GAME_DATA_SIZE.SHORT, 2, 78)
    Log(string.format("[OnServerOperate] SetPlayerDataShort: %d PlayerIndex: %d", bRetCode, nPlayer))

    bRetCode = Mgr.SetPlayerData(nPlayer, MINI_GAME_DATA_SIZE.INT, 3, 996, 4, 9106)
    Log(string.format("[OnServerOperate] SetPlayerDataInt: %d PlayerIndex: %d", bRetCode, nPlayer))

    Mgr.Operate(-1, 1, 2, 3, 4)        --广播
    Mgr.Operate(nPlayer, 2, 4, 6, 8)  --单人
end

-- 小游戏服务端收到不自动扣除计数的操作
function OnNoCostOperate(nPlayer, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)
    Log(string.format("[OnNoCostOperate] nPlayer: %d nValue1: %d nValue2: %d nValue3: %d nValue4: %d", nPlayer, nValue1, nValue2, nValue3, nValue4))
    return true
end

-- 小游戏服务端收到不校验数据不扣除计数的操作
function OnNoCheckOperate(nPlayer, nValue1, nValue2, nValue3, nValue4, nValue5, nValue6)
    Log(string.format("[OnNoCheckOperate] nPlayer: %d nValue1: %d nValue2: %d nValue3: %d nValue4: %d", nPlayer, nValue1, nValue2, nValue3, nValue4))
    return true
end

function OnMiniGameTimer(nValue1, nValue2)
    Log(string.format("[OnMiniGameTimer] nValue1: %d nValue2: %d", nValue1, nValue2))
    local Mgr = GetMiniGameMgr()
    if Mgr == nil then
        return false
    end

    local value = nil
    value = Mgr.GetPublicData(MINI_GAME_DATA_SIZE.BOOL, 0)
    if value ~= nil then
        Log(string.format("[OnMiniGameTimer] GetPublicDataBOOL: %d", value[1]))
    end

    value = Mgr.GetPublicData(MINI_GAME_DATA_SIZE.BYTE, 1)
    if value ~= nil then
        Log(string.format("[OnMiniGameTimer] GetPublicDataByte: %d", value[1]))
    end
    
    value = Mgr.GetPublicData(MINI_GAME_DATA_SIZE.SHORT, 2)
    if value ~= nil then
        Log(string.format("[OnMiniGameTimer] GetPublicDataShort: %d", value[1]))
    end

    value = Mgr.GetPublicData(MINI_GAME_DATA_SIZE.INT, 3, 4)
    if value ~= nil then
        Log(string.format("[OnMiniGameTimer] GetPublicDataInt: %d %d", value[1], value[2]))
    end

    Mgr.EndGame()

end

function OnMiniGameEndGame()
end