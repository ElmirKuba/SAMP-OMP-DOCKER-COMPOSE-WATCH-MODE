/*
 - by timmylich.
 - vk.com/timmylich
 - t.me/timmylich
*/

static russed[256];
stock ru_GameTextForPlayer(playerid, const format[], time, style)
{

    RusTD(format, russed);
    return GameTextForPlayer(playerid, russed, time, style);
}
#if defined _ALS_GameTextForPlayer
	#undef GameTextForPlayer
#else
	#define _ALS_GameTextForPlayer
#endif
#define GameTextForPlayer ru_GameTextForPlayer

stock ru_GameTextForAll(const format[], time, style)
{
    RusTD(format, russed);
    return GameTextForAll(russed, time, style);
}
#if defined _ALS_GameTextForAll
	#undef GameTextForAll
#else
	#define _ALS_GameTextForAll
#endif
#define GameTextForAll ru_GameTextForAll

stock RusTD(const textdraw[], dest[])
{
    static rusi, rusj;
	strcpy(dest, textdraw, 512);
	for(rusi = 0, rusj = strlen(dest); rusi < rusj; rusi++)
	{
		switch(dest[rusi])
		{
	          case '�':dest[rusi] = 'a';
		      case '�':dest[rusi] = 'A';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = 'e';
		      case '�':dest[rusi] = 'E';
		      case '�':dest[rusi] = 'e';
		      case '�':dest[rusi] = 'E';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = 'k';
		      case '�':dest[rusi] = 'K';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = 'M';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = 'H';
		      case '�':dest[rusi] = 'o';
		      case '�':dest[rusi] = 'O';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = 'p';
		      case '�':dest[rusi] = 'P';
		      case '�':dest[rusi] = 'c';
		      case '�':dest[rusi] = 'C';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = 'y';
		      case '�':dest[rusi] = 'Y';
		      //case '�':dest[rusi] = '?';
		      case '�', '�':dest[rusi] = '�';
		      case '�':dest[rusi] = 'x';
		      case '�':dest[rusi] = 'X';
		      //case '�':dest[rusi] = '$';
		      case '�', '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		      case '�':dest[rusi] = '�';
		}
	}
	return 1;
}