wls.MAX_BULLET_CNT = 25
wls.BULLET_LANCHER_INTERVAL = 0.2

wls.PlayerFlip = false

-- 鱼的状态
wls.FISH_STATE =
{
    normal = 1,
    start_freeze = 2,
    freeze = 3,
    end_freeze = 4, 
}

--炮塔坐标
wls.CannonPosList = 
{
    cc.p(332.43, 0), 
    cc.p(display.width - 332.43, 0), 
    cc.p(display.width - 332.43, display.height),
    cc.p(332.43, display.height),
}
--收取道具坐标
wls.AimPosTab = 
{
    cc.p(332.43, 40), 
    cc.p(display.width - 332.43, 40), 
    cc.p(display.width - 332.43, display.height - 40),
    cc.p(332.43, display.height - 40),
}