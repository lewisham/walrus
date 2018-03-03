local COL = 4
local ROW = 4
local STEP = 50
local OFFSET = 6
local M = class("UIPackbackPanel", wls.UIGameObject)

function M:onCreate()
    self:loadCenterNode(self:fullPath("hall/packback_panel.csb"), true)
    self:wrapGameObject(self["node_info"], "UIPackabackItemInfo")


    self:readConfigs()
    self:sortConfigs()
    self:createItems()
    
    self:initWithConfig()

    self.scroll_bag_list:setScrollBarEnabled(false)
    self.scroll_bag_list:addTouchEventListener(handler(self, self.scroll_callback))
end

function M:createItems()
    local props = self:get("props")
    
    local baseNum = COL*COL
    local propNum = table.maxn(props)
    local needNum = (propNum > baseNum and math.floor(propNum/baseNum)*baseNum+ math.ceil((propNum-baseNum)/COL)*COL or baseNum)
    local scrollSize = self.scroll_bag_list:getContentSize()
    local baseSize = cc.size(scrollSize.width/COL, scrollSize.height/ROW)
    local distance = scrollSize.height/ROW
    local newScrollSize = cc.size(scrollSize.width, math.ceil(needNum/COL)*baseSize.height)
    self.scroll_bag_list:setInnerContainerSize(newScrollSize)

    print("scroll size width:"..scrollSize.width.." height:"..scrollSize.height)

    for key = 0, needNum-1 do
        local item = self:createGameObject("UIPackbackItem")
        local itemSize = item:getItemSize()
        local row = math.ceil((needNum-key)/ROW)
        local col = key%COL+1
        local pos = cc.p(itemSize.width/2+(col-1)*distance, itemSize.height/2+(row-1)*distance)
        item:setPosition(pos)
        
        wls.ChangeParentNode(item, self.scroll_bag_list)
        if key == 0 then 
            item:setSelected()
            self:set("selected", 1)
        end
    end

    
end

function M:readConfigs()
    local configs = {}
    local props = clone(self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]["props"])
    local seniorProps = clone(self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]["seniorProps"])


    --高级道具加入数量 方便后面统一处理判断
    for key, val in pairs(seniorProps) do
        val.propCount = 1
    end

    props = self:merge(props, seniorProps)

    --加入没有数量也要显示道具的数据
    local defaultShowItems = self:find("SCConfig"):getDefaultShowItem()
    for key, val in ipairs(props) do
        if defaultShowItems[val.propId] then
            table.remove(defaultShowItems, val.propId)
        end
    end
    props = self:merge(props, defaultShowItems)
    

    for key = table.maxn(props), 1, -1 do
        local info = self:find("SCConfig"):getItemData(props[key]["propId"])
        if tonumber(info["if_show"]) == 0 then
            table.remove(props, key)
        else
            if info == nil then
                break
            end
            props[key]["show_order"] = info["show_order"]
            configs[props[key]["propId"]] = info
        end
        
    end

    self:set("props", props)
    self:set("configs", configs)
end

function M:sortConfigs()
    local function sortFunc(val1, val2)
        return tonumber(val1["show_order"]) > tonumber(val2["show_order"])
    end

    table.sort(self:get("props"), sortFunc)
end

function M:initWithConfig()
    local items = self.scroll_bag_list:getChildren()
    local selected = self:get("selected")
    local configs = self:get("configs")
    local props = self:get("props")
    for key, val in ipairs(props) do
        items[key]:initWithData(configs[val.propId], val)
    end

    local config, data = items[selected]:getConfigData()
    self["node_info"]:setSelected(config, data)
end

function M:merge(tab1, tab2)
    for key, val in pairs(tab2) do
        table.insert(tab1, val)
    end

    return tab1
end

function M:click_btn_close()
    self:set("props", nil)
    self:set("configs", nil)
    for key, val in ipairs(self.scroll_bag_list:getChildren()) do
        val:removeFromScene()
    end
    self:removeFromScene()
end

function M:scroll_callback(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        local beginPos = sender:getTouchBeganPosition()
        local endPos = sender:getTouchEndPosition()
        local items = self.scroll_bag_list:getChildren()
        local selected = self:get("selected")
        
        if endPos.x-beginPos.x > OFFSET or endPos.x-beginPos.x < -OFFSET or endPos.y-beginPos.y > OFFSET or endPos.y-beginPos.y < -OFFSET then
            return;
        end
        for key, val in ipairs(items) do
            if val:isClicked(endPos) and not val:isSelected() and val:isNull() then
                local config, data = val:getConfigData()
                val:setSelected()
                self["node_info"]:setSelected(config, data)
                items[selected]:cancelSelected()
                self:set("selected", key)
            end
        end
    end
end

return M