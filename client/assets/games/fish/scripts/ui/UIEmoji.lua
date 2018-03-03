----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2018-02-23
-- 描述：表情界面
----------------------------------------------------------------------

local M = class("UIEmoji", wls.UIGameObject)

local TAB_NORMAL_COLOR = cc.c3b(22, 67, 108)
local TAB_SELECT_COLOR = cc.c3b(31, 106, 174)
local OFFSET_X = 40
local OFFSET_Y = -45
local ITEM_W = (500 - 40 * 2) / 4
local ITEM_H = (340 - 85) / 2
local EMOJI_ID_VAL = 400000000
local EMOJI_RECT = cc.rect(0, 0, 120, 120)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/emoji/uiemoji.csb"), true)
    if wls.SelfViewID == 1 then
        self:setPosition(150, 150)
    else
        self:setPosition(display.width - 600, 150)
    end

    local tb = {{}, {}}
    for _, v in pairs(self:require("emoji")) do
        v.id = tonumber(v.id)
        if tonumber(v.tab_num) == 1 then
            table.insert(tb[1], v)
        elseif tonumber(v.tab_num) == 2 then
            table.insert(tb[2], v)
        end
    end
    table.sort(tb[1], function(a, b) return a.id > b.id end)
    table.sort(tb[2], function(a, b) return a.id > b.id end)
    self._emojiCfg = tb

    -- 创建tab栏的表情图标
    for i=1,2 do
        local subSprite = cc.Sprite:createWithSpriteFrameName(self:fullPath("ui/images/emoji/"..tb[i][8].emoji_res.."_".."00.png"))
        subSprite:setScale(0.65)
        if i == 1 then subSprite:setPosition(self.Image_11:getPosition()) end
        if i == 2 then subSprite:setPosition(self.Image_12:getPosition()) end
        self.nd_emoji:addChild(subSprite)
    end
    self.Image_11:onClicked(function() self:onClickTab(1) end)
    self.Image_12:onClicked(function() self:onClickTab(2) end)

    self._emojiTb = {}
    self:onClickTab(1)
    self:setVisible(false)
end

function M:onClickTab(index)
    local color_11 = index == 1 and TAB_SELECT_COLOR or TAB_NORMAL_COLOR
    self.Image_11:setColor(color_11)
    local color_12 = index == 2 and TAB_SELECT_COLOR or TAB_NORMAL_COLOR
    self.Image_12:setColor(color_12)

    for i,v in ipairs(self._emojiTb) do
        v:removeFromParent()
    end
    self._emojiTb = {}

    for i,v in ipairs(self._emojiCfg[index]) do
        local item = self:createEmojiBtn(i, v)
        table.insert(self._emojiTb, item)
    end
end

function M:createEmojiBtn(idx, cfg)
    local x = OFFSET_X + idx % 4 * ITEM_W + ITEM_W / 2 
    local y = OFFSET_Y + math.ceil(idx / 4) * ITEM_H + ITEM_H / 2

    local item = ccui.Layout:create()
    item:setContentSize(cc.size(ITEM_W, ITEM_H))
    item:setTag(tonumber(cfg.id))
    item:setAnchorPoint(cc.p(0.5, 0.5))
    item:setPosition(cc.p(x, y))
    item:setTouchEnabled(true)
    item:onClicked(function() self:sendEmoji(cfg) end)
    self.nd_emoji:addChild(item)

    local emoji = cc.Sprite:createWithSpriteFrameName(self:fullPath("ui/images/emoji/"..cfg.emoji_res.."_".."00.png"))
    emoji:setPosition(cc.p(ITEM_W / 2, ITEM_H / 2))
    item:addChild(emoji)

    return item
end

-- 发送表情消息
function M:sendEmoji(cfg)
    self:setVisible(false)
    if self._isShowing then
        wls.Toast(self:find("SCConfig"):getLanguageByID(800000181))
        return
    end

    local id = tonumber(cfg.id) - EMOJI_ID_VAL
    wls.SendMsg("sendEmotionIcon", id)
end

-- 播放表情
function M:showEmoticonAni(viewID, emoticonId)
    self._isShowing = true
    emoticonId = emoticonId + EMOJI_ID_VAL
    local cannon = self:find("UICannon" .. viewID)
    local bg = self:createEmoticonBg()
    cannon:addChild(bg, 10000)

    local emoji = self:createEmoji(self:require("emoji")[tostring(emoticonId)])
    local rect = bg:getTextureRect()
    emoji:setPosition(rect.width /2, rect.height /2)
    bg:addChild(emoji)

    local deltX = 85
    local deltY = 165
    if viewID == 1 then
        bg:setRotation(180)
        bg:setPosition(cc.p(deltX, deltY))
        emoji:setRotation(180)
    elseif viewID == 2 then
        bg:setRotationSkewX(180)
        bg:setPosition(cc.p(-deltX, deltY))
        emoji:setRotationSkewX(180)
    elseif viewID == 3 then
        bg:setRotationSkewY(180)
        bg:setPosition(cc.p(-deltX, -deltY))
    elseif viewID == 4 then
        bg:setPosition(cc.p(deltX, -deltY))
        emoji:setRotationSkewY(180)
    end
end

function M:createEmoticonBg()
    local bg = cc.Sprite:createWithSpriteFrameName(self:fullPath("ui/images/emoji/emoji_popup.png"))
    bg:setScale(0)
    local popAni = cc.Sequence:create(
        cc.ScaleTo:create(0.0, 0.1),
        cc.ScaleTo:create(0.25, 1),
        cc.ScaleTo:create(0.13, 1, 0.9),
        cc.ScaleTo:create(0.12, 1.0), 
        cc.ScaleTo:create(2.5, 1.0), 
        cc.ScaleTo:create(0.15, 1.1), 
        cc.ScaleTo:create(0.1, 0.1), 
        cc.CallFunc:create(function()     
            bg:removeFromParent()
            self._isShowing = false
        end)
    )
    bg:runAction(popAni)
    return bg
end

function M:createEmoji(cfg)
    local emoji = cc.Sprite:create()
    local animation = cc.Animation:create()
    animation:addSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(self:fullPath("ui/images/emoji/"..cfg.emoji_res.."_".."00.png")))
    animation:addSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(self:fullPath("ui/images/emoji/"..cfg.emoji_res.."_".."01.png")))
    animation:setDelayPerUnit(0.3)
    local action = cc.Animate:create(animation)
    emoji:runAction(cc.Repeat:create(action, 5))
    return emoji
end

function M:onEventTouchBegan()
    self:setVisible(false)
end

return M