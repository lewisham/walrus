local MATERIAL_ID = 7
local M = class("UIForgedPanel", wls.UIGameObject)

function M:onCreate()
    self:loadCenterNode(self:fullPath("hall/forged_panel.csb"), true)
    --fnt_cur_multiple fnt_next_multiple fnt_success_rate text_success_num text_fail_num text_cur_num text_max_num

    self:updatePanel()
end

--初始化锻造面板
function M:initForgedInfo(curGunRateInfo, nextGunRateInfo, failNum, materialNum)
    local red = cc.c3b(255, 0, 0)
    local green = cc.c3b(0, 255, 0)
    local needMaterialNum = (nextGunRateInfo["unlock_item"] == nil and 0 or tonumber(nextGunRateInfo["unlock_item"][2]))
    self.fnt_cur_multiple:setString(curGunRateInfo["times"])
    self.fnt_next_multiple:setString(nextGunRateInfo["times"])
    self.fnt_success_rate:setString((nextGunRateInfo["unlock_prob"]/100).."%")
    self.text_success_num:setString(nextGunRateInfo["succ_need"])
    self.text_fail_num:setString(failNum)
    self.text_cur_num:setString(materialNum)
    self.text_cur_num:setColor(materialNum>=needMaterialNum and green or red)
    self.text_max_num:setString("/"..needMaterialNum)

    self:set("curMaterialNum", materialNum)
    self:set("needMaterialNum", needMaterialNum)
end

function M:updatePanel()
    local maxGunRate = self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]["maxGunRate"]
    local failNum = self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]["forgeCount"]
    local curGunRateInfo, nextGunRateInfo = self:getGunRateInfo(maxGunRate)
    local materialNum = self:getCurMaterialNum(nextGunRateInfo["unlock_item"] == nil and MATERIAL_ID or tonumber(nextGunRateInfo["unlock_item"][1]))
    self:initForgedInfo(curGunRateInfo, nextGunRateInfo, failNum, materialNum)
    self:set("nextGunRate", maxGunRate)
    self:set("failNum", failNum)
end

function M:getGunRateInfo(gunRate)
    local gunRateInfos = self:find("SCConfig"):get("cannon")
    for key, val in ipairs(gunRateInfos) do
        if val["times"] == gunRate then
            return val, (gunRateInfos[key+1] == nil and val or gunRateInfos[key+1])
        end
    end
end

--获取材料道具数量
function M:getCurMaterialNum(propId)
    local props = self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]["props"]

    for key, val in ipairs(props) do
        if val["propId"] == propId then
            return val["propCount"]
        end
    end

    return 0
end

--设置锻造材料道具数量
function M:setMaterialNum(num)
    for key, val in ipairs(self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]["props"]) do
        if val["propId"] == MATERIAL_ID then
            val["propCount"] = num
        end
    end
end

function M:isAutoFroged()
    return self.spr_hook:isVisible()
end

function M:click_btn_close()
    self:removeFromScene()
end

function M:click_btn_auto_forged()
    self.spr_hook:setVisible(not self.spr_hook:isVisible())
end

function M:click_btn_forged()
    self:find("SCRoomMgr"):sendForge()
end

function M:onForgedResult(data)
    if data.success then
        self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]["maxGunRate"] = self:get("nextGunRate")
        self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]["forgedFail"] = 0
    else
        self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]["forgedFail"] = self:get("failNum")
    end
    self:setMaterialNum(lessMaterialNum)
    self:updatePanel()

    --是否需要自动锻造
    if data.success == false and self:isAutoForged() and self:get("curMaterialNum") >= self:get("needMaterialNum") then
        self:click_btn_forged()
    end
end

return M