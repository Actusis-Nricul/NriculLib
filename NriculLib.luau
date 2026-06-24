--[[
    NriculLib
    By Actusis-Nricul

    Load with:
    local Lib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Actusis-Nricul/NriculLib/refs/heads/main/NriculLib.luau'))()
]]

local NriculLib = {}
NriculLib.Flags = {}

-- =====================
-- SERVICES
-- =====================
local Players           = game:GetService("Players")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local RunService         = game:GetService("RunService")
local CoreGui            = game:GetService("CoreGui")
local HttpService        = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- =====================
-- LUCIDE ICONS
-- =====================
local Lucide = nil
do
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(
            "https://github.com/latte-soft/lucide-roblox/releases/latest/download/lucide-roblox.luau"
        ))()
    end)
    if ok and result then
        Lucide = result
    else
        warn("NriculLib | Failed to load Lucide icon library — icons will not render. " .. tostring(result))
    end
end

local function isLucideIcon(icon)
    if not Lucide or typeof(icon) ~= "string" then return false end
    local names = Lucide.IconNames
    if not names then return false end
    return table.find(names, icon:lower()) ~= nil
end

-- configures an existing ImageLabel with the resolved icon.
-- accepts: Lucide icon name (string), raw rbxassetid number, or "rbxassetid://...""/"rbxasset://..."/"http..." string
-- returns true if something was applied, false if blank
local function applyIcon(imgLabel, icon, size)
    if not icon or icon == "" then
        imgLabel.Visible = false
        return false
    end

    if typeof(icon) == "string" and (icon:match("^rbxassetid://") or icon:match("^rbxasset://") or icon:match("^http")) then
        imgLabel.Image = icon
        imgLabel.ImageRectOffset = Vector2.zero
        imgLabel.ImageRectSize = Vector2.zero
        imgLabel.Visible = true
        return true
    end

    if typeof(icon) == "number" then
        imgLabel.Image = "rbxassetid://" .. tostring(icon)
        imgLabel.ImageRectOffset = Vector2.zero
        imgLabel.ImageRectSize = Vector2.zero
        imgLabel.Visible = true
        return true
    end

    if isLucideIcon(icon) then
        local ok, asset = pcall(function()
            return Lucide.GetAsset(icon:lower(), size or 48)
        end)
        if ok and asset then
            imgLabel.Image = asset.Url
            imgLabel.ImageRectOffset = asset.ImageRectOffset
            imgLabel.ImageRectSize = asset.ImageRectSize
            imgLabel.Visible = true
            return true
        end
    end

    imgLabel.Visible = false
    return false
end

-- =====================
-- THEMES
-- =====================
NriculLib.Theme = {
    Default = {
        Background = Color3.fromRGB(18, 18, 26), Topbar = Color3.fromRGB(24, 24, 34),
        Accent = Color3.fromRGB(90, 110, 255), TextColor = Color3.fromRGB(235, 235, 245),
        SubTextColor = Color3.fromRGB(150, 150, 165), TabBackground = Color3.fromRGB(26, 26, 38),
        TabSelected = Color3.fromRGB(90, 110, 255), ElementBackground = Color3.fromRGB(28, 28, 40),
        ElementHover = Color3.fromRGB(36, 36, 50), ElementStroke = Color3.fromRGB(45, 45, 60),
        ToggleOn = Color3.fromRGB(90, 200, 130), ToggleOff = Color3.fromRGB(60, 60, 75),
        InputBackground = Color3.fromRGB(22, 22, 32),
    },
    Midnight = {
        Background = Color3.fromRGB(10, 10, 16), Topbar = Color3.fromRGB(14, 14, 22),
        Accent = Color3.fromRGB(140, 80, 255), TextColor = Color3.fromRGB(230, 230, 240),
        SubTextColor = Color3.fromRGB(120, 120, 140), TabBackground = Color3.fromRGB(16, 16, 26),
        TabSelected = Color3.fromRGB(140, 80, 255), ElementBackground = Color3.fromRGB(18, 18, 28),
        ElementHover = Color3.fromRGB(26, 26, 38), ElementStroke = Color3.fromRGB(35, 35, 50),
        ToggleOn = Color3.fromRGB(140, 80, 255), ToggleOff = Color3.fromRGB(45, 45, 60),
        InputBackground = Color3.fromRGB(14, 14, 22),
    },
    Ocean = {
        Background = Color3.fromRGB(12, 22, 28), Topbar = Color3.fromRGB(16, 28, 34),
        Accent = Color3.fromRGB(40, 180, 220), TextColor = Color3.fromRGB(225, 240, 245),
        SubTextColor = Color3.fromRGB(120, 160, 170), TabBackground = Color3.fromRGB(18, 32, 38),
        TabSelected = Color3.fromRGB(40, 180, 220), ElementBackground = Color3.fromRGB(20, 36, 42),
        ElementHover = Color3.fromRGB(26, 46, 52), ElementStroke = Color3.fromRGB(35, 60, 68),
        ToggleOn = Color3.fromRGB(40, 180, 220), ToggleOff = Color3.fromRGB(45, 60, 65),
        InputBackground = Color3.fromRGB(16, 28, 34),
    },
    Crimson = {
        Background = Color3.fromRGB(22, 12, 14), Topbar = Color3.fromRGB(30, 16, 18),
        Accent = Color3.fromRGB(230, 60, 70), TextColor = Color3.fromRGB(245, 230, 230),
        SubTextColor = Color3.fromRGB(170, 130, 130), TabBackground = Color3.fromRGB(32, 18, 20),
        TabSelected = Color3.fromRGB(230, 60, 70), ElementBackground = Color3.fromRGB(34, 20, 22),
        ElementHover = Color3.fromRGB(44, 26, 28), ElementStroke = Color3.fromRGB(55, 35, 38),
        ToggleOn = Color3.fromRGB(230, 60, 70), ToggleOff = Color3.fromRGB(55, 40, 42),
        InputBackground = Color3.fromRGB(26, 14, 16),
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245), Topbar = Color3.fromRGB(225, 225, 235),
        Accent = Color3.fromRGB(70, 110, 230), TextColor = Color3.fromRGB(30, 30, 40),
        SubTextColor = Color3.fromRGB(100, 100, 115), TabBackground = Color3.fromRGB(220, 220, 230),
        TabSelected = Color3.fromRGB(70, 110, 230), ElementBackground = Color3.fromRGB(228, 228, 238),
        ElementHover = Color3.fromRGB(215, 215, 228), ElementStroke = Color3.fromRGB(200, 200, 212),
        ToggleOn = Color3.fromRGB(70, 150, 230), ToggleOff = Color3.fromRGB(190, 190, 200),
        InputBackground = Color3.fromRGB(232, 232, 242),
    },
    Neon = {
        Background = Color3.fromRGB(8, 8, 12), Topbar = Color3.fromRGB(10, 10, 16),
        Accent = Color3.fromRGB(0, 255, 170), TextColor = Color3.fromRGB(200, 255, 240),
        SubTextColor = Color3.fromRGB(100, 200, 170), TabBackground = Color3.fromRGB(12, 18, 14),
        TabSelected = Color3.fromRGB(0, 255, 170), ElementBackground = Color3.fromRGB(12, 20, 16),
        ElementHover = Color3.fromRGB(18, 30, 22), ElementStroke = Color3.fromRGB(0, 80, 55),
        ToggleOn = Color3.fromRGB(0, 255, 170), ToggleOff = Color3.fromRGB(30, 50, 40),
        InputBackground = Color3.fromRGB(10, 16, 12),
    },
    Sunset = {
        Background = Color3.fromRGB(20, 12, 18), Topbar = Color3.fromRGB(28, 16, 24),
        Accent = Color3.fromRGB(255, 130, 60), TextColor = Color3.fromRGB(255, 235, 220),
        SubTextColor = Color3.fromRGB(200, 160, 130), TabBackground = Color3.fromRGB(30, 18, 26),
        TabSelected = Color3.fromRGB(255, 130, 60), ElementBackground = Color3.fromRGB(32, 20, 28),
        ElementHover = Color3.fromRGB(42, 26, 36), ElementStroke = Color3.fromRGB(80, 45, 55),
        ToggleOn = Color3.fromRGB(255, 130, 60), ToggleOff = Color3.fromRGB(60, 40, 45),
        InputBackground = Color3.fromRGB(24, 14, 20),
    },
    Arctic = {
        Background = Color3.fromRGB(230, 240, 250), Topbar = Color3.fromRGB(210, 225, 240),
        Accent = Color3.fromRGB(80, 160, 220), TextColor = Color3.fromRGB(20, 40, 60),
        SubTextColor = Color3.fromRGB(90, 130, 160), TabBackground = Color3.fromRGB(200, 218, 235),
        TabSelected = Color3.fromRGB(80, 160, 220), ElementBackground = Color3.fromRGB(215, 230, 245),
        ElementHover = Color3.fromRGB(200, 215, 232), ElementStroke = Color3.fromRGB(170, 195, 220),
        ToggleOn = Color3.fromRGB(80, 160, 220), ToggleOff = Color3.fromRGB(170, 195, 215),
        InputBackground = Color3.fromRGB(220, 233, 247),
    },
    Void = {
        Background = Color3.fromRGB(4, 4, 8), Topbar = Color3.fromRGB(6, 6, 12),
        Accent = Color3.fromRGB(180, 60, 255), TextColor = Color3.fromRGB(220, 210, 240),
        SubTextColor = Color3.fromRGB(120, 100, 150), TabBackground = Color3.fromRGB(8, 6, 14),
        TabSelected = Color3.fromRGB(180, 60, 255), ElementBackground = Color3.fromRGB(10, 8, 18),
        ElementHover = Color3.fromRGB(18, 12, 30), ElementStroke = Color3.fromRGB(50, 30, 80),
        ToggleOn = Color3.fromRGB(180, 60, 255), ToggleOff = Color3.fromRGB(40, 28, 60),
        InputBackground = Color3.fromRGB(8, 6, 14),
    },
    Sakura = {
        Background = Color3.fromRGB(30, 16, 22), Topbar = Color3.fromRGB(40, 20, 28),
        Accent = Color3.fromRGB(255, 160, 190), TextColor = Color3.fromRGB(255, 235, 242),
        SubTextColor = Color3.fromRGB(210, 160, 180), TabBackground = Color3.fromRGB(44, 22, 32),
        TabSelected = Color3.fromRGB(255, 160, 190), ElementBackground = Color3.fromRGB(46, 24, 34),
        ElementHover = Color3.fromRGB(58, 30, 42), ElementStroke = Color3.fromRGB(80, 44, 58),
        ToggleOn = Color3.fromRGB(255, 160, 190), ToggleOff = Color3.fromRGB(70, 44, 54),
        InputBackground = Color3.fromRGB(36, 18, 26),
    },
    Forest = {
        Background = Color3.fromRGB(14, 24, 16), Topbar = Color3.fromRGB(18, 30, 20),
        Accent = Color3.fromRGB(90, 200, 120), TextColor = Color3.fromRGB(230, 245, 235),
        SubTextColor = Color3.fromRGB(140, 180, 150), TabBackground = Color3.fromRGB(20, 34, 24),
        TabSelected = Color3.fromRGB(90, 200, 120), ElementBackground = Color3.fromRGB(22, 38, 26),
        ElementHover = Color3.fromRGB(28, 46, 32), ElementStroke = Color3.fromRGB(40, 70, 50),
        ToggleOn = Color3.fromRGB(90, 200, 120), ToggleOff = Color3.fromRGB(55, 70, 60),
        InputBackground = Color3.fromRGB(18, 28, 20),
    },
    Lavender = {
        Background = Color3.fromRGB(18, 14, 28), Topbar = Color3.fromRGB(22, 18, 34),
        Accent = Color3.fromRGB(170, 120, 255), TextColor = Color3.fromRGB(240, 235, 250),
        SubTextColor = Color3.fromRGB(160, 150, 190), TabBackground = Color3.fromRGB(26, 20, 40),
        TabSelected = Color3.fromRGB(170, 120, 255), ElementBackground = Color3.fromRGB(28, 22, 44),
        ElementHover = Color3.fromRGB(36, 28, 56), ElementStroke = Color3.fromRGB(60, 45, 90),
        ToggleOn = Color3.fromRGB(170, 120, 255), ToggleOff = Color3.fromRGB(60, 55, 80),
        InputBackground = Color3.fromRGB(20, 16, 32),
    },
    Solar = {
        Background = Color3.fromRGB(28, 20, 10), Topbar = Color3.fromRGB(36, 26, 14),
        Accent = Color3.fromRGB(255, 190, 80), TextColor = Color3.fromRGB(255, 245, 225),
        SubTextColor = Color3.fromRGB(200, 170, 120), TabBackground = Color3.fromRGB(40, 28, 16),
        TabSelected = Color3.fromRGB(255, 190, 80), ElementBackground = Color3.fromRGB(44, 32, 18),
        ElementHover = Color3.fromRGB(54, 40, 22), ElementStroke = Color3.fromRGB(90, 65, 35),
        ToggleOn = Color3.fromRGB(255, 190, 80), ToggleOff = Color3.fromRGB(70, 55, 40),
        InputBackground = Color3.fromRGB(32, 24, 12),
    },
    Monochrome = {
        Background = Color3.fromRGB(15, 15, 15), Topbar = Color3.fromRGB(22, 22, 22),
        Accent = Color3.fromRGB(180, 180, 180), TextColor = Color3.fromRGB(235, 235, 235),
        SubTextColor = Color3.fromRGB(140, 140, 140), TabBackground = Color3.fromRGB(25, 25, 25),
        TabSelected = Color3.fromRGB(180, 180, 180), ElementBackground = Color3.fromRGB(28, 28, 28),
        ElementHover = Color3.fromRGB(35, 35, 35), ElementStroke = Color3.fromRGB(55, 55, 55),
        ToggleOn = Color3.fromRGB(200, 200, 200), ToggleOff = Color3.fromRGB(70, 70, 70),
        InputBackground = Color3.fromRGB(20, 20, 20),
    },
    Cyber = {
        Background = Color3.fromRGB(8, 12, 18), Topbar = Color3.fromRGB(12, 18, 28),
        Accent = Color3.fromRGB(0, 200, 255), TextColor = Color3.fromRGB(220, 240, 255),
        SubTextColor = Color3.fromRGB(120, 170, 200), TabBackground = Color3.fromRGB(14, 22, 34),
        TabSelected = Color3.fromRGB(0, 200, 255), ElementBackground = Color3.fromRGB(16, 26, 40),
        ElementHover = Color3.fromRGB(22, 36, 55), ElementStroke = Color3.fromRGB(40, 90, 120),
        ToggleOn = Color3.fromRGB(0, 200, 255), ToggleOff = Color3.fromRGB(40, 60, 80),
        InputBackground = Color3.fromRGB(10, 16, 24),
    },
    Ember = {
        Background = Color3.fromRGB(18, 10, 10), Topbar = Color3.fromRGB(28, 14, 14),
        Accent = Color3.fromRGB(255, 90, 60), TextColor = Color3.fromRGB(255, 230, 225),
        SubTextColor = Color3.fromRGB(190, 130, 120), TabBackground = Color3.fromRGB(34, 18, 18),
        TabSelected = Color3.fromRGB(255, 90, 60), ElementBackground = Color3.fromRGB(38, 20, 20),
        ElementHover = Color3.fromRGB(48, 26, 26), ElementStroke = Color3.fromRGB(90, 45, 45),
        ToggleOn = Color3.fromRGB(255, 120, 80), ToggleOff = Color3.fromRGB(80, 50, 50),
        InputBackground = Color3.fromRGB(24, 12, 12),
    },
    AquaMint = {
        Background = Color3.fromRGB(10, 20, 22), Topbar = Color3.fromRGB(14, 26, 28),
        Accent = Color3.fromRGB(80, 230, 200), TextColor = Color3.fromRGB(225, 255, 250),
        SubTextColor = Color3.fromRGB(120, 190, 180), TabBackground = Color3.fromRGB(16, 32, 34),
        TabSelected = Color3.fromRGB(80, 230, 200), ElementBackground = Color3.fromRGB(18, 36, 38),
        ElementHover = Color3.fromRGB(24, 46, 48), ElementStroke = Color3.fromRGB(50, 100, 95),
        ToggleOn = Color3.fromRGB(80, 230, 200), ToggleOff = Color3.fromRGB(45, 70, 68),
        InputBackground = Color3.fromRGB(12, 24, 26),
    },
    RoseGold = {
        Background = Color3.fromRGB(24, 18, 20), Topbar = Color3.fromRGB(32, 24, 26),
        Accent = Color3.fromRGB(225, 170, 150), TextColor = Color3.fromRGB(255, 240, 235),
        SubTextColor = Color3.fromRGB(190, 150, 140), TabBackground = Color3.fromRGB(38, 28, 30),
        TabSelected = Color3.fromRGB(225, 170, 150), ElementBackground = Color3.fromRGB(42, 32, 34),
        ElementHover = Color3.fromRGB(52, 40, 42), ElementStroke = Color3.fromRGB(100, 80, 78),
        ToggleOn = Color3.fromRGB(240, 190, 170), ToggleOff = Color3.fromRGB(80, 65, 65),
        InputBackground = Color3.fromRGB(28, 22, 24),
    },
    Thunder = {
        Background = Color3.fromRGB(12, 12, 18), Topbar = Color3.fromRGB(18, 18, 26),
        Accent = Color3.fromRGB(255, 230, 90), TextColor = Color3.fromRGB(240, 240, 220),
        SubTextColor = Color3.fromRGB(160, 160, 120), TabBackground = Color3.fromRGB(22, 22, 32),
        TabSelected = Color3.fromRGB(255, 230, 90), ElementBackground = Color3.fromRGB(26, 26, 38),
        ElementHover = Color3.fromRGB(34, 34, 50), ElementStroke = Color3.fromRGB(70, 70, 90),
        ToggleOn = Color3.fromRGB(255, 230, 90), ToggleOff = Color3.fromRGB(60, 60, 75),
        InputBackground = Color3.fromRGB(16, 16, 24),
    },
    Candy = {
        Background = Color3.fromRGB(255, 240, 250), Topbar = Color3.fromRGB(255, 220, 235),
        Accent = Color3.fromRGB(255, 120, 180), TextColor = Color3.fromRGB(60, 30, 50),
        SubTextColor = Color3.fromRGB(140, 90, 120), TabBackground = Color3.fromRGB(255, 225, 240),
        TabSelected = Color3.fromRGB(255, 120, 180), ElementBackground = Color3.fromRGB(255, 235, 245),
        ElementHover = Color3.fromRGB(255, 210, 230), ElementStroke = Color3.fromRGB(220, 180, 200),
        ToggleOn = Color3.fromRGB(255, 120, 180), ToggleOff = Color3.fromRGB(200, 170, 190),
        InputBackground = Color3.fromRGB(255, 230, 240),
    },
    Matrix = {
        Background = Color3.fromRGB(5, 10, 5), Topbar = Color3.fromRGB(10, 20, 10),
        Accent = Color3.fromRGB(0, 255, 80), TextColor = Color3.fromRGB(200, 255, 200),
        SubTextColor = Color3.fromRGB(120, 200, 120), TabBackground = Color3.fromRGB(8, 16, 8),
        TabSelected = Color3.fromRGB(0, 255, 80), ElementBackground = Color3.fromRGB(10, 22, 10),
        ElementHover = Color3.fromRGB(15, 30, 15), ElementStroke = Color3.fromRGB(30, 80, 30),
        ToggleOn = Color3.fromRGB(0, 255, 80), ToggleOff = Color3.fromRGB(40, 70, 40),
        InputBackground = Color3.fromRGB(6, 14, 6),
    },
    Galaxy = {
        Background = Color3.fromRGB(10, 8, 20), Topbar = Color3.fromRGB(18, 12, 35),
        Accent = Color3.fromRGB(120, 90, 255), TextColor = Color3.fromRGB(235, 230, 255),
        SubTextColor = Color3.fromRGB(150, 140, 200), TabBackground = Color3.fromRGB(14, 10, 28),
        TabSelected = Color3.fromRGB(120, 90, 255), ElementBackground = Color3.fromRGB(16, 12, 32),
        ElementHover = Color3.fromRGB(24, 18, 45), ElementStroke = Color3.fromRGB(60, 50, 100),
        ToggleOn = Color3.fromRGB(120, 90, 255), ToggleOff = Color3.fromRGB(60, 55, 90),
        InputBackground = Color3.fromRGB(12, 10, 24),
    },
    Desert = {
        Background = Color3.fromRGB(30, 24, 18), Topbar = Color3.fromRGB(40, 32, 24),
        Accent = Color3.fromRGB(230, 180, 90), TextColor = Color3.fromRGB(255, 245, 220),
        SubTextColor = Color3.fromRGB(180, 150, 110), TabBackground = Color3.fromRGB(38, 30, 22),
        TabSelected = Color3.fromRGB(230, 180, 90), ElementBackground = Color3.fromRGB(42, 34, 26),
        ElementHover = Color3.fromRGB(52, 42, 32), ElementStroke = Color3.fromRGB(90, 70, 50),
        ToggleOn = Color3.fromRGB(230, 180, 90), ToggleOff = Color3.fromRGB(80, 65, 50),
        InputBackground = Color3.fromRGB(34, 26, 20),
    },
    Steel = {
        Background = Color3.fromRGB(18, 20, 22), Topbar = Color3.fromRGB(26, 28, 32),
        Accent = Color3.fromRGB(120, 140, 160), TextColor = Color3.fromRGB(235, 240, 245),
        SubTextColor = Color3.fromRGB(150, 160, 170), TabBackground = Color3.fromRGB(24, 26, 30),
        TabSelected = Color3.fromRGB(120, 140, 160), ElementBackground = Color3.fromRGB(28, 30, 34),
        ElementHover = Color3.fromRGB(36, 38, 42), ElementStroke = Color3.fromRGB(70, 80, 90),
        ToggleOn = Color3.fromRGB(140, 160, 180), ToggleOff = Color3.fromRGB(80, 85, 90),
        InputBackground = Color3.fromRGB(22, 24, 26),
    },
}

local SelectedTheme = NriculLib.Theme.Default

-- =====================
-- HELPERS
-- =====================
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local QUICK = TweenInfo.new(0.25, Enum.EasingStyle.Quint)

local function round(inst, radius)
    create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = inst})
end

local function stroke(inst, color, thickness)
    return create("UIStroke", {
        Color = color or SelectedTheme.ElementStroke,
        Thickness = thickness or 1,
        Parent = inst,
    })
end

local function safeCall(fn, ...)
    if not fn then return true end
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("NriculLib | Callback Error: " .. tostring(err))
    end
    return ok, err
end

-- =====================
-- FILESYSTEM SAFE WRAPPERS
-- =====================
local hasFS = type(isfolder) == "function" and type(makefolder) == "function"
    and type(isfile) == "function" and type(writefile) == "function" and type(readfile) == "function"

local function ensureFolder(path)
    if hasFS then
        pcall(function()
            if not isfolder(path) then makefolder(path) end
        end)
    end
end

-- =====================
-- DISCORD JOIN (matches Rayfield's exact behaviour)
-- =====================
local NriculLibFolder = "NriculLib"
local ConfigurationExtension = ".nlib"
local requestFunc = (syn and syn.request) or (fluxus and fluxus.request)
    or (http and http.request) or http_request or request

local function handleDiscordPrompt(discordSettings)
    if not discordSettings or not discordSettings.Enabled then return end
    if not discordSettings.Invite or discordSettings.Invite == "" then return end

    ensureFolder(NriculLibFolder)
    ensureFolder(NriculLibFolder .. "/Discord Invites")

    local inviteFile = NriculLibFolder .. "/Discord Invites/" .. discordSettings.Invite .. ConfigurationExtension

    if not (hasFS and pcall(isfile, inviteFile) and isfile(inviteFile)) then
        if requestFunc then
            pcall(function()
                requestFunc({
                    Url = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        Origin = "https://discord.com",
                    },
                    Body = HttpService:JSONEncode({
                        cmd = "INVITE_BROWSER",
                        nonce = HttpService:GenerateGUID(false),
                        args = {code = discordSettings.Invite},
                    }),
                })
            end)
        end

        if discordSettings.RememberJoins then
            if hasFS then
                pcall(function()
                    writefile(
                        inviteFile,
                        "NriculLib RememberJoins is true for this invite, this invite will not ask you to join again"
                    )
                end)
            end
        end
    end
end

-- =====================
-- CreateGui (main entry point)
-- =====================
function NriculLib:CreateGui(settings)
    settings = settings or {}

    -- =====================
    -- KEY SYSTEM (local-only, no HTTP)
    -- =====================
    if settings.KeySystem then
        local ks = settings.KeySettings or {}
        local validKeys = ks.Key or {}
        if typeof(validKeys) == "string" then validKeys = {validKeys} end

        local folder = "NriculLib/Key System"
        ensureFolder("NriculLib")
        ensureFolder(folder)
        local keyFile = folder .. "/" .. tostring(ks.FileName or "key") .. ".key"

        local passthrough = false

        if hasFS and ks.SaveKey then
            local ok, saved = pcall(readfile, keyFile)
            if ok and saved then
                for _, validKey in ipairs(validKeys) do
                    if saved == validKey then
                        passthrough = true
                        break
                    end
                end
            end
        end

        if not passthrough then
            local keyGui = create("ScreenGui", {
                Name = "NriculLib_KeyCheck",
                ResetOnSpawn = false,
                DisplayOrder = 1000,
            })
            local parentTarget = (gethui and gethui()) or CoreGui
            if syn and syn.protect_gui then pcall(syn.protect_gui, keyGui) end
            keyGui.Parent = parentTarget

            local keyMain = create("Frame", {
                Size = UDim2.new(0, 360, 0, 200),
                Position = UDim2.new(0.5, -180, 0.5, -100),
                BackgroundColor3 = SelectedTheme.Background,
                BorderSizePixel = 0,
                Parent = keyGui,
            })
            round(keyMain, 12)
            stroke(keyMain, SelectedTheme.ElementStroke)

            create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 28),
                Position = UDim2.new(0, 10, 0, 14),
                BackgroundTransparency = 1,
                Text = ks.Title or "Key Required",
                TextColor3 = SelectedTheme.TextColor,
                Font = Enum.Font.GothamBold,
                TextSize = 18,
                Parent = keyMain,
            })

            create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 18),
                Position = UDim2.new(0, 10, 0, 42),
                BackgroundTransparency = 1,
                Text = ks.Subtitle or "Enter your key to continue",
                TextColor3 = SelectedTheme.SubTextColor,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                Parent = keyMain,
            })

            create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 36),
                Position = UDim2.new(0, 10, 0, 64),
                BackgroundTransparency = 1,
                Text = ks.Note or "No instructions provided.",
                TextColor3 = SelectedTheme.SubTextColor,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextWrapped = true,
                Parent = keyMain,
            })

            local inputBox = create("TextBox", {
                Size = UDim2.new(1, -20, 0, 34),
                Position = UDim2.new(0, 10, 0, 108),
                BackgroundColor3 = SelectedTheme.InputBackground,
                Text = "",
                PlaceholderText = "Enter key here...",
                TextColor3 = SelectedTheme.TextColor,
                PlaceholderColor3 = SelectedTheme.SubTextColor,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                ClearTextOnFocus = false,
                BorderSizePixel = 0,
                Parent = keyMain,
            })
            round(inputBox, 8)
            stroke(inputBox, SelectedTheme.ElementStroke)

            local submitBtn = create("TextButton", {
                Size = UDim2.new(1, -20, 0, 34),
                Position = UDim2.new(0, 10, 0, 150),
                BackgroundColor3 = SelectedTheme.Accent,
                Text = "Submit",
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Parent = keyMain,
            })
            round(submitBtn, 8)

            local waiting = true
            local function attempt()
                local text = inputBox.Text
                for _, validKey in ipairs(validKeys) do
                    if text == validKey then
                        if hasFS and ks.SaveKey then
                            pcall(writefile, keyFile, text)
                        end
                        waiting = false
                        keyGui:Destroy()
                        return
                    end
                end
                tween(keyMain, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 20, 20)})
                task.wait(0.15)
                tween(keyMain, TweenInfo.new(0.3), {BackgroundColor3 = SelectedTheme.Background})
                inputBox.Text = ""
            end

            submitBtn.MouseButton1Click:Connect(attempt)
            inputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then attempt() end
            end)

            repeat task.wait(0.1) until not waiting
        end
    end

    local Window = {}
    Window._tabs = {}
    Window._connections = {}

    if settings.Theme then
        if typeof(settings.Theme) == "string" and NriculLib.Theme[settings.Theme] then
            SelectedTheme = NriculLib.Theme[settings.Theme]
        elseif typeof(settings.Theme) == "table" then
            SelectedTheme = settings.Theme
        end
    end

    -- =====================
    -- ROOT GUI
    -- =====================
    local screenGui = create("ScreenGui", {
        Name = "NriculLib_" .. (settings.Name or "Window"):gsub("%s", ""),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    })

    local parentTarget = (gethui and gethui()) or CoreGui

    for _, child in ipairs(parentTarget:GetChildren()) do
        if child.Name == screenGui.Name then child:Destroy() end
    end

    if syn and syn.protect_gui then pcall(syn.protect_gui, screenGui) end
    screenGui.Parent = parentTarget

    local minimized = false
    local mainSize = UDim2.new(0, 520, 0, 380)

    local main = create("Frame", {
        Size = mainSize,
        Position = UDim2.new(0.5, -260, 0.5, -190),
        BackgroundColor3 = SelectedTheme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = screenGui,
    })
    round(main, 12)
    stroke(main, SelectedTheme.ElementStroke, 1)

    create("ImageLabel", {
        Size = UDim2.new(1, 60, 1, 60),
        Position = UDim2.new(0, -30, 0, -30),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1,
        Parent = main,
    })

    -- =====================
    -- TOPBAR
    -- =====================
    local topbar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = SelectedTheme.Topbar,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = main,
    })
    round(topbar, 12)

    create("Frame", {
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = SelectedTheme.Topbar,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = topbar,
    })

    -- topbar icon: real Lucide icon if settings.Icon given, else first-letter fallback
    local topbarIconImg = create("ImageLabel", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 13, 0.5, -9),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 7,
        Parent = topbar,
    })
    local hasTopbarIcon = false
    if settings.Icon then
        hasTopbarIcon = applyIcon(topbarIconImg, settings.Icon, 48)
    end

    local iconCircle = create("Frame", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 10, 0.5, -13),
        BackgroundColor3 = SelectedTheme.Accent,
        BorderSizePixel = 0,
        Visible = not hasTopbarIcon,
        ZIndex = 6,
        Parent = topbar,
    })
    round(iconCircle, 13)

    create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = (settings.Name or "N"):sub(1, 1):upper(),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        ZIndex = 7,
        Parent = iconCircle,
    })

    create("TextLabel", {
        Size = UDim2.new(1, -160, 1, 0),
        Position = UDim2.new(0, 46, 0, 0),
        BackgroundTransparency = 1,
        Text = settings.Name or "NriculLib",
        TextColor3 = SelectedTheme.TextColor,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = topbar,
    })

    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -34, 0.5, -13),
        BackgroundColor3 = Color3.fromRGB(200, 60, 60),
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 7,
        Parent = topbar,
    })
    round(closeBtn, 13)
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    local minBtn = create("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -64, 0.5, -13),
        BackgroundColor3 = Color3.fromRGB(220, 170, 40),
        Text = "-",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 7,
        Parent = topbar,
    })
    round(minBtn, 13)

    local function setMinimized(state)
        minimized = state
        if minimized then
            tween(main, QUICK, {Size = UDim2.new(0, mainSize.X.Offset, 0, 42)})
        else
            tween(main, QUICK, {Size = mainSize})
        end
    end
    minBtn.MouseButton1Click:Connect(function() setMinimized(not minimized) end)

    -- dragging
    local dragging, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- keybinds
    local minimizeKeybind = settings.MinimizeKeybind
    local toggleUIKeybind  = settings.ToggleUIKeybind
    local guiVisible = true

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if minimizeKeybind then
            local kc = typeof(minimizeKeybind) == "string" and Enum.KeyCode[minimizeKeybind:upper()] or minimizeKeybind
            if kc and input.KeyCode == kc then setMinimized(not minimized) end
        end
        if toggleUIKeybind then
            local kc = typeof(toggleUIKeybind) == "string" and Enum.KeyCode[toggleUIKeybind:upper()] or toggleUIKeybind
            if kc and input.KeyCode == kc then
                guiVisible = not guiVisible
                main.Visible = guiVisible
            end
        end
    end)

    -- =====================
    -- TAB LIST
    -- =====================
    local tabListWidth = 130
    local tabList = create("Frame", {
        Size = UDim2.new(0, tabListWidth, 1, -42),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundColor3 = SelectedTheme.Topbar,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = main,
    })
    create("UIListLayout", {Padding = UDim.new(0, 4), Parent = tabList})
    create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = tabList})

    local contentArea = create("Frame", {
        Size = UDim2.new(1, -tabListWidth, 1, -42),
        Position = UDim2.new(0, tabListWidth, 0, 42),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = main,
    })

    local firstTabSet = false

    -- =====================
    -- NOTIFICATIONS
    -- =====================
    local notifContainer = create("Frame", {
        Size = UDim2.new(0, 300, 1, -20),
        Position = UDim2.new(1, -310, 0, 10),
        BackgroundTransparency = 1,
        ZIndex = 500,
        Parent = screenGui,
    })
    create("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 6),
        Parent = notifContainer,
    })

    function Window:Notify(data)
        data = data or {}
        local notif = create("Frame", {
            Size = UDim2.new(1, 0, 0, 64),
            BackgroundColor3 = SelectedTheme.ElementBackground,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 501,
            Parent = notifContainer,
        })
        round(notif, 8)
        local s = stroke(notif, SelectedTheme.ElementStroke)
        s.Transparency = 1

        local accent = create("Frame", {
            Size = UDim2.new(0, 3, 1, -12),
            Position = UDim2.new(0, 0, 0, 6),
            BackgroundColor3 = SelectedTheme.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 502,
            Parent = notif,
        })

        local titleL = create("TextLabel", {
            Size = UDim2.new(1, -16, 0, 22),
            Position = UDim2.new(0, 12, 0, 6),
            BackgroundTransparency = 1,
            Text = data.Title or "Notification",
            TextColor3 = SelectedTheme.TextColor,
            TextTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 502,
            Parent = notif,
        })

        local contentL = create("TextLabel", {
            Size = UDim2.new(1, -16, 0, 30),
            Position = UDim2.new(0, 12, 0, 28),
            BackgroundTransparency = 1,
            Text = data.Content or "",
            TextColor3 = SelectedTheme.SubTextColor,
            TextTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 502,
            Parent = notif,
        })

        tween(notif, TweenInfo.new(0.3), {BackgroundTransparency = 0})
        tween(s, TweenInfo.new(0.3), {Transparency = 0})
        tween(accent, TweenInfo.new(0.3), {BackgroundTransparency = 0})
        tween(titleL, TweenInfo.new(0.3), {TextTransparency = 0})
        tween(contentL, TweenInfo.new(0.3), {TextTransparency = 0})

        task.delay(data.Duration or 4, function()
            if notif and notif.Parent then
                tween(notif, TweenInfo.new(0.3), {BackgroundTransparency = 1})
                tween(s, TweenInfo.new(0.3), {Transparency = 1})
                tween(accent, TweenInfo.new(0.3), {BackgroundTransparency = 1})
                tween(titleL, TweenInfo.new(0.3), {TextTransparency = 1})
                tween(contentL, TweenInfo.new(0.3), {TextTransparency = 1})
                task.wait(0.35)
                if notif then notif:Destroy() end
            end
        end)
    end

    if settings.Discord then
        task.spawn(function()
            handleDiscordPrompt(settings.Discord)
        end)
    end

    -- =====================
    -- CreateTab (real Lucide icon support)
    -- =====================
    function Window:CreateTab(name, icon)
        local Tab = {}

        local tabBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = SelectedTheme.TabBackground,
            Text = "",
            AutoButtonColor = false,
            BorderSizePixel = 0,
            Parent = tabList,
        })
        round(tabBtn, 8)

        local tabIconImg = create("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 9, 0.5, -8),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = tabBtn,
        })
        local hasIcon = applyIcon(tabIconImg, icon, 48)
        local labelOffset = hasIcon and 30 or 12

        local tabLabel = create("TextLabel", {
            Size = UDim2.new(1, -labelOffset - 4, 1, 0),
            Position = UDim2.new(0, labelOffset, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = SelectedTheme.SubTextColor,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn,
        })

        local tabPage = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = SelectedTheme.Accent,
            BorderSizePixel = 0,
            Visible = false,
            Parent = contentArea,
        })
        local pageLayout = create("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabPage,
        })

        local orderCounter = 0
        local function nextOrder()
            orderCounter = orderCounter + 1
            return orderCounter
        end

        create("UIPadding", {
            PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 14), PaddingBottom = UDim.new(0, 10),
            Parent = tabPage,
        })
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
        end)

        local function selectTab()
            for _, t in ipairs(Window._tabs) do
                t.page.Visible = false
                t.btn.BackgroundColor3 = SelectedTheme.TabBackground
                t.label.TextColor3 = SelectedTheme.SubTextColor
            end
            tabPage.Visible = true
            tabBtn.BackgroundColor3 = SelectedTheme.TabSelected
            tabLabel.TextColor3 = Color3.new(1, 1, 1)
        end

        tabBtn.MouseButton1Click:Connect(selectTab)
        tabBtn.MouseEnter:Connect(function()
            if not tabPage.Visible then tween(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = SelectedTheme.ElementHover}) end
        end)
        tabBtn.MouseLeave:Connect(function()
            if not tabPage.Visible then tween(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = SelectedTheme.TabBackground}) end
        end)

        table.insert(Window._tabs, {btn = tabBtn, label = tabLabel, page = tabPage})

        if not firstTabSet then
            firstTabSet = true
            selectTab()
        end

        -- =====================
        -- CreateSection
        -- =====================
        function Tab:CreateSection(sectionName)
            local sec = create("Frame", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = nextOrder(), Parent = tabPage})
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = sectionName:upper(), TextColor3 = SelectedTheme.Accent,
                Font = Enum.Font.GothamBold, TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = sec,
            })
            local SectionValue = {}
            function SectionValue:Set(newName) lbl.Text = newName:upper() end
            return SectionValue
        end

        -- =====================
        -- CreateDivider
        -- =====================
        function Tab:CreateDivider()
            local div = create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = SelectedTheme.ElementStroke,
                BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
                Parent = tabPage,
            })
            local DividerValue = {}
            function DividerValue:Set(visible) div.Visible = visible end
            return DividerValue
        end

        -- =====================
        -- CreateLabel (real Lucide icon)
        -- =====================
        function Tab:CreateLabel(text, icon2, color)
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = SelectedTheme.ElementBackground,
                Text = "",
                TextColor3 = color or SelectedTheme.TextColor,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
                Parent = tabPage,
            })
            round(lbl, 6)

            local iconImg = create("ImageLabel", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, 8, 0.5, -7),
                BackgroundTransparency = 1,
                Visible = false,
                Parent = lbl,
            })
            local hasIco = applyIcon(iconImg, icon2, 48)

            local textLbl = create("TextLabel", {
                Size = hasIco and UDim2.new(1, -28, 1, 0) or UDim2.new(1, -16, 1, 0),
                Position = hasIco and UDim2.new(0, 26, 0, 0) or UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = color or SelectedTheme.TextColor,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = lbl,
            })

            local LabelValue = {}
            function LabelValue:Set(newText, newIcon, newColor)
                textLbl.Text = newText
                if newColor then textLbl.TextColor3 = newColor end
                if newIcon then
                    local has = applyIcon(iconImg, newIcon, 48)
                    textLbl.Size = has and UDim2.new(1, -28, 1, 0) or UDim2.new(1, -16, 1, 0)
                    textLbl.Position = has and UDim2.new(0, 26, 0, 0) or UDim2.new(0, 8, 0, 0)
                end
            end
            return LabelValue
        end

        -- =====================
        -- CreateParagraph
        -- =====================
        function Tab:CreateParagraph(opts)
            opts = opts or {}
            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = SelectedTheme.ElementBackground,
                BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
                Parent = tabPage,
            })
            round(frame, 8)
            stroke(frame, SelectedTheme.ElementStroke)

            local titleL = create("TextLabel", {
                Size = UDim2.new(1, -16, 0, 18), Position = UDim2.new(0, 8, 0, 6),
                BackgroundTransparency = 1, Text = opts.Title or "Title",
                TextColor3 = SelectedTheme.TextColor, Font = Enum.Font.GothamBold,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame,
            })
            local content = create("TextLabel", {
                Size = UDim2.new(1, -16, 0, 32), Position = UDim2.new(0, 8, 0, 24),
                BackgroundTransparency = 1, Text = opts.Content or "",
                TextColor3 = SelectedTheme.SubTextColor, Font = Enum.Font.Gotham,
                TextSize = 11, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
                Parent = frame,
            })

            local ParagraphValue = {}
            function ParagraphValue:Set(newOpts)
                titleL.Text = newOpts.Title or ""
                content.Text = newOpts.Content or ""
            end
            return ParagraphValue
        end

        -- =====================
        -- CreateButton (real Lucide icon)
        -- =====================
        function Tab:CreateButton(opts)
            opts = opts or {}
            local btn = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = SelectedTheme.ElementBackground,
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
                Parent = tabPage,
            })
            round(btn, 8)
            stroke(btn, SelectedTheme.ElementStroke)

            local iconImg = create("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 10, 0.5, -8),
                BackgroundTransparency = 1,
                Visible = false,
                Parent = btn,
            })
            local hasIco = applyIcon(iconImg, opts.Icon, 48)

            local label = create("TextLabel", {
                Size = hasIco and UDim2.new(1, -36, 1, 0) or UDim2.new(1, -16, 1, 0),
                Position = hasIco and UDim2.new(0, 32, 0, 0) or UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = opts.Name or "Button",
                TextColor3 = SelectedTheme.TextColor,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = btn,
            })

            btn.MouseEnter:Connect(function() tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = SelectedTheme.ElementHover}) end)
            btn.MouseLeave:Connect(function() tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = SelectedTheme.ElementBackground}) end)

            btn.MouseButton1Click:Connect(function()
                local ok, err = safeCall(opts.Callback)
                if not ok then
                    local orig = label.Text
                    label.Text = "Callback Error"
                    tween(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)})
                    task.wait(0.6)
                    label.Text = orig
                    tween(btn, TweenInfo.new(0.2), {BackgroundColor3 = SelectedTheme.ElementBackground})
                end
            end)

            local ButtonValue = {}
            function ButtonValue:Set(newName) label.Text = newName end
            return ButtonValue
        end

        -- =====================
        -- CreateToggle
        -- =====================
        function Tab:CreateToggle(opts)
            opts = opts or {}
            local state = opts.CurrentValue or false

            local frame = create("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = SelectedTheme.ElementBackground, BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = tabPage})
            round(frame, 8); stroke(frame, SelectedTheme.ElementStroke)

            local iconImg = create("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 10, 0.5, -8),
                BackgroundTransparency = 1,
                Visible = false,
                Parent = frame,
            })
            local hasIco = applyIcon(iconImg, opts.Icon, 48)

            create("TextLabel", {
                Size = hasIco and UDim2.new(1, -84, 1, 0) or UDim2.new(1, -60, 1, 0),
                Position = hasIco and UDim2.new(0, 32, 0, 0) or UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, Text = opts.Name or "Toggle",
                TextColor3 = SelectedTheme.TextColor, Font = Enum.Font.Gotham,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame,
            })

            local switchBg = create("Frame", {
                Size = UDim2.new(0, 38, 0, 18), Position = UDim2.new(1, -48, 0.5, -9),
                BackgroundColor3 = state and SelectedTheme.ToggleOn or SelectedTheme.ToggleOff,
                BorderSizePixel = 0, Parent = frame,
            })
            round(switchBg, 9)

            local knob = create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = switchBg,
            })
            round(knob, 7)

            local interact = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = frame})

            local ToggleValue = {CurrentValue = state}
            local function applyVisual(v)
                tween(switchBg, QUICK, {BackgroundColor3 = v and SelectedTheme.ToggleOn or SelectedTheme.ToggleOff})
                tween(knob, QUICK, {Position = v and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
            end

            interact.MouseButton1Click:Connect(function()
                ToggleValue.CurrentValue = not ToggleValue.CurrentValue
                applyVisual(ToggleValue.CurrentValue)
                safeCall(opts.Callback, ToggleValue.CurrentValue)
            end)

            function ToggleValue:Set(v)
                ToggleValue.CurrentValue = v
                applyVisual(v)
                safeCall(opts.Callback, v)
            end

            if opts.Flag then NriculLib.Flags[opts.Flag] = ToggleValue end
            return ToggleValue
        end

        -- =====================
        -- CreateSlider
        -- =====================
        function Tab:CreateSlider(opts)
            opts = opts or {}
            local range = opts.Range or {0, 100}
            local increment = opts.Increment or 1
            local current = opts.CurrentValue or range[1]

            local frame = create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = SelectedTheme.ElementBackground, BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = tabPage})
            round(frame, 8); stroke(frame, SelectedTheme.ElementStroke)

            create("TextLabel", {
                Size = UDim2.new(1, -16, 0, 20), Position = UDim2.new(0, 12, 0, 4),
                BackgroundTransparency = 1, Text = opts.Name or "Slider",
                TextColor3 = SelectedTheme.TextColor, Font = Enum.Font.Gotham,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame,
            })

            local valueLabel = create("TextLabel", {
                Size = UDim2.new(0, 100, 0, 20), Position = UDim2.new(1, -112, 0, 4),
                BackgroundTransparency = 1, Text = tostring(current) .. " " .. (opts.Suffix or ""),
                TextColor3 = SelectedTheme.SubTextColor, Font = Enum.Font.Gotham,
                TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, Parent = frame,
            })

            local track = create("Frame", {Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 1, -16), BackgroundColor3 = SelectedTheme.InputBackground, BorderSizePixel = 0, Parent = frame})
            round(track, 3)

            local fillFrac = (current - range[1]) / (range[2] - range[1])
            local fill = create("Frame", {Size = UDim2.new(math.clamp(fillFrac, 0, 1), 0, 1, 0), BackgroundColor3 = SelectedTheme.Accent, BorderSizePixel = 0, Parent = track})
            round(fill, 3)

            local SliderValue = {CurrentValue = current}
            local dragging2 = false

            local function setFromX(xPos)
                local rel = math.clamp((xPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local raw = range[1] + rel * (range[2] - range[1])
                raw = math.floor(raw / increment + 0.5) * increment
                raw = math.clamp(raw, range[1], range[2])
                if raw ~= SliderValue.CurrentValue then
                    SliderValue.CurrentValue = raw
                    fill.Size = UDim2.new((raw - range[1]) / (range[2] - range[1]), 0, 1, 0)
                    valueLabel.Text = tostring(raw) .. " " .. (opts.Suffix or "")
                    safeCall(opts.Callback, raw)
                end
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging2 = true
                    setFromX(input.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging2 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    setFromX(input.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging2 = false
                end
            end)

            function SliderValue:Set(v)
                v = math.clamp(v, range[1], range[2])
                SliderValue.CurrentValue = v
                fill.Size = UDim2.new((v - range[1]) / (range[2] - range[1]), 0, 1, 0)
                valueLabel.Text = tostring(v) .. " " .. (opts.Suffix or "")
                safeCall(opts.Callback, v)
            end

            if opts.Flag then NriculLib.Flags[opts.Flag] = SliderValue end
            return SliderValue
        end

        -- =====================
        -- CreateInput
        -- =====================
        function Tab:CreateInput(opts)
            opts = opts or {}
            local frame = create("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = SelectedTheme.ElementBackground, BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = tabPage})
            round(frame, 8); stroke(frame, SelectedTheme.ElementStroke)

            create("TextLabel", {
                Size = UDim2.new(0.42, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, Text = opts.Name or "Input",
                TextColor3 = SelectedTheme.TextColor, Font = Enum.Font.Gotham,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame,
            })

            local box = create("TextBox", {
                Size = UDim2.new(0.52, 0, 0, 26), Position = UDim2.new(0.46, 0, 0.5, -13),
                BackgroundColor3 = SelectedTheme.InputBackground, Text = opts.CurrentValue or "",
                PlaceholderText = opts.PlaceholderText or "", TextColor3 = SelectedTheme.TextColor,
                PlaceholderColor3 = SelectedTheme.SubTextColor, Font = Enum.Font.Gotham,
                TextSize = 11, ClearTextOnFocus = false, BorderSizePixel = 0, Parent = frame,
            })
            round(box, 6); stroke(box, SelectedTheme.ElementStroke)

            local InputValue = {CurrentValue = opts.CurrentValue or ""}
            box.FocusLost:Connect(function()
                InputValue.CurrentValue = box.Text
                safeCall(opts.Callback, box.Text)
                if opts.RemoveTextAfterFocusLost then box.Text = "" end
            end)

            function InputValue:Set(text)
                box.Text = text
                InputValue.CurrentValue = text
                safeCall(opts.Callback, text)
            end

            if opts.Flag then NriculLib.Flags[opts.Flag] = InputValue end
            return InputValue
        end

        -- =====================
        -- CreateDropdown
        -- =====================
        function Tab:CreateDropdown(opts)
            opts = opts or {}
            local options = opts.Options or {}
            local multi = opts.MultipleOptions or false
            local current = opts.CurrentOption
            if typeof(current) == "string" then current = {current} end
            current = current or {}

            local frame = create("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = SelectedTheme.ElementBackground, BorderSizePixel = 0, ClipsDescendants = false, LayoutOrder = nextOrder(), Parent = tabPage})
            round(frame, 8); stroke(frame, SelectedTheme.ElementStroke)

            create("TextLabel", {
                Size = UDim2.new(0.42, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, Text = opts.Name or "Dropdown",
                TextColor3 = SelectedTheme.TextColor, Font = Enum.Font.Gotham,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame,
            })

            local selectedLabel = current[1] or "None"
            local valBtn = create("TextButton", {
                Size = UDim2.new(0.46, 0, 0, 26), Position = UDim2.new(0.52, 0, 0.5, -13),
                BackgroundColor3 = SelectedTheme.InputBackground, Text = selectedLabel .. "  v",
                TextColor3 = SelectedTheme.Accent, Font = Enum.Font.GothamBold, TextSize = 11,
                AutoButtonColor = false, BorderSizePixel = 0, Parent = frame,
            })
            round(valBtn, 6); stroke(valBtn, SelectedTheme.ElementStroke)

            local listPanel = create("Frame", {Size = UDim2.new(0, 160, 0, 0), BackgroundColor3 = SelectedTheme.ElementBackground, BorderSizePixel = 0, Visible = false, ZIndex = 100, Parent = screenGui})
            round(listPanel, 8); stroke(listPanel, SelectedTheme.ElementStroke)

            local listScroll = create("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 2, BorderSizePixel = 0, ZIndex = 100, Parent = listPanel})
            create("UIListLayout", {Parent = listScroll})

            local DropdownValue = {CurrentOption = current, Options = options}
            local optionButtons = {}

            local function refreshSelectedLabel()
                if multi then
                    if #DropdownValue.CurrentOption == 0 then valBtn.Text = "None  v"
                    elseif #DropdownValue.CurrentOption == 1 then valBtn.Text = DropdownValue.CurrentOption[1] .. "  v"
                    else valBtn.Text = "Various  v" end
                else
                    valBtn.Text = (DropdownValue.CurrentOption[1] or "None") .. "  v"
                end
            end

            local function buildOptions()
                for _, b in ipairs(optionButtons) do b:Destroy() end
                optionButtons = {}
                for _, opt in ipairs(DropdownValue.Options) do
                    local ob = create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = table.find(DropdownValue.CurrentOption, opt) and SelectedTheme.Accent or SelectedTheme.ElementBackground,
                        Text = "  " .. opt, TextColor3 = SelectedTheme.TextColor, Font = Enum.Font.Gotham,
                        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                        AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 101, Parent = listScroll,
                    })
                    ob.MouseButton1Click:Connect(function()
                        if multi then
                            local idx = table.find(DropdownValue.CurrentOption, opt)
                            if idx then
                                table.remove(DropdownValue.CurrentOption, idx)
                                ob.BackgroundColor3 = SelectedTheme.ElementBackground
                            else
                                table.insert(DropdownValue.CurrentOption, opt)
                                ob.BackgroundColor3 = SelectedTheme.Accent
                            end
                        else
                            DropdownValue.CurrentOption = {opt}
                            for _, other in ipairs(optionButtons) do other.BackgroundColor3 = SelectedTheme.ElementBackground end
                            ob.BackgroundColor3 = SelectedTheme.Accent
                            listPanel.Visible = false
                        end
                        refreshSelectedLabel()
                        safeCall(opts.Callback, DropdownValue.CurrentOption)
                    end)
                    table.insert(optionButtons, ob)
                end
                listPanel.Size = UDim2.new(0, 160, 0, math.min(#DropdownValue.Options * 28, 180))
            end

            buildOptions()
            refreshSelectedLabel()

            valBtn.MouseButton1Click:Connect(function()
                listPanel.Visible = not listPanel.Visible
                if listPanel.Visible then
                    local abs = valBtn.AbsolutePosition
                    local sz  = valBtn.AbsoluteSize
                    listPanel.Position = UDim2.new(0, abs.X, 0, abs.Y + sz.Y + 4)
                end
            end)

            function DropdownValue:Set(newOption)
                if typeof(newOption) == "string" then newOption = {newOption} end
                DropdownValue.CurrentOption = newOption
                refreshSelectedLabel()
                buildOptions()
                safeCall(opts.Callback, newOption)
            end

            function DropdownValue:Refresh(newOptions)
                DropdownValue.Options = newOptions
                buildOptions()
            end

            if opts.Flag then NriculLib.Flags[opts.Flag] = DropdownValue end
            return DropdownValue
        end

        -- =====================
        -- CreateColorPicker
        -- =====================
        function Tab:CreateColorPicker(opts)
            opts = opts or {}
            local color = opts.Color or Color3.new(1, 1, 1)

            local frame = create("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = SelectedTheme.ElementBackground, BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = tabPage})
            round(frame, 8); stroke(frame, SelectedTheme.ElementStroke)

            create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, Text = opts.Name or "Color Picker",
                TextColor3 = SelectedTheme.TextColor, Font = Enum.Font.Gotham,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame,
            })

            local swatch = create("TextButton", {
                Size = UDim2.new(0, 36, 0, 22), Position = UDim2.new(1, -48, 0.5, -11),
                BackgroundColor3 = color, Text = "", AutoButtonColor = false, BorderSizePixel = 0, Parent = frame,
            })
            round(swatch, 6); stroke(swatch, SelectedTheme.ElementStroke)

            local panel = create("Frame", {Size = UDim2.new(0, 200, 0, 140), BackgroundColor3 = SelectedTheme.ElementBackground, BorderSizePixel = 0, Visible = false, ZIndex = 100, Parent = screenGui})
            round(panel, 8); stroke(panel, SelectedTheme.ElementStroke)

            local preview = create("Frame", {Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0, 10, 0, 10), BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 101, Parent = panel})
            round(preview, 6)

            local ColorValue = {Color = color}

            local function makeRGBRow(labelText, yPos, channel)
                local row = create("Frame", {Size = UDim2.new(1, -20, 0, 24), Position = UDim2.new(0, 10, 0, yPos), BackgroundTransparency = 1, ZIndex = 101, Parent = panel})
                create("TextLabel", {Size = UDim2.new(0, 20, 1, 0), BackgroundTransparency = 1, Text = labelText, TextColor3 = SelectedTheme.SubTextColor, Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 102, Parent = row})
                local box = create("TextBox", {
                    Size = UDim2.new(1, -26, 1, 0), Position = UDim2.new(0, 26, 0, 0),
                    BackgroundColor3 = SelectedTheme.InputBackground, Text = tostring(math.floor(channel * 255)),
                    TextColor3 = SelectedTheme.TextColor, Font = Enum.Font.Gotham, TextSize = 11, BorderSizePixel = 0, ZIndex = 102, Parent = row,
                })
                round(box, 4)
                return box
            end

            local rBox = makeRGBRow("R", 58, color.R)
            local gBox = makeRGBRow("G", 86, color.G)
            local bBox = makeRGBRow("B", 114, color.B)

            local function applyFromBoxes()
                local rv = tonumber(rBox.Text) or 255
                local gv = tonumber(gBox.Text) or 255
                local bv = tonumber(bBox.Text) or 255
                local newColor = Color3.fromRGB(rv, gv, bv)
                ColorValue.Color = newColor
                preview.BackgroundColor3 = newColor
                swatch.BackgroundColor3 = newColor
                safeCall(opts.Callback, newColor)
            end

            rBox.FocusLost:Connect(applyFromBoxes)
            gBox.FocusLost:Connect(applyFromBoxes)
            bBox.FocusLost:Connect(applyFromBoxes)

            swatch.MouseButton1Click:Connect(function()
                panel.Visible = not panel.Visible
                if panel.Visible then
                    local abs = swatch.AbsolutePosition
                    panel.Position = UDim2.new(0, abs.X - 160, 0, abs.Y + 30)
                end
            end)

            function ColorValue:Set(newColor)
                ColorValue.Color = newColor
                preview.BackgroundColor3 = newColor
                swatch.BackgroundColor3 = newColor
                rBox.Text = tostring(math.floor(newColor.R * 255))
                gBox.Text = tostring(math.floor(newColor.G * 255))
                bBox.Text = tostring(math.floor(newColor.B * 255))
                safeCall(opts.Callback, newColor)
            end

            if opts.Flag then NriculLib.Flags[opts.Flag] = ColorValue end
            return ColorValue
        end

        -- =====================
        -- CreateKeybind
        -- =====================
        function Tab:CreateKeybind(opts)
            opts = opts or {}
            local currentKey = opts.CurrentKeybind or "None"
            local listening = false

            local frame = create("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = SelectedTheme.ElementBackground, BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = tabPage})
            round(frame, 8); stroke(frame, SelectedTheme.ElementStroke)

            create("TextLabel", {
                Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, Text = opts.Name or "Keybind",
                TextColor3 = SelectedTheme.TextColor, Font = Enum.Font.Gotham,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame,
            })

            local keyBtn = create("TextButton", {
                Size = UDim2.new(0, 80, 0, 24), Position = UDim2.new(1, -92, 0.5, -12),
                BackgroundColor3 = SelectedTheme.InputBackground, Text = currentKey,
                TextColor3 = SelectedTheme.Accent, Font = Enum.Font.GothamBold, TextSize = 11,
                AutoButtonColor = false, BorderSizePixel = 0, Parent = frame,
            })
            round(keyBtn, 6); stroke(keyBtn, SelectedTheme.ElementStroke)

            local KeybindValue = {CurrentKeybind = currentKey}
            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
            end)

            local conn = UserInputService.InputBegan:Connect(function(input, gpe)
                if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
                    listening = false
                    local name = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                    KeybindValue.CurrentKeybind = name
                    keyBtn.Text = name
                    safeCall(opts.Callback, name)
                elseif not listening and not gpe and KeybindValue.CurrentKeybind ~= "None" then
                    local kc = Enum.KeyCode[KeybindValue.CurrentKeybind]
                    if kc and input.KeyCode == kc and not opts.HoldToInteract then
                        safeCall(opts.Callback, true)
                    end
                end
            end)
            table.insert(Window._connections, conn)

            function KeybindValue:Set(newKey)
                KeybindValue.CurrentKeybind = newKey
                keyBtn.Text = newKey
                safeCall(opts.Callback, newKey)
            end

            if opts.Flag then NriculLib.Flags[opts.Flag] = KeybindValue end
            return KeybindValue
        end

        -- =====================
        -- CreatePreview
        -- Drops one example of every element type with labels
        -- =====================
        function Tab:CreatePreview()
            Tab:CreateSection("Element Preview")
            Tab:CreateLabel("This is a Label", "info")
            Tab:CreateParagraph({
                Title = "This is a Paragraph",
                Content = "Paragraphs are good for longer descriptions or instructions.",
            })
            Tab:CreateDivider()
            Tab:CreateButton({Name = "This is a Button", Icon = "star", Callback = function() end})
            Tab:CreateToggle({Name = "This is a Toggle", CurrentValue = false, Flag = "PreviewToggle_" .. tostring(math.random(1, 99999)), Callback = function() end})
            Tab:CreateSlider({Name = "This is a Slider", Range = {0, 100}, Increment = 1, Suffix = "units", CurrentValue = 50, Flag = "PreviewSlider_" .. tostring(math.random(1, 99999)), Callback = function() end})
            Tab:CreateInput({Name = "This is an Input", CurrentValue = "", PlaceholderText = "Type here...", Flag = "PreviewInput_" .. tostring(math.random(1, 99999)), Callback = function() end})
            Tab:CreateDropdown({Name = "This is a Dropdown", Options = {"Option A", "Option B", "Option C"}, CurrentOption = {"Option A"}, MultipleOptions = false, Flag = "PreviewDropdown_" .. tostring(math.random(1, 99999)), Callback = function() end})
            Tab:CreateColorPicker({Name = "This is a Color Picker", Color = Color3.fromRGB(120, 150, 255), Flag = "PreviewColorPicker_" .. tostring(math.random(1, 99999)), Callback = function() end})
            Tab:CreateKeybind({Name = "This is a Keybind", CurrentKeybind = "None", HoldToInteract = false, Flag = "PreviewKeybind_" .. tostring(math.random(1, 99999)), Callback = function() end})
            Tab:CreateDivider()
            Tab:CreateLabel("That's every element type!", "check")
        end

        return Tab
    end

    function Window:SetTheme(themeName)
        if NriculLib.Theme[themeName] then
            SelectedTheme = NriculLib.Theme[themeName]
        end
    end

    function Window:Destroy()
        screenGui:Destroy()
    end

    return Window
end

return NriculLib

-- subscribe!
print("nricullib")
