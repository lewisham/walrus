----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：网络接收处理
----------------------------------------------------------------------

local M = class("SCRecv", wls.GameObject)

function M:onCreate()
    self:set("start_process", false)
end 

function M:doHandleMsg(id, resp)
    if id == "MSGS2CGameStatus" then
        wls.Invoke(self, id, resp)
        return
    end
    if not self:get("start_process") then return end
    if self[id] == nil then
        print("++++++++++++++++++++++未处理的消息协议   " .. id)
        return
    end
    wls.Invoke(self, id, resp)
end

function M:getPlayer(id)
    return self:find("SCGameClient"):getPlayer(id)
end

-------------------------------------
-- 协议处理
-------------------------------------

-- 进入游戏初始化
function M:MSGS2CGameStatus(resp)
    self:set("start_process", true)
    print("+++++++++++++++++++开启游戏")
    for _, val in pairs(resp.playerInfos) do
        self:MSGS2CPlayerJion(val)
    end
    resp.playerInfos = nil
    Log(resp)
    self:find("SCGameLoop"):setClientFrame(resp.frameId)
    self:find("SCPool"):setKilledFishes(resp.killedFishes)
    --resp.isInGroup = true
    if resp.isInGroup then
        self:find("SCPool"):createFishGroup(resp.timelineIndex, 1)
    else
        self:find("SCPool"):createTimeLine(resp.timelineIndex, resp.frameId, false)
        self:find("SCPool"):createTimeLine(resp.timelineIndex, resp.frameId, true)
    end
    self:find("SCGameLoop"):set("timeline_idx", resp.timelineIndex)

    --处理时光沙漏
    local temData = {}
    for k,v in pairs(resp.inTimeHourGlass) do
        local player = self:getPlayer(v)
        if player == nil then return end
        if player.is_self then
            self:find("SKTimeRevert"):continueCheck()
        else
            temData.isSuccess = true
            temData.playerID = v
            temData.nTimeRemain = 300
            temData.nFishIcon = 1
            self:MSGS2CContinueTimeHourglass(temData)
        end

    end


end

-- 玩家加入 
function M:MSGS2CPlayerJion(resp)
    if resp.playerInfo then resp = resp.playerInfo end
    --Log(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    resp.is_self = player.is_self
    resp.chairid = player.chairid
    resp.view_id = player.view_id
    player.playerInfo = resp
    self:find("UIBackGround"):showWaiting(resp.view_id, false)
    local cannon = self:find("UICannon" .. resp.view_id)
    cannon:reset()
    cannon.maxGunRate = resp.maxGunRate
    cannon:join(resp.is_self)
    cannon:updateGun(resp.gunType)
    cannon:find("SCPool"):createBulletPool(cannon.config.id)
    cannon:setCoin(resp.fishIcon)
    cannon:setGem(resp.crystal)
    cannon:setGunRate(resp.currentGunRate)
    if resp.is_self then
        self:find("UITouch"):setTouchEnabled(true)
        self:find("DAPlayer"):updateData(resp)
        self:find("UISkillPanel"):updateBtnIsCanUse()
    end
end

function M:MSGPlayerInfo(resp)
    Log(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    local cannon = self:find("UICannon" .. player.view_id)
    cannon.fnt_coins:setString(resp.fishIcon)
    cannon.fnt_diamonds:setString(resp.crystal)
end

-- 心跳包
function M:MSGS2CHeartBeat(resp)
    if not self:get("start_process") then return end
    self:find("SCGameLoop"):syncFrame(resp.frameCount)
end

-- 玩家射击
function M:MSGS2CPlayerShoot(resp)
    --Log(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    if player.is_self then return end
    local fish = nil 
    if resp.timelineId ~= 0 and resp.fishArrayId ~= 0 then
        fish = self:find("SCPool"):findFish(resp.timelineId, resp.fishArrayId)
    end
    self:find("SCPool"):setFollowFish(player.view_id, fish)
    local duration = 0 -- resp.frameId - self:find("SCGameLoop").mClientFrame * 0.05
    local cannon = self:find("UICannon" .. player.view_id)
    cannon:fire(resp.bulletId, resp.angle, fish, duration)
    local cost = (resp.isViolent and resp.gunRate*resp.nViolentRatio or resp.gunRate)
    cannon:opCoin(-cost)
end

-- 击中鱼
function M:MSGS2CPlayerHit(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    if #resp.killedFishes == 0 then return end
    local go = self:find("SCPool")
    local fish = nil
    --Log(resp)
    local dropPos = cc.p(0,0)
    for _, val in ipairs(resp.killedFishes) do
        fish = go:killFish(val.timelineId, val.fishArrayId)
        if fish then
            dropPos = cc.p(fish:getPositionX(),fish:getPositionY())
            local score = resp.gunRate * tonumber(fish.config.score)
            self:find("UIEffect"):playFishDeadEff(fish, player.view_id, score)
        end
    end
    self:find("EFLighting"):endLighting()
    --处理掉落
    self:find("UIPropMgr"):playHitDropProp(resp.playerId,resp.dropProps,resp.dropCrystal,dropPos)
end

-- 改变炮的倍率
function M:MSGS2CGunRateChange(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    local cannon = self:find("UICannon" .. player.view_id)
    cannon:updateGunRate(resp.newGunRate)
end

-- 改变炮的类型
function M:MSGS2CGunTpyeChange(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil or not resp.isSuccess then return end
    local cannon = self:find("UICannon" .. player.view_id)
    cannon:updateGun(resp.newGunType)
end

--------------------------------
-- 技能逻辑
--------------------------------

-- 请求冰冻技能结果
function M:MSGS2CFreezeResult(resp)
    if not resp.isSuccess then
        self:find("UISkillPanel"):onStopTimer(3)
        return
    end
    self:find("UISkillPanel"):onRunTimer(3)
    self:find("SKFreeze"):releaseSkill()
end

-- 开始冰冻技能
function M:MSGS2CFreezeStart(resp)
    self:find("SKFreeze"):releaseSkill()
end

-- 结束冰冻技能
function M:MSGS2CFreezeEnd(resp)
    self:find("SKFreeze"):stopSkill()
end

-- 锁定技能
function M:MSGS2CAimResult(resp)
    if not resp.isSuccess then return end
    self:find("UISkillPanel"):onRunTimer(4)
    self:find("SKLockTarget"):releaseSkill(resp.skillPlus)
end

-- 别人锁定技能
function M:MSGS2CAim(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    Log("----------------MSGS2CAim----别人锁定---------")
end

-- 锁定跟踪目标改变
function M:MSGS2CBulletTargetChange(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    if player.is_self then return end
    local fish = self:find("SCPool"):findFish(resp.timelineId, resp.fishArrayId)
    self:find("SCPool"):setFollowFish(player.view_id, fish)
end

-- 开启狂暴
function M:MSGS2CViolent(resp)
    --Log(resp)
    if not resp.isSuccess then return end
    local player = self:getPlayer(resp.playerID)
    if player == nil then return end
    if player.is_self then 
        self:find("SKViolent"):releaseSkill(100)
    end
    
    local cannon = self:find("UICannon" .. player.view_id)
    cannon:playViolentAct()
end

-- 狂暴结束
function M:MSGS2CViolentTimeOut(resp)
    Log(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    self:find("SKViolent"):stopPlayerSkill(player.view_id)
end

function M:MSGS2CSetViolentRatio(resp)
    if not resp.isSuccess then
        Log("--------MSGS2CSetViolentRatio-----玩家切换倍率失败---------")
        self:find("UISkillPanel"):setViolentRate(resp.nRatio)
    end
end

-- 召唤鱼
function M:MSGS2CCallFish(resp)
    --Log(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    if not resp.isSuccess then 
        if resp.failType == 1 then
            local function callback(ret)
                if ret == 1 then 
                    print("--吊起商店--")
                end
            end
            wls.Dialog(3,self:find("SCConfig"):getLanguageByID(800000087),callback)
        elseif resp.failType == 2 then
            wls.Dialog(1,self:find("SCConfig"):getLanguageByID(800000109))
        end
        return 
    end
    local args = {}
    args.array_id = resp.callFishId
    args.id = tostring(resp.fishId)
    --args.id = "100000158"
    args.path_id = tostring(resp.pathId)
    args.cur_frame = resp.frameId
    args.timeline_id = -resp.playerId
    self:find("SCGameLoop"):addCallFish(args)
    resp.view_id = player.view_id
    resp.args = args
    self:find("SKSummon"):releaseSkill(resp)
    self:find("UISkillPanel"):onRunTimer(5)
end

-- 开启时光沙漏
function M:MSGS2CUseTimeHourglass(resp)
    local player = self:getPlayer(resp.playerID)
    if player == nil then return end

    if not resp.isSuccess then
        if player.is_self then
            self:find("UISkillPanel"):onStopTimer(14)
        end
        return 
    end

    resp.view_id = player.view_id
    self:find("SKTimeRevert"):releaseSkill(resp)

    if not player.is_self then
        --扣掉别人的钱
        return 
    end

    --扣掉自己的钱

    --播放特效
    self:find("UISkillPanel"):onRunTimer(14)
    self:find("UISkillPanel"):setState(14,2)


end

-- 停止时光沙漏
function M:MSGS2CStopTimeHourglass(resp)
    local player = self:getPlayer(resp.playerID)
    if player == nil then return end

    if not resp.isSuccess then
        Log("----------------MSGS2CStopTimeHourglass faile--------------")
        return 
    end

    resp.view_id = player.view_id
    self:find("SKTimeRevert"):stopSkill(resp)

    if not player.is_self then
        --设置别人的钱
        Log("-----------set other player fish money-------------")
        return 
    end
    self:find("UISkillPanel"):onStopTimer(14)
    self:find("UISkillPanel"):setState(14,1)

end

-- 继续时光沙漏
function M:MSGS2CContinueTimeHourglass(resp)
    local player = self:getPlayer(resp.playerID)
    if player == nil then return end

    if not resp.isSuccess then
        if player.is_self then
            self:find("UISkillPanel"):onStopTimer(14)
        end
        return 
    end

    resp.view_id = player.view_id
    self:find("SKTimeRevert"):continueSkill(resp)

    if not player.is_self then
        return 
    end

    --播放特效
    self:find("UISkillPanel"):setState(14,2)

end

--申请核弹结果
function M:MSGS2CNBomb( resp )
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end

    if not resp.isSuccess then
        if player.is_self then
            self:find("UISkillPanel"):onStopTimer(resp.nPropID)
        end
        return 
    end
    resp.view_id = player.view_id
    self:find("SKBomb"):releaseSkill(resp)

end

--核弹爆炸结果
function M:MSGS2CNBombBlast( resp )
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end

    if not resp.isSuccess then
        Log("---------MSGS2CNBombBlast-----is faile-------")
        return 
    end
    self:MSGS2CPlayerHit(resp)

    --扣个数或水晶

    -- if player.view_id ~= wls.SelfViewID then
    --     return
    -- end

    -- resp.view_id = player.view_id


end

--------------------------------
-- 鱼线
--------------------------------

-- 鱼潮来临提示
function M:MSGS2CFishGroupNotify(resp)
    local function callback()
        self:createGameObject("UIGroupComing"):play()
        local go = self:find("SCPool")
        go:removeTimeline()
        go:allFishFadeOut()
    end
    self:find("UIBackGround"):callAfter(11, callback)
end

-- 鱼潮来临
function M:MSGS2CStartFishGroup(resp)
    self:find("SCGameLoop"):setClientFrame(1)
    self:find("SCPool"):createFishGroup(resp.index, 1)
    self:find("SCGameLoop"):set("timeline_idx", resp.index)
end

-- 鱼时间线
function M:MSGS2CStartTimeline(resp)
    self:find("SCGameLoop"):setClientFrame(1)
    self:find("SCPool"):createTimeLine(resp.index, 1, false)
    self:find("SCPool"):createTimeLine(resp.index, 1, true)
    self:find("SCGameLoop"):set("timeline_idx", resp.index)
end

function M:MSGS2CDrawStatusChange(resp)
    Log(resp)
end

function M:MSGS2CGetNewTaskInfo(resp)
    Log(resp)
end

-- 全局消息广播
function M:MSGS2CGameAnnouncement(resp)
    self:find("UINotice"):pushNotice(resp)
end

-- 表情
function M:MSGS2CEmoticon(resp)
    --Log(resp)
    local player = self:getPlayer(resp.playerId)
    if player == nil then return end
    self:find("UIEmoji"):showEmoticonAni(player.view_id, resp.emoticonId)
end

-- 接收丟道具
function M:MSGS2CMagicprop(resp)
    Log(resp)
    if not resp.isSuccess then return end
    local player = self:getPlayer(resp.playerId)
    local toPlayer = self:getPlayer(resp.toPlayerID)
    if player == nil or toPlayer == nil then return end
    self:find("UIMagicPropAni"):playPropAni(resp.toPlayerID, resp.magicpropId, resp.playerId)
    --可能需要扣掉自己的水晶

end

-- 获取新手任务信息
function M:MSGS2CGetNewTaskInfo(resp)
    Log(resp)
    if not resp.isSuccess then return end
    self:find("UINewBieTask"):updateAfterGetNewTaskInfo(resp)
end

-- 领取新手任务奖励
function M:MSGS2CGetNewTaskReward(resp)
    Log(resp)
    
    local playerId = resp.playerID
    if not resp.isSuccess then return end
    
    local player = self:getPlayer(playerId)
    if player == nil then return end
    --更新道具數據


    local selfId = self:find("SCGameClient"):getSelfPlayer().id
    if playerId ~= selfId then return end
 
    --更新界面信息
    self:find("UINewBieTask"):updateAfterGetReward(resp)
end

return M