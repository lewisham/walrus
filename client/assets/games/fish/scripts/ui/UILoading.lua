----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：加载界面
----------------------------------------------------------------------

local M = class("UILoading", wls.UIGameObject)

function M:getZorder()
    return 100
end

function M:onCreate()
    self:loadCsb(self:fullPath("ui/uiLoadingLayer.csb"), true)
    self.sliderScale = self.slider_loading:getScale()
    self:updatePercent(0)
    local action = cc.CSLoader:createTimeline(self:fullPath("ui/uiLoadingLayer.csb"))
    self:runAction(action)
    action:gotoFrameAndPlay(0)
    local ids = {}
    for i = 0, 9 do
        table.insert(ids, {i, math.random(1, 100)})
    end
    table.sort(ids, function(a, b) return a[2] < b[2] end )
    self.ids = ids
    self.textIdx = 1
    self:showText()
    self:startTimer(2.0, "onTipsTimer", nil, -1)
end

function M:onTipsTimer()
    self:showText()
end

function M:showText()
    self.textIdx = self.textIdx + 1
    if self.textIdx > #self.ids then
        self.textIdx = 1
    end
    local idx = self.ids[self.textIdx][1]
    self.text_message:setString(self:require("language")[tostring(800000059 + idx)].ch)
end

function M:calcLoadRes()
    local list = {}
    -- 鱼的资源
    for _, val in pairs(self:require("fish")) do
        local unit = {}
        unit.type = 1
        unit.filename = string.format("games/fish/assets/plist/fish/%s.plist", val.fish_res)
        table.insert(list, unit)
    end
    -- 鱼网
    for i = 1, 10 do
        local unit = {}
        unit.type = 1
        unit.filename = string.format("games/fish/assets/plist/nets/net_%d.plist", i)
        table.insert(list, unit)
    end
    -- 子弹开火效果
    table.insert(list, {type = 1, filename = "games/fish/assets/ui/images/effect/guns_fire.plist"})
    table.insert(list, {type = 1, filename = "games/fish/assets/plist/bullet/bullet.plist"})

    -- 特效图
    table.insert(list, {type = 1, filename = "games/fish/assets/ui/images/effect/blast.plist"})
    table.insert(list, {type = 1, filename = "games/fish/assets/ui/images/effect/bomb.plist"})
    table.insert(list, {type = 1, filename = "games/fish/assets/ui/images/effect/combo.plist"})

    -- 金币
    table.insert(list, {type = 1, filename = "games/fish/assets/plist/coin/friend_coin1.plist"})
    table.insert(list, {type = 1, filename = "games/fish/assets/plist/coin/friend_coin2.plist"})
    table.insert(list, {type = 1, filename = "games/fish/assets/plist/coin/game_coin1.plist"})
    table.insert(list, {type = 1, filename = "games/fish/assets/plist/coin/game_coin2.plist"})

    -- 声音资源
    for key, _ in pairs(self:require("SoundPath")) do
        table.insert(list, {type = 2, filename = key})
    end
    return list

end

function M:play()
    cc.SimpleAudioEngine:getInstance():stopMusic()
    local list = self:calcLoadRes()
    local total = #list
    for idx, val in ipairs(list) do
        if val.type == 1 then
            cc.SpriteFrameCache:getInstance():addSpriteFrames(val.filename)
        elseif val.type == 2 then
            self:find("SCSound"):preload(val.filename)
        end
        self:updatePercent(idx / total * 100)
        wls.WaitForFrames(1)
    end
    self:find("SCSound"):playMusic("music_00" .. wls.RoomIdx)
end

function M:updatePercent(per)
    self.slider_loading:setPercent(per)
    local scaleY = self.sliderScale
    local scaleDis = 3
    if per > 100-scaleDis then
        scaleY = (100 - per)/scaleDis*scaleY
    end
    if per <= scaleDis then
        scaleY = per/scaleDis*scaleY
    end

    local size = self.slider_loading:getContentSize()
    self.spr_bar_light:setPositionX(size.width*per/100)
    self.spr_bar_light:setScale(scaleY)
end

return M