/* ������� ������ */

stock KickEx(playerid) return SetCustomTimerEx(!"KickTimer", (GetPlayerPing(playerid) > 450 ? 500 : GetPlayerPing(playerid)+50), false, 1, !"d", playerid);
CB:KickTimer(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	return Kick(playerid);
}

stock PlayerSpawn(playerid, type = 0) // type = 1 - ����� �����������, 2 - ����� �����������
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
    // � ������ ����� ������� �� �� ��� ���������
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
                // ���� ����� �� �������
				case '�', '�': cmdtrans[iter] = 'q';
				case '�', '�': cmdtrans[iter] = 'w';
				case '�', '�': cmdtrans[iter] = 'e';
				case '�', '�': cmdtrans[iter] = 'r';
				case '�', '�': cmdtrans[iter] = 't';
				case '�', '�': cmdtrans[iter] = 'y';
				case '�', '�': cmdtrans[iter] = 'u';
				case '�', '�': cmdtrans[iter] = 'i';
				case '�', '�': cmdtrans[iter] = 'o';
				case '�', '�': cmdtrans[iter] = 'p';
				case '�', '�': cmdtrans[iter] = 'a';
				case '�', '�': cmdtrans[iter] = 's';
				case '�', '�': cmdtrans[iter] = 'd';
				case '�', '�': cmdtrans[iter] = 'f';
				case '�', '�': cmdtrans[iter] = 'g';
				case '�', '�': cmdtrans[iter] = 'h';
				case '�', '�': cmdtrans[iter] = 'j';
				case '�', '�': cmdtrans[iter] = 'k';
				case '�', '�': cmdtrans[iter] = 'l';
				case '�', '�': cmdtrans[iter] = 'z';
				case '�', '�': cmdtrans[iter] = 'x';
				case '�', '�': cmdtrans[iter] = 'c';
				case '�', '�': cmdtrans[iter] = 'v';
				case '�', '�': cmdtrans[iter] = 'b';
				case '�', '�': cmdtrans[iter] = 'n';
				case '�', '�': cmdtrans[iter] = 'm';

                // ���� ����� �� ����������
                case 'q', 'Q': cmdtrans[iter] = '�';
                case 'w', 'W': cmdtrans[iter] = '�';
                case 'e', 'E': cmdtrans[iter] = '�';
                case 'r', 'R': cmdtrans[iter] = '�';
                case 't', 'T': cmdtrans[iter] = '�';
                case 'y', 'Y': cmdtrans[iter] = '�';
                case 'u', 'U': cmdtrans[iter] = '�';
                case 'i', 'I': cmdtrans[iter] = '�';
                case 'o', 'O': cmdtrans[iter] = '�';
                case 'p', 'P': cmdtrans[iter] = '�';
                case '[', '{': cmdtrans[iter] = '�';
                case ']', '}': cmdtrans[iter] = '�';
                case '`', '~': cmdtrans[iter] = '�';
                case 'a', 'A': cmdtrans[iter] = '�';
                case 's', 'S': cmdtrans[iter] = '�';
                case 'd', 'D': cmdtrans[iter] = '�';
                case 'f', 'F': cmdtrans[iter] = '�';
                case 'g', 'G': cmdtrans[iter] = '�';
                case 'h', 'H': cmdtrans[iter] = '�';
                case 'j', 'J': cmdtrans[iter] = '�';
                case 'k', 'K': cmdtrans[iter] = '�';
                case 'l', 'L': cmdtrans[iter] = '�';
                case ';', ':': cmdtrans[iter] = '�';
                case '\'', '"': cmdtrans[iter] = '�';
                case 'z', 'Z': cmdtrans[iter] = '�';
                case 'x', 'X': cmdtrans[iter] = '�';
                case 'c', 'C': cmdtrans[iter] = '�';
                case 'v', 'V': cmdtrans[iter] = '�';
                case 'b', 'B': cmdtrans[iter] = '�';
                case 'n', 'N': cmdtrans[iter] = '�';
                case 'm', 'M': cmdtrans[iter] = '�';
                case ',', '<': cmdtrans[iter] = '�';
                case '.', '>': cmdtrans[iter] = '�';
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
alias:leave("exit", "�����", "�����");

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