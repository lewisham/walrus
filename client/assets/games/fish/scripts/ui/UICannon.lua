----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：炮台
----------------------------------------------------------------------

local M = class("UICannon", wls.UIGameObject)

function M:onCreate(viewID)
    self.mViewID = viewID
    self:loadCsb(self:fullPath("ui/uicannon.csb"))
    self:initDir(viewID)
    self.cannonWorldPos = self.node_gun:convertToWorldSpaceAR(cc.p(0, 0))
    self:initGunFirAction()
    self:initViolentAction()
    self:reset()
end

function M:reset()
    self.is_self = false
    self.maxGunRate = 1
    self.panel_1:setTouchEnabled(false)
    self.spr_coin_bg:setVisible(false)
    self.fnt_curadd:setVisible(false)
    self.spr_gun_lock:setVisible(false)
    self.spr_bankrupt:setVisible(false)
    self.spr_light:setVisible(false)
    self.spr_gunfire:setVisible(false)
    self.btn_minus:setVisible(false)
    self.btn_add:setVisible(false)
    self.spr_circle:setVisible(false)
    self.spr_circle:stopAllActions()
    self:updateGun(1)
    self:setVisible(false)
    self:stopTimeRevert()
    self.TimeRevertCount = 0
    self.node_violent:setVisible(false)
    -- 初始数值 
    self.fnt_coins.cur = 0
    self.fnt_diamonds.cur = 0
    self.fnt_multiple.cur = 0
end

function M:initDir(viewID)
    self:setPosition(wls.CannonPosList[viewID])
    if viewID == 2  then
        self.spr_coin_bg:setPositionX(-self.spr_coin_bg:getPositionX())
        self.fnt_curadd:setPositionX(-self.fnt_curadd:getPositionX())
        self.node_buff:setPositionX(-self.node_buff:getPositionX())
    elseif viewID == 3 then
        self:setRotation(180)
        self.spr_coin_bg:setRotation(180)
        self.spr_bankrupt:setRotation(180)
        self.fnt_curadd:setRotation(180)
    elseif viewID == 4 then
        self:setRotation(180)
        self.spr_coin_bg:setRotation(180)
        self.spr_bankrupt:setRotation(180)
        self.fnt_curadd:setRotation(180)
        self.spr_coin_bg:setPositionX(-self.spr_coin_bg:getPositionX())
        self.fnt_curadd:setPositionX(-self.fnt_curadd:getPositionX())
        self.node_buff:setPositionX(-self.node_buff:getPositionX())
    end
end

-- 枪火帧动画
function M:initGunFirAction()
    local strFormat = "games/fish/assets/ui/images/effect/gunfire_1_%02d.png"
    local animation = self:find("SCAction"):createAnimation(strFormat, 1 / 24.0)
    local tb =
    {
        cc.Show:create(),
        cc.Animate:create(animation),
        cc.Hide:create(),
    }
    self.gunFireAction = cc.Sequence:create(tb)
    self:find("SCAction"):retainAction(self.gunFireAction)

end

-- 狂暴动画
function M:initViolentAction()
    local action = cc.CSLoader:createTimeline(self:fullPath("ui/skill/uiskill_kb_1.csb"))
    action:gotoFrameAndPause(0)
    self.node_violent_1:runAction(action)
    self.node_violent_1.animation = action

    action = cc.CSLoader:createTimeline(self:fullPath("ui/skill/uiskill_kb_2.csb"))
    action:gotoFrameAndPause(0)
    self.node_violent_2:runAction(action)
    self.node_violent_2.animation = action
end

-- 向某条鱼开火
function M:shootPre(bullet_id, angle, bViolent)
    self:updateAngle(angle)
    local extra = self.mViewID >= 3 and 180 or 0
    local pos = self.Node_launcher:convertToWorldSpaceAR(cc.p(0, 0))
    self:find("SCPool"):createFollowBullet(self.mViewID, self.config.id, pos, angle + extra, bullet_id, 0, bViolent)
    self:playFireAni()
    self:opCoin(-self:getGunRate())
end


-- 开火(向某个角度)
function M:fire(bullet_id, angle, fish, duration, bViolent)
    angle = 180 - angle
    self:updateAngle(angle)
    local extra = self.mViewID >= 3 and 180 or 0
    local pos = self.Node_launcher:convertToWorldSpaceAR(cc.p(0, 0))
    if fish then
        self:find("SCPool"):createFollowBullet(self.mViewID, self.config.id, pos, angle + extra, bullet_id, duration, bViolent)
    else
        self:find("SCPool"):createNormalBullet(self.mViewID, self.config.id, pos, angle + extra, bullet_id, duration)
    end
    self:playFireAni()
end

-- 预处理开火(向某个角度)
function M:firePre(bullet_id, angle)
    self:updateAngle(angle)
    local extra = self.mViewID >= 3 and 180 or 0
    local pos = self.Node_launcher:convertToWorldSpaceAR(cc.p(0, 0))
    self:find("SCPool"):createNormalBullet(self.mViewID, self.config.id, pos, angle + extra, bullet_id, 0)
    self:playFireAni()
    self:opCoin(-self:getGunRate())
end

-- 炮开火动画
function M:playFireAni()
    if self.is_self then
        self:find("SCSound"):playSound("gunfire_01")
    end
    self.spr_cannon:stopAllActions()
    local act = cc.Sequence:create(cc.ScaleTo:create(0.05, 1, 0.8), cc.ScaleTo:create(0.05, 1, 1))
    self.spr_cannon:runAction(act)
    self.spr_gunfire:stopAllActions()
    self.spr_gunfire:runAction(self.gunFireAction)
end

function M:updateAngle(angle)
    local extra = self.mViewID >= 3 and 180 or 0
    self.node_gun:setRotation(-angle + 90)
end

function M:join(is_self)
    self:setVisible(true)
    self.spr_coin_bg:setVisible(true)
    self.is_self = is_self
    self.img_numbg:setVisible(self.is_self)
    self.txt_timecount:setVisible(self.is_self)
    self.panel_1:setTouchEnabled(true)
    if not is_self then 
        self.panel_1:onClicked(function() self:click_roleInfo() end)
    else
        self.panel_1:onClicked(function() self:click_panel() end)
        self.btn_minus:setVisible(true)
        self.btn_add:setVisible(true)
        self.spr_circle:setVisible(true)
        self.spr_circle:runAction(cc.RepeatForever:create(cc.RotateBy:create(5.0, 360)))
    end 
end

-- 更新枪
function M:updateGun(id)
    id = 930000000 + id
    local config = self:require("cannonoutlook")[tostring(id)]
    self.config = config
    self.spr_cannon:setTexture(self:fullPath("plist/bullet/".. config.cannon_img))
end

-- 是否可以开炮
function M:isCanFire()
    if self.spr_gun_lock:isVisible() then 
        return wls.FireErrorCode.Lock
    end
    if self:getCoin() < self:getGunRate() then 
        return wls.FireErrorCode.Not_Enough_Money
    end
    return 0
end

-- 炮率上增
function M:click_btn_add()
    local cur = self:getGunRate()
    local rate = self:find("DAPlayer"):getNextRate(cur)
    if rate == nil then return end
    self.btn_minus:setTouchEnabled(false)
    self.btn_add:setTouchEnabled(false)
    wls.SendMsg("sendNewGunRate", rate)
end

-- 炮率下调
function M:click_btn_minus()
    local cur = self:getGunRate()
    local rate = self:find("DAPlayer"):getLastRate(cur)
    if rate == nil then return end
    self.btn_minus:setTouchEnabled(false)
    self.btn_add:setTouchEnabled(false)
    wls.SendMsg("sendNewGunRate", rate)
end

function M:updateGunRate(rate)
    self:setGunRate(rate)
    self:playChangeEff()
    self.spr_gun_lock:setVisible(rate > self.maxGunRate)
    if not self.is_self then return end
    self:find("SCSound"):playSound("gunswitch_01")
    self.btn_minus:setTouchEnabled(true)
    self.btn_add:setTouchEnabled(true)
end

--播放切换炮倍特效
function M:playChangeEff( )
    self.spr_light:stopAllActions()
    self.spr_light:setOpacity(0)
    self.spr_light:setScale(1)
    local tb =
    {
        cc.Show:create(),
        cc.FadeTo:create(0.04,255),
        cc.ScaleTo:create(0.08,1.5),
        cc.FadeTo:create(0.04,0),
        cc.Hide:create(),
    }
    self.spr_light:runAction(cc.Sequence:create(tb))
    self.node_gun:stopAllActions()
    self.node_gun:setOpacity(255)
    self.node_gun:setScale(1)
    self.node_gun:runAction(cc.Sequence:create(cc.ScaleTo:create(0.04,0.5), cc.ScaleTo:create(0.08,1)))
end

function M:click_panel()
    self:find("UIGunPanel"):switch()
end

--查看角色信息
function M:click_roleInfo()
    self:find("UIPlayerInfo"):setVisible(true)
    self:find("UIPlayerInfo"):setShowViewID(self.mViewID)
    self:find("UIPlayerInfo"):open()
end

function M:playTimeRevert(time)
    self:stopTimeRevert()
    self.node_buff:setVisible(true)
    self.spr_buff:stopAllActions()
    local act = cc.RepeatForever:create(cc.RotateBy:create(6, 360))
    self.spr_buff:runAction(act)
    
    if self.is_self == false then
        return 
    end
    self.txt_timecount:setString(time.."S")
    self.TimeRevertCount = time
    self.startTime = os.time()
    local callback = function ( ... )
        local cur = os.time()
        local curCount = self.TimeRevertCount - (cur - self.startTime)
        self.txt_timecount:setString(curCount.."S")
        if curCount <= 0 then
            self:stopTimeRevert()
            self:find("SKTimeRevert"):sendStopSkill(0)
        end
    end
    local delay = cc.DelayTime:create(1)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    local action = cc.RepeatForever:create(sequence)
    self.node_buff:runAction(action)

end

function M:stopTimeRevert()
    self.node_buff:setVisible(false)
    self.node_buff:stopAllActions()
    self.spr_buff:stopAllActions()
end

function M:playViolentAct()
    self.node_violent:setVisible(true)
    self:coroutine(self, "playViolentActImpl")
end

function M:playViolentActImpl()
    self.node_violent_1:setVisible(true)
    self.node_violent_2:setVisible(false)
    self.node_violent_1.animation:play("beginkb",false)
    wls.WaitForSeconds(55/60)
    self.node_violent_1:setVisible(false)
    self.node_violent_2:setVisible(true)
    self.node_violent_2.animation:play("loopkb",true)
end

function M:stopViolentAct()
    self.node_violent:setVisible(false)
    self.node_violent_2.animation:play("loopkb",false)
end

-----------------------------
-- 显示数据处理
-----------------------------

-- 获得宝石
function M:getGem()
    return self.fnt_diamonds.cur
end

-- 设置宝石
function M:setGem(val)
    self.fnt_diamonds.cur = val
    self.fnt_diamonds:setString(val)
end

-- 修改宝石
function M:opGem(val)
    self.fnt_diamonds.cur = self.fnt_diamonds.cur + val
    self.fnt_diamonds:setString(self.fnt_diamonds.cur)
end

-- 获得金币
function M:getCoin()
    return self.fnt_coins.cur
end

-- 设置金币
function M:setCoin(val)
    self.fnt_coins.cur = val
    self.fnt_coins:setString(val)
end

-- 修改金币
function M:opCoin(val)
    self.fnt_coins.cur = self.fnt_coins.cur + val
    self.fnt_coins:setString(self.fnt_coins.cur)
end

-- 获得炮倍率
function M:getGunRate()
    return self.fnt_multiple.cur
end

-- 设置炮倍率
function M:setGunRate(val)
    self.fnt_multiple.cur = val
    self.fnt_multiple:setString(val)
end

return M