/*
- В данном файле происходят основные процессы для инициализации, работы мода и подключение модулей.
- Разрабатано: timmylich.
*/

#pragma	warning disable 239
#pragma	warning disable 213
#pragma	warning disable 219
#pragma	warning disable 234

#include <open.mp>

#undef	MAX_PLAYERS
#define	MAX_PLAYERS 100
#undef	MAX_VEHICLES
#define	MAX_VEHICLES 200

#include <a_mysql>
#include <streamer>
#include <Pawn.CMD>
#include <sscanf2>
#include <foreach>
#include <Pawn.RakNet>
#define ifx_FallVelocity 0.7
#include <InteriorFallFix>
#include <RU_GameText>

#define DEBUGMODE // Режим тестирования, закомментировать на проде

// Настройки для лаунчера
#define	GameModeText "TROPIKI - "GameModeVersion""
#define	GameModeVersion "v2024.12.22"
#define	ProjectName "Tropiki"
#define	ServerName ""ProjectName" | Fun/DM/CopChase"

/* HEADER */
new string[4096], cline[145], rows, len; // Для форматирования и всяких одноразовых махинаций
new iter, jter, kter;
new dbHandle; // Подключение к БД
new UpdateSeconds;
#define World_DMZone 1001
#include "../../gamemodes/header/style.pwn" // Стилистические настройки
#include "../../gamemodes/header/dialog.pwn" // Диалоговые окна
#include "../../gamemodes/header/login.pwn" // Регистрация/авторизация
#include "../../gamemodes/header/pvars.pwn" // Переменные игрока
#include "../../gamemodes/header/anticheat.pwn" // Анти-чит
#include "../../gamemodes/header/dmzones.pwn" // ДМ-зоны
#include "../../gamemodes/header/damage.pwn" // Оружие и урон
#include "../../gamemodes/header/server.pwn" // Глобальное, настройки сервера

/* SCRIPT */
#include "../../gamemodes/script/login.pwn" // Регистрация/авторизация
#include "../../gamemodes/script/pvars.pwn" // Переменные игрока
#include "../../gamemodes/script/anticheat.pwn" // Анти-чит
#include "../../gamemodes/script/dialog.pwn" // Диалоговые окна
#include "../../gamemodes/script/pfunc.pwn" // Функции игрока
#include "../../gamemodes/script/dmzones.pwn" // ДМ-зоны
#include "../../gamemodes/script/explosions.pwn" // Взрывы
#include "../../gamemodes/script/pcmd.pwn" // Команды игрока
#include "../../gamemodes/script/damage.pwn" // Оружие и урон

/* MAPPING */
stock LoadMapping()
{
	new object_world, object_int;
	#include "../../gamemodes/map/DMZ_Mochilovo_map1.pwn"
	return 1;
}

/* FREE */
public OnPlayerText(playerid, text[])
{
	if(translate_OnPlayerText(playerid, text)) return 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	pfunc_OnPlayerSpawn(playerid);
	dmzones_OnPlayerSpawn(playerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	anticheat_OnDialogResponse(playerid, dialogid);
	login_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	dmzones_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	return 1;
}

public OnPlayerConnect(playerid)
{
	pvars_OnPlayerConnect(playerid);
    login_OnPlayerConnect(playerid);
	SecondUpdateTimerID[playerid] = SetTimerEx(!"OnPlayerSecondUpdate", 1000, true, !"d", playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	pfunc_OnPlayerDisconnect(playerid, reason);
	pvars_OnPlayerDisconnect(playerid);
	KillTimer(SecondUpdateTimerID[playerid]);
	return 1;
}

main()
{
	print(!"|------------------------------------------------------------");
	print(!"| "ProjectName" Version - "GameModeVersion"");
	print(!"|------------------------------------------------------------");
	return 1;
}

public OnGameModeInit()
{
	SendRconCommand("name "ServerName"");
	SendRconCommand("game.mode "GameModeText"");
    EnableStuntBonusForAll(0);
	ManualVehicleEngineAndLights();
    DisableInteriorEnterExits();
    //ShowPlayerMarkers(0);
	LimitPlayerMarkerRadius(8.0);
	SetNameTagDrawDistance(20.0);
	SetGravity(0.008);
	LimitGlobalChatRadius(10.0);
	EnableVehicleFriendlyFire();
    ConnectMySQL();
	AllowRussianNicknames();
	LoadMapping();
	dmzones_OnGameModeInit();
	//login_OnGameModeInit();
	SetTimer(!"OnServerUpdate", 1000, true);
    return 1;
}

CB:OnPlayerSecondUpdate(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	anticheat_OnPlayerSecondUpdate(playerid);
	if(!TI[playerid][tLogin])
	{
		return 1;
	}
	else
	{
		dmzones_OnPlayerSecondUpdate(playerid);
	}
	return 1;
}

CB:OnServerUpdate()
{
	++UpdateSeconds;
	
	dmzones_Timer();

	return 1;
}

stock ConnectMySQL()
{
		//dbHandle = mysql_connect("localhost", "root", "", "tropiki");
		dbHandle = mysql_connect_file(); // Подключение через mysql.ini
		print(!" _ ");
		print(!" _ ");
		print(!" _ ");
		print(!" _ ");
		print(!" _ ");
		switch(mysql_errno())
	{
	    case 0: print(!"[Info] [DataBase] Connect to DB - Success!");
	    case 1044: print(!"[Error] [DataBase] #1044 - Error connecting to the database! [The user has been denied access to the database]");
	    case 1045: print(!"[Error] [DataBase] #1045 - Error connecting to the database! [[User denied access (Incorrect password)]");
	    case 1049: print(!"[Error] [DataBase] #1049 - Error connecting to the database! [Unknown DATABASE]");
	    case 2003: print(!"[Error] [DataBase] #2003 - Error connecting to the database! [Unable to connect to MySQL server]");
	    case 2005: print(!"[Error] [DataBase] #2005 - Error connecting to the database! [Unknown server]");
	    default: printf("[Error] [DataBase] #%d - Error connecting to the database! [Unknown error]", mysql_errno());
	}
		print(!" _ ");
		print(!" _ ");
		print(!" _ ");
		print(!" _ ");
		print(!" _ ");
	mysql_log(ERROR | WARNING);
	mysql_set_charset(!"cp1251");
}

stock AllowRussianNicknames()
{
	// Резрешает символы а-я А-Я
	for(iter = 192; iter <= 255; iter++) AllowNickNameCharacter(iter, true);
	return 1;
}

stock strcpy(dest[], const source[], maxlength=sizeof dest) return strmid(dest, source, 0, strlen(source), maxlength);

public OnPlayerWeaponShot(playerid, WEAPON:weaponid, BULLET_HIT_TYPE:hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, WEAPON:weaponid, bodypart)
{
	damage_OnPlayerGiveDamage(playerid, damagedid, amount, weaponid, bodypart);
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, WEAPON:weaponid, bodypart)
{
	damage_OnPlayerTakeDamage(playerid, issuerid, amount, weaponid, bodypart);
	return 1;
}

public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
	dmzones_OnPlayerDeath(playerid, killerid, reason);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetSpawnInfo(playerid,1,101,2043.195, -1402.992, 68.313, 90.0,0,0,0,0,0,0);
	SpawnPlayer(playerid);
	return 1;
}

CMD:death(playerid)
{
	SetPlayerHealthAC(playerid, 0.0);
	return 1;
}

public OnPlayerUpdate(playerid)
{
	damage_OnPlayerUpdate(playerid);
	return 1;
}
