local placeId == 76598287484083
if game.placeId ~= placeId then return end
repeat task.wait() until game:IsLoaded()
local StartTick = tick()

local HttpService = game:GetService('HttpService')