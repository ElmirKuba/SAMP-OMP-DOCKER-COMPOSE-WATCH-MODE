/* Глобальное, настройки сервера */

enum E_SERVERSETTINGS
{
    E_SS_DMKILLPRIZE, // Вознаграждение $ за килл в ДМ зоне
    E_SS_DMROWKILLPRIZE, // Вознаграждение $ за 2+ килла подряд в ДМ зоне
}
new SS[E_SERVERSETTINGS] =
{
    100,
    125
};