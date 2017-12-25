----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：全局方法
----------------------------------------------------------------------

function FindScene(sceneName)
    if GameAppInstance == nil then return nil end
    return GameAppInstance:findScene(sceneName)
end

function FindObject(sceneName, objectName)
    local scene = FindScene(sceneName)
    if scene == nil then return nil end
    return scene:find(objectName)
end