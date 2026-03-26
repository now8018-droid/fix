local sec = 1000
local min = sec * 60
setting = setting or {}

setting.eventroute = {
    ['getSharedObject'] = 'esx:getSharedObject',
}

setting.delayuse = 2 * sec
setting.useRemoteKey = 'U'
setting.getRemoteKey = 40
setting.distance = 7.0