# Changelog (Latest: Version 1 Build 3)

### VERSION 1 BUILD 1
1. Improved the indentation of the script at a lot of places.
2. Improved the ranking system and changed it to utilize array.
3. Improved the class system and changed them to utilize arrays as well. Both, Human and Zombie teams use different arrays.
4. Added a new user saving system.
5. Added a new map system.
6. Removed /updates since all the change log will be found at the GitHub.
7. Updated several commands by optimizing or re-writing them.
8. The code looks a lot more cleaner.
9. Removed the play time saving method which used three different variables.
10. Optimized the script at lots of places
11. General function changes:
- GetAdminName renamed to GetAdminRank and updated it.
- Improved the GetClosestPlayer function.
- Re-written OnPlayerDeath.

### VERSION 1 BUILD 2
12. Added a new ban system (fairly basic and only bans username for now)
13. General function changes:
- Renamed CheckAccount to CheckPlayerAccount.
- Renamed SaveAccount to SavePlayerAccount.
- Rewritten killsteak function and added CheckPlayerKillStreak.
- Improvised OnPlayerText function.
- Added GetPlayerNameEx, which fetches the player name once upon connection and stores it in the array.
- Revised the OnPlayerConnect function and improvised the vending machine removal code.
- Revised the random message code a little bit.
- Added KickPlayer.
14. Optimized the script at lots of other places.
15. More indentation fixes.

#### VERSION 1 BUILD 2 (patch 1)
16. More code clean up.
17. Renamed some variables.
18. Optimized VIP labels code.
19. General function changes:
- Removed the two admin message function and added a new one.
20. Fixed a mistake in headshot system code!

#### VERSION 1 BUILD 2 (patch 2)
21. Command changes:
- Removed /unblockpm and /blockpm and added /dnd.
- Updated /maps.

### VERSION 1 BUILD 3
22. Heavily optimised and organised OnPlayerKeyStateChange function.
23. Modified GivePlayerXP function

### VERSION 1 BUILD 4
24. Added new terrorist bomb system
25. Added new doctor shield system
26. Patched an issue with terrorist bomb system
27. Added an array that stores the map name, can be useful for '/maps' command.
