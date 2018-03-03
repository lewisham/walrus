----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：网络发送请求
----------------------------------------------------------------------

local M = class("SCSend", wls.GameObject)

function M:onCreate()
    self:initSendFunc()
end 

-- 定义SendMsg函数
function M:initSendFunc()
    -- 发送函数
    function wls.SendMsg(id, ...)
        if self[id] == nil then
            print("++++++++++++++++++++++未定义的发送命令   " .. id)
            return
        end
        wls.Invoke(self, id, ...)
    end

    -- 创建子弹id
    function wls.CreateBulletID(cnt)
        return self:getSelfPlayer().id .. cnt
    end
end

-- 发送协议
function M:sendJMsg(name, data)
    if GameClient == nil then return end
    --Log("请求网络消息:" .. name)
    local msg = CLuaMsgHeader.New()
    msg.id = 30
    wls.JMSG:encode(name, msg, data)
    GameClient:SendData(msg)
end

function M:getSelfPlayer()
    return self:find("SCGameClient"):getSelfPlayer()
end

-- 开启心跳包定时器
function M:startHeartBeatTimer()
    local function callback()
        self:sendHeartBeat()
    end
    self:startTimer(2.0, callback, nil, -1)
end

-------------------------------------
-- 网络请求
-------------------------------------

-- 发送准备
function M:sendReady()
    self:sendJMsg("MSGC2SClientReady", {})
end

-- 发送子弹
function M:sendBullet(id, angle, timelineId, fishArrayId)
    local player = self:getSelfPlayer()
    if player == nil then return end
    self.MsgBullet = self.MsgBullet or {}
    local data = self.MsgBullet
    local cannon = self:find("UICannon" .. player.view_id)
    data.bulletId = id
    data.frameId = self:find("SCGameLoop").mClientFrame
    data.angle = 180 - angle
    data.gunRate = cannon:getGunRate()
    data.timelineId = timelineId or 0
    data.fishArrayId = fishArrayId or 0
    data.pointX = 0
    data.pointY = 0
    data.isViolent = false 
    self:sendJMsg("MSGC2SPlayerShoot", data)
end

-- 发送碰撞消息
function M:sendHit(bulletId, fishes, effectFishes)
    self.MsgHit = self.MsgHit or {}
    local data = self.MsgHit
    data.bulletId = bulletId
    data.frameId = self:find("SCGameLoop").mClientFrame
    data.killedFishes = {}
    data.effectedFishes = {}
    for _, fish in ipairs(fishes) do
        local unit = {}
        unit.timelineId = fish:get("timeline_id")
        unit.fishArrayId = fish:get("array_id")
        table.insert(data.killedFishes, unit)
    end
    if effectFishes then
        for _, fish in ipairs(effectFishes) do
            local unit = {}
            unit.timelineId = fish:get("timeline_id")
            unit.fishArrayId = fish:get("array_id")
            table.insert(data.effectedFishes, unit)
        end
    end
    --Log(#data.effectedFishes)
    self:sendJMsg("MSGC2SPlayerHit", data)
end

--锁定变换目标
function M:sendBulletTargetChange(fish)
    self.MsgBulletTC = self.MsgBulletTC or {}
    local data = self.MsgBulletTC
    data.bullets = {}
    data.timelineId = fish:get("timeline_id")
    data.fishArrayId = fish:get("array_id")
    self:sendJMsg("MSGC2SBulletTargetChange", data)
end

-- 申请冰冻
function M:sendFreezeStart(useType)
    local data = 
    {
        useType = useType,
    }
    self:sendJMsg("MSGC2SFreezeStart", data)
end

-- 申请锁定
function M:sendlockFish(timelineId, fishArrayId, useType)
    Log("------------sendlockFish-----------------------")
    self.MsgLockFish = self.MsgLockFish or {}
    local data = self.MsgLockFish
    data.timelineId = timelineId
    data.fishArrayId = fishArrayId
    data.useType = useType
    self:sendJMsg("MSGC2SAim", data)
end

-- 发送心跳消息
function M:sendHeartBeat()
    self.MsgHeartBeat = self.MsgHeartBeat or {}
    local data = self.MsgHeartBeat
    data.frameCount = self:find("SCGameLoop").mClientFrame
    self:sendJMsg("MSGC2SHeartBeat", data)
end

-- 召唤鱼
function M:sendCallFish(useType, cnt)
    self.MsgCallFish = self.MsgCallFish or {}
    local data = self.MsgCallFish
    data.callFishId = cnt
    data.useType = useType
    self:sendJMsg("MSGC2SCallFish", data)
end

--核弹申请使用
function M:sendNBomb(resp)
    self:sendJMsg("MSGC2SNBomb", resp)
end

--核弹爆炸
function M:sendNBombBalst(data)
    self:sendJMsg("MSGC2SNBombBlast", data)
end

--普通场使用狂暴技能
function M:sendUseViolent(useType)
    local data = {
        useType = useType,
    }
    self:sendJMsg("MSGC2SViolent", data)
end

--[[
发送加钱请求
]]
function M:sendAddMoney(data)
    if data == nil then
        return
    end
    self:sendJMsg("MSGC2SSetProp", data)
end

--切换炮倍
function M:sendNewGunRate(gunRate)
    local data = {}
    data.newGunRate = gunRate
    self:sendJMsg("MSGC2SGunRateChange", data)
end

--解锁炮倍申请
function M:sendUpgradeCannon()
    local data = {}
    local ifNotice = FishGI.gameScene.uiSkillView.Skill_17:ifNoticeRate()
    if ifNotice then
        local function callback(sender)
            local tag = sender:getTag()
            if tag == 2 then
                self:sendJMsg("MSGC2SUpgradeCannon", data)
            end
        end
        local str = FishGF.getChByIndex(800000349)
        FishGF.showMessageLayer(FishCD.MODE_MIDDLE_OK_CLOSE,str,callback)
        return
    end

    FishGF.waitNetManager(true,nil,"UpgradeCannon")
    self:sendJMsg("MSGC2SUpgradeCannon", data)
end

--准备申请救济金
function M:sendAlmInfo()
    local data = {}
    self:sendJMsg("MSGC2SAlmInfo", data)
end

--开始申请救济金
function M:sendApplyAlm()
    local data = {}
    self:sendJMsg("MSGC2SApplyAlm", data)
end

--发送开始抽奖
function M:sendStatrLottery(drawGradeId)
    local data = {
        drawGradeId = drawGradeId,
    }
  self:sendJMsg("MSGC2SDraw", data)
end

--发送换炮类型
function M:sendNewGunType(newGunType)
    print("--sendNewGunType-")
    local data = {
        newGunType = newGunType,
    }
  self:sendJMsg("MSGC2SGunTpyeChange", data)
end

--充值成功发送消息
function M:sendReChargeSucceed()
    print("--sendReChargeSucceed--")
    local data = {}
    self:sendJMsg("MSCC2SRechargeSuccess", data)
end

--进入充值界面发送消息使不会被踢
function M:sendGotoCharge()
    print("--sendGotoCharge--")
    local data = {}
    self:sendJMsg("MSGC2SGotoCharge", data)
end

--退出充值界面发送消息
function M:sendBackFromCharge()
    print("--sendBackFromCharge--")
    local data = {}
    self:sendJMsg("MSGC2SBackFromCharge", data)
end

--刷新玩家数据
function M:sendUpDataPlayerData(playerId)
    print("--sendUpDataPlayerData--")
    local data = {
        playerId = playerId,
    }
    self:sendJMsg("MSGC2SGetPlayerInfo", data)
end

-- 显示表示
function M:sendEmotionIcon(emoticonId)
    self.MsgEmotion = self.MsgEmotion or {}
    local data = self.MsgEmotion
    data.emoticonId = emoticonId
    self:sendJMsg("MSGC2SEmoticon", data)
end

--魔法道具
function M:sendMagicProp(magicpropId, toPlayerID)
    self.MsgMagicProp = self.MsgMagicProp or {}
    local data = self.MsgMagicProp
    data.magicpropId = magicpropId
    data.toPlayerID = toPlayerID
    self:sendJMsg("MSGC2SMagicprop", data)
end

--房主踢人
function M:sendFriendKickOut(playerId)
    print("-------sendFriendKickOut-----------")
    local data = 
    {
        playerId = magicpropId,
    }
    self:sendJMsg("MSGC2SFriendKickOut", data)
end

--发送vip每日领取
function M:sendGetVipDailyReward(tabVal)
    self:sendJMsg("MSGC2SGetVipDailyReward", tabVal)
end

--开启时光沙漏
function M:sendToStartTimeHourglass(tabVal)
    print("-------sendToStartTimeHourglass-----------")
    Log(tabVal)
    self:sendJMsg("MSGC2SUseTimeHourglass", tabVal)
end

--停止时光沙漏
function M:sendToStopTimeHourglass(tabVal)
    self:sendJMsg("MSGC2SStopTimeHourglass", tabVal)
end

--继续时光沙漏
function M:sendToContinueTimeHourglass(tabVal)
    self:sendJMsg("MSGC2SContinueTimeHourglass", tabVal)
end

--获取新手任务信息
function M:sendGetNewTaskInfo()
    Log("M:sendGetNewTaskInfo")
    self:sendJMsg("MSGC2SGetNewTaskInfo", {})
end

--领取新手任务奖励
function M:sendGetNewTaskReward(nTaskID)
    Log("M:GetNewTaskReward")
    local data = {
        nTaskID = nTaskID
    }
    self:sendJMsg("MSGC2SGetNewTaskReward", data)
end

--使用限时炮台
function M:sendUsePropCannon(useType,propID)
    print("--sendUsePropCannon--")
    FishGF.waitNetManager(true,nil,"UsePropCannon")
    local data = {
        useType = useType,
        propID = propID,        
    }
    self:sendJMsg("MSGC2SUsePropCannon", data)
end

function M:sendSetViolentRate(rate)
    local data = {
        nRatio = rate
    }
    self:sendJMsg("MSGC2SSetViolentRatio", data)
end

--发送锻造请求
function M:sendForgedReq(useCrystalPower)
    FishGF.waitNetManager(true,nil,"MSGC2SForge")
    local data = {
        useCrystalPower = useCrystalPower,
    }
    self:sendJMsg("MSGC2SForge", data)
end


return M