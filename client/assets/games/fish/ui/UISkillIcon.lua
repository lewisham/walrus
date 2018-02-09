----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：技能icon
----------------------------------------------------------------------

local M = class("UISkillIcon", u3a.UIGameObject)

function M:onCreate()
    local action = cc.CSLoader:createTimeline(self:fullPath("ui/skill/uiskilllight3.csb"))
    action:gotoFrameAndPause(0)
    self.node_light_3:runAction(action)
    self.node_light_3.animation = action
end

function M:updateIcon(id)
    local picname = self:fullPath(string.format("ui/images/skill/bl_pic_skill_prop_%03d.png", id))
    self.spr_lock:setSpriteFrame(picname)
    self:setState(1)
    self:initProgressTimer()
    self:playBtnUpAct(0)
    self:updateCost()
    local config = self:require("skill")[id]
    if config == nil then return end
    self.config = config

end

function M:setState(type)
    self.node_light_2:setVisible(false)
    self.node_light_1:setVisible(false)
    if type == 1 then                          --只显示光环1
        self.node_light_1:setVisible(true)
    elseif type == 2 then                          --只显示光环2
        self.node_light_2:setVisible(true)
    elseif type == 3 then                          --显示光环1和2
        self.node_light_2:setVisible(true)
        self.node_light_1:setVisible(true)
    end
end

--阴影进度条
function M:initProgressTimer( )
    self.spr_gray:setVisible(false)
    self.progress_timer = cc.ProgressTimer:create(self.spr_gray)  
    self.progress_timer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    self.progress_timer:setPercentage(0) 
    self.progress_timer:setPosition(cc.p(self.spr_gray:getPositionX(),self.spr_gray:getPositionY()))  
    self.btn_skill:addChild(self.progress_timer) 
    self.progress_timer:setLocalZOrder(self.spr_gray:getLocalZOrder())
    self.fnt_count:setLocalZOrder(self.spr_gray:getLocalZOrder()+1)
    self.fnt_price:setLocalZOrder(self.spr_gray:getLocalZOrder()+2)
end

--设置按键是否可用
function M:playBtnUpAct(index)
    if index == 0 then      --正常
        self.node_light_3.animation:play("use", false)
    elseif index == 1 then      --禁用
        self.node_light_3.animation:play("nouse", false)
    elseif index == 2 then      --解锁动作1
        self.node_light_3.animation:play("activation1", false)
    elseif index == 3 then      --解锁动作2
        self.node_light_3.animation:play("activation2", false)
    end
end

-- 更新消耗显示
function M:updateCost()
    local cnt = self:find("DAFish"):getPropCnt(0)
    local price = 10
    if cnt <= 0 then      
        self.num_bg:setVisible(true)
        if price > 99 then
            self.spr_price:setVisible(true)
            self.fnt_price:setVisible(false)
        else
            self.spr_price:setVisible(false)
            self.fnt_price:setVisible(true)
            self.fnt_count:setVisible(false)
        end
    else
        self.fnt_count:setString(cnt)
        self.num_bg:setVisible(false)
        self.fnt_price:setVisible(false)
        self.fnt_count:setVisible(true)
    end
end

function M:click_btn_skill()
    self:find("SKFreeze"):activeSkill()
end

return M