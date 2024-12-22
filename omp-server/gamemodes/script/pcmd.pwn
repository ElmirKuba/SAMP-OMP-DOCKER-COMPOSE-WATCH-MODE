/* Команды игрока */

CMD:tpc(playerid, params[])
{
    static Float:tpcx, Float:tpcy, Float:tpcz;
    if(sscanf(params, !"fff", tpcx, tpcy, tpcz) && sscanf(params, !"p<,>fff", tpcx, tpcy, tpcz)) return 1;
    printf("tpc %f %f %f", tpcx, tpcy, tpcz);
	return SetPlayerPosEx(playerid, tpcx, tpcy, tpcz);
}