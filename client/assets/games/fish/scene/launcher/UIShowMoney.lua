local M = class("UIShowMoney", wls.UIGameObject)

function M:onCreate()

end

function M:setMoneyNum(num)
    self.fnt_coin:setString(num)
end

function M:click_btn_addcoin()
    self:createGameObject("UIMailPanel")
end

return M