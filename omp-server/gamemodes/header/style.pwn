/* ��������� ����� */

/* ��� ���� */
#define	CB:%0(%1)	forward %0(%1); public %0(%1)
#define SetCustomTimerEx(%0,%1,%2,%3,%4,%5) SetTimerEx(%0, %1, %2, %4, %5)
#define SetCustomTimer(%0,%1,%2,%3) SetTimer(%0, %1, %2)
#define DSM 			DIALOG_STYLE_MSGBOX
#define	DSI				DIALOG_STYLE_INPUT
#define	DSL				DIALOG_STYLE_LIST
#define	DSP				DIALOG_STYLE_PASSWORD
#define	DST				DIALOG_STYLE_TABLIST
#define	DSTH			DIALOG_STYLE_TABLIST_HEADERS

/* ��� ������� */

/* ����� */
// ����� ��� ������
#define	C_W "{EBEBEB}"
#define	CX_W 0xEBEBEBFF
// ��������� ���� � �������� � ����������
#define C_CON "{FFAD2A}"
#define CX_CON 0xFFAD2AFF
// ��������� ���� � �������� � ���������� ������
#define C_GCON C_G
#define CX_GCON CX_G
// ������
#define	C_G "{00A902}"
#define	CX_G 0x00A902FF
// Ƹ����
#define	C_Y "{ECC21F}"
#define	YD 0xECC21FFF
// �������
#define	C_R "{B30000}"
#define	CX_R 0xB30000FF
// ���������
#define	C_O "{FFAD2A}"
#define	CX_O 0xFFAD2AFF
// ������-������
#define	C_LG "{93C927}"
#define	CX_LG 0x93C927FF

/* ������� */
#define D_G ""C_G"|"C_W" " // ������ "�������" �������
#define D_Y ""C_Y"|"C_W" " // ������ ������������������ "������" �������
#define D_R ""C_R"|"C_W" " // ������ �������������� "��������" �������

#define D_PRIMR ""C_R">"C_W" " // ������������� ������������ ���������� � �������
#define D_PRIMY ""C_Y">"C_W" " // ��������������� ������������ ���������� � �������
#define D_PRIM ""C_CON"*"C_W" " // ���������� � �������

#define D_TH ""C_O"|"C_W" " // ������ ������ ��������� � ��������� ��������
#define D_LIST(%0) ""C_O"["%0"]"C_W" " // ������ ������ � ������ 

#define CLINE "|"C_W" " // ������ ��������� � ����

#define CH_G CX_G // ���� �������������� ���������
#define CH_Y CX_Y // ���� �������������� ���������
#define CH_R CX_R // ���� �������������� ���������