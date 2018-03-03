----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：核弹技能
----------------------------------------------------------------------

local M = class("SKBomb", wls.UIGameObject)

--动画1
local BOMB_ACT_FIRST  = {
    [15]= { fileName = {"ui/bomb/uisbomb1.csb"},delayTime = 100 ,AllTime = 100}, 
    [6]= { fileName = {"ui/bomb/uimbomb2.csb","ui/bomb/uimbomb1.csb"},delayTime = 0 ,AllTime = 165}, 
    [16]= { fileName = {"ui/bomb/uibbomb1.csb"},delayTime = 95 ,AllTime = 150,startSound = "bomb_02"}, 
 }

 --动画2
local BOMB_ACT_SECOND  = {
    [15]= { fileName = nil,delayTime = 0 ,AllTime = 0}, 
    [6]= { fileName = {"ui/bomb/uimbombcom.csb"},delayTime =165 ,AllTime = 165,startSound = "bombdown_01"}, 
    [16]= { fileName = {"ui/bomb/uibbomb2.csb"},delayTime = 145 ,AllTime = 154}, 
 }

 --动画3
 local BOMB_ACT_THREE  = {
    [15]= { fileName = {"ui/bomb/uisbomb2.csb"},delayTime = 49 ,AllTime = 49,hitFrame = 0,bombSound = "bomb_01"}, 
    [6]= { fileName = {"ui/bomb/uimbomb3.csb"},delayTime = 40 ,AllTime = 40,hitFrame = 0,bombSound = "bomb_01"}, 
    [16]= { fileName = {"ui/bomb/uibbomb3.csb"},delayTime = 130 ,AllTime = 130,hitFrame = 15,shakeCount = 3,bombSound = "bomb_03"}, 
 }
 
function M:onCreate()
    self.SkillUsedList = {}
    self.useingId = 0
    self.nbombCount = 0

    local tips = cc.Sprite:create();
    local seq = cc.Sequence:create(cc.FadeTo:create(0.32, 255), cc.FadeTo:create(0.32, 204), cc.DelayTime:create(0.32));
    tips:setOpacity(0);
    tips:runAction(cc.RepeatForever:create(seq));
    self:addChild(tips);
    tips:setVisible(false)
    self.tips = tips

end

function M:activeSkill(propId,curUesType)
    --判断是否使用中
    if self:getSkillUsedState(propId) == true then
        self:onChoseState(propId,false)
        return 
    end

    if curUesType == 0 then
        self:onChoseState(propId,true)
        return 
    end
    --先判断是否要提示
    if IS_COST_BOMB_TIPS == nil or IS_COST_BOMB_TIPS == true then
        if IS_COST_BOMB_TIPS == nil then
            rawset(_G, "IS_COST_BOMB_TIPS", true)
        end

        self.isNotice = true
        local function callback(ret,ishook)
            print("---ret="..ret)
            if ret == 1 then 
                rawset(_G, "IS_COST_BOMB_TIPS", not ishook)
                self:onChoseState(propId,true)
            end
        end
        wls.Dialog(4,self:find("SCConfig"):getLanguageByID(800000110),callback)
        return 
    end
    self:onChoseState(propId,true)
    
end

function M:setSkillUsedState(propId,isusing)
    for k,v in pairs(self.SkillUsedList) do
        self.SkillUsedList[k] = false
        self.useingId = 0
    end
    self.SkillUsedList[propId] = isusing
    if isusing then
        self.useingId = propId
        self:setTouchEnabled(true)
    else
        self:setTouchEnabled(false)
    end
end

function M:getSkillUsedState(propId)
    return self.SkillUsedList[propId]
end

function M:isSkillUseing()
    for k,v in pairs(self.SkillUsedList) do
        if v then return v end
    end
    return false
end

function M:onChoseState(propId,isChoose)
    --按键状态
    self:find("UISkillPanel"):choseBombSkill(propId,isChoose)
    self:setSkillUsedState(propId,isChoose)
    --ui准备状态
    if isChoose == true then
        local cannon = self:find("UICannon" .. wls.SelfViewID)
        if cannon == nil then return end
        local pos = cc.p(cannon:getPositionX(),cannon:getPositionY() + 240 )
        self.tips:setPosition(pos)
        local fileName = self:fullPath(string.format( "ui/images/nuclear/nuclear_tips_%d.png",propId ))
        if not self.tips:initWithFile(fileName) then Log("-----nuclear_tips is no exist----") end
    end
    self.tips:setVisible(isChoose)
end

function M:isListenTouchEvent()
    return self:isSkillUseing()
end

-- 点击
function M:onTouchBegan(pos)
    if not self:isSkillUseing() then return false end
    self.touchPos = pos
    Log(self.touchPos)
    --判断个数以及水晶是否足够
    local result = self:find("DASkill"):judgeUseType(self.useingId)
    if result == nil then
        self:onChoseState(self.useingId,false)
        return false
    end

    self:find("SCSound"):playSound("lock_01")
    --扣水晶
    
    
    --适配成1280, 720的位置
    self.touchPos.x = self.touchPos.x/1
    self.touchPos.y = self.touchPos.y/1
    local data = {
        pointX = self.touchPos.x,
        pointY = self.touchPos.y,
        nBombId = self.nbombCount,
        useType = result,
        nPropID = self.useingId,
    }
    self.nbombCount = self.nbombCount +1
    wls.SendMsg("sendNBomb", data)

    self:find("UISkillPanel"):onRunTimer(self.useingId)
    self:onChoseState(0,false)
    return false
end

function M:releaseSkill(resp)
    if resp.view_id > 2 then
        resp.pointX = display.width - resp.pointX
        resp.pointY = display.height - resp.pointY
    end
    resp.pos = cc.p(resp.pointX,resp.pointY)
    self:coroutine(self, "loop",resp)
end

function M:loop(resp)
    wls.WaitForFrames(1)
    local root = cc.Node:create()
    self:addChild(root)
    root:setPosition(resp.pos)
    local effectActData = BOMB_ACT_FIRST[resp.nPropID]
    self:playCsbAni(resp,root, effectActData)
    effectActData = BOMB_ACT_SECOND[resp.nPropID]
    self:playCsbAni(resp,root, effectActData)
    effectActData = BOMB_ACT_THREE[resp.nPropID]
    self:playCsbAni(resp,root, effectActData)
    wls.SafeRemoveNode(root)
end

function M:playCsbAni(resp,root,effectData)
    if effectData.fileName == nil then
        return 
    end
    local effectActData = clone(effectData)
    local nodeList = {}
    for i,v in ipairs(effectActData.fileName) do
        v = self:fullPath(v)
        local node = wls.LoadCsb(v)
        root:addChild(node)
        wls.BindToUI(node, node)
        node:setPosition(0, 0)
        local action = cc.CSLoader:createTimeline(v)
        node:runAction(action)
        action:gotoFrameAndPlay(0,false)
        table.insert( nodeList,node )
    end

    if effectActData.hitFrame ~= nil and resp.view_id == wls.SelfViewID then
        wls.WaitForSeconds(effectActData.hitFrame / 60.0)
        Log("----------sendHitFish---------------")
        self:find("SCSound"):playSound(effectActData.bombSound)
        self:sendHitFish(resp.nPropID,resp.pos,resp.nBombId)
    else
        effectActData.hitFrame = 0
    end

    if effectActData.startSound ~= nil then
        self:find("SCSound"):playSound(effectActData.startSound)
    end

    if effectActData.shakeCount ~= nil and effectActData.shakeCount > 0  then
        for i=1,effectActData.shakeCount do
            self:find("UIBackGround"):shake(1/15, 20)
            wls.WaitForSeconds(16/60)
        end
    else
        effectActData.shakeCount = 0
    end

    wls.WaitForSeconds((effectActData.delayTime - effectActData.hitFrame - 16*effectActData.shakeCount) / 60.0)
    local function callback()
        for k,v in pairs(nodeList) do
            wls.SafeRemoveNode(v)
        end  
    end
    self:callAfter((effectActData.AllTime - effectActData.delayTime) / 60.0, callback)
end

function M:sendHitFish(nPropID,pos,nBombId)
    local fishList = {}
    self:find("SCPool"):calcAtomBombFish(fishList, pos, tonumber(self:find("SCConfig"):getBombData(nPropID).range))
    local tb = {}
    for k,v in ipairs(fishList) do
        local fishData = {}
        fishData.timelineId = v:get("timeline_id")
        fishData.fishArrayId = v:get("array_id")
        table.insert( tb, fishData )
    end
    local data = {}
    data.nBombId = nBombId
    data.killedFishes = tb
    Log(data)
    wls.SendMsg("sendNBombBalst", data)
end

return M