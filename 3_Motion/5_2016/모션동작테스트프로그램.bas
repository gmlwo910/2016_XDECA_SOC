
'****************************************
'***** 메탈파이터 기초 프로그램 *******
'****************************************

'******* 변수선언 ***********************
DIM A AS BYTE
DIM I AS BYTE
DIM A_old AS BYTE
DIM X AS BYTE
DIM Y AS BYTE
DIM 보행순서 AS BYTE
DIM ONE AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE

'**** 기울기센서포트 설정

CONST 앞뒤기울기AD포트 = 2
CONST 좌우기울기AD포트 = 3

'*****  2012년 이전 센서 ****
'CONST 기울기확인시간 = 10  'ms
'CONST min = 100			'뒤로넘어졌을때
'CONST max = 160			'앞으로넘어졌을때
'CONST COUNT_MAX = 30
'

'**** 2012년 사용 센서 *****
CONST 기울기확인시간 = 5  'ms
CONST MIN = 61			'뒤로넘어졌을때
CONST MAX = 107			'앞으로넘어졌을때
CONST COUNT_MAX = 20

'*******************

'*******모터방향설정*********************
DIR G6A,1,0,0,1,0,0	'왼쪽다리:모터0~5번
DIR G6D,0,1,1,0,1,0	'오른쪽다리:모터18~23번
DIR G6B,1,1,1,1,1,1	'왼쪽팔:모터6~11번
DIR G6C,0,0,0,0,0,0	'오른쪽팔:모터12~17번


'*******모터동시제어설정****************
PTP SETON 		'단위그룹별 점대점동작 설정
PTP ALLON		'전체모터 점대점 동작 설정

'*******모터위치값피드백****************
GOSUB MOTOR_GET

'*******모터사용설정********************
GOSUB MOTOR_ON

'*******피에조소리내기******************
TEMPO 220
MUSIC "O23EAB7EA>3#C"
'***** 초기자세로 **********************
SPEED 5
GOSUB 기본자세


ONE = 1

'***** 메인 반복루틴 **************
MAIN:

    IF ONE=1 THEN
        'GOTO 오른쪽턴45
        GOTO 왼쪽턴45
        ' GOTO 전진달리기50
        'GOTO 앞으로덤블링2
        'GOTO 기어가기
        'GOTO 계단오른발오르기1cm
        'GOTO 기어서올라가기
        'GOTO 허들넘기
        'GOTO 전진보행50
        'GOTO 전진종종걸음
        'GOTO 계단왼발내리기3cm
        'GOTO 전진달리기최종
    ENDIF


    GOTO MAIN
    '************************************************
    '******************************************
왼쪽턴45:
    '조금부족
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,96,  115, 145,  53, 105, 100
    MOVE G6D,96,  38,  148,  129, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,94,  115, 145,  53, 105, 100
    MOVE G6D,94,  38,  148,  129, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세2

    GOSUB Leg_motor_mode1
    DELAY 1000
    GOTO RX_EXIT



전진종종걸음:
    '    넘어진확인 = 0

    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    '    IF 보행순서 = 0 THEN
    '        보행순서 = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    MOVE G6B,100,  35
    MOVE G6C,100,  35
    WAIT

    '        GOTO 전진종종걸음_1
    '    ELSE
    '        보행순서 = 0
    '        MOVE G6D,95,  76, 145,  93, 101
    '        MOVE G6A,101,  77, 145,  93, 98
    '        MOVE G6B,100,  35
    '        MOVE G6C,100,  35
    '        WAIT

    '       GOTO 전진종종걸음_4
    '    ENDIF


    '**********************
    FOR I = 0 TO 100
전진종종걸음_1:
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


전진종종걸음_2:
        MOVE G6A,95,  85, 130, 103, 104
        MOVE G6D,104,  79, 146,  89,  100
        WAIT

전진종종걸음_3:
        MOVE G6A,103,   85, 130, 103,  100
        MOVE G6D, 95,  79, 146,  89, 102
        WAIT

        '    GOSUB 앞뒤기울기측정
        '    IF 넘어진확인 = 1 THEN
        '        넘어진확인 = 0
        '        GOTO MAIN
        '    ENDIF
        '
        '    ERX 4800,A, 전진종종걸음_4
        '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

        '*********************************

전진종종걸음_4:
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


전진종종걸음_5:
        MOVE G6D,95,  85, 130, 103, 104
        MOVE G6A,104,  79, 146,  89,  100
        WAIT

전진종종걸음_6:
        MOVE G6D,103,   85, 130, 103,  100
        MOVE G6A, 95,  79, 146,  89, 102
        WAIT
    NEXT I
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, 전진종종걸음_1
    '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

전진종종걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    보행순서=0
    GOTO MAIN

    '******************************************
왼쪽턴10:

    SPEED 5
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세
    보행순서=0
    GOTO MAIN

    '왼쪽턴20:
    ' FOR I = 0 TO 5
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    'NEXT I
    GOSUB 기본자세
    DELAY 2000
    GOSUB Leg_motor_mode1
    보행순서=0
    GOTO MAIN

왼쪽옆으로20:


    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 104, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세
    보행순서=0
    GOTO MAIN

왼쪽옆으로70: 'USE


    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6A, 102,  76, 147, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 10
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15	
    GOSUB 기본자세
    보행순서=0
    GOTO MAIN
오른쪽턴45: 'USE

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6C,115
    MOVE G6B,85
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    보행순서=0
    GOTO MAIN
오른쪽턴20:

    GOSUB Leg_motor_mode2
    FOR I = 0 TO 6
        SPEED 8
        MOVE G6A,95,  56, 145,  113, 105, 100
        MOVE G6D,95,  96, 145,  73, 105, 100
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        SPEED 12
        MOVE G6A,93,  56, 145,  113, 105, 100
        MOVE G6D,93,  96, 145,  73, 105, 100
        WAIT

        SPEED 6
        MOVE G6A,101,  76, 146,  93, 98, 100
        MOVE G6D,101,  76, 146,  93, 98, 100
        MOVE G6B,100,  30,  80
        MOVE G6C,100,  30,  80
        WAIT
    NEXT I
    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    보행순서=0
    GOTO MAIN

전진달리기50:

    SPEED 30
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  78, 145,  93, 98
        MOVE G6B,100,  30,  80,    , 100, 100
        MOVE G6C,100,  30,  80, 100, 135, 100
        WAIT
        GOTO 전진달리기50_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  78, 145,  93, 98
        MOVE G6C,100,  30,  80, 100, 135, 100
        MOVE G6B,100,  30,  80,    , 100, 100
        WAIT
        GOTO 전진달리기50_4
    ENDIF


    '**********************
전진달리기50_1:

    FOR I = 0 TO 2

        MOVE G6A,95,  95, 100, 120, 101
        MOVE G6D,106, 88, 136,  91, 105
        MOVE G6B, 80
        MOVE G6C,120
        WAIT
        '   GOTO 전진달리기50_2
        '전진달리기50_2:
        MOVE G6A,95,  75, 122, 120, 101
        MOVE G6D,106, 78, 146,  91, 105
        WAIT
        '    GOTO 전진달리기50_3
        '전진달리기50_3:
        MOVE G6A,103, 70, 145, 103, 100
        MOVE G6D, 97, 88, 160,  68, 102
        WAIT

        MOVE G6D,95,  88, 100, 120, 101
        MOVE G6A,108, 78, 146,  91, 105
        MOVE G6C, 80
        MOVE G6B,120
        WAIT
        '   GOTO 전진달리기50_5
        '전진달리기50_5:
        MOVE G6D,95,  75, 122, 120, 101
        MOVE G6A,108, 80, 146,  91, 105
        WAIT
        '    GOTO 전진달리기50_6
        '전진달리기50_6:
        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT

    NEXT I

    GOTO 전진달리기50_멈춤

전진달리기50_4:

    FOR I = 0 TO 2

        MOVE G6D,95,  95, 100, 120, 101
        MOVE G6A,106, 88, 136,  91, 105
        MOVE G6C, 80
        MOVE G6B,120
        WAIT
        '   GOTO 전진달리기50_2
        '전진달리기50_2:
        MOVE G6D,95,  75, 122, 120, 101
        MOVE G6A,106, 78, 146,  91, 105
        WAIT
        '    GOTO 전진달리기50_3
        '전진달리기50_3:
        MOVE G6D,103, 70, 145, 103, 100
        MOVE G6A, 97, 88, 160,  68, 102
        WAIT

        MOVE G6A,95,  88, 100, 120, 101
        MOVE G6D,108, 78, 146,  91, 105
        MOVE G6B, 80
        MOVE G6C,120
        WAIT
        '   GOTO 전진달리기50_5
        '전진달리기50_5:
        MOVE G6A,95,  75, 122, 120, 101
        MOVE G6D,108, 80, 146,  91, 105
        WAIT
        '    GOTO 전진달리기50_6
        '전진달리기50_6:
        MOVE G6A,104, 70, 145, 103, 100
        MOVE G6D, 94, 88, 160,  68, 102
        WAIT

    NEXT I

    GOTO 전진달리기50_멈춤

전진달리기50_멈춤:
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB 안정화자세
    SPEED 6
    GOSUB 기본자세

    DELAY 500

    GOSUB Leg_motor_mode1
    GOTO MAIN

    '******************************************
허들넘기: 'USE

    SPEED 15
    MOVE G6B, 190, 100, 100
    MOVE G6C, 190, 100, 100
    WAIT

    SPEED 12
    MOVE G6B, 190, 10, 100
    MOVE G6C, 190, 10, 100
    WAIT

    'SPEED 12
    'MOVE G6A, 100,  76, 145,  93, 100, 100
    'MOVE G6D, 100,  76, 145,  93, 100, 100
    'MOVE G6B, 190,  10,  100
    'MOVE G6C, 190,  10,  100
    'WAIT

    SPEED 7
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  76, 145,  130, 100, 100
    MOVE G6B, 190,  10,  80 , 100, 100
    MOVE G6C, 190,  10,  80 , 100, 190
    WAIT
    '=------------------------------------------
    SPEED 7
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  76, 145,  130, 100, 100
    MOVE G6B, 155,  20,  85
    MOVE G6C, 155,  20,  85
    WAIT

    SPEED 7
    MOVE G6A,100,  100, 95,  10, 100, 100
    MOVE G6D,100,  100, 95,  10, 100, 100
    MOVE G6B, 155,  20,  85
    MOVE G6C, 155,  20,  85
    WAIT


    '-------------------------------------
    SPEED 7
    MOVE G6A,100,  10, 55,  140, 100, 100
    MOVE G6D,100,  10, 55,  140, 100, 100
    MOVE G6B, 100,  30,  80
    MOVE G6C, 100,  30,  80, 100, 100
    WAIT

    SPEED 7
    MOVE G6A,100,  10, 55,  140, 100, 100
    MOVE G6D,100,  10, 55,  140, 100, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT

    SPEED 7
    MOVE G6A,100,  10, 55,  140, 190, 100
    MOVE G6D,100,  10, 55,  140, 190, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT

    SPEED 7
    MOVE G6A,100,  60, 55,  140, 190, 100
    MOVE G6D,100,  60, 55,  140, 190, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT

    SPEED 7
    MOVE G6A,100,  60, 55,  140, 100, 100
    MOVE G6D,100,  60, 55,  140, 100, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT



    '--------------------------------------------
    SPEED 12
    MOVE G6A,100, 150, 170,  40, 100
    MOVE G6D,100, 150, 170,  40, 100
    MOVE G6B, 150, 150,  45
    MOVE G6C, 150, 150,  45
    WAIT

    SPEED 12
    MOVE G6A,  100, 155,  110, 120, 100
    MOVE G6D,  100, 155,  110, 120, 100
    MOVE G6B, 190, 80,  15
    MOVE G6C, 190, 80,  15
    WAIT

    SPEED 12
    MOVE G6A,  100, 165,  25, 162, 100
    MOVE G6D,  100, 165,  25, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '-------------- 일어나기 -----------------
    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,160,  32, 70, 100, 100, 100
    MOVE G6C,160,  32, 70, 100, 100, 100
    WAIT


    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT
    '''''''''''''''''''''''''

    '---------------'추가분'-----------------
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    SPEED 10
    MOVE G6A,100, 130,  48, 136, 100, 100
    MOVE G6D,100, 130,  48, 136, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT


    '---------------------------------------

    SPEED 10
    GOSUB 기본자세
    보행순서=0
    GOTO MAIN

기어가기:

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5	
    MOVE G6A, 100, 155,  57, 160, 100, 100'
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,186,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    DELAY 300

    SPEED 6
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON

    'GOTO 기어가기왼쪽턴_LOOP

기어가기_LOOP:


    MOVE G6A, 100, 160,  55, 160, 100
    MOVE G6D, 100, 145,  75, 160, 100
    MOVE G6B, 175,  25,  70
    MOVE G6C, 190,  50,  40
    WAIT
    '    ERX 4800, A, 기어가기_1
    '    IF A = 8 THEN GOTO 기어가기_1
    '   IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    '  IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    'GOTO 기어가다일어나기

기어가기_1:
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  25,  70
    MOVE G6C, 190,  25,  70
    WAIT

    MOVE G6D, 100, 160,  55, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 180,  25,  70
    MOVE G6B, 190,  50,  40
    WAIT

    'ERX 4800, A, 기어가기_2
    ' IF A = 8 THEN GOTO 기어가기_2
    'IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    'IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    'GOTO 기어가다일어나기

기어가기_2:
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 170,  25,  70
    MOVE G6B, 190,  25,  70
    WAIT

    GOTO 기어가기_LOOP

계단오른발오르기1cm: 'UPSTAIR GREEN COMPLETE
    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,105,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D, 93, 140, 35, 130, 114
    MOVE G6A,113,  71, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6D,  80, 55, 130, 140, 114,
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6D, 105, 75, 100, 152, 102,
    MOVE G6A,95,  93, 160,  70, 102
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 110, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 102
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 110, 90, 100, 150,95,
    MOVE G6A,93,  90, 165,  70, 107
    WAIT

    SPEED 12
    MOVE G6D, 110, 90, 100, 150,95,
    MOVE G6A,88,  120, 40,  140, 110
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,88,  95, 90,  145, 110
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 110
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6A, 98, 90, 110, 125,101,
    MOVE G6D,98,  90, 110,  125,101,
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    GOSUB 기본자세
    ONE=0
    GOTO MAIN

기어서올라가기: 'UPSTAIR RED

    SPEED 15
    MOVE G6B, 190, 100, 100
    MOVE G6C, 190, 100, 100
    WAIT

    SPEED 12
    MOVE G6B, 190, 10, 100
    MOVE G6C, 190, 10, 100
    WAIT

    SPEED 12
    MOVE G6A, 100,  76, 145,  93, 100, 100
    MOVE G6D, 100,  76, 145,  93, 100, 100
    MOVE G6B, 190,  10,  100
    MOVE G6C, 190,  10,  100
    WAIT

    SPEED 5
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  76, 145,  130, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  76, 90,  130, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT


    SPEED 8
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  141, 90,  130, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  76, 90,  130, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  141, 90,  130, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  141, 90,  155, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    '기어가기
    GOSUB Leg_motor_mode3


    SPEED 5	
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    DELAY 300

    SPEED 6
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON
    '기어가기_LOOP

    FOR I = 0 TO 5
        MOVE G6D, 100, 160,  55, 160, 100
        MOVE G6A, 100, 145,  75, 160, 100
        MOVE G6C, 175,  25,  70
        MOVE G6B, 190,  50,  40
        WAIT

        '기어가기_2

        MOVE G6D, 100, 140,  80, 160, 100
        MOVE G6A, 100, 140, 120, 120, 100
        MOVE G6C, 160,  25,  70
        MOVE G6B, 190,  25,  70
        WAIT

        MOVE G6A, 100, 160,  55, 160, 100
        MOVE G6D, 100, 145,  75, 160, 100
        MOVE G6B, 175,  25,  70
        MOVE G6C, 190,  50,  40
        WAIT
        '기어가기_1
        MOVE G6A, 100, 150,  70, 160, 100
        MOVE G6D, 100, 140, 120, 120, 100
        MOVE G6B, 160,  25,  70
        MOVE G6C, 190,  25,  70
        WAIT


    NEXT I
    '	기어가다일어나기:

    PTP SETON		
    PTP ALLON
    SPEED 15
    HIGHSPEED SETOFF


    MOVE G6A, 100, 150,  80, 150, 100
    MOVE G6D, 100, 150,  80, 150, 100
    MOVE G6B,185,  40, 60
    MOVE G6C,185,  40, 60
    WAIT

    GOSUB Leg_motor_mode3
    DELAY 300


    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT

    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10

    GOSUB 기본자세
    보행순서=0
    GOTO MAIN
계단왼발내리기3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,111,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,111,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,111,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 20, 150, 150, 110
    MOVE G6D,110,  155, 35,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    SPEED 5 ' add
    MOVE G6A,90, 20, 150, 150, 105
    MOVE G6D,110,  155, 55,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT
    '****************************

    SPEED 8
    MOVE G6A,100, 30, 150, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6A,108, 64, 132, 137, 94
    MOVE G6D,80,  125, 140,  85,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,110, 68, 130, 147, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

    SPEED 9
    MOVE G6A,110, 75, 130, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6A,110, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6D, , 80, 130, 105,99,
    MOVE G6A,100,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4

    GOSUB 기본자세
    ONE = 0
    GOTO MAIN




안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    RETURN
    '************************************************
    '************************************************
    '******************************************
    '***************************************

왼쪽턴45_1:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    MOVE G6B,115,,,,,190
    MOVE G6C,85,,,,128,100
    WAIT



    SPEED 10
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    MOVE G6B,115,,,,,190
    MOVE G6C,85,,,,128,100

    WAIT

    SPEED 8
    GOSUB 기본자세2
    GOSUB Leg_motor_mode1
    GOTO MAIN

전진보행50:
    'GOSUB SOUND_Walk_Ready
    보행속도 = 10'5
    좌우속도 = 5'8'3
    좌우속도2 = 4'5'2
    '넘어진확인 = 0
    GOSUB Leg_motor_mode3


    SPEED 4
    '오른쪽기울기
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  94
    MOVE G6B,100,35
    MOVE G6C,100,35
    WAIT

    SPEED 10'보행속도
    '왼발들기
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,111,  78, 146,  93,  95
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    '        GOTO 전진보행50_1



전진보행50_1:
    FOR I = 0 TO 10
        SPEED 보행속도
        '왼발뻣어착지
        MOVE G6A, 85,  44, 163, 113, 117
        MOVE G6D,108,  77, 146,  93,  92
        WAIT



        SPEED 좌우속도
        'GOSUB Leg_motor_mode3
        '왼발중심이동
        MOVE G6A,108,  76, 144, 100,  93
        MOVE G6D,85, 93, 155,  71, 112
        WAIT



        SPEED 보행속도
        'GOSUB Leg_motor_mode2
        '오른발들기10
        MOVE G6A,110,  77, 146,  93, 94
        MOVE G6D,90, 100, 105, 110, 114
        MOVE G6B,110
        MOVE G6C,90
        WAIT



전진보행50_2:


        SPEED 보행속도
        '오른발뻣어착지
        MOVE G6D,85,  44, 163, 113, 114
        MOVE G6A,110,  77, 146,  93,  94
        WAIT

        SPEED 좌우속도
        'GOSUB Leg_motor_mode3
        '오른발중심이동
        MOVE G6D,108,  76, 144, 100,  93
        MOVE G6A, 85, 93, 155,  71, 112
        WAIT


        SPEED 보행속도
        'GOSUB Leg_motor_mode2
        '왼발들기10
        MOVE G6A, 90, 100, 105, 110, 114
        MOVE G6D,110,  77, 146,  93,  94
        MOVE G6B, 90
        MOVE G6C,110
        WAIT
    NEXT I

    GOSUB 기본자세
    ONE=0
    GOTO MAIN


    '************************************************
    '************************************************



MOTOR_ON: '전포트서보모터사용설정
    MOTOR G24
    RETURN

    '***********************************
MOTOR_OFF: '전포트서보모터설정해제
    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    RETURN
    '***********************************
MOTOR_GET: '위치값피드백
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '*******기본자세관련*****************

기본자세:
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    RETURN


    '*************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 20, 90, 100, 100, 100
    MOVE G6C,100, 20, 90, 100, 100, 100
    WAIT
    RETURN
    '**************************************
앉은자세:

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    RETURN
    '***************************************

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    MOTORMODE G6B,1,1,1, , ,1
    MOTORMODE G6C,1,1,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2, , ,2
    MOTORMODE G6C,2,2,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1
    MOTORMODE G6C,1,1,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2
    MOTORMODE G6C,2,2,2
    RETURN
    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3
    MOTORMODE G6C,3,3,3
    RETURN

    '************************************************

RX_EXIT: '수신값을 버리는루틴	

    ERX 4800, A, MAIN

    GOTO RX_EXIT

    '************************************************
GYRO_INIT:
    GYRODIR G6A, 0, 0, 0, 0, 1
    GYRODIR G6D, 1, 0, 0, 0, 0
    RETURN
GYRO_ON:
    GYROSET G6A, 2, 1, 1, 1,
    GYROSET G6D, 2, 1, 1, 1,
    RETURN
GYRO_OFF:
    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0
    RETURN
GYRO_MAX:
    GYROSENSE G6A,255,255,255,255
    GYROSENSE G6D,255,255,255,255
    RETURN
GYRO_MID:
    GYROSENSE G6A,255,100,100,100
    GYROSENSE G6D,255,100,100,100
    RETURN
GYRO_MIN:
    GYROSENSE G6A,100,50,50,50,50
    GYROSENSE G6D,100,50,50,50,50
    RETURN
GYRO_ST:
    GYROSENSE G6A,100,30,20,10,
    GYROSENSE G6D,100,30,20,10 ,
    RETURN

기본자세2:
    MOVE G6A,100,  83, 137,  94, 100, 100
    MOVE G6D,100,  84, 137,  94, 100, 100
    MOVE G6B,100,  30,  80, 	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 155, 100
    WAIT

    RETURN
    '************************************************

왼쪽턴20:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세
    DELAY 2000
    GOSUB Leg_motor_mode1

    GOTO MAIN


전진달리기최종:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST
    SPEED 30
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    'IF 보행순서 = 0 THEN
    '    보행순서 = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,100,  78, 145,  93, 98
    WAIT

    '    GOTO 전진달리기50_1
    'ELSE
    '    보행순서 = 0
    '    MOVE G6D,95,  76, 145,  93, 101
    '    MOVE G6A,101,  78, 145,  93, 98
    '    WAIT

    '    GOTO 전진달리기50_4
    'ENDIF


    '**********************
    FOR I = 0 TO 4
전진달리기최종_1:
        MOVE G6A,96,  95, 100, 120, 104
        MOVE G6D,101, 78, 146,  91, 100
        MOVE G6B, 80
        MOVE G6C,120
        WAIT

전진달리기최종_2:
        MOVE G6A,96,  75, 122, 120, 104
        MOVE G6D,101, 80, 146,  89, 100
        WAIT

전진달리기최종_3:
        MOVE G6A,104, 70, 145, 103, 100
        MOVE G6D, 96, 88, 160,  68, 100
        WAIT

        'ERX 4800,A, 전진달리기50_4
        'IF A <> A_old THEN  GOTO 전진달리기50_멈춤

        '*********************************

전진달리기최종_4:
        MOVE G6D,96,  95, 100, 120, 104
        MOVE G6A,103, 78, 146,  91, 102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

전진달리기최종_5:
        MOVE G6D,96,  75, 122, 120, 104
        MOVE G6A,103, 80, 146,  89, 100
        WAIT

전진달리기최종_6:
        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT
    NEXT I



전진달리기최종_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    '보행순서=0
    GOSUB GYRO_OFF
    GOTO MAIN

