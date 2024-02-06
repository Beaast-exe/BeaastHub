-- // VARIABLES \\ --
local VirtualInputManager = game:GetService("VirtualInputManager")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

-- // FEATURE DEFINING \\ --
local settings = {
	autoClick = {
		enabled = false,
		x = 0,
		y = 0,
		interval = 0.01
	}
}

-- // UI SETUP \\ --
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
	Name = "Beaast Hub",
	HidePremium = false,
	SaveConfig = false,
	IntroEnabled = false,
	IntroText = "Beaast Hub"
})

local Main = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Autos = Main:AddSection({
	Name = "Autos"
})

Autos:AddSlider({
	Name = "Auto Click Delay",
	Min = 0.01,
	Max = 1,
	Default = 0.01,
	Increment = 0.01,
	Color = Color3.fromRGB(0, 255, 255),
	Callback = function(value)
		settings.autoClick.interval = value
	end
})

Autos:AddBind({
	Name = "Toggle Auto Clicker",
	Default = Enum.KeyCode.F,
	Hold = false,
	Callback = function()
		settings.autoClick.x = Mouse.X
		settings.autoClick.y = Mouse.Y

		if settings.autoClick.enabled then
			settings.autoClick.enabled = false
			doAutoClick()
		else
			settings.autoClick.enabled = true
			doAutoClick()
		end
	end
})

-- // MISC TAB \\ --
local Misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local CREDITS = Misc:AddSection({
	Name = "Credits"
})

CREDITS:AddButton({
	Name = "COPY DISCORD LINK",
	Callback = function()
		setclipboard('https://discord.gg/MeAXMSCc9Q')
		OrionLib:MakeNotification({
			Name = "COPIED!",
			Content = "Discord link copied to your clipboard!",
			Time = 5
		})
  	end
})

CREDITS:AddLabel("Created by: Beaast#6458")

local UI = Misc:AddSection({
	Name = "UI Options"
})

UI:AddBind({
	Name = "Toggle UI",
	Default = Enum.KeyCode.RightControl,
	Hold = false,
	Callback = function()
		local UI = game:GetService("CoreGui"):FindFirstChild("Orion")
		if UI then
			UI.Enabled = not UI.Enabled
		end
	end
})

UI:AddButton({
	Name = "Destroy UI",
	Callback = function()
		OrionLib:Destroy()
  	end
})

-- // CHEAT FUNCTIONS \\ --
function doAutoClick()
	spawn(function()
		while settings.autoClick.enabled do
			VirtualInputManager:SendMouseButtonEvent(settings.autoClick.x, settings.autoClick.y, 0, true, game, 1)
			VirtualInputManager:SendMouseButtonEvent(settings.autoClick.x, settings.autoClick.y, 0, false, game, 1)
			wait(settings.autoClick.interval)
		end
	end)
end

-- // INITIALIZE THE SCRIPT \\ --
OrionLib:Init()