local ESX = exports['es_extended']:getSharedObject()

local onlineTime = 0
local getReward = 0
local serverTime = 0
local rewardCache = {}
local maxHour = 0

local function hoursToMs(hours)
    return hours * 60 * 60 * 1000
end

local function updateUI()
    pcall(function()
        onlineTime = exports['nongnut_onlinerewards']:getOnlineTime()
        getReward = exports['nongnut_onlinerewards']:getGetReward()
        serverTime = exports['nongnut_onlinerewards']:getServerTime()
    end)
    local currentTime = onlineTime + (GetNetworkTime() - serverTime)
    if getReward >= maxHour then
        exports[GetCurrentResourceName()]:postMessage('updateOnlineRewards', {
            seconds = math.floor(currentTime / 1000),
            index = #rewardCache
        })
        return
    end
    local remainingTime = 0
    local currentRewardIndex = 0
    for i = 1, #rewardCache do
        local reward = rewardCache[i]
        local time = reward.time
        local requiredTime = hoursToMs(time)
        remainingTime = requiredTime - currentTime
        if currentTime >= requiredTime and getReward >= time then
            currentRewardIndex = i
        else
            break
        end
    end
    exports[GetCurrentResourceName()]:postMessage('updateOnlineRewards', {
        seconds = math.floor(remainingTime / 1000),
        index = currentRewardIndex
    })
end

RegisterNetEvent('nongnut_inventory:initialized', function()
    while GetResourceState('nongnut_onlinerewards') ~= 'started' do
        Wait(500)
    end
    Wait(1000)
    local rewards = {}
    rewardCache = exports['nongnut_onlinerewards']:getRewards()
    for i = 1, #rewardCache do
        local reward = rewardCache[i]
        local items = {}
        for j = 1, #reward.items do
            local item = reward.items[j]
            items[j] = {
                name = item.name,
                count = item.amount
            }
        end
        rewards[i] = {
            icon = './images/items/' .. items[1].name .. '.png',
            name = reward.time,
            items = items
        }
    end
    maxHour = rewardCache[#rewardCache].time
    exports[GetCurrentResourceName()]:postMessage('setupOnlineRewards', {
        onlineRewards = {
            seconds = 0,
            rewards = rewards,
            currentRewardIndex = 0
        }
    })
    CreateThread(function()
        repeat
            updateUI()
            Wait(10000)
        until false
    end)
    RegisterNetEvent('nongnut_onlinerewards:update', function()
        updateUI()
    end)
end)