/* Диалоговые окна */

stock SPD(playerid, dialogid, style, const caption[], const info[], const button1[], const button2[])
{
    TI[playerid][tDialogID] = dialogid;
    return ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
}