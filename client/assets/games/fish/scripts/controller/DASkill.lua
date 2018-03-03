----------------------------------------------------------------------
-- 作者：lps
-- 日期：2018-2-28
-- 描述：技能逻辑
----------------------------------------------------------------------

local M = class("DASkill", wls.GameObject)

function M:onCreate()
end

function M:getSkillCostProp(skillId)
    local propData = self:find("SCConfig"):getItemData(skillId)
    local priceData = string.split(propData.price,",")
    return tonumber(priceData[1]),tonumber(priceData[2])
end

function M:judgeUseType(skillId)
    print("------DASkill----judgeUseType---------")
    if self:judgeCount(skillId) then return 0 end
    if skillId == 17 then
        if not self:judgeViolent() then return nil end
    end
    if not self:judgeGem(skillId) then return nil end
    if not self:judgeGunRate(skillId) then return nil end
    return 1
end

--得到道具描述
function M:getPropDes(skillId)
    local itemData = self:find("SCConfig"):getItemData(skillId)
    local propDes = "$".."("..self:find("SCConfig"):getLanguageByID(800000337)..self:find("SCConfig"):getLanguageByID(800000218)..itemData.pack_text..")"
    return propDes
end

--判断个数是否足够
function M:judgeCount(skillId)
    local viewCount = self:find("UISkillPanel"):getSkillViewCount(skillId)
    if viewCount <= 0 then
        return false
    end
    return true
end
--判断钻石是否足够
function M:judgeGem(skillId,isNotice)
    if isNotice == nil then isNotice = true end
    local trueGemCount = self:find("DAPlayer"):getDataByKey("crystal")
    local cannon = self:find("UICannon" .. wls.SelfViewID)
    local viewGemCount = cannon:getGem()
    local cosrid ,price = self:getSkillCostProp(skillId)
    if viewGemCount < price then
        --提示钻石不够
        print("--提示钻石不够购买--")
        if isNotice then
            local function callback(ret)
                if ret == 1 then 
                    print("--吊起商店--")
                end
            end
            local propDes = self:getPropDes(skillId)
            local des = "\n"..self:find("SCConfig"):getLanguageByID(800000093).."\n"
            wls.Dialog(3,des..propDes,callback)    
        end
        return false
    end
    return true
end
--判断炮倍是否足够
function M:judgeGunRate(skillId,isNotice)
    if isNotice == nil then isNotice = true end
    local maxGunRate = self:find("DAPlayer"):getDataByKey("maxGunRate")
    local itemData = self:find("SCConfig"):getItemData(skillId)
    if maxGunRate < tonumber(itemData.need_cannon) then
        if isNotice then
            local function callback(ret)
                if ret == 1 then 
                    print("--吊起炮倍--")
                end
            end
            local propDes = self:getPropDes(skillId)
            local des = "\n"..self:find("SCConfig"):getLanguageByID(800000345)..itemData.need_cannon..self:find("SCConfig"):getLanguageByID(800000346).."\n"
            wls.Dialog(3,des..propDes,callback)    
        end
        return false
    end
    return true
end

--狂暴解锁提示
function M:judgeViolent()
    local maxGunRate = self:find("DAPlayer"):getDataByKey("maxGunRate")
    local itemData = self:find("SCConfig"):getItemData(17)
    if maxGunRate <  tonumber(itemData.need_cannon) then
        local function callback(ret)
            if ret == 1 then 
                print("--吊起炮倍--")
            end
        end
        local key = 800000348
        if maxGunRate < 100 then key = 800000347 end
        local propDes = self:getPropDes(17)
        local str = "\n"..self:find("SCConfig"):getLanguageByID(key).."\n"..propDes
        wls.Dialog(3,str,callback)
        return false
    end
    return true
end


return M