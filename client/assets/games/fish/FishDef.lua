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
    acce = 5,
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

-- 能否射击
wls.FireErrorCode =
{
    Normal = 0,
    Lock = 1,
    Not_Enough_Money = 2,
}

-- 对话框模式
wls.DialogStyle =
{
    MODE_MIN_OK_ONLY = 1,              -- 带确定按钮的小提示框
    MODE_MIDDLE_OK_ONLY = 2,           -- 带确定按钮的中提示框
    MODE_MIDDLE_OK_CLOSE = 3 ,         -- 带确定按钮和取消按钮的提示框
    MODE_MIDDLE_OK_CLOSE_HOOK = 4,     -- 带确定按钮和取消按钮，并且带有复选按钮的提示框
}

wls.ScreenRect = cc.rect(0, 0, display.width, display.height)