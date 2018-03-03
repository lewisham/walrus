----------------------------------------------------------------------
-- 作者：Lihq
-- 日期：2018-3-1
-- 描述：新手任务信息界面
----------------------------------------------------------------------

local M = class("UINewBieTask", wls.UIGameObject)

function M:onCreate()
    self:loadCsb(self:fullPath("ui/newbietask/uinewbietask.csb"), true)
   
    self:initData()

    local actions = {
        cc.DelayTime:create(1),
        cc.CallFunc:create(function ()
            self:sendGetNewTaskInfo()
        end)
    }
    self:runAction(cc.Sequence:create(actions))
end

--初始化数据
function M:initData()
    local winSize = cc.Director:getInstance():getWinSize();
    local panelSize = self.img_bg:getContentSize()
    self.exitPosY = winSize.height + panelSize.height/2 
    self.enterPosY = winSize.height - panelSize.height/2 
    self.panelPosX = winSize.width/2
    self:setPosition(cc.p(self.panelPosX, self.exitPosY))

    self.mTaskData = self:require("newtask")
end

--panel退出移动动画
function M:exitAni(callback)
    self:stopAllActions()
    local actions = {
        cc.MoveTo:create(0.5, cc.p(self.panelPosX, self.exitPosY)),
        cc.CallFunc:create(callback)
    }
    self:runAction(cc.Sequence:create(actions))
end

--panel进入移动动画
function M:enterAni()
    self:stopAllActions()
    self:runAction(cc.MoveTo:create(0.5, cc.p(self.panelPosX, self.enterPosY)))
end

--获取新手任务后更新界面
function M:updateAfterGetNewTaskInfo(resp)
    if resp.nTaskID ~= -1 or resp.nTaskData ~= -1 then
        if self.showEnterAni then  
            self:enterAni()
            self.showEnterAni = false
        end
        self:setVisible(true)
        self:initTaskPanelUI(resp.nTaskID, resp.nTaskData)
    else
        self:setVisible(false)
    end
end

--更新任务界面信息  taskID任務id；taskData 任務完成數量
function M:initTaskPanelUI(taskID, taskData)
	self.iCurTaskID = taskID + 450000000      --任務id
    self.curTaskData = self.mTaskData[tostring(self.iCurTaskID)]
    if nil == self.curTaskData then return end
    --任务奖励
    local tRewardData = string.split(self.curTaskData.reward, ',')
    self:refreshTaskReward(tRewardData[1], tRewardData[2], self.curTaskData.task_text)
    --任务是否可领
    local isFinished = taskData >= tonumber(self.curTaskData.task_data)
    self:refreshTaskFinishState(isFinished)
    self.bTaskExecuting = not isFinished
    --任务进度与可领奖励动画
    if isFinished then
       --self.resourceNode_["animation"]:play("animation0", true)
    else
        self:refreshTaskProcessUI(taskData, self.curTaskData.task_data)
    end   
end

--根据任务有沒有完成，更新界面
function M:refreshTaskFinishState(isFinished)
    self.img_desc_bg:setVisible(not isFinished)
    self.text_desc:setVisible(not isFinished)
    self.img_process_bg:setVisible(not isFinished)
    self.spr_draw_effect:setVisible(isFinished)
    self.btn_draw:setVisible(isFinished)
    self.btn_draw:setTouchEnabled(isFinished)
end

--更新進度條  --curPro：任务完成数量 --totalPro：任务总数量
function M:refreshTaskProcessUI(curPro, totalPro)
    self.loading_bar_process:setPercent(curPro/totalPro*100)
    self.process_percentage:setString(tostring(curPro) .. "&" .. tostring(totalPro))
end

--更新奖励道具信息   propId：任务奖励道具id ； propCount：任务奖励道具数量； testDes：任务描述
function M:refreshTaskReward(propId, propCount, testDes)
    --话费券
    if propId == 12 then propCount = (propCount/100)..y  end
    self.fnt_prop_num:setString(propCount)
    self.text_desc:setString(testDes)
    --奖励图片
    if propId == "1002" or propId == "1003" then
        self.spr_prop:setScale(0.8)
    else
        self.spr_prop:setScale(1)
    end
    local resName = self:require("item")[tostring( 200000000 + propId)].res
    self.spr_prop:initWithFile(self:fullPath("ui/images/common/prop/"..resName))  
end

--领取奖励后更新界面
function M:updateAfterGetReward(resp)
    self:exitAni(function ()
        self:sendGetNewTaskInfo()
    end)
end

--请求领取新的任務
function M:sendGetNewTaskInfo()
    self.showEnterAni = true
    wls.SendMsg("sendGetNewTaskInfo")
end

--点击领取奖励
function M:click_btn_draw( sender )
    wls.SendMsg("sendGetNewTaskReward", self.iCurTaskID)
end

return M