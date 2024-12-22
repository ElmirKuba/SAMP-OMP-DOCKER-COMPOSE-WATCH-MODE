/* Функции игрока */

stock KickEx(playerid) return SetCustomTimerEx(!"KickTimer", (GetPlayerPing(playerid) > 450 ? 500 : GetPlayerPing(playerid)+50), false, 1, !"d", playerid);
CB:KickTimer(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	return Kick(playerid);
}

stock PlayerSpawn(playerid, type = 0) // type = 1 - после регистрации, 2 - после авторизации
{
    if(1 <= type <= 2) SetPlayerName(playerid, PI[playerid][pName]);
    SpawnPlayer(playerid);
    return SetPlayerPosEx(playerid, 1479.287, -1617.184, 14.039, 180.0, 0, 0);
}

stock pfunc_OnPlayerSpawn(playerid)
{
    SetSpawnInfo(playerid,1,101,2043.195, -1402.992, 68.313, 90.0,0,0,0,0,0,0);
    return 1;
}

stock SetPlayerPosEx(playerid, Float:x, Float:y, Float:z, Float:a = -1.0, worldid = -1, interiorid = -1)
{
    if(a != -1.0) SetPlayerFacingAngle(playerid, a);
	if(worldid != -1) SetPlayerVirtualWorldAC(playerid, worldid);
	if(interiorid != -1) SetPlayerInterior(playerid, interiorid);
	SetPlayerPos(playerid, x, y, z);
	return SetCameraBehindPlayer(playerid);
}

stock SetPlayerVirtualWorldAC(playerid, worldid)
{
	TI[playerid][tWorld] = worldid;
	return SetPlayerVirtualWorld(playerid, worldid);
}

stock translate_OnPlayerText(playerid, const text[])
{
    // В случае ввода команды не на той раскладке
    static cmdtrans[33];
    if(text[0] == ',' || text[0] == '.' && text[1] != '.')
	{
		strcpy(cmdtrans, text);
		cmdtrans[0] = '/';
		if(PC_EmulateCommand(playerid, cmdtrans) != -1) return 1;
		for(iter = 1; iter< strlen(cmdtrans); iter++)
		{
			if(iter>= 32) break;
			switch(cmdtrans[iter])
			{
                // Если ввели на русском
				case 'й', 'Й': cmdtrans[iter] = 'q';
				case 'ц', 'Ц': cmdtrans[iter] = 'w';
				case 'у', 'У': cmdtrans[iter] = 'e';
				case 'к', 'К': cmdtrans[iter] = 'r';
				case 'е', 'Е': cmdtrans[iter] = 't';
				case 'н', 'Н': cmdtrans[iter] = 'y';
				case 'г', 'Г': cmdtrans[iter] = 'u';
				case 'ш', 'Ш': cmdtrans[iter] = 'i';
				case 'щ', 'Щ': cmdtrans[iter] = 'o';
				case 'з', 'З': cmdtrans[iter] = 'p';
				case 'ф', 'Ф': cmdtrans[iter] = 'a';
				case 'ы', 'Ы': cmdtrans[iter] = 's';
				case 'в', 'В': cmdtrans[iter] = 'd';
				case 'а', 'А': cmdtrans[iter] = 'f';
				case 'п', 'П': cmdtrans[iter] = 'g';
				case 'р', 'Р': cmdtrans[iter] = 'h';
				case 'о', 'О': cmdtrans[iter] = 'j';
				case 'л', 'Л': cmdtrans[iter] = 'k';
				case 'д', 'Д': cmdtrans[iter] = 'l';
				case 'я', 'Я': cmdtrans[iter] = 'z';
				case 'ч', 'Ч': cmdtrans[iter] = 'x';
				case 'с', 'С': cmdtrans[iter] = 'c';
				case 'м', 'М': cmdtrans[iter] = 'v';
				case 'и', 'И': cmdtrans[iter] = 'b';
				case 'т', 'Т': cmdtrans[iter] = 'n';
				case 'ь', 'Ь': cmdtrans[iter] = 'm';

                // Если ввели на английском
                case 'q', 'Q': cmdtrans[iter] = 'й';
                case 'w', 'W': cmdtrans[iter] = 'ц';
                case 'e', 'E': cmdtrans[iter] = 'у';
                case 'r', 'R': cmdtrans[iter] = 'к';
                case 't', 'T': cmdtrans[iter] = 'е';
                case 'y', 'Y': cmdtrans[iter] = 'н';
                case 'u', 'U': cmdtrans[iter] = 'г';
                case 'i', 'I': cmdtrans[iter] = 'ш';
                case 'o', 'O': cmdtrans[iter] = 'щ';
                case 'p', 'P': cmdtrans[iter] = 'з';
                case '[', '{': cmdtrans[iter] = 'х';
                case ']', '}': cmdtrans[iter] = 'ъ';
                case '`', '~': cmdtrans[iter] = 'ё';
                case 'a', 'A': cmdtrans[iter] = 'ф';
                case 's', 'S': cmdtrans[iter] = 'ы';
                case 'd', 'D': cmdtrans[iter] = 'в';
                case 'f', 'F': cmdtrans[iter] = 'а';
                case 'g', 'G': cmdtrans[iter] = 'п';
                case 'h', 'H': cmdtrans[iter] = 'р';
                case 'j', 'J': cmdtrans[iter] = 'о';
                case 'k', 'K': cmdtrans[iter] = 'л';
                case 'l', 'L': cmdtrans[iter] = 'д';
                case ';', ':': cmdtrans[iter] = 'ж';
                case '\'', '"': cmdtrans[iter] = 'э';
                case 'z', 'Z': cmdtrans[iter] = 'я';
                case 'x', 'X': cmdtrans[iter] = 'ч';
                case 'c', 'C': cmdtrans[iter] = 'с';
                case 'v', 'V': cmdtrans[iter] = 'м';
                case 'b', 'B': cmdtrans[iter] = 'и';
                case 'n', 'N': cmdtrans[iter] = 'т';
                case 'm', 'M': cmdtrans[iter] = 'ь';
                case ',', '<': cmdtrans[iter] = 'б';
                case '.', '>': cmdtrans[iter] = 'ю';
				case ' ': break;
			}
		}
		if(PC_EmulateCommand(playerid, cmdtrans) != -1) return 1;
	}
    return 0;
}

stock GivePlayerRating(playerid, rating)
{
	PI[playerid][pRating] += rating;
	return SetPlayerScore(playerid, PI[playerid][pRating]);
}

stock GivePlayerMoneyEx(playerid, money)
{
	PI[playerid][pMoney] += money;
	ResetPlayerMoney(playerid);
	return GivePlayerMoney(playerid, PI[playerid][pMoney]);
}

CMD:leave(playerid)
{
	return LeaveCMD(playerid);
}
alias:leave("exit", "выход", "выйти");

stock LeaveCMD(playerid)
{
	if(TI[playerid][tDMZone] != -1)
	{
		SetPlayerDMZone(playerid, -1);
		return PlayerSpawn(playerid);
	}
	return 1;
}

stock pfunc_OnPlayerDisconnect(playerid, reason)
{
	LeaveCMD(playerid);
	return 1;
}