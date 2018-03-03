----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：大厅背景界面
----------------------------------------------------------------------
local ROOM_LIST = {
    {["varname"] = "room1", ["lv"] = 1, ["index"] = 1},
    {["varname"] = "room2", ["lv"] = 2, ["index"] = 2},
    {["varname"] = "room3", ["lv"] = 3, ["index"] = 3},
    {["varname"] = "room4", ["lv"] = 4, ["index"] = 4},
}
local M = class("UIHallBackGround", wls.UIGameObject)

function M:getZorder()
    return -1
end

function M:onCreate()
    local uiRooms = {}
    self:loadCsb(self:fullPath("hall/fish_hall_bg.csb"))
    for key, val in ipairs(ROOM_LIST) do
        if self[val.varname] == nil then
            break;
        end
        local gameObject = self:wrapGameObject(self[val.varname], "UIRoom")
        gameObject:setRoomLV(val["lv"])
        gameObject:set("posIndex", val["index"])
        table.insert(uiRooms, gameObject)
    end
    self:set("uiRooms", uiRooms)
end

function M:refreshWithData(data)
    
end

function M:scroll(beginPos, endPos)
    local uiRooms = self:get("uiRooms")
    local isValid = false
    for key, val in ipairs(uiRooms) do
        if val:isClicked(beginPos) then
            isValid = true;
        end
    end

    if isValid == false then
        return;
    end
    for key, val in ipairs(uiRooms) do
        if endPos.x > beginPos.x then
            val:scrollToRight()
        else
            val:scrollToLeft()
        end
    end
end

function M:click(endPos)
    local uiRooms = self:get("uiRooms")
    for key, val in ipairs(uiRooms) do
        if val:isClicked(endPos) then
            val:clicked(endPos)
        end
    end
end





return M