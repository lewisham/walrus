print("开始调试代码")

local scene = AppBase:getInstance():findScene("SBattle")
print("战斗场景1", scene)
if scene then
    scene:find("UIDesk").scroll_view:setTouchEnabled(true)
end