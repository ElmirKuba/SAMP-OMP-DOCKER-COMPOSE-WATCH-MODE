/* Анти-чит */

stock TogglePlayerSpectatingAC(playerid, bool:mode)
{
    TI[playerid][tSpec] = mode;
    return TogglePlayerSpectating(playerid, mode);
}

stock AntiCheat(playerid, code)
{
    // Написать код для срабатывания античита
    return 1;
}

stock anticheat_OnDialogResponse(playerid, dialogid)
{
    if(dialogid != TI[playerid][tDialogID]) return AntiCheat(playerid, AC_BYPASS);
    return 1;
}

stock SetPlayerHealthAC(playerid, Float:health)
{
    TI[playerid][tHP] = health;
    return SetPlayerHealth(playerid, health);
}

stock anticheat_OnPlayerSecondUpdate(playerid)
{
    SetPlayerHealthAC(playerid, TI[playerid][tHP]);
}

stock GivePlayerWeaponAC(playerid, WEAPON:weaponid, ammo)
{
    TI[playerid][tWeapons][Weapons[weaponid][E_WEAPON_SLOT]] = weaponid;
    return GivePlayerWeapon(playerid, weaponid, ammo);
}

stock ResetPlayerWeaponsAC(playerid)
{
    static i;
    for(i = 0; i < 13; i++) TI[playerid][tWeapons][i] = 0;
    return ResetPlayerWeapons(playerid);
}

stock anticheat_SetPlayerPos(playerid, Float:x, Float:y, Float:z)
{
    tAC_TPTime[playerid] = GetTickCount()+1000;
    return SetPlayerPos(playerid, x, y, z);
}
#if defined _ALS_SetPlayerPos
	#undef SetPlayerPos
#else
	#define _ALS_SetPlayerPos
#endif
#define SetPlayerPos anticheat_SetPlayerPos