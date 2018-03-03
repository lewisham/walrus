----------------------------------------------------------------------
-- 作者：Lihq
-- 日期：2018-2-26
-- 描述：玩家魔法道具动画界面
----------------------------------------------------------------------

local M = class("UIMagicPropAni", wls.UIGameObject)

local  MagicType = 
{
    ["hammer"] = 1,
    ["egg"] = 2,
    ["cake"] = 3,
    ["gun"] = 4,
    ["pulldown"] = 5,
}

function M:onCreate()
    self.BASE_PATH = "ui/images/magicprop/magicproppic/"
    self.magicData = self:find("UIPlayerInfo"):getMgicData() 
end

--根據玩家id，播放道具效果
function M:playPropAni(toPlayerId, propId, fromPlayerId)
    local toViewId = self:getViewIdByPlayerId(toPlayerId)
    local fromViewId = self:getViewIdByPlayerId(fromPlayerId)
    self:showPropAni(toViewId, propId, fromViewId)
end

-- 播放道具动画 viewID 被丟道具的玩家視圖id；fromID丟道具的玩家視圖ID；propId道具類型
function M:showPropAni(viewID, propId, fromID)
    self:find("UIPlayerInfo"):setShowingFlag(true)  
    local magicData = self.magicData 
    local revert = false
    local rotation = nil
    if propId == MagicType.gun then
        revert = not self:isPosRight(fromID)
    elseif propId == MagicType.hammer then
        revert = self:isPosRight(fromID)
    elseif propId == MagicType.egg then
        rotation = {360, 0.5}
    end
    local angle = self:getAngle(fromID, viewID)	
    local headName = magicData[propId].magicprop_res 
    if propId == MagicType.gun then
        self:showGunAni(viewID, propId, fromID, revert, angle, headName)
        return 
    end
    self:showOtherPropAni(viewID, propId, fromID, headName, revert, rotation)
end

-- 播放gun动画
function M:showGunAni(viewID, propId, fromID, revert, angle, headName)
    local shooter 		= cc.Sprite:create()
	local shootlayer 	= cc.Sprite:create()
    local target  		= cc.Sprite:create()
    local frameRate = 0.05 
    --枪在一个节点，子弹在另外一个节点
    local fireAction = self:createAction(headName, 0, 3, frameRate)
    local bulletAction = self:createAction(headName, 3, 10, frameRate)
    self:find("SCSound"):playSound("magicprop04")
    if revert then 
		shooter:setRotationSkewY(-180)
		shootlayer:setRotation(-angle)
    else
		shootlayer:setRotation(180 - angle)
    end
        local function shootFuncEnd()
            shooter:removeFromParent()
        end

        local function bulletFuncEnd()
            target:removeFromParent() 
            self:find("UIPlayerInfo"):setShowingFlag(false)
        end

    self:animateDecor(shooter, fromID, viewID, function () end, fireAction, 0, shootFuncEnd, 10, propId)  
    
    self:animateDecor(target, fromID, viewID, function () end, bulletAction, 1.5, bulletFuncEnd, 10, propId)                   
    
    shootlayer:addChild(shooter)

    local offY = 100
    if viewID > 2 then offY = -offY end
    --设置子弹位置
    local toCannon = self:find("UICannon" .. viewID)
    local  x, y  = toCannon:getPosition()
    target:setPosition(cc.p(x, y + offY))
    self:addChild(target, 10000)
    self:addChild(shootlayer, 10000)
    --设置枪身layer位置
    local fromCannon = self:find("UICannon" .. fromID)
    local  x, y = fromCannon:getPosition()
    if fromID < 3 and viewID > 2 then
        offY = -offY
    elseif fromID > 2 and viewID < 3 then
        offY = -offY
    end
    shootlayer:setPosition(cc.p(x, y + offY))
end

 -- 播放除枪以外的其它动画
 function M:showOtherPropAni(viewID, propId, fromID, headName, revert, rotation)
    local sprite_bgr = cc.Sprite:create()  
    local firstSpritePath = self.BASE_PATH .. headName .. "_0.png"
	local sprite = cc.Sprite:createWithSpriteFrameName(self:fullPath(firstSpritePath)) 
    local action = self:getActionByPropType(propId, headName) 
    local delayTime = 1.5
    local repeatTimes = 1
        local function funAfterMove()
            sprite:removeFromParent()  
            self:find("SCSound"):playSound("magicprop0" ..propId)
        end

        local function funcEnd()
            sprite_bgr:removeFromParent() 
            self:find("UIPlayerInfo"):setShowingFlag(false)
        end

    self:animateDecor(sprite_bgr, fromID, viewID, funAfterMove, action, delayTime, funcEnd, repeatTimes, propId)
    
    if revert then sprite_bgr:setRotationSkewY(180) end
    
    if rotation then sprite:runAction(cc.RotateBy:create(rotation[2], rotation[1])) end
	sprite_bgr:addChild(sprite)
    self:addChild(sprite_bgr, 100000000)
end

 --根据道具类型，获取帧动画 propId道具類型id，headName
 function M:getActionByPropType(propId, headName)
    local farameArray = { 0, 7, 0, 0, 12}   --每種道具，總共的幀數
    local action   
    if propId == MagicType.cake then
        local aniFrame = { {start = 1,farames = 7}, {start = 8,farames = 3} }
        local actions = 
        {
            self:createAction(headName, aniFrame[1].start, aniFrame[1].farames),
            cc.Repeat:create(self:createAction(headName, aniFrame[2].start, aniFrame[2].farames), 7)
        }
        action = cc.Sequence:create(actions)
    elseif propId == MagicType.hammer then
        local aniFrame = {  --帧动画  起始帧数start ； farames总共帧数
            {start = 1,farames = 2}, {start = 3,farames = 5},
            {start = 8,farames = 2}, {start = 9,farames = 4},
            {start = 13,farames = 1}
        }
        local  actions = 
        {
            self:createAction(headName, aniFrame[1].start, aniFrame[1].farames),
            cc.Repeat:create(self:createAction(headName, aniFrame[2].start, aniFrame[2].farames), 3),
            self:createAction(headName, aniFrame[3].start, aniFrame[3].farames),
            cc.Repeat:create(self:createAction(headName, aniFrame[4].start, aniFrame[4].farames), 3),
            self:createAction(headName, aniFrame[5].start, aniFrame[5].farames)
        }
        action = cc.Sequence:create(actions)
    elseif propId == MagicType.pulldown or propId == MagicType.egg then
        action = self:createAction(headName, 1, farameArray[propId])
    end
    return action
 end

--主要的动画--funAfterMove:移动完，移除动画；action：移动完后的帧动画；funcEnd：帧动画播完后，消除
function M:animateDecor(spr, from, to, funAfterMove, action, delayTime, funcEnd, repeatTimes, propId)
    local posChangeArr = {}
    local repeatTimes = repeatTimes or 1
    local offY = 100
    if to > 2 then offY = -offY end
    local move = {}
    if propId ~= MagicType.gun then
        local toCannon = self:find("UICannon" .. to)
        local  x, y  = toCannon:getPosition()
        table.insert(move, cc.MoveTo:create(0.5,cc.p(x,y + offY)))
        table.insert(move, cc.CallFunc:create(funAfterMove))
    end
    table.insert(move, cc.Repeat:create(action, repeatTimes))
    if delayTime then  table.insert(move, cc.DelayTime:create(delayTime))  end
    table.insert(move, cc.CallFunc:create(funcEnd))

    local sequence = cc.Sequence:create(move)
    --枪身动画不设置位置，子弹要设置
    if propId ~= MagicType.gun and delayTime > 0 then  
        local fromCannon = self:find("UICannon" .. from)
        local  x, y  = fromCannon:getPosition()
        if from < 3 and to > 2 then
            offY = -offY
        elseif from > 2 and to < 3 then
            offY = -offY
        end
        spr:setPosition(cc.p(x, y + offY))
    end
    spr:runAction(sequence)  
end

--序列帧动画 headName:资源前缀；istart开始帧数；iFrmes播放总共的帧数；
function M:createAction(headName, istart, iFrmes, frameRate)
    local frameRate = frameRate or 0.1
    local animation = cc.Animation:create()
    for i = istart, istart + iFrmes - 1 do
        local pathName = self.BASE_PATH..headName.."_" .. i ..".png"
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(self:fullPath(pathName))
        if frame == nil then break end
        animation:addSpriteFrame(frame)
    end
    animation:setDelayPerUnit(frameRate)
    local action = cc.Animate:create(animation)
    return action     
end

--根据玩家id，获取他的视图id
function M:getViewIdByPlayerId(playerId)
    for key, var in pairs(self:find("SCGameClient").mPlayers) do
        if var.playerInfo.playerId == playerId then
            return var.view_id
        end
    end 
end

 --判断是否需要翻转 pos 是视图Id
function M:isPosRight(pos)
    local Direct = { LEFT_DOWN = 1, RIGHT_DOWN = 2, RIGHT_UP = 3, LEFT_UP = 4}
	return pos == Direct.RIGHT_DOWN or pos == Direct.RIGHT_UP
end

--获取需要旋转的角度 from/to 都是视图Id
function M:getAngle(from, to)
    --获取灯塔坐标
	local posFrom = wls.CannonPosList[from]   
    local posTo   = wls.CannonPosList[to]
	-- 去掉偏移影响
	local posDst = cc.p(posTo.x - posFrom.x, posTo.y - posFrom.y)
    return (cc.pGetAngle(cc.p(0, 0), posDst)/math.pi) * 180
end

return M