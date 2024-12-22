/* Переменные игрока */

enum E_PLAYER_INFO
{
    pID,
    pName[MAX_PLAYER_NAME+1],
    pPasswordHash[65],
    pPasswordSalt[11],
    pRegDate,
    pRegIP[16],
    pLastDate,
    pLastIP[16],
    pRating,
    pMoney,
    pKills,
    pDeaths,

    pSettingsTDLanguage, // Язык GameText и TextDraw, 0 - англ, 1 - рус
}
new PI[MAX_PLAYERS][E_PLAYER_INFO];

enum E_TEMP_PLAYER_INFO
{
    bool:tSpec, // Находится ли в режиме слежки
    tDialogID, // ID открытого диалогового окна
    tIP[16],
    tPassword[33], // Пароль при вводе
    tLogin, // Авторизован ли игрок
    tLoginAttempts, // Попытки ввода пароля
    tDMZone,
    tDMZoneTime,
    tWorld,
    Float:tHP,
    tDeathState, // Состояние смерти, 1 = убит в дм зоне
    tWeapons[13], // Оружие в руках по слотам
}
new TI[MAX_PLAYERS][E_TEMP_PLAYER_INFO];

new SecondUpdateTimerID[MAX_PLAYERS];