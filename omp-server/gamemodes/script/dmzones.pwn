stock dmzones_OnGameModeInit()
{
    Iter_Init(DMZPlayer);
    return 1;
}

CMD:dm(playerid)
{
    return ShowDMZones(playerid);
}
alias:dm("dmz", "dmzone", "dmzones", "дм", "дмз", "дмзона", "дмзоны", "deathmatch", "мочилово");

stock ShowDMZones(playerid)
{
    string = ""D_TH"Название\tОружие\tТребуемый рейтинг\tКоличество игроков";
    for(iter = 0; iter < sizeof(DMZones); iter++)
    {
        format(cline, sizeof(cline),
            "\n"D_LIST("1")"%s\t"C_W"%s\t%s%d\t"C_LG"%d/%d",
            DMZones[iter][E_DMZ_NAME],
            DMZoneGuns[DMZones[iter][E_DMZ_GUNS]],
            PI[playerid][pRating] >= DMZones[iter][E_DMZ_RATING] ? C_W : C_R, DMZones[iter][E_DMZ_RATING],
            DMZones[iter][E_DMZ_PLAYERCOUNT], DMZones[iter][E_DMZ_MAXPLAYERS]);
        strcat(string, cline);
    }
    return SPD(playerid, DLG_DMZ, DSTH, !""D_G"ДМ-зоны", string, !"Выбрать", !"Закрыть");
}

stock dmzones_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DLG_DMZ:
        {
            if(!response) return 1;
            if(!(0 <= listitem < sizeof(DMZones))) return ShowDMZones(playerid);

            if(TI[playerid][tDMZone] == listitem) return ShowDMZones(playerid), SendClientMessage(playerid, CH_R, !""CLINE"Вы уже находитесь в выбранной ДМ-зоне. Выйти - "C_CON"/leave"C_W".");
            if(DMZones[listitem][E_DMZ_RATING] > PI[playerid][pRating]) return ShowDMZones(playerid), SendClientMessage(playerid, CH_R, !""CLINE"У вас недостаточно рейтинга для входа в выбранную ДМ-зону.");
            if(DMZones[listitem][E_DMZ_PLAYERCOUNT] >= DMZones[listitem][E_DMZ_MAXPLAYERS]) return ShowDMZones(playerid), SendClientMessage(playerid, CH_R, !""CLINE"Данная ДМ-зона переполнена.");

            SetPlayerDMZone(playerid, listitem);
            return SpawnDMZone(playerid);
        }
    }
    return 1;
}

stock SetPlayerDMZone(playerid, zone)
{
    if(zone == -1 && TI[playerid][tDMZone] != zone)
    {
        Iter_Remove(DMZPlayer[TI[playerid][tDMZone]], playerid);
        --DMZones[TI[playerid][tDMZone]][E_DMZ_PLAYERCOUNT];
    }
    else if(zone >= 0 && TI[playerid][tDMZone] == -1)
    {
        Iter_Add(DMZPlayer[zone], playerid);
        ++DMZones[zone][E_DMZ_PLAYERCOUNT];
    }
    else if(zone >= 0 && TI[playerid][tDMZone] != zone)
    {
        Iter_Remove(DMZPlayer[TI[playerid][tDMZone]], playerid);
        --DMZones[TI[playerid][tDMZone]][E_DMZ_PLAYERCOUNT];
        Iter_Add(DMZPlayer[zone], playerid);
        ++DMZones[zone][E_DMZ_PLAYERCOUNT];
    }
    TI[playerid][tDMZone] = zone;
    return 1;
}

stock SpawnDMZone(playerid)
{
    DMRowKills[playerid] = 0;
    GiveDMGunKit(playerid);
    iter = random(DMZonePosesCount[DMZones[TI[playerid][tDMZone]][E_DMZ_MAP]]);
    return SetPlayerPosEx(playerid, DMZonePoses[DMZones[TI[playerid][tDMZone]][E_DMZ_MAP]][iter][0], DMZonePoses[DMZones[TI[playerid][tDMZone]][E_DMZ_MAP]][iter][1], DMZonePoses[DMZones[TI[playerid][tDMZone]][E_DMZ_MAP]][iter][2], DMZonePoses[DMZones[TI[playerid][tDMZone]][E_DMZ_MAP]][iter][3], 1001+TI[playerid][tDMZone], DMZoneMaps[DMZones[TI[playerid][tDMZone]][E_DMZ_MAP]][E_DMZM_INTERIOR]);
}

stock dmzones_Timer()
{
    for(iter = 0; iter < sizeof(DMZones); iter++)
    {
        if(DMZones[iter][E_DMZ_TYPE] != E_DMZT_MOCHILOVO) continue;
        if(UpdateSeconds % DMZoneMaps[DMZones[iter][E_DMZ_MAP]][E_DMZM_EXPLINTERVAL] != 0) continue;
        for(kter = 0; kter < DMZoneMaps[DMZones[iter][E_DMZ_MAP]][E_DMZM_EXPLCOUNT]; kter++)
        {
            jter = random(DMZoneMapsExplosionsCount[DMZoneMaps[DMZones[iter][E_DMZ_MAP]][E_DMZM_EXPLARRAY]]);
            CreateDynamicExplosion(DMZoneMapsExplosions[DMZoneMaps[DMZones[iter][E_DMZ_MAP]][E_DMZM_EXPLARRAY]][jter][0], DMZoneMapsExplosions[DMZoneMaps[DMZones[iter][E_DMZ_MAP]][E_DMZM_EXPLARRAY]][jter][1],DMZoneMapsExplosions[DMZoneMaps[DMZones[iter][E_DMZ_MAP]][E_DMZM_EXPLARRAY]][jter][2], 0, 5.0, World_DMZone+iter, 75.0);
        }
    }
    return 1;
}

stock GiveDMGunKit(playerid)
{
    ResetPlayerWeaponsAC(playerid);
    switch(DMZones[TI[playerid][tDMZone]][E_DMZ_GUNS])
    {
        case 0:
        {
            iter = random(sizeof(RandomGunKit));
            GivePlayerWeaponAC(playerid, RandomGunKit[iter], 10000);
        }
        case 1:
        {
            GivePlayerWeaponAC(playerid, 24, 98);
        }
        case 2:
        {
            GivePlayerWeaponAC(playerid, 24, 98);
            GivePlayerWeaponAC(playerid, 31, 250);
        }
    }
    return 1;
}

stock dmzones_OnPlayerSpawn(playerid)
{
    if(TI[playerid][tDMZone] == -1) return 1;
    SpawnDMZone(playerid);
    SetPlayerHealthAC(playerid, 100.0);
    return 1;
}

stock dmzones_OnPlayerSecondUpdate(playerid)
{
    if(TI[playerid][tDMZone] != -1)
    {
        if(++TI[playerid][tDMZoneTime] % 10 == 0)
        {
            GiveDMGunKit(playerid);
        }
    }
    return 1;
}

stock dmzones_OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
    if(TI[playerid][tDMZone] == -1) return 1;

    TI[playerid][tDeathState] = 1;
    if(killerid != INVALID_PLAYER_ID) GivePlayerDMKill(killerid, playerid);
    DMRowKills[playerid] = 0;
    ++PI[playerid][pDeaths];
    return 1;
}

stock GivePlayerDMKill(playerid, killedid)
{
    ++PI[playerid][pKills];
    ++DMRowKills[playerid];
    if(DMRowKills[playerid] == 1)
    {
        GivePlayerMoneyEx(playerid, SS[E_SS_DMKILLPRIZE]);
        format(cline, sizeof(cline), "~g~~h~KILL\n+%d$", SS[E_SS_DMKILLPRIZE]);
        GameTextForPlayer(playerid, cline, 2000, 6);
    }
    else
    {
        GivePlayerMoneyEx(playerid, SS[E_SS_DMROWKILLPRIZE]);
        GivePlayerRating(playerid, 1);
        format(cline, sizeof(cline), "~g~~h~2X KILL\n+%d$\n~y~+1 RATING", SS[E_SS_DMROWKILLPRIZE]);
        GameTextForPlayer(playerid, cline, 2000, 6);
    }
    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);

    format(cline, sizeof(cline), "~r~~h~KILLED BY\n%s", PI[playerid][pName]);
    GameTextForPlayer(killedid, cline, 2000, 6);
}