/* Переменные игрока */

// Обнуление переменных
stock NullPlayerVariables(playerid)
{
    PI[playerid][pLastDate] = 0;
    PI[playerid][pLastIP][0] = EOS;
    PI[playerid][pRating] = 0;
    PI[playerid][pMoney] = 0;
    PI[playerid][pKills] = 0;
    PI[playerid][pDeaths] = 0;

    PI[playerid][pSettingsTDLanguage] = 0;

    TI[playerid][tSpec] = false;
    TI[playerid][tDialogID] = 0;
    TI[playerid][tLogin] = false;
    TI[playerid][tLoginAttempts] = 0;
    TI[playerid][tDMZone] = -1;
    SetPlayerHealthAC(playerid, 100.0);
    TI[playerid][tDeathState] = 0;
    TI[playerid][tWeapons][0] = EOS; // Обнуление массива с оружием в руках
    return 1;
}

stock pvars_OnPlayerConnect(playerid)
{
    NullPlayerVariables(playerid);
    return 1;
}

stock pvars_OnPlayerDisconnect(playerid)
{
    UpdatePlayerDB(playerid);
    NullPlayerVariables(playerid);
    return 1;
}

stock LoadPlayerVariables(playerid)
{
    cache_get_value_name_int(0, !"pRegDate", PI[playerid][pRegDate]);
    cache_get_value_name_int(0, !"pRegIP", PI[playerid][pRegIP]);
    cache_get_value_name_int(0, !"pRating", PI[playerid][pRating]);
    SetPlayerScore(playerid, PI[playerid][pRating]);
    cache_get_value_name_int(0, !"pMoney", PI[playerid][pMoney]);
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PI[playerid][pMoney]);
    cache_get_value_name_int(0, !"pKills", PI[playerid][pKills]);
    cache_get_value_name_int(0, !"pDeaths", PI[playerid][pDeaths]);

    static settings[65];
    cache_get_value_name(0, !"pSettings", settings);
    sscanf(settings, !"p<|>d", PI[playerid][pSettingsTDLanguage]);
    return 1;
}

stock UpdatePlayerDB(playerid)
{
    if(!TI[playerid][tLogin]) return 0;

    static settings[65];
    format(settings, sizeof(settings), "%d", PI[playerid][pSettingsTDLanguage]);

    mysql_format(dbHandle, string, sizeof(string), "UPDATE `accounts` SET \
        `pLastDate` = '%d', `pLastIP` = '%s', `pRating` = '%d', `pMoney` = '%d', `pSettings` = '%s', \
        `pKills` = '%d', `pDeaths` = '%d' \
        WHERE `pID` = '%d' LIMIT 1",
        gettime(), TI[playerid][tIP], PI[playerid][pRating], PI[playerid][pMoney], settings,
        PI[playerid][pKills], PI[playerid][pDeaths],
        PI[playerid][pID]);

    return mysql_pquery(dbHandle, string);
}