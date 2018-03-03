local CRYSTAL = 2
local M = class("UIPackbackItemInfo", wls.UIGameObject)

function M:onCreate()
    self.btn_buy:setVisible(false)
    self.btn_sell:setVisible(false)
    self.btn_send:setVisible(false)
    self.btn_resolve:setVisible(false)
    self.btn_exchange:setVisible(false)
    self.btn_taste:setVisible(false)
    self.node_timelimit:setVisible(false)
    self.node_type_2:setVisible(false)
    self.node_type_3:setVisible(false)
end

function M:setSelected(config, data)
    local name = config["name"]
    local decomposeNum = tonumber(config["num_decompose"])
    local sendNum = tonumber(config["num_send"])
    local requireSendLv = tonumber(config["sendreq_vip"])
    local sellValTab = string.split(config["sell_value"],",")
    local tasteTime = tonumber(config["taste_time"])
    local packText = config["pack_text"]
    local isDecomposable = (tonumber(config["decomposable"]) == 1 and true or false)
    local isAllowSend = ((tonumber(config["allow_send"]) == 1 and data["propCount"] > 0) and true or false)
    local isAllowExchange = ((tonumber(config["allow_exchange"]) == 1 and data["propCount"] > 0) and true or false)
    local isCanBuy = (tonumber(config["can_buy"]) == 1 and true or false)
    local isCanSell = ((tonumber(sellValTab[2]) ~= 0 and data["propCount"] > 0) and true or false)
    local isTaste = (tonumber(config["if_taste"]) == 1 and true or false)
    local isSenior = (tonumber(config["if_senior"]) == 1 and true or false)

    self.node_type_1:setVisible(true)
    self.node_type_2:setVisible(false)
    self.node_type_3:setVisible(false)
    
    self.text_title:setString(name)
    self.text_describe:setString(packText)

    self.btn_buy:setVisible(isCanBuy)
    self.btn_sell:setVisible(isCanSell)
    self.btn_resolve:setVisible(isDecomposable)
    self.btn_exchange:setVisible(isAllowExchange)
    self.btn_taste:setVisible(isTaste)

    self:createIcon(config, data)

    self:set("config", config)
    self:set("data", data)
end

function M:createIcon(config, data)
    local oldIcon = self:get("icon")
    if oldIcon then oldIcon:removeFromScene() end

    local icon = self:createGameObject("UIPackbackItem")
    icon:initWithData(config, data)
    wls.ChangeParentNode(icon, self.node_curitem)
    self:set("icon", icon)
end

function M:showBuyPanel()
    local config = self:get("config")
    local buyPriceTab = string.split(config["price"], ",")
    local unitNum = tonumber(config["num_perbuy"])
    local totalPrice = unitNum*tonumber(buyPriceTab[2])
    local unitName = self:find("SCConfig"):getItemData(tonumber(buyPriceTab[1]))["name"]
    
    self.node_type_2:setVisible(true)
    self.text_buy_count:setString(unitNum)
    self.text_buy_notice:setString("请选择购买物品数量code")
    self.text_buy_allprice:setString("总价:"..totalPrice..unitName.."code")
    self.text_buy_price_count:setString("购买单价/数量:"..buyPriceTab[2]..unitName.."/"..unitNum.."code")
end

function M:showSellPanel()
    local config = self:get("config")
    local data = self:get("data")
    local sellValTab = string.split(config["sell_value"],",")
    local unitNum = 1
    local curCount = data["propCount"]
    local totalPrice = tonumber(sellValTab[2])*unitNum
    local unitName = self:find("SCConfig"):getItemData(tonumber(sellValTab[1]))["name"]

    
    self.node_type_3:setVisible(true)
    self.text_cangetcoin:setString(totalPrice..unitName)
    self.text_curnum:setString(unitNum)
    self.text_allnum:setString("/"..curCount)
end

function M:click_btn_buy()
    self.node_type_1:setVisible(false)
    self:showBuyPanel()
end

function M:click_btn_sell()
    self.node_type_1:setVisible(false)
    self:showSellPanel()
end

--赠送
function M:click_btn_send()
end

--分解
function M:click_btn_resolve()
end

--兑换
function M:click_btn_exchange()
end

--体验
function M:click_btn_taste()
end

--确认购买
function M:click_btn_surebuy()
    self.node_type_1:setVisible(true)
    self.node_type_2:setVisible(false)
end

--购买数量减按钮
function M:click_btn_buy_minus()
    local config = self:get("config")
    local unitNum = tonumber(config["num_perbuy"])
    local showNum = tonumber(self.text_buy_count:getString())
    local buyPriceTab = string.split(config["price"], ",")
    local totalPrice = (showNum+unitNum)*tonumber(buyPriceTab[2])
    local unitName = self:find("SCConfig"):getItemData(tonumber(buyPriceTab[1]))["name"]

    if showNum-unitNum <= 0 then
        return
    end

    self.text_buy_count:setString(showNum-unitNum)
    self.text_buy_allprice:setString("总价:"..totalPrice..unitName.."code")
end

--购买数量加按钮
function M:click_btn_buy_add()
    local config = self:get("config")
    local buyPriceTab = string.split(config["price"], ",")
    local money = (tonumber(buyPriceTab[1]) == CRYSTAL and self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]["crystal"] or self:find("SCRoomMgr"):get("HallInfo")["playerInfo"]["fishIcon"] )
    local unitNum = tonumber(config["num_perbuy"])
    local showNum = tonumber(self.text_buy_count:getString())
    local totalPrice = (showNum+unitNum)*tonumber(buyPriceTab[2])
    local unitName = self:find("SCConfig"):getItemData(tonumber(buyPriceTab[1]))["name"]

    if totalPrice > money then
        return;
    end

    self.text_buy_count:setString(showNum+unitNum)
    self.text_buy_allprice:setString("总价:"..totalPrice..unitName.."code")

end

--确认出售数量减按钮
function M:click_btn_minus()
    local config = self:get("config")
    local sellValTab = string.split(config["sell_value"],",")
    local unitNum = 1
    local showNum = tonumber(self.text_curnum:getString())
    local totalPrice = (showNum-unitNum)*tonumber(sellValTab[2])
    local unitName = self:find("SCConfig"):getItemData(tonumber(sellValTab[1]))["name"]
    if showNum-unitNum <= 0 then
        return
    end

    self.text_curnum:setString(showNum-unitNum)
    self.text_cangetcoin:setString(totalPrice..unitName)

end

--确认出售数量加按钮
function M:click_btn_add()
    local data = self:get("data")
    local config = self:get("config")
    local sellValTab = string.split(config["sell_value"],",")
    local unitNum = 1
    local showNum = tonumber(self.text_curnum:getString())
    local totalPrice = (showNum+unitNum)*tonumber(sellValTab[2])
    local unitName = self:find("SCConfig"):getItemData(tonumber(sellValTab[1]))["name"]
    local curCount = data["propCount"]

    if showNum+unitNum > curCount then
        return;
    end

    self.text_curnum:setString(showNum+unitNum)
    self.text_cangetcoin:setString(totalPrice..unitName)

end

--确认出售数量最大按钮
function M:click_btn_max()
    local data = self:get("data")
    local config = self:get("config")
    local sellValTab = string.split(config["sell_value"],",")
    local curCount = data["propCount"]
    local totalPrice = curCount*tonumber(sellValTab[2])
    local unitName = self:find("SCConfig"):getItemData(tonumber(sellValTab[1]))["name"]

    self.text_curnum:setString(curCount)
    self.text_cangetcoin:setString(totalPrice..unitName)
end

--确认出售
function M:click_btn_suresell()
    self.node_type_1:setVisible(true)
    self.node_type_3:setVisible(false)
end

return M