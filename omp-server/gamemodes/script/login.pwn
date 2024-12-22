// Регистрация/авторизация

// Анимация загрузочного экрана
stock SetPlayerLoadScreen(playerid, type = 1) // type = 1 - с анимацией, 0 - без анимации
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
			""C_W"Нельзя создать аккаунт с ник-неймом "C_CON"%s"C_W".\n\n\
            "D_PRIM"В нём обнаружена частица "C_CON"Logging_Player_"C_W", использующаяся в системе безопасности.",
			PI[playerid][pName]);
		SPD(playerid, DLG_NONE, DSM, !""D_R"Запрещенные детали в ник-нейме", string, !"Понятно", "");
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
         ""C_W"Добро пожаловать на "C_CON""ProjectName""C_W"!\n\
        Аккаунт с ник-неймом "C_CON"%s "C_GCON"зарегистрирован"C_W".\n\n\
        "D_PRIM"Введите пароль для того, чтобы авторизоваться.",
        PI[playerid][pName]);

    switch(type)
    {
        case 1: strcat(string, "\n\n"D_PRIMR"Вы оставили поле пустым.");
        case 2:
        {
            if(TI[playerid][tLoginAttempts] == 1) strcat(string, "\n\n"D_PRIMY"Пароль неверный, осталось "C_CON"2"C_W" попытки.");
            else strcat(string, "\n\n"D_PRIMY"Пароль неверный, осталась последняя попытка.");
        }
    }
    return SPD(playerid, DLG_LOGIN, DSP, type ? !""D_Y"Авторизация" : !""D_G"Авторизация", string, !"Далее", !"Выход");
}

stock ShowReg(playerid)
{
    format(string, sizeof(string),
        ""C_W"Добро пожаловать на "C_CON""ProjectName""C_W"!\n\
        Аккаунт с ник-неймом "C_CON"%s "C_GCON"не зарегистрирован"C_W".\n\n\
        "D_PRIM"Для регистрации аккаунта нажмите \""C_CON"Далее"C_W"\"",
        PI[playerid][pName]);
    return SPD(playerid, DLG_REG, DSM, !""D_G"Добро пожаловать!", string, !"Далее", !"Выход");
}

stock login_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[])
{
    #pragma unused listitem
    switch(dialogid)
    {
        case DLG_REG:
        {
            if(!response) return SendClientMessage(playerid, CH_R, !""CLINE"Вы вышли с сервера."), KickEx(playerid);
            return ShowRegInput(playerid);
        }
        case DLG_REGINPUT:
        {
            if(!response) return SendClientMessage(playerid, CH_R, !""CLINE"Вы вышли с сервера."), KickEx(playerid);
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
            if(!response) return SendClientMessage(playerid, CH_R, !""CLINE"Вы вышли с сервера."), KickEx(playerid);
            if(isnull(inputtext)) return ShowLogin(playerid, 1);
            SHA256_PassHash(inputtext, PI[playerid][pPasswordSalt], cline, 65);
            if(strcmp(cline, PI[playerid][pPasswordHash]))
            {
                if(++TI[playerid][tLoginAttempts] == 3)
                {
                    SPD(playerid, DLG_NONE, DSM, !""D_R"Вы были отсоединены от сервера",
                        !""C_W"Вы исчерпали все попытки ввода пароля.\n\n\
                        "D_PRIM"Вы можете перезайти и попробовать ещё раз.",
                        !"Понятно", "");
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
        ""C_W"Введите пароль для вашего аккаунта\n\n\
        Примечание:\n\
        "D_PRIM"Длина пароля может составлять от "C_CON"6"C_W"-ти до "C_CON"32"C_W"-х символов.\n\
        "D_PRIM"Пароль может содержать символы латиницы и кириллицы в верхнем и нижнем регистре.\n\
        "D_PRIM"Пароль может содержать цифры.\n\
        "D_PRIM"Пароль может содержать такие спец. символы как "C_CON"! @ $ * _ - + = . , ? /\n\
        "D_PRIM"Не делайте пароль очень простым, вы подвергаете свой аккаунт риску взлома.";
    
    switch(type)
    {
        case 1: strcat(string, "\n\n"D_PRIMR"Вы оставили поле пустым.");
        case 2: strcat(string, "\n\n"D_PRIMR"Длина пароля не соответствует требованиям.");
        case 3: strcat(string, "\n\n"D_PRIMR"Пароль содержит не упомянутые в требованиях символы.");
        case 4: strcat(string, "\n\n"D_PRIMR"Данный пароль находится в базе очень простых, сделайте его сложнее.");
    }
    return SPD(playerid, DLG_REGINPUT, DSI, type ? !""D_Y"Регистрация аккаунта" : !""D_G"Регистрация аккаунта", string, !"Далее", !"Выход");
}

stock ShowRegInput2(playerid, type = 0)
{
    string =
        ""C_W"Подтвердите ваш пароль, введя его ещё раз.\n\n\
        "D_PRIM"Вы можете ввести изменить введённый пароль, нажав \""C_CON"Назад"C_W"\".";
    switch(type)
    {
        case 1: strcat(string, "\n\n"D_PRIMR"Вы оставили поле пустым.");
        case 2: strcat(string, "\n\n"D_PRIMR"Пароли не совпадают.");
    }
    return SPD(playerid, DLG_REGINPUT2, DSI, type ? !""D_Y"Регистрация аккаунта" : !""D_G"Регистрация аккаунта", string, !"Далее", !"Назад");
}

/*stock login_OnGameModeInit()
{
    // Регулярное выражение для проверки пароля
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
            case '0'..'9', 'A'..'Z', 'a'..'z', 'а'..'я', 'А'..'Я', '!', '@', '$', '*', '_', '-', '+', '=', '.', ',', '?', '/': continue;
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
    printf("[PLAYER] Аккаунт %s (%d) зарегистрирован с IP %s.", PI[playerid][pName], PI[playerid][pID], PI[playerid][pRegIP]);
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
    // Защита от двойной авторизации
    foreach(new i:Player)
    {
        if(TI[i][tLogin]) continue;
        if(!strcmp(PI[i][pName], PI[playerid][pName], true))
        {
            SendClientMessage(i, CH_R, !""CLINE"Кто-то уже авторизовался на данном аккаунте.");
            KickEx(i);
        }
    }
    return PlayerSpawn(playerid, 2);
}