DATAS SEGMENT
    ;�˴��������ݶδ���
    students STRUCT			 ;ƫ���� 	 
	NAME DB 3+1 DUP('$')	 ;name:0-3
	grade DB ?			 ;grade:4
	MINGCI DB 1			 ;MINGCI:5
	students endS   ;�ṹ�干6���ֽ�
  
  	N EQU 3		;�ı�Nֵ���ɿ�������ѧ����Ϣ�ĸ���
	student_list students n dup(<>)
	jiange dd 10 dup(?)		;���������ʾ�ڵ��˵�
    WELCOME1	DB		'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\',13,10
    WELCOME2	DB		'|			student information system			|',13,10
    WELCOME3	DB		'|			1.add  student             			|',13,10
    WELCOME4	DB		'|			2.sort student            			|',13,10
    WELCOME5	DB		'|			3.find student            			|',13,10
    WELCOME6	DB		'|			4.exit                    			|',13,10
    WELCOME7	DB		'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\',13,10
    WELCOME8	DB	'select a feature:','$'
    WELCOME9	DB	'INPUT NAME: $'
    WELCOME10	DB	'INPUT	CJ: $'
    CHENG DB  10
    CHU DW 10
    STRING1 DB 'ERROR IMPUT!',13,10,'$'
    STRING2 DB 13,10,'$'
    STRING3 DB '	$'
    STRING4 DB 'TOP:$'
    STRING5 DB 3+1 DUP('$')
    STRING6 DB 'NEED CHANG?(y/n)	$'
    STRING7 DB 'NO FOUND!',13,10,'$'
    S1 DW 0
    S2 DW 0
    S3 DW 0  
    COUNT DB 1
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:  
    HH MACRO;����
	MOV AH,2
	MOV DL,13
	INT 21H
	MOV AH,2
	MOV DL,10
	INT 21H
	ENDM
	
	OUTPUT1 MACRO STRING	;����ַ�
	MOV AH,2
	MOV DL,STRING
	INT 21H
	ENDM
	
	OUTPUT2 MACRO STRING	;����ַ���
	MOV AH,9
	LEA DX,STRING
	INT 21H
	ENDM
	
	INPUT1 MACRO STRING		;�����ַ�
	MOV AH,1
	INT 21H
	ENDM
	
	INPUT2 MACRO STRING		;�����ַ���
	MOV AH,10
	LEA DX,STRING
	INT 21H
	ENDM
	
	INPUTCJ MACRO STRING	;����ɼ�
	LOCAL
    MOV DX,0
  DSP2:  
   	INPUT1
    CMP AL,13
    JNZ DS1
    JMP DSP1
    DS1:
    
    CMP AL,'0'
    JNL DS2
    OUTPUT2 STRING1
    OUTPUT2 WELCOME10
    MOV DX,0
    JMP DSP2
    DS2:
    CMP AL,'9'
    JNG DS3
    OUTPUT2 STRING1
    OUTPUT2 WELCOME10
    MOV DX,0
    JMP DSP2
    DS3:
    SUB AL,30H
    MOV AH,0
    XCHG AX,DX
    MUL CHENG
    ADD DX,AX
    MOV STRING,DX
    JMP DSP2
    DSP1:
    
    .IF DX>100
    OUTPUT2 STRING1
    OUTPUT2 WELCOME10
    MOV DX,0
    JMP DSP2
    .ELSE
    JMP EXIT2
    .ENDIF
    EXIT2:
	ENDM
	
	OUTPUTCJ MACRO STRING
	LOCAL
    MOV DI,CX
    MOV DX,STRING
    MOV CX,0
    MOV AX,DX
    DS5:
    CWD
    DIV CHU  
    INC CX
    PUSH DX 
    CMP AX,0
    JNZ DS5
    JMP DSP3
    
    DSP3:
    LP2:
    POP DX
    MOV AH,2
    ADD DL,30H
    INT 21H
    LOOP LP2

	ENDM


    MOV AX,DATAS	;������
    MOV DS,AX
    MOV ES,AX
    ;�˴��������δ���
   TOP: 
    OUTPUT2 WELCOME1
    INPUT1
    PUSH AX
   	HH
   	POP  AX
   	
    .IF AL=='1'			;����1
    MOV CX,N
    LPP1:
     PUSH CX
   	 CALL INPUT
   	 POP CX
   	 LOOP LPP1
   	 JMP TOP
   	 
    .ELSEIF AL=='2'		;����2
   	 CALL SORT
   	 MOV CX,N
   	 MOV S2,0
   	 MOV COUNT,1
    LPP2:
     PUSH CX
   	 CALL SHUCHU
   	 POP CX
   	 LOOP LPP2
   	 JMP TOP
   	 
    .ELSEIF AL=='3'		;����3
    CALL  SELECT
     JMP TOP
     
    .ELSEIF AL=='4'		;����4
    JMP EXIT
    
    .ELSE				;����
    OUTPUT2 STRING1
    JMP TOP
    
    .ENDIF
    
    EXIT:				;����
    MOV AH,4CH
    INT 21H
    
    
    
    
    ;�ӳ���
    
    
    INPUT PROC	;����
    
    OUTPUT2 WELCOME9
    MOV SI,S1
    LEA BX,student_list	
    
    MOV CX,3			;��������
    LP1:
	INPUT1 
	CMP AL,13
	JNZ D1
	MOV CX,1
	JMP TO
	D1:
	MOV [BX+SI],AL
	TO:
	INC SI
	LOOP LP1
	CMP AL,13
	JZ D2
	HH
	D2:
	MOV AL,'$'
	MOV [BX+SI],AL
	
    OUTPUT2 WELCOME10
    MOV SI,S1
    ADD SI,4
    INPUTCJ [BX+SI]		;�������
    HH
    ADD SI,2
    MOV S1,SI
    RET
    INPUT ENDP
    
    SHUCHU PROC    		;���
    OUTPUT2 STRING4
    MOV SI,S2
    LEA BX,student_list
    MOV AH,2
	MOV DL,COUNT
	ADD DL,30H
	INT 21H
	INC COUNT
    HH
    OUTPUT2 STRING3
    OUTPUT2 [BX+SI]
    OUTPUT2 STRING3
    ADD SI,4
    OUTPUTCJ [BX+SI]
    ADD SI,2
    MOV S2,SI
    HH
    RET
    SHUCHU ENDP
    
    SORT PROC
    MOV CX,N-1		
	.WHILE CX				;ð������
	PUSH CX		
	LEA BX,student_list	
	.WHILE CX
	MOV DI,4
	MOV DL,[BX+DI]		;ȡ���ĵ�һ��ֵ�������ĺ�һλֵ�Ƚϣ���Ӧ���ṹ��Ϊgrade����
	MOV DH,[BX+DI+6]	;ȡ���ĵڶ���ֵ������ǰһλ�Ƚ�
	.IF DL<DH		;���ǰһ��С�ں�һ���ɼ�����������ݽ���
		MOV DI,0
		.WHILE DI<6				;�ṹ��ʵ�ʳ���Ϊ6
		XCHG AL,[BX+DI]
		XCHG [BX+DI+6],AL		;.while��Ϊǰ�����ݽ�������
		XCHG [BX+DI],AL
		INC DI
		.ENDW
	.ENDIF
	ADD BX,6	;�����ڶ���λ�����һ�����ݱȽϣ�ð������
	DEC CX					
	.ENDW
	POP CX
	DEC CX						
.ENDW
   	RET
    SORT ENDP
    
    
    SELECT PROC		;ȡ����Ӧ�ɼ�
    
    OUTPUT2 WELCOME9
    MOV SI,0
    MOV CX,3			;��������
    LLP1:
	INPUT1 
	CMP AL,13
	JNZ DD1
	MOV CX,1
	JMP TO1
	DD1:
	MOV STRING5[SI],AL
	TO1:
	INC SI
	LOOP LLP1
	CMP AL,13
	JZ DD2
	HH
	DD2:
	MOV AL,'$'
	MOV STRING5[SI],AL
	
	MOV S3,0
	MOV DX,0
	LEA BX,student_list
	LEA BP,STRING5
	MOV CX,N
	
	LLP3:				;ѭ���Ƚ��ҳ��ɼ� 
	PUSH CX
	MOV CX,3
	MOV SI,0
	MOV S3,0
	LLP2:
	MOV AX,[BX+SI]
	CMP AX,[BP+SI]
	JZ DD3 
	MOV CX,1
	INC S3
	DD3:
	INC SI
	LOOP LLP2
	
	CMP S3,0
	JNZ DD4
	MOV SI,4
	OUTPUTCJ [BX+SI]
	HH
	POP CX
	MOV CX,1
	PUSH CX
	CALL INPUTCJ2
	HH
	DD4:
	ADD BX,6
	POP CX
	LOOP LLP3
	
	CMP S3,0
	JZ EXIT2
	OUTPUT2 STRING7
	EXIT2:
	
    RET
    SELECT ENDP
    
    
    
    INPUTCJ2 PROC	;�ж��޸�
    
    TO2:
	OUTPUT2 STRING6
	INPUT1
	PUSH AX
	POP AX
	.IF AL=='y'
	HH
	OUTPUT2 WELCOME10
    MOV SI,4
    INPUTCJ [BX+SI]		;�������
	.ELSEIF AL=='n'
	
	.ELSE
	OUTPUT2 STRING1
	JMP TO2
	.ENDIF
	
    RET
    INPUTCJ2 ENDP
    
CODES ENDS
    END START























