----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：炮台
----------------------------------------------------------------------

local pos_list = 
{
    cc.p(300, 0), 
    cc.p(display.width - 300, 0), 
    cc.p(display.width - 300, display.height),
    cc.p(300, display.height),
}

local M = class("UICannon", UIBase)

function M:onCreate(viewID)
    self.mViewID = viewID
    self:loadCsb("games/fish/assets/ui/uicannon.csb")
    self:setPosition(pos_list[viewID])
    self.spr_coin_bg:setVisible(false)
    self.fnt_curadd:setVisible(false)
    self.spr_gun_lock:setVisible(false)
    self.spr_bankrupt:setVisible(false)
    self.spr_light:setVisible(false)
    self.spr_gunfire:setVisible(false)
    self.btn_minus:setVisible(false)
    self.btn_add:setVisible(false)
    self.spr_circle:setVisible(false)
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
    self.cannonWorldPos = self.node_gun:convertToWorldSpaceAR(cc.p(0, 0))
    self:updateGun(1)
    self:setVisible(false)
end

function M:onEventFire(viewID, pos)
    if self.mViewID ~= viewID then return end
    local cnt = self:find("SCPool"):calcBulletCnt(self.mViewID)
    if cnt >= FCDefine.MAX_BULLET_CNT then
        Toast("屏幕上子弹太多")
        return
    end
    local vec = cc.pSub(pos, self.cannonWorldPos)
    local rotation = math.atan2(vec.y, vec.x) * 180 / PI
    local extra = self.mViewID >= 3 and 270 or 90
    self.node_gun:setRotation(-rotation + extra)
    local pos = self.Node_launcher:convertToWorldSpaceAR(cc.p(0, 0))
    self:find("SCPool"):createNormalBullet(self.mViewID, self.config.id, pos, rotation)
    self:playFireAni()
end

function M:playFireAni()
    self:find("SCSound"):playSound("gunfire_01")
    self.spr_cannon:stopAllActions()
    local act = cc.Sequence:create(cc.ScaleTo:create(0.05, 1, 0.8), cc.ScaleTo:create(0.05, 1, 1))
    self.spr_cannon:runAction(act)
end

function M:join(id)
    self:setVisible(true)
    self:updateGun(id)
end

-- 更新枪
function M:updateGun(id)
    id = 930000000 + id
    local config = self:require("cannonoutlook")[tostring(id)]
    self.config = config
    self.spr_cannon_base:setTexture(self:fullPath("images/battle/cannon/".. config.base_img))
    self.spr_cannon:setTexture(self:fullPath("images/battle/cannon/".. config.cannon_img))
end

return M