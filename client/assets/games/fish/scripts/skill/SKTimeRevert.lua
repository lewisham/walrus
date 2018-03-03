----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：时光沙漏技能
----------------------------------------------------------------------

local M = class("SKTimeRevert", wls.UIGameObject)

function M:onCreate()
    self.isUsing = false
    self.startFishCoin = 0
end

function M:activeSkill(curUesType)
    if self.isUsing == false then
        self:startCheck(curUesType)
    else
        self:revertCheck()
    end
end

-- 释放技能
function M:releaseSkill(resp)
    if resp.view_id == wls.SelfViewID then 
        self.startFishCoin = resp.nFishIcon
    end
    self:coroutine(self, "releaseSkillImpl",resp.view_id,resp.nTimeRemain)
end

function M:releaseSkillImpl(view_id,nTimeRemain)
    local cannon = self:find("UICannon" .. view_id)
    if cannon == nil then return end
    local beginPos = cc.p(cannon:getPositionX(),cannon:getPositionY())
    local endPos = cc.p(display.width/2,display.height/2)
    self:addLamp(beginPos,endPos)
    self:addDarkCloud(endPos)
    self:addDarkCloud(endPos)
    self:addBuffer(view_id,nTimeRemain)
    if view_id ~= wls.SelfViewID then 
        return 
    end
    
    self.isUsing = true
    self:playTimehourBanner(nTimeRemain)
end

--丢神灯动画
function M:addLamp(beginPos,endPos)
    local dis = cc.pDistanceSQ(beginPos, endPos);
    local rotateAct = cc.RotateBy:create(0.88, 360);
    local fadeAct = cc.Sequence:create(cc.FadeTo:create(0.12, 255), cc.DelayTime:create(0.76), cc.FadeTo:create(0.08, 0));
    local moveAct = cc.MoveTo:create(0.88, endPos);
    local callFishAct = cc.Sequence:create(cc.DelayTime:create(1.16), cc.RemoveSelf:create());
    local lampSprite = cc.Sprite:create(self:fullPath("ui/images/common/prop/prop_014.png"))
    lampSprite:setOpacity(255);
    lampSprite:setPosition(beginPos);
    lampSprite:runAction(rotateAct);
    lampSprite:runAction(fadeAct);
    lampSprite:runAction(moveAct);
    lampSprite:runAction(callFishAct);
    self:addChild(lampSprite, 99)
    wls.WaitForSeconds(0.76)
end

--召唤烟雾动画
function M:addDarkCloud(endPos,callback)
    local strFormat = self:fullPath("ui/images/effect/effect_lamp_clouds.png")
    local cloud1 = cc.Sprite:createWithSpriteFrameName(strFormat);
    cloud1:setOpacity(0);
    cloud1:setScale(0);
    cloud1:setPosition(endPos);
    local cloud2 = cc.Sprite:createWithSpriteFrameName(strFormat);
    cloud2:setRotation(180);
    cloud2:setOpacity(0);
    cloud2:setScale(0);
    cloud2:setPosition(cc.p(endPos.x, endPos.y-cloud1:getContentSize().height/2));

    local fadeAct1 = cc.Sequence:create(cc.FadeTo:create(0.6, 255), cc.FadeTo:create(0.6, 0))
    local scaleAct1 = cc.Sequence:create(cc.ScaleTo:create(1.2, 3), cc.RemoveSelf:create())
    local spaw1 = cc.Spawn:create(fadeAct1, scaleAct1);
    cloud1:runAction(spaw1);

    local fadeAct2 = cc.Sequence:create(cc.FadeTo:create(0.6, 255), cc.FadeTo:create(0.6, 0))
    local scaleAct2 = cc.Sequence:create(cc.ScaleTo:create(1.2, 3), cc.RemoveSelf:create())
    local spaw2 = cc.Spawn:create(fadeAct2, scaleAct2);
    local seq = cc.Sequence:create(cc.DelayTime:create(0.2), spaw2, cc.CallFunc:create(function ( ... )
        if callback ~= nil then callback() end
    end))
    cloud2:runAction(seq);
    endPos = cc.p(endPos.x, endPos.y-20);

    self:addChild(cloud1, 100);
    self:addChild(cloud2, 100);
    if callback == nil then
        wls.WaitForSeconds(0.2)
    end
end

--炮台小神灯特效
function M:addBuffer(view_id, delay)      
    local cannon = self:find("UICannon" .. view_id)
    if cannon == nil then return end
    cannon:playTimeRevert(delay)
end

--炮台小神灯特效
function M:delBuffer(view_id)      
    local cannon = self:find("UICannon" .. view_id)
    if cannon == nil then return end
    cannon:stopTimeRevert()
end

--全屏开始计时特效
function M:playTimehourBanner(showTimeCount)      
    self:createGameObject("UITimehourBanner"):play(showTimeCount)
end

function M:sendStopSkill(curUesType)
    Log("------------sendStopSkill---------------curUesType="..curUesType)
    local data = { useType = curUesType }
    wls.SendMsg("sendToStopTimeHourglass", data)
end

--停止技能
function M:stopSkill(resp)
    self:delBuffer(resp.view_id)
    if resp.view_id ~= wls.SelfViewID then 
        return 
    end
    self.isUsing = false
    self:coroutine(self, "stopSkillImpl",resp.nFishIcon)
end

function M:stopSkillImpl(nFishIcon)
    local cannon = self:find("UICannon" .. wls.SelfViewID)
    local viewFishCount = cannon:getCoin()
    Log("nFishIcon="..nFishIcon,"viewFishCount="..viewFishCount)
    local actTime = self:playTimehourRevert(nFishIcon,viewFishCount)
    wls.WaitForSeconds(actTime)
    self:find("UICoinMgr"):play(cc.p(display.width/2,display.height/2),12,wls.SelfViewID,tonumber(nFishIcon - viewFishCount ))
end

function M:playTimehourRevert(aimCount,curCount)
    return self:createGameObject("UITimehourRevert"):play(aimCount,curCount)
end


-- 断线回来请求继续时光沙漏
function M:continueSkill(resp)
    if resp.view_id == wls.SelfViewID then 
        self.startFishCoin = resp.nFishIcon
    end
    self:coroutine(self, "continueSkillImpl",resp.view_id,resp.nTimeRemain)
end

function M:continueSkillImpl(view_id,nTimeRemain)
    local cannon = self:find("UICannon" .. view_id)
    if cannon == nil then return end
    local beginPos = cc.p(cannon:getPositionX(),cannon:getPositionY())
    local endPos = cc.p(display.width/2,display.height/2)
    self:addBuffer(view_id,nTimeRemain)
    if view_id ~= wls.SelfViewID then 
        return 
    end
    self.isUsing = true
end

--------------------------------------------各种检测和提示--------------------------------------------------
--开始提示
function M:startCheck(curUesType)
    local function callback(ret)
        if ret == 1 then 
            local data = {useType = curUesType }
            wls.SendMsg("sendToStartTimeHourglass", data)
        end
    end
    local str = '\n'..self:find("SCConfig"):getLanguageByID(800000254) .. "$" .. '\n'..self:find("SCConfig"):getLanguageByID(800000255)
    wls.Dialog(3,str,callback)
end

--回朔提示
function M:revertCheck()
    local fishIcon = self:find("DAPlayer"):getDataByKey("fishIcon")
    local cannon = self:find("UICannon" .. wls.SelfViewID)
    local viewFishCount = cannon:getCoin()
    if fishIcon <= self.startFishCoin and viewFishCount <= self.startFishCoin then
        self:sendStopSkill(1)
        return 
    end
    local function callback(ret)
        if ret == 1 then 
            self:sendStopSkill(1)
        end
    end
    local body = string.format(self:find("SCConfig"):getLanguageByID(800000257), tostring(self.startFishCoin))
    wls.Dialog(3,self:find("SCConfig"):getLanguageByID(800000271) .. "\n" .. body,callback)
end

--退出检测
function M:exitCheck(callFun)
    if not self.isUsing then
        return true
    end
    local function callback(ret)
        if ret == 1 then 
            self:sendStopSkill(0)
            callFun(ret)
        end
    end
    local body = string.format(self:find("SCConfig"):getLanguageByID(800000257), tostring(self.startFishCoin))
    local str = self:find("SCConfig"):getLanguageByID(800000258) .. "\n" .. body
    wls.Dialog(3,str,callback)
end

--充值检测   传入打开商店的回调函数
function M:rechargeCheck(callFun)
    if not self.isUsing then
        return true
    end
    local function callback(ret)
        if ret == 1 then 
            callFun(ret)
        end
    end
    local body = string.format(self:find("SCConfig"):getLanguageByID(800000257), tostring(self.startFishCoin))
    local str = self:find("SCConfig"):getLanguageByID(800000259) .. "\n" .. body
    wls.Dialog(3,str,callback)
end

--是否继续的检测
function M:continueCheck()
    if self.isUsing then
        return true
    end
    local function callback(ret)
        if ret == 1 then 
            wls.SendMsg("sendToContinueTimeHourglass", {})
        elseif ret == 0 then
            self:sendStopSkill(0)
        end
    end
    Log("-------------continueCheck-------------------")
    --local body = string.format(self:find("SCConfig"):getLanguageByID(800000257), tostring(self.startFishCoin))
    local str = self:find("SCConfig"):getLanguageByID(800000256) 
    wls.Dialog(3,str,callback)
end

return M