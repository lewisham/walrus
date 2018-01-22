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
    self:reset()
end

function M:reset()
    self.mMenuNode = nil
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

function M:fire(rotation)
    local extra = self.mViewID >= 3 and 180 or 0
    self.node_gun:setRotation(-rotation + 90)
    local pos = self.Node_launcher:convertToWorldSpaceAR(cc.p(0, 0))
    self:find("SCPool"):createNormalBullet(self.mViewID, self.config.id, pos, rotation + extra)
    self:playFireAni()
end

function M:playFireAni()
    self:find("SCSound"):playSound("gunfire_01")
    self.spr_cannon:stopAllActions()
    local act = cc.Sequence:create(cc.ScaleTo:create(0.05, 1, 0.8), cc.ScaleTo:create(0.05, 1, 1))
    self.spr_cannon:runAction(act)
end

function M:join(info)
    self:reset()
    self:setVisible(true)
    self:updateGun(info.gun_id)
    self.fnt_multiple:setString(info.gun_rate)
    self.fnt_coins:setString(info.coin)
    self.fnt_diamonds:setString(info.diamonds)
    self.spr_coin_bg:setVisible(true)
    if not info.is_self then return end
    self.panel_1:setTouchEnabled(true)
    self.panel_1:onClicked(function() self:click_panel() end)
    self.btn_minus:setVisible(true)
    self.btn_add:setVisible(true)
    self.spr_circle:setVisible(true)
    self.spr_circle:runAction(cc.RepeatForever:create(cc.RotateBy:create(5.0, 360)))
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
    self:createMenuNode()
    self.mMenuNode:setVisible(true)
    local bAutoFire = self:getScene():get("auto_fire")
    self.mMenuNode.spr_autofire:setVisible(not bAutoFire)
    self.mMenuNode.spr_cancelauto:setVisible(bAutoFire)
end

function M:createMenuNode()
    if self.mMenuNode then return end
    self.mMenuNode = LoadCsb(self:fullPath("ui/uigunchange.csb"))
    self:addChild(self.mMenuNode, 10)
    self.mMenuNode:setPosition(cc.p(0, 62))
    BindToUI(self.mMenuNode, self.mMenuNode)
    self.mMenuNode.btn_autofire:onClicked(function() self:click_auto_fire() end)
    self.mMenuNode.btn_face:onClicked(function() self:click_btn_face() end)
    self.mMenuNode.btn_changecannon:onClicked(function() self:click_btn_changecannon() end)
end

function M:click_auto_fire()
    self.mMenuNode:setVisible(false)
    local bAutoFire = not self:getScene():get("auto_fire")
    self:getScene():set("auto_fire", bAutoFire)
    if not bAutoFire then
        self:find("UITouch"):stopTimer()
    end
end

function M:click_btn_face()
    self.mMenuNode:setVisible(false)
end

function M:click_btn_changecannon()
    self.mMenuNode:setVisible(false)
end

return M