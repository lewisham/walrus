local tp = cc.Application:getInstance():getTargetPlatform()
-- 平台自定义
if tp == 0 then 
    require("src.platform.win32.win32")
    require("src.platform.CustomScript")
end