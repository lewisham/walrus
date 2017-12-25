----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：厦门麻将
----------------------------------------------------------------------

local SXiaMen = class("SXiaMen", GameBase)

function SXiaMen:run()
    self:autoRequire("games\\xmmj")
    self:require("BattleConst")
    self:createGameObject("DAMahjong")
    self:createGameObject("DAPlayers")
    self:coroutine(self, "play")
end

function SXiaMen:play()
    self:createGameObject("UIDesk")
    self:balckOut(0.1)
    PlayMusic("sound/bgm_battle1.mp3")
    self:createGameObject("UIDecision")
    self:createGameObject("UIMenu")
    self:find("DAMahjong"):shuffle()
    self:createGameObject("UIWallTile")
    self:find("DAPlayers"):createPlayers()
    self:deal()
    self:loop()
    self:gameEnd()
end

-- 发牌
function SXiaMen:deal()
    self:find("UIDesk"):onTurn(self:find("DAPlayers"):getDealer())
    self:createGameObject("UIDice"):play(1)
    self:find("UIWallTile"):deal()
    self:removeGameObject("UIDice")
    self:find("DAPlayers"):sortTiles()
    WaitForSeconds( 0.2)
    self:createGameObject("UIDice"):play(2)  
    self:find("UIWallTile"):displayRascal()
    WaitForSeconds(1.5)
    self:removeGameObject("UIDice")
    self:find("DAPlayers"):sortTiles()
    WaitForSeconds(0.3)
end

function SXiaMen:loop()
    local idx = self:find("DAPlayers"):get("dealer")
    local card = nil
    while true do
        if self:find("DAMahjong"):isOver() then
            break
        end
        local player = self:find("DAPlayers"):findPlayer(idx)
        self:find("UIDesk"):onTurn(player)
        card = player:play()
        while card do
            local jumper = self:find("DAPlayers"):afterDiscard(idx, card)
            if jumper == nil then break end
            cnt = jumper:decision(card)
            if cnt == 2 then
                self:find("UIDesk"):onTurn(jumper)
                player:getComponent("DropCard"):removeCurrent()
                card = jumper:doPong(card)
                idx = jumper:get("seat")
            elseif cnt >= 3 then
                self:find("UIDesk"):onTurn(jumper)
                player:getComponent("DropCard"):removeCurrent()
                card = jumper:doMingKong(card)
                idx = jumper:get("seat")
            else
                break
            end
        end
        idx = idx + 1
        if idx > 4 then
            idx = 1
        end
        WaitForSeconds(0.8)
    end
end

function SXiaMen:gameEnd()
    local list = self:find("DAPlayers"):get("player_list")
    for _, val in ipairs(list) do
        val:getComponent("PlayerCard"):showCards()
    end
    WaitForSeconds(6.0)
    local app = self:getGameApp()
	app:popScene()
    app:playGame(1001)
end

return SXiaMen