/* ����-��� */

enum
{
    AC_UNKNOWN,
    AC_BYPASS,
}

enum E_AC_INFO
{
    E_AC_NAME[65],
}
new AC[][E_AC_NAME] =
{
    "#0 - ����������",
    "#1 - ����� �������"
};

new tAC_TPTime[MAX_PLAYERS]; // ��� �� �������� ����� ������� ��������� �� �������� ����� ������������