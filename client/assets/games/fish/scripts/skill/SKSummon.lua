----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：召唤技能
----------------------------------------------------------------------

local M = class("SKSummon", wls.UIGameObject)

function M:onCreate()
    self.callFishCount = 1
end

function M:activeSkill(curUesType)
    wls.SendMsg("sendCallFish", curUesType, self.callFishCount)
    self.callFishCount = self.callFishCount + 1 
end

function M:releaseSkill(resp)
    self:coroutine(self, "releaseSkillImpl", resp)
end

function M:releaseSkillImpl(resp)
    local cannon = self:find("UICannon" .. resp.view_id)
    self:find("SCSound"):playSound("com_btn03")
    local beginPos = cc.p(cannon:getPositionX(),cannon:getPositionY())
    local frame = math.floor(0.5/(3/60))
    local pos = self:find("SCConfig"):get("path")[tostring(resp.pathId)][frame].pos
    local endPos = cc.p(pos.x, pos.y)
    if wls.PlayerFlip then 
        endPos.x = display.width - endPos.x
        endPos.y = display.height - endPos.y
    end
    self:addLamp(beginPos,endPos)
    self:addDarkCloud(endPos)
    wls.WaitForSeconds(0.2)
    self:addDarkCloud(endPos)
    wls.WaitForSeconds(0.2)
    self:showFish(resp.args)
end

--丢神灯动画
function M:addLamp(beginPos,endPos)
    local dis = cc.pDistanceSQ(beginPos, endPos);
    local rotateAct = cc.RotateBy:create(0.88, 360);
    local fadeAct = cc.Sequence:create(cc.FadeTo:create(0.12, 255), cc.DelayTime:create(0.76), cc.FadeTo:create(0.08, 0));
    local moveAct = cc.MoveTo:create(0.88, endPos);
    local callFishAct = cc.Sequence:create(cc.DelayTime:create(1.16), cc.RemoveSelf:create());
    local lampSprite = cc.Sprite:createWithSpriteFrameName(self:fullPath("ui/images/effect/effect_lamp.png"))
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
function M:addDarkCloud(endPos)
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
    local seq = cc.Sequence:create(cc.DelayTime:create(0.2), spaw2)
    cloud2:runAction(seq);
    endPos = cc.p(endPos.x, endPos.y-20);

    self:addChild(cloud1, 100);
    self:addChild(cloud2, 100);
end

--召唤鱼出现
function M:showFish(args)
    local fish = self:find("SCPool"):findFish(args.timeline_id, args.array_id)
    if fish and fish:isAlive() then
        fish:setVisible(true)
    end
end

return M