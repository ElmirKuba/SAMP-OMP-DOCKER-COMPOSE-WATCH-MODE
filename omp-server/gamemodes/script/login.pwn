// �����������/�����������

// �������� ������������ ������
stock SetPlayerLoadScreen(playerid, type = 1) // type = 1 - � ���������, 0 - ��� ��������
{
    TogglePlayerSpectatingAC(playerid, true);
    if(type)
    {
        InterpolateCameraPos(playerid, LoadScreen[E_LOADSCREEN_POS_FROM][0], LoadScreen[E_LOADSCREEN_POS_FROM][1], LoadScreen[E_LOADSCREEN_POS_FROM][2], LoadScreen[E_LOADSCREEN_POS_TO][0], LoadScreen[E_LOADSCREEN_POS_TO][1], LoadScreen[E_LOADSCREEN_POS_TO][2], LoadScreen[E_LOADSCREEN_TIME]);
        InterpolateCameraLookAt(playerid, LoadScreen[E_LOADSCREEN_LOOK_FROM][0], LoadScreen[E_LOADSCREEN_LOOK_FROM][1], LoadScreen[E_LOADSCREEN_LOOK_FROM][2], LoadScreen[E_LOADSCREEN_LOOK_TO][0], LoadScreen[E_LOADSCREEN_LOOK_TO][1], LoadScreen[E_LOADSCREEN_LOOK_TO][2], LoadScreen[E_LOADSCREEN_TIME]);
    }
    else
    {
        InterpolateCameraPos(playerid, LoadScreen[E_LOADSCREEN_POS_TO][0], LoadScreen[E_LOADSCREEN_POS_TO][1], LoadScreen[E_LOADSCREEN_POS_TO][2], LoadScreen[E_LOADSCREEN_POS_TO][0], LoadScreen[E_LOADSCREEN_POS_TO][1], LoadScreen[E_LOADSCREEN_POS_TO][2], 1000);
        InterpolateCameraLookAt(playerid, LoadScreen[E_LOADSCREEN_LOOK_TO][0], LoadScreen[E_LOADSCREEN_LOOK_TO][1], LoadScreen[E_LOADSCREEN_LOOK_TO][2], LoadScreen[E_LOADSCREEN_LOOK_TO][0], LoadScreen[E_LOADSCREEN_LOOK_TO][1], LoadScreen[E_LOADSCREEN_LOOK_TO][2], 1000);
    }
    return 1;
}

stock login_OnPlayerConnect(playerid)
{
    SetPlayerLoadScreen(playerid);
    SetCustomTimerEx(!"OnConnectClearChat", 500, false, 1, !"i", playerid);

    GetPlayerName(playerid, PI[playerid][pName], MAX_PLAYER_NAME+1);
	if(strfind(PI[playerid][pName], "Logging_Player_", true) != -1)
	{
		format(string, sizeof(string),
			""C_W"������ ������� ������� � ���-������ "C_CON"%s"C_W".\n\n\
            "D_PRIM"� �� ���������� ������� "C_CON"Logging_Player_"C_W", �������������� � ������� ������������.",
			PI[playerid][pName]);
		SPD(playerid, DLG_NONE, DSM, !""D_R"����������� ������ � ���-�����", string, !"�������", "");
		return KickEx(playerid);
	}
	format(cline, sizeof(cline), "Logging_Player_%d", playerid);
	SetPlayerName(playerid, cline);
	GetPlayerIp(playerid, TI[playerid][tIP], 16);

    SetSpawnInfo(playerid,1,101,2043.195, -1402.992, 68.313, 90.0,0,0,0,0,0,0);
    CheckPlayerAccount(playerid);
    return 1;
}

CB:OnConnectClearChat(playerid)
{
    for(iter = 0; iter < 32; iter++) SendClientMessage(playerid, -1, "");
    SetPlayerLoadScreen(playerid);
    return 1;
}

stock CheckPlayerAccount(playerid)
{
    mysql_format(dbHandle, string, sizeof(string), "SELECT * FROM `accounts` WHERE `pName` = '%e' LIMIT 1", PI[playerid][pName]);
    return mysql_tquery(dbHandle, string, !"OnCheckPlayerAccount", !"d", playerid);
}
CB:OnCheckPlayerAccount(playerid)
{
    cache_get_row_count(rows);
    if(!rows) return ShowReg(playerid);

    cache_get_value_name_int(0, !"pID", PI[playerid][pID]);
    cache_get_value_name(0, !"pPasswordHash", PI[playerid][pPasswordHash]);
    cache_get_value_name(0, !"pPasswordSalt", PI[playerid][pPasswordSalt]);
    cache_get_value_name(0, !"pName", PI[playerid][pName]);
    return ShowLogin(playerid);
}

stock ShowLogin(playerid, type = 0)
{
    format(string, sizeof(string),
         ""C_W"����� ���������� �� "C_CON""ProjectName""C_W"!\n\
        ������� � ���-������ "C_CON"%s "C_GCON"���������������"C_W".\n\n\
        "D_PRIM"������� ������ ��� ����, ����� ��������������.",
        PI[playerid][pName]);

    switch(type)
    {
        case 1: strcat(string, "\n\n"D_PRIMR"�� �������� ���� ������.");
        case 2:
        {
            if(TI[playerid][tLoginAttempts] == 1) strcat(string, "\n\n"D_PRIMY"������ ��������, �������� "C_CON"2"C_W" �������.");
            else strcat(string, "\n\n"D_PRIMY"������ ��������, �������� ��������� �������.");
        }
    }
    return SPD(playerid, DLG_LOGIN, DSP, type ? !""D_Y"�����������" : !""D_G"�����������", string, !"�����", !"�����");
}

stock ShowReg(playerid)
{
    format(string, sizeof(string),
        ""C_W"����� ���������� �� "C_CON""ProjectName""C_W"!\n\
        ������� � ���-������ "C_CON"%s "C_GCON"�� ���������������"C_W".\n\n\
        "D_PRIM"��� ����������� �������� ������� \""C_CON"�����"C_W"\"",
        PI[playerid][pName]);
    return SPD(playerid, DLG_REG, DSM, !""D_G"����� ����������!", string, !"�����", !"�����");
}

stock login_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[])
{
    #pragma unused listitem
    switch(dialogid)
    {
        case DLG_REG:
        {
            if(!response) return SendClientMessage(playerid, CH_R, !""CLINE"�� ����� � �������."), KickEx(playerid);
            return ShowRegInput(playerid);
        }
        case DLG_REGINPUT:
        {
            if(!response) return SendClientMessage(playerid, CH_R, !""CLINE"�� ����� � �������."), KickEx(playerid);
            len = strlen(inputtext);
            if(!len) return ShowRegInput(playerid, 1);
            if(!(6 <= len <= 32)) return ShowRegInput(playerid, 2);
            if(!IsValidPassword(inputtext)) return ShowRegInput(playerid, 3);
            if(IsEasyPassword(inputtext)) return ShowRegInput(playerid, 4);
            strcpy(TI[playerid][tPassword], inputtext);
            return ShowRegInput2(playerid);
        }
        case DLG_REGINPUT2:
        {
            if(!response) return ShowRegInput(playerid);
            if(isnull(inputtext)) return ShowRegInput2(playerid, 1);
            if(strcmp(inputtext, TI[playerid][tPassword])) return ShowRegInput2(playerid, 2);
            return CreateAccountAfterReg(playerid);
        }
        case DLG_LOGIN:
        {
            if(!response) return SendClientMessage(playerid, CH_R, !""CLINE"�� ����� � �������."), KickEx(playerid);
            if(isnull(inputtext)) return ShowLogin(playerid, 1);
            SHA256_PassHash(inputtext, PI[playerid][pPasswordSalt], cline, 65);
            if(strcmp(cline, PI[playerid][pPasswordHash]))
            {
                if(++TI[playerid][tLoginAttempts] == 3)
                {
                    SPD(playerid, DLG_NONE, DSM, !""D_R"�� ���� ����������� �� �������",
                        !""C_W"�� ��������� ��� ������� ����� ������.\n\n\
                        "D_PRIM"�� ������ ��������� � ����������� ��� ���.",
                        !"�������", "");
                    return KickEx(playerid);
                }
                return ShowLogin(playerid, 2);
            }

            mysql_format(dbHandle, string, sizeof(string), "SELECT * FROM `accounts` WHERE `pID` = '%d' LIMIT 1", PI[playerid][pID]);
            return mysql_tquery(dbHandle, string, !"LoadPlayerAccount", !"d", playerid);
        }
    }
    return 1;
}

stock ShowRegInput(playerid, type = 0)
{
    string =
        ""C_W"������� ������ ��� ������ ��������\n\n\
        ����������:\n\
        "D_PRIM"����� ������ ����� ���������� �� "C_CON"6"C_W"-�� �� "C_CON"32"C_W"-� ��������.\n\
        "D_PRIM"������ ����� ��������� ������� �������� � ��������� � ������� � ������ ��������.\n\
        "D_PRIM"������ ����� ��������� �����.\n\
        "D_PRIM"������ ����� ��������� ����� ����. ������� ��� "C_CON"! @ $ * _ - + = . , ? /\n\
        "D_PRIM"�� ������� ������ ����� �������, �� ����������� ���� ������� ����� ������.";
    
    switch(type)
    {
        case 1: strcat(string, "\n\n"D_PRIMR"�� �������� ���� ������.");
        case 2: strcat(string, "\n\n"D_PRIMR"����� ������ �� ������������� �����������.");
        case 3: strcat(string, "\n\n"D_PRIMR"������ �������� �� ���������� � ����������� �������.");
        case 4: strcat(string, "\n\n"D_PRIMR"������ ������ ��������� � ���� ����� �������, �������� ��� �������.");
    }
    return SPD(playerid, DLG_REGINPUT, DSI, type ? !""D_Y"����������� ��������" : !""D_G"����������� ��������", string, !"�����", !"�����");
}

stock ShowRegInput2(playerid, type = 0)
{
    string =
        ""C_W"����������� ��� ������, ����� ��� ��� ���.\n\n\
        "D_PRIM"�� ������ ������ �������� �������� ������, ����� \""C_CON"�����"C_W"\".";
    switch(type)
    {
        case 1: strcat(string, "\n\n"D_PRIMR"�� �������� ���� ������.");
        case 2: strcat(string, "\n\n"D_PRIMR"������ �� ���������.");
    }
    return SPD(playerid, DLG_REGINPUT2, DSI, type ? !""D_Y"����������� ��������" : !""D_G"����������� ��������", string, !"�����", !"�����");
}

/*stock login_OnGameModeInit()
{
    // ���������� ��������� ��� �������� ������
    PasswordRegex = Regex_New("^[A-Za-z0-9!@$*_-+=.,?/]+$");
    return 1;
}*/

stock IsEasyPassword(const password[])
{
    for(iter = 0; iter < sizeof(EasyPasswords); iter++)
    {
        if(!strcmp(password, EasyPasswords[iter], true)) return true;
    }
    return false;
}

stock IsValidPassword(const password[])
{
    for(iter = 0, len = strlen(password); iter < len; iter++)
    {
        switch(password[iter])
        {
            case '0'..'9', 'A'..'Z', 'a'..'z', '�'..'�', '�'..'�', '!', '@', '$', '*', '_', '-', '+', '=', '.', ',', '?', '/': continue;
            default: return false;
        }
    }
    return true;
}

stock CreateAccountAfterReg(playerid)
{
    GeneratePasswordSalt(PI[playerid][pPasswordSalt], 10);
    SHA256_PassHash(TI[playerid][tPassword], PI[playerid][pPasswordSalt], PI[playerid][pPasswordHash], 65);

    PI[playerid][pRegDate] = gettime();
    strcpy(PI[playerid][pRegIP], TI[playerid][tIP]);

    mysql_format(dbHandle, string, sizeof(string),
        "INSERT INTO `accounts` \
        (`pName`, `pPasswordHash`, `pPasswordSalt`, `pRegDate`, `pRegIP`) \
        VALUES ('%e', '%s', '%e', '%d', '%s')",
        PI[playerid][pName], PI[playerid][pPasswordHash], PI[playerid][pPasswordSalt], PI[playerid][pRegDate], PI[playerid][pRegIP]);
    mysql_tquery(dbHandle, string);
    mysql_format(dbHandle, string, sizeof(string), "SELECT `pID` FROM `accounts` WHERE `pName` = '%e' LIMIT 1", PI[playerid][pName]);
    return mysql_tquery(dbHandle, string, !"OnCreateAccountAfterReg", !"d", playerid);
}
CB:OnCreateAccountAfterReg(playerid)
{
    cache_get_value_name_int(0, !"pID", PI[playerid][pID]);
    printf("[PLAYER] ������� %s (%d) ��������������� � IP %s.", PI[playerid][pName], PI[playerid][pID], PI[playerid][pRegIP]);
    TogglePlayerSpectatingAC(playerid, false);
    TI[playerid][tLogin] = true;
    return PlayerSpawn(playerid, 1);
}

stock GeneratePasswordSalt(dest[], saltlen)
{
    dest[0] = EOS;
    for(iter = 0; iter < saltlen; iter++)
    {
        dest[iter] = 48+random(43);
    }
    return 1;
}

CB:LoadPlayerAccount(playerid)
{
    LoadPlayerVariables(playerid);
    TogglePlayerSpectatingAC(playerid, false);
    TI[playerid][tLogin] = true;
    // ������ �� ������� �����������
    foreach(new i:Player)
    {
        if(TI[i][tLogin]) continue;
        if(!strcmp(PI[i][pName], PI[playerid][pName], true))
        {
            SendClientMessage(i, CH_R, !""CLINE"���-�� ��� ������������� �� ������ ��������.");
            KickEx(i);
        }
    }
    return PlayerSpawn(playerid, 2);
}