----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：网络发送请求
----------------------------------------------------------------------

local M = class("SCSend", u3a.GameObject)

function M:onCreate()
    self:initSendFunc()
end 

function M:initSendFunc()
    local function sendFunc(id, ...)
        if self[id] == nil then
            print("++++++++++++++++++++++未定义的发送命令   " .. id)
            return
        end
        u3a.Invoke(self, id, ...)
    end
    u3a.SendMsg = sendFunc
end

function M:sendJMsg(name, data)
    --设置发送消息的标识 判断断线的时候用
    local encoded, len = jmsg.encodeBinary(proto, name, data)
    local msg = CLuaMsgHeader.New()
    msg.id = self.msg.HEAD.MSG_C2S_JMSG
--    print("encoded len="..len)
    msg:WriteData(encoded, len)
    
    self:SendData(msg)
    jmsg.freeBinary(encoded)
end

-------------------------------------
-- 网络请求
-------------------------------------

function  M:sendClientReadyMessage()
    self:sendJMsg("MSGC2SClientReady", {})
end

-- 发送子弹
function M:sendBullet(bulletId, frameId, angle, gunRate,timelineId,fishArrayId,posx, posy, isViolent)
    angle = FishGF.getStandardAngle(angle)
    local scaleX_,scaleY_,scaleMin_  = FishGF.getCurScale()
    posx = posx/scaleX_
    posy = posy/scaleY_
    if FishGI.isPlayerFlip then
        local winSize = cc.Director:getInstance():getWinSize();
        local cfg_ds= CC_DESIGN_RESOLUTION
        posx = cfg_ds.width-posx;
        posy = cfg_ds.height-posy;
    end

    local data = {}
    data.bulletId = bulletId;
    --data.frameId = frameId;
    data.angle = angle;
    data.gunRate = gunRate;
    data.timelineId = timelineId;
    data.fishArrayId = fishArrayId;
    data.pointX = posx;
    data.pointY = posy;
    data.isViolent = isViolent
    
    self:sendJMsg("MSGC2SPlayerShoot", data)
end

--锁定变换目标
function M:sendBulletTargetChange(data)
    if data == nil then
        return
    end
    self:sendJMsg("MSGC2SBulletTargetChange", data)
end

--申请冰冻
function  M:sendFreezeStart(useType)
    local data = {
        useType = useType,
    }
    self:sendJMsg("MSGC2SFreezeStart", data)
end

--申请锁定
function  M:sendlockFish(timelineId,fishArrayId,useType)
    local data = {
        timelineId = timelineId,
        fishArrayId = fishArrayId,
        useType = useType,
    }
    self:sendJMsg("MSGC2SAim",data)
end

--[[
发送心跳消息
frameCount:客户端帧号
]]
function M:sendHeartBeat(localFrameCount)
    local data = {
        frameCount = localFrameCount
    }
    self.isSend = true;
    self:sendJMsg("MSGC2SHeartBeat", data)
end

--[[
发送碰撞消息
]]
function M:sendHit(bulletId, frameId, fishes, effectedFishes)
    local data = {
        bulletId = bulletId,
        frameId = frameId,
        killedFishes = fishes,
        effectedFishes = effectedFishes,
    }
  self:sendJMsg("MSGC2SPlayerHit", data)
end

--召唤鱼
function M:sendCallFish(fishId, useType)
    local data = {
        callFishId = fishId,
        useType = useType,
    }
    self:sendJMsg("MSGC2SCallFish", data)
end

--核弹申请使用
function M:sendNBomb(id, pos, useType)
    local data = {
        pointX = pos.x,
        pointY = pos.y,
        nBombId = FishGI.nbombCount,
        useType = useType,
        nPropID = id,
    }
    self:sendJMsg("MSGC2SNBomb", data)
    FishGI.nbombCount = FishGI.nbombCount+1;
end

--核弹爆炸
function M:sendNBombBalst(id, killedFishes)
    local data = {
        killedFishes = killedFishes,
        nBombId = id,
    }
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
        FishGF.showMessageLayer(FishCD.MODE_MIDDLE_OK_CLOSE,str,callback);
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

--显示表示
function M:sendEmotionIcon(emoticonId)
    local data = 
    {
        emoticonId = emoticonId,
    }
    self:sendJMsg("MSGC2SEmoticon", data)
end

--魔法道具
function M:sendMagicProp(magicpropId, toPlayerID)
    local data = 
    {
        magicpropId = magicpropId,
        toPlayerID = toPlayerID,
    }
    self:sendJMsg("MSGC2SMagicprop", data)
end

--发送vip每日领取
function M:sendGetVipDailyReward(tabVal)
    self:sendJMsg("MSGC2SGetVipDailyReward", tabVal)
end

--开启时光沙漏
function M:sendToStartTimeHourglass(tabVal)
    self:sendJMsg("MSGC2SUseTimeHourglass", tabVal)
end

--停止时光沙漏
function M:sendToStopTimeHourglass(tabVal)
    log("M:sendToStopTimeHourglass")
    self:sendJMsg("MSGC2SStopTimeHourglass", tabVal)
end

--继续时光沙漏
function M:sendToContinueTimeHourglass(tabVal)
    log("M:sendToContinueTimeHourglass")
    self:sendJMsg("MSGC2SContinueTimeHourglass", tabVal)
end

--获取新手任务信息
function M:sendGetNewTaskInfo(tabVal)
    log("M:sendGetNewTaskInfo")
    self:sendJMsg("MSGC2SGetNewTaskInfo", tabVal)
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

--领取新手任务奖励
function M:GetNewTaskReward(tabVal)
    log("M:GetNewTaskReward")
    self:sendJMsg("MSGC2SGetNewTaskReward", tabVal)
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