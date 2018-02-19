u3a.MAX_BULLET_CNT = 25
u3a.BULLET_LANCHER_INTERVAL = 0.2

u3a.PlayerFlip = false

-- 鱼的状态
u3a.FISH_STATE =
{
    normal = 1,
    start_freeze = 2,
    freeze = 3,
    end_freeze = 4, 
}

--炮塔坐标
u3a.CannonPosList = 
{
    cc.p(332.43, 0), 
    cc.p(display.width - 332.43, 0), 
    cc.p(display.width - 332.43, display.height),
    cc.p(332.43, display.height),
}
--收取道具坐标
u3a.AimPosTab = 
{
    cc.p(332.43, 40), 
    cc.p(display.width - 332.43, 40), 
    cc.p(display.width - 332.43, display.height - 40),
    cc.p(332.43, display.height - 40),
}