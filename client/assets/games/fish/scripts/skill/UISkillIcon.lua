----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：技能icon
----------------------------------------------------------------------

local M = class("UISkillIcon", wls.UIGameObject)

function M:onCreate()
    local action3 = cc.CSLoader:createTimeline(self:fullPath("ui/skill/uiskilllight3.csb"))
    action3:gotoFrameAndPause(0)
    self.node_light_3:runAction(action3)
    self.node_light_3.animation = action3

    local action2 = cc.CSLoader:createTimeline(self:fullPath("ui/skill/uiskilllight2.csb"))
    action2:gotoFrameAndPause(0)
    self.node_light_2:runAction(action2)
    self.node_light_2.animation = action2

    local action1 = cc.CSLoader:createTimeline(self:fullPath("ui/skill/uiskilllight1.csb"))
    action1:gotoFrameAndPause(0)
    self.node_light_1:runAction(action1)
    self.node_light_1.animation = action1

    self.fnt_count:setString(0)
    self.propId = 0
    self.price = 0
    self.costId = 0
    self.beginTime = 0
    self.totalTime = 0
    self:setBtnIfCanUsed(true)
end

function M:updateIcon(id,index,allCount)
    if id == nil then
        self.propId = 0
        local picname = self:fullPath("ui/images/skill/bl_btn_hd.png")
        self:initNormalBtn(picname)
        self:initLight(index,allCount)
        return 
    end
    self.propId = id
    local picname = self:fullPath(string.format("ui/images/skill/bl_pic_skill_prop_%03d.png", id))
    self.spr_lock:setSpriteFrame(picname)
    self:setState(1)
    self:initProgressTimer()
    self:playBtnUpAct(0)
    self:initLight(index,allCount)
    self:replayStateAct(id)
    local cosrid ,price = self:find("DASkill"):getSkillCostProp(id)
    self:setPricce(cosrid,price)
    local config = self:find("SCConfig"):getSkillData(id)
    if config == nil then return end
    self.config = config
end

-- 初始化视图
function M:updateView()
    self:updateCost()
end

function M:replayStateAct( propId )
    if tonumber(propId) == 14 then
        local filename = self:fullPath("ui/hourglass/uiskillanimation.csb")
        local timeRevert = cc.CSLoader:createNode(filename) 
        self.node_light_2:addChild(timeRevert)
        timeRevert.animation = cc.CSLoader:createTimeline(filename)
        timeRevert:runAction(timeRevert.animation)
        timeRevert.animation:gotoFrameAndPlay(0)

        timeRevert:setPosition(cc.p(0,0))
        timeRevert.animation:play("doplay",true)
        timeRevert:setScale(1/self.node_light_2:getScale())
    end

end

--设置道具价格
function M:setPricce( costId,price )
    price = tonumber(price)
    costId = tonumber(costId)
    self.fnt_price:setString(price)
    self.price = price
    self.costId = costId
end

function M:getFntCount()
    return tonumber(self.fnt_count:getString())
end

function M:getFntPrice()
    return tonumber(self.fnt_price:getString())
end

--初始化光圈
function M:initLight(index,allCount )
    self.node_light_1:stopAllActions()
    self.node_light_1:runAction(self.node_light_1.animation)
    local disTime = 55/60
    local allDelayTime = disTime*allCount
    if allCount == 1 then
        allDelayTime = allDelayTime + 1
    end
    
    local allAct = function ( ... )
        local sequence = cc.Sequence:create(
            cc.DelayTime:create(allDelayTime),
            cc.CallFunc:create(function ( ... )
                self.node_light_1.animation:play("doplay", false);
            end))
        local action = cc.RepeatForever:create(sequence)
        self.node_light_1:runAction(action)
    end

    local nowDelayTime = index*disTime
    local seq = cc.Sequence:create(cc.DelayTime:create(nowDelayTime),cc.CallFunc:create(function ( ... )
        allAct()
    end))
    self.node_light_1:runAction(seq)
    
    --要先停止原先变形的动画，再播放最新的动画
    self.node_light_2:stopAllActions()
    self.node_light_2:runAction(self.node_light_2.animation)
    self.node_light_2.animation:play("doplay", true);

    self.node_light_3:stopAllActions()
    self.node_light_3:runAction(self.node_light_3.animation)
    self.node_light_3.animation:play("use", false);

end

--初始化为按键，不是道具
function M:initNormalBtn(btnPic)
    self.spr_lock:setSpriteFrame(btnPic)
    self:setState(1)
    self.num_bg:setVisible(false)
    self.fnt_price:setVisible(false)
    self.fnt_count:setVisible(false)
    self.spr_gray:setVisible(false)
    self.spr_price:setVisible(false)
    self.node_light_3:setVisible(false)
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
    local cnt = self:find("DAPlayer"):getPropCnt(self.propId)
    local price = self.price
    if cnt <= 0 then      
        self.num_bg:setVisible(true)
        self.fnt_count:setVisible(false)
        if price > 999 then
            self.spr_price:setVisible(true)
            self.fnt_price:setVisible(false)
        else
            self.spr_price:setVisible(false)
            self.fnt_price:setVisible(true)
        end
    else
        self.fnt_count:setString(cnt)
        self.num_bg:setVisible(false)
        self.fnt_price:setVisible(false)
        self.fnt_count:setVisible(true)
        self.spr_price:setVisible(false)
    end
end

--设置按键是否可用
function M:setBtnIfCanUsed(ifCan)
    if ifCan then
        local p = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP");
        self.spr_lock:setGLProgram(p);
    else
        local grayvsh = "attribute vec4 a_position; \n attribute vec2 a_texCoord; \n attribute vec4 a_color; \n varying vec4 v_fragmentColor;\n varying vec2 v_texCoord;\n void main(void) \n { \n gl_Position = CC_PMatrix * a_position;\n v_fragmentColor = a_color;\n v_texCoord = a_texCoord;\n }";
        local grayfsh = "varying vec4 v_fragmentColor;\n varying vec2 v_texCoord;\n void main()\n {\n vec4 v_orColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);\n float gray = dot(v_orColor.rgb, vec3(0.099, 0.387, 0.114));\n gl_FragColor = vec4(gray, gray, gray, v_orColor.a);\n }";
        local p = cc.GLProgram:createWithByteArrays(grayvsh, grayfsh);
        p:link();  
        p:updateUniforms();  
        self.spr_lock:setGLProgram(p);
        p:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION);  
        p:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORD);  
    end
end

--CD进度条
function M:runTimer(hasCostTime)
    self.beginTime = os.time()
    self.totalTime = tonumber(self.config.cool_down)
    self:updateCDTime()
end

function M:runCountdownAct(time)
    self.progress_timer:setVisible(true)
    self.progress_timer:stopAllActions()
    local seq = cc.Sequence:create(cc.ProgressTo:create(time,0), cc.CallFunc:create(function () self:stopTimer() end))
    self.progress_timer:runAction(seq)
end

-- 更新CD
function M:updateCDTime()
    if self.totalTime<= 0 then
        return
    end
    local remainTime = self.totalTime-(os.time()-self.beginTime)
    if remainTime <= 0 then
        self:stopTimer()
        return
    end
    self.progress_timer:setPercentage(remainTime/self.totalTime*100)
    self:runCountdownAct(remainTime)
end

--停止CD进度条
function M:stopTimer()
    local Timer = self.progress_timer
    if Timer == nil then return end
    Timer:setVisible(true)
    Timer:stopAllActions()
    Timer:setPercentage(0) 
    self.btn_skill:setTouchEnabled(true)
    self.beginTime = 0
    self.totalTime = 0
end

--按键回调处理
function M:click_btn_skill()
    if self.propId == 0 then
        self:find("UISkillPanel"):setIsOpenBombList()
        return
    end
    local result = self:find("DASkill"):judgeUseType(self.propId)
    if result == nil then return end
    if self.propId == 3 then 
        self.btn_skill:setTouchEnabled(false)
        self:find("SKFreeze"):activeSkill(result)
    elseif  self.propId == 4 then
        self.btn_skill:setTouchEnabled(false)
        self:find("SKLockTarget"):activeSkill(result)
    elseif self.propId == 5 then
        self.btn_skill:setTouchEnabled(false)
        self:find("SKSummon"):activeSkill(result)
    elseif  self.propId == 14 then
        --self.btn_skill:setTouchEnabled(false)
        self:find("SKTimeRevert"):activeSkill(result)
    elseif  self.propId == 15 or self.propId == 6 or self.propId == 16  then
        --self.btn_skill:setTouchEnabled(false)
        self:find("SKBomb"):activeSkill(self.propId,result)
    elseif self.propId == 17 then
        self.btn_skill:setTouchEnabled(false)
        self:find("SKViolent"):activeSkill(result)
    end
end

return M