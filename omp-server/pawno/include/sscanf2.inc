/*
 *  sscanf 2.8.3
 *  Created by Y_Less, updated by Emmet_.
 *
 *  Version: MPL 1.1
 *
 *  The contents of this file are subject to the Mozilla Public License Version
 *  1.1 (the "License"); you may not use this file except in compliance with
 *  the License. You may obtain a copy of the License at
 *  [url]http://www.mozilla.org/MPL/[/url]
 *
 *  Software distributed under the License is distributed on an "AS IS" basis,
 *  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 *  for the specific language governing rights and limitations under the
 *  License.
 *
 *  The Original Code is the sscanf 2.0 SA:MP plugin.
 *
 *  The Initial Developer of the Original Code is Alex "Y_Less" Cole.
 *  Portions created by the Initial Developer are Copyright (C) 2010
 *  the Initial Developer. All Rights Reserved.
 *
 *  Contributor(s):
 *
 *  Special Thanks to:
 *
 *      SA:MP Team past, present and future
 */

#if !defined _INC_SSCANF
	#define _INC_SSCANF
#else
	#endinput
#endif

#if defined _inc_a_npc
	#pragma library sscanf
#elseif !defined _samp_included
	#error Please include <a_npc> or <a_samp> first.
#endif

#define SSCANF:%0(%1) forward sscanf_%0(%1);public sscanf_%0(%1)

#if defined sscanf
	#error sscanf (possibly the PAWN version) already defined.
#endif

native sscanf(const data[], const format[], {Float,_}:...);
native unformat(const data[], const format[], {Float,_}:...) = sscanf;
native SSCANF_Init(players, invalid, len);
native SSCANF_Join(playerid, const name[], npc);
native SSCANF_Leave(playerid);
native SSCANF_IsConnected(playerid);

native SSCANF_Option(const name[], value);

stock const
	SSCANF_QUIET[] = "SSCANF_QUIET",
	OLD_DEFAULT_NAME[] = "OLD_DEFAULT_NAME",
	MATCH_NAME_PARTIAL[] = "MATCH_NAME_PARTIAL",
	CELLMIN_ON_MATCHES[] = "CELLMIN_ON_MATCHES",
	OLD_DEFAULT_KUSTOM[] = "OLD_DEFAULT_KUSTOM",
	OLD_DEFAULT_CUSTOM[] = "OLD_DEFAULT_CUSTOM";

static stock
	bool:SSCANF_gInit = false,
	SSCANF_g_sPlayers[MAX_PLAYERS char];

#if defined _inc_a_npc
	forward SSCANF_PlayerCheck();

	/*
	  OnNPCModeInit

	  Called when the script starts if it is a NPC mode, sets up the system,
	  then calls the "real" OnNPCModeInit (using the new ALS 2 hook method).
	*/

	public OnNPCModeInit()
	{
		SSCANF_Init(MAX_PLAYERS, INVALID_PLAYER_ID, MAX_PLAYER_NAME);
		#if !defined SSCANF_NO_PLAYERS
			// Initialise the system.
			SSCANF_PlayerCheck();
			SetTimer("SSCANF_PlayerCheck", 1, 1);
		#endif
		#if defined SSCANF_OnNPCModeInit
			SSCANF_OnNPCModeInit();
		#endif
		return 1;
	}

	#if defined _ALS_OnNPCModeInit
		#undef OnNPCModeInit
	#else
		#define _ALS_OnNPCModeInit
	#endif
	#define OnNPCModeInit SSCANF_OnNPCModeInit
	#if defined SSCANF_OnNPCModeInit
		forward SSCANF_OnNPCModeInit();
	#endif

	/*
	  SSCANF_PlayerCheck

	  NPC modes have no "OnPlayerConnect callback, so we need to simulate one.
	*/

	#if !defined SSCANF_NO_PLAYERS
		public SSCANF_PlayerCheck()
		{
			for (new i = 0; i != MAX_PLAYERS; ++i)
			{
				if (IsPlayerConnected(i))
				{
					if (!SSCANF_g_sPlayers{i})
					{
						new
							name[MAX_PLAYER_NAME + 1];
						GetPlayerName(i, name, sizeof(name));
						// We have no way to know if they are an NPC or not!
						SSCANF_Join(i, name, 0);
						SSCANF_g_sPlayers{i} = 1;
					}
				}
				else
				{
					if (SSCANF_g_sPlayers{i})
					{
						SSCANF_Leave(i);
						SSCANF_g_sPlayers{i} = 0;
					}
				}
			}
		}
	#endif
#else
	/*
	  OnFilterScriptInit

	  Called when the script starts if it is a filterscript, sets up the system,
	  then calls the "real" OnFilterScriptInit (using the new ALS 2 hook
	  method).
	*/

	public OnFilterScriptInit()
	{
	    new
     		name[MAX_PLAYER_NAME + 1];

		SSCANF_Init(GetMaxPlayers(), INVALID_PLAYER_ID, MAX_PLAYER_NAME);
		SSCANF_gInit = true;

		// Check if there are any players that aren't initialized.
		for (new i = 0; i < MAX_PLAYERS; i ++)
		{
		    if (IsPlayerConnected(i) && !SSCANF_IsConnected(i))
		    {
		        GetPlayerName(i, name, sizeof(name));
		        SSCANF_Join(i, name, IsPlayerNPC(i));
		    }
		}

		#if defined SSCANF_OnFilterScriptInit
			SSCANF_OnFilterScriptInit();
		#endif
		return 1;
	}

	#if defined _ALS_OnFilterScriptInit
		#undef OnFilterScriptInit
	#else
		#define _ALS_OnFilterScriptInit
	#endif
	#define OnFilterScriptInit SSCANF_OnFilterScriptInit
	#if defined SSCANF_OnFilterScriptInit
		forward SSCANF_OnFilterScriptInit();
	#endif

	/*
	  OnGameModeInit

	  Called when the script starts if it is a gamemode.  This callback is also
	  called in filterscripts so we don't want to reinitialise the system in
	  that case.
	*/

	public OnGameModeInit()
	{
		if (!SSCANF_gInit)
		{
		    new
		        name[MAX_PLAYER_NAME + 1];

			SSCANF_Init(GetMaxPlayers(), INVALID_PLAYER_ID, MAX_PLAYER_NAME);
			SSCANF_gInit = true;

			// Check if there are any players that aren't initialized.
			for (new i = 0; i < MAX_PLAYERS; i ++)
			{
			    if (IsPlayerConnected(i) && !SSCANF_IsConnected(i))
			    {
			        GetPlayerName(i, name, sizeof(name));
			        SSCANF_Join(i, name, IsPlayerNPC(i));
			    }
			}
		}
		#if defined SSCANF_OnGameModeInit
			SSCANF_OnGameModeInit();
		#endif
		return 1;
	}

	#if defined _ALS_OnGameModeInit
		#undef OnGameModeInit
	#else
		#define _ALS_OnGameModeInit
	#endif
	#define OnGameModeInit SSCANF_OnGameModeInit
	#if defined SSCANF_OnGameModeInit
		forward SSCANF_OnGameModeInit();
	#endif

	/*
	  OnPlayerConnect

	  Called when a player connects.  Actually increments an internal count so
	  that if a script ends and "OnPlayerDisconnect" is called then "sscanf"
	  still knows that the player is really connected.  Also stores their name
	  internally.
	*/

	public OnPlayerConnect(playerid)
	{
		new
			name[MAX_PLAYER_NAME + 1];
		GetPlayerName(playerid, name, sizeof(name));
		SSCANF_Join(playerid, name, IsPlayerNPC(playerid));
		#if defined SSCANF_OnPlayerConnect
			SSCANF_OnPlayerConnect(playerid);
		#endif
		return 1;
	}

	#if defined _ALS_OnPlayerConnect
		#undef OnPlayerConnect
	#else
		#define _ALS_OnPlayerConnect
	#endif
	#define OnPlayerConnect SSCANF_OnPlayerConnect
	#if defined SSCANF_OnPlayerConnect
		forward SSCANF_OnPlayerConnect(playerid);
	#endif

	/*
	  OnPlayerDisconnect

	  Called when a player disconnects, or when a script is ended.
	*/

	public OnPlayerDisconnect(playerid, reason)
	{
		#if defined SSCANF_OnPlayerDisconnect
			SSCANF_OnPlayerDisconnect(playerid, reason);
		#endif
		SSCANF_Leave(playerid);
		return 1;
	}

	#if defined _ALS_OnPlayerDisconnect
		#undef OnPlayerDisconnect
	#else
		#define _ALS_OnPlayerDisconnect
	#endif
	#define OnPlayerDisconnect SSCANF_OnPlayerDisconnect
	#if defined SSCANF_OnPlayerDisconnect
		forward SSCANF_OnPlayerDisconnect(playerid, reason);
	#endif
#endif

#define SSCANF_Init
#define SSCANF_Join
#define SSCANF_Leave

#define extract%0->%1; EXTRN%1;unformat(_:EXTRZ:EXTRV:EXTRX:%0,#,%1,,);
#define unformat(_:EXTRZ:EXTRV:EXTRX:%0,#,%1);%2else if (unformat(_:EXTRV:EXTRX:%0,#,%1))

#define EXTRV:EXTRX:%0<%3>%4#,%9new%1,%2) EXTRY:%0%4#P<%3>,|||%1|||%2)
#define EXTRX:%0#,%9new%1,%2) EXTRY:%0#,|||%1|||%2)
#define EXTRY: EXTR8:EXTR9:EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:

#define EXTR8:EXTR9:EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:%0#%1,%2|||%6:%3=%9|||%4) %6_EXTRO:%0#%1,%2|||%3=%9|||%4)
#define EXTR9:EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:%0#%1,%2|||%3=%9|||%4) __EXTRO:%0#%1,%2|||%3=%9|||%4)
#define EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:%0#%1,%2|||%6:%3[%7]|||%4) %6_EXTRW:%0#%1,%2|||%3[%7]|||%4)
#define EXTR1:EXTR2:EXTR3:EXTR4:%0#%1,%2|||%3[%7]|||%4) __EXTRW:%0#%1,%2|||%3|||%4)
#define EXTR2:EXTR3:EXTR4:%0#%1,%2|||%6:%3|||%4) %6_EXTRN:%0#%1,%2|||%3|||%4)
#define EXTR3:EXTR4:%0#%1,,%2||||||%4) %0#%1,%2)
#define EXTR4:%0#%1,%2|||%3|||%4) __EXTRN:%0#%1,%2|||%3|||%4)

// Optional specifiers.
#define __EXTRO:%0#%1,%2|||%3=%9|||%4,%5) EXTRY:%0#%1I"("#%9")"#,%2,%3|||%4|||%5)
#define Float_EXTRO:%0#%1,%2|||%3=%9|||%4,%5) EXTRY:%0#%1F"("#%9")"#,%2,%3|||%4|||%5)
#define player_EXTRO:%0#%1,%2|||%3=%9|||%4,%5) EXTRY:%0#%1U"("#%9")"#,%2,%3|||%4|||%5)
#define string_EXTRO:%0#%1,%2|||%3[%7]=%9|||%4,%5) EXTRY:%0#%1S"("#%9")"#[%7],%2,%3|||%4|||%5)

// Normal specifiers (the double underscore is to work for "_:".
#define __EXTRN:%0#%1,%2|||%3|||%4,%5) EXTRY:%0#%1i,%2,%3|||%4|||%5)
#define Float_EXTRN:%0#%1,%2|||%3|||%4,%5) EXTRY:%0#%1f,%2,%3|||%4|||%5)
#define player_EXTRN:%0#%1,%2|||%3|||%4,%5) EXTRY:%0#%1u,%2,%3|||%4|||%5)
//#define string_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1s[%7],%2,%3|||%4|||%5)

// Array versions of normal specifiers.
#define __EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<i>[%7],%2,%3|||%4|||%5)
#define Float_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<f>[%7],%2,%3|||%4|||%5)
#define player_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<u>[%7],%2,%3|||%4|||%5)
#define string_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1s[%7],%2,%3|||%4|||%5)

// Get rid of excess leading space which causes warnings.
#define EXTRN%0new%1; new%1;

#if !defined string
    #define string:
#endif

#define player:%0;unformat(%1) %0;unformat(%1)

#define hex:%0;unformat(%1) %0;unformat(%1)
#define hex_EXTRO:%0#%1,%2|||%3=%9|||%4,%5) EXTRY:%0#%1H"("#%9")"#,%2,%3|||%4|||%5)
#define hex_EXTRN:%0#%1,%2|||%3|||%4,%5) EXTRY:%0#%1h,%2,%3|||%4|||%5)
#define hex_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<h>[%7],%2,%3|||%4|||%5)

#define bin:%0;unformat(%1) %0;unformat(%1)
#define bin_EXTRO:%0#%1,%2|||%3=%9|||%4,%5) EXTRY:%0#%1B"("#%9")"#,%2,%3|||%4|||%5)
#define bin_EXTRN:%0#%1,%2|||%3|||%4,%5) EXTRY:%0#%1b,%2,%3|||%4|||%5)
#define bin_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<b>[%7],%2,%3|||%4|||%5)

#define kustom:%0<%1> %0
#define kustom_EXTRO:%0#%1,%2|||%3<%8>=%9|||%4,%5) EXTRY:%0#%1K<%8>"("#%9")"#,%2,%3|||%4|||%5)
#define kustom_EXTRN:%0#%1,%2|||%3<%8>|||%4,%5) EXTRY:%0#%1k<%8>,%2,%3|||%4|||%5)
//#define bin_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<b>[%7],%2,%3|||%4|||%5)

SSCANF:weapon(sstring[])
{
	// This function is VERY basic, needs VASTLY improving to detect variations.
	if ('0' <= sstring[0] <= '9')
	{
		new
			ret = strval(sstring);
		if (0 <= ret <= 18 || 22 <= ret <= 46)
		{
			return ret;
		}
	}
	else if (!strcmp(sstring, "Unarmed", true)) return 0;
	else if (!strcmp(sstring, "Brass Knuckles", true)) return 1;
	else if (!strcmp(sstring, "Golf Club", true)) return 2;
	else if (!strcmp(sstring, "Night Stick", true)) return 3;
	else if (!strcmp(sstring, "Knife", true)) return 4;
	else if (!strcmp(sstring, "Baseball Bat", true)) return 5;
	else if (!strcmp(sstring, "Shovel", true)) return 6;
	else if (!strcmp(sstring, "Pool cue", true)) return 7;
	else if (!strcmp(sstring, "Katana", true)) return 8;
	else if (!strcmp(sstring, "Chainsaw", true)) return 9;
	else if (!strcmp(sstring, "Purple Dildo", true)) return 10;
	else if (!strcmp(sstring, "White Dildo", true)) return 11;
	else if (!strcmp(sstring, "Long White Dildo", true)) return 12;
	else if (!strcmp(sstring, "White Dildo 2", true)) return 13;
	else if (!strcmp(sstring, "Flowers", true)) return 14;
	else if (!strcmp(sstring, "Cane", true)) return 15;
	else if (!strcmp(sstring, "Grenades", true)) return 16;
	else if (!strcmp(sstring, "Tear Gas", true)) return 17;
	else if (!strcmp(sstring, "Molotovs", true)) return 18;
	else if (!strcmp(sstring, "Pistol", true)) return 22;
	else if (!strcmp(sstring, "Silenced Pistol", true)) return 23;
	else if (!strcmp(sstring, "Desert Eagle", true)) return 24;
	else if (!strcmp(sstring, "Shotgun", true)) return 25;
	else if (!strcmp(sstring, "Sawn Off Shotgun", true)) return 26;
	else if (!strcmp(sstring, "Combat Shotgun", true)) return 27;
	else if (!strcmp(sstring, "Micro Uzi", true)) return 28;
	else if (!strcmp(sstring, "Mac 10", true)) return 28;
	else if (!strcmp(sstring, "MP5", true)) return 29;
	else if (!strcmp(sstring, "AK47", true)) return 30;
	else if (!strcmp(sstring, "M4", true)) return 31;
	else if (!strcmp(sstring, "Tec9", true)) return 32;
	else if (!strcmp(sstring, "Rifle", true)) return 33;
	else if (!strcmp(sstring, "Sniper Rifle", true)) return 34;
	else if (!strcmp(sstring, "RPG", true)) return 35;
	else if (!strcmp(sstring, "Missile Launcher", true)) return 36;
	else if (!strcmp(sstring, "Flame Thrower", true)) return 37;
	else if (!strcmp(sstring, "Minigun", true)) return 38;
	else if (!strcmp(sstring, "Sachel Charges", true)) return 39;
	else if (!strcmp(sstring, "Detonator", true)) return 40;
	else if (!strcmp(sstring, "Spray Paint", true)) return 41;
	else if (!strcmp(sstring, "Fire Extinguisher", true)) return 42;
	else if (!strcmp(sstring, "Camera", true)) return 43;
	else if (!strcmp(sstring, "Nightvision Goggles", true)) return 44;
	else if (!strcmp(sstring, "Thermal Goggles", true)) return 45;
	else if (!strcmp(sstring, "Parachute", true)) return 46;
	return -1;
}

SSCANF:vehicle(sstring[])
{
	// This function is VERY basic, needs VASTLY improving to detect variations.
	if ('0' <= sstring[0] <= '9')
	{
		new
			ret = strval(sstring);
		if (400 <= ret <= 611)
		{
			return ret;
		}
	}
	else if (!strcmp(sstring, "Landstalker", true)) return 400;
	else if (!strcmp(sstring, "Bravura", true)) return 401;
	else if (!strcmp(sstring, "Buffalo", true)) return 402;
	else if (!strcmp(sstring, "Linerunner", true)) return 403;
	else if (!strcmp(sstring, "Perenniel", true)) return 404;
	else if (!strcmp(sstring, "Sentinel", true)) return 405;
	else if (!strcmp(sstring, "Dumper", true)) return 406;
	else if (!strcmp(sstring, "Firetruck", true)) return 407;
	else if (!strcmp(sstring, "Trashmaster", true)) return 408;
	else if (!strcmp(sstring, "Stretch", true)) return 409;
	else if (!strcmp(sstring, "Manana", true)) return 410;
	else if (!strcmp(sstring, "Infernus", true)) return 411;
	else if (!strcmp(sstring, "Voodoo", true)) return 412;
	else if (!strcmp(sstring, "Pony", true)) return 413;
	else if (!strcmp(sstring, "Mule", true)) return 414;
	else if (!strcmp(sstring, "Cheetah", true)) return 415;
	else if (!strcmp(sstring, "Ambulance", true)) return 416;
	else if (!strcmp(sstring, "Leviathan", true)) return 417;
	else if (!strcmp(sstring, "Moonbeam", true)) return 418;
	else if (!strcmp(sstring, "Esperanto", true)) return 419;
	else if (!strcmp(sstring, "Taxi", true)) return 420;
	else if (!strcmp(sstring, "Washington", true)) return 421;
	else if (!strcmp(sstring, "Bobcat", true)) return 422;
	else if (!strcmp(sstring, "Mr Whoopee", true)) return 423;
	else if (!strcmp(sstring, "BF Injection", true)) return 424;
	else if (!strcmp(sstring, "Hunter", true)) return 425;
	else if (!strcmp(sstring, "Premier", true)) return 426;
	else if (!strcmp(sstring, "Enforcer", true)) return 427;
	else if (!strcmp(sstring, "Securicar", true)) return 428;
	else if (!strcmp(sstring, "Banshee", true)) return 429;
	else if (!strcmp(sstring, "Predator", true)) return 430;
	else if (!strcmp(sstring, "Bus", true)) return 431;
	else if (!strcmp(sstring, "Rhino", true)) return 432;
	else if (!strcmp(sstring, "Barracks", true)) return 433;
	else if (!strcmp(sstring, "Hotknife", true)) return 434;
	else if (!strcmp(sstring, "Article Trailer", true)) return 435;
	else if (!strcmp(sstring, "Previon", true)) return 436;
	else if (!strcmp(sstring, "Coach", true)) return 437;
	else if (!strcmp(sstring, "Cabbie", true)) return 438;
	else if (!strcmp(sstring, "Stallion", true)) return 439;
	else if (!strcmp(sstring, "Rumpo", true)) return 440;
	else if (!strcmp(sstring, "RC Bandit", true)) return 441;
	else if (!strcmp(sstring, "Romero", true)) return 442;
	else if (!strcmp(sstring, "Packer", true)) return 443;
	else if (!strcmp(sstring, "Monster", true)) return 444;
	else if (!strcmp(sstring, "Admiral", true)) return 445;
	else if (!strcmp(sstring, "Squallo", true)) return 446;
	else if (!strcmp(sstring, "Seasparrow", true)) return 447;
	else if (!strcmp(sstring, "Pizzaboy", true)) return 448;
	else if (!strcmp(sstring, "Tram", true)) return 449;
	else if (!strcmp(sstring, "Article Trailer 2", true)) return 450;
	else if (!strcmp(sstring, "Turismo", true)) return 451;
	else if (!strcmp(sstring, "Speeder", true)) return 452;
	else if (!strcmp(sstring, "Reefer", true)) return 453;
	else if (!strcmp(sstring, "Tropic", true)) return 454;
	else if (!strcmp(sstring, "Flatbed", true)) return 455;
	else if (!strcmp(sstring, "Yankee", true)) return 456;
	else if (!strcmp(sstring, "Caddy", true)) return 457;
	else if (!strcmp(sstring, "Solair", true)) return 458;
	else if (!strcmp(sstring, "Berkley's RC Van", true)) return 459;
	else if (!strcmp(sstring, "Skimmer", true)) return 460;
	else if (!strcmp(sstring, "PCJ-600", true)) return 461;
	else if (!strcmp(sstring, "Faggio", true)) return 462;
	else if (!strcmp(sstring, "Freeway", true)) return 463;
	else if (!strcmp(sstring, "RC Baron", true)) return 464;
	else if (!strcmp(sstring, "RC Raider", true)) return 465;
	else if (!strcmp(sstring, "Glendale", true)) return 466;
	else if (!strcmp(sstring, "Oceanic", true)) return 467;
	else if (!strcmp(sstring, "Sanchez", true)) return 468;
	else if (!strcmp(sstring, "Sparrow", true)) return 469;
	else if (!strcmp(sstring, "Patriot", true)) return 470;
	else if (!strcmp(sstring, "Quad", true)) return 471;
	else if (!strcmp(sstring, "Coastguard", true)) return 472;
	else if (!strcmp(sstring, "Dinghy", true)) return 473;
	else if (!strcmp(sstring, "Hermes", true)) return 474;
	else if (!strcmp(sstring, "Sabre", true)) return 475;
	else if (!strcmp(sstring, "Rustler", true)) return 476;
	else if (!strcmp(sstring, "ZR-350", true)) return 477;
	else if (!strcmp(sstring, "Walton", true)) return 478;
	else if (!strcmp(sstring, "Regina", true)) return 479;
	else if (!strcmp(sstring, "Comet", true)) return 480;
	else if (!strcmp(sstring, "BMX", true)) return 481;
	else if (!strcmp(sstring, "Burrito", true)) return 482;
	else if (!strcmp(sstring, "Camper", true)) return 483;
	else if (!strcmp(sstring, "Marquis", true)) return 484;
	else if (!strcmp(sstring, "Baggage", true)) return 485;
	else if (!strcmp(sstring, "Dozer", true)) return 486;
	else if (!strcmp(sstring, "Maverick", true)) return 487;
	else if (!strcmp(sstring, "SAN News Maverick", true)) return 488;
	else if (!strcmp(sstring, "Rancher", true)) return 489;
	else if (!strcmp(sstring, "FBI Rancher", true)) return 490;
	else if (!strcmp(sstring, "Virgo", true)) return 491;
	else if (!strcmp(sstring, "Greenwood", true)) return 492;
	else if (!strcmp(sstring, "Jetmax", true)) return 493;
	else if (!strcmp(sstring, "Hotring Racer", true)) return 494;
	else if (!strcmp(sstring, "Sandking", true)) return 495;
	else if (!strcmp(sstring, "Blista Compact", true)) return 496;
	else if (!strcmp(sstring, "Police Maverick", true)) return 497;
	else if (!strcmp(sstring, "Boxville", true)) return 498;
	else if (!strcmp(sstring, "Benson", true)) return 499;
	else if (!strcmp(sstring, "Mesa", true)) return 500;
	else if (!strcmp(sstring, "RC Goblin", true)) return 501;
	else if (!strcmp(sstring, "Hotring Racer", true)) return 502;
	else if (!strcmp(sstring, "Hotring Racer", true)) return 503;
	else if (!strcmp(sstring, "Bloodring Banger", true)) return 504;
	else if (!strcmp(sstring, "Rancher", true)) return 505;
	else if (!strcmp(sstring, "Super GT", true)) return 506;
	else if (!strcmp(sstring, "Elegant", true)) return 507;
	else if (!strcmp(sstring, "Journey", true)) return 508;
	else if (!strcmp(sstring, "Bike", true)) return 509;
	else if (!strcmp(sstring, "Mountain Bike", true)) return 510;
	else if (!strcmp(sstring, "Beagle", true)) return 511;
	else if (!strcmp(sstring, "Cropduster", true)) return 512;
	else if (!strcmp(sstring, "Stuntplane", true)) return 513;
	else if (!strcmp(sstring, "Tanker", true)) return 514;
	else if (!strcmp(sstring, "Roadtrain", true)) return 515;
	else if (!strcmp(sstring, "Nebula", true)) return 516;
	else if (!strcmp(sstring, "Majestic", true)) return 517;
	else if (!strcmp(sstring, "Buccaneer", true)) return 518;
	else if (!strcmp(sstring, "Shamal", true)) return 519;
	else if (!strcmp(sstring, "Hydra", true)) return 520;
	else if (!strcmp(sstring, "FCR-900", true)) return 521;
	else if (!strcmp(sstring, "NRG-500", true)) return 522;
	else if (!strcmp(sstring, "HPV1000", true)) return 523;
	else if (!strcmp(sstring, "Cement Truck", true)) return 524;
	else if (!strcmp(sstring, "Towtruck", true)) return 525;
	else if (!strcmp(sstring, "Fortune", true)) return 526;
	else if (!strcmp(sstring, "Cadrona", true)) return 527;
	else if (!strcmp(sstring, "FBI Truck", true)) return 528;
	else if (!strcmp(sstring, "Willard", true)) return 529;
	else if (!strcmp(sstring, "Forklift", true)) return 530;
	else if (!strcmp(sstring, "Tractor", true)) return 531;
	else if (!strcmp(sstring, "Combine Harvester", true)) return 532;
	else if (!strcmp(sstring, "Feltzer", true)) return 533;
	else if (!strcmp(sstring, "Remington", true)) return 534;
	else if (!strcmp(sstring, "Slamvan", true)) return 535;
	else if (!strcmp(sstring, "Blade", true)) return 536;
	else if (!strcmp(sstring, "Freight (Train)", true)) return 537;
	else if (!strcmp(sstring, "Brownstreak (Train)", true)) return 538;
	else if (!strcmp(sstring, "Vortex", true)) return 539;
	else if (!strcmp(sstring, "Vincent", true)) return 540;
	else if (!strcmp(sstring, "Bullet", true)) return 541;
	else if (!strcmp(sstring, "Clover", true)) return 542;
	else if (!strcmp(sstring, "Sadler", true)) return 543;
	else if (!strcmp(sstring, "Firetruck LA", true)) return 544;
	else if (!strcmp(sstring, "Hustler", true)) return 545;
	else if (!strcmp(sstring, "Intruder", true)) return 546;
	else if (!strcmp(sstring, "Primo", true)) return 547;
	else if (!strcmp(sstring, "Cargobob", true)) return 548;
	else if (!strcmp(sstring, "Tampa", true)) return 549;
	else if (!strcmp(sstring, "Sunrise", true)) return 550;
	else if (!strcmp(sstring, "Merit", true)) return 551;
	else if (!strcmp(sstring, "Utility Van", true)) return 552;
	else if (!strcmp(sstring, "Nevada", true)) return 553;
	else if (!strcmp(sstring, "Yosemite", true)) return 554;
	else if (!strcmp(sstring, "Windsor", true)) return 555;
	else if (!strcmp(sstring, "Monster \"A\"", true)) return 556;
	else if (!strcmp(sstring, "Monster \"B\"", true)) return 557;
	else if (!strcmp(sstring, "Uranus", true)) return 558;
	else if (!strcmp(sstring, "Jester", true)) return 559;
	else if (!strcmp(sstring, "Sultan", true)) return 560;
	else if (!strcmp(sstring, "Stratum", true)) return 561;
	else if (!strcmp(sstring, "Elegy", true)) return 562;
	else if (!strcmp(sstring, "Raindance", true)) return 563;
	else if (!strcmp(sstring, "RC Tiger", true)) return 564;
	else if (!strcmp(sstring, "Flash", true)) return 565;
	else if (!strcmp(sstring, "Tahoma", true)) return 566;
	else if (!strcmp(sstring, "Savanna", true)) return 567;
	else if (!strcmp(sstring, "Bandito", true)) return 568;
	else if (!strcmp(sstring, "Freight Flat Trailer (Train)", true)) return 569;
	else if (!strcmp(sstring, "Streak Trailer (Train)", true)) return 570;
	else if (!strcmp(sstring, "Kart", true)) return 571;
	else if (!strcmp(sstring, "Mower", true)) return 572;
	else if (!strcmp(sstring, "Dune", true)) return 573;
	else if (!strcmp(sstring, "Sweeper", true)) return 574;
	else if (!strcmp(sstring, "Broadway", true)) return 575;
	else if (!strcmp(sstring, "Tornado", true)) return 576;
	else if (!strcmp(sstring, "AT400", true)) return 577;
	else if (!strcmp(sstring, "DFT-30", true)) return 578;
	else if (!strcmp(sstring, "Huntley", true)) return 579;
	else if (!strcmp(sstring, "Stafford", true)) return 580;
	else if (!strcmp(sstring, "BF-400", true)) return 581;
	else if (!strcmp(sstring, "Newsvan", true)) return 582;
	else if (!strcmp(sstring, "Tug", true)) return 583;
	else if (!strcmp(sstring, "Petrol Trailer", true)) return 584;
	else if (!strcmp(sstring, "Emperor", true)) return 585;
	else if (!strcmp(sstring, "Wayfarer", true)) return 586;
	else if (!strcmp(sstring, "Euros", true)) return 587;
	else if (!strcmp(sstring, "Hotdog", true)) return 588;
	else if (!strcmp(sstring, "Club", true)) return 589;
	else if (!strcmp(sstring, "Freight Box Trailer (Train)", true)) return 590;
	else if (!strcmp(sstring, "Article Trailer 3", true)) return 591;
	else if (!strcmp(sstring, "Andromada", true)) return 592;
	else if (!strcmp(sstring, "Dodo", true)) return 593;
	else if (!strcmp(sstring, "RC Cam", true)) return 594;
	else if (!strcmp(sstring, "Launch", true)) return 595;
	else if (!strcmp(sstring, "Police Car (LSPD)", true)) return 596;
	else if (!strcmp(sstring, "Police Car (SFPD)", true)) return 597;
	else if (!strcmp(sstring, "Police Car (LVPD)", true)) return 598;
	else if (!strcmp(sstring, "Police Ranger", true)) return 599;
	else if (!strcmp(sstring, "Picador", true)) return 600;
	else if (!strcmp(sstring, "S.W.A.T.", true)) return 601;
	else if (!strcmp(sstring, "Alpha", true)) return 602;
	else if (!strcmp(sstring, "Phoenix", true)) return 603;
	else if (!strcmp(sstring, "Glendale Shit", true)) return 604;
	else if (!strcmp(sstring, "Sadler Shit", true)) return 605;
	else if (!strcmp(sstring, "Baggage Trailer \"A\"", true)) return 606;
	else if (!strcmp(sstring, "Baggage Trailer \"B\"", true)) return 607;
	else if (!strcmp(sstring, "Tug Stairs Trailer", true)) return 608;
	else if (!strcmp(sstring, "Boxville", true)) return 609;
	else if (!strcmp(sstring, "Farm Trailer", true)) return 610;
	else if (!strcmp(sstring, "Utility Trailer", true)) return 611;
	return -1;
}

// Fix the compiler crash when both the PAWN and Plugin versions of sscanf are
// found by renaming the old version at declaration.  (fixes.inc compatible
// naming scheme: "BAD_Function()").
#define sscanf(%0:...) BAD_sscanf(%0:...)
