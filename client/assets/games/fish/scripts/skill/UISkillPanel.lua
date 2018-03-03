----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：技能操作层
----------------------------------------------------------------------

--底部的按键
local DOWN_LIST  = 
{
    { ["varname"] = "btn_skill_3",["propId"]  = 3,["index"]  = 1,["allCount"] = 3}, 
    { ["varname"] = "btn_skill_4",["propId"]  = 4,["index"]  = 2,["allCount"] = 3},
    { ["varname"] = "btn_skill_5",["propId"]  = 5,["index"]  = 1,["allCount"] = 1},
    { ["varname"] = "btn_skill_17",["propId"] = 17,["index"] = 3,["allCount"] = 3},
    { ["varname"] = "btn_skill_14",["propId"] = 14,["index"] = 1,["allCount"] = 1},
}

--左边的按键
local BOMB_LIST  = {
    { ["varname"] = "btn_skill_15",["nodename"]   = "node_skill_left_1",["propId"] = 15,["index"]  = 1,["allCount"] = 3}, 
    { ["varname"] = "btn_skill_6",["nodename"]    = "node_skill_left_2",["propId"] = 6,["index"]   = 2,["allCount"] = 3},
    { ["varname"] = "btn_skill_16",["nodename"]   = "node_skill_left_3",["propId"] = 16,["index"]  = 3,["allCount"] = 3},
    { ["varname"] = "btn_skill_Open",["nodename"] = "node_open",["propId"]         = nil,["index"] = 1,["allCount"] = 1}, 
}

local M = class("UISkillPanel", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/skill/uiskilldesk.csb"))
    --self.node_violentcd:setVisible(false)
    self.mSkillIcons = {}
    local go
    for k, v in ipairs(DOWN_LIST) do
        go = self:wrapGameObject(self[v.varname], "UISkillIcon")
        go:updateIcon(v.propId, v.index, v.allCount)
        if v.propId then self.mSkillIcons[v.propId] = go end
    end
    wls.BindToUI(self.node_left, self.node_left)
    for k, v in ipairs(BOMB_LIST) do
        self[v.varname] = self.node_left[v.nodename]
        go = self:wrapGameObject(self[v.varname], "UISkillIcon")
        go:updateIcon(v.propId, v.index, v.allCount)
        if v.propId then self.mSkillIcons[v.propId] = go end
    end
    self:wrapGameObject(self.node_violentcd, "UIViolentBar")

    self.panel_left:setTouchEnabled(false)
    self.node_skill = self.node_left["node_skill"]
    self.firstPosX = self.node_skill:getPositionX()
    self.isOpen = true
    self.downPosY = self.btn_skill_3:getPositionY()

    self:setIsViolent(false)

    ---------------------------------------------------------------------------------------------------------
    --监听进入前后台
    local eventDispatcher = self:getEventDispatcher()
    local forelistener = cc.EventListenerCustom:create("applicationWillEnterForeground", function ( ... )
        self:updateCDTime()
    end)
    eventDispatcher:addEventListenerWithSceneGraphPriority(forelistener, self)
    local backlistener = cc.EventListenerCustom:create("applicationDidEnterBackground", function ( ... )
        self:updateCDTime()
    end)
    eventDispatcher:addEventListenerWithSceneGraphPriority(backlistener, self)

end

function M:setIsOpenBombList(isShow,callBack)  
    if isShow == nil then isShow = not self.isOpen end
    self.isOpen = isShow
    if callBack == nil then callBack = function ( ... ) end end
    local aimPos = cc.p(0,0)
    if self.isOpen == true then
        aimPos = cc.p(self.firstPosX,self.node_skill:getPositionY())
    else
        aimPos = cc.p(-268,self.node_skill:getPositionY())
    end

    self.node_skill:stopAllActions()
    local seq = cc.Sequence:create(cc.MoveTo:create(0.2,aimPos),cc.CallFunc:create(callBack))
    self.node_skill:runAction(seq)  

end

function M:onEventTouchBegan(touch)
    if self.isOpen == true then
        self:setIsOpenBombList(false)
    end
    return false
end

--开启cd
function M:onRunTimer(SkillId)
    local Skill = self["btn_skill_"..SkillId]
    if Skill == nil then return end
    Skill:runTimer(0)
end

--停止cd
function M:onStopTimer(SkillId)
    local Skill = self["btn_skill_"..SkillId]
    if Skill == nil then return end
    Skill:stopTimer()
end

-- 更新CD
function M:updateCDTime()
    print("---------updateCDTime-----------------")
    for k, v in ipairs(DOWN_LIST) do
        self[v.varname]:updateCDTime()
    end
    for k, v in ipairs(BOMB_LIST) do
        self[v.varname]:updateCDTime()
    end
    self.node_violentcd:updateCDTime()

end

--设置按键状态
function M:setState( SkillId,stateId )
    if self["btn_skill_"..SkillId] == nil then return end
    self["btn_skill_"..SkillId]:setState(stateId)
end

-- 更新所有技能icon数据
function M:updateAllIcon()
    for _, icon in pairs(self.mSkillIcons) do
        icon:updateView()
    end
end

--选中核弹技能
function M:choseBombSkill( bombId ,isChoose)
    if bombId == nil then bombId = 0 end
    for k, v in ipairs(BOMB_LIST) do
        local Skill = self[v.varname]
        if Skill ~= nil then
            if v.propId == bombId and isChoose then
                Skill:setState(2)
            else
                Skill:setState(1)
            end
        end
    end
end

--设置是否进入狂暴状态
function M:setIsViolent( isViolent,barTime)
    self:coroutine(self, "setIsViolentImpl",isViolent,barTime)
end

--设置是否显示狂暴进度
function M:setIsViolentImpl(isViolent,barTime)
    if isViolent then
        self.node_violentcd:play(barTime)
        self:setIsShowDownNode(self.btn_skill_4, false)
        self:setIsShowDownNode(self.btn_skill_17, false)
        wls.WaitForSeconds(0.5)
        self:setIsShowDownNode(self.node_violentcd, true)
    else
        self.node_violentcd:stop()
        self:setIsShowDownNode(self.node_violentcd, false)
        wls.WaitForSeconds(0.5)
        self:setIsShowDownNode(self.btn_skill_4, true)
        self:setIsShowDownNode(self.btn_skill_17, true)
    end
end

--设置是否显示底部按键
function M:setIsShowDownNode(node, isShow)
    node:stopActionByTag(1001)
    local pos = nil
    if isShow then
        pos = cc.p(node:getPositionX(), self.downPosY)
    else
        pos = cc.p(node:getPositionX(), -self.downPosY)
    end
    local act = cc.Sequence:create(cc.EaseExponentialIn:create(cc.MoveTo:create(0.5, pos)))
    act:setTag(1001)
    node:runAction(act)
end

--设置狂暴倍率
function M:setViolentRate( rate)
    self.node_violentcd:setRate(rate)
end

--得到技能视图上个数
function M:getSkillViewCount( SkillId )
    if self["btn_skill_"..SkillId] == nil then return end
    return self["btn_skill_"..SkillId]:getFntCount()or 0
end

--更新按键是否可用
function M:updateBtnIsCanUse()
    local DASkill = self:find("DASkill")
    for k, v in ipairs(DOWN_LIST) do
        if v.propId ~= nil then
            self[v.varname]:setBtnIfCanUsed(DASkill:judgeGunRate(v.propId,false))
        end
    end

    for k, v in ipairs(BOMB_LIST) do
        if v.propId ~= nil then
            self[v.varname]:setBtnIfCanUsed(DASkill:judgeGunRate(v.propId,false))
        end
    end
end

-- 操作道具数量
function M:opProp(id, add)
end

return M