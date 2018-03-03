----------------------------------------------------------------------
-- 作者：lps
-- 日期：2018-3-2
-- 描述：道具效果
----------------------------------------------------------------------

local M = class("UIPropMgr", wls.UIGameObject)

function M:onCreate()

end

--创建道具节点
function M:createProp(propId,propCount,isShowCount)
    local node = cc.Node:create()
    local light = self:getLight()
    node:addChild(light,1)
    local propSprite = self:getPropSpr(propId)
    if propSprite == nil then return end
    node:addChild(propSprite,2)
    if propCount > 1 and isShowCount then
        local countFnt = self:getCount(propId,propCount)
        node:addChild(countFnt,3)
    end
    self:addChild(node)
    return node
end

-- 创建道具图片
function M:getPropSpr(propId)
    local itemData = self:find("SCConfig"):getItemData(propId)
    if itemData == nil then return nil end
    local propname = "ui/images/common/prop/"..itemData.res
    local propSprite = cc.Sprite:create(self:fullPath(propname))
    return propSprite
end

-- 创建道具图片
function M:getLight()
    local light = cc.Sprite:create(self:fullPath("ui/images/common/com_pic_light.png"))
    light:setScale(1.4)
    light:setOpacity(255*0.5)
    light:runAction(cc.RepeatForever:create(cc.RotateBy:create(1,60)))
    return light
end

-- 创建道具图片
function M:getCount(propId,propCount)
    local countFnt = ccui.TextBMFont:create()
    countFnt:setFntFile(self:fullPath("fnt/lottery_gift_num.fnt"))
    countFnt:setString(propCount)
    if tonumber(propId) == 12 then
        countFnt:setString((propCount/100).."y")
    end
    countFnt:setAnchorPoint(cc.p(0.5,0))
    countFnt:setPosition(cc.p(0,-40))
    return countFnt
end

function M:playHitDropProp(playerId, dropProps,dropGem, firstPos)
    if dropProps == nil then dropProps = {} end
    if dropGem == nil then dropGem = 0 end
    if #dropProps <= 0 and dropGem <= 0 then return end
    local player = self:find("SCGameClient"):getPlayer(playerId)
    if player == nil then return end
    local endPos = wls.AimPosTab[player.view_id] or cc.p(0, 0)
    local dis = 150
    local leftPosX = firstPos.x - ((#dropProps-1)*dis)/2
    local delayTime = 0.8
    for k,v in ipairs(dropProps) do
        self:play(playerId, v.propId, v.propCount, cc.p(leftPosX + dis*(k -1),firstPos.y) ,endPos,true, true, true,delayTime)
    end
    if dropGem > 0 then
        for i=1,dropGem do
            local pos,indexd,maxScale = self:getDropPos(2,firstPos,i,dropGem)
            local isRefreshData = false
            if i == 1 then
                isRefreshData = true
            end
            self:play(playerId,2, dropGem, pos ,endPos,false, true, isRefreshData,(delayTime + indexd*0.1),maxScale)
        end
    end
end

--得到掉落位置
function M:getDropPos(propId,dropPos,count,allCount)
    local pos = {}
    local index = 1
    local maxScale = 1.2
    if propId == 2 then
        local disX = 75
        local disY = 75
        if allCount == 1  then
            pos = dropPos
        elseif allCount == 10  then
            maxScale = 0.8
            if count  < 4 then
                pos.x = (count - 2)*disX + dropPos.x
                pos.y = disY + dropPos.y
                index = count
            elseif count  < 8 then
                pos.x = (count - 3 - 2.5)*disX + dropPos.x
                pos.y = dropPos.y
                index = count- 3
            elseif count  < 11 then
                pos.x = (count - 7 - 2)*disX + dropPos.x
                pos.y = - disY + dropPos.y
                index = count- 7
            end
        else
            pos = cc.p((dropPos.x - (allCount - 1)*150/2 +(count - 1) *150),dropPos.y)
            index = count
        end
    end
    return pos,index,maxScale
end

function M:play(playerId, propId, propCount, firstPos, endPos, isShowCount, isJump, isRefreshData,delayTime,maxScale)
    if endPos == nil then endPos = cc.p(0, 0) end
    if isShowCount == nil then isShowCount = true end
    if isJump == nil then isJump = true end
    if isRefreshData == nil then isRefreshData = true end
    if delayTime == nil then delayTime = 0 end
    if maxScale == nil then maxScale = 1.2 end
    local node = self:createProp(propId,propCount,isShowCount)
    if node == nil then return end
    node:setPosition(firstPos)
    node:setVisible(false)
    self:coroutine(self, "playImpl",node,firstPos,endPos,isJump,isRefreshData,playerId,propId,propCount,delayTime,maxScale)
end

function M:playImpl(node,firstPos,endPos,isJump,isRefreshData,playerId,propId, propCount,delayTime,maxScale)
    wls.WaitForSeconds(delayTime)
    node:setVisible(true)
    if isJump then
        self:jumpAct(node,maxScale)
    end
    wls.WaitForSeconds(0.4)
    node:setScale(maxScale)
    self:flyAct(node,endPos)
    self:find("SCSound"):playSound("getprop_01")
    if isRefreshData then
        self:updatePropCount(playerId,propId, propCount)
    end
end

function M:jumpAct(node,maxScale)
    node:setScale(0.3)
    node:setVisible(true)
    local seq1 = cc.Sequence:create
    {
        cc.MoveBy:create(0.21, cc.p(0, 88)),
        cc.MoveBy:create(0.20, cc.p(0, -103)),
        cc.MoveBy:create(0.13, cc.p(0, 27)),
    }
    node:runAction(cc.Spawn:create(cc.ScaleTo:create(0.54,maxScale), seq1))
    wls.WaitForSeconds(0.54)
end

function M:flyAct(node,endPos)
    local timeMove = 0.75
    local tb =
    {
        cc.Spawn:create(cc.ScaleTo:create(timeMove, 0.7), cc.EaseExponentialIn:create(cc.MoveTo:create(timeMove, endPos))),
        cc.DelayTime:create(0.05),
        cc.RemoveSelf:create(),
    }
    node:runAction(cc.Sequence:create(tb))
    wls.WaitForSeconds(timeMove)
end

function M:updatePropCount(playerId,propId, addCount)
    local player = self:find("SCGameClient"):getPlayer(playerId)
    if player == nil then return end

    if propId == 2 then
        self:find("UICannon" .. player.view_id):opGem(addCount)
    else

    end

    if player.is_self then
        self:playGunTip(player.view_id,propId, addCount)
    end
end

function M:playGunTip(view_id, propId, addCount)
    local cannon = self:find("UICannon" .. view_id)
    local pos = cc.p(cannon:getPositionX(),cannon:getPositionY() + 180)
    local node = self:cteateGunTip(propId, addCount)
    node:setPosition(pos)
    if self.tipsCount == nil then self.tipsCount = 0 end
    self.tipsCount = self.tipsCount +1
    local spawnAct = cc.Spawn:create(cc.MoveBy:create(1,cc.p(0,80)),cc.FadeTo:create(1,0))
    local tb = {
        cc.DelayTime:create((self.tipsCount - 1)*0.5),
        cc.Show:create(),
        spawnAct,
        cc.CallFunc:create(function ()
            node:removeFromParent()
            self.tipsCount = self.tipsCount - 1
        end)
    }
    local seq = cc.Sequence:create(tb)
    node:runAction(seq)

end

function M:cteateGunTip(propId, addCount)
    local node = cc.Node:create()
    self:addChild(node)

    local tipBg = cc.Scale9Sprite:create(self:fullPath("ui/images/common/layerbg/com_tips_bg.png"));
    tipBg:setScale9Enabled(true);
    tipBg:setCapInsets({x = 20, y = 18, width = 1, height = 1})
    node:addChild(tipBg)
    local word = self:find("SCConfig"):getLanguageByID(800000374).." "
    local tipword = cc.LabelTTF:create(word, "Arial", 20);
    tipword:setColor(cc.c3b(255, 255,255));
    node:addChild(tipword)
    local tipDate = cc.LabelTTF:create("", "Arial", 20);
    tipDate:setColor(cc.c3b(255, 230,114));
    node:addChild(tipDate)

    tipDate:setString(self:getPropName(propId, addCount))

    --更新位置
    local sizeTipDate = tipDate:getContentSize()
    local sizeTipWord = tipword:getContentSize()
    local allSize = sizeTipDate.width + sizeTipWord.width
    tipword:setPositionX(sizeTipWord.width/2 -allSize/2)
    tipDate:setPositionX(allSize/2 - sizeTipDate.width/2)
    tipBg:setContentSize(cc.size(allSize+30,sizeTipDate.height+10))
    node:setOpacity(255)
    node:setVisible(false)
    return node
end

function M:getPropName(propId, addCount)
    local itemData = self:find("SCConfig"):getItemData(propId)
    if itemData == nil then return addCount end
    local cellStr = addCount
    if propId == 12 then
        cellStr = (addCount/100)..self:find("SCConfig"):getLanguageByID(800000210)
    end
    return itemData.name.."* "..cellStr
end

return M