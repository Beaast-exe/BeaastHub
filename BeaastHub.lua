repeat task.wait() until game:IsLoaded()
local placeID = game.PlaceId
local GitHub = 'https://raw.githubusercontent.com/Beaast-exe/BeaastHub/master/scripts/'

-- // ANTI-AFK \\ --
local VirtualUser = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

function execute(rawScriptPath)
	print('[BeaastHub] Executing ' .. rawScriptPath)
	task.spawn(loadstring(game:HttpGet(GitHub .. rawScriptPath, true)))
end

if placeID == 11040063484 then -- [[ SWORDS FIGHTERS SIMULATOR ]] --
	execute('SwordFighters/SwordFighters.lua')
elseif placeID == 11542692507 then  -- [[ ANIME SOULS SIMULATOR ]] --
	execute('AnimeSouls/AnimeSoulsSimulator.lua')
elseif placeID == 6299805723 then -- [[ ANIME FIGHTERS SIMULATOR ]] --
	execute('AnimeFighters/AnimeFightersSimulator.lua')
elseif placeID == 9292879820 then -- [[ GRASS CUTTING INCREMENTAL ]] --
	execute('GrassCuttingIncremental/GrassCuttingIncremental.lua')
elseif placeID == 14433762945 then -- [[ ANIME CHAMPIONS SIMULATOR ]] --
	execute('AnimeChampions/AnimeChampionsSimulator.lua')
elseif placeID == 15367026228 then -- [[ ANIME SOULS SIMULATOR X ]] --
	execute('AnimeSouls/AnimeSoulsX_Protected.lua')
elseif placeID == 12886143095 then -- [[ ANIME LAST STAND ]] --
	execute('AnimeLastStand/AnimeLastStand.lua')
elseif placeID == 8737899170 or placeID == 16498369169 then -- [[ PET SIMULATOR 99 ]] --
	execute('PetSimulator/PS99.lua')
elseif placeID == 76598287484083 then
	execute('AnimePower/AnimePower.lua')
elseif placeID == 17334984034 then
	execute('AnimeKingdom/AnimeKingdom.lua')
end

if _G.IY then
	task.spawn(loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source')))
end