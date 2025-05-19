--[[
Stamina System for Roblox
Author: Vain_ie

--- HOW TO IMPLEMENT ---
1. Copy this script into a Script object in ServerScriptService in your Roblox game.
2. The system will automatically track stamina for all players.
3. To decrease stamina (e.g., when a player sprints or jumps), call:
   DecreaseStamina(player, amount)
4. To regenerate stamina (e.g., when a player is resting), call:
   RegenerateStamina(player, regenRate, duration)
5. To set stamina multipliers (e.g., for buffs/debuffs), call:
   SetStaminaMultiplier(player, multiplier)
6. To get a player's current stamina, use:
   GetPlayerStamina(player)
7. To fully restore a player's stamina, use:
   RestoreStamina(player)
8. For admin controls, use AdminSetStamina(adminPlayer, stamina)

--- END OF TUTORIAL ---

Credits: System created by Vain_ie
]]

-- Stamina System for Roblox
-- This script manages player stamina, including decay, regeneration, multipliers, and admin controls.

-- Get the Players service to access all players in the game
local Players = game:GetService("Players")

-- Maximum value for stamina
local STAMINA_MAX = 100
-- How much stamina decreases every interval (passive decay, optional)
local STAMINA_DECAY = 0 -- Set to 0 for no passive decay
-- How often (in seconds) stamina decreases (if passive decay is used)
local DECAY_INTERVAL = 1 -- Seconds

-- Table to store each player's stamina
local playerStamina = {}

-- Function to initialize a player's stamina when they join or respawn
local function initStamina(player)
    playerStamina[player.UserId] = {
        Stamina = STAMINA_MAX -- Start with full stamina
    }
end

-- Function to decrease a player's stamina (e.g., when sprinting or jumping)
function DecreaseStamina(player, amount)
    local stats = playerStamina[player.UserId]
    if stats then
        stats.Stamina = math.max(0, stats.Stamina - amount)
    end
end

-- Function to regenerate stamina for a player (e.g., when resting)
-- regenRate: how much stamina to restore per second
-- duration: how many seconds to regenerate for
function RegenerateStamina(player, regenRate, duration)
    local stats = playerStamina[player.UserId]
    if not stats then return end
    local regenTime = 0
    while regenTime < duration do
        stats.Stamina = math.min(STAMINA_MAX, stats.Stamina + regenRate)
        regenTime = regenTime + 1
        wait(1)
    end
end

-- Store multipliers for each player (for buffs/debuffs)
local staminaMultipliers = {}
-- Set a player's stamina decay multiplier
function SetStaminaMultiplier(player, multiplier)
    staminaMultipliers[player.UserId] = multiplier or 1
end
-- Get a player's current multiplier (default to 1 if not set)
function GetStaminaMultiplier(player)
    return staminaMultipliers[player.UserId] or 1
end

-- Main function: decrease stamina for all players over time (if passive decay is used)
local function decayStamina()
    while true do
        for _, player in ipairs(Players:GetPlayers()) do
            local stats = playerStamina[player.UserId]
            local mult = GetStaminaMultiplier(player)
            if stats then
                stats.Stamina = math.max(0, stats.Stamina - STAMINA_DECAY * mult)
                -- If stamina is low (but not zero), notify the player
                if stats.Stamina <= 20 and stats.Stamina > 0 then
                    notifyLowStamina(player)
                end
                -- If stamina is zero, you can add effects here (e.g., slow the player)
            end
        end
        wait(DECAY_INTERVAL)
    end
end

-- When a player joins, initialize their stamina and reset on respawn
Players.PlayerAdded:Connect(function(player)
    initStamina(player)
    player.CharacterAdded:Connect(function()
        initStamina(player)
    end)
end)

-- When a player leaves, remove their stamina from the table
Players.PlayerRemoving:Connect(function(player)
    playerStamina[player.UserId] = nil
end)

-- Function to get a player's current stamina
function GetPlayerStamina(player)
    local stats = playerStamina[player.UserId]
    if stats then
        return stats.Stamina
    end
    return nil
end

-- Function to set a player's stamina directly (with clamping)
function SetPlayerStamina(player, stamina)
    local stats = playerStamina[player.UserId]
    if stats then
        stats.Stamina = math.clamp(stamina, 0, STAMINA_MAX)
    end
end

-- Function to notify a player when their stamina is low
-- You can replace this with a UI notification or sound for the player
function notifyLowStamina(player)
    print(player.Name .. "'s Stamina is low!")
end

-- Function to fully restore a player's stamina (e.g., for admin or respawn)
function RestoreStamina(player)
    SetPlayerStamina(player, STAMINA_MAX)
end

-- Example admin command to set all player stamina
-- Only works for a specific admin UserId (replace 123456 with your own)
function AdminSetStamina(player, stamina)
    if player and player.UserId == 123456 then -- Replace with your admin UserId
        for _, p in ipairs(Players:GetPlayers()) do
            SetPlayerStamina(p, stamina)
        end
    end
end

-- Start the stamina decay loop in the background (if passive decay is used)
if STAMINA_DECAY > 0 then
    spawn(decayStamina)
end
