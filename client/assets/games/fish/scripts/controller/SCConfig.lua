----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：数据配置
----------------------------------------------------------------------

local M = class("SCConfig", wls.GameObject)

function M:onCreate()
    
end

function M:initHallData()
    self:initItem()
    self:initGunRate()
end

function M:initGameData()
    self:initConfig()
    self:parsePath()
    self:parseFish()
    self:initGunRate()
    self:initHandBook()
    self:initItem()
    self:initLanguage()
end

-- 加载配置表
function M:initConfig()
    local tb = {}
    for _, val in pairs(self:require("config")) do
        tb[val.id] = val.data
    end
    self:set("config", tb)
end

-- 得到配置数据
function M:getConfigByID(id)
    return  self:get("config")[tonumber(id)] or ""
end

-- 解析鱼游的路径
function M:parsePath()
    local tb = {}
    local scaleY = display.height / 720
    for _, val in pairs(self:require("fishpathEx")) do
        local list = {}
        for _, v2 in ipairs(string.split(val.pointdata, ";")) do
            if v2 ~= "" then
                local t2 = string.split(v2, ",")
                local unit = {}
                unit.pos = cc.p(tonumber(t2[1]), tonumber(t2[2]))
                unit.pos.y = unit.pos.y * scaleY
                unit.angle = tonumber(t2[3])
                unit.vec = cc.p(math.sin(unit.angle), math.cos(unit.angle))
                table.insert(list, unit)
            end
        end
        tb[val.id] = list
    end
    self:set("path", tb)
end

-- 解析鱼
function M:parseFish()
    local fish = self:require("fish")
    for _, val in pairs(fish) do
        local tb = string.split(val.point_info, ";")
        val.vertices = {}
        for _, str in ipairs(tb) do
            if str ~= "" then
                local points = string.split(str, ",")
                table.insert(val.vertices, cc.p(tonumber(points[1]), tonumber(points[2])))
            end
        end
        val.score = tonumber(val.score)
        val.raduis = self:calcRaduisByVertices(val.vertices)
        --print(val.name, val.raduis)
    end
    self:set("fish", fish)
end

-- 计算多边形的最大半径
function M:calcRaduisByVertices(vertices)
    local raduis = 0
    for _, val in ipairs(vertices) do
        local length = cc.pGetLength(val)
        if length > raduis then
            raduis = length
        end
    end
    return raduis
end

-- 鱼潮数据
function M:getFishGroup(id)
    id = 330000000 + id * 100000
    local fishgroup = self:require("fishgroup")
    local tb = {}
    local maxFrame = 0
    while true do
        local config = fishgroup[tostring(id)]
        if config == nil then break end
        if config.arrId == "" then break end
        local frame = tonumber(config.frame)
        maxFrame = frame > maxFrame and frame or maxFrame
        local unit = tb[frame]
        if unit == nil then
            unit = {}
            unit.frame = frame
            unit.fishes = {}
            tb[frame] = unit
        end
        local val = {}
        val.id = id
        val.fisharrid = config.arrId
        table.insert(unit.fishes, val)
        id = id + 1
    end
    return tb, maxFrame
end

-- 鱼时间线数据
function M:getFishTimeline(id)
    local timeline = self:require("timeline")
    local tb = {}
    local maxFrame = 0
    while true do
        local config = timeline[tostring(id)]
        if config == nil then break end
        if config.fishid == "" then break end
        local frame = tonumber(config.frame)
        maxFrame = frame > maxFrame and frame or maxFrame
        local unit = tb[frame]
        if unit == nil then
            unit = {}
            unit.frame = frame
            unit.fishes = {}
            tb[frame] = unit
        end
        table.insert(unit.fishes, {config.fishid, config.pathid, id})
        id = id + 1
    end
    return tb, maxFrame
end

-- 鱼串
function M:getFishArray(id)
    id = 310000000 + id * 1000
    local fisharray = self:require("fisharray")
    local tb = {}
    local maxFrame = 0
    while true do
        local config = fisharray[tostring(id)]
        if config == nil then break end
        if config.fishid == "" then break end
        local frame = tonumber(config.frame)
        maxFrame = frame > maxFrame and frame or maxFrame
        local unit = tb[frame]
        if unit == nil then
            unit = {}
            unit.frame = frame
            unit.fishes = {}
            unit.id = id
            tb[frame] = unit
        end
        local fc = {}
        fc.fishid = config.fishid
        fc.trace = config.trace
        fc.offset = cc.p(tonumber(config.offsetx), tonumber(config.offsety))
        fc.arrayid = id
        table.insert(unit.fishes, fc)
        id = id + 1
    end
    return tb, maxFrame
end

local function splitNumber(str, sDiv)
    local retList = {}
    str:gsub('[^'..sDiv..']+', function(sRet) table.insert(retList, tonumber(sRet)) end)
    return retList
end

-- 鱼组
function M:getFishchildren(id)
    local config = clone(self:require("fishchildren")[id])
    config.fishcount = tonumber(config.fishcount)
    config.bgindex = splitNumber(config.bgindex, ";")
    config.bgscale = splitNumber(config.bgscale, ";")
    config.fishid = splitNumber(config.fishid, ";")
    config.fishscale = splitNumber(config.fishscale, ";")
    local tb = string.split(config.offset, ";")
    config.offset = {}
    for _, str in ipairs(tb) do
        local points = string.split(str, ",")
        table.insert(config.offset, cc.p(tonumber(points[1]), tonumber(points[2])))
    end
    return config
end

-- 初始化炮的倍率
function M:initGunRate()
    local tb = {}
    for _, val in pairs(self:require("cannon")) do
        local unit = {}
        unit.times = tonumber(val.times)
        unit.interval = tonumber(val.interval)
        unit.unlock_gem = tonumber(val.unlock_gem)
        unit.unlock_award = tonumber(val.unlock_award)
        unit.unlock_prob = tonumber(val.unlock_prob)
        unit.succ_need = tonumber(val.succ_need)
        if val.unlock_item == "" then unit.unlock_item = nil else unit.unlock_item = string.split(val.unlock_item, ",") end
        table.insert(tb, unit)
    end
    table.sort(tb, function(a, b) return a.times < b. times end)
    self:set("cannon", tb)
end

-- 图鉴数据
function M:initHandBook()
    local tb = {}
    local roomIdx = 910000000 + wls.RoomIdx
    for _, v in pairs(self:require("roomfish")) do
        if tonumber(v.room_id) == roomIdx then
            if v.show_score == nil or v.show_score == "" then
                v.show_score = 0
            end
            v.id = tonumber(v.id)
            v.fish_id = tonumber(v.fish_id)
            v.show_score = tonumber(v.show_score)
            v.fish_type = tonumber(v.fish_type)
            table.insert(tb, v)
        end
    end
    table.sort(tb, function(a, b) return a.id < b.id end)
    self:set("hand_book", tb)
end

-- -- 道具数据
function M:initItem()
    local tb = {}
    for _, v in pairs(self:require("item")) do
        table.insert(tb, v)
    end
    table.sort(tb, function(a, b) return a.id < b.id end)
    self:set("item", tb)
end

--获取没有数量也必须显示的道具数据表
function M:getDefaultShowItem()
    local tb = {}
    local list = self:get("item")
    for k,v in pairs(list) do
        if tonumber(v.default_show) == 1 then
            tb[v.id-200000000] = {propId = v.id-200000000, propCount = 0}
        end
    end

    return tb
end

-- 得到道具数据
function M:getItemData(propId)
    local list = self:get("item")
    for k,v in pairs(list) do
        if (propId + 200000000) == tonumber(v.id) then
            return v
        end
    end
end

-- 得到技能数据
function M:getSkillData(propId)
    for _, v in pairs(self:require("skill")) do
        if propId == tonumber(v.item_need) then
            return v
        end
    end
end

-- 得到核弹数据
function M:getBombData(propId)
    for _, v in pairs(self:require("bomb")) do
        if (propId + 200000000) == tonumber(v.item_id) then
            return v
        end
    end
end

function M:initLanguage()
    local tb = {}
    for _, v in pairs(self:require("language")) do
        tb[v.id] = v.ch
    end
    self:set("language", tb)
end

-- 得到中文数据
function M:getLanguageByID(id)
    return self:get("language")[tostring(id)]
end

return M