/*
	Zombieland ~ Version 1 Build 5
	
	Mode: Game mode/ TDM/ Zombie TDM/ Survival
	Project type: Edit
	
	Authors: Erwin (formerly, Sjutel), Kitten, Logic_, Private200 and others who contributed to this amazing project!
*/

#include	<a_samp>

#undef		MAX_PLAYERS
#define		MAX_PLAYERS					50 // Please modify it according to the slots in your server!

#include	<sscanf2>
#include	<foreach>
#include	<izcmd>
#include	<streamer>

/*
	Definitions
*/
#define		DB_PATH						"ZL/data.db" // The directory (path) of the database
#define		NAME						"Zombieland (0.3.7)"
#define		SITE						"samp-zombieland.info"
#define		chat						"{FFFFFF}»"

#define		function%0(%1)				\
			forward %0(%1);\
			public %0(%1)

#define		NON_IMMUNE					311
#define		MAX_MAPTIME					250
#define		MAX_RESTART_TIME			10000
#define		MAX_MAPUPDATE_TIME			1450
#define		MAX_SHOW_CP_TIME			1000
#define		MAX_END_TIME				60000
#define		MAX_BALANCERUPDATE_TIME		6000
#define		TIME						180000
#define		MAX_MAPS					30
#define		MAX_BOMBS					20
#define		MAX_SHIELDS					10

#define		PRESSED(%0)					\
			(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define		GetAdminRankName(%0)		\
			gAdminRanks[pInfo[%0][pAdminLevel]]

#define		KickPlayer(%0)				\
			SetTimerEx("KickTimer", 1000, false, "i", %0)

#define		GetPlayerNameEx(%0)			\
			pInfo[%0][pName]

#define		GivePlayerXP(%0,%1)			\
			pInfo[%0][pXP] += %1

#define		NotifyPlayer(%0,%1)			\
			GameTextForPlayer(%0, %1, 3000, 3)

#define		MAX_PASSWORD_LEN			65
#define		PASSWORD_SALT				"xxxtentacion" // anyways, you should use per-player salts

#define		MAX_REASON_LEN				20 // Maximum ban reason length
#define		MAX_MAP_NAME_LEN			30 // Maximum map name

#define		TABLE_BANS					"`Bans`"
#define		FIELD_BAN_ID				"`ID`"
#define		FIELD_BANNAME				"`Name`"
#define		FIELD_BANREASON				"`Reason`"

#define 	TABLE_USERS					"`Users`"
#define		FIELD_ID					"`ID`"
#define		FIELD_NAME					"`Name`"
#define		FIELD_PASSWORD				"`Password`"
#define		FIELD_IP					"`IP`"
#define		FIELD_CASH					"`Cash`"
#define		FIELD_XP					"`XP`"
#define		FIELD_KILLS					"`Kills`"
#define		FIELD_DEATHS				"`Deaths`"
#define		FIELD_HEADS					"`Heads`"
#define		FIELD_EVAC					"`Evac`"
#define		FIELD_RANK					"`Rank`"
#define		FIELD_ADMIN					"`Admin`"
#define		FIELD_VIP					"`VIP`"
#define		FIELD_TIME					"`Time`"
#define		FIELD_MAPS					"`Maps`"
#define		FIELD_COINS					"`Coins`"
#define		FIELD_KICKBACK				"`Kickback`" // New additions in Build 4
#define		FIELD_DMGDEAGLE				"`DamageDeagle`" // New additions in Build 4
#define		FIELD_DMGSHOTGUN			"`DamageShotgun`" // New additions in Build 4
#define		FIELD_DMGMP5				"`DamageMP5`" // New additions in Build 4

#define		TABLE_MAPS					"`Maps`"
#define		FIELD_MAP_ID				"ID"
#define		FIELD_MAP_FS_NAME			"FS"
#define		FIELD_MAP_NAME				"Name"
#define		FIELD_MAP_HUMAN_SPAWN_X		"Human_Spawn_X"
#define		FIELD_MAP_HUMAN_SPAWN_Y		"Human_Spawn_Y"
#define		FIELD_MAP_HUMAN_SPAWN_Z		"Human_Spawn_Z"
#define		FIELD_MAP_HUMAN_SPAWN2_X	"Human_Spawn2_X"
#define		FIELD_MAP_HUMAN_SPAWN2_Y	"Human_Spawn2_Y"
#define		FIELD_MAP_HUMAN_SPAWN2_Z	"Human_Spawn2_Z"
#define		FIELD_MAP_ZOMBIE_SPAWN_X	"Zombie_Spawn_X"
#define		FIELD_MAP_ZOMBIE_SPAWN_Y	"Zombie_Spawn_Y"
#define		FIELD_MAP_ZOMBIE_SPAWN_Z	"Zombie_Spawn_Z"
#define		FIELD_MAP_INTERIOR			"Interior"
#define		FIELD_MAP_GATE_X			"Gate_X"
#define		FIELD_MAP_GATE_Y			"Gate_Y"
#define		FIELD_MAP_GATE_Z			"Gate_Z"
#define		FIELD_MAP_GATE2_X			"Gate2_X"
#define		FIELD_MAP_GATE2_Y			"Gate2_Y"
#define		FIELD_MAP_GATE2_Z			"Gate2_Z"
#define		FIELD_MAP_CP_X				"CP_X"
#define		FIELD_MAP_CP_Y				"CP_Y"
#define		FIELD_MAP_CP_Z				"CP_Z"
#define		FIELD_MAP_MOVE_GATE			"Move_Gate"
#define		FIELD_MAP_GATE_ID			"Gate_ID"
#define		FIELD_MAP_WATER				"Water"
#define		FIELD_MAP_EVAC_TYPE			"Evac_Type"
#define		FIELD_MAP_WEATHER			"Weather"
#define		FIELD_MAP_TIME				"Time"

#define		PLAYER_MUTE_TIME_MINUTES	(2)

#define		BODY_PART_HEAD				9

/*
	Teams
*/

enum {
	TEAM_ZOMBIE = 0,
	TEAM_HUMAN
};

/*
	Dialogs
*/

enum
{
	DIALOG_REGISTER = 1,
	DIALOG_LOGIN,
	DIALOG_RADIO,
	DIALOG_KICK,
	DIALOG_TOP,
	DIALOG_WARN,
	DIALOG_BANNED,
	DIALOG_CMDS,
	DIALOG_HELP,
	DIALOG_HOWTOXP,
	DIALOG_ACMDS,
	DIALOG_RULES,
	DIALOG_CLASS_2,
	DIALOG_CLASS_3,
	DIALOG_ADMINS,
	DIALOG_VIPS,
	DIALOG_REPORT,
	DIALOG_REPORT_2,
	DIALOG_SHOUT,
	DIALOG_VIPINFO,
	DIALOG_VIP,
	DIALOG_VIP_CLASS,
	DIALOG_COINS,
	DIALOG_SKINS,
	DIALOG_COINS_TOYS,
	DIALOG_KICKN,
	DIALOG_VCMDS,
	DIALOG_MAPS,
	DIALOG_WEAPONS,
	DIALOG_WEAPONS_SHOP,
	DIALOG_ZOMBIE_CLASSES,
	DIALOG_PERKS,
	DIALOG_PASSWORD
};

/*
	Colors
*/
#define COLOR_PINK 0xFFC0CB77
#define COLOR_HUMAN 0x3366FF44
#define COLOR_ZOMBIE 0xFF003344
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_DARKRED 0x660000AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_BRIGHTRED 0xFF0000AA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_VIOLET 0x9955DEEE
#define COLOR_LIGHTRED 0xFF99AADD
#define COLOR_SEAGREEN 0x00EEADDF
#define COLOR_GRAYWHITE 0xEEEEFFC4
#define COLOR_LIGHTNEUTRALBLUE 0xabcdef66
#define COLOR_GREENISHGOLD 0xCCFFDD56
#define COLOR_LIGHTBLUEGREEN 0x0FFDD349
#define COLOR_NEUTRALBLUE 0xABCDEF01
#define COLOR_LIGHTCYAN 0xAAFFCC33
#define COLOR_LEMON 0xDDDD2357
#define COLOR_MEDIUMBLUE 0x63AFF00A
#define COLOR_NEUTRAL 0xABCDEF97
#define COLOR_BLACK 0x00000000
#define COLOR_NEUTRALGREEN 0x81CFAB00
#define COLOR_DARKGREEN 0x12900BBF
#define COLOR_LIGHTGREEN 0x24FF0AB9
#define COLOR_DARKBLUE 0x300FFAAB
#define COLOR_BLUEGREEN 0x46BBAA00
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_DARKRED 0x660000AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_PURPLE 0x800080AA
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_RED1 0xFF0000AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BROWN 0x993300AA
#define COLOR_CYAN 0x99FFFFAA
#define COLOR_TAN 0xFFFFCCAA
#define COLOR_KHAKI 0x999900AA
#define COLOR_LIME 0x99FF00AA
#define COLOR_SYSTEM 0xEFEFF7AA
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD6 0xF0F0F0FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD1 0xB4B5B7FF

#define COL_WHITE          "{FFFFFF}"
#define COL_GREY           "{C3C3C3}"
#define COL_GREEN          "{37DB45}"
#define COL_RED            "{F81414}"
#define COL_YELLOW         "{F3FF02}"
#define COL_ORANGE         "{F9B857}"
#define COL_BLUE           "{0049FF}"
#define COL_PINK           "{FF00EA}"
#define COL_LIGHTBLUE      "{00C0FF}"
#define COL_LGREEN         "{C9FFAB}"

/*
	Classes
*/

enum E_CLASS {
	E_CLASS_NAME[16],
	E_CLASS_SCORE
};

enum {
	CIVILIAN,
	MEDIC,
	TERRORIST,
	SNIPER,
	HEAVYSHOTGUN,
	ENGINEER,
	KICKBACK,
	SCOUT,
	DOCTOR,
	VIPENGINEER,
	VIPMEDIC,
	VIPSCOUT
};

new const gHumanClass[][E_CLASS] = {
	{"Civilian",		0},
	{"Medic",			6000},
	{"Terrorist",		37000},
	{"Sniper",			40000},
	{"Heavy Shotgun",	54000},
	{"Engineer",		79000},
	{"Kick Back",		100000},
	{"Scout",			225000},
	{"Doctor",			505000},
	{"VIP Engineer",	0},
	{"VIP Medic",		0},
	{"VIP Scout",		0}
};

enum {
	STANDARDZOMBIE,
	MUTATEDZOMBIE,
	HUNTERZOMBIE,
	STOMPERZOMBIE,
	WITCHZOMBIE,
	SMOKERZOMBIE,
	SCREAMERZOMBIE,
	SEEKER,
	FLESHEATER,
	ROGUE,
	BOOMERZOMBIE,
	TANKERZOMBIE
};

new const gZombieClass[][E_CLASS] = {
	
	{"Standard Zombie",	0},
	{"Mutated Zombie",	5000},
	{"Hunter Zombie",	10000},
	{"Stomper Zombie",	39000},
	{"Witch Zombie", 	55000},
	{"Smoker Zombie",	63000},
	{"Screamer Zombie",	78000},
	{"Seeker Zombie",	92000},
	{"Flesh Eater",		150000},
	{"Rogue Zombie",	186000},
	{"Boomer Zombie",	220000},
	{"Tanker Zombie",	330000}
};

/*
	Bomb and Shield
*/

enum E_BOMB {
	E_BOMB_OBJECT,
	E_BOMB_PLAYERID
};
new gBomb[MAX_BOMBS][E_BOMB];

enum E_SHIELD {
	E_SHIELD_PLAYERID,
	E_SHIELD_OBJECT
};
new gShields[MAX_SHIELDS][E_SHIELD];

/*
	Administrator Ranks
*/

new const gAdminRanks[][16] =  {
	"Player",
	"Trial Moderator",
	"Moderator",
	"Administrator",
	"Manager",
	"Owner"
};

/*
	Variables and Arrays
*/

new
	// Server related variables
	DB: gSQL,
	Text: gXPTD,
	gTime,
	gMap_Timer,
	gBalance_Timer,
	gMaps[MAX_MAPS],
	gMapNames[MAX_MAPS][MAX_MAP_NAME_LEN],
	gMapID,
	gPlayersCount,
	gGateObject,
	playersAliveCount,

	// Player related variables
	pASK_Timer[MAX_PLAYERS],
	Text3D: pVIPLabel[MAX_PLAYER_NAME],
	Text3D: pAdminLabel[MAX_PLAYER_NAME];

// Unchanged variables are located below!
//TEXTDRAWS(round ending)
new Text:Textdraw7;
new Text:Textdraw8;
new Text:Textdraw9;
new Text:Textdraw10;
new Text:Textdraw11;
new Text:Textdraw12;

new smokegas[MAX_PLAYERS];

new Float:SpecX[MAX_PLAYERS], Float:SpecY[MAX_PLAYERS], Float:SpecZ[MAX_PLAYERS], vWorld[MAX_PLAYERS], Inter[MAX_PLAYERS];
new IsSpecing[MAX_PLAYERS], IsBeingSpeced[MAX_PLAYERS],spectatorid[MAX_PLAYERS];

new Text:EventText;
new Text:CurrentMap;
new Text:remadeText2;
new Text:AliveInfo;
new Text:TimeLeft;
new Text:UntilRescue;
new Text:aod;
new Text:aodbox;
new Text:www;
new Text:samps;
new Text:svitra;
new Text:zland;
new Text:dot;
new Text:infos;
new Text:Infected[MAX_PLAYERS];
new Text:iKilled[MAX_PLAYERS];
new Text:myXP[MAX_PLAYERS];
new Text:mykills[MAX_PLAYERS];
new Text:mydeaths[MAX_PLAYERS];
new Text:mykd[MAX_PLAYERS];
new Text:mytokens[MAX_PLAYERS];
new Text:myrank[MAX_PLAYERS];
new Text:ServerIntroOne[MAX_PLAYERS];
new Text:ServerIntroTwo[MAX_PLAYERS];

/*
	Map Stats
*/

enum E_MAP_INFO {

	MapName[MAX_MAP_NAME_LEN],
	FSMapName[MAX_MAP_NAME_LEN],
	
	Float:HumanSpawnX,
	Float:HumanSpawnY,
	Float:HumanSpawnZ,
	
	Float:HumanSpawn2X,
	Float:HumanSpawn2Y,
	Float:HumanSpawn2Z,
	
	Float:ZombieSpawnX,
	Float:ZombieSpawnY,
	Float:ZombieSpawnZ,
	
	Float:GateX,
	Float:GateY,
	Float:GateZ,
	
	Float:GaterX,
	Float:GaterY,
	Float:GaterZ,
	
	Float:CPx,
	Float:CPy,
	Float:CPz,
	
	GateID,
	MoveGate,
	AllowWater,
	
	Interior,
	Weather,
	Time,
	
	EvacType,
	IsStarted,
	XPType
};
new Map[E_MAP_INFO];

/*
	Player Stats
*/

enum E_PLAYER_INFO {

	// Stuff that is saved!
	pID,
	pName[MAX_PLAYER_NAME],
	pPassword[65],
	pCash,
	pXP,
	pKills,
	pHeads,
	pDeaths,
	pRank,
	pAdminLevel,
	pVipLevel,
	pMapsPlayed,
	pCoins,
	
	// Stuff that isn't saved!
	pLogged,
	
	// - Class related content
	pBombs,
	pDoctorShield,
	
	// - Round related content
	pRoundZombies,
	pRoundDeaths,
	pRoundKills,
	pTeam,
	pClass,
	
	pEvac,
	pTime, // Unused for now
	pAdminDuty,
	pWarnings,
	pPM,
	Last,
	Muted,
	Killstreak,
	IsPlayerInfected,
	IsPlayerInfectedTimer,
	Boxes,
	BoxesAdvanced,
	bandages,
	antidotes,
	pVipKickBack,
	pVipFlash,
	pVipBoxes,
	pLadders,
	pKickBackCoin,
	pDamageShotgunCoin,
	pDamageDeagleCoin,
	pDamageMP5Coin,
	Frozen,
	Minigun,
	pSpawned
};
new pInfo[MAX_PLAYERS][E_PLAYER_INFO];

enum aname { // ???? Needs to be worked
	HighJumpScout,
	HighJumpZombie,
	StomperPushing,
	WitchAttack,
	ScreamerZombieAb,
	ScreamerZombieAb2,
	InfectionNormal,
	InfectionMutated,
	ShoutCooldown,
	HealCoolDown,
	AdvancedMutatedCooldown,
	WitchAttack2,
	InfectionFleshEater
}
new Abilitys[MAX_PLAYERS][aname];

/*
	Random Messages
*/

new const gRandomMessages[][144] = { // The variable was renamed!
	"[{DC143C}SERVER{FFFFFF}]: Check the command /vip, to see information about the donation and features.",
	"[{DC143C}SERVER{FFFFFF}]: Join our Community Forums: www.samp-zombieland.info, to see the latest News & Updates.",
	"[{DC143C}SERVER{FFFFFF}]: Earn XP and Cash by killing your enemy team, or you can donate for getting more XP and Cash.",
	"[{DC143C}SERVER{FFFFFF}]: New here? Then it is recommended for you to read the /cmds and /help.",
	"[{DC143C}SERVER{FFFFFF}]: If you have seen the Hacker, then please use /report [id] [reason], do not shout about it in the main public chat.",
	"[{DC143C}SERVER{FFFFFF}]: Please respect other Players & Administrators on this server.",
	"[{DC143C}SERVER{FFFFFF}]: Remember to read and follow the server /rules, do NOT, violate any of them.",
	"[{DC143C}SERVER{FFFFFF}]: Interested to become part of our staff team? You can post your application at our forums!",
	"[{DC143C}SERVER{FFFFFF}]: Do you enjoy playing? Then don't forget to add this server to your favorites! Also invite your friends."
};

/*
	Ranks
*/

enum E_RANKS
{
	E_RANKS_NAME[14],
	E_RANKS_KILLS
};
new const gRanks[][E_RANKS] =
{
	{"Unranked",		0},
	{"Private",			10},
	{"Private I",		50},
	{"Private II",		100},
	{"Specialist",		200},
	{"Specialist I",	250},
	{"Corporal I",		300},
	{"Corporal II",		350},
	{"Sergeant", 		400},
	{"Seargeant I", 	450},
	{"Sergeant II", 	500},
	{"Commander",		550},
	{"Commander II",	600},
	{"Killer",			650},
	{"Killer I",		700},
	{"Killer II",		750},
	{"Major",			800},
	{"Major I",			850},
	{"Major II",		900},
	{"Doctor",			950},
	{"Doctor I",		1000},
	{"Doctor II",		1500},
	{"Colonel",			2000},
	{"Colonel I",		2500},
	{"Colonel II",		3000},
	{"Sniper",			3500},
	{"Sniper I",		4000},
	{"Sniper II",		4500},
	{"Survivor",		5000},
	{"Survivor I",		5500},
	{"Survivor II",		6000},
	{"Finalist",		7000}
};

/*
	Main
*/

main() {
	print("[main] "NAME"");
}

function StartMap()
{
	ClearChat();
	ResetBombs();
	ResetShields();

	foreach(new i : Player)
	{
		TextDrawHideForPlayer(i, Textdraw7);
		TextDrawHideForPlayer(i, Textdraw8);
		TextDrawHideForPlayer(i, Textdraw9);
		TextDrawHideForPlayer(i, Textdraw10);
		TextDrawHideForPlayer(i, Textdraw11);
		TextDrawHideForPlayer(i, Textdraw12);
		SetCameraBehindPlayer(i);
		ClearAnimations(i);
		HumanSetup(i);
		SpawnPlayer(i);
		CurePlayer(i);
		SetPlayerDrunkLevel(i,0);
		DisablePlayerCheckpoint(i);
		pInfo[i][Boxes] = 3;
		pInfo[i][BoxesAdvanced] = 7;
		pInfo[i][pVipBoxes] = 9;
		pInfo[i][pLadders] = 4;
		pInfo[i][pBombs] = 3;
		pInfo[i][bandages] = 0;
		pInfo[i][antidotes] = 0;
		pInfo[i][pDoctorShield] = 1;
		pInfo[i][pMapsPlayed]++;
		pInfo[i][Killstreak] = 0;
		TextDrawHideForPlayer(i, ServerIntroOne[i]);
		TextDrawHideForPlayer(i, ServerIntroTwo[i]);
		TogglePlayerControllable(i,1);
	}

	gTime = MAX_MAPTIME;

	SetWeather(Map[Weather]);
	SetWorldTime(Map[Time]);
	UpdateMapName();

	gGateObject = CreateObject(Map[GateID],Map[GateX],Map[GateY],Map[GateZ],Map[GaterX],Map[GaterY],Map[GaterZ],500.0);
	gMap_Timer = SetTimer("OnMapUpdate",MAX_MAPUPDATE_TIME,true);
	gBalance_Timer = SetTimer("OnMapBalance",MAX_BALANCERUPDATE_TIME,true);
	return 1;
}

//ROUND END TEXTDRAW STATISCTICS
LoadTextdraws()
{
	Textdraw7 = TextDrawCreate(508.823547, 109.416671, "usebox");
	TextDrawLetterSize(Textdraw7, 0.000000, 26.192592);
	TextDrawTextSize(Textdraw7, 151.882354, 0.000000);
	TextDrawAlignment(Textdraw7, 1);
	TextDrawColor(Textdraw7, 0);
	TextDrawUseBox(Textdraw7, true);
	TextDrawBoxColor(Textdraw7, 102);
	TextDrawSetShadow(Textdraw7, 0);
	TextDrawSetOutline(Textdraw7, 0);
	TextDrawFont(Textdraw7, 0);

	Textdraw8 = TextDrawCreate(508.823547, 109.416671, "usebox");
	TextDrawLetterSize(Textdraw8, 0.000000, 1.238888);
	TextDrawTextSize(Textdraw8, 151.882339, 0.000000);
	TextDrawAlignment(Textdraw8, 1);
	TextDrawColor(Textdraw8, 0);
	TextDrawUseBox(Textdraw8, true);
	TextDrawBoxColor(Textdraw8, 102);
	TextDrawSetShadow(Textdraw8, 0);
	TextDrawSetOutline(Textdraw8, 0);
	TextDrawFont(Textdraw8, 0);

	Textdraw9 = TextDrawCreate(159.058792, 128.916671, "~r~Name: ~w~ 123456789012345678901234  -  ~r~Deaths: ~w~50  -  ~b~Kills: ~w~50~n~");
	TextDrawLetterSize(Textdraw9, 0.217529, 1.109998);
	TextDrawAlignment(Textdraw9, 1);
	TextDrawColor(Textdraw9, -1);
	TextDrawSetShadow(Textdraw9, 0);
	TextDrawSetOutline(Textdraw9, 1);
	TextDrawBackgroundColor(Textdraw9, 51);
	TextDrawFont(Textdraw9, 2);
	TextDrawSetProportional(Textdraw9, 1);

	Textdraw10 = TextDrawCreate(287.529052, 108.499992, "~r~Round Stats");
	TextDrawLetterSize(Textdraw10, 0.245293, 1.489167);
	TextDrawAlignment(Textdraw10, 1);
	TextDrawColor(Textdraw10, -16776961);
	TextDrawSetShadow(Textdraw10, 0);
	TextDrawSetOutline(Textdraw10, 1);
	TextDrawBackgroundColor(Textdraw10, 51);
	TextDrawFont(Textdraw10, 2);
	TextDrawSetProportional(Textdraw10, 1);

	Textdraw11 = TextDrawCreate(272.058624, 334.083343, "~b~Map starting soon..");
	TextDrawLetterSize(Textdraw11, 0.245293, 1.489167);
	TextDrawAlignment(Textdraw11, 1);
	TextDrawColor(Textdraw11, -16776961);
	TextDrawSetShadow(Textdraw11, 0);
	TextDrawSetOutline(Textdraw11, 1);
	TextDrawBackgroundColor(Textdraw11, 51);
	TextDrawFont(Textdraw11, 2);
	TextDrawSetProportional(Textdraw11, 1);
	TextDrawSetSelectable(Textdraw11, true);

	Textdraw12 = TextDrawCreate(508.823547, 337.500000, "usebox");
	TextDrawLetterSize(Textdraw12, 0.000000, 0.802941);
	TextDrawTextSize(Textdraw12, 151.882339, 0.000000);
	TextDrawAlignment(Textdraw12, 1);
	TextDrawColor(Textdraw12, 0);
	TextDrawUseBox(Textdraw12, true);
	TextDrawBoxColor(Textdraw12, 102);
	TextDrawSetShadow(Textdraw12, 0);
	TextDrawSetOutline(Textdraw12, 0);
	TextDrawFont(Textdraw12, 0);
	TextDrawSetSelectable(Textdraw11, 1);
	return 1;
}

function No_Maps() return SendRconCommand("exit");

LoadNewMap()
{
	gMapID %= MAX_MAPS;
	gMapID ++;
	if (!gMaps[gMapID])
	{
		gMapID = 1;
	}
	return gMapID - 1;
}

function EndMap(playerid)
{
	new string[2000];
	ClearObjects();
	DestroyAllVehicle();
	UnloadFilterScript(Map[FSMapName]);
	LoadMap(LoadNewMap());

	SetTimer("StartMap",MAX_RESTART_TIME,false);

	foreach(new i : Player)
	{
		if (!IsPlayerConnected(i)) continue;
		format(string, sizeof string, "%s~r~Name: ~w~ %s(ID:%d) -  ~b~Humans Killed: ~w~%d  -  ~r~Zombies Killed: ~w~%d~n~", string, GetPlayerNameEx(i), i, pInfo[i][pRoundKills], pInfo[i][pRoundZombies]);
		TextDrawSetString(Textdraw9, string);

		TextDrawShowForPlayer(i, Textdraw7);
		TextDrawShowForPlayer(i, Textdraw8);
		TextDrawShowForPlayer(i, Textdraw9);
		TextDrawShowForPlayer(i, Textdraw10);
		TextDrawShowForPlayer(i, Textdraw11);
		TextDrawShowForPlayer(i, Textdraw12);
		pInfo[playerid][pRoundZombies] = 0;
		pInfo[playerid][pRoundKills] = 0;
		pInfo[playerid][pRoundDeaths] = 0;

		ChangeCameraView(i);
		TogglePlayerControllable(i,0);
		TextDrawShowForPlayer(i, ServerIntroOne[i]);
		TextDrawShowForPlayer(i, ServerIntroTwo[i]);

		if (pInfo[i][pAdminDuty] == 1)
		{
			pInfo[i][pAdminDuty] = 0;
		}
	}
	
	SendClientMessageToAll(-1,""chat""COL_YELLOW"{FFFF99} Creating Objects, Please Wait..");
	return 1;
}

function OnMapUpdate()
{
	gTime -= 1;

	foreach(new i : Player)
	{
		TextDrawHideForPlayer(i, Textdraw7);
		TextDrawHideForPlayer(i, Textdraw8);
		TextDrawHideForPlayer(i, Textdraw9);
		TextDrawHideForPlayer(i, Textdraw10);
		TextDrawHideForPlayer(i, Textdraw11);
		TextDrawHideForPlayer(i, Textdraw12);
	}

	TextDrawSetString(TimeLeft, timelefttimer(gTime));

	if (gTime<= 0)
	{
		KillTimer(gMap_Timer);
		KillTimer(gBalance_Timer);
		SetTimer("ShowCheckpoint",MAX_SHOW_CP_TIME,false);
		GameTextForAll("~b~Humans~n~ ~w~Go To Evacuation!",5000,4);
	}
	return 1;
}

timelefttimer(seconds)
{
	new vstr[8], minutes = floatround(seconds / 60, floatround_floor);
	format(vstr, sizeof(vstr), "%2d:%02d", minutes, seconds - (minutes * 60));
	return vstr;
}

function ShowCheckpoint()
{
	MoveObject(gGateObject,Map[GateX],Map[GateY],Map[MoveGate],3.0);
	foreach(new i : Player) SetPlayerCheckpoint(i,Map[CPx],Map[CPy],Map[CPz],6.0);
	SetTimer("EndMap",MAX_END_TIME,false);
	return 1;
}

function OnMapBalance()
{
	if (gPlayersCount >= 2)
	{
		EvenTeam();

		if (GetTeamPlayersAlive(TEAM_HUMAN) == 0)
		{
			KillTimer(gBalance_Timer);
			KillTimer(gMap_Timer);
			GameTextForAll("~r~*Zombies wins*",5000,4);
			SetTimer("EndMap",4000,false);
			foreach(new i : Player)
			{
				if (pInfo[i][pTeam] == TEAM_ZOMBIE)
				{
					pInfo[i][pXP] += 10;
					GivePlayerXP(i,10);
					SetPlayerScore(i,pInfo[i][pXP]);
					UpdateXPTextdraw(i);
				}
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if (pInfo[playerid][pTeam] == TEAM_HUMAN)
	{
		new string[256];
		if (Map[EvacType] == 1)
		{
			SetPlayerInterior(playerid,17);
			SetPlayerPos(playerid,490.6371,-18.4129,1000.6797);
			format(string, sizeof string, ""chat""COL_LGREEN"{ffffff} %s{99CCFF} made it to evacuation point and has received {FFD700}1 Token{99CCFF}!", GetPlayerNameEx(playerid));
			SendClientMessageToAll(-1,string);
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~y~+10 XP ~n~~g~+100 $",3500,5);
			DisablePlayerCheckpoint(playerid);
			CurePlayer(playerid);
			GivePlayerXP(playerid,10);
			GivePlayerMoney(playerid, 100);
			pInfo[playerid][pCash] +=100;
			pInfo[playerid][pEvac]++;
			pInfo[playerid][pCoins]++;
			SetPlayerColor(playerid,COLOR_YELLOW);
			UpdateTokensTextdraw(playerid);
			SetPlayerScore(playerid,pInfo[playerid][pXP]);
			UpdateXPTextdraw(playerid);
		}
	}
	return 1;
}

public OnGameModeInit() {

	print("[OnGameModeInit] Checking database.");
	
	if ((gSQL = db_open(DB_PATH)) == DB: 0)
	{
		return print("SQLite: Connection to the database failed.");
	}
	
	print("SQLite: Connected to the database.");

	print("[OnGameModeInit] Creating database.");

	db_free_result(db_query(gSQL, "CREATE TABLE IF NOT EXISTS "#TABLE_BANS" \
		("FIELD_BAN_ID" INTEGER PRIMARY KEY AUTOINCREMENT, "FIELD_BANNAME" STRING, "FIELD_BANREASON" STRING)"));

	db_free_result(db_query(gSQL, "CREATE TABLE IF NOT EXISTS "TABLE_USERS" \
		("FIELD_ID" INTEGER PRIMARY KEY AUTOINCREMENT, "FIELD_NAME" STRING, "FIELD_PASSWORD" STRING, "FIELD_IP" STRING, "FIELD_CASH" INTEGER DEFAULT '0', "FIELD_XP" INTEGER DEFAULT '0', \
		"FIELD_KILLS" INTEGER DEFAULT '0', "FIELD_DEATHS" INTEGER DEFAULT '0', "FIELD_HEADS" INTEGER DEFAULT '0', "FIELD_EVAC" INTEGER DEFAULT '0', "FIELD_RANK" INTEGER DEFAULT '0', "FIELD_ADMIN" INTEGER DEFAULT '0', \
		"FIELD_VIP" INTEGER DEFAULT '0', "FIELD_TIME" INTEGER DEFAULT '0', "FIELD_MAPS" INTEGER DEFAULT '0', "FIELD_COINS" INTEGER DEFAULT '0', "FIELD_KICKBACK" INTEGER DEFAULT '0', "FIELD_DMGDEAGLE" INTEGER DEFAULT '0',\
		"FIELD_DMGSHOTGUN" INTEGER DEFAULT '0', "FIELD_DMGMP5" INTEGER DEFAULT '0')"));

	db_free_result(db_query(gSQL, "CREATE TABLE IF NOT EXISTS "TABLE_MAPS" \
		("FIELD_MAP_ID" INTEGER PRIMARY KEY AUTOINCREMENT, "FIELD_MAP_FS_NAME" STRING, "FIELD_MAP_NAME" STRING, "FIELD_MAP_HUMAN_SPAWN_X" FLOAT, "FIELD_MAP_HUMAN_SPAWN_Y" FLOAT, "FIELD_MAP_HUMAN_SPAWN_Z" FLOAT, \
		"FIELD_MAP_HUMAN_SPAWN2_X" FLOAT, "FIELD_MAP_HUMAN_SPAWN2_Y" FLOAT, "FIELD_MAP_HUMAN_SPAWN2_Z" FLOAT, "FIELD_MAP_ZOMBIE_SPAWN_X" FLOAT, "FIELD_MAP_ZOMBIE_SPAWN_Y" FLOAT, "FIELD_MAP_ZOMBIE_SPAWN_Z" FLOAT, \
		"FIELD_MAP_INTERIOR" INTEGER, "FIELD_MAP_GATE_X" REAL, "FIELD_MAP_GATE_Y" REAL, "FIELD_MAP_GATE_Z" REAL, "FIELD_MAP_GATE2_X" REAL, "FIELD_MAP_GATE2_Y" REAL, "FIELD_MAP_GATE2_Z" REAL, \
		"FIELD_MAP_CP_X" REAL, "FIELD_MAP_CP_Y" REAL, "FIELD_MAP_CP_Z" REAL, "FIELD_MAP_MOVE_GATE" INTEGER, "FIELD_MAP_GATE_ID" INTEGER, "FIELD_MAP_WATER" INTEGER, "FIELD_MAP_EVAC_TYPE" INTEGER, \
		"FIELD_MAP_WEATHER" INTEGER, "FIELD_MAP_TIME" INTEGER)"));

	print("[OnGameModeInit] Loading maps.");
	LoadMaps();

	print("[OnGameModeInit] Creating textdraws.");
	LoadTextdraws();

	print("[OnGameModeInit] Initiating server information.");
	SetGameModeText("Zombieland v0.1 TDM");
	SendRconCommand("hostname "NAME"");
	SendRconCommand("weburl "SITE"");

	print("[OnGameModeInit] Initiating general stuff.");
	AllowInteriorWeapons(1);
	DisableInteriorEnterExits();

	print("[OnGameModeInit] Adding class.");
	AddPlayerClass(162, -342.24377, 2217.76343, 42.58860,   90.00000, 0, 0, 0, 0, 0, 0);

	CreateObject(19124, -328.05219, 2233.07642, 42.33670,   0.00000, 0.00000, 0.00000);
	CreateObject(19124, -327.40564, 2212.46313, 42.33670,   0.00000, 0.00000, 0.00000);
	
	print("[OnGameModeInit] Initiating timers.");
	SetTimer("RandomMessages",	45000,	true);
	SetTimer("AntiCheat",		3000,	true);
	SetTimer("OneSecondUpdate",	1000,	true);

	SetTeamCount(2);
	SetWorldTime(0);
	SetWeather(12);
	DefaultTextdraws();

	Map[IsStarted] = 0;
	Map[XPType] = 1;
	gMapID = 0;
	return 1;
}

forward OneSecondUpdate();
public OneSecondUpdate() {

	UpdateAliveInfo();
	DoctorShield();
	TerroristBomb(); // Completely new terrorist bomb system!

	foreach (new i : Player) {
		UpdateXPTextdraw(i);
		UpdateTokensTextdraw(i);
		UpdateRanksTextdraw(i);
	}
	
	return 1;
}

UpdateKillStatsTD(playerid)
{	
	UpdateKillsTextdraw(playerid);
	UpdateDeathsTextdraw(playerid);
	UpdateKDTextdraw(playerid);
	return 1;
}

LoadMaps() {
	new DBResult: result = db_query(gSQL, "SELECT "FIELD_MAP_ID", "FIELD_MAP_NAME" FROM "TABLE_MAPS""), maps = db_num_rows(result);

	if (!maps) {

		print("_____________________________________________________________");
		print("Maps: The server has detected there are no map files\n\
			currently installed. The server has been set to\n\
			automatically shut down in 5 seconds.");
		print("_____________________________________________________________");

		return SetTimer("No_Maps", 5000, false);
	}

	for(new i; i < maps; i++) {

		gMaps[i] = db_get_field_assoc_int(result, FIELD_MAP_ID);
		db_get_field_assoc(result, FIELD_MAP_NAME, gMapNames[i], MAX_MAP_NAME_LEN);
		db_next_row(result);
	}

	printf("Maps: %d maps are currently loaded in the server.", maps);
	return 1;
}

public OnGameModeExit() {

	TextDrawHideForAll(TimeLeft);
	TextDrawDestroy(TimeLeft);
	TextDrawHideForAll(UntilRescue);
	TextDrawHideForAll(AliveInfo);
	TextDrawDestroy(AliveInfo);
	TextDrawHideForAll(remadeText2);
	TextDrawDestroy(remadeText2);
	TextDrawHideForAll(CurrentMap);
	TextDrawDestroy(CurrentMap);
	TextDrawHideForAll(EventText);
	TextDrawDestroy(EventText);
	TextDrawHideForAll(aod);
	TextDrawDestroy(aod);
	TextDrawHideForAll(aodbox);
	TextDrawDestroy(aodbox);
	TextDrawHideForAll(www);
	TextDrawDestroy(www);
	TextDrawHideForAll(samps);
	TextDrawDestroy(samps);
	TextDrawHideForAll(svitra);
	TextDrawDestroy(svitra);
	TextDrawHideForAll(zland);
	TextDrawDestroy(zland);
	TextDrawHideForAll(dot);
	TextDrawDestroy(dot);
	TextDrawHideForAll(infos);
	TextDrawDestroy(infos);

	for(new i; i < MAX_PLAYERS; i ++)
	{
		TextDrawHideForAll(Infected[i]);
		TextDrawHideForAll(iKilled[i]);
		TextDrawDestroy(iKilled[i]);
		TextDrawHideForAll(myXP[i]);
		TextDrawDestroy(myXP[i]);
		TextDrawHideForAll(mykills[i]);
		TextDrawDestroy(mykills[i]);
		TextDrawHideForAll(mydeaths[i]);
		TextDrawDestroy(mydeaths[i]);
		TextDrawHideForAll(mykd[i]);
		TextDrawDestroy(mykd[i]);
		TextDrawHideForAll(mytokens[i]);
		TextDrawDestroy(mytokens[i]);
		TextDrawHideForAll(myrank[i]);
		TextDrawDestroy(myrank[i]);
		TextDrawHideForAll(ServerIntroOne[i]);
		TextDrawDestroy(ServerIntroOne[i]);
		TextDrawHideForAll(ServerIntroTwo[i]);
		TextDrawDestroy(ServerIntroTwo[i]);
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	TextDrawHideForPlayer(playerid, Textdraw7);
	TextDrawHideForPlayer(playerid, Textdraw8);
	TextDrawHideForPlayer(playerid, Textdraw9);
	TextDrawHideForPlayer(playerid, Textdraw10);
	TextDrawHideForPlayer(playerid, Textdraw11);
	TextDrawHideForPlayer(playerid, Textdraw12);

	InterpolateCameraPos(playerid, 199.084838, -1051.298828, 146.296569, -1807.364257, -2560.537597, 185.529602, 100000);
	InterpolateCameraLookAt(playerid, 195.089538, -1054.304077, 146.374694, -1811.359619, -2563.542724, 185.607727, 100000);

	if (classid == 0)
	{
		SetPlayerTeam(playerid,TEAM_ZOMBIE);
		pInfo[playerid][pTeam] = TEAM_ZOMBIE;
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if (pInfo[playerid][pLogged]) return 1;
	
	GameTextForPlayer(playerid, "~r~YOU MUST LOGIN TO PLAY", 1000, 4);
	CheckPlayerAccount(playerid);
	return 0;
}

public OnPlayerConnect(playerid)
{
	GetPlayerName(playerid, GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
	SetPlayerWeather(playerid, 12);
	SetPlayerTime(playerid, 21, 0);

	// Removes all the vending machines that may give players health with tricky usage of radius!
	RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 3000.0);
	RemoveBuildingForPlayer(playerid, 956, 0.0, 0.0, 0.0, 3000.0);
	RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 3000.0);
	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 3000.0);
	RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 3000.0);
	RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 3000.0);

	TextDrawHideForPlayer(playerid, Textdraw7);
	TextDrawHideForPlayer(playerid, Textdraw8);
	TextDrawHideForPlayer(playerid, Textdraw9);
	TextDrawHideForPlayer(playerid, Textdraw10);
	TextDrawHideForPlayer(playerid, Textdraw11);
	TextDrawHideForPlayer(playerid, Textdraw12);

	gPlayersCount++;
	ResetVars(playerid);
	ConnectVars(playerid);

	new string[60];
	format(string,sizeof string,"{808080}%s has joined the server.", GetPlayerNameEx(playerid));
	SendClientMessageToAll(-1, string);

	ResetCoinVars(playerid);
	
	if (CheckBan(GetPlayerNameEx(playerid))) {
		SendClientMessage(playerid, -1, "{808080} YOU'RE BANNED FROM THIS SERVER!");

		KickPlayer(playerid);
		return 0;
	}
	CheckPlayerAccount(playerid);

	TextDrawHideForPlayer(playerid, Textdraw7);
	TextDrawHideForPlayer(playerid, Textdraw8);
	TextDrawHideForPlayer(playerid, Textdraw9);
	TextDrawHideForPlayer(playerid, Textdraw10);
	TextDrawHideForPlayer(playerid, Textdraw11);
	TextDrawHideForPlayer(playerid, Textdraw12);
	return 1;
}

CheckPlayerAccount(playerid) {
	
	new query[140], DBResult: result;
	format(query, sizeof query, "SELECT "FIELD_PASSWORD", "FIELD_ID" FROM "TABLE_USERS" WHERE "FIELD_NAME" = '%q' LIMIT 1", GetPlayerNameEx(playerid));
	result = db_query(gSQL, query);

	if (db_num_rows(result)) {
		
		db_get_field_assoc(result, FIELD_PASSWORD, pInfo[playerid][pPassword], MAX_PASSWORD_LEN);
		pInfo[playerid][pID] = db_get_field_assoc_int(result, FIELD_ID);

		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Zombieland :: Login", ""chat" Our system has detected your username is registered, please login to continue:", "Login", "Quit");
	}
	else {
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Zombieland :: Register", ""chat" Our system has detected your username is not registered, please register to continue:", "Register", "Quit");
	}

	db_free_result(result);
	return 1;
}

public KickTimer(playerid) {
	Kick(playerid);
	return 1;
}

forward KickTimer(playerid);

public OnPlayerWeaponShot( playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ ) {
	
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	if (weaponid < 22 || weaponid > 38) return 0;
	if (!(-20000.0 <= z <= 20000.0)) return 0;
	return 1;
}

SavePlayerAccount(playerid) {

	new query[200];
	format(query, sizeof query,
		"UPDATE "TABLE_USERS" SET "FIELD_CASH" = %d, "FIELD_XP" = %d, "FIELD_KILLS" = %d, "FIELD_DEATHS" = %d, "FIELD_HEADS" = %d WHERE "FIELD_ID" = %d",
		pInfo[playerid][pCash], pInfo[playerid][pXP], pInfo[playerid][pKills], pInfo[playerid][pDeaths], pInfo[playerid][pHeads], pInfo[playerid][pID]);
	db_free_result(db_query(gSQL, query));

	return 1;
}

public OnPlayerDisconnect(playerid, reason) {
	new string[39 + MAX_PLAYER_NAME];
	switch (reason)
	{
		case 0: format(string, sizeof string, "{808080}%s has left the server. (Lost Connection)", GetPlayerNameEx(playerid));
		case 1: format(string, sizeof string, "{808080}%s has left the server. (Leaving)", GetPlayerNameEx(playerid));
		case 2: format(string, sizeof string, "{808080}%s has left the server. (Kicked)", GetPlayerNameEx(playerid));
	}
	SendClientMessageToAll(0xAAAAAAAA, string);

	if (pInfo[playerid][pLogged] == 1) { SavePlayerAccount(playerid); } else return 0;
	ResetVars(playerid);
	
	playersAliveCount--;
	gPlayersCount --;
	
	Delete3DTextLabel(pAdminLabel[playerid]);
	Delete3DTextLabel(pVIPLabel[playerid]);

	if (gPlayersCount == 0) return SendRconCommand("mapname Loading"),KillTimer(gMap_Timer),KillTimer(gBalance_Timer),Map[IsStarted] = 0;

	if (IsBeingSpeced[playerid] == 1)
	{
		foreach(new i : Player)
		{
			if (spectatorid[i] == playerid)
			{
				TogglePlayerSpectating(i,false);
			}
		}
	}
	return 1;
}

public OnPlayerSpawn(playerid) {

	pInfo[playerid][pSpawned] = 1;
	pInfo[playerid][Minigun] = 0;

	if (IsSpecing[playerid] == 1) {

		SetPlayerPos(playerid,SpecX[playerid],SpecY[playerid],SpecZ[playerid]);
		SetPlayerInterior(playerid,Inter[playerid]);
		SetPlayerVirtualWorld(playerid,vWorld[playerid]);
		IsSpecing[playerid] = 0;
		IsBeingSpeced[spectatorid[playerid]] = 0;
		SetWeather(Map[Weather]);
		SetWorldTime(Map[Time]);

		switch (pInfo[playerid][pVipLevel]) {
			case 1: pVIPLabel[playerid] = Create3DTextLabel("Bronze VIP", 0xCC9900FF, 30.0, 40.0, 50.0, 40.0, 0);
			case 2: pVIPLabel[playerid] = Create3DTextLabel("Bronze VIP", 0x999966FF, 30.0, 40.0, 50.0, 40.0, 0);
			case 3: pVIPLabel[playerid] = Create3DTextLabel("Gold VIP", 0xFFCC00FF, 30.0, 40.0, 50.0, 40.0, 0);
			default: pVIPLabel[playerid] = Create3DTextLabel("Regular Player", 0xFFFFFFFF, 30.0, 40.0, 50.0, 40.0, 0);
		}

		if (pInfo[playerid][pTeam] == TEAM_HUMAN)
		{
			HumanSetup(playerid);
			SpawnPlayer(playerid);
		}
		else if (pInfo[playerid][pTeam] == TEAM_ZOMBIE)
		{
			ZombieSetup(playerid);
			SpawnPlayer(playerid);
		}
	}
	else {

		playersAliveCount++;
		SetPlayerInterior(playerid, Map[Interior]);
		CheckToStartMap();

		switch (pInfo[playerid][pTeam]) {

			case TEAM_ZOMBIE: {
				ZombieSetup(playerid);

				SetPlayerPos(playerid,Map[ZombieSpawnX],Map[ZombieSpawnY],Map[ZombieSpawnZ]);

				SetPlayerHealth(playerid, 99999);
				pASK_Timer[playerid] = SetTimerEx("EndAntiSpawnKill", 5000, false, "i", playerid);
				SendClientMessage(playerid, 0xFFFFF55, "{ffffff}[{33FF99}ANTI-SK{ffffff}]: You Have 5 Seconds Of Spawn Protection.");
				SendClientMessage(playerid, 0xFFFFF55, "{ffffff}[{33FF99}ANTI-SK{ffffff}]: Press 'N' Key To End Spawn Protection Now.");

				ShowZombieMenu(playerid);
			}

			case TEAM_HUMAN: {
				HumanSetup(playerid);

				switch (random(2))
				{
					case 0: SetPlayerPos(playerid,Map[HumanSpawnX],Map[HumanSpawnY],Map[HumanSpawnZ]);
					case 1: SetPlayerPos(playerid,Map[HumanSpawn2X],Map[HumanSpawn2Y],Map[HumanSpawn2Z]);
				}

				ShowShopDialog(playerid);
			}
		}

		if (pInfo[playerid][Frozen] == 1)
		{
			TogglePlayerControllable(playerid,0);
			SendClientMessage(playerid,COLOR_RED,"You are still frozen!");
		}

		setClass(playerid);
		SpawnVars(playerid);
	}
	
	StopAudioStreamForPlayer(playerid);

	UpdateKillsTextdraw(playerid);
	UpdateDeathsTextdraw(playerid);
	UpdateKDTextdraw(playerid);
	UpdateTokensTextdraw(playerid);
	UpdateRanksTextdraw(playerid);
	
	TextDrawHideForPlayer(playerid, Textdraw7);
	TextDrawHideForPlayer(playerid, Textdraw8);
	TextDrawHideForPlayer(playerid, Textdraw9);
	TextDrawHideForPlayer(playerid, Textdraw10);
	TextDrawHideForPlayer(playerid, Textdraw11);
	TextDrawHideForPlayer(playerid, Textdraw12);
	return 1;
}

forward EndAntiSpawnKill(playerid);
public EndAntiSpawnKill(playerid)
{
	if (pInfo[playerid][pTeam] != TEAM_ZOMBIE) return 1;

	pInfo[playerid][pSpawned] = 0;
	SetPlayerHealth(playerid, 100.0);
	KillTimer(pASK_Timer[playerid]);
	SendClientMessage(playerid, 0xFFFFF55, "{ffffff}[{33FF99}ANTI-SK{ffffff}]: Spawn Protection Is Over.");
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
		case DIALOG_REGISTER:
		{
			if (!response)
			{
				SendClientMessage(playerid, -1, "You must register to play at "NAME);
				return KickPlayer(playerid);
			}

			if (!strlen(inputtext))
			{
				return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Zombieland :: Register", ""chat" Our system has detected your username is not registered, please register to continue:", "Register", "Quit");
			}
			
			new IP[16], query[230], DBResult: result;
			GetPlayerIp(playerid, IP, sizeof IP);
			SHA256_PassHash(inputtext, PASSWORD_SALT, pInfo[playerid][pPassword], MAX_PASSWORD_LEN);

			format(query, sizeof query, "INSERT INTO "TABLE_USERS" ("FIELD_NAME", "FIELD_PASSWORD", "FIELD_IP") VALUES('%q', '%q', '%q')", GetPlayerNameEx(playerid), pInfo[playerid][pPassword], IP);
			db_free_result(db_query(gSQL, query));

			result = db_query(gSQL, "SELECT last_insert_rowid()");
			pInfo[playerid][pID] = db_get_field_int(result);

			pInfo[playerid][pLogged] = 1;
			SendClientMessage(playerid,-1,""chat""COL_LGREEN" {66FF66}You have successfully registered!");
			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
			return 1;
		}

		case DIALOG_LOGIN:
		{
			if (!response)
			{
				SendClientMessage(playerid, -1, "You must log in to play at "NAME);
				return KickPlayer(playerid), 1;
			}
			
			new buf[65];
			SHA256_PassHash(inputtext, PASSWORD_SALT, buf, sizeof buf);

			if (!strcmp(buf,pInfo[playerid][pPassword]))
			{
				LoadAccount(playerid);
				pInfo[playerid][pLogged] = 1;
				SendClientMessage(playerid,-1,""chat""COL_LGREEN" {66FF66}You have successfully logged in!");
				PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Zombieland :: Login", ""chat" Our system has detected your username is registered, please login to continue:", "Login", "Quit");
			}
			return 1;
		}

		case DIALOG_RADIO:
		{
			if (response)
			{
				switch (listitem)
				{
					case 0: PlayAudioStreamForPlayer(playerid,"http://50.7.64.226:80/frisky_mp3_hi");//Electro
					case 1: PlayAudioStreamForPlayer(playerid,"http://69.4.232.118:80/live");//Heavy Metal
					case 2: PlayAudioStreamForPlayer(playerid,"http://listen.radionomy.com/ABC-Katy-Perry");//Teen Pop
					case 3: PlayAudioStreamForPlayer(playerid,"http://46.165.232.57:80");//R&B
					case 4: PlayAudioStreamForPlayer(playerid,"http://88.198.0.37:9020");//Hip-Hop
					case 5: PlayAudioStreamForPlayer(playerid,"http://184.107.197.154:8002");//Reggae
					case 6: PlayAudioStreamForPlayer(playerid,"http://198.50.155.189:8004");//Rock
					case 7: PlayAudioStreamForPlayer(playerid,"http://listen.radionomy.com/Animes-Station");//Anime
					case 8: PlayAudioStreamForPlayer(playerid,"http://listen.radionomy.com/R1Dubstep");//Dubstep
					case 9: PlayAudioStreamForPlayer(playerid,"http://185.33.22.13:8030");//Blues
					case 10: PlayAudioStreamForPlayer(playerid,"http://listen.radionomy.com/100-HIT-radio");//TOP 40
					case 11: StopAudioStreamForPlayer(playerid);
				}
			}
		}

		case DIALOG_CLASS_2:
		{
			if (!response)
			{
				return ShowPlayerDialog(playerid, DIALOG_WEAPONS_SHOP, DIALOG_STYLE_LIST, "{FFFFFF}SHOP", "Weapons\nSkins\nClasses\nToken Shop\nPerks", "Select", "Close");
			}

			if (pInfo[playerid][pXP] < gHumanClass[listitem][E_CLASS_SCORE])
			{
				return SendXPError(playerid, gHumanClass[listitem][E_CLASS_SCORE]);
			}

			pInfo[playerid][pClass] = listitem;
			setClass(playerid);
			switch (pInfo[playerid][pClass])
			{
				case 1: SendClientMessage(playerid, -1, ""chat""COL_WHITE" {FFFF33}You have selected Medic. Type '/cure' to cure an infected player.");
				case 2: SendClientMessage(playerid, -1, ""chat""COL_WHITE" {FFFF33}You have selected Terrorist. Press 'LALT' to plant a bomb.");
				case 3: SendClientMessage(playerid, -1, ""chat""COL_WHITE" {FFFF33}You have selected Sniper. Do a headshot with a sniper rifle, which instantly kills a zombie.");
				case 4: SendClientMessage(playerid, -1, ""chat""COL_WHITE" {FFFF33}You have selected Hershel. Your shotgun will give more damage on zombies.");
				case 5: SendClientMessage(playerid, -1, ""chat""COL_WHITE" {FFFF33}You have selected Heavy Shotgun. Your shotgun will give more damage on zombies.");
				case 6: SendClientMessage(playerid, -1, ""chat""COL_WHITE" {FFFF33}You have selected Kickback. When you will shoot the zombie, it will kick him back away.");
				case 7: SendClientMessage(playerid, -1, ""chat""COL_WHITE" {FFFF33}You have selected Scout. With one shot you can kill a zombie. Also press 'LALT' for a high jump.");
				case 8: SendClientMessage(playerid, -1, ""chat""COL_WHITE" {FFFF33}You have selected Scientist. Type '/cure' to cure an infected player. Type '/heal' to heal up a player.");
			}

			ShowPlayerDialog(playerid, DIALOG_WEAPONS_SHOP, DIALOG_STYLE_LIST, "{FFFFFF}SHOP", "Weapons\nSkins\nClasses\nToken Shop\nPerks", "Select", "Close");
			return 1;
		}

		case DIALOG_CLASS_3: {
			if (!response) {
				return ShowPlayerDialog(playerid, DIALOG_ZOMBIE_CLASSES, DIALOG_STYLE_LIST, "ZOMBIE SPAWN MENU", "Classes", "Select", "Back");
			}

			if (pInfo[playerid][pXP] < gZombieClass[listitem][E_CLASS_SCORE]) {
				return SendXPError(playerid, gZombieClass[listitem][E_CLASS_SCORE]);
			}

			pInfo[playerid][pClass] = listitem;
			setClass(playerid);
			
			switch (listitem) {
				case 1: SendClientMessage(playerid,-1,""chat""COL_WHITE" {FFFF33}You have selected a Mutated Zombie. Press 'LALT' to infect all humans around you.");
				case 2: SendClientMessage(playerid,-1,""chat""COL_WHITE" {FFFF33}You have selected a Hunter Zombie. Press 'LSHIFT' to do a high jump.");
				case 3: SendClientMessage(playerid,-1,""chat""COL_WHITE" {FFFF33}You have selected a Stomper Zombie. Press 'LALT' to throw humans away around you.");
				case 4: SendClientMessage(playerid,-1,""chat""COL_WHITE" {FFFF33}You have selected a Witch Zombie. Press 'LALT' to give a human damage of -99 HP. (Instant kill).");
				case 5: SendClientMessage(playerid,-1,""chat""COL_WHITE" {FFFF33}You have selected a Smoker Zombie. Press 'LALT' to cause the toxic gas/smoke.");
				case 6: SendClientMessage(playerid,-1,""chat""COL_WHITE" {FFFF33}You have selected a Screamer Zombie. Press 'LALT' to throw humans on the ground.");
				case 7: SendClientMessage(playerid,-1,""chat""COL_WHITE" {FFFF33}You have selected a Seeker Zombie. Press 'LALT' to teleport to a random human.");
				case 8: SendClientMessage(playerid,-1,""chat""COL_WHITE" {FFFF33}You have selected a Flesh Eater Zombie. Press 'LALT' to infect a human.");
				case 9: SendClientMessage(playerid,-1,""chat""COL_WHITE" {FFFF33}You have selected a Rogue Zombie. Press 'LALT' to become a fake human.");
				case 10: SendClientMessage(playerid,-1,""chat""COL_WHITE" {FFFF33}You have selected a Boomer Zombie. Press 'LALT' to explode.");
			}

			ShowPlayerDialog(playerid, DIALOG_ZOMBIE_CLASSES, DIALOG_STYLE_LIST, "ZOMBIE SPAWN MENU", "Classes", "Select", "Back");
			return 1;
		}

		case DIALOG_VIP: {

			if (!response) return 1;
			
			switch (listitem)
			{
				case 0: if (pInfo[playerid][pVipLevel] >= 1) SendPlayerMaxAmmo(playerid),SendClientMessage(playerid,-1,""chat""COL_PINK" {B266FF}You have all your weapons max'ed ammo."); else { SendVipError(playerid,1); }
				case 1: if (pInfo[playerid][pVipLevel] >= 1) GivePlayerWeapon(playerid,31,150),GivePlayerWeapon(playerid,24,100),GivePlayerWeapon(playerid,25,600); else { SendVipError(playerid,1); }
				case 2: if (pInfo[playerid][pVipLevel] >= 1) SetPlayerAttachedObject(playerid,0,19142,1,0.028000,0.034000,0.000000,0.000000,0.000000,0.000000,1.063000,1.191999,1.285999); else { SendVipError(playerid,2); }
				case 3: if (pInfo[playerid][pVipLevel] >= 2) ShowPlayerDialog(playerid,DIALOG_VIP_CLASS,DIALOG_STYLE_LIST,"VIP Classes {ffffff}({0080FF}Human{ffffff})","Engineer\nMedic\nScout","Select","Close"); else { SendVipError(playerid,3); }
				case 4: if (pInfo[playerid][pVipLevel] >= 2) pInfo[playerid][pVipFlash] = 1,SendClientMessage(playerid,-1,""chat""COL_LGREEN" {B266FF}Your name is now flashing."); else { SendVipError(playerid,4); }
				case 5: if (pInfo[playerid][pVipLevel] >= 2) pInfo[playerid][pVipFlash] = 0,SendClientMessage(playerid,-1,""chat""COL_LGREEN" {B266FF}Your name has stopped flashing."); else { SendVipError(playerid,4); }
				case 6: if (pInfo[playerid][pVipLevel] >= 3) pInfo[playerid][pVipKickBack] = 1,SendClientMessage(playerid,-1,""chat""COL_LGREEN" {B266FF}You have enabled kick back!"); else { SendVipError(playerid,3); }
				case 7: if (pInfo[playerid][pVipLevel] >= 3) pInfo[playerid][pVipKickBack] = 0,SendClientMessage(playerid,-1,""chat""COL_LGREEN" {B266FF}You have disabled kick back!"); else { SendVipError(playerid,3); }
			}

			return 1;
		}

		case DIALOG_ZOMBIE_CLASSES: {

			if (!response) return 1;

			switch (listitem)
			{
				case 0:
				{
					new string[2000];
					strcat(string,"Class\tAbility\tPrice\nMutated\tInfect All Around\t5,000 XP\nHunter\tFast,High Jump\t10,000 XP\nStomper\tThrow All\t39,000 XP\n\
					Witch\t-99 Damage\t55,000 XP\nSmoker\tCauses Toxic Smoke/Gas\t63,000 XP\nScreamer\tThrow To Ground\t78,000 XP\nSeeker\tTeleport To a Human\t92,000 XP\n\
					Flesh Eater\tKills faster\t150,00 XP\nRogue\tBecomes a Fake Human\t186,00 XP\nBoomer\tExplode\t220,000 XP\nTanker\tPunch Away\t330,000 XP");

					ShowPlayerDialog(playerid,DIALOG_CLASS_3,DIALOG_STYLE_TABLIST_HEADERS, "ZOMBIE CLASSES", string, "Select", "Back");
				}
			}
		}

		case DIALOG_WEAPONS_SHOP:
		{
			if (response)
			{
				switch (listitem)
				{
					case 0: ShowPlayerDialog(playerid,DIALOG_WEAPONS,DIALOG_STYLE_TABLIST_HEADERS, "WEAPONS", "Weapon\tPrice\tAmmo\nSilenced 9mm\t$210\t70\nDesert Eagle\t$400\t50\nShotgun\t$320\t45\nCombat Shotgun\t$550\t65\nMP5\t$500\t150\nAK-47\t$600\t170\nM4\t$620\t170\nTEC-9\t$500\t150\nSniper Rifle\t$700\t30", "Buy", "Back");
					case 1: ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
					case 2: ShowPlayerDialog(playerid,DIALOG_CLASS_2,DIALOG_STYLE_TABLIST_HEADERS, "CLASSES", "Class\tAbility\tPrice\nMedic\tCure & Heal\t6,000 XP\nTerrorist\tPlant Bombs\t37,000 XP\nSniper\tHeadshot Kill\t40,000 XP\nHershel\tShotgun Damage\t54,000 XP\nEngineer\tBuild Ladders\t79,000 XP\nKickback\tThrowshot\t100,000 XP\nScout\tOne shoot kill\t225,000 XP\nScientist\tShield Heal\tRank 22", "Select", "Back");
					case 3: ShowPlayerDialog(playerid,DIALOG_COINS,DIALOG_STYLE_TABLIST_HEADERS, "TOKEN SHOP", "Feature\tPrice\nEnable Kick Back\t45 Tokens\nMore Shotgun Damage\t40 Tokens\n\
					More Deagle Damage\t50 Tokens\nMore MP5 Damage\t30 Tokens\nS.W.A.T Armour Object\t30 Tokens\n\
					Accessories (Each Accessorie Costs 1 Token)\n","Select","Back");
					case 4: ShowPlayerDialog(playerid,DIALOG_PERKS,DIALOG_STYLE_TABLIST_HEADERS, "PERKS", "Perk\tPrice\tAmount\nBandages\t$2,000\t2\nAntidotes\t$3,500\t2", "Buy", "Back");
				}
			}
		}

		case DIALOG_PERKS:
		{
			if ( !response ) return ShowPlayerDialog(playerid, DIALOG_WEAPONS_SHOP, DIALOG_STYLE_LIST, "{FFFFFF}SHOP", "Weapons\nSkins\nClasses\nToken Shop\nPerks", "Select", "Close");
			if (response)
			{
				switch (listitem)
				{
					case 0:
					{
					if (GetPlayerMoney(playerid) < 2000)
					return SendClientMessage(playerid, 0x33FF00AA, "You don't have enough cash to buy a Bandage.");
					GivePlayerMoney(playerid, -2000);
					pInfo[playerid][pCash] -= 2000;
					pInfo[playerid][bandages] = 2;
					SendClientMessage(playerid,-1,""chat""COL_WHITE" You have purchased two Bandages. Type '/bandage' whenever you are injured.");
					return ShowPlayerDialog(playerid, DIALOG_WEAPONS_SHOP, DIALOG_STYLE_LIST, "{FFFFFF}SHOP", "Weapons\nSkins\nClasses\nToken Shop\nPerks", "Select", "Close");
					}
					case 1:
					{
					if (GetPlayerMoney(playerid) < 3500)
					return SendClientMessage(playerid, 0x33FF00AA, "You don't have enough cash to buy a Bandage.");
					GivePlayerMoney(playerid, -3500);
					pInfo[playerid][pCash] -= 3500;
					pInfo[playerid][antidotes] = 2;
					SendClientMessage(playerid,-1,""chat""COL_WHITE" You have purchased two Antidotes. Type '/antidote' whenever you are infected.");
					return ShowPlayerDialog(playerid, DIALOG_WEAPONS_SHOP, DIALOG_STYLE_LIST, "{FFFFFF}SHOP", "Weapons\nSkins\nClasses\nToken Shop\nPerks", "Select", "Close");
					}
				}
			}
		}

		case DIALOG_WEAPONS:
		{
			if ( !response ) return ShowPlayerDialog(playerid, DIALOG_WEAPONS_SHOP, DIALOG_STYLE_LIST, "{FFFFFF}SHOP", "Weapons\nSkins\nClasses\nToken Shop\nPerks", "Select", "Close");
			if (response)
			{
				switch (listitem)
				{
					case 0: // Silenced 9mm
					{
					if (GetPlayerMoney(playerid) < 210)
					return SendClientMessage(playerid, 0x33FF00AA, "You don't have enough cash to buy this Weapon.");
					GivePlayerMoney(playerid, -210);
					pInfo[playerid][pCash] -= 210;
					GivePlayerWeapon(playerid, 23, 70);
					return ShowPlayerDialog(playerid,DIALOG_WEAPONS,DIALOG_STYLE_TABLIST_HEADERS, "WEAPONS", "Weapon\tPrice\tAmmo\nSilenced 9mm\t$210\t70\nDesert Eagle\t$400\t50\nShotgun\t$320\t45\nCombat Shotgun\t$550\t65\nMP5\t$500\t150\nAK-47\t$600\t170\nM4\t$620\t170\nTEC-9\t$500\t150\nSniper Rifle\t$700\t30", "Buy", "Back");
					}
					case 1: // Desert Eaogle
					{
					if (GetPlayerMoney(playerid) < 400)
					return SendClientMessage(playerid, 0x00FFFFAA, "You don't have enough cash to buy this Weapon.");
					GivePlayerMoney(playerid, -400);
					pInfo[playerid][pCash] -= 400;
					GivePlayerWeapon(playerid, 24, 50);
					return ShowPlayerDialog(playerid,DIALOG_WEAPONS,DIALOG_STYLE_TABLIST_HEADERS, "WEAPONS", "Weapon\tPrice\tAmmo\nSilenced 9mm\t$210\t70\nDesert Eagle\t$400\t50\nShotgun\t$320\t45\nCombat Shotgun\t$550\t65\nMP5\t$500\t150\nAK-47\t$600\t170\nM4\t$620\t170\nTEC-9\t$500\t150\nSniper Rifle\t$700\t30", "Buy", "Back");
					}
					case 2: // Shotgun
					{
					if (GetPlayerMoney(playerid) < 320)
					return SendClientMessage(playerid, 0x6600FFAA, "You don't have enough cash to buy this Weapon.");
					GivePlayerMoney(playerid, -320);
					pInfo[playerid][pCash] -= 320;
					GivePlayerWeapon(playerid, 25, 45);
					return ShowPlayerDialog(playerid,DIALOG_WEAPONS,DIALOG_STYLE_TABLIST_HEADERS, "WEAPONS", "Weapon\tPrice\tAmmo\nSilenced 9mm\t$210\t70\nDesert Eagle\t$400\t50\nShotgun\t$320\t45\nCombat Shotgun\t$550\t65\nMP5\t$500\t150\nAK-47\t$600\t170\nM4\t$620\t170\nTEC-9\t$500\t150\nSniper Rifle\t$700\t30", "Buy", "Back");
					}
					case 3: // Combat Shotgun
					{
					if (GetPlayerMoney(playerid) < 550)
					return SendClientMessage(playerid, 0x99FF00AA, "You don't have enough cash to buy this Weapon.");
					GivePlayerMoney(playerid, -550);
					pInfo[playerid][pCash] -= 550;
					GivePlayerWeapon(playerid, 27, 65);
					return ShowPlayerDialog(playerid,DIALOG_WEAPONS,DIALOG_STYLE_TABLIST_HEADERS, "WEAPONS", "Weapon\tPrice\tAmmo\nSilenced 9mm\t$210\t70\nDesert Eagle\t$400\t50\nShotgun\t$320\t45\nCombat Shotgun\t$550\t65\nMP5\t$500\t150\nAK-47\t$600\t170\nM4\t$620\t170\nTEC-9\t$500\t150\nSniper Rifle\t$700\t30", "Buy", "Back");
					}
					case 4: // MP5
					{
					if (GetPlayerMoney(playerid) < 500)
					return SendClientMessage(playerid, 0x999999AA, "You don't have enough cash to buy this Weapon.");
					GivePlayerMoney(playerid, -500);
					pInfo[playerid][pCash] -= 500;
					GivePlayerWeapon(playerid, 29, 150);
					return ShowPlayerDialog(playerid,DIALOG_WEAPONS,DIALOG_STYLE_TABLIST_HEADERS, "WEAPONS", "Weapon\tPrice\tAmmo\nSilenced 9mm\t$210\t70\nDesert Eagle\t$400\t50\nShotgun\t$320\t45\nCombat Shotgun\t$550\t65\nMP5\t$500\t150\nAK-47\t$600\t170\nM4\t$620\t170\nTEC-9\t$500\t150\nSniper Rifle\t$700\t30", "Buy", "Back");
					}
					case 5: // Ak-47
					{
					if (GetPlayerMoney(playerid) < 600)
					return SendClientMessage(playerid, 0xCC0000AA, "You don't have enough cash to buy this Weapon.");
					GivePlayerMoney(playerid, -600);
					pInfo[playerid][pCash] -= 600;
					GivePlayerWeapon(playerid, 30, 170);
					return ShowPlayerDialog(playerid,DIALOG_WEAPONS,DIALOG_STYLE_TABLIST_HEADERS, "WEAPONS", "Weapon\tPrice\tAmmo\nSilenced 9mm\t$210\t70\nDesert Eagle\t$400\t50\nShotgun\t$320\t45\nCombat Shotgun\t$550\t65\nMP5\t$500\t150\nAK-47\t$600\t170\nM4\t$620\t170\nTEC-9\t$500\t150\nSniper Rifle\t$700\t30", "Buy", "Back");
					}
					case 6: // M4
					{
					if (GetPlayerMoney(playerid) < 620)
					return SendClientMessage(playerid, 0xFF00FFAA, "You don't have enough cash to buy this Weapon.");
					GivePlayerMoney(playerid, -620);
					pInfo[playerid][pCash] -= 620;
					GivePlayerWeapon(playerid, 31, 170);
					return ShowPlayerDialog(playerid,DIALOG_WEAPONS,DIALOG_STYLE_TABLIST_HEADERS, "WEAPONS", "Weapon\tPrice\tAmmo\nSilenced 9mm\t$210\t70\nDesert Eagle\t$400\t50\nShotgun\t$320\t45\nCombat Shotgun\t$550\t65\nMP5\t$500\t150\nAK-47\t$600\t170\nM4\t$620\t170\nTEC-9\t$500\t150\nSniper Rifle\t$700\t30", "Buy", "Back");
					}
					case 7: // TEC-9
					{
					if (GetPlayerMoney(playerid) < 500)
					return SendClientMessage(playerid, 0xCCFF00AA, "You don't have enough cash to buy this Weapon.");
					GivePlayerMoney(playerid, -500);
					pInfo[playerid][pCash] -= 500;
					GivePlayerWeapon(playerid, 32, 150);
					return ShowPlayerDialog(playerid,DIALOG_WEAPONS,DIALOG_STYLE_TABLIST_HEADERS, "WEAPONS", "Weapon\tPrice\tAmmo\nSilenced 9mm\t$210\t70\nDesert Eagle\t$400\t50\nShotgun\t$320\t45\nCombat Shotgun\t$550\t65\nMP5\t$500\t150\nAK-47\t$600\t170\nM4\t$620\t170\nTEC-9\t$500\t150\nSniper Rifle\t$700\t30", "Buy", "Back");
					}
					case 8: // Sniper
					{
					if (GetPlayerMoney(playerid) < 700)
					return SendClientMessage(playerid, 0xFFFFFFAA, "You don't have enough cash to buy this Weapon.");
					GivePlayerMoney(playerid, -700);
					pInfo[playerid][pCash] -= 700;
					GivePlayerWeapon(playerid, 34, 30);
					return ShowPlayerDialog(playerid,DIALOG_WEAPONS,DIALOG_STYLE_TABLIST_HEADERS, "WEAPONS", "Weapon\tPrice\tAmmo\nSilenced 9mm\t$210\t70\nDesert Eagle\t$400\t50\nShotgun\t$320\t45\nCombat Shotgun\t$550\t65\nMP5\t$500\t150\nAK-47\t$600\t170\nM4\t$620\t170\nTEC-9\t$500\t150\nSniper Rifle\t$700\t30", "Buy", "Back");
					}
				}
			}
		}

		case DIALOG_VIP_CLASS:
		{
			if (response)
			{
				if (pInfo[playerid][pTeam] == TEAM_HUMAN)
				{
					switch (listitem)
					{
						case 0: if (pInfo[playerid][pVipLevel] >= 2) pInfo[playerid][pClass] = 0,pInfo[playerid][pClass] = VIPENGINEER,setClass(playerid); else { SendVipError(playerid,1); }
						case 1: if (pInfo[playerid][pVipLevel] >= 2) pInfo[playerid][pClass] = 0,pInfo[playerid][pClass] = VIPMEDIC,setClass(playerid); else { SendVipError(playerid,1); }
						case 2: if (pInfo[playerid][pVipLevel] >= 2) pInfo[playerid][pClass] = 0,pInfo[playerid][pClass] = VIPSCOUT,setClass(playerid); else { SendVipError(playerid,1); }

					}
				}
				else return SendClientMessage(playerid,-1,""chat""COL_LGREEN" You must be a human to use VIP classes!");
			}
		}

		case DIALOG_SKINS:
		{
			if ( !response ) return ShowPlayerDialog(playerid, DIALOG_WEAPONS_SHOP, DIALOG_STYLE_LIST, "{FFFFFF}SHOP", "Weapons\nSkins\nClasses\nToken Shop\nPerks", "Select", "Close");
			
			switch (listitem)
			{
				case 0: // Andre
				{
				if (GetPlayerMoney(playerid) < 50)
				return SendClientMessage(playerid, 0x33FF00AA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -50);
				pInfo[playerid][pCash] -= 50;
				SetPlayerSkin(playerid, 3);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 1: // Barry "Big Bear" Thorne [Big]
				{
				if (GetPlayerMoney(playerid) < 75)
				return SendClientMessage(playerid, 0x00FFFFAA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -75);
				pInfo[playerid][pCash] -= 75;
				SetPlayerSkin(playerid, 5);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 2: // The Truth
				{
				if (GetPlayerMoney(playerid) < 65)
				return SendClientMessage(playerid, 0x6600FFAA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -65);
				pInfo[playerid][pCash] -= 65;
				SetPlayerSkin(playerid, 1);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 3: // Homeless
				{
				if (GetPlayerMoney(playerid) < 30)
				return SendClientMessage(playerid, 0x99FF00AA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -30);
				pInfo[playerid][pCash] -= 30;
				SetPlayerSkin(playerid, 78);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 4: // Backpacker
				{
				if (GetPlayerMoney(playerid) < 100)
				return SendClientMessage(playerid, 0x999999AA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -100);
				pInfo[playerid][pCash] -= 100;
				SetPlayerSkin(playerid, 26);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 5: // The Russian Mafia
				{
				if (GetPlayerMoney(playerid) < 80)
				return SendClientMessage(playerid, 0xCC0000AA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -80);
				pInfo[playerid][pCash] -= 80;
				SetPlayerSkin(playerid, 112);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 6: // Johhny Sindacco
				{
				if (GetPlayerMoney(playerid) < 50)
				return SendClientMessage(playerid, 0xFF00FFAA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -50);
				pInfo[playerid][pCash] -= 50;
				SetPlayerSkin(playerid, 119);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 7: // Farm Inhabitant
				{
				if (GetPlayerMoney(playerid) < 500)
				return SendClientMessage(playerid, 0xCCFF00AA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -500);
				pInfo[playerid][pCash] -= 500;
				SetPlayerSkin(playerid, 128);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 8: // Big Smoke Armored
				{
				if (GetPlayerMoney(playerid) < 75)
				return SendClientMessage(playerid, 0xFFFFFFAA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -75);
				pInfo[playerid][pCash] -= 75;
				SetPlayerSkin(playerid, 149);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 9: // Black MIB agent
				{
				if (GetPlayerMoney(playerid) < 100)
				return SendClientMessage(playerid, 0xFFFFFFAA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -100);
				pInfo[playerid][pCash] -= 100;
				SetPlayerSkin(playerid, 166);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 10: // Jeffery "OG Loc" Martin/Cross
				{
				if (GetPlayerMoney(playerid) < 90)
				return SendClientMessage(playerid, 0xFFFFFFAA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -90);
				pInfo[playerid][pCash] -= 90;
				SetPlayerSkin(playerid, 293);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 11: // Claude Speed
				{
				if (GetPlayerMoney(playerid) < 150)
				return SendClientMessage(playerid, 0xFFFFFFAA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -150);
				pInfo[playerid][pCash] -= 150;
				SetPlayerSkin(playerid, 299);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
				case 12: // Michael Toreno
				{
				if (GetPlayerMoney(playerid) < 200)
				return SendClientMessage(playerid, 0xFFFFFFAA, "You don't have enough cash to buy this Skin.");
				GivePlayerMoney(playerid, -200);
				pInfo[playerid][pCash] -= 200;
				SetPlayerSkin(playerid, 295);
				return ShowPlayerDialog(playerid,DIALOG_SKINS,DIALOG_STYLE_TABLIST_HEADERS, "SKINS", "Skin\tPrice\nAndre\t$50\nBarry \"Big Bear\" Thorne\t$75\nTruth\t$65\nUnemployed\t$100\nBackpacker\t$80\nMafia Boss\t$50\nJohhny Sindacco\t$75\nFarm Inhabitant\t$100\nBig Smoke Armored\t$100\nBlack MIB agent\t$90\nJeffrey \"OG Loc\" Cross\t$150\nClaude Speed\t$200\nMichael Toreno\t$190","Buy","Back");
				}
			}
		}

		case DIALOG_COINS_TOYS:
		{
			if ( !response ) return ShowPlayerDialog(playerid, DIALOG_WEAPONS_SHOP, DIALOG_STYLE_LIST, "{FFFFFF}SHOP", "Weapons\nSkins\nClasses\nToken Shop\nPerks", "Select", "Close");
			
			switch (listitem)
			{
				case 0: if (pInfo[playerid][pCoins] >= 1) pInfo[playerid][pCoins] -= 1,SetPlayerAttachedObject(playerid, 0, 1550, 1, -0.029999, -0.159999, -0.019999, -180.000000, 85.000000, -10.000000); else { SendCoinError(playerid,1); }
				case 1: if (pInfo[playerid][pCoins] >= 1) pInfo[playerid][pCoins] -= 1,SetPlayerAttachedObject(playerid, 0, 19078, 3, -0.042999, 0.010000, -0.043999, 161.399993, 166.699981, -3.700001, 1.000000, 1.000000, 1.000000, 0, 0); else { SendCoinError(playerid,1); }
				case 2: if (pInfo[playerid][pCoins] >= 1) pInfo[playerid][pCoins] -= 1,SetPlayerAttachedObject(playerid, 0, 18963, 2, 0.064000, 0.032999, -0.000999, 84.699981, 93.199989, 0.000000, 1.179999, 1.385999, 1.429999, 0, 0); else { SendCoinError(playerid,1); }
				case 3: if (pInfo[playerid][pCoins] >= 1) pInfo[playerid][pCoins] -= 1,SetPlayerAttachedObject(playerid, 0, 19137, 2, 0.114000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0); else { SendCoinError(playerid,1); }
				case 4: if (pInfo[playerid][pCoins] >= 1) pInfo[playerid][pCoins] -= 1,SetPlayerAttachedObject(playerid, 0, 19036, 2, 0.097000, -0.002999, 0.000000, 90.099983, 79.099975, 0.000000, 1.012000, 1.000000, 1.000000, 0, 0); else { SendCoinError(playerid,1); }
				case 5: if (pInfo[playerid][pCoins] >= 1) pInfo[playerid][pCoins] -= 1,SetPlayerAttachedObject(playerid, 0, 19847, 5, 0.088000, 0.005000, -0.048000, 52.799999, -3.099998, 1.699998, 1.000000, 1.000000, 1.000000, 0, 0); else { SendCoinError(playerid,1); }
				case 6: if (pInfo[playerid][pCoins] >= 1) pInfo[playerid][pCoins] -= 1,SetPlayerAttachedObject(playerid, 0, 19320, 2, 0.111000, 0.000000, 0.012000, 1.700000, 77.500007, 0.000000, 0.476000, 0.457000, 0.588999, 0, 0); else { SendCoinError(playerid,1); }
			}

			return 1;
		}

		case DIALOG_COINS: { // Modified by Logic_
			if (!response) return 1;

			if (pInfo[playerid][pTeam] != TEAM_HUMAN) return 1;
			
			switch (listitem) {
				case 0: {
					if (pInfo[playerid][pCoins] < 45) return SendCoinError(playerid, 45);

					pInfo[playerid][pCoins] -= 45;
					pInfo[playerid][pKickBackCoin] = 1;
				}
				
				case 1: {
					if (pInfo[playerid][pCoins] < 40) return SendCoinError(playerid, 40);

					pInfo[playerid][pCoins] -= 40;
					pInfo[playerid][pDamageShotgunCoin] = 1;
				}

				case 2: {
					if (pInfo[playerid][pCoins] < 50) return SendCoinError(playerid, 50);

					pInfo[playerid][pCoins] -= 50;
					pInfo[playerid][pDamageDeagleCoin] = 1;
				}

				case 3: {
					if (pInfo[playerid][pCoins] < 30) return SendCoinError(playerid, 30);

					pInfo[playerid][pCoins] -= 30;
					pInfo[playerid][pDamageMP5Coin] = 1;
				}

				case 4: {
					if (pInfo[playerid][pCoins] < 25) return SendCoinError(playerid, 25);

					pInfo[playerid][pCoins] -= 25;
					SetPlayerAttachedObject(playerid,0,19142,1,0.028000,0.034000,0.000000,0.000000,0.000000,0.000000,1.063000,1.191999,1.285999);
				}

				case 5: {
					ShowPlayerDialog(playerid,DIALOG_COINS_TOYS,DIALOG_STYLE_LIST,"ACCESSORIES","Money Bag\nParrot\nCJ's Head\nCluckinBell Hat\nHockey Mask\nMeat\nPumpkin","Select","Back");
				}
			}

			return 1;
		}
	}
	
	return 0;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SendDeathMessage(killerid, playerid, reason);

	pInfo[playerid][pTeam] = TEAM_ZOMBIE;

	if (killerid != INVALID_PLAYER_ID)
	{
		pInfo[killerid][pKills]++;
		pInfo[killerid][Killstreak]++;

		UpdateKillStatsTD(killerid);

		switch (pInfo[killerid][pTeam])
		{
			case TEAM_ZOMBIE: pInfo[killerid][pRoundKills]++;
			case TEAM_HUMAN: pInfo[killerid][pRoundZombies]++;
		}

		new gunname[32],
			string[100],
			xp_type = Map[XPType],
			player_xp = 10 * xp_type,
			player_money = 1000 * xp_type;

		if (pInfo[killerid][pVipLevel]) {

			player_xp += 5;
			player_money += 250;
		}

		format(string, sizeof string, "~n~~n~~n~~n~~n~~y~+%i XP ~n~~g~+$%i", player_xp, player_money);
		GameTextForPlayer(killerid, string, 3000, 5);

		GivePlayerXP(killerid, player_xp);
		GivePlayerMoney(killerid, player_money);

		GetWeaponName(reason, gunname, sizeof gunname);
		format(string, sizeof string,"You have killed~r~ %s~w~ with an %s", GetPlayerNameEx(playerid), gunname);
		TextDrawSetString(iKilled[killerid],string);
		TextDrawShowForPlayer(killerid, iKilled[killerid]);
		
		SetTimerEx("HideiKilled", 3000, 0, "i", killerid);

		CheckPlayerKillStreak(killerid);
		
		CheckToLevelOrRankUp(killerid);
	}
	else
	{
		UpdateDeathsTextdraw(playerid);
	}

	playersAliveCount--;

	pInfo[playerid][pRoundDeaths]++;
	pInfo[playerid][pDeaths] ++;
	pInfo[playerid][Killstreak] = pInfo[playerid][Minigun] = 0;

	KillTimer(pInfo[playerid][IsPlayerInfectedTimer]);
	if (pInfo[playerid][IsPlayerInfected] == 1) CurePlayer(playerid);

	if (IsBeingSpeced[playerid])
	{
		foreach(new i : Player)
		{
			if (spectatorid[i] != playerid) continue;

			TogglePlayerSpectating(i, false);
			SpawnPlayer(i);
		}
	}

	if (pInfo[playerid][pTeam] == TEAM_ZOMBIE && pInfo[playerid][pClass] == BOOMERZOMBIE)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,Float:x,Float:y,Float:z);
		CreateExplosion(Float:x,Float:y,Float:z,0,6.0);
		
		foreach(new i : Player)
		{
			if (GetPlayerSkin(i) == NON_IMMUNE)
			{
				if (IsPlayerInRangeOfPoint(i,7.0,Float:x,Float:y,Float:z))
					if (!pInfo[i][IsPlayerInfected])
						InfectPlayerStandard(i);
			}
		}
	}

	hideTextdrawsAfterConnect(playerid);
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		if (IsBeingSpeced[playerid] == 1)
		{
			foreach(new i : Player)
			{
				if (spectatorid[i] == playerid)
				{
					PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
				}
			}
		}
	}
	if (newstate == PLAYER_STATE_ONFOOT)
	{
		if (IsBeingSpeced[playerid] == 1)
		{
			foreach(new i : Player)
			{
				if (spectatorid[i] == playerid)
				{
					PlayerSpectatePlayer(i, playerid);
				}
			}
		}
	}
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	if (IsBeingSpeced[playerid] == 1)
	{
		foreach(new i : Player)
		{
			if (spectatorid[i] == playerid)
			{
				SetPlayerInterior(i,GetPlayerInterior(playerid));
				SetPlayerVirtualWorld(i,GetPlayerVirtualWorld(playerid));
			}
		}
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{

	new Float:HP;
	GetPlayerHealth(playerid, HP);
	if (pInfo[issuerid][pTeam] != pInfo[playerid][pTeam])
	{
		if (weaponid == 4)
		{
			SetPlayerHealth(playerid, HP-35);
		}
	}

	if (pInfo[issuerid][pTeam] == TEAM_HUMAN)
	{
		if (pInfo[issuerid][pClass] == KICKBACK || pInfo[issuerid][pVipKickBack] == 1 || pInfo[issuerid][pKickBackCoin])
		{
			if (pInfo[playerid][pTeam] == TEAM_ZOMBIE)
			{
				if (weaponid == 23 || weaponid == 25 || weaponid == 24 || weaponid == 34 || weaponid == 31)
				{
					new Float:x,Float:y,Float:z,Float:angle;
					GetPlayerFacingAngle(playerid,Float:angle);
					GetPlayerVelocity(playerid,Float:x,Float:y,Float:z);

					SetPlayerVelocity(playerid,Float:x+0.1,Float:y+0.1,Float:z+0.2);
					SetPlayerFacingAngle(playerid,Float:angle);
				}
			}
		}
	}

	if (pInfo[issuerid][pTeam] == TEAM_HUMAN)
	{
		if (pInfo[issuerid][pClass] == VIPSCOUT)
		{
			if (pInfo[playerid][pTeam] == TEAM_ZOMBIE)
			{
				if (weaponid == 34)
				{
					SetPlayerHealth(playerid, -0);
				}
			}
		}
	}

	if (pInfo[issuerid][pTeam] == TEAM_HUMAN)
	{
		if (pInfo[issuerid][pClass] == SCOUT || pInfo[issuerid][pClass] == HEAVYSHOTGUN || pInfo[issuerid][pClass] == KICKBACK || pInfo[issuerid][pDamageShotgunCoin] == 1)
		{
			if (pInfo[playerid][pTeam] == TEAM_ZOMBIE)
			{
				if (weaponid == 34 || 25)
				{
					new Float:hp;
					GetPlayerHealth(playerid,hp);
					SetPlayerHealth(playerid, hp - 45);
				}
			}
		}
	}

	if (pInfo[issuerid][pTeam] == TEAM_HUMAN)
	{
		if (pInfo[issuerid][pDamageMP5Coin] == 1 || pInfo[issuerid][pDamageDeagleCoin] == 1)
		{
			if (pInfo[playerid][pTeam] == TEAM_ZOMBIE)
			{
				if (weaponid == 24 || 29)
				{
					new Float:hp;
					GetPlayerHealth(playerid,hp);
					SetPlayerHealth(playerid, hp - 45);
				}
			}
		}
	}

	if (pInfo[issuerid][pTeam] == TEAM_HUMAN && pInfo[issuerid][pClass] == SNIPER)
	{
		if (pInfo[playerid][pTeam] == TEAM_ZOMBIE)
		{
			if (weaponid == WEAPON_SNIPER && bodypart == BODY_PART_HEAD)
			{
				SetPlayerHealth(playerid, -0);
				GameTextForPlayer(playerid, "~n~~r~HEADSHOT", 3000, 3);
				GameTextForPlayer(issuerid, "~n~~g~HEADSHOT", 3000, 3);
				
				new Float:x, Float:y, Float:z, Float:fDistance, hsMessage[90];
				GetPlayerPos(playerid, x, y, z);
				fDistance = GetPlayerDistanceFromPoint(issuerid, x, y, z);

				format(hsMessage, sizeof(hsMessage), "{DC143C}%s has Headshotted {FFFFFF}%s{DC143C} from the distance of %0.2f", GetPlayerNameEx(issuerid), GetPlayerNameEx(playerid), fDistance);
				SendClientMessageToAll(-1, hsMessage);
				pInfo[issuerid][pHeads]++;
			}
		}
	}
	return 1;
}

public OnPlayerText(playerid, text[]) { // Updated by Logic_

	if (!pInfo[playerid][pLogged]) return 0;

	if (!GetPVarInt(playerid, "SPS Muted")) return SendClientMessage(playerid, -1, ""chat""COL_LIGHTBLUE" {99CCFF}You are muted, you can't talk."), 0;

	SetPVarInt(playerid, "SPS Messages Sent", GetPVarInt(playerid, "SPS Messages Sent") + 1);
	SetTimerEx("SPS_Remove_Messages_Limit", 1500, 0, "i", playerid);

	if (GetPVarInt(playerid, "SPS Messages Sent") >= 4) {
		if (!(((GetPVarInt(playerid, "SPS Spam Warnings") + 2) == 3))) {
			SendClientMessage(playerid, -1, ""chat""COL_LIGHTBLUE" {99CCFF}Please, do not spam.");
		}
		SetPVarInt(playerid, "SPS Spam Warnings", GetPVarInt(playerid, "SPS Spam Warnings") + 1);
	}

	if (pInfo[playerid][Muted] == 1) SendClientMessage(playerid,-1,""chat" {99CCFF}You are muted.");

	if (strfind(text, ":", true) != -1) {
		new i_numcount, i_period, i_pos;
		while(text[i_pos]) {
			if ('0' <= text[i_pos] <= '9') i_numcount ++;
			else if (text[i_pos] == '.') i_period ++;
			i_pos++;
		}
		if (i_numcount >= 8 && i_period >= 3) {
			BanPlayer(playerid, "Possible Adv", INVALID_PLAYER_ID);
			return 0;
		}
	}

	// Added by Logic_
	new string[144];
	format(string, sizeof string, "%s"COL_WHITE"(%d): %s", GetPlayerNameEx(playerid), playerid, text);
	SendClientMessageToAll(GetPlayerColor(playerid), string);
	return 0;
}

PlantBomb(playerid) { // A completely new bomb system made from Scratch by Logic_
	if (!pInfo[playerid][pBombs]) return NotifyPlayer(playerid, "~r~You don't have any bombs left.");

	new Float: x, Float: y, Float: z, string[40];

	GetPlayerPos(playerid, x, y, z);
	pInfo[playerid][pBombs] -= 1;
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 2000);

	format(string, sizeof(string),""chat" You have %i bombs left.", pInfo[playerid][pBombs]);
	SendClientMessage(playerid,-1,string);

	new index;
	if ((index = GetFreeBombID()) == -1) return NotifyPlayer(playerid, "~r~No more bombs can be placed!");
	
	gBomb[index][E_BOMB_OBJECT] = CreateDynamicObject(1252, x, y, z - 0.25, 0.0, 0.0, 90.0);
	gBomb[index][E_BOMB_PLAYERID] = playerid;

	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	return 1;
}

TerroristBomb() {
	new i, Float: distance, Float: x, Float: y, Float: z;

	for (; i < MAX_BOMBS; i++) {
		if (gBomb[i][E_BOMB_PLAYERID] == INVALID_PLAYER_ID) continue;

		foreach (new j : Player) {
			
			if (pInfo[j][pTeam] == TEAM_HUMAN)
				continue;

			GetPlayerPos(j, x, y, z);

			Streamer_GetDistanceToItem(x, y, z, STREAMER_TYPE_OBJECT, gBomb[i][E_BOMB_OBJECT], distance);

			if (distance <= 1.0) {
				CreateExplosion(x, y, z, 3, 20.0);
				DestroyDynamicObject(gBomb[i][E_BOMB_OBJECT]);

				gBomb[i][E_BOMB_OBJECT] = INVALID_OBJECT_ID;
				gBomb[i][E_BOMB_PLAYERID] = INVALID_PLAYER_ID;
				
				// You can add a function to send the bomber some XP or cash!
			}
		}
	}
	return 1;
}

GetFreeBombID() {
	for (new i; i < MAX_BOMBS; i++) {
		if (gBomb[i][E_BOMB_PLAYERID] != INVALID_PLAYER_ID) continue;

		return i;
	}

	return -1;
}

ResetBombs() {
	for (new i; i < MAX_BOMBS; i++) {
		gBomb[i][E_BOMB_PLAYERID] = INVALID_PLAYER_ID;

		if (IsValidDynamicObject(gBomb[i][E_BOMB_OBJECT])) DestroyDynamicObject(gBomb[i][E_BOMB_OBJECT]);
		gBomb[i][E_BOMB_OBJECT] = INVALID_OBJECT_ID;
	}

	return 1;
}

GetFreeShieldID() { // Completely new scratch written Shield system by Logic_
	for (new i; i < MAX_SHIELDS; i++) {
		if (gShields[i][E_SHIELD_PLAYERID] != INVALID_PLAYER_ID) continue;

		return i;
	}
	return -1;
}

PlantShield(playerid) {
	if (!pInfo[playerid][pDoctorShield]) return NotifyPlayer(playerid, "~r~You don't have any shields left.");

	new Float:pz, Float:x, Float:y, Float:z, string[40];
	
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, pz);
	pInfo[playerid][pDoctorShield] -= 1;

	format(string, sizeof string,""chat" You have %i Scientist shields left.",pInfo[playerid][pDoctorShield]);
	SendClientMessage(playerid,-1,string);
	
	new index;
	if ((index = GetFreeShieldID()) == -1) return NotifyPlayer(playerid, "~r~No more shields can be placed!");

	GetXYInFrontOfPlayer(playerid,  x, y, 1.0);
	gShields[index][E_SHIELD_OBJECT] = CreateDynamicObject(3534, x, y, z, 0.0, 0.0, pz);
	gShields[index][E_SHIELD_PLAYERID] = playerid;
	
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	return 1;
}

ResetShields() {
	for (new i; i < MAX_SHIELDS; i++) {
		gShields[i][E_SHIELD_PLAYERID] = INVALID_PLAYER_ID;

		if (IsValidDynamicObject(gShields[i][E_SHIELD_OBJECT])) DestroyDynamicObject(gShields[i][E_SHIELD_OBJECT]);
		gShields[i][E_SHIELD_OBJECT] = INVALID_OBJECT_ID;
	}
	return 1;
}

DoctorShield() {

	new i, Float: distance, Float: x, Float: y, Float: z, Float: health;

	for (; i < MAX_SHIELDS; i++) {
		if (gShields[i][E_SHIELD_PLAYERID] == INVALID_PLAYER_ID) continue;

		foreach (new j : Player) {
			if (pInfo[j][pTeam] != TEAM_HUMAN) continue; 

			GetPlayerPos(j, x, y, z);

			Streamer_GetDistanceToItem(x, y, z, STREAMER_TYPE_OBJECT, gShields[i][E_SHIELD_OBJECT], distance);

			if (distance <= 5.0) {
				GetPlayerHealth(j, health);
				
				if (health <= 80.0) {
					SetPlayerHealth(j, health + 3.5);

					NotifyPlayer(j, "~n~~n~~n~~n~~g~GETTING HEALED BY DOCTOR SHIELD!");
				}
			}
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) { // Modified by Logic_
	
	if (newkeys == KEY_NO && pInfo[playerid][pTeam] == TEAM_ZOMBIE && pInfo[playerid][pSpawned]) {
		KillTimer(pASK_Timer[playerid]);
		EndAntiSpawnKill(playerid);
		SendClientMessage(playerid, 0xFFFFF55, "{ffffff}[{33FF99}ANTI-SK{ffffff}]: You Have Ended Your Spawn Protection.");
	}

	if (PRESSED(KEY_FIRE)) {
		
		new vehicleid = GetPlayerVehicleID(playerid);
		if (GetVehicleModel(vehicleid) == 564 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {

			new Float:x,Float:y,Float:z,Float:x2,Float:y2,Float:az;
			GetPlayerPos(playerid,x,y,z);
			GetVehicleZAngle(GetPlayerVehicleID(playerid), az);
			x2 = x + (30 * floatsin(-az+5, degrees));
			y2 = y + (30 * floatcos(-az+5, degrees));
			CreateExplosion(x2,y2,z,3,4.0);
		}
		else {
			if (pInfo[playerid][pTeam] == TEAM_HUMAN) {
				if (GetPlayerWeapon(playerid) == WEAPON_CHAINSAW) {
					ShowPlayerDialog(playerid,DIALOG_KICK,DIALOG_STYLE_MSGBOX,"Bugged!","You have been kicked due to chainsaw bug.\n Please reconnect, to solve the problem. Thank you!","Leave","");
					return KickPlayer(playerid), 1;
				}
			}
			else {
				if (pInfo[playerid][pClass] == TANKERZOMBIE) {
					if (gettime() - 1 < Abilitys[playerid][StomperPushing]) return GameTextForPlayer(playerid,"~r~ Still recovering", 1000, 5);

					new Float: x, Float: y, Float: z;

					GetPlayerPos(playerid,Float:x,Float:y,Float:z);
					foreach (new i : Player) {
						if (GetPlayerSkin(playerid) != NON_IMMUNE) continue;

						if (GetDistanceBetweenPlayers(playerid, i) < 2.0) {
							new Float: hp, victimid = GetClosestPlayer(playerid);

							SetPlayerHealth(victimid, hp -20);
							GetPlayerVelocity(i,Float:x,Float:y,Float:z);
							SetPlayerVelocity(i,Float:x+0.3,Float:y+0.3,Float:z+0.2);

							GivePlayerXP(playerid,10);
							GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~y~+10 XP",3500,5);
							Abilitys[playerid][StomperPushing] = gettime();
						}
					}
				}
			}
		}
	}

	else if (PRESSED(KEY_JUMP))
	{
		if (pInfo[playerid][pTeam] == TEAM_ZOMBIE && pInfo[playerid][pClass] == HUNTERZOMBIE)
		{
			if (gettime() - 2 < Abilitys[playerid][HighJumpZombie]) return GameTextForPlayer(playerid,"~w~ Still recovering",1000,5);

			new Float:x,Float:y,Float:z;
			GetPlayerVelocity(playerid, x, y, z);
			SetPlayerVelocity(playerid, x*4.0, y*4.0, z + 0.8 * 1.2);
			Abilitys[playerid][HighJumpZombie] = gettime();
		}
	}

	else if (PRESSED(KEY_WALK)) {
		if (pInfo[playerid][pTeam] == TEAM_HUMAN) {
			switch (pInfo[playerid][pClass]) {

				case ENGINEER: {
					new Float:pz, Float:x, Float:y, Float:z;
					GetPlayerFacingAngle(playerid, pz);
					GetPlayerPos(playerid, Float:x, Float:y, Float:z);

					if (pInfo[playerid][pLadders] >= 1)
					{
						new string[128];
						pInfo[playerid][pLadders] -= 1;
						GetXYInFrontOfPlayer(playerid, Float:x,Float:y, 1.0);
						CreateObject(1437,Float:x,Float:y,Float:z,-22.0,0.0,pz,500.0);
						format(string, sizeof string,""chat" You have %i ladders left.",pInfo[playerid][pLadders]);
						SendClientMessage(playerid,-1,string);
						PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
					}
					else return SendClientMessage(playerid,-1,""chat" You ran out of Ladders!");
				}

				case VIPENGINEER: {
					new Float:pz, Float:x, Float:y, Float:z;
					GetPlayerFacingAngle(playerid, pz);
					GetPlayerPos(playerid, Float:x, Float:y, Float:z);

					if (pInfo[playerid][pVipBoxes] >= 1)
					{
						new string[128];
						pInfo[playerid][pVipBoxes] -= 1;
						GetXYInFrontOfPlayer(playerid, Float:x,Float:y, 1.0);
						CreateObject(1421,Float:x,Float:y,Float:z,0.0,0.0,pz,500.0);
						format(string, sizeof string,""chat" You have %i boxes left.",pInfo[playerid][pVipBoxes]);
						SendClientMessage(playerid,-1,string);
						PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
					}
					else return SendClientMessage(playerid,-1,""chat" You ran out of boxes!");
				}

				case DOCTOR: {
					PlantShield(playerid);
				}

				case TERRORIST: {
					PlantBomb(playerid);
				}

				case MEDIC: {
					new victimid = GetClosestPlayer(playerid);
					
					switch (GetPlayerSkin(victimid))
					{
						case NON_IMMUNE:
						{
							if (GetDistanceBetweenPlayers(playerid,victimid) > 10.0) return 1;

							if (pInfo[victimid][IsPlayerInfected]) {
								CurePlayer(victimid);
								GivePlayerXP(playerid,10);
								GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~y~+10 XP",3500,5);
							}
							else return SendClientMessage(playerid,-1,""chat" No one around you is infected.");
						}
					}
				}

				case SCOUT: {
					if (gettime() - 6 < Abilitys[playerid][HighJumpScout]) return GameTextForPlayer(playerid,"~w~ Still recovering",1000,5);

					new Float:x,Float:y,Float:z;
					GetPlayerVelocity(playerid,Float:x,Float:y,Float:z);
					SetPlayerVelocity(playerid,Float:x,Float:y*0.9,Float:z+0.5* 0.9);
					Abilitys[playerid][HighJumpScout] = gettime();
				}
			}
		}
		else {
			switch (pInfo[playerid][pClass]) {
				case STOMPERZOMBIE: {
					if (gettime() - 6 < Abilitys[playerid][StomperPushing]) return GameTextForPlayer(playerid,"~w~ Still recovering",1000,5);

					new Float:x,Float:y,Float:z;
					GetPlayerPos(playerid,Float:x,Float:y,Float:z);
					ApplyAnimation(playerid, "ped", "Shove_Partial", 2.1, 0, 0, 0, 0, 0);

					foreach(new i : Player)
					{
						switch (GetPlayerSkin(i))
						{
							case NON_IMMUNE,163:
							{
								if (GetDistanceBetweenPlayers(playerid,i) < 6.0)
								{
									GetClosestPlayer(i);
									GetPlayerVelocity(i,Float:x,Float:y,Float:z);
									SetPlayerVelocity(i,Float:x+0.3,Float:y+0.3,Float:z+0.2);
									GivePlayerXP(playerid,10);
									GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~y~+10 XP",3500,5);
									Abilitys[playerid][StomperPushing] = gettime();
								}
							}
						}
					}
				}

				case MUTATEDZOMBIE: {
					if (gettime() - 10 < Abilitys[playerid][AdvancedMutatedCooldown]) return GameTextForPlayer(playerid,"~w~ Still recovering",1000,5);

					foreach(new i : Player)
					{
						switch (GetPlayerSkin(i))
						{
							case NON_IMMUNE, 70:
							{
								if (GetDistanceBetweenPlayers(playerid, i) > 6.5) continue;

								if (pInfo[i][IsPlayerInfected] == 0)
								{
									InfectPlayerMutated(i);
									GivePlayerXP(playerid,10);
									GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~y~+10 XP",3500,5);
									Abilitys[playerid][AdvancedMutatedCooldown] = gettime();
								}
							}
						}
					}
				}

				case SCREAMERZOMBIE: {
					if (gettime() - 12 < Abilitys[playerid][ScreamerZombieAb2]) return GameTextForPlayer(playerid,"~w~ Still recovering",1000,5);

					foreach(new i : Player)
					{
						switch (GetPlayerSkin(i))
						{
							case NON_IMMUNE:
							{
								if (GetDistanceBetweenPlayers(playerid,i) > 8.0) continue;

								new Float:hp;
								GetClosestPlayer(i);
								ApplyAnimation(i, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
								GameTextForPlayer(i,"~n~~n~~n~~n~~g~Screamer Attacked",3500,5);
								SetTimerEx("ScreamerClearAnim",1500,0,"i",i);
								GivePlayerXP(playerid,10);
								GetPlayerHealth(playerid,hp);
								Abilitys[playerid][ScreamerZombieAb2] = gettime();
								if (hp <= 80)
								{
									GetPlayerHealth(playerid,hp);
									SetPlayerHealth(playerid,hp+10);
								}
								else return SendClientMessage(playerid,-1,""chat""COL_PINK" {E5CCFF}Screamed sucessfully, but was not able to gain HP, because you have enough HP (80).");
							}
						}
					}
				}

				case SEEKER: {
					if (gettime() - 30 < Abilitys[playerid][StomperPushing]) return GameTextForPlayer(playerid,"~w~ Still recovering",1000,5);
					new Float:x,Float:y,Float:z;
					foreach(new i : Player)
					{
						if (pInfo[i][pTeam] == TEAM_HUMAN)
						{
							GetClosestPlayer(i);
							GetPlayerPos(i,x,y,z);
							SetPlayerPos(playerid,x,y,z);
							Abilitys[playerid][StomperPushing] = gettime();
							break;
						}
					}
				}

				case ROGUE: {
					if (gettime() - 30 < Abilitys[playerid][StomperPushing]) return GameTextForPlayer(playerid,"~w~ Still recovering",1000,5);

					SetPlayerColor(playerid,COLOR_HUMAN);
					SetPlayerSkin(playerid,15);
					SetTimerEx("RogueTimer", 30000, 0, "i", playerid);
					Abilitys[playerid][StomperPushing] = gettime();
				}

				case WITCHZOMBIE: {
					new victimid = GetClosestPlayer(playerid);

					if (pInfo[victimid][pAdminDuty]) return 1;

					switch (GetPlayerSkin(victimid)) {
						case NON_IMMUNE, 68, 70: {
							if (GetDistanceBetweenPlayers(playerid,victimid) > 1.5) return 1;
							if (gettime() - 15 < Abilitys[playerid][WitchAttack2]) return GameTextForPlayer(playerid, "~w~ Still recovering", 4000, 5);

							new Float:hp, zmstring[144];
							GetPlayerHealth(victimid,hp);
							SetPlayerHealth(victimid, hp -45);
							GameTextForPlayer(victimid,"~n~~n~~n~~n~~y~Witch attacked",3000,5);
							GivePlayerXP(playerid,10);
							format(zmstring,sizeof(zmstring), ""chat""COL_PINK" {66B2FF}%s{E5CCFF} has been witch attacked by {FF6666}%s", GetPlayerNameEx(victimid), GetPlayerNameEx(playerid));
							SendClientMessageToAll(-1,zmstring);
							Abilitys[playerid][WitchAttack2] = gettime();
						}
					}
				}

				case STANDARDZOMBIE: {
					new victimid = GetClosestPlayer(playerid);

					if (gettime() - 7 < Abilitys[playerid][InfectionNormal]) return GameTextForPlayer(playerid,"~b~ Still recovering",4000,5);

					if (pInfo[victimid][pAdminDuty]) return 1;
					if (pInfo[victimid][IsPlayerInfected]) return 1;

					switch (GetPlayerSkin(victimid))
					{
						case NON_IMMUNE, 70:
						{
							if (GetDistanceBetweenPlayers(playerid,victimid) > 2.0) return 1;

							new zmstring[256];
							InfectPlayerStandard(victimid);
							format(zmstring,sizeof(zmstring), ""chat""COL_PINK" {66B2FF}%s{E5CCFF} has been infected by {FF6666}%s",GetPlayerNameEx(victimid), GetPlayerNameEx(playerid));
							SendClientMessageToAll(-1,zmstring);
							GivePlayerXP(playerid,10);
							GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~y~+10 XP",3500,5);
							Abilitys[playerid][InfectionNormal] = gettime();
						}
					}
				}

				case SMOKERZOMBIE: {
					new victimid = GetClosestPlayer(playerid);

					if (gettime() - 7 < Abilitys[playerid][InfectionNormal]) return GameTextForPlayer(playerid,"~b~ Still recovering",4000,5);

					if (pInfo[victimid][pAdminDuty]) return 1;
					if (pInfo[victimid][IsPlayerInfected]) return 1;

					switch (GetPlayerSkin(victimid)) {
						case NON_IMMUNE, 70: {
							if (GetDistanceBetweenPlayers(playerid,victimid) > 2.0) return 1;
							
							new zmstring[256];
							InfectPlayerStandard(victimid);
							smokegas[playerid] = SetPlayerAttachedObject(playerid, 7, 18729, 18, -2.2709, 1.1330, -5.0079, -6.0999, 109.2999, -98.0999, 1.0000, 1.0000, 1.0000, 0, 0);
							SetTimerEx("Smoke",5000,0,"i",playerid);
							format(zmstring,sizeof(zmstring), ""chat""COL_PINK" {66B2FF}%s{E5CCFF} has been infected by {FF6666}%s",GetPlayerNameEx(victimid), GetPlayerNameEx(playerid));
							SendClientMessageToAll(-1,zmstring);
							GivePlayerXP(playerid,10);
							GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~y~+10 XP",3500,5);
							Abilitys[playerid][InfectionNormal] = gettime();
						}
					}
				}

				case BOOMERZOMBIE: {
					if (IsPlayerInRangeOfPoint(playerid,7.0,Map[ZombieSpawnX],Map[ZombieSpawnY],Map[ZombieSpawnZ])) return GameTextForPlayer(playerid,"~r~You Can't explode near the Zombie spawn!",4000,5);
					
					new Float:x,Float:y,Float:z;
					GetPlayerPos(playerid,Float:x,Float:y,Float:z);
					SetPlayerHealth(playerid,0.0);
					CreateExplosion(Float:x,Float:y,Float:z,0,6.0);
					foreach(new i : Player)
					{
						switch (GetPlayerSkin(i))
						{
							case NON_IMMUNE:
							{
								if (IsPlayerInRangeOfPoint(i,7.0,Float:x, Float:y, Float:z))
								{
									if (!pInfo[i][IsPlayerInfected]) InfectPlayerStandard(i);
								}
							}
						}
					}
				}

				case FLESHEATER: {
					new victimid = GetClosestPlayer(playerid);
					if (gettime() - 18 < Abilitys[playerid][InfectionFleshEater]) return GameTextForPlayer(playerid,"~b~ Still recovering",4000,5);

					if (GetDistanceBetweenPlayers(playerid,victimid) > 1.7) return 1;
					switch (GetPlayerSkin(victimid))
					{
						case NON_IMMUNE:
						{
							if (pInfo[victimid][IsPlayerInfected] == 0)
							{
								new zmstring[256];
								InfectPlayerFleshEater(victimid);
								format(zmstring,sizeof(zmstring), ""chat""COL_PINK" {66B2FF}%s{E5CCFF} has been bitten and infected by {FF6666}%s",GetPlayerNameEx(victimid), GetPlayerNameEx(playerid));
								SendClientMessageToAll(-1,zmstring);
								GivePlayerXP(playerid,10);
								GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~y~+10 XP",3500,5);
								Abilitys[playerid][InfectionFleshEater] = gettime();
							}
							else return SendClientMessage(playerid,-1,""chat" Player is already infected!");
						}
					}
				}
			}
		}
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid) {
	BanPlayer(playerid, "Vehicle Modding", INVALID_PLAYER_ID);
	return 0;
}

GetPlayerSpeedSpeedo(playerid, bool:kmh) {
	new Float:Vx, Float:Vy, Float:Vz, Float:rtn;
	if (IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz);
	else GetPlayerVelocity(playerid,Vx,Vy,Vz);
	
	rtn = floatsqroot(floatabs(floatpower(Vx + Vy + Vz,2)));
	rtn = rtn * 100;
	return kmh ? floatround(rtn * 1.61) : floatround(rtn);
}

public OnPlayerUpdate(playerid) {
	// ...
	return 1;
}

forward AntiCheat();
public AntiCheat() {
	
	new Float:x, Float:y, Float:z, str[65], weaponid;

	foreach(new i : Player) {
		weaponid = GetPlayerWeapon(i);
		GetPlayerVelocity(i, x, y, z);

		if ((x <= -0.800000  || y <= -0.800000 || z <= -0.800000) && GetPlayerAnimationIndex(i) == 1008) {
			format(str, sizeof str, "[AC] Fly hack detected on %s (%d).", GetPlayerNameEx(i), i);
			SendMessageToAdmins(str, COLOR_RED);
		}

		if (GetPlayerSpeedSpeedo(i, true) > 400) {
			format(str, sizeof str, "[AC] Speed hacks detected on %s (%d).", GetPlayerNameEx(i), i);
			SendMessageToAdmins(str, COLOR_RED);
		}

		switch (weaponid) {
			case 38: {
				if (pInfo[i][Minigun]) continue;
				
				BanPlayer(i, "Minigun hack", INVALID_PLAYER_ID);
			}
			
			case 2,3,5,6,7,8,9,10,11,12,13,14,15,18,26,28,35,36,37,39,40,41,42,43,44,45,46: {
				BanPlayer(i, "Weapon Hack", INVALID_PLAYER_ID);
			}
		}

		if (IsPlayerInWater(i)) {
			SetPlayerHealth(i, 0.0);
		}
	}

	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success) {
	
	if (!success) {

		PlayerPlaySound(playerid,1054,0.0,0.0,0.0),
		SendClientMessage(playerid,-1,"{ffffff}[{FF0000}ERROR{ffffff}]: Unknown or incorrect command!");
	}
	
	return 1;
}

// ****************** COMMANDS ********************** //
CMD:bandage(playerid,params[])
{
	if (pInfo[playerid][pTeam] == TEAM_HUMAN)
	{
		if (pInfo[playerid][bandages] >= 1)
		{
			new string[128];
			pInfo[playerid][bandages] -= 1;
			SetPlayerHealth(playerid,100);
			format(string, sizeof string,""chat" You have used a Bandage. Now your health has been restored.(%i BANDAGES LEFT).",pInfo[playerid][bandages]);
			SendClientMessage(playerid,-1,string);
			return 1;
		}
		else return SendClientMessage(playerid,-1,""chat" You ran out of bandages!");
	}
	return 1;
}

CMD:antidote(playerid,params[])
{
	if (pInfo[playerid][pTeam] == TEAM_HUMAN)
	{
		if (pInfo[playerid][antidotes] >= 1)
		{
			new string[128];
			CurePlayer(playerid);
			pInfo[playerid][antidotes] -= 1;
			format(string, sizeof string,""chat" You have used an Antidote. Now you are cured.(%i ANTIDOTES LEFT).",pInfo[playerid][antidotes]);
			SendClientMessage(playerid,-1,string);
			return 1;
		}
		else return SendClientMessage(playerid,-1,""chat" You ran out of Antidotes!");
	}
	return 1;
}

CMD:cure(playerid,params[])
{
	if (pInfo[playerid][pTeam] == TEAM_HUMAN)
	{
		if (pInfo[playerid][pClass] == MEDIC || pInfo[playerid][pClass] == VIPMEDIC || pInfo[playerid][pClass] == DOCTOR)
		{
			new lookupid,string[128],str[256];
			if (sscanf(params,"u", lookupid)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /cure [playerid]");

			if (pInfo[lookupid][IsPlayerInfected] == 1)
			{
				CurePlayer(lookupid);
				format(string, sizeof string,"~n~~n~~n~~n~~g~%s~w~ %s has cured you",GetPlayerClassName(playerid), GetPlayerNameEx(playerid));
				GameTextForPlayer(lookupid,string,3500,5);
				format(str,sizeof str,""chat""COL_LGREEN" %s %s has cured %s",GetPlayerClassName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(lookupid));
				SendClientMessageToAll(-1,str);
				GivePlayerXP(playerid,20);
			}
			else return SendClientMessage(playerid,-1,""chat" The player you are trying to cure isn't infected.");
		}
		else return SendClientMessage(playerid,-1,""chat""COL_LGREEN" You will need to be an Medic & Advanced Medic, or VIP Medic, to use this command.");
	}
	else return SendClientMessage(playerid,-1,""chat""COL_LGREEN" You must be human, to use this command.");
	return 1;
}

CMD:heal(playerid,params[])
{
	if (gettime() - 15 < Abilitys[playerid][HealCoolDown]) return GameTextForPlayer(playerid,"~w~ Cannot heal wait 15 seconds!",1000,5);
	{
		if (pInfo[playerid][pTeam] == TEAM_HUMAN)
		{
			if (pInfo[playerid][pClass] == MEDIC || pInfo[playerid][pClass] == VIPMEDIC || pInfo[playerid][pClass] == DOCTOR)
			{
				new lookupid,string[128],str[256];
				if (sscanf(params,"u", lookupid)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /heal [playerid]");
				new Float:hp;
				GetPlayerHealth(lookupid,hp);
				if (pInfo[lookupid][pTeam] == TEAM_HUMAN)
				{
					if (hp >= 80)
					{
						SendClientMessage(playerid,-1,""chat" That player already has enough health to survive.");
					}
					else
					{
						if (pInfo[playerid][pClass] == MEDIC)
						{
							SetPlayerHealth(lookupid,hp+5);
							format(string, sizeof string,"~n~~n~~n~~n~~g~%s~w~ %s has healed you (New HP: %.2f)",GetPlayerClassName(playerid), GetPlayerNameEx(playerid),hp);
							GameTextForPlayer(lookupid,string,3500,5);
							format(str,sizeof str,""chat""COL_LGREEN" %s %s has healed %s (NEW HP: %.2f HP)",GetPlayerClassName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),hp,GetPlayerNameEx(lookupid));
							SendClientMessageToAll(-1,str);
							GivePlayerXP(playerid,20);
							Abilitys[playerid][HealCoolDown] = gettime();
						}
						else if (pInfo[playerid][pClass] == VIPMEDIC)
						{
							SetPlayerHealth(lookupid,hp+20);
							format(string, sizeof string,"~n~~n~~n~~n~~g~%s~w~ %s has healed you (by %.2f HP)",GetPlayerClassName(playerid), GetPlayerNameEx(playerid),hp);
							GameTextForPlayer(lookupid,string,3500,5);
							format(str,sizeof str,""chat""COL_LGREEN" %s %s has healed %s by (NEW HP: %.2f HP)",GetPlayerClassName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),hp);
							SendClientMessageToAll(-1,str);
							GivePlayerXP(playerid,20);
							Abilitys[playerid][HealCoolDown] = gettime();
						}

						else if (pInfo[playerid][pClass] == DOCTOR)
						{
							SetPlayerHealth(lookupid,hp+40);
							format(string, sizeof string,"~n~~n~~n~~n~~g~%s~w~ %s has healed you (by %.2f HP)",GetPlayerClassName(playerid), GetPlayerNameEx(playerid),hp);
							GameTextForPlayer(lookupid,string,3500,5);
							format(str,sizeof str,""chat""COL_LGREEN" %s %s has healed %s by (NEW HP: %.2f HP)",GetPlayerClassName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),hp);
							SendClientMessageToAll(-1,str);
							GivePlayerXP(playerid,35);
							Abilitys[playerid][HealCoolDown] = gettime();
						}
					}
				}
				else return SendClientMessage(playerid,-1,""chat" You cannot heal an zombie!");
			}
			else return SendClientMessage(playerid,-1,""chat""COL_LGREEN" You will need to be an Medic, Advanced Medic & Doctor or V.I.P Medic, to use this command!");
		}
		else return SendClientMessage(playerid,-1,""chat""COL_LGREEN" You must be human, to use this command.");
	}
	return 1;
}

CMD:admins(playerid, params[])
{
	new adminstring[600], count;
	foreach (new i : Player)
	{
		if (!pInfo[i][pAdminLevel]) continue;

		format(adminstring, sizeof(adminstring),"%s%s: %s\n", adminstring, GetAdminRankName(i), GetPlayerNameEx(i));
		count++;
	}
	
	if (!count) return SendClientMessage(playerid, COLOR_GREY, "There are currently no Administrators online.");
	else ShowPlayerDialog(playerid,DIALOG_ADMINS,DIALOG_STYLE_MSGBOX,"{DC143C}Online Administrators:",adminstring,"Close","");
	return 1;
}

CMD:vips(playerid, params[])
{
	new vipstring[600], count;
	foreach (new i : Player)
	{
		if (!pInfo[i][pVipLevel]) continue;

		format(vipstring, sizeof(vipstring),"{ffffff}%s%s (ID:%d)\n", vipstring, GetPlayerNameEx(i), playerid);
		count++;
	}
	
	if (!count) return SendClientMessage(playerid, COLOR_GREY, "There are currently no VIP's online.");
	else ShowPlayerDialog(playerid,DIALOG_VIPS,DIALOG_STYLE_MSGBOX,"{B266FF}Online VIPs:",vipstring,"Close","");
	return 1;
}

CMD:robj(playerid) return RemovePlayerAttachedObject(playerid,1);

CMD:stopanim(playerid) return ClearAnimations(playerid);

CMD:machinegun(playerid) // Modified by Logic_
{
	if (pInfo[playerid][pTeam] != TEAM_HUMAN) return SendClientMessage(playerid,-1,""chat""COL_LGREEN" {FF0000}You must be a Human, in order to spawn a Machine gun.");
	if (pInfo[playerid][pRank] < 31) return SendClientMessage(playerid,-1,""chat""COL_LGREEN" {FF0000}You must have a rank 31 of a Survivor II.");
	if (pInfo[playerid][Minigun]) return SendClientMessage(playerid,-1,""chat""COL_LGREEN" {FF0000}You already have spawned a minigun before.");
	
	GivePlayerWeapon(playerid, 38, 500);
	SendClientMessage(playerid, -1, ""chat""COL_LGREEN" You spawned a Machine gun! Now blast all those zombies!");
	pInfo[playerid][Minigun] = 1;
	return 1;
}

CMD:ranks(playerid) {  // Added by Logic_

	new i, str[20], str2[40 + 20 * sizeof gRanks + 1] = "{FFFFFF}Rank Name\t{FFFFFF}Rank Kills\n";
	
	for(; i < sizeof gRanks; i++) {
		format(str, sizeof str, "%s\t%d\n", gRanks[i][E_RANKS_NAME], gRanks[i][E_RANKS_KILLS]);
		strcat(str2, str);
	}

	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, "Rank list", str2, "Close", "");
	return 1;
}

CMD:vip(playerid)
{
	new vipinfo[700];
	strcat(vipinfo,"Very Important Player (VIP)\n");
	strcat(vipinfo,"\n");
	strcat(vipinfo,"\n");
	strcat(vipinfo,"{FFFF66}Features:\n");
	strcat(vipinfo,"\n");
	strcat(vipinfo,"{ffffff}Access to VIP Menu.\n");
	strcat(vipinfo,"{ffffff}Access to VIP Commands.\n");
	strcat(vipinfo,"{ffffff}Access to VIP Forums.\n");
	strcat(vipinfo,"{ffffff}Get listed in /vips\n");
	strcat(vipinfo,"{ffffff}Name Changes.\n");
	strcat(vipinfo,"{ffffff}Special Forum Rank.\n");
	strcat(vipinfo,"\n");
	strcat(vipinfo,"{FFFF66}More features coming soon!\n");
	strcat(vipinfo,"\n");
	strcat(vipinfo,"{ffffff}Get VIP today! Check the information\n");
	strcat(vipinfo,"about purchasing at our website: www.samp-zombieland.info\n");
	ShowPlayerDialog(playerid,DIALOG_VIPINFO,DIALOG_STYLE_MSGBOX,"{B266FF}VIP Info:",vipinfo,"Close","");
	return 1;
}

CMD:rules(playerid)
{
	new rules[2000];
	strcat(rules,"It is recommended for you to read the rules, before starting to play.\n");
	strcat(rules,"\n");
	strcat(rules,"{ffffff}1. No Hacking.\n");
	strcat(rules,"{ffffff}2. No Cleo mod using, which gives you advantages in gameplay.\n");
	strcat(rules,"{ffffff}3. Do not go outside of the map area.\n");
	strcat(rules,"{ffffff}4. No Advertising.\n");
	strcat(rules,"{ffffff}5. Do not spam or flood the main public chat.\n");
	strcat(rules,"{ffffff}6. Do not insult, argue with anyone on the server, which can make conflict.\n");
	strcat(rules,"{ffffff}7. Bunnyhoping is ALLOWED.\n");
	strcat(rules,"{ffffff}8. Do not Pause while playing.\n");
	strcat(rules,"{ffffff}9. No Spawn Killing (SK).\n");
	strcat(rules,"{ffffff}10. Do not attack your team.\n");
	strcat(rules,"{ffffff}11. Do not ask for XP,Cash or Tokens etc.\n");
	strcat(rules,"{ffffff}12. Do not farm XP and Cash, farming will get you banned.\n");
	strcat(rules,"\n");
	strcat(rules,"{FF3333}Remember to follow these server rules!\n");
	ShowPlayerDialog(playerid,DIALOG_RULES,DIALOG_STYLE_MSGBOX,"{DC143C}Server Rules:",rules,"Close","");
	return 1;
}

CMD:help(playerid)
{
	new helpstring[2000];
	strcat(helpstring,"Welcome to the server: Zombieland!\n");
	strcat(helpstring,"\n");
	strcat(helpstring,"{DC143C}About:\n");
	strcat(helpstring,"\n");
	strcat(helpstring,"{ffffff}It is a TDM / Survival based gamemode, where you can play with two teams.\n");
	strcat(helpstring,"Those two teams are, well, actually classes: Human & Zombie.\n");
	strcat(helpstring,"Both of those classes has their same goal, just kill & survive, or die.\n");
	strcat(helpstring,"As a human, you must kill the zombies and survive till the evacuation.\n");
	strcat(helpstring,"As a zombie, you must kill humans and not let them to survive.\n");
	strcat(helpstring,"\n");
	strcat(helpstring,"{DC143C}Classes:\n");
	strcat(helpstring,"\n");
	strcat(helpstring,"{ffffff}Human and zombie has their many unique classes. Each classes proves with\n");
	strcat(helpstring,"their skill and amount of Experience Points.\n");
	strcat(helpstring,"\n");
	strcat(helpstring,"{DC143C}How To Earn XP, Cash and Tokens:\n");
	strcat(helpstring,"\n");
	strcat(helpstring,"{ffffff}There are many options on how to earn XP, Cash and Tokens. The most common is, when you kill\n");
	strcat(helpstring,"your enemy team, when you infect, cure and heal. Do killstreaks and evacuate as a Human.\n");
	strcat(helpstring,"With XP, you can have access to the classes, but with Cash, you can buy Weapons and Skins.\n");
	strcat(helpstring,"And with Tokens, you can buy some miscellaneous items and features.\n");
	strcat(helpstring,"\n");
	strcat(helpstring,"{DC143C}Mapchange System:\n");
	strcat(helpstring,"\n");
	strcat(helpstring,"{ffffff}Each map changes after when the round ends. There are different type of maps.\n");
	strcat(helpstring,"Like interior maps, outside areas etc. All of them, are made by our Mappers.\n");
	strcat(helpstring,"If you are experienced Mapper and want to help us, you can apply for that in our forum.\n");
	strcat(helpstring,"\n");
	strcat(helpstring,"\n");
	strcat(helpstring,"If you have more questions related to the server's gameplay, you can ask\n");
	strcat(helpstring,"server administrators and they will do his best to help you out.\n");
	strcat(helpstring,"Also, more information about the server updates and other news, you can find at our website:\n");
	strcat(helpstring,"\n");
	strcat(helpstring,"www.samp-zombieland.info\n");
	ShowPlayerDialog(playerid,DIALOG_HELP,DIALOG_STYLE_MSGBOX,"Help?",helpstring,"Close","");
	return 1;
}

CMD:pm(playerid,params[])
{
	new lastID, text[128], string[128];
	if (sscanf(params, "us", lastID, text)) return SendClientMessage(playerid, COLOR_RED,"{C0C0C0}USAGE: /pm [playerid] [message]");
	if (!IsPlayerConnected(lastID)) return SendClientMessage(playerid, COLOR_RED,""chat" {FF0000}Player is not connected.");
	if (lastID == playerid) return SendClientMessage(playerid, COLOR_RED,""chat" {FF0000}You cannot PM yourself.");
	format(string, sizeof string, "%s (%d) is not accepting private messages at the moment.", GetPlayerNameEx(lastID), lastID);
	if (pInfo[lastID][pPM] == 1) return SendClientMessage(playerid, COLOR_RED, string);
	format(string, sizeof string, "{FF9933}PM to %s(%d):{ffffff} %s", GetPlayerNameEx(lastID),lastID, text);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof string, "{FF9933}PM from %s(%d):{ffffff} %s", GetPlayerNameEx(playerid),lastID, text);
	SendClientMessage(lastID, COLOR_YELLOW, string);
	pInfo[lastID][Last] = playerid;
	return 1;
}

CMD:r(playerid,params[])
{
	new text[128], string[128];
	if (sscanf(params, "s", text)) return SendClientMessage(playerid, COLOR_RED, "{C0C0C0}USAGE: /reply [message]");
	new lastID = pInfo[playerid][Last];
	if (!IsPlayerConnected(lastID)) return SendClientMessage(playerid, COLOR_RED,""chat" {FF0000}Player is not connected.");
	if (lastID == playerid) return SendClientMessage(playerid, COLOR_RED,""chat" {FF0000}You cannot PM yourself.");
	format(string, sizeof string, "%s (%d) is not accepting private messages at the moment.", GetPlayerNameEx(lastID), lastID);
	if (pInfo[lastID][pPM] == 1) return SendClientMessage(playerid, COLOR_RED, string);
	format(string, sizeof string, "{FF9933}PM to %s(%d):{ffffff} %s", GetPlayerNameEx(lastID),lastID, text);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof string, "{FF9933}PM from %s(%d):{ffffff} %s", GetPlayerNameEx(playerid),lastID, text);
	SendClientMessage(lastID, COLOR_YELLOW, string);
	pInfo[lastID][Last] = playerid;
	return 1;
}

CMD:cmds(playerid)
{
	new cmdstring[2000];
	strcat(cmdstring,"{DC143C}/credits{ffffff} - Information About the Contributors.\n");
	strcat(cmdstring,"{DC143C}/kill{ffffff} - Kill yourself.\n");
	strcat(cmdstring,"{DC143C}/robj{ffffff} - Remove the attached object.\n");
	strcat(cmdstring,"{DC143C}/vip{ffffff} - Information about the VIP features.\n");
	strcat(cmdstring,"{DC143C}/ranks{ffffff} - List of all ranks.\n");
	strcat(cmdstring,"{DC143C}/rules{ffffff} - Read the servers rules.\n");
	strcat(cmdstring,"{DC143C}/help{ffffff} - Some helpfull information.\n");
	strcat(cmdstring,"{DC143C}/radio{ffffff} - Choose the radio station to play.\n");
	strcat(cmdstring,"{DC143C}/z{ffffff} - Zombie chat.\n");
	strcat(cmdstring,"{DC143C}/h{ffffff} - Human Chat.\n");
	strcat(cmdstring,"{DC143C}/report{ffffff} - Report a hacker, rulebreaker.\n");
	strcat(cmdstring,"{DC143C}/pm{ffffff} - Send a private message to player.\n");
	strcat(cmdstring,"{DC143C}/r{ffffff} - A quick reply to message.\n");
	strcat(cmdstring,"{DC143C}/dnd{ffffff} - Toggle 'do not disturb' mode (toggle PM blocking).\n");
	strcat(cmdstring,"{DC143C}/sharexp{ffffff} - Share your XP to someone.\n");
	strcat(cmdstring,"{DC143C}/sharecash{ffffff} - Share your Cash to someone.\n");
	strcat(cmdstring,"{DC143C}/savestats{ffffff} - Save your statistics.\n");
	strcat(cmdstring,"{DC143C}/stats{ffffff} - View your statistics.\n");
	strcat(cmdstring,"{DC143C}/pstats{ffffff} - View someone's statistics.\n");
	strcat(cmdstring,"{DC143C}/machinegun{ffffff} - Requires Rank 31.\n");
	strcat(cmdstring,"{DC143C}/maps{ffffff} - View the list of all the server maps.\n");
	strcat(cmdstring,"{DC143C}/changepass{ffffff} - To change your account password.\n");
	strcat(cmdstring,"{DC143C}/anims{ffffff} - See the available Animations.\n");
	strcat(cmdstring,"{DC143C}/stopanim{ffffff} - Stop the current Animation.\n");
	strcat(cmdstring,"{DC143C}/laseron{ffffff} - Enable the laser for your weapon.\n");
	strcat(cmdstring,"{DC143C}/laseroff{ffffff} - Disable the laser for your weapon.\n");
	strcat(cmdstring,"{DC143C}/lasercol{ffffff} - Choose a colour for the laser.\n");
	strcat(cmdstring,"{DC143C}/me{ffffff} - Roleplay an action.\n");
	
	return ShowPlayerDialog(playerid, DIALOG_CMDS, DIALOG_STYLE_MSGBOX, "{DC143C}Server Commands:", cmdstring, "Close", ""), 1;
}

CMD:radio(playerid)
{
	new string[256];
	strcat(string,"Electro\nHeavy Metal\nTeen Pop\nR&B\nHip-Hop\nReggae\nRock\nAnime\nDubstep\nBlues\nTOP 40\n{FF0000}Stop Radio!");
	ShowPlayerDialog(playerid,DIALOG_RADIO,DIALOG_STYLE_LIST,"{DC143C}RADIO",string,"Select","Close");
	return 1;
}

CMD:z(playerid,params[])
{
	new zstring[256];
	if (pInfo[playerid][pTeam] == TEAM_ZOMBIE)
	{
		if (!strlen(params))
		{
			SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /z [message]");
			return 1;
		}
		format(zstring, sizeof(zstring), "{ffffff}[{CC0000}ZOMBIE CHAT{ffffff}]%s[%d]: %s", GetPlayerNameEx(playerid), playerid, params);
		SendZMessage(zstring, -1);
	}
	else return SendClientMessage(playerid,-1,""chat" You must be a zombie to use this chat function.");
	return 1;
}

CMD:h(playerid,params[])
{
	new zstring[256];
	if (pInfo[playerid][pTeam] == TEAM_HUMAN)
	{
		if (!strlen(params))
		{
			SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /h [message]");
			return 1;
		}
		format(zstring, sizeof(zstring), "{ffffff}[{0080FF}HUMAN CHAT{ffffff}]%s[%d]: %s", GetPlayerNameEx(playerid), playerid, params);
		SendHMessage(zstring, -1);
	}
	else return SendClientMessage(playerid,-1,""chat" You must be a human to use this chat function.");
	return 1;
}

CMD:changepass(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_PASSWORD, DIALOG_STYLE_INPUT, "Change Password", "Enter your desired password to continue", "Okay", "Cancel");
	return 1;
}

CMD:report(playerid, params[])
{
	if (pInfo[playerid][pLogged] == 1)
	{

		new text[128],lookupid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
		if (sscanf(params, "us[128]", lookupid, text)) SendClientMessage(playerid, COLOR_GREY, "{C0C0C0}USAGE: /report [playerid] [reason]");
		else
		{
			if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Invaild ID - That player is not connected.");
			if (lookupid == playerid) return SendClientMessage(playerid,-1,""chat" You cannot report yourself.");
			format(sendername, sizeof(sendername), "%s", GetPlayerNameEx(playerid));
			format(giveplayer, sizeof(giveplayer), "%s", GetPlayerNameEx(lookupid));
			format(string, sizeof string, "{ffffff}[{009999}REPORT{ffffff}]: %s[%d] has reported %s[%d] [Reason: %s]", sendername, playerid, giveplayer, lookupid, text);
			SendMessageToAdmins(string, -1);
			printf("{ffffff}[{009999}REPORT{ffffff}]: %s[%d] has reported %s[%d] [Reason: %s]", sendername, playerid, giveplayer, lookupid, text);
			SendClientMessage(playerid,-1,""chat" Thank you for reporting. We apologize for the disturbance.");
		}
	}
	return 1;
}

CMD:sharexp(playerid,params[])
{
	if (pInfo[playerid][pLogged] == 1)
	{
		{
			new lookupid,givexp,reason[105],stringxp[256];
			if (sscanf(params,"uis[105]", lookupid,givexp,reason)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /sharexp [playerid] [amount] [reason]");
			if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");
			if (lookupid == playerid) return SendClientMessage(playerid,-1,""chat" You cannot give XP to yourself.");

			if (givexp > 0 && pInfo[playerid][pXP] >= givexp)
			{
				pInfo[lookupid][pXP] += givexp;
				pInfo[playerid][pXP] -= givexp;
				format(stringxp,sizeof(stringxp),""chat" Player %s has shared %d XP to %s [Reason: %s]", GetPlayerNameEx(playerid), givexp, GetPlayerNameEx(lookupid), reason);
				SendClientMessageToAll(-1,stringxp);
				SetPlayerScore(playerid,pInfo[playerid][pXP]);
				UpdateXPTextdraw(playerid);
			}
			else
			{
				SendClientMessage(playerid,-1,""chat" You don't have enough XP.");
			}
		}
	}
	return 1;
}

CMD:sharecash(playerid,params[])
{
	if (pInfo[playerid][pLogged] == 1)
	{
		{
			new lookupid,givecash,reason[105],stringcash[256];
			if (sscanf(params,"uis[105]", lookupid,givecash,reason)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /sharecash [playerid] [amount] [reason]");
			if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");
			if (lookupid == playerid) return SendClientMessage(playerid,-1,""chat" You cannot give Cash to yourself.");

			if (givecash > 0 && pInfo[playerid][pCash] >= givecash)
			{
				pInfo[lookupid][pCash] += givecash;
				pInfo[playerid][pCash] -= givecash;
				GivePlayerMoney(lookupid, givecash);
				format(stringcash,sizeof(stringcash),""chat" Player %s has shared %d Cash to %s [Reason: %s]", GetPlayerNameEx(playerid), givecash, GetPlayerNameEx(lookupid), reason);
				SendClientMessageToAll(-1,stringcash);
			}
			else
			{
				SendClientMessage(playerid,-1,""chat" You don't have enough XP.");
			}
		}
	}
	return 1;
}

CMD:savestats(playerid)
{
	if (pInfo[playerid][pLogged] == 1)
	{
		SavePlayerAccount(playerid);
		SendClientMessage(playerid,-1,""chat"{33FF99} Your game statistics have been saved.");
	}
	return 1;
}

CMD:ss(playerid) return cmd_savestats(playerid);

CMD:stats(playerid)
{
	new string[2000];
	new Float:kd = floatdiv(pInfo[playerid][pKills], pInfo[playerid][pDeaths]);
	new Float:wins = floatdiv(pInfo[playerid][pMapsPlayed], pInfo[playerid][pEvac]);
	format(string, sizeof string,"	Viewing player stats: Yourself	\n\n\
	Cash: %i\n\
	Tokens: %i\n\
	XP: %i\n\
	Kills: %i\n\
	Deaths: %i\n\
	Headshots: %i\n\
	Maps Played: %i\n\
	Rank: %i\n\
	Evac Points: %i\n\
	Admin: %s\n\
	Vip Level: %i\n\
	K:D RATIO: %0.2f\n\
	Win RATIO: %0.2f",
	pInfo[playerid][pCash],pInfo[playerid][pCoins],pInfo[playerid][pXP],
	pInfo[playerid][pKills],pInfo[playerid][pDeaths],pInfo[playerid][pHeads],pInfo[playerid][pMapsPlayed],
	pInfo[playerid][pRank],pInfo[playerid][pEvac],GetAdminRankName(playerid),pInfo[playerid][pVipLevel],
	kd,wins);
	//Played: %d Hours || %d Minutes || %d Seconds\n

	ShowPlayerDialog(playerid,1888,DIALOG_STYLE_MSGBOX,"Viewing Stats!",string,"Close","");
	return 1;
}

CMD:pstats(playerid,params[])
{
	if (pInfo[playerid][pXP] >= 20)
	{
		new lookupid;
		if (sscanf(params, "u", lookupid)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /pstats [playerid]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");
		{
			new string[2000];
			new Float:kd = floatdiv(pInfo[lookupid][pKills], pInfo[lookupid][pDeaths]);
			new Float:wins = floatdiv(pInfo[lookupid][pMapsPlayed], pInfo[lookupid][pEvac]);
			format(string, sizeof string,"	Viewing player stats: %s \n\n\
			Cash: %i\n\
			Tokens: %i\n\
			XP: %i\n\
			Kills: %i\n\
			Deaths: %i\n\
			Headshots: %i\n\
			Maps Played: %i\n\
			Rank: %i\n\
			Evac Points: %i\n\
			Admin: %s\n\
			Vip Level: %i\n\
			K:D RATIO: %0.2f\n\
			Win RATIO: %0.2f",
			GetPlayerNameEx(lookupid),pInfo[playerid][pCash],pInfo[lookupid][pCoins],pInfo[lookupid][pXP],
			pInfo[lookupid][pKills],pInfo[lookupid][pDeaths],pInfo[lookupid][pHeads],pInfo[lookupid][pMapsPlayed],
			pInfo[playerid][pRank],pInfo[lookupid][pEvac],GetAdminRankName(lookupid),pInfo[lookupid][pVipLevel],
			kd,wins);
			//Played: %d Hours || %d Minutes || %d Seconds\n

			ShowPlayerDialog(playerid,1888,DIALOG_STYLE_MSGBOX,"Viewing Stats!",string,"Close","");
		}
	}
	else return SendXPError(playerid,20);
	return 1;
}

CMD:dnd(playerid) {

	return SendClientMessage(playerid, -1, (pInfo[playerid][pPM] ^= 1, pInfo[playerid][pPM]) ? ""chat" You are now blocking private messages." : ""chat" You are not blocking anymore private messages."), 1;
}

CMD:maps(playerid) {

	new string[2000];

	strcat(string, "All of the server maps are listed here:\nThis includes all the creations of our mappers and other people along with their credits.\n\n\n");

	/*
	for (new i; i < MAX_MAPS; i++) {
		if (!gMaps[i]) contiue;

		strcat(string, gMapNames[i]);
	}*/

	strcat(string, "{ffffff}MAP#00: {FFB266}LVPD/Las Venturas Police Department <Interior Map>\n");
	strcat(string, "{ffffff}MAP#01: {FFB266}Jefferson Motel <Interior Map>\n");
	strcat(string, "{ffffff}MAP#02: {FFB266}Meat Factory <Interior Map>\n");
	strcat(string, "{ffffff}MAP#03: {FFB266}Sherman Dam <Interior Map>\n");
	strcat(string, "{ffffff}MAP#04: {FFB266}BattleField <Interior Map>\n");
	strcat(string, "{ffffff}MAP#05: {FFB266}TheAfterWar (Made by Justice (SjuteL))\n");
	strcat(string, "{ffffff}MAP#06: {FFB266}Pharoahs Rise (Made by Shady)\n");
	strcat(string, "{ffffff}MAP#07: {FFB266}Resident Evil (Made by Shady)\n");
	strcat(string, "{ffffff}MAP#08: {FFB266}Dead Farm (Made by hossa)\n");
	strcat(string, "{ffffff}MAP#09: {FFB266}Dead Sewers (Made by hossa)\n");
	strcat(string, "{ffffff}MAP#10: {FFB266}Hallows Forest (Made by Justice (SjuteL))\n");
	strcat(string, "{ffffff}MAP#11: {FFB266}Land Of Terror (Made by Shady)\n");
	strcat(string, "{ffffff}MAP#12: {FFB266}Vinewood Cemetery (Made by Justice (SjuteL))\n");
	strcat(string, "{ffffff}MAP#13: {FFB266}Abandoned Sea (Made by Ceedie)\n");
	strcat(string, "{ffffff}MAP#14: {FFB266}Prepped Square (Made by Ceedie)\n");
	strcat(string, "{ffffff}MAP#15: {FFB266}Rock Hotel (Made by Ceedie)\n");
	strcat(string, "{ffffff}MAP#16: {FFB266}Airport Construction (Made by Ceedie)\n");
	strcat(string, "{ffffff}MAP#17: {FFB266}KACC Military (Made by Ceedie).\n");
	strcat(string, "{ffffff}MAP#18: {FFB266}Ocean DocksCrane (Made by Ceedie).\n");
	strcat(string, "{ffffff}MAP#19: {FFB266}SantaMaria Beach (Made by Ceedie).\n");
	strcat(string, "{ffffff}MAP#20: {FFB266}Toy Story (Made by Ceedie).\n");
	strcat(string, "{ffffff}MAP#21: {FFB266}Market Tunnel (Made by Justice (SjuteL)).\n");
	strcat(string, "{ffffff}MAP#22: {FFB266}Liberty City (Made by Pride).\n");
	strcat(string, "{ffffff}MAP#23: {FFB266}GroveSt Christmas (Made by LosTigeros/Patryk98).\n");
	strcat(string, "{ffffff}MAP#24: {FFB266}Skyscraper (Made by Justice (SjuteL)).\n");
	strcat(string, "{ffffff}MAP#25: {FFB266}Outpost (Unknown Creator).\n");
	strcat(string, "{ffffff}MAP#26: {FFB266}Swamp (Made by Moody).\n");
	
	strcat(string, "\n\nWe're always adding new maps! Our mappers try their best to make enjoyable maps for you!\n\n\
		If you're interested to become a mapper, then feel free to post the application on the forums!");
	
	return ShowPlayerDialog(playerid,DIALOG_MAPS,DIALOG_STYLE_MSGBOX,"{DC143C}Server Maps", string, "Close", "");
}

CMD:anims(playerid, params[])
{
	SendClientMessage(playerid,COLOR_YELLOW,"{FFFF33}--------------------Animations--------------------");
	SendClientMessage(playerid,COLOR_YELLOW,"{DC143C}/piss - /wank - /dance [1-4] /vomit");
	SendClientMessage(playerid,COLOR_YELLOW,"{DC143C}/drunk - /sit - /wave - /lay - /smoke");
	SendClientMessage(playerid,COLOR_YELLOW,"{DC143C}/cigar - /handsup - /crossarms - /fucku");
	SendClientMessage(playerid,COLOR_YELLOW,"{FFFFFF}To stop an animation use /stopanim");
	SendClientMessage(playerid,COLOR_YELLOW,"{FFFF33}----------------------------------------------------------");
	return 1;
}

CMD:dance(playerid, params[])
{
	switch (strval(params))
	{
		case 1: SetPlayerSpecialAction(playerid, 5);
		case 2: SetPlayerSpecialAction(playerid, 6);
		case 3: SetPlayerSpecialAction(playerid, 7);
		case 4: SetPlayerSpecialAction(playerid, 8);
		default: SendClientMessage(playerid, COLOR_WHITE, "{C0C0C0}USAGE: /dance [1-4]");
	}
	return 1;
}

CMD:sit(playerid)
{
	ApplyAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:crossarms(playerid)
{
	ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
	return 1;
}

CMD:fucku(playerid)
{
	ApplyAnimation(playerid,"PED","fucku",4.0,0,0,0,0,0);
	return 1;
}

CMD:handsup(playerid)
{
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:cigar(playerid)
{
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
	return 1;
}

CMD:piss(playerid)
{
	ApplyAnimation(playerid, "PAULNMAC", "Piss_loop", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:wank(playerid)
{
	ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:vomit(playerid)
{
	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:drunk(playerid)
{
	ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:wave(playerid)
{
	ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:lay(playerid)
{
	ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:smoke(playerid)
{
	ApplyAnimation(playerid, "SHOP", "Smoke_RYD", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:kill(playerid)
{
	if (pInfo[playerid][pTeam] == TEAM_HUMAN)
	{
		SetPlayerHealth(playerid,0.0);
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		SendClientMessage(playerid,-1,""chat"{FF3333} You have killed yourself! Suicider!");
		UpdateDeathsTextdraw(playerid);
	}
	else return SendClientMessage(playerid,-1,""chat"{FF0000} You cannot kill yourself, if you are a Zombie.");
	return 1;
}

CMD:credits(playerid)
{
	new string[235];

	strcat(string, "{DC143C}ADDICTIVE {FFFFFF}GAMING\n\n");
	strcat(string, "{DC143C}Script Maintainer: {FFFFFF}Logic_\n");
	strcat(string, "{DC143C}Script Developers: {FFFFFF}Kitten, SjuteL, Private200 & Logic_.\n");
	strcat(string, "And all former and present administrators for making this place what it's today!");

//    strcat(mapstring,"{DC143C}Server Founder:{ffffff} Justice (SjuteL).\n");
//	strcat(mapstring,"{DC143C}Server Developer(s):{ffffff} Justice (SjuteL) & Private200.\n");
//	strcat(mapstring,"{DC143C}Server Ex-Developer(s):{ffffff} Shady.\n");
//	strcat(mapstring,"{DC143C}Server Mapper(s):{ffffff} Shady, Ryder, SoundWave, Justice (SjuteL) and oth.\n");
//	strcat(mapstring,"{DC143C}Server Hoster:{ffffff} Crimson.\n");
//	strcat(mapstring,"{DC143C}Server's Community Forums Founder:{ffffff} Justice (SjuteL).\n");
//	strcat(mapstring,"{DC143C}Server's GameMode Original Creator/Scripter:{ffffff} Kitten Aka AldenJ (Aaron).\n");
//	strcat(mapstring,"{DC143C}Past Contributors/Scripters:{ffffff} hossa & FahadKing07.\n");

	ShowPlayerDialog(playerid,DIALOG_MAPS,DIALOG_STYLE_MSGBOX,"{DC143C}Server Credits", string, "Close","");
	return 1;
}

//===========VIP COMMANDS===============

CMD:vcmds(playerid)
{
	new vcmdstring[2000];
	strcat(vcmdstring,"{FFFF66}LEVEL 1:\n");
	strcat(vcmdstring,"{B266FF}/v{ffffff} - Special VIP Chat where to chat with other VIP's.\n");
	strcat(vcmdstring,"{B266FF}/vipmenu{ffffff} - See the menu of features.\n");
	strcat(vcmdstring,"{B266FF}/vsay{ffffff} - Announce your message to all players.\n");
	strcat(vcmdstring,"{B266FF}/vskins{ffffff} - Choose any kind of skin.\n");
	strcat(vcmdstring,"\n");
	strcat(vcmdstring,"{FFFF66}LEVEL 2:\n");
	strcat(vcmdstring,"{B266FF}/vcure{ffffff} - Cure other humans when you are not Medic.\n");
	strcat(vcmdstring,"{B266FF}/vheal{ffffff} - Heal other humans when you are not Medic.\n");
	strcat(vcmdstring,"\n");
	strcat(vcmdstring,"{FFFF66}LEVEL 3:\n");
	strcat(vcmdstring,"{B266FF}/vtime{ffffff} - Set your own time. From 0-24.\n");
	strcat(vcmdstring,"{B266FF}/vweather{ffffff} - Set your own weather.\n");
	strcat(vcmdstring,"{B266FF}/vdj{ffffff} - Play some music for the players as a DJ.\n");
	strcat(vcmdstring,"\n");
	strcat(vcmdstring,"\n");
	strcat(vcmdstring,"There will be more commands added for VIP in the future.\n");
	strcat(vcmdstring,"If you have some ideas, suggestions for VIP, you can post them in our Forum:\n");
	strcat(vcmdstring,"\n");
	strcat(vcmdstring,"{FFFF33}www.samp-zombieland.info\n");
	ShowPlayerDialog(playerid,DIALOG_VCMDS,DIALOG_STYLE_MSGBOX,"{B266FF}VIP Commands:",vcmdstring,"Close","");
	return 1;
}

CMD:v(playerid,params[])
{
	new vipstring[256];
	if (pInfo[playerid][pVipLevel] >= 1)
	{
		if (!strlen(params))
		{
			SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /v [message]");
			return 1;
		}
		format(vipstring, sizeof(vipstring), "{ffffff}[{B266FF}VIP CHAT{ffffff}]%s(%d): %s", GetPlayerNameEx(playerid), playerid, params);
		SendMessageToAllVips(vipstring, -1);
	}
	else {

	}
	return 1;
}

CMD:vipmenu(playerid)
{
	if (pInfo[playerid][pVipLevel] >= 1)
	{
		new str[300];
		strcat(str,"Unlimited Ammo\t\t\tLevel 1\nWeapons\t\t\t\tLevel 1\nS.W.A.T Armour Object\t\t\tLevel 1\nClasses\t\t\t\tLevel 2\nEnable Name Flash\t\t\tLevel 2\n\
		Disable Name Flash\t\t\tLevel 2\nEnable Kick Back\t\t\tLevel 3\nDisable Kick Back\t\t\tLevel 3");
		ShowPlayerDialog(playerid,DIALOG_VIP,DIALOG_STYLE_LIST,"VIP Menu",str,"Select","Close");
	}
	else return SendClientMessage(playerid,-1,""chat""COL_LGREEN" You must be VIP, in order to be able to use this command.");
	return 1;
}

CMD:vsay(playerid,params[])
{
	new string[256];
	if (pInfo[playerid][pVipLevel] >= 1)
	{
		if (!strlen(params))
		{
			SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /vsay [message]");
			return 1;
		}
		format(string, sizeof string, "{B266FF}(VIP)%s {BA55D3}**%s**", GetPlayerNameEx(playerid), params);
		SendClientMessageToAll(COLOR_PURPLE,string);
	}
	else {
		SendClientMessage(playerid,-1,""chat""COL_LGREEN" You must be VIP, in order to be able to use this command.");
	}
	return 1;
}

CMD:vskins(playerid)
{
	if (pInfo[playerid][pVipLevel] >= 1)
	{
		//ShowModelSelectionMenu(playerid, skinlist, "Skins");
	}
	else return SendClientMessage(playerid,-1,""chat""COL_LGREEN" You must be VIP, in order to be able to use this command.");
	return 1;
}

CMD:vcure(playerid,params[])
{
	if (pInfo[playerid][pTeam] == TEAM_HUMAN)
	{
		if (pInfo[playerid][pVipLevel] >= 2)
		{
			new lookupid,string[128],str[256];
			if (sscanf(params,"u", lookupid)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /vcure [playerid]");

			if (pInfo[lookupid][IsPlayerInfected] == 1)
			{
				CurePlayer(lookupid);
				format(string, sizeof string,"~n~~n~~n~~n~~g~VIP~w~ %s has cured you",GetPlayerClassName(playerid), GetPlayerNameEx(playerid));
				GameTextForPlayer(lookupid,string,3500,5);
				format(str,sizeof str,""chat""COL_LGREEN" VIP %s has cured %s",GetPlayerClassName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid));
				SendClientMessageToAll(-1,str);
				GivePlayerXP(playerid,20);
			}
			else return SendClientMessage(playerid,-1,""chat" The player you are trying to cure is not infected.");
		}
		else return SendClientMessage(playerid,-1,""chat""COL_LGREEN" You must be VIP, in order to be able to use this command.");
	}
	else return SendClientMessage(playerid,-1,""chat" You'll need to be an human to use this command!");
	return 1;
}

CMD:vheal(playerid,params[])
{
	if (gettime() - 15 < Abilitys[playerid][HealCoolDown]) return GameTextForPlayer(playerid,"~w~ Cannot VIP heal wait 15 seconds!",1000,5);
	{
		if (pInfo[playerid][pTeam] == TEAM_HUMAN)
		{
			if (pInfo[playerid][pVipLevel] >= 2)
			{
				new lookupid,string[128],str[256];
				if (sscanf(params,"u", lookupid)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /vheal [playerid]");
				new Float:hp;
				GetPlayerHealth(lookupid,hp);
				if (pInfo[lookupid][pTeam] == TEAM_HUMAN)
				{
					if (hp >= 80)
					{
						SendClientMessage(playerid,-1,""chat" That player already has enough health to survive.");
					}
					else
					{
						if (pInfo[playerid][pVipLevel] >= 4)
						{
							SetPlayerHealth(lookupid,hp+40);
							format(string, sizeof string,"~n~~n~~n~~n~~g~%s~w~ %s has healed you (by %.2f HP)",GetPlayerClassName(playerid), GetPlayerNameEx(playerid),hp);
							GameTextForPlayer(lookupid,string,3500,5);
							format(str,sizeof str,""chat""COL_LGREEN" %s %s has healed %s by (NEW HP: %.2f HP)",GetPlayerClassName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),hp);
							SendClientMessageToAll(-1,str);
							GivePlayerXP(playerid,35);
							Abilitys[playerid][HealCoolDown] = gettime();
						}
					}
				}
				else return SendClientMessage(playerid,-1,""chat" You cannot heal an zombie!");
			}
			else return SendClientMessage(playerid,-1,""chat""COL_LGREEN" You must be VIP, in order to be able to use this command.");
		}
		else return SendClientMessage(playerid,-1,""chat" You'll need to be an human to use this command!");
	}
	return 1;
}

CMD:vtime(playerid,params[])
{
	if (pInfo[playerid][pVipLevel] >= 3)
	{
		new vtime,string[128];
		if (sscanf(params, "i", vtime)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /vtime [time]");
		SetPlayerTime(playerid,vtime,0);
		format(string, sizeof string, ""chat" {B266FF}You have changed the Time To %d.",vtime);
		SendClientMessage(playerid,COLOR_PURPLE,string);
	}
	return 1;
}

CMD:vweather(playerid,params[])
{
	if (pInfo[playerid][pVipLevel] >= 3)
	{
		new vweather,string[128];
		if (sscanf(params, "i", vweather)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /vweather [weather id]");
		SetPlayerWeather(playerid,vweather);
		format(string, sizeof string, ""chat" {B266FF}You have changed the Weather to (ID:%d).",vweather);
		SendClientMessage(playerid,COLOR_PURPLE,string);
	}
	return 1;
}

CMD:vdj(playerid, params[])
{
	if (pInfo[playerid][pVipLevel] >= 3)
	{
		new string[128];
		if (sscanf(params, "s[256]", params)) return SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /vdj [Link]");
		format(string, sizeof string, "{B266FF}(VIP){ffffff}DJ %s {BA55D3}is playing some music!", GetPlayerNameEx(playerid), params);
		SendClientMessageToAll(COLOR_PURPLE,string);
		foreach(new i : Player) PlayAudioStreamForPlayer(i, params);
	}
	return 1;
}

CMD:me(playerid, params[])
{
	new action[200];
	if (sscanf(params,"s[200]", action))return SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /me [action]");
	format(action, sizeof(action), "{FF9933}** %s %s", GetPlayerNameEx(playerid), action);
	SendClientMessageToAll(COLOR_WHITE, action);
	return 1;
}

CMD:acmds(playerid)
{
	if (!pInfo[playerid][pAdminLevel]) return 1;
	
	new acmdstring[600];

	strcat(acmdstring,"{DC143C}Trial Moderator{ffffff}: /aod /spec /specoff /freeze /unfreeze /codes /getid\n"); // 86
	strcat(acmdstring,"/clearchat /nextmap /slap /a /warn /unwarn /akill /mute /unmute /kick /cw\n\n"); // 77

	if (pInfo[playerid][pAdminLevel] > 2) strcat(acmdstring,"{DC143C}Moderator{ffffff}: /skip /ban /unban /offlineban /ann2 /settime /setweather /get /goto /aheli /acar /exit\n\n"); // 117

	if (pInfo[playerid][pAdminLevel] > 3) strcat(acmdstring,"{DC143C}Administrator{ffffff}: /xp /setzombie /sethuman /ann /ip /restart /freezeteam /unfreezeteam /atank\n\n"); // 110

	if (pInfo[playerid][pAdminLevel] > 4) strcat(acmdstring,"{DC143C}Manager{ffffff}: /givecash /givexp /givetokens /setxp\n\n"); // 65

	if (pInfo[playerid][pAdminLevel] > 5) strcat(acmdstring,"{DC143C}Owner{ffffff}: /setvip /setadmin /nuke /offlinesetadmin /offlinesetvip\n"); // 80
	
	return ShowPlayerDialog(playerid,DIALOG_ACMDS,DIALOG_STYLE_MSGBOX,"{DC143C}Administrative Commands:", acmdstring, "Close", ""), 1;
}

new aduty[MAX_PLAYERS];
CMD:aod(playerid)
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 1)
		{
			if (aduty[playerid] == 0)
			{
			aduty[playerid] = 1;

			new adutyonstring[128];
			format(adutyonstring, sizeof(adutyonstring), "{33FF33}%s %s is now Admin On Duty !" ,GetAdminRankName(playerid), GetPlayerNameEx(playerid));
			SendClientMessageToAll(-1,adutyonstring);
			SetPlayerColor(playerid,0x99FF33FF);
			SetPlayerHealth(playerid,999999.0);
			SetPVarInt(playerid, "aduty147", 1);
			SetPlayerSkin(playerid, 217);
			pAdminLabel[playerid] = Create3DTextLabel("Admin On Duty!", 0x99FF33FF, 30.0, 40.0, 50.0, 40.0, 0);
			Attach3DTextLabelToPlayer(pAdminLabel[playerid], playerid, 0.0, 0.0, 0.7);
			pInfo[playerid][pTeam] = TEAM_ZOMBIE;
			SendClientMessage(playerid,COLOR_RED,"Remember to /aod when you play as regular player.");
			}
			else
			{
				if (aduty[playerid] == 1)
				{
				aduty[playerid] = 0;
				new adutyoffstring[128];
				format(adutyoffstring, sizeof(adutyoffstring), "%s %s is now Admin Off Duty !" ,GetAdminRankName(playerid), GetPlayerNameEx(playerid));
				Delete3DTextLabel(pAdminLabel[playerid]);
				SetPVarInt(playerid, "aduty147", 0);
				SendClientMessageToAll(-1,adutyoffstring);

				if (pInfo[playerid][pTeam] == TEAM_ZOMBIE)
				{
					SetPlayerColor(playerid,COLOR_ZOMBIE);
					SetPlayerSkin(playerid,162);
				}
				if (pInfo[playerid][pTeam] == TEAM_HUMAN)
				{
					SetPlayerColor(playerid,COLOR_HUMAN);
				}
				SetPlayerHealth(playerid,100);
				}
			}
		}
	}
	else if (pInfo[playerid][pLogged] == 0)
	{
		SendClientMessage(playerid,-1,"{FFFFFF}[{B3432B}KICKED{FFFFFF}] You must be logged in");
		printf("%s has been kicked for trying to use a command without being logged in!", GetPlayerNameEx(playerid));
		KickPlayer(playerid);
	}
	return 1;
}

CMD:spec(playerid,params[])
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 1)
		{
			new id;
			if (sscanf(params,"u", id))return SendClientMessage(playerid, COLOR_ORANGE, "{C0C0C0}USAGE: /spec [playerid]");
			if (id == playerid)return SendClientMessage(playerid,COLOR_ORANGE,"{FF0000}You cannot spec yourself.");
			if (id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_ORANGE,"{FF0000}Player not found!");
			GetPlayerPos(playerid,SpecX[playerid],SpecY[playerid],SpecZ[playerid]);
			Inter[playerid] = GetPlayerInterior(playerid);
			vWorld[playerid] = GetPlayerVirtualWorld(playerid);
			TogglePlayerSpectating(playerid, true);
			if (IsPlayerInAnyVehicle(id))
			{
				if (GetPlayerInterior(id) > 0)
				{
					SetPlayerInterior(playerid,GetPlayerInterior(id));
				}
				if (GetPlayerVirtualWorld(id) > 0)
				{
					SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
				}
				PlayerSpectateVehicle(playerid,GetPlayerVehicleID(id));
			}
			else
			{
				if (GetPlayerInterior(id) > 0)
				{
					SetPlayerInterior(playerid,GetPlayerInterior(id));
				}
				if (GetPlayerVirtualWorld(id) > 0)
				{
					SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
				}
				PlayerSpectatePlayer(playerid,id);
			}

			new String[40 + MAX_PLAYER_NAME];
			format(String, sizeof String,"{ffffff}You have started to spectate %s.", GetPlayerNameEx(id));
			SendClientMessage(playerid,0x0080C0FF,String);

			IsSpecing[playerid] = IsBeingSpeced[id] = 1;
			spectatorid[playerid] = id;
		}
			else SendClientMessage(playerid,-1,""chat" You must be on admin duty before you spectate! /aod");
	}
	else if (pInfo[playerid][pLogged] == 0)
	{
		printf("%s has been kicked for trying to use a command without being logged in!", GetPlayerNameEx(playerid));
		KickPlayer(playerid);
	}
	return 1;
}

CMD:specoff(playerid, params[])
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 1)
		{
			if (IsSpecing[playerid] == 0)return SendClientMessage(playerid,COLOR_LIGHTBLUE,"{ffffff}You are not spectating anyone.");
			TogglePlayerSpectating(playerid, 0);
			if (pInfo[playerid][pTeam] == TEAM_HUMAN)
			{
				HumanSetup(playerid);
				SpawnPlayer(playerid);
			}
			else if (pInfo[playerid][pTeam] == TEAM_ZOMBIE)
			{
				ZombieSetup(playerid);
				SpawnPlayer(playerid);
			}
		}
	}
	else if (pInfo[playerid][pLogged] == 0)
	{
		printf("%s has been kicked for trying to use a command without being logged in!", GetPlayerNameEx(playerid));
		KickPlayer(playerid);
	}
	return 1;
}

CMD:freeze(playerid,params[])
{
	if (pInfo[playerid][pLogged] == 1) {
		if (pInfo[playerid][pAdminLevel] >= 1) {
			new Target;
			if (sscanf(params, "u", Target)) SendClientMessage(playerid, COLOR_LIGHTBLUE, "{C0C0C0}USAGE: /freeze [playerid]");
			
			if (!IsPlayerConnected(Target)) return SendClientMessage(playerid, COLOR_GREY, ""chat"{FF0000}Player is not online.");
			
			if (pInfo[Target][pAdminLevel] > pInfo[playerid][pAdminLevel]) return SendClientMessage(playerid,COLOR_RED,"ERROR: You cant perform this on Admins that are higher than your level!"); // if the player you're performing this command on has a higher level as you, return a message, you ain't able to freeze him
			
			new string[144];
			format(string, sizeof string,"{FF0000}You have been frozen by %s %s", GetAdminRankName(playerid), GetPlayerNameEx(playerid));
			SendClientMessage(playerid, COLOR_RED, string);

			format(string, sizeof string,"{FF0000}You have frozen player %s(%d)", GetPlayerNameEx(Target), Target);
			SendClientMessage(Target, COLOR_RED, string);

			TogglePlayerControllable(Target, false);
			pInfo[Target][Frozen] = 1;
		}
		else return SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	else if (pInfo[playerid][pLogged] == 0)
	{
		printf("%s has been kicked for trying to use a command without being logged in!", GetPlayerNameEx(playerid));
		KickPlayer(playerid);
	}
	return 1;
}

CMD:unfreeze(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 1)
	{
		new Target;
		if (sscanf(params, "u", Target)) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "{C0C0C0}USAGE: /freeze [playerid]");
		if (!IsPlayerConnected(Target))
			return SendClientMessage(playerid, COLOR_GREY, ""chat"{FF0000} Player is not online.");
		if (!sscanf(params, "u", Target)) {			
			new tstring[128], pstring[128], astring[128];
			
			format(tstring,sizeof(tstring),"{DC143C}You have been unfrozen by %s %s", GetAdminRankName(playerid), GetPlayerNameEx(playerid));
			format(pstring,sizeof(pstring),"{FF0000}You have unfrozen player %s(%d)", GetPlayerNameEx(Target), Target);
			format(astring,sizeof(astring),"{DC143C}%s %s has unfrozen %s", GetAdminRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(Target));
			
			SendClientMessage(Target, COLOR_RED, tstring);
			SendClientMessage(playerid, COLOR_RED, pstring);
			SendClientMessageToAll(COLOR_RED, astring);

			TogglePlayerControllable(Target, true);
			pInfo[Target][Frozen] = 0;
		}
		if (pInfo[Target][pTeam] == TEAM_HUMAN)
		{
			SetPlayerHealth(Target, 100);
			SetPlayerColor(Target,COLOR_HUMAN);
		}

		if (pInfo[Target][pTeam] == TEAM_ZOMBIE)
		{
			if (pInfo[Target][pClass] == BOOMERZOMBIE)
			{
				SetPlayerHealth(Target, 25);
				SetPlayerColor(Target,COLOR_ZOMBIE);
			}
			else
			{
				SetPlayerHealth(Target, 100);
				SetPlayerColor(Target,COLOR_ZOMBIE);
			}
		}
	}
	else if (pInfo[playerid][pLogged] == 0)
	{
		printf("%s has been kicked for trying to use a command without being logged in!", GetPlayerNameEx(playerid));
		KickPlayer(playerid);
	}
	return 1;
}

CMD:codes(playerid) {
	if (!pInfo[playerid][pAdminLevel]) return 1;

	new cstring[2000];
	strcat(cstring,"{DC143C}HH{ffffff} - Health Hacks {DC143C}(Permanent)\n{DC143C}GM{ffffff} - God Mode {DC143C}(Permanent)\n{DC143C}AB{ffffff} - Air Break {DC143C}(Permanent)\n{DC143C}SH{ffffff} - Speed Hacks {DC143C}(Permanent)\n{DC143C}WH{ffffff} - Weapon Hacks {DC143C}(Permanent)\n\
	{DC143C}SK{ffffff} - Spawnkill {DC143C}(Over did)\n{DC143C}FH{ffffff} - Fly hacks {DC143C}(Permanent)\n{DC143C}VH{ffffff} - Vehicle Hacks {DC143C}(Permanent)");

	return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{DC143C}Ban Codes", cstring, "Close", ""), 1;
}

CMD:getid(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 1)
	{
		new lookup[MAX_PLAYER_NAME];
		if (sscanf(params, "s[24]", lookup)) return SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /getid [Playername] ");
		new string[80], namelen, bool:searched=false;
		format(string, sizeof string,""chat" Searched for: \"%s\"", lookup);
		SendClientMessage(playerid, -1,string);
		foreach(new i : Player)
		{
			namelen = strlen(GetPlayerNameEx(i));
			
			for(new pos; pos <= namelen; pos++)
			{
				if (strfind(GetPlayerNameEx(i), params, true) == pos)
				{
					format(string, sizeof string,""chat" %s (ID: %d)", GetPlayerNameEx(i), i);
					SendClientMessage(playerid, -1 ,string);
					searched = true;
					break;
				}
			}
		}
		
		if (!searched) SendClientMessage(playerid, -1, ""chat" No Players Localized!");
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:clearchat(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 1)
	{
		new string[256];

		ClearChat();
		format(string, sizeof string, "{DC143C}%s %s has cleared the chat.",GetAdminRankName(playerid), GetPlayerNameEx(playerid));
		SendClientMessageToAll(-1,string);
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:nextmap(playerid,params[])
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 1)
		{
			new map,stringmap[256];
			if (sscanf(params,"i", map)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /nextmap [mapid]");

			format(stringmap,sizeof(stringmap),"{DC143C}%s %s has set next map id to %i.",GetAdminRankName(playerid), GetPlayerNameEx(playerid),map);
			SendClientMessageToAll(-1,stringmap);
			gMapID = map;
		}
	}
	return 1;
}

CMD:megaslap(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 3 || IsPlayerAdmin(playerid))
	{
		new lookupid,string[256];
		if (sscanf(params, "u", lookupid)) return  SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /slap [playerid]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		new Float:posxx[3];
		GetPlayerPos(lookupid, posxx[0], posxx[1], posxx[2]);
		SetPlayerPos(lookupid, posxx[0], posxx[1], posxx[2]+40);

		if (IsPlayerAdmin(playerid))
		{
			format(string, sizeof string, ""chat" RCON Admin has mega slapped %s",GetPlayerNameEx(lookupid));
			SendClientMessageToAll(-1,string);
		}
		else
		{
			format(string, sizeof string, "{DC143C}%s %s has mega slapped %s",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid));
			SendClientMessageToAll(-1,string);
		}
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:slap(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 1 || IsPlayerAdmin(playerid))
	{
		new lookupid,string[256],height;
		if (sscanf(params, "ud", lookupid, height)) return  SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /slap [playerid] [height]");
		if (height < 0 || height > 10) return SendClientMessage(playerid, -1, "{DC143C}ERROR: The Height should be between 0-10.");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		new Float:posxx[3];
		GetPlayerPos(lookupid, posxx[0], posxx[1], posxx[2]);
		SetPlayerPos(lookupid, posxx[0], posxx[1], posxx[2]+height);

		if (IsPlayerAdmin(playerid))
		{
			format(string, sizeof string, ""chat" RCON Admin has slapped %s",GetPlayerNameEx(lookupid));
			SendClientMessageToAll(-1,string);
		}
		else
		{
			format(string, sizeof string, "{DC143C}%s %s has slapped %s",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid));
			SendClientMessageToAll(-1,string);
		}
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:a(playerid,params[])
{
	new adminstring[256];
	if (pInfo[playerid][pAdminLevel] >= 1)
	{
		if (!strlen(params))
		{
			SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /a [message]");
			return 1;
		}
		format(adminstring, sizeof(adminstring), "{ffffff}[{00FF00}ADMIN CHAT{ffffff}]%s(%d): %s", GetPlayerNameEx(playerid), playerid, params);
		SendMessageToAdmins(adminstring, -1);
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:warn(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 1 || IsPlayerAdmin(playerid))
	{
		new lookupid,reason[105],string[256];
		if (sscanf(params, "us[105]", lookupid, reason)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /warn [playerid] [reason]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		new sentstring[128];

		pInfo[lookupid][pWarnings]++;

		format(string, sizeof string, "%s %s has warned you!\n\n{DC143C}Reason{ffffff}: %s\n{DC143C}Warning Number{ffffff}: %i",GetAdminRankName(playerid), GetPlayerNameEx(playerid), reason, pInfo[lookupid][pWarnings]);
		ShowPlayerDialog(lookupid,DIALOG_WARN,DIALOG_STYLE_MSGBOX,"Warning!",string,"Apologize","");
		format(sentstring,sizeof(sentstring), "{DC143C}%s %s has warned %s Reason: %s (%i / 3)",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),reason,pInfo[lookupid][pWarnings]);
		SendClientMessageToAll(-1,sentstring);

		if (pInfo[lookupid][pWarnings] >= 3)
		{
			format(string, sizeof string, "{DC143C}%s %s has kicked %s Reason: %s (3 Warnings EXCEEDED)",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),reason);
			SendClientMessageToAll(-1,string);
			KickPlayer(lookupid);
		}
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:unwarn(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 1 || IsPlayerAdmin(playerid))
	{
		new lookupid,reason[105],string[256];
		if (sscanf(params, "us[105]", lookupid, reason)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /unwarn [playerid] [reason]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		new sentstring[128];

		if (pInfo[lookupid][pWarnings] >= 1)
		{
			pInfo[lookupid][pWarnings]--;
		}
		else return SendClientMessage(playerid, -1,""chat" Player has no warning(s).");

		format(string, sizeof string, "%s %s has unwarned you!\n\n{DC143C}Reason{ffffff}: %s",GetAdminRankName(playerid), GetPlayerNameEx(playerid), reason);
		ShowPlayerDialog(lookupid,DIALOG_WARN,DIALOG_STYLE_MSGBOX,"Warning! Removed",string,"Thanks","");
		format(sentstring,sizeof(sentstring), "{DC143C}%s %s has unwarned %s Reason: %s (%i / 3)",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),reason,pInfo[lookupid][pWarnings]);
		SendClientMessageToAll(-1,sentstring);

	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:akill(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 1)
	{
		new lookupid,string[256];
		if (sscanf(params, "u", lookupid)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /akill [playerid]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		SetPlayerHealth(lookupid,0.0);

		format(string, sizeof string, "{DC143C}%s %s has killed %s",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid));
		SendClientMessageToAll(-1,string);
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:mute(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 1)
	{
		new lookupid,reason[105],string[128];
		if (sscanf(params, "us[105]", lookupid,reason)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /mute [playerid] [reason]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		pInfo[lookupid][Muted] = 1;

		format(string, sizeof string,"{DC143C}%s %s has muted %s [Reason: %s]",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),reason);
		SendMessageToAdmins(string,-1);

		format(string, sizeof string,"{DC143C}%s %s muted you for [Reason %s]",GetAdminRankName(playerid), GetPlayerNameEx(playerid),reason);
		SendClientMessage(lookupid,-1,string);
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:unmute(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 1)
	{
		new lookupid,string[128];
		if (sscanf(params, "u", lookupid)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /unmute [playerid]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		if (pInfo[lookupid][Muted] == 1)
		{
			format(string, sizeof string,"{DC143C}%s %s has unmuted you",GetAdminRankName(playerid), GetPlayerNameEx(playerid));
			SendClientMessage(lookupid,-1,string);
			format(string, sizeof string,""chat" You unmuted %s",GetPlayerNameEx(lookupid));
			SendClientMessage(playerid,-1,string);
			pInfo[lookupid][Muted] = 0;
		}
		else
		{
			SendClientMessage(playerid,-1,""chat" Player isn't muted.");
		}
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:cw(playerid, params[])
{
	if (pInfo[playerid][pAdminLevel] >= 1)
	{
		new count = 0;
		new ammo, weaponid, weapon[24], string[128], id;
		if (!sscanf(params, "u", id))
		{
				for (new c = 0; c < 13; c++)
				{
					GetPlayerWeaponData(id, c, weaponid, ammo);
					if (weaponid != 0 && ammo != 0)
					{
						count++;
					}
				}
				SendClientMessage(playerid, COLOR_ORANGE, "||=============WEAPONS AND AMMO===========||");
				if (count > 0)
				{
					for (new c = 0; c < 13; c++)
					{
						GetPlayerWeaponData(id, c, weaponid, ammo);
						if (weaponid != 0 && ammo != 0)
						{
							GetWeaponName(weaponid, weapon, 24);
							format(string, sizeof string, "Weapons: %s  Ammo: %d", weapon, ammo);
							SendClientMessage(playerid, COLOR_GREEN, string);
						}
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_GREY, "This player has no weapons!");
				}
				return 1;
		}
		else return SendClientMessage(playerid, COLOR_GREY, "{C0C0C0}USAGE: /cw [playerid]");
	}
	else return SendClientMessage(playerid, COLOR_GREY, "You are not allowed to do this!");
}


CMD:kick(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 1)
	{
		new lookupid,reason[105],string[256];
		if (sscanf(params, "us[105]", lookupid,reason)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /kick [playerid] [reason]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		format(string, sizeof string, "{DC143C}%s %s has kicked %s [Reason: %s]",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),reason);
		SendClientMessageToAll(-1,string);

		format(string, sizeof string, "You are kicked from the server!\n\n{DC143C}Kicked by{ffffff}: %s\n{DC143C}Reason{ffffff}: %s", GetPlayerNameEx(playerid), reason);
		ShowPlayerDialog(lookupid,DIALOG_KICKN,DIALOG_STYLE_MSGBOX,"{DC143C}KICKED",string,"Close","");
		KickPlayer(lookupid);
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:exit(playerid)
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 2)
		{
			if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,-1,"{DC143C}You Are Not In Any Vehicle");
			new vehicleid = GetPlayerVehicleID(playerid);
			DestroyVehicle(vehicleid);
		}
	}
	return 1;
}

CMD:aheli(playerid)
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 2)
		{
			new Float: x, Float: y, Float: z, Float: r, vehicle;
			GetPlayerPos(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,r);
			vehicle = CreateVehicle(501,x,y,z,r,1,1,300);
			PutPlayerInVehicle(playerid,vehicle,0);
			SetVehicleHealth(vehicle, 999999);
			SetVehicleVirtualWorld(vehicle, GetPlayerVirtualWorld(playerid));
			LinkVehicleToInterior(vehicle, GetPlayerInterior(playerid));
		}
	}
	return 1;
}

CMD:acar(playerid)
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 2)
		{
			new Float: x, Float: y, Float: z, Float: r, vehicle;
			GetPlayerPos(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,r);
			vehicle = CreateVehicle(441,x,y,z,r,1,1,300);
			PutPlayerInVehicle(playerid,vehicle,0);
			SetVehicleHealth(vehicle, 999999);
			SetVehicleVirtualWorld(vehicle, GetPlayerVirtualWorld(playerid));
			LinkVehicleToInterior(vehicle, GetPlayerInterior(playerid));
		}
	}
	return 1;
}

CMD:skip(playerid)
{
	if (pInfo[playerid][pAdminLevel] >= 2)
	{
		gTime = 5;
	}
	return 1;
}

CMD:ann2(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 2 || IsPlayerAdmin(playerid))
	{
		if (!strlen(params)) return SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /ann2 [text]");
		if (strlen(params) > 100) return SendClientMessage(playerid, COLOR_GREY, "Your message must not exceed 100 characters");
		
		new str[128];
		SendClientMessageToAll(COLOR_LIGHTBLUE, "|~~~~~~~~~~ Admin Announcement ~~~~~~~~~~|");
		format(str, sizeof str, "{9999FF}%s", params);
		SendClientMessageToAll(COLOR_GREEN, str);
		SendClientMessageToAll(COLOR_LIGHTBLUE, "|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|");
	}
	return 1;
}

CMD:settime(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 2 || IsPlayerAdmin(playerid))
	{
		new time2,string[128];
		if (sscanf(params, "i", time2)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /settime [time]");
		if (time2 < 0 || time2 > 24) return SendClientMessage(playerid, -1, "{DC143C}ERROR: Invalid time hour, must be between 0-24.");

		SetWorldTime(time2);

		if (IsPlayerAdmin(playerid))
		{
			format(string, sizeof string, ""chat" Time Changed To %d",time2);
			SendClientMessageToAll(-1,string);
		}
		else
		{
			format(string, sizeof string, "{DC143C}%s %s has changed the time to %d",GetAdminRankName(playerid), GetPlayerNameEx(playerid),time2);
			SendClientMessageToAll(-1,string);
		}
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:setweather(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 2 || IsPlayerAdmin(playerid))
	{
		new weather,string[128];
		if (sscanf(params, "i", weather)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /setweather [weather id]");
		if (weather < 0 || weather > 20) return SendClientMessage(playerid, -1, "{DC143C}ERROR: Invalid weather, must be between 0-20.");

		SetWeather(weather);

		if (IsPlayerAdmin(playerid))
		{
			format(string, sizeof string, ""chat" Weather Changed to %d",weather);
			SendClientMessageToAll(-1,string);
		}
		else
		{
			format(string, sizeof string, "{DC143C}%s %s has changed the weather to %d",GetAdminRankName(playerid), GetPlayerNameEx(playerid),weather);
			SendClientMessageToAll(-1,string);
		}
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:get(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 2)
	{
		new lookupid;
		if (sscanf(params, "u", lookupid)) SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /get [playerid]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerPos(lookupid, x+1, y+1, z);

		if (IsPlayerInAnyVehicle(lookupid))
		{
			SetVehiclePos(GetPlayerVehicleID(lookupid),x,y,z);
		}
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:goto(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 2)
	{
		new lookupid;
		if (sscanf(params, "u", lookupid)) SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /goto [playerid]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		new Float:x,Float:y,Float:z,inter;
		GetPlayerPos(lookupid,Float:x,Float:y,Float:z);
		inter = GetPlayerInterior(lookupid);
		SetPlayerPosEx(playerid,Float:x,Float:y,Float:z,inter,0);
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}
///////////////////////////////////////////////////////////
///////////==============LEVEL 3================///////////
CMD:freezeteam(playerid, params[])
{
	if (pInfo[playerid][pAdminLevel] >= 3)
	{
		new teams[100];
		if (sscanf(params,"s[100]",teams)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /freezeteam [Team Name] (Zombie/Human)");
		//-----------------------------------
		if (strfind(params,"Zombie",true) != -1)
		{
			foreach(new i : Player)
			{
				if (pInfo[i][pTeam] == TEAM_ZOMBIE)
				{
					TogglePlayerControllable(i, false);
				}
			}
			new string[100];
			format(string, sizeof string,"{DC143C}%s %s has frozen team {FFFFFF}Zombies",GetAdminRankName(playerid), GetPlayerNameEx(playerid));
			SendClientMessageToAll(-1, string);
		}
		//---------------------------------
		if (strfind(params,"Human",true) != -1)
		{
			foreach(new i : Player)
			{
				if (pInfo[i][pTeam] == TEAM_HUMAN)
				{
					TogglePlayerControllable(i, false);
				}
			}
			new string[100];
			format(string, sizeof string,"{DC143C}%s %s has frozen team {FFFFFF}Humans",GetAdminRankName(playerid), GetPlayerNameEx(playerid));
			SendClientMessageToAll(-1, string);
		}
	}
	return 1;
}

CMD:unfreezeteam(playerid, params[])
{
	if (pInfo[playerid][pAdminLevel] >= 3)
	{
		new teams[100];
		if (sscanf(params,"s[100]",teams)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /unfreezeteam [Team Name] (Zombie/Human)");
		//-----------------------------------
		if (strfind(params,"Zombie",true) != -1)
		{
			foreach(new i : Player)
			{
				if (pInfo[i][pTeam] == TEAM_ZOMBIE)
				{
					TogglePlayerControllable(i, true);
				}
			}
			new string[100];
			format(string, sizeof string,"{DC143C}%s %s has unfrozen team {FFFFFF}Zombies",GetAdminRankName(playerid), GetPlayerNameEx(playerid));
			SendClientMessageToAll(-1, string);
		}
		//---------------------------------
		if (strfind(params,"Human",true) != -1)
		{
			foreach(new i : Player)
			{
				if (pInfo[i][pTeam] == TEAM_HUMAN)
				{
					TogglePlayerControllable(i, true);
				}
			}
			new string[100];
			format(string, sizeof string,"{DC143C}%s %s has unfrozen team {FFFFFF}Humans",GetAdminRankName(playerid), GetPlayerNameEx(playerid));
			SendClientMessageToAll(-1, string);
		}
	}
	return 1;
}

CMD:atank(playerid)
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 3)
		{
			new Float: x, Float: y, Float: z, Float: r, vehicle;
			GetPlayerPos(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,r);
			vehicle = CreateVehicle(564,x,y,z,r,1,1,300);
			PutPlayerInVehicle(playerid,vehicle,0);
			SetVehicleHealth(vehicle, 999999);
			SetVehicleVirtualWorld(vehicle, GetPlayerVirtualWorld(playerid));
			LinkVehicleToInterior(vehicle, GetPlayerInterior(playerid));
		}
	}
	return 1;
}

CMD:restart(playerid)
{
	if (pInfo[playerid][pAdminLevel] >= 3)
	{
		GameTextForAll("~>~~r~Server ~g~Restarting~<~", 5000, 3 );
		SendRconCommand("gmx");
	}
	return 1;
}

CMD:xp(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 3)
	{
		new xpID,string[256],xpString[64];
		if (sscanf(params, "i", xpID)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /xp [XP Type ID] (1normal,2double,3triple,4quad)");
		if (xpID < 1 || xpID > 4) return SendClientMessage(playerid, -1, "{DC143C}Invalid XP Type ID.");
		{
			format(string, sizeof string,"{DC143C}%s %s has changed the XP variable to %s",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetXPName());
			SendClientMessageToAll(-1,string);
			
			Map[XPType] = xpID;
			switch (xpID)
			{
				case 1: format(xpString,sizeof(xpString),"~p~Normal XP"),TextDrawSetString(gXPTD,xpString);
				case 2: format(xpString,sizeof(xpString),"~b~Double XP"),TextDrawSetString(gXPTD,xpString);
				case 3: format(xpString,sizeof(xpString),"~y~Triple XP"),TextDrawSetString(gXPTD,xpString);
				case 4: format(xpString,sizeof(xpString),"~r~Quad XP"),TextDrawSetString(gXPTD,xpString);
			}
		}
	}
	return 1;
}

CMD:setzombie(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 3)
	{
		if (IsPlayerConnected(playerid))
		{
			new lookupid,str[256];
			if (sscanf(params, "u", lookupid)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /setzombie [playerid]");
			if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

			ZombieSetup(lookupid);
			SpawnPlayer(lookupid);
			CurePlayer(playerid);
			format(str,sizeof str,"{DC143C}%s %s(%i) has set your team to Zombie.",GetAdminRankName(playerid), GetPlayerNameEx(playerid),playerid);
			SendClientMessage(lookupid,-1,str);
			format(str,sizeof str,""chat""COL_LGREEN" You have changed %s(%i) team to Zombie.",GetPlayerNameEx(lookupid),lookupid);
			SendClientMessage(playerid,-1,str);
		}
	}
	return 1;
}

CMD:sethuman(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 3)
	{
		if (IsPlayerConnected(playerid))
		{
			new lookupid,str[256];
			if (sscanf(params, "u", lookupid)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /sethuman [playerid]");
			if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

			HumanSetup(lookupid);
			SpawnPlayer(lookupid);
			CurePlayer(playerid);
			format(str,sizeof str,"{DC143C}%s %s(%i) has set your team to Human.",GetAdminRankName(playerid), GetPlayerNameEx(playerid),playerid);
			SendClientMessage(lookupid,-1,str);
			format(str,sizeof str,""chat""COL_LGREEN" You have changed %s(%i) team to Human.",GetPlayerNameEx(lookupid),lookupid);
			SendClientMessage(playerid,-1,str);
		}
	}
	return 1;
}

CMD:ann(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 3)
	{
		new param[40];
		if (sscanf(params, "s[40]")) return SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /ann [text]");
		
		GameTextForAll(param,5000,3);
	}
	return 1;
}

CMD:ip(playerid, params[])
{
	if (pInfo[playerid][pAdminLevel] >= 3)
	{
		new lookupid,playerip[16],string[128];
		if (sscanf(params, "u", lookupid, playerip)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /ip [playerid]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		GetPlayerIp(lookupid, playerip, sizeof(playerip));
		format(string, sizeof string, ""chat" IP of %s %s", GetPlayerNameEx(lookupid), playerip);
		SendClientMessage(playerid, -1, string);
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}
///////////////////////////////////////////////////////////
///////////==============LEVEL 4================///////////
CMD:givexp(playerid,params[])
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 4)
		{
			new lookupid,givexp,string[256];
			if (sscanf(params, "ui", lookupid, givexp)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /givexp [playerid] [amount]");
			if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

			if (givexp < -2000 || givexp > 2000) return SendClientMessage(playerid,-1,""chat"  You can only give XP between Negative 2000 - Positive 2000.");
			pInfo[lookupid][pXP] += givexp;

			format(string, sizeof string, "{DC143C}%s %s has given %s %d XP.",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),givexp);
			SendClientMessageToAll(-1,string);
			SetPlayerScore(playerid,pInfo[playerid][pXP]);
			UpdateXPTextdraw(playerid);
		}
		else {
			SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
		}
	}
	else {
		SendClientMessage(playerid,-1,""chat" Your not logged in.");
		KickPlayer(playerid);
	}
	return 1;
}

CMD:givecash(playerid, params[])
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 4)
		{
		new targetplayer, amount;
		if (sscanf(params, "ui", targetplayer, amount)) return SendClientMessage(playerid, COLOR_ORANGE, "{C0C0C0}USAGE: /givemoney [playerid] [amount]");
		if (!IsPlayerConnected(targetplayer)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		new string[100];
		GivePlayerMoney(targetplayer, amount);
		pInfo[targetplayer][pCash] += amount;
		format(string, sizeof string, "{DC143C}%s %s gave you $%i.", GetAdminRankName(playerid), GetPlayerNameEx(playerid),amount);
		SendClientMessage(targetplayer, COLOR_GREEN, string);
		}
		else {
			SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
		}
	}
	else {
		SendClientMessage(playerid,-1,""chat" Your not logged in.");
		KickPlayer(playerid);
	}
	return 1;
}

CMD:givetokens(playerid,params[])
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 4)
		{
			new lookupid,givecoin,string[256];
			if (sscanf(params, "ui", lookupid, givecoin)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /givetokens [playerid] [amount]");
			if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

			if (givecoin < 1 || givecoin > 10) return SendClientMessage(playerid,-1,""chat" You can only give coins between 1 and 10.");
			pInfo[lookupid][pCoins] += givecoin;
			UpdateTokensTextdraw(playerid);

			format(string, sizeof string, "{DC143C}%s %s has given %s %d Tokens.",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),givecoin);
			SendClientMessageToAll(-1,string);
		}
		else {
			SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
		}
	}
	else {
		SendClientMessage(playerid,-1,""chat" Your not logged in.");
		KickPlayer(playerid);
	}
	return 1;
}

CMD:setxp(playerid,params[])
{
	if (pInfo[playerid][pLogged] == 1)
	{
		if (pInfo[playerid][pAdminLevel] >= 4)
		{
			new lookupid,givexp,string[256];
			if (sscanf(params, "ui", lookupid, givexp)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /setxp [playerid] [amount]");
			if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

			pInfo[lookupid][pXP] = givexp;
			SetPlayerScore(playerid,pInfo[playerid][pXP]);
			UpdateXPTextdraw(playerid);

			format(string, sizeof string, "{DC143C}%s %s has set %s XP to %d",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid),givexp);
			SendClientMessageToAll(-1,string);
		}
		else {
			SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
		}
	}
	else {
		SendClientMessage(playerid,-1,""chat" Your not logged in.");
		KickPlayer(playerid);
	}
	return 1;
}
///////////////////////////////////////////////////////////
///////////==============LEVEL 5================///////////
CMD:setadmin(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 5)
	{
		new lookupid,level,string[256];
		if (sscanf(params, "ud", lookupid, level)) return  SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /setlevel [playerid] [level]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");
		if (level < 0 || level > 5) return SendClientMessage(playerid,-1,""chat" Administrator levels are ONLY between 1-5.");

		pInfo[lookupid][pAdminLevel] = level;

		format(string, sizeof string, "{DC143C}%s %s have given Admin status of %d to %s",GetAdminRankName(playerid), GetPlayerNameEx(playerid),level,GetPlayerNameEx(lookupid));
		SendClientMessageToAll(-1,string);
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:offlinesetadmin(playerid, params[])
{
	if (pInfo[playerid][pAdminLevel] >= 5)
	{
		new targetname[24], level;
		if (sscanf(params, "s[24]d", targetname, level)) return SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /offlinesetadmin [Player Name] [Level]");
		if (level < 0 || level > 5) return SendClientMessage(playerid, -1, "{DC143C}ERROR: Level should be between 0 to 5");

		new query[130], DBResult: result;
		format(query, sizeof query, "UPDATE "TABLE_USERS" SET "FIELD_ADMIN" = %d WHERE "FIELD_ID" = (SELECT "FIELD_ID" FROM "TABLE_USERS" WHERE "FIELD_NAME" = '%q'", level, targetname);
		result = db_query(gSQL, query);

		if (!db_num_rows(result))
		{
			SendClientMessage(playerid, -1, "The player name you have chosen was not found in our system.");
		}
		else
		{
			format(query, sizeof query, "{DC143C}You have set the offline player %s as Admin level %d.", targetname, level);
			SendClientMessage(playerid, -1, query);
		}

		db_free_result(result);
	}
	return 1;
}

CMD:setvip(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 5)
	{
		new lookupid,level,string[256];
		if (sscanf(params, "ud", lookupid, level)) return  SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /setvip [playerid] [level]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");
		if (level < 0 || level > 3) return SendClientMessage(playerid,-1,""chat" VIP levels are ONLY between 0-3.");

		pInfo[lookupid][pVipLevel] = level;

		format(string, sizeof string, "{DC143C}%s %s have given VIP status to %s.",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid));
		SendClientMessageToAll(-1,string);
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:offlinesetvip(playerid, params[])
{
	if (pInfo[playerid][pAdminLevel] >= 5)
	{
		new targetname[24], level;
		if (sscanf(params, "s[24]d", targetname, level)) return SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /offlinesetvip [Player Name] [Level]");
		if (level < 0 || level > 3) return SendClientMessage(playerid, -1, "{DC143C}ERROR: Level should be between 0 to 3");

		new query[130], DBResult: result;
		format(query, sizeof query, "UPDATE "TABLE_USERS" SET "FIELD_VIP" = %d WHERE "FIELD_ID" = (SELECT "FIELD_ID" FROM "TABLE_USERS" WHERE "FIELD_NAME" = '%q'", level, targetname);
		result = db_query(gSQL, query);

		if (!db_num_rows(result))
		{
			SendClientMessage(playerid, -1, "The player name you have chosen was not found in our system.");
		}
		else
		{
			format(query, sizeof query, "{DC143C}You have set the offline player %s as Vip level %d.", targetname, level);
			SendClientMessage(playerid, -1, query);
		}

		db_free_result(result);
	}
	return 1;
}

CMD:nuke(playerid,params[])
{
	if (pInfo[playerid][pAdminLevel] >= 5)
	{
		new lookupid,string[256];
		if (sscanf(params, "u", lookupid)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /nuke [playerid]");
		if (!IsPlayerConnected(lookupid)) return SendClientMessage(playerid,-1,""chat" Player is not online.");

		new Float:x,Float:y,Float:z;
		GetPlayerPos(lookupid,Float:x,Float:y,Float:z);
		CreateExplosion(Float:x,Float:y,Float:z,0,10.0);

		format(string, sizeof string, "{DC143C}%s %s has blown up %s",GetAdminRankName(playerid), GetPlayerNameEx(playerid),GetPlayerNameEx(lookupid));
		SendClientMessageToAll(-1,string);
	}
	else {
		SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");
	}
	return 1;
}

CMD:dj(playerid, params[])
{
	if (pInfo[playerid][pAdminLevel] >= 5)
	{
		if (sscanf(params, "s[256]", params)) return SendClientMessage(playerid, -1, "{C0C0C0}USAGE: /vdj [Link]");
		foreach(new i : Player)
		{
			PlayAudioStreamForPlayer(i, params);
		}
	}
	return 1;
}

function RandomMessages()
{
	return SendClientMessageToAll(-1, gRandomMessages[random(sizeof gRandomMessages)]);
}

LoadAccount(playerid)
{
	new query[68], DBResult: result;
	format(query, sizeof query, "SELECT * FROM "TABLE_USERS" WHERE "FIELD_ID" = %d LIMIT 1", pInfo[playerid][pID]);
	result = db_query(gSQL, query);

	pInfo[playerid][pCash] = db_get_field_assoc_int(result, FIELD_CASH);
	pInfo[playerid][pXP] = db_get_field_assoc_int(result, FIELD_XP);
	pInfo[playerid][pKills] = db_get_field_assoc_int(result, FIELD_KILLS);
	pInfo[playerid][pDeaths] = db_get_field_assoc_int(result, FIELD_DEATHS);
	pInfo[playerid][pHeads] = db_get_field_assoc_int(result, FIELD_HEADS);
	pInfo[playerid][pRank] = db_get_field_assoc_int(result, FIELD_RANK);
	pInfo[playerid][pEvac] = db_get_field_assoc_int(result, FIELD_EVAC);
	pInfo[playerid][pAdminLevel] = db_get_field_assoc_int(result, FIELD_ADMIN);
	pInfo[playerid][pVipLevel] = db_get_field_assoc_int(result, FIELD_VIP);
	pInfo[playerid][pTime] = db_get_field_assoc_int(result, FIELD_TIME);
	pInfo[playerid][pMapsPlayed] = db_get_field_assoc_int(result, FIELD_MAPS);
	pInfo[playerid][pCoins] = db_get_field_assoc_int(result, FIELD_COINS);
	pInfo[playerid][pKickBackCoin] = db_get_field_assoc_int(result, FIELD_KICKBACK);
	pInfo[playerid][pDamageShotgunCoin] = db_get_field_assoc_int(result, FIELD_DMGSHOTGUN);
	pInfo[playerid][pDamageDeagleCoin] = db_get_field_assoc_int(result, FIELD_DMGDEAGLE);
	pInfo[playerid][pDamageMP5Coin] = db_get_field_assoc_int(result, FIELD_DMGMP5);

	db_free_result(result);
	return 1;
}

ClearChat()
{
	for(new a = 0; a < 129; a++) SendClientMessageToAll(-1, " ");
	return 1;
}

ResetVars(playerid)
{
	CurePlayer(playerid);
	KillTimer(pInfo[playerid][IsPlayerInfectedTimer]);
	
	static const RESET_PINFO[E_PLAYER_INFO];
	pInfo[playerid] = RESET_PINFO;

	SetPVarInt(playerid, "SPS Messages Sent", 0);
	SetPVarInt(playerid, "SPS Muted", 0);
	SetPVarInt(playerid, "SPS Spam Warnings", 0);
	return 1;
}

ResetCoinVars(playerid)
{
	pInfo[playerid][pKickBackCoin] = 0;
	pInfo[playerid][pDamageShotgunCoin] = 0;
	pInfo[playerid][pDamageDeagleCoin] = 0;
	pInfo[playerid][pDamageMP5Coin] = 0;
	return 1;
}

ConnectVars(playerid)
{
	TextDrawShowForPlayer(playerid, ServerIntroOne[playerid]);
	TextDrawShowForPlayer(playerid, ServerIntroTwo[playerid]);
	pInfo[playerid][pClass] = CIVILIAN;
	pInfo[playerid][pClass] = STANDARDZOMBIE;
	pInfo[playerid][pTeam] = 0;
	return 1;
}

CMD:ban(playerid, params[]) {
	if (pInfo[playerid][pAdminLevel] < 2) return SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");

	new lookupid, reason[MAX_REASON_LEN];
	if (sscanf(params, "us["#MAX_REASON_LEN"]", lookupid, reason)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /ban [playerid] [reason]");
	if (lookupid == INVALID_PLAYER_ID) return SendClientMessage(playerid,-1,""chat" Player is not online.");

	BanPlayer(lookupid, reason, playerid);
	return 1;
}

CMD:unban(playerid, params[]) {
	if (pInfo[playerid][pAdminLevel] < 2) return SendClientMessage(playerid,COLOR_RED,"{FF0000}You don't have permission to use this command!");

	new name[MAX_PLAYER_NAME];
	if (sscanf(params, "s[24]", name)) return SendClientMessage(playerid,-1,"{C0C0C0}USAGE: /unban [username]");
	if (CheckBan(name)) return SendClientMessage(playerid,-1,""chat" Ban for that username doesn't exist.");

	UnbanPlayer(name);
	return 1;
}

BanPlayer(playerid, reason[], adminid) {
	new
		string[500],
		query[56 + MAX_PLAYER_NAME + MAX_REASON_LEN],
		Admin_Name[MAX_PLAYER_NAME] = "Anti Cheat";

	TogglePlayerControllable(playerid, false);

	if (adminid != INVALID_PLAYER_ID) {
		Admin_Name[0] = GetPlayerNameEx(adminid);

		format(string, sizeof string, "[{00FF80}ADMIN{FFFFFF}]: {00FF80}%s (ID:%d) has been banned from the server {FFFFFF}[{00FF80}%s{FFFFFF}]", GetPlayerNameEx(playerid), playerid, reason);
	}
	else {
		format(string, sizeof string, "[{00FF80}ANTI-CHEAT{FFFFFF}]: {00FF80}%s (ID:%d) has been banned from the server {FFFFFF}[{00FF80}%s{FFFFFF}]", GetPlayerNameEx(playerid), playerid, reason);
	}

	format(query, sizeof query, "INSERT INTO "#TABLE_BANS" (`Name`, `Reason`) VALUES('%q', '%q')", GetPlayerNameEx(playerid), reason);
	db_free_result(db_query(gSQL, query));

	SendClientMessageToAll(-1, string);
	
	string[0] = EOS;
	strcat(string, "{FF0000}You're banned from the server!\n\n");

	format(query, sizeof query, "{FFFFFF}Reason:{FF0000}: %s\n{FFFFFF}Banned By:{00FF80} %s\n\n", reason, Admin_Name);
	strcat(string, query);
	strcat(string, "{FFFFFF}You can post Ban Appeal on our Forums:\n{FFFF33}www.samp-zombieland.info\n");
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_TABLIST, "{00FF80}BANNED!", string, "Accept", "");
	
	return KickPlayer(playerid);
}

UnbanPlayer(name[]) {
	new query[38 + MAX_PLAYER_NAME];

	format(query, sizeof query, "DELETE FROM "#TABLE_BANS" WHERE `Name` = '%q'", name);
	db_free_result(db_query(gSQL, query));
	return 1;
}

CheckBan(name[]) {
	new query[48 + MAX_PLAYER_NAME], DBResult: result, num_rows;

	format(query, sizeof query, "SELECT * FROM "#TABLE_BANS" WHERE `Name` = '%q' LIMIT 1", name);
	result = db_query(gSQL, query);

	num_rows = db_num_rows(result);
	db_free_result(result);
	return num_rows; // Returns the number of rows (0 is not banned, anything else than 0 is banned)
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);
	if (GetPlayerVehicleID(playerid)) {
		GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

SetPlayerPosEx( playerid, Float: posx, Float: posy, Float: posz, interior, virtualworld )
{
	if (GetPlayerState(playerid) == 2) {
		SetPlayerVirtualWorld( playerid, virtualworld );
		SetVehicleVirtualWorld( GetPlayerVehicleID( playerid ), virtualworld );
		LinkVehicleToInterior( GetPlayerVehicleID( playerid ), interior );
		SetPlayerInterior( playerid, interior );
		SetVehiclePos( GetPlayerVehicleID( playerid ), posx, posy, posz );
		return 1;
	}
	else {
		SetPlayerVirtualWorld( playerid, virtualworld );
		SetPlayerInterior( playerid, interior );
		SetPlayerPos( playerid, posx, posy, posz );
		return 1;
	}
}

SendMessageToAdmins(message[], color)
{
	foreach(new i : Player)
	{
		if (pInfo[i][pAdminLevel] >= 1 || IsPlayerAdmin(i))
		{
			SendClientMessage(i, color, message);
		}
	}
	return 1;
}

SendMessageToAllVips(message[], color)
{
	foreach(new i : Player)
	{
		if (pInfo[i][pVipLevel] >= 1)
		{
			SendClientMessage(i, color, message);
		}
	}
	return 1;
}

SendZMessage(message[], color)
{
	foreach(new i : Player)
	{
		if (pInfo[i][pTeam] == TEAM_ZOMBIE)
		{
			SendClientMessage(i, color, message);
		}
	}
	return 1;
}

SendHMessage(message[], color)
{
	foreach(new i : Player)
	{
		if (pInfo[i][pTeam] == TEAM_HUMAN)
		{
			SendClientMessage(i, color, message);
		}
	}
	return 1;
}

SendXPError(playerid,xp)
{
	new string[128];
	format(string, sizeof string,""chat""COL_PINK" {CA97CA}You need atleast {FFD700}%i XP{CA97CA}, to use this class or command.",xp);
	SendClientMessage(playerid,-1,string);
	return 1;
}

SendCoinError(playerid,coin)
{
	new string[128];
	format(string, sizeof string,""chat""COL_PINK" {CA97CA}You need {FFD700}%i Tokens{CA97CA}, to use this feature.",coin);
	SendClientMessage(playerid,-1,string);
	return 1;
}

SendVipError(playerid,viplevel)
{
	new string[128];
	format(string, sizeof string,""chat""COL_PINK" {CA97CA}You need to be higher level {FFD700}VIP{CA97CA}, to use this command.",viplevel);
	SendClientMessage(playerid,-1,string);
	return 1;
}

LoadMap(mapid) { // Re-written by Logic_
	new query[60], DBResult: result;
	format(query, sizeof query, "SELECT * FROM "TABLE_MAPS" WHERE "FIELD_MAP_ID" = %d", gMaps[mapid]);
	result = db_query(gSQL, query);

	if (db_num_rows(result)) { 
		printf("Loading map ID %d.", mapid);

		db_get_field_assoc(result, FIELD_MAP_FS_NAME, Map[FSMapName], sizeof Map[FSMapName]);
		LoadFilterScript(Map[FSMapName]);

		db_get_field_assoc(result, FIELD_MAP_NAME, Map[MapName], sizeof Map[MapName]);
		format(query, sizeof query, "mapname %s", Map[MapName]);
		SendRconCommand(query);

		Map[HumanSpawnX] = db_get_field_assoc_float(result, FIELD_MAP_HUMAN_SPAWN_X);
		Map[HumanSpawnY] = db_get_field_assoc_float(result, FIELD_MAP_HUMAN_SPAWN_Y);
		Map[HumanSpawnZ] = db_get_field_assoc_float(result, FIELD_MAP_HUMAN_SPAWN_Z);
		
		Map[HumanSpawn2X] = db_get_field_assoc_float(result, FIELD_MAP_HUMAN_SPAWN2_X);
		Map[HumanSpawn2Y] = db_get_field_assoc_float(result, FIELD_MAP_HUMAN_SPAWN2_Y);
		Map[HumanSpawn2Z] = db_get_field_assoc_float(result, FIELD_MAP_HUMAN_SPAWN2_Z);
		
		Map[ZombieSpawnX] = db_get_field_assoc_float(result, FIELD_MAP_ZOMBIE_SPAWN_X);
		Map[ZombieSpawnY] = db_get_field_assoc_float(result, FIELD_MAP_ZOMBIE_SPAWN_Y);
		Map[ZombieSpawnZ] = db_get_field_assoc_float(result, FIELD_MAP_ZOMBIE_SPAWN_Z);
		
		Map[Interior] = db_get_field_assoc_int(result, FIELD_MAP_INTERIOR);
		
		Map[GateX] = db_get_field_assoc_float(result, FIELD_MAP_GATE_X);
		Map[GateY] = db_get_field_assoc_float(result, FIELD_MAP_GATE_Y);
		Map[GateZ] = db_get_field_assoc_float(result, FIELD_MAP_GATE_Z);
		
		Map[GaterX] = db_get_field_assoc_float(result, FIELD_MAP_GATE2_X);
		Map[GaterY] = db_get_field_assoc_float(result, FIELD_MAP_GATE2_Y);
		Map[GaterZ] = db_get_field_assoc_float(result, FIELD_MAP_GATE2_Z);
		
		Map[CPx] = db_get_field_assoc_float(result, FIELD_MAP_CP_X);
		Map[CPy] = db_get_field_assoc_float(result, FIELD_MAP_CP_Y);
		Map[CPz] = db_get_field_assoc_float(result, FIELD_MAP_CP_Z);
		
		Map[MoveGate] = db_get_field_assoc_int(result, FIELD_MAP_MOVE_GATE);
		Map[GateID] = db_get_field_assoc_int(result, FIELD_MAP_GATE_ID);
		Map[AllowWater] = db_get_field_assoc_int(result, FIELD_MAP_WATER);
		Map[EvacType] = db_get_field_assoc_int(result, FIELD_MAP_EVAC_TYPE);
		
		Map[Weather] = db_get_field_assoc_int(result, FIELD_MAP_WEATHER);
		SetWeather(Map[Weather]);

		Map[Time] = db_get_field_assoc_int(result, FIELD_MAP_TIME);
		SetWorldTime(Map[Time]);
		
		printf("Map ID %d's Information Has Been Loaded.", mapid);
	}

	db_free_result(result);
	return 0;
}

ClearObjects()
{
	for(new i; i<MAX_OBJECTS; i++)
	{
		if (IsValidObject(i)) DestroyObject(i);
	}
}

DestroyAllVehicle()
{
	for(new i=1;i<=MAX_VEHICLES;i++)
	{
		DestroyVehicle(i);
	}
	return 1;
}

LoadFilterScript(filename[])
{
	new string[50];
	format(string, sizeof string, "loadfs %s", filename);
	SendRconCommand(string);
	return 1;
}

UnloadFilterScript(filename[])
{
	new string[50];
	format(string, sizeof string, "unloadfs %s", filename);
	SendRconCommand(string);
	return 1;
}

HumanSetup(playerid)
{
	SetPlayerTeam(playerid,TEAM_HUMAN);
	SetPlayerHealth(playerid,100.0);
	pInfo[playerid][pTeam] = TEAM_HUMAN;
	SetPlayerColor(playerid,COLOR_HUMAN);
	return 1;
}

ZombieSetup(playerid)
{
	SetPlayerTeam(playerid,TEAM_ZOMBIE);
	pInfo[playerid][pTeam] = TEAM_ZOMBIE;
	SetPlayerColor(playerid,COLOR_ZOMBIE);
	return 1;
}

ZombieSetup2(playerid)
{
	SetPlayerTeam(playerid,TEAM_ZOMBIE);
	pInfo[playerid][pTeam] = TEAM_ZOMBIE;
	SetPlayerColor(playerid,COLOR_ZOMBIE);
	SpawnPlayer(playerid);
	return 1;
}

forward Float:GetDistanceBetweenPlayers(p1,p2);
public Float:GetDistanceBetweenPlayers(p1,p2) {
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if (!IsPlayerConnected(p1) || !IsPlayerConnected(p2)) {
		return -1.00;
	}
	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

GetClosestPlayer(playerid)
{
	new
		lookupid = INVALID_PLAYER_ID,
		Float: distance = 9999.0,
		Float: distance2;
	
	foreach (new i : Player)
	{
		if (i == playerid) continue;

		distance2 = GetDistanceBetweenPlayers(i, playerid);
		if (distance2 < distance && distance2 != -1.0)
		{
			distance = distance2;
			lookupid = i;
		}
	}
	
	return lookupid;
}

IsPlayerInWater(playerid)
{
	new animlib[32],tmp[32];
	GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,tmp,32);
	if ( !strcmp(animlib, "SWIM") && !IsPlayerInAnyVehicle(playerid) ) return true;
	return false;
}

GetTeamPlayersAlive(teamid) { // Modified by Logic_

	new count;
	foreach (new i : Player) {
		if (pInfo[i][pTeam] == teamid) count ++;
	}
	return count;
}

EvenTeam() { // Modified by Logic_

	new count = Iter_Count(Player), number = (count % 2);

	count /= 2;
	if (number) count --;

	foreach(new i : Player)
	{
		if (GetTeamPlayersAlive(TEAM_ZOMBIE) == count) break;
		if (pInfo[i][pTeam] == TEAM_ZOMBIE) continue;

		ZombieSetup2(i);
	}
}

DefaultTextdraws()
{
	TimeLeft = TextDrawCreate(540.000000, 37.000000, "0:00");
	TextDrawBackgroundColor(TimeLeft, 68);
	TextDrawFont(TimeLeft, 1);
	TextDrawLetterSize(TimeLeft, 0.689999, 2.499999);
	TextDrawColor(TimeLeft, -1);
	TextDrawSetOutline(TimeLeft, 1);
	TextDrawSetProportional(TimeLeft, 1);
	TextDrawSetShadow(TimeLeft, 1);

	remadeText2 = TextDrawCreate(565.000000, 23.000000, "ld_grav:timer");
	TextDrawBackgroundColor(remadeText2, 255);
	TextDrawFont(remadeText2, 4);
	TextDrawLetterSize(remadeText2, 1.289999, 0.599999);
	TextDrawColor(remadeText2, -1);
	TextDrawSetOutline(remadeText2, 0);
	TextDrawSetProportional(remadeText2, 1);
	TextDrawSetShadow(remadeText2, 1);
	TextDrawUseBox(remadeText2, 1);
	TextDrawBoxColor(remadeText2, 255);
	TextDrawTextSize(remadeText2, 22.000000, 14.000000);
	TextDrawSetSelectable(remadeText2, 0);

	gXPTD = TextDrawCreate(498.000000, 99.000000, "~n~");
	TextDrawBackgroundColor(gXPTD, 68);
	TextDrawFont(gXPTD, 2);
	TextDrawLetterSize(gXPTD, 0.240000, 1.499999);
	TextDrawColor(gXPTD, -1);
	TextDrawSetOutline(gXPTD, 1);
	TextDrawSetProportional(gXPTD, 1);
	TextDrawSetShadow(gXPTD, 1);

	AliveInfo = TextDrawCreate(255.000000, 428.000000, "0 HUMANS ALIVE VS ZOMBIES ALIVE 0");
	TextDrawBackgroundColor(AliveInfo, 1911);
	TextDrawFont(AliveInfo, 2);
	TextDrawLetterSize(AliveInfo, 0.300000, 1.500000);
	TextDrawColor(AliveInfo, -1);
	TextDrawSetOutline(AliveInfo, 1);
	TextDrawSetProportional(AliveInfo, 1);
	TextDrawSetShadow(AliveInfo, 1);

	CurrentMap = TextDrawCreate(19.000000, 429.000000, "Map:~w~ Loading...");
	TextDrawBackgroundColor(CurrentMap, 51);
	TextDrawFont(CurrentMap, 1);
	TextDrawLetterSize(CurrentMap, 0.300000, 1.299999);
	TextDrawColor(CurrentMap, -16776961);
	TextDrawSetOutline(CurrentMap, 1);
	TextDrawSetProportional(CurrentMap, 1);
	TextDrawSetShadow(CurrentMap, 1);

	EventText = TextDrawCreate(40.000000, 321.000000, "Zombieland");
	TextDrawBackgroundColor(EventText, 51);
	TextDrawFont(EventText, 3);
	TextDrawLetterSize(EventText, 0.349999, 1.800000);
	TextDrawColor(EventText, -16776961);
	TextDrawSetOutline(EventText, 1);
	TextDrawSetProportional(EventText, 1);
	TextDrawSetShadow(EventText, 1);

	aod = TextDrawCreate(548.000000, 52.000000, "ADMIN ON DUTY");
	TextDrawBackgroundColor(aod, 255);
	TextDrawFont(aod, 1);
	TextDrawLetterSize(aod, 0.210000, 1.600000);
	TextDrawColor(aod, 1728001023);
	TextDrawSetOutline(aod, 0);
	TextDrawSetProportional(aod, 1);
	TextDrawSetShadow(aod, 1);
	TextDrawSetSelectable(aod, 0);

	aodbox = TextDrawCreate(610.000000, 55.000000, "_");
	TextDrawBackgroundColor(aodbox, 255);
	TextDrawFont(aodbox, 1);
	TextDrawLetterSize(aodbox, 0.500000, 1.000000);
	TextDrawColor(aodbox, -1);
	TextDrawSetOutline(aodbox, 0);
	TextDrawSetProportional(aodbox, 1);
	TextDrawSetShadow(aodbox, 1);
	TextDrawUseBox(aodbox, 1);
	TextDrawBoxColor(aodbox, 119);
	TextDrawTextSize(aodbox, 544.000000, 0.000000);
	TextDrawSetSelectable(aodbox, 0);

	www = TextDrawCreate(512.000000, 433.000000, "www.");
	TextDrawBackgroundColor(www, 255);
	TextDrawFont(www, 2);
	TextDrawLetterSize(www, 0.180000, 1.299998);
	TextDrawColor(www, -1);
	TextDrawSetOutline(www, 1);
	TextDrawSetProportional(www, 1);
	TextDrawSetSelectable(www, 0);

	samps = TextDrawCreate(532.000000, 433.000000, "samp");
	TextDrawBackgroundColor(samps, 255);
	TextDrawFont(samps, 2);
	TextDrawLetterSize(samps, 0.180000, 1.299998);
	TextDrawColor(samps, -16776961);
	TextDrawSetOutline(samps, 1);
	TextDrawSetProportional(samps, 1);
	TextDrawSetSelectable(samps, 0);

	svitra = TextDrawCreate(554.000000, 433.000000, "-");
	TextDrawBackgroundColor(svitra, 255);
	TextDrawFont(svitra, 2);
	TextDrawLetterSize(svitra, 0.180000, 1.299998);
	TextDrawColor(svitra, -1);
	TextDrawSetOutline(svitra, 1);
	TextDrawSetProportional(svitra, 1);
	TextDrawSetSelectable(svitra, 0);

	zland = TextDrawCreate(557.000000, 433.000000, "zombieland");
	TextDrawBackgroundColor(zland, 255);
	TextDrawFont(zland, 2);
	TextDrawLetterSize(zland, 0.180000, 1.299998);
	TextDrawColor(zland, -16776961);
	TextDrawSetOutline(zland, 1);
	TextDrawSetProportional(zland, 1);
	TextDrawSetSelectable(zland, 0);

	dot = TextDrawCreate(606.000000, 433.000000, ".");
	TextDrawBackgroundColor(dot, 255);
	TextDrawFont(dot, 2);
	TextDrawLetterSize(dot, 0.180000, 1.299998);
	TextDrawColor(dot, -1);
	TextDrawSetOutline(dot, 1);
	TextDrawSetProportional(dot, 1);
	TextDrawSetSelectable(dot, 0);

	infos = TextDrawCreate(608.000000, 433.000000, "info");
	TextDrawBackgroundColor(infos, 255);
	TextDrawFont(infos, 2);
	TextDrawLetterSize(infos, 0.180000, 1.299998);
	TextDrawColor(infos, -1);
	TextDrawSetOutline(infos, 1);
	TextDrawSetProportional(infos, 1);
	TextDrawSetSelectable(infos, 0);

	for (new i; i < MAX_PLAYERS; i ++) {
		Infected[i] = TextDrawCreate(2.000000, 1.000000, "~n~");
		TextDrawBackgroundColor(Infected[i], 255);
		TextDrawFont(Infected[i], 1);
		TextDrawLetterSize(Infected[i], 0.500000, 50.000000);
		TextDrawColor(Infected[i], -1);
		TextDrawSetOutline(Infected[i], 0);
		TextDrawSetProportional(Infected[i], 1);
		TextDrawSetShadow(Infected[i], 1);
		TextDrawUseBox(Infected[i], 1);
		TextDrawBoxColor(Infected[i], 1174405190);
		TextDrawTextSize(Infected[i], 640.000000, 0.000000);

		iKilled[i] = TextDrawCreate(237.000000, 418.000000, "Loading");
		TextDrawBackgroundColor(iKilled[i], 255);
		TextDrawFont(iKilled[i], 2);
		TextDrawLetterSize(iKilled[i], 0.200000, 1.000000);
		TextDrawColor(iKilled[i], -1);
		TextDrawSetOutline(iKilled[i], 0);
		TextDrawSetProportional(iKilled[i], 1);
		TextDrawSetShadow(iKilled[i], 1);

		myXP[i] = TextDrawCreate(529.000000, 338.000000, "XP: %i");
		TextDrawBackgroundColor(myXP[i], 255);
		TextDrawFont(myXP[i], 1);
		TextDrawLetterSize(myXP[i], 0.300000, 1.299998);
		TextDrawColor(myXP[i], -1);
		TextDrawSetOutline(myXP[i], 1);
		TextDrawSetProportional(myXP[i], 1);
		TextDrawSetShadow(myXP[i], 1);

		mykills[i] = TextDrawCreate(529.000000, 351.000000, "Kills: %i");
		TextDrawBackgroundColor(mykills[i], 255);
		TextDrawFont(mykills[i], 1);
		TextDrawLetterSize(mykills[i], 0.300000, 1.299999);
		TextDrawColor(mykills[i], -1);
		TextDrawSetOutline(mykills[i], 1);
		TextDrawSetProportional(mykills[i], 1);
		TextDrawSetSelectable(mykills[i], 0);

		mydeaths[i] = TextDrawCreate(529.000000, 364.000000, "Deaths: %i");
		TextDrawBackgroundColor(mydeaths[i], 255);
		TextDrawFont(mydeaths[i], 1);
		TextDrawLetterSize(mydeaths[i], 0.300000, 1.299999);
		TextDrawColor(mydeaths[i], -1);
		TextDrawSetOutline(mydeaths[i], 1);
		TextDrawSetProportional(mydeaths[i], 1);
		TextDrawSetSelectable(mydeaths[i], 0);

		mykd[i] = TextDrawCreate(529.000000, 376.000000, "K/D: %0.2f");
		TextDrawBackgroundColor(mykd[i], 255);
		TextDrawFont(mykd[i], 1);
		TextDrawLetterSize(mykd[i], 0.300000, 1.299999);
		TextDrawColor(mykd[i], -1);
		TextDrawSetOutline(mykd[i], 1);
		TextDrawSetProportional(mykd[i], 1);
		TextDrawSetSelectable(mykd[i], 0);

		mytokens[i] = TextDrawCreate(529.000000, 388.000000, "Tokens: %i");
		TextDrawBackgroundColor(mytokens[i], 255);
		TextDrawFont(mytokens[i], 1);
		TextDrawLetterSize(mytokens[i], 0.300000, 1.299999);
		TextDrawColor(mytokens[i], -1);
		TextDrawSetOutline(mytokens[i], 1);
		TextDrawSetProportional(mytokens[i], 1);
		TextDrawSetSelectable(mytokens[i], 0);

		myrank[i] = TextDrawCreate(529.000000, 400.000000, "Rank: %i");
		TextDrawBackgroundColor(myrank[i], 255);
		TextDrawFont(myrank[i], 1);
		TextDrawLetterSize(myrank[i], 0.300000, 1.299999);
		TextDrawColor(myrank[i], -1);
		TextDrawSetOutline(myrank[i], 1);
		TextDrawSetProportional(myrank[i], 1);
		TextDrawSetSelectable(myrank[i], 0);
	}
	return 1;
}

UpdateAliveInfo() { // Modified by Logic_
	new string[50];
	format(string, sizeof string, "~r~%d~w~ ZOMBIES ~w~VS~w~ HUMANS ~b~%d", GetTeamPlayersAlive(TEAM_ZOMBIE), GetTeamPlayersAlive(TEAM_HUMAN));
	
	return TextDrawSetString(AliveInfo,string), 1;
}

UpdateXPTextdraw(playerid) { // Modified by Logic_
	
	new string[24];
	format(string, sizeof string, "XP: %i",pInfo[playerid][pXP]);
	TextDrawSetString(myXP[playerid],string);
	return 1;
}

UpdateKillsTextdraw(playerid) { // Modified by Logic_

	new string[24];
	format(string, sizeof string, "Kills: %i",pInfo[playerid][pKills]);
	TextDrawSetString(mykills[playerid],string);
	return 1;
}

UpdateDeathsTextdraw(playerid) { // Modified by Logic_

	new string[24];
	format(string, sizeof string, "Deaths: %i", pInfo[playerid][pDeaths]);
	TextDrawSetString(mydeaths[playerid],string);
	return 1;
}

UpdateKDTextdraw(playerid) { // Modified by Logic_

	new string[24], Float:kd = floatdiv(pInfo[playerid][pKills], pInfo[playerid][pDeaths]);
	format(string, sizeof string, "K/D: %0.2f", kd);
	TextDrawSetString(mykd[playerid],string);
	return 1;
}

UpdateTokensTextdraw(playerid) { // Modified by Logic_

	new string[24];
	format(string, sizeof string, "Tokens: %i",pInfo[playerid][pCoins]);
	TextDrawSetString(mytokens[playerid],string);
	return 1;
}

UpdateRanksTextdraw(playerid) { // Modified by Logic_

	new string[20];
	format(string, sizeof string, "Rank: %i/%i", pInfo[playerid][pRank], sizeof gRanks);
	TextDrawSetString(myrank[playerid], string);
	return 1;
}

UpdateMapName() { // Modified by Logic_

	new string[10 + MAX_MAP_NAME_LEN];
	format(string, sizeof string, "Map: ~w~%s", Map[MapName]);
	TextDrawSetString(CurrentMap,string);
	return 1;
}

setClass(playerid)
{
	if (pInfo[playerid][pTeam] == TEAM_HUMAN)
	{
		ResetPlayerWeapons(playerid);
		switch (pInfo[playerid][pClass])
		{
			case CIVILIAN:
			{
				GivePlayerWeapon(playerid,22,999999);
				GivePlayerWeapon(playerid,25,15);
				switch (random(82))
				{
					case 0: SetPlayerSkin(playerid,10);
					case 1: SetPlayerSkin(playerid,101);
					case 2: SetPlayerSkin(playerid,12);
					case 3: SetPlayerSkin(playerid,13);
					case 4: SetPlayerSkin(playerid,15);
					case 5: SetPlayerSkin(playerid,14);
					case 6: SetPlayerSkin(playerid,143);
					case 7: SetPlayerSkin(playerid,15);
					case 8: SetPlayerSkin(playerid,151);
					case 9: SetPlayerSkin(playerid,156);
					case 10: SetPlayerSkin(playerid,169);
					case 11: SetPlayerSkin(playerid,17);
					case 12: SetPlayerSkin(playerid,170);
					case 13: SetPlayerSkin(playerid,180);
					case 14: SetPlayerSkin(playerid,182);
					case 15: SetPlayerSkin(playerid,54);
					case 16: SetPlayerSkin(playerid,184);
					case 17: SetPlayerSkin(playerid,263);
					case 18: SetPlayerSkin(playerid,186);
					case 19: SetPlayerSkin(playerid,185);
					case 20: SetPlayerSkin(playerid,188);
					case 21: SetPlayerSkin(playerid,19);
					case 22: SetPlayerSkin(playerid,216);
					case 23: SetPlayerSkin(playerid,20);
					case 24: SetPlayerSkin(playerid,21);
					case 25: SetPlayerSkin(playerid,22);
					case 26: SetPlayerSkin(playerid,210);
					case 27: SetPlayerSkin(playerid,214);
					case 28: SetPlayerSkin(playerid,215);
					case 29: SetPlayerSkin(playerid,220);
					case 30: SetPlayerSkin(playerid,221);
					case 31: SetPlayerSkin(playerid,225);
					case 32: SetPlayerSkin(playerid,226);
					case 33: SetPlayerSkin(playerid,222);
					case 34: SetPlayerSkin(playerid,223);
					case 35: SetPlayerSkin(playerid,227);
					case 36: SetPlayerSkin(playerid,231);
					case 37: SetPlayerSkin(playerid,228);
					case 38: SetPlayerSkin(playerid,234);
					case 39: SetPlayerSkin(playerid,76);
					case 40: SetPlayerSkin(playerid,235);
					case 41: SetPlayerSkin(playerid,236);
					case 42: SetPlayerSkin(playerid,89);
					case 43: SetPlayerSkin(playerid,88);
					case 44: SetPlayerSkin(playerid,24);
					case 45: SetPlayerSkin(playerid,218);
					case 46: SetPlayerSkin(playerid,240);
					case 47: SetPlayerSkin(playerid,25);
					case 48: SetPlayerSkin(playerid,250);
					case 49: SetPlayerSkin(playerid,28);
					case 50: SetPlayerSkin(playerid,40);
					case 51: SetPlayerSkin(playerid,41);
					case 52: SetPlayerSkin(playerid,223);
					case 53: SetPlayerSkin(playerid,227);
					case 54: SetPlayerSkin(playerid,35);
					case 55: SetPlayerSkin(playerid,37);
					case 56: SetPlayerSkin(playerid,38);
					case 57: SetPlayerSkin(playerid,36);
					case 58: SetPlayerSkin(playerid,44);
					case 59: SetPlayerSkin(playerid,69);
					case 60: SetPlayerSkin(playerid,43);
					case 61: SetPlayerSkin(playerid,46);
					case 62: SetPlayerSkin(playerid,9);
					case 63: SetPlayerSkin(playerid,93);
					case 64: SetPlayerSkin(playerid,39);
					case 65: SetPlayerSkin(playerid,48);
					case 66: SetPlayerSkin(playerid,47);
					case 67: SetPlayerSkin(playerid,262);
					case 68: SetPlayerSkin(playerid,229);
					case 69: SetPlayerSkin(playerid,58);
					case 70: SetPlayerSkin(playerid,59);
					case 71: SetPlayerSkin(playerid,60);
					case 72: SetPlayerSkin(playerid,232);
					case 73: SetPlayerSkin(playerid,233);
					case 74: SetPlayerSkin(playerid,67);
					case 75: SetPlayerSkin(playerid,7);
					case 76: SetPlayerSkin(playerid,72);
					case 77: SetPlayerSkin(playerid,55);
					case 78: SetPlayerSkin(playerid,94);
					case 79: SetPlayerSkin(playerid,95);
					case 80: SetPlayerSkin(playerid,98);
					case 81: SetPlayerSkin(playerid,56);
				}
			}

			case MEDIC:
			{
				switch (random(4))
				{
					case 0: SetPlayerSkin(playerid,274);
					case 1: SetPlayerSkin(playerid,275);
					case 2: SetPlayerSkin(playerid,276);
					case 3: SetPlayerSkin(playerid,308);
				}
			}

			case TERRORIST:
			{
				GivePlayerWeapon(playerid,16,3);
				SetPlayerSkin(playerid,100);
			}

			case SNIPER:
			{
				GivePlayerWeapon(playerid,34,60);
				SetPlayerSkin(playerid,304);
			}

			case HEAVYSHOTGUN:
			{
				GivePlayerWeapon(playerid,25,300);
				SetPlayerSkin(playerid,1);
			}

			case KICKBACK:
			{
				GivePlayerWeapon(playerid,23,500);
				GivePlayerWeapon(playerid,25,450);
				GivePlayerWeapon(playerid,29,200);
				SetPlayerSkin(playerid,149);
			}

			case SCOUT:
			{
				GivePlayerWeapon(playerid,34,150);
				SetPlayerSkin(playerid,29);
			}

			case VIPENGINEER:
			{
				GivePlayerWeapon(playerid,31,1000);
				GivePlayerWeapon(playerid,25,2000);
				GivePlayerWeapon(playerid,24,500);
				SetPlayerSkin(playerid,16);
			}

			case VIPMEDIC:
			{
				GivePlayerWeapon(playerid,31,1000);
				GivePlayerWeapon(playerid,24,500);
				SetPlayerSkin(playerid,308);
			}

			case VIPSCOUT:
			{
				GivePlayerWeapon(playerid,34,130);
				GivePlayerWeapon(playerid,24,500);
				SetPlayerSkin(playerid,294);
			}

			case ENGINEER:
			{
				switch (random(3))
				{
					case 0: SetPlayerSkin(playerid,260);
					case 1: SetPlayerSkin(playerid,16);
					case 2: SetPlayerSkin(playerid,27);
				}
			}

			case DOCTOR:
			{
				GivePlayerWeapon(playerid,17,1);
				GivePlayerWeapon(playerid,29,353);
				SetPlayerSkin(playerid,70);
			}
		}
	}

	if (pInfo[playerid][pTeam] == TEAM_ZOMBIE)
	{
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid,4,1);
		SetPlayerArmour(playerid,0);
		ShowPlayerDialog(playerid, DIALOG_ZOMBIE_CLASSES, DIALOG_STYLE_LIST, "ZOMBIE SPAWN MENU", "Classes", "Select", "Close");
		switch (pInfo[playerid][pClass])
		{
			case STANDARDZOMBIE: SetPlayerSkin(playerid,181);
			case MUTATEDZOMBIE: SetPlayerSkin(playerid,135);
			case HUNTERZOMBIE: SetPlayerSkin(playerid,230);
			case STOMPERZOMBIE: SetPlayerSkin(playerid,78);
			case WITCHZOMBIE: SetPlayerSkin(playerid,178);
			case SMOKERZOMBIE: SetPlayerSkin(playerid,168);
			case SCREAMERZOMBIE: SetPlayerSkin(playerid,134);
			case SEEKER: SetPlayerSkin(playerid,200);
			case FLESHEATER: SetPlayerSkin(playerid,213);
			case ROGUE: SetPlayerSkin(playerid,79);
			case BOOMERZOMBIE: SetPlayerSkin(playerid,264),SetPlayerHealth(playerid,15);
			case TANKERZOMBIE: SetPlayerSkin(playerid,206);
		}
	}
	return 1;
}

function ScreamerClearAnim(i) return ClearAnimations(i);

InfectPlayerStandard(playerid) {
	if (pInfo[playerid][pTeam] == TEAM_HUMAN) {
		if (!pInfo[playerid][IsPlayerInfected]) {
			pInfo[playerid][IsPlayerInfectedTimer] = SetTimerEx("StandardInfection",2000,1,"i",playerid);
			SetPlayerColor(playerid,COLOR_PINK);
			TextDrawShowForPlayer(playerid,Infected[playerid]);
			pInfo[playerid][IsPlayerInfected] = 1;
		}
	}
	return 1;
}

InfectPlayerMutated(playerid) {
	if (pInfo[playerid][pTeam] == TEAM_HUMAN) {
		if (!pInfo[playerid][IsPlayerInfected]) {
			pInfo[playerid][IsPlayerInfectedTimer] = SetTimerEx("MutatedInfection",1500,1,"i",playerid);
			SetPlayerColor(playerid,COLOR_PINK);
			TextDrawShowForPlayer(playerid,Infected[playerid]);
			pInfo[playerid][IsPlayerInfected] = 1;
		}
	}
	return 1;
}

InfectPlayerFleshEater(playerid)
{
	if (pInfo[playerid][pTeam] == TEAM_HUMAN)
	{
		if (pInfo[playerid][IsPlayerInfected] == 0)
		{
			pInfo[playerid][IsPlayerInfectedTimer] = SetTimerEx("FleshEaterInfection",1500,1,"i",playerid);
			SetPlayerColor(playerid,COLOR_PINK);
			TextDrawShowForPlayer(playerid,Infected[playerid]);
			pInfo[playerid][IsPlayerInfected] = 1;
		}
	}
	return 1;
}

CurePlayer(playerid)
{
	if (pInfo[playerid][IsPlayerInfected] == 1)
	{
		KillTimer(pInfo[playerid][IsPlayerInfectedTimer]);
		pInfo[playerid][IsPlayerInfected] = 0;
		SetPlayerColor(playerid,COLOR_HUMAN);
		ApplyAnimation(playerid,"MEDIC","CPR",4.1,0,1,1,1,1);
		SetPlayerDrunkLevel(playerid,0);
		TextDrawHideForPlayer(playerid,Infected[playerid]);
	}
	return 1;
}

function StandardInfection(playerid)
{
	GameTextForPlayer(playerid,"~n~~n~~n~~n~~r~Infected",1000,5);
	new Float:health;
	GetPlayerHealth(playerid, health);
	SetPlayerHealth(playerid, health - 2.5);
}

function MutatedInfection(playerid)
{
	SetPlayerDrunkLevel(playerid,6000);
	GameTextForPlayer(playerid,"~n~~n~~n~~n~~r~Infected",1000,5);
	new Float:health;
	GetPlayerHealth(playerid, health);
	SetPlayerHealth(playerid, health - 4.5);
	return 1;
}

function FleshEaterInfection(playerid)
{
	SetPlayerDrunkLevel(playerid,7500);
	GameTextForPlayer(playerid,"~n~~n~~n~~n~~r~Flesh Eater Infection",1000,5);
	new Float:health;
	GetPlayerHealth(playerid, health);
	SetPlayerHealth(playerid, health - 10.0);
	return 1;
}

CheckToStartMap()
{
	if (Map[IsStarted] == 0)
	{
		LoadMap(LoadNewMap());
		StartMap();
		Map[IsStarted] = 1;
	}
	return 1;
}

ChangeCameraView(playerid)
{
	new Float:px,Float:py,Float:pz,Float:pa;
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, pa);
	SetPlayerCameraPos(playerid, px, py+4.0, pz+2.0);
	SetPlayerCameraLookAt(playerid, px, py, pz);
	return 1;
}

SendPlayerMaxAmmo( playerid )
{
	new slot, weap, ammo;

	for ( slot = 0; slot < 14; slot++ ) {
		GetPlayerWeaponData( playerid, slot, weap, ammo );
		if ( IsValidWeapon( weap ) ) {
			GivePlayerWeapon( playerid, weap, 99999 );
		}
	}
	return 1;
}

IsValidWeapon( weaponid )
{
	if ( weaponid > 0 && weaponid < 19 || weaponid > 21 && weaponid < 47 ) return 1;
	return 0;
}

GetXPName() { // Modified by Logic_
	new str[11];
	switch (Map[XPType]) {
		case 1: str = "Normal XP";
		case 2: str = "Double XP";
		case 3: str = "Triple XP";
		case 4: str = "Quad XP";
	}
	return str;
}

CheckToLevelOrRankUp(killerid) {
	new
		i = sizeof gRanks, previous_rank = pInfo[killerid][pRank];
	
	for(; i > -1; i--) {
		if (gRanks[i][E_RANKS_KILLS] != pInfo[killerid][pKills]) continue;

		pInfo[killerid][pRank] = i;
		break;
	}

	if (previous_rank < i) { // if the player rank has increased!
		new str[128];
		format(str, sizeof str, "{D9B9DA} %s has ranked up to rank %s (%d).", GetPlayerNameEx(killerid), pInfo[killerid][pRank]);
		SendClientMessageToAll(-1, str);
		
		UpdateRanksTextdraw(killerid);
	}
	return 1;
}

function HideiKilled(playerid) {
	return TextDrawHideForPlayer(playerid, iKilled[playerid]), 1;
}

SpawnVars(playerid) {
	TextDrawHideForPlayer(playerid, ServerIntroOne[playerid]);
	TextDrawHideForPlayer(playerid, ServerIntroTwo[playerid]);
	ShowTextdrawsAfterConnect(playerid);
	return 1;
}

ShowTextdrawsAfterConnect(playerid) {
	TextDrawShowForPlayer(playerid, TimeLeft);
	TextDrawShowForPlayer(playerid, UntilRescue);
	TextDrawShowForPlayer(playerid, AliveInfo);
	TextDrawShowForPlayer(playerid, remadeText2);
	TextDrawShowForPlayer(playerid, CurrentMap);
	TextDrawShowForPlayer(playerid, gXPTD);
	TextDrawShowForPlayer(playerid, myXP[playerid]);
	TextDrawShowForPlayer(playerid, mykills[playerid]);
	TextDrawShowForPlayer(playerid, mydeaths[playerid]);
	TextDrawShowForPlayer(playerid, mykd[playerid]);
	TextDrawShowForPlayer(playerid, mytokens[playerid]);
	TextDrawShowForPlayer(playerid, myrank[playerid]);
	TextDrawShowForPlayer(playerid, EventText);
	TextDrawShowForPlayer(playerid, www);
	TextDrawShowForPlayer(playerid, samps);
	TextDrawShowForPlayer(playerid, svitra);
	TextDrawShowForPlayer(playerid, zland);
	TextDrawShowForPlayer(playerid, dot);
	TextDrawShowForPlayer(playerid, infos);
	return 1;
}

hideTextdrawsAfterConnect(playerid) {
	TextDrawHideForPlayer(playerid, TimeLeft);
	TextDrawHideForPlayer(playerid, UntilRescue);
	TextDrawHideForPlayer(playerid, AliveInfo);
	TextDrawHideForPlayer(playerid, remadeText2);
	TextDrawHideForPlayer(playerid, CurrentMap);
	TextDrawHideForPlayer(playerid, gXPTD);
	TextDrawHideForPlayer(playerid, myXP[playerid]);
	TextDrawHideForPlayer(playerid, mykills[playerid]);
	TextDrawHideForPlayer(playerid, mydeaths[playerid]);
	TextDrawHideForPlayer(playerid, mykd[playerid]);
	TextDrawHideForPlayer(playerid, mytokens[playerid]);
	TextDrawHideForPlayer(playerid, myrank[playerid]);
	TextDrawHideForPlayer(playerid, EventText);
	TextDrawHideForPlayer(playerid, www);
	TextDrawHideForPlayer(playerid, samps);
	TextDrawHideForPlayer(playerid, svitra);
	TextDrawHideForPlayer(playerid, zland);
	TextDrawHideForPlayer(playerid, dot);
	TextDrawHideForPlayer(playerid, infos);
	return 1;
}

function SPS_Reset_PVars() {
	for(new i; i < MAX_PLAYERS; i++) {
		if (GetPVarType(i, "SPS Muted") != PLAYER_VARTYPE_NONE) {
			SetPVarInt(i, "SPS Muted", 0);
		}
		
		if (GetPVarType(i, "SPS Messages Sent") != PLAYER_VARTYPE_NONE) {
			SetPVarInt(i, "SPS Messages Sent", 0);
		}
		
		if (GetPVarType(i, "SPS Spam Warnings") != PLAYER_VARTYPE_NONE) {
			SetPVarInt(i, "SPS Spam Warnings", 0);
		}
	}
	return 1;
}

function SPS_Remove_Messages_Limit(playerid) { // Modified by Logic_

	if (GetPVarInt(playerid, "SPS Spam Warnings") == 1) {
		new string[128];

		format(string, sizeof string, "{DC143C}Player %s has been muted for %i minutes because of flooding the chat.", GetPlayerNameEx(playerid), PLAYER_MUTE_TIME_MINUTES);
		foreach(new i : Player) {
			if (i != playerid)
				SendClientMessage(i, -1, string);
		}

		format(string, sizeof string, "{CCFFFF}You have been muted for %i minutes because of flooding the chat.", PLAYER_MUTE_TIME_MINUTES);
		SendClientMessage(playerid, -1, string);

		SetTimerEx("SPS_Unmute_Player", (PLAYER_MUTE_TIME_MINUTES * 60000), 0, "i", playerid);
		SetPVarInt(playerid, "SPS Muted", 1);

		CallRemoteFunction("OnPlayerGetMuted", "i", playerid);
	}
	
	SetPVarInt(playerid, "SPS Messages Sent", 0);
	SetPVarInt(playerid, "SPS Spam Warnings", 0);
	return 1;
}

function SPS_Unmute_Player(playerid) {
	SendClientMessage(playerid, -1, "{CCFFFF}You have been automatically unmuted.");
	SetPVarInt(playerid, "SPS Muted", 0);
	return 1;
}

forward RogueTimer(playerid);
public RogueTimer(playerid) {
	
	SetPlayerSkin(playerid, 137);
	SetPlayerColor(playerid, COLOR_ZOMBIE);
	
	return 1;
}

GetPlayerClassName(playerid) { // Added by Logic_ (NOTE: Needs to be modified to: GetPlayerClassName(playerid, class_name[]))
	new str[16];
	if (pInfo[playerid][pTeam] == TEAM_HUMAN) {
		format(str, sizeof str, gHumanClass[pInfo[playerid][pClass]][E_CLASS_NAME]);
	}
	else {
		format(str, sizeof str, gZombieClass[pInfo[playerid][pClass]][E_CLASS_NAME]);
	}

	return str;
}

CheckPlayerKillStreak(killerid) { // Added by Logic_
	new
		kills = pInfo[killerid][Killstreak]; // storing the value of killstreak in a variable to avoid recalling it over and over again!

	if (! (kills % 5)) { // if the killstreak is multiple of 5
		new
			tokens = (kills / 5),
			xp = (kills * 2),
			cash = (kills * 10),
			string[144];

		format(string, sizeof string, ""chat""COL_WHITE" %s{9999FF} has achieved a killstreak of %d"COL_WHITE"(+%d XP +%d$) (%d Tokens)", GetPlayerNameEx(killerid), kills, xp, cash, tokens);
		SendClientMessageToAll(-1, string);

		pInfo[killerid][pXP] += xp;
		GivePlayerMoney(killerid, cash);
		pInfo[killerid][pCash] += cash;
		pInfo[killerid][pCoins] += tokens;
	}
	return 1;
}

/* ZOMBIELAND - LOGIC_ - SJUTEL - KITTEN - PRIVATE200 - AND OTHER CONTRIBUTERS */
