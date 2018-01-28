----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：炮台
----------------------------------------------------------------------

local pos_list = 
{
    cc.p(330, 0), 
    cc.p(display.width - 330, 0), 
    cc.p(display.width - 330, display.height),
    cc.p(330, display.height),
}

local M = class("UICannon", UIBase)

function M:onCreate(viewID)
    self.mViewID = viewID
    self:loadCsb(self:fullPath("ui/uicannon.csb"))
    self:initDir(viewID)
    self.cannonWorldPos = self.node_gun:convertToWorldSpaceAR(cc.p(0, 0))
    self:initGunFirAction()
    self:reset()
end

function M:reset()
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
end

function M:initDir(viewID)
    self:setPosition(pos_list[viewID])
    if viewID == 2  then
        self.spr_coin_bg:setPositionX(-self.spr_coin_bg:getPositionX())
        self.fnt_curadd:setPositionX(-self.fnt_curadd:getPositionX())
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

-- 开火
function M:fire(angle)
    self:updateAngle(angle)
    local extra = self.mViewID >= 3 and 180 or 0
    local pos = self.Node_launcher:convertToWorldSpaceAR(cc.p(0, 0))
    self:find("SCPool"):createNormalBullet(self.mViewID, self.config.id, pos, angle + extra)
    self:playFireAni()
end

-- 预处理开火
function M:firePre(angle)
    self:updateAngle(angle)
    local extra = self.mViewID >= 3 and 180 or 0
    local pos = self.Node_launcher:convertToWorldSpaceAR(cc.p(0, 0))
    self:find("SCPool"):createNormalBullet(self.mViewID, self.config.id, pos, angle + extra)
    self:playFireAni()
    local money = tonumber(self.fnt_coins:getString())
    local rate = tonumber(self.fnt_multiple:getString())
    money = money - rate
    self.fnt_coins:setString(money)
end

-- 炮开火动画
function M:playFireAni()
    if self.is_self then
        self:find("SCSound"):playSound("gunfire_01")
    end
    self.spr_cannon:stopAllActions()
    local act = cc.Sequence:create(cc.ScaleTo:create(0.05, 1, 0.8), cc.ScaleTo:create(0.05, 1, 1))
    self.spr_cannon:runAction(act)
    self.spr_gunfire:runAction(self.gunFireAction)
end

function M:updateAngle(angle)
    local extra = self.mViewID >= 3 and 180 or 0
    self.node_gun:setRotation(-angle + 90)
end

function M:join(info)
    self:reset()
    self:setVisible(true)
    self:updateGun(info.gun_id)
    self.fnt_multiple:setString(info.gun_rate)
    self.fnt_coins:setString(info.coin)
    self.fnt_diamonds:setString(info.diamonds)
    self.spr_coin_bg:setVisible(true)
    self.is_self = info.is_self
    if not info.is_self then return end
    self:createMenuNode()
    self.panel_1:setTouchEnabled(true)
    self.panel_1:onClicked(function() self:click_panel() end)
    self.btn_minus:setVisible(true)
    self.btn_add:setVisible(true)
    self.spr_circle:setVisible(true)
    self.spr_circle:runAction(cc.RepeatForever:create(cc.RotateBy:create(5.0, 360)))
end

function M:createMenuNode()
    if self:find("UIGunChange") then return end
    self:createGameObject("UIGunChange", self.mViewID):setPosition(self:convertToWorldSpaceAR(cc.p(0, 62)))
end

-- 更新枪
function M:updateGun(id)
    id = 930000000 + id
    local config = self:require("cannonoutlook")[tostring(id)]
    self.config = config
    self.spr_cannon_base:setTexture(self:fullPath("bg/".. config.base_img))
    self.spr_cannon:setTexture(self:fullPath("bg/".. config.cannon_img))
end

function M:updateCoin(coin)
    self.fnt_coins:setString(coin)
end

function M:click_btn_add()
end

function M:click_btn_minus()
end

function M:click_panel()
    self:find("UIGunChange"):show()
end

return M