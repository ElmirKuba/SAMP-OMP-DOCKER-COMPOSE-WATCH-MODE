/* Анти-чит */

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
    "#0 - Неизвестно",
    "#1 - Обход системы"
};

new tAC_TPTime[MAX_PLAYERS]; // Тик до которого будет длиться иммунитет от античита после телепортации