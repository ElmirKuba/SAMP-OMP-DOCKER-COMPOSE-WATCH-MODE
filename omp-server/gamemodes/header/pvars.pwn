/* ���������� ������ */

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

    pSettingsTDLanguage, // ���� GameText � TextDraw, 0 - ����, 1 - ���
}
new PI[MAX_PLAYERS][E_PLAYER_INFO];

enum E_TEMP_PLAYER_INFO
{
    bool:tSpec, // ��������� �� � ������ ������
    tDialogID, // ID ��������� ����������� ����
    tIP[16],
    tPassword[33], // ������ ��� �����
    tLogin, // ����������� �� �����
    tLoginAttempts, // ������� ����� ������
    tDMZone,
    tDMZoneTime,
    tWorld,
    Float:tHP,
    tDeathState, // ��������� ������, 1 = ���� � �� ����
    tWeapons[13], // ������ � ����� �� ������
}
new TI[MAX_PLAYERS][E_TEMP_PLAYER_INFO];

new SecondUpdateTimerID[MAX_PLAYERS];