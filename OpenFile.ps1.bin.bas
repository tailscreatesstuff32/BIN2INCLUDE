IF _FILEEXISTS("OpenFile.ps1") = 0 THEN
'#lang "qb"
A$ = ""
A$ = A$ + "haIKAn]C23356onU\gQV5Bf8aE0_bHR6aPTh=0aAd;@8Y\M6DCGkBKGP5dW<"
A$ = A$ + "_`79O5l\aO4A^\Omkkgid_nmWOeHDD?8UE8\SHJF6H1mc<A1HVh?\`6fW;P["
A$ = A$ + "O@6[Bhb5nC9g@l;\YGikjd=99LLI>@2kJ<@fLAi0<>9ZdHQ<j;LIRJUQfGYc"
A$ = A$ + "<^>=ZhL_6E0=bH0\:LhlgPHkImC7V3bZ4mh<QJ19LTFU3JK9i^=4GW?n;?jH"
A$ = A$ + "^E08e6<m2cTfCa[iB^5cN@\cDjHETES?RPVdWPL1;62lJiMQg[N=?QgSK3gS"
A$ = A$ + "[a5DY;[X\38j<NYb0bD^`FoDfbobccOF[Ih4NoOCXoQd7Cce1]9;4e[mafSF"
A$ = A$ + "ZF]]:2fCZ^[?afNMG7N:9hGKQBPhkgLcaA_UhSEJeP19NVJGKaoDH=gBjDg`"
A$ = A$ + "P`0KfYd6EnA<%%L2"
btemp$=""
FOR i&=1TO LEN(A$) STEP 4:B$=MID$(A$,i&,4)
IF INSTR(1,B$,"%") THEN
FOR C%=1 TO LEN(B$):F$=MID$(B$,C%,1)
IF F$<>"%"THEN C$=C$+F$
NEXT:B$=C$
END IF:FOR t%=LEN(B$) TO 1 STEP-1
B&=B&*64+ASC(MID$(B$,t%))-48
NEXT:X$="":FOR t%=1 TO LEN(B$)-1
X$=X$+CHR$(B& AND 255):B&=B&\256
NEXT:btemp$=btemp$+X$:NEXT
BASFILE$=_INFLATE$(btemp$):btemp$=""
OPEN "OpenFile.ps1" FOR OUTPUT AS #1
PRINT #1, BASFILE$;
CLOSE #1
END IF
