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
	          case 'à':dest[rusi] = 'a';
		      case 'À':dest[rusi] = 'A';
		      case 'á':dest[rusi] = '—';
		      case 'Á':dest[rusi] = '€';
		      case 'â':dest[rusi] = '¢';
		      case 'Â':dest[rusi] = '‹';
		      case 'ã':dest[rusi] = '™';
		      case 'Ã':dest[rusi] = '‚';
		      case 'ä':dest[rusi] = 'š';
		      case 'Ä':dest[rusi] = 'ƒ';
		      case 'å':dest[rusi] = 'e';
		      case 'Å':dest[rusi] = 'E';
		      case '¸':dest[rusi] = 'e';
		      case '¨':dest[rusi] = 'E';
		      case 'æ':dest[rusi] = '›';
		      case 'Æ':dest[rusi] = '„';
		      case 'ç':dest[rusi] = 'Ÿ';
		      case 'Ç':dest[rusi] = 'ˆ';
		      case 'è':dest[rusi] = 'œ';
		      case 'È':dest[rusi] = '…';
		      case 'é':dest[rusi] = '';
		      case 'É':dest[rusi] = '…';
		      case 'ê':dest[rusi] = 'k';
		      case 'Ê':dest[rusi] = 'K';
		      case 'ë':dest[rusi] = 'ž';
		      case 'Ë':dest[rusi] = '‡';
		      case 'ì':dest[rusi] = '¯';
		      case 'Ì':dest[rusi] = 'M';
		      case 'í':dest[rusi] = '®';
		      case 'Í':dest[rusi] = 'H';
		      case 'î':dest[rusi] = 'o';
		      case 'Î':dest[rusi] = 'O';
		      case 'ï':dest[rusi] = '£';
		      case 'Ï':dest[rusi] = 'Œ';
		      case 'ð':dest[rusi] = 'p';
		      case 'Ð':dest[rusi] = 'P';
		      case 'ñ':dest[rusi] = 'c';
		      case 'Ñ':dest[rusi] = 'C';
		      case 'ò':dest[rusi] = '¦';
		      case 'Ò':dest[rusi] = '';
		      case 'ó':dest[rusi] = 'y';
		      case 'Ó':dest[rusi] = 'Y';
		      //case 'ô':dest[rusi] = '?';
		      case 'Ô', 'ô':dest[rusi] = '';
		      case 'õ':dest[rusi] = 'x';
		      case 'Õ':dest[rusi] = 'X';
		      //case 'ö':dest[rusi] = '$';
		      case 'Ö', 'ö':dest[rusi] = '‰';
		      case '÷':dest[rusi] = '¤';
		      case '×':dest[rusi] = '';
		      case 'ø':dest[rusi] = '¥';
		      case 'Ø':dest[rusi] = 'Ž';
		      case 'ù':dest[rusi] = '¡';
		      case 'Ù':dest[rusi] = 'Š';
		      case 'ü':dest[rusi] = '©';
		      case 'Ü':dest[rusi] = '’';
		      case 'ú':dest[rusi] = '';
		      case 'Ú':dest[rusi] = '§';
		      case 'û':dest[rusi] = '¨';
		      case 'Û':dest[rusi] = '‘';
		      case 'ý':dest[rusi] = 'ª';
		      case 'Ý':dest[rusi] = '“';
		      case 'þ':dest[rusi] = '«';
		      case 'Þ':dest[rusi] = '”';
		      case 'ÿ':dest[rusi] = '¬';
		      case 'ß':dest[rusi] = '•';
		}
	}
	return 1;
}