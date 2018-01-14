----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：系统场景全局方法
----------------------------------------------------------------------

-- 显示提示信息
function Toast(str)
    local scene = FindScene("SSystem")
    if scene == nil then return end
    scene:find("UIToast"):show(str)
    return true
end

-- 显示对话框
function Dialog(title, content, yesFunc, noFunc)
    local scene = FindScene("SSystem")
    if scene == nil then return end
    scene:createGameObject("UIDialog"):show(title, content, yesFunc, noFunc)
    return true
end

-- 等待对话框
function WaitForDialog(title, content)
    local co = GetRunningCO()
    if co == nil then return end
    local bRet = false
    local function yesFunc() 
        bRet = true 
        co:resume("WaitForDialog")
    end
    local function noFunc() 
        bRet = false
        co:resume("WaitForDialog") 
    end
    Dialog(title, content, yesFunc, noFunc)
    co:pause("WaitForDialog")
    WaitForFrames(1)
    return bRet
end


function ShowBroadcast(str, priority)
    local obj = FindObject("SSystem", "UIBroadcast")
    if obj == nil then return end
    obj:play(str, priority)
end