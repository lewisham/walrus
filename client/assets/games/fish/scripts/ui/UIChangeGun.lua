----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2018-02-23
-- 描述：换炮界面
----------------------------------------------------------------------

local M = class("UIChangeGun", wls.UIGameObject)

local GunCnt = 10

function M:onCreate()
    self:createMask()
    self:loadCenterNode(self:fullPath("ui/selectcannon/uiselectcannon.csb"), true)
    self.scroll_list:setSwallowTouches(false)
    self.scroll_list:setScrollBarEnabled(false)

    -- todo 测试数据
    self._playerVip = 1     -- 玩家的VIP等级
    self._curCannon = 0     -- 当前使用的炮
    self._tasteCannon = 5   -- 体验炮的id
    -- test end

    self.gunCardArr = {}
    self:createGun()
end

function M:createGun()
    local cell_h_count = 4      -- 格子横向数
    local cell_v_count = 1      -- 格子纵向数
    local cellCountSize = self.scroll_list:getContentSize()
    -- 计算出每个格子的宽高
    local cellW = cellCountSize.width / cell_h_count
    local cellH = cellCountSize.height / cell_v_count

    for i=1,GunCnt do
        local gunCard = self:createGunCardByVIP(i - 1)
        self.gunCardArr[i] = gunCard
        gunCard:setPosition(cc.p(cellW / 2 + cellW * (i - 1), cellH / 2))
        self.scroll_list:addChild(gunCard)
    end
    self.scroll_list:setInnerContainerSize(cc.size(cellW * GunCnt, cellH))
end

function M:createGunCardByVIP(gunLv)
    local item = wls.LoadCsb(self:fullPath("ui/selectcannon/uiguncard.csb"))
    wls.BindToUI(item, item)
    item:setTag(gunLv)
    item.spr_vip:setTexture(self:fullPath("ui/images/common/vip/vip_badge_" .. gunLv .. ".png"))
    item.spr_nane:setSpriteFrame(self:fullPath("ui/images/selectcannon/selectcannon_pic_title_" .. gunLv .. ".png"))
    item.spr_gun:setSpriteFrame(self:fullPath("ui/images/cannon/bl_gun_" .. string.format("%02d", gunLv + 1) .. ".png"))
    item.spr_base:setSpriteFrame(self:fullPath("ui/images/cannon/bl_cannon_base_01.png"))
    
    item.btn_use:onClicked(function() self:onClickUse(item) end)
    item.btn_get:onClicked(function() self:onClickGet(item) end)
    item.btn_taste:onClicked(function() self:onClickTaste(item) end)
    self:updateGunItem(item)
    
    return item
end

function M:updateGunItem(item)
    -- warming 下面代码设置状态使用测试数据
    -- 设置解锁状态
    local gunLv = item:getTag()
    item.spr_lock:setVisible(self._playerVip < gunLv)
    item.img_taste:setVisible(self._tasteCannon == gunLv)

    if self._curCannon == gunLv then 
        self:setGunItemState(item, 1)
    elseif self._tasteCannon == gunLv then
        self:setGunItemState(item, 3)
    elseif gunLv <= self._playerVip then
        self:setGunItemState(item, 2)
    else
        self:setGunItemState(item, 4)
    end
end

-- 设置炮的item状态 1:已装备 2:未装备 3:体验 4:获取
function M:setGunItemState(item, state)
    item.btn_use:setVisible(state == 1 or state == 2)
    item.btn_use:setEnabled(state == 2)
    item.spr_zb:setVisible(state == 2)
    item.spr_yzb:setVisible(state == 1)
    item.btn_get:setVisible(state == 4)
    item.btn_taste:setVisible(state == 3)
end

-- 使用炮
function M:onClickUse(sender)
    print("装备炮"..sender:getTag())
end

-- 获取炮
function M:onClickGet(sender)
    print("获取炮"..sender:getTag())
end

-- 体验
function M:onClickTaste(sender)
    print("体验炮"..sender:getTag())
end

function M:click_btn_close()
    wls.SafeRemoveNode(self)
end

return M