----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2017-12-24
-- 描述：图鉴
----------------------------------------------------------------------

local M = class("UIFishHandBook", wls.UIGameObject)

local TypeMapFile = {
    [1] = "ui/images/form/form_box_1.png",
    [2] = "ui/images/form/form_box_1.png",
    [3] = "ui/images/form/form_box_2.png",
    [4] = "ui/images/form/form_box_1.png",
    [5] = "ui/images/form/form_box_3.png",
    [6] = "ui/images/form/form_box_1.png",
}

function M:onCreate()
    self:createMask()
    self:loadCenterNode(self:fullPath("ui/fishform/uifishform.csb"), true)
    self.scrollSize = self.scroll_fish_list:getContentSize()
    self.normal_v_count = 8
    self.special_v_count = 4
    -- 计算出每个格子的宽高
    self.cellW1 = self.scrollSize.width / self.normal_v_count
    self.cellW2 = self.scrollSize.width / self.special_v_count
    self.cellH = 100
    self:initFishForm()
end

function M:initFishForm()
    local RoomFishArr = self:find("SCConfig"):get("hand_book")
    local count = #RoomFishArr

    self.fishList = {}
    self.specialFishList = {}
    
    for i=1,count do
        local RoomFish = RoomFishArr[i]
        if RoomFish == nil or RoomFish == "" then
            break
        end
        local item = self:createFishItem(RoomFish)
        self.scroll_fish_list:addChild(item)
        if RoomFish.fish_type ~= 6 then
            table.insert( self.fishList, item)
        else
            table.insert( self.specialFishList, item)
        end
    end
    self:updataScrollView(self.scroll_fish_list, self.fishList, self.specialFishList)
end

function M:updataScrollView(listView, fishList, specialFishList)
    local count1 = #fishList
    local h_count1 = math.floor((count1-1) /self.normal_v_count)+1

    local count2 = #specialFishList
    local h_count2 = math.floor((count2-1) /self.special_v_count)+1

    local all_h_size = (h_count1 + h_count2)*self.cellH
    listView:setInnerContainerSize(cc.size(self.scrollSize.width, all_h_size))

    for i=1,count1 do
        local fishItem = fishList[i]
        local posX = self.cellW1/2 + math.mod(i-1,self.normal_v_count) * self.cellW1
        local posY = all_h_size - self.cellH/2 - math.floor((i-1)/self.normal_v_count) *self.cellH
        fishItem:setPosition(cc.p(posX, posY))
    end

    for i=1,count2 do
        local fishItem = specialFishList[i]
        local posX = self.cellW2/2 + math.mod(i-1,self.special_v_count) * self.cellW2
        local posY = all_h_size - h_count1*self.cellH -self.cellH/2 - math.floor((i-1)/self.special_v_count) *self.cellH
        fishItem:setPosition(cc.p(posX, posY))
    end
end

function M:createFishItem(valtab)
    local fishID = valtab.fish_id - 100000000
    local show_score = valtab.show_score
    local fish_type = valtab.fish_type

    local item = wls.LoadCsb(self:fullPath("ui/fishform/uiformitem.csb"))
    wls.BindToUI(item, item)
    -- 图片
    item.spr_fish:setSpriteFrame(self:fullPath("ui/images/form/fishid_"..fishID..".png"))
    -- 倍率
    item.fnt_rate:setString(show_score)
    item.fnt_rate:setVisible(tonumber(show_score) > 0)
    -- 背景框
    local filename = self:fullPath(TypeMapFile[fish_type])
    item.image_formbg:loadTexture(filename, 1)
    if fish_type == 6 then
        local size = item.image_formbg:getContentSize()
        item.image_formbg:setContentSize(cc.size(size.width + 134,size.height))
        item.fnt_rate:setVisible(false)
    end

    item["fish_type"] = fish_type
    return item
end

function M:click_btn_close()
    wls.SafeRemoveNode(self)
end

return M