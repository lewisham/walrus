----------------------------------------------------------------------
-- 作者：Lihq
-- 日期：2018-2-26
-- 描述：玩家信息界面
----------------------------------------------------------------------

local M = class("UIPlayerInfo", wls.UIGameObject)

--弹窗位置
local showPosTb = 
{
    cc.p(320, 320), 
    cc.p(display.width - 320, 320), 
    cc.p(display.width - 320,  display.height - 160),
    cc.p(320,  display.height - 160)    
}

function M:onCreate()
    self:loadCsb(self:fullPath("ui/playerinfo/uigameplayerinfo.csb"), true)
    self:setVisible(false)
    self.BASE_PATH = "ui/images/magicprop/magicproppic/"
    self.magicData = self:getMgicData()
end

--设置点击的是那个view
function M:setShowViewID(viewID)
    self.mViewID = viewID
end

--界面入口函数
function M:open()
    self.panel:stopAllActions()
    self.panel:setVisible(true)
    self.panel:setOpacity(255)
    self:setVisible(true)
    self:initView()
end

--更新角色信息
function M:initView()
    self:setPosition(showPosTb[self.mViewID])
    self.text_word_dqyb:setString("玩家ID")
    self.text_word_gunname:setString("炮台")
    self.text_word_zgpb:setString("最高炮倍")
    self.text_word_dqdj:setString("当前等级")
    self.text_toplayer:setString("怼他")

    self:initPropScrollView()

    --判断是否能踢人。--房間是否是自己創建的？
    local bKickOut = fale       
    self.btn_kickout:setVisible(bKickOut)
    self.btn_kickout:setTouchEnabled(bKickOut)

    for key, var in pairs(self:find("SCGameClient").mPlayers) do
        if var.view_id == self.mViewID then
            self:initplayerInfo(var.playerInfo)
            return 
        end
    end
end

--设置角色信息--最高炮倍--名字
function M:initplayerInfo(playerInfo)
    self.text_rate:setString(playerInfo.maxGunRate) 
    self.text_name:setString(playerInfo.nickName) 
    self.text_playerid:setString(playerInfo.playerId) 
    --炮台图片
    local gunName = string.format("ui/images/selectcannon/selectcannon_pic_title_%d.png",(playerInfo.gunType-1))
    self.spr_gunname:setSpriteFrame(self:fullPath(gunName))
    --当前等级
    --self.text_grade:setString("") 
    --vip等级
    --local vipName = string.format("ui/images/common/vip/vip_badge_%d.png", playerInfo.vip_level)
    --self.spr_vip:setSpriteFrame(self:fullPath(vipName))
end

--加载道具信息
function M:initPropScrollView() 
    self.scroll_list:removeAllChildren()
    local propdatas = self.magicData 
    self.propItems = {}
    for i = 1, #propdatas do
        local propItem = self:initMagicPropItem(propdatas[i])   
        propItem:setAnchorPoint(0, 0)
        propItem:setPosition((i - 1)*116 + 58, 58)
        propItem:setContentSize(114, 114)
        self.scroll_list:addChild(propItem)
        self.propItems[i] = propItem
    end
    self.scroll_list:setInnerContainerSize(cc.size(116 * #propdatas, 116))
    self.scroll_list:setSwallowTouches(true)
    self.scroll_list:setScrollBarEnabled(false)
 end

--设置魔法道具信息
function M:initMagicPropItem(propdata)
    local itemPanel = wls.LoadCsb(self:fullPath("ui/magicitem/uipropitem.csb"))
    wls.BindToUI(itemPanel, itemPanel)
    --self:setPropVipInfo(propdata, itemPanel)
    --道具精灵
    local spriteImgName = self.BASE_PATH .. propdata.magicprop_res .. ".png"
    local propImg = cc.Sprite:createWithSpriteFrameName(self:fullPath(spriteImgName))
    propImg:setAnchorPoint(0.5, 0.5)
    propImg:setPosition(55, 55)
    itemPanel.spr_propbg:addChild(propImg, 0)
    itemPanel.propImg = propImg
    itemPanel.panel:onClicked(function()  
        self:onClickProp(propdata) 
    end)
    --临时代码
    itemPanel.img_subbg:setVisible(false)
    itemPanel.img_vip:setVisible(false)
    itemPanel.text_select:setVisible(false)
    itemPanel.img_select:setVisible(false)
    itemPanel.img_select:setTouchEnabled(false)
    return itemPanel
end

 --设置道具vip信息
 function M:setPropVipInfo(propdata, itemPanel)
    itemPanel.text_select:setVisible(false)
    itemPanel.text_select:setTextColor(cc.c4b(255, 255, 255, 255))
    itemPanel.img_vip:setVisible(true)
    local unlockVipLevel = propdata.unlock_vip
    local needDiaCount = propdata.cystal_need
    if unlockVipLevel == 0 and needDiaCount > 0 then
        itemPanel.font_diamon:setString(needDiaCount)
        itemPanel.img_subbg:setVisible(true)
    elseif unlockVipLevel == 0 and needDiaCount == 0 then
        itemPanel.text_select:setVisible(true)
        itemPanel.img_vip:setColor(cc.c3b(255, 72, 0))
        itemPanel.text_select:setString("免费")
    elseif unlockVipLevel > 0 then
        itemPanel.text_select:setVisible(true)
        itemPanel.img_vip:setColor(cc.c3b(0, 168, 204))
        itemPanel.text_select:setString("V"..tostring(unlockVipLevel))
        itemPanel.font_diamon:setString(needDiaCount)
        itemPanel.img_subbg:setVisible(true)
    end
 end

 --设置播动画标记
 function M:setShowingFlag(flag)
    self._isShowing = flag
 end

--根据视图id，获取取他的玩家id
function M:getPlayerIdByViewId(viewId)
    for key, var in pairs(self:find("SCGameClient").mPlayers) do
        if var.view_id == viewId then
            return var.playerInfo.playerId
        end
    end 
end

--点击道具
function M:onClickProp(propdata)
    self:setVisible(false)
    if self._isShowing then 
        wls.Toast(self:find("SCConfig"):getLanguageByID(800000182))
        return false
    end 
    --发送扔道具信息 , 道具id可能需要轉化？
    local toPlayerId = self:getPlayerIdByViewId(self.mViewID)
    wls.SendMsg("sendMagicProp", propdata.id, toPlayerId )
end

--踢出房间
function M:click_btn_kickout()
    self:setVisible(false)
    local toPlayerId = self:getPlayerIdByViewId(self.mViewID)
    wls.SendMsg("sendFriendKickOut", toPlayerId )
end

function M:onEventTouchBegan()
    if not self:isVisible() then return end
    self:setVisible(false)
    --模拟动画入口
    --self:find("UIMagicPropAni"):showPropAni(1, 3, 2)
    --self:onClickProp(self.magicData[4])
end

-- --测试数据 --self:require("emoji")
function M:getMgicData()
    local data =  {
        {id = 1, cystal_need = 0, unlock_vip = 0, magicprop_res = "magicprop01" },
        {id = 2, cystal_need = 0, unlock_vip = 0, magicprop_res = "magicprop02" },
        {id = 3, cystal_need = 0, unlock_vip = 0, magicprop_res = "magicprop03" },
        {id = 4, cystal_need = 2, unlock_vip = 0, magicprop_res = "magicprop04" },
        {id = 5, cystal_need = 2, unlock_vip = 1, magicprop_res = "magicprop05" },
    }
    return data
end

return M