// Регистрация/авторизация

// Анимация загрузочного экрана
enum E_LOADSCREEN
{
    Float:E_LOADSCREEN_POS_FROM[3],
    Float:E_LOADSCREEN_POS_TO[3],
    Float:E_LOADSCREEN_LOOK_FROM[3],
    Float:E_LOADSCREEN_LOOK_TO[3],
    E_LOADSCREEN_TIME
}
new LoadScreen[E_LOADSCREEN] = 
{
    {1210.031616, -2084.902832, 98.727317},
    {648.012390, -1224.568115, 57.718475},
    {1206.539672, -2081.380371, 98.096191},
    {643.868896, -1221.776489, 57.523212},
    8000
};
/*new LoadScreen[E_LOADSCREEN] = 
{
    {321.471069, -2100.709472, 19.811817},
    {502.023132, -1288.777221, 65.089767},
    {324.965118, -2097.157226, 19.394645},
    {502.918487, -1283.886230, 64.563713},
    8000
};*/

//new Regex:PasswordRegex;

// Список простейших паролей, запрещенных для установки игроками
new EasyPasswords[][] =
{
    "123456",
    "1234567",
    "12345678",
    "123456789",
    "1234567890",
    "abc123",
    "qwerty",
    "iloveyou",
    "tropiki",
    "password",
    "parol123",
    "password123",
    "aaaaaa",
    "asdfgh",
    "zxcvbn"
};