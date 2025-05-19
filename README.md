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
