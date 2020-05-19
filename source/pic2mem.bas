$SCREENHIDE
_SCREENHIDE
DEFINT A-Z
DECLARE FUNCTION E$ (B$)
IF COMMAND$ <> "" THEN
    IN$ = COMMAND$(1)
    IF IN$ = "" THEN SYSTEM 0
    OUT$ = COMMAND$(2)
    IF OUT$ = "" THEN SYSTEM 0
    'Load image file to screen mode
    SCREEN _LOADIMAGE(IN$, 32): SLEEP 1
    DIM m AS _MEM: m = _MEMIMAGE(0)

    'Grab screen data
    INDATA$ = SPACE$(m.SIZE)
    _MEMGET m, m.OFFSET, INDATA$
    'Compress it
    INDATA$ = _DEFLATE$(INDATA$)
    'get screen specs
    wid = _WIDTH: hih = _HEIGHT

    SCREEN 0

    OPEN OUT$ FOR OUTPUT AS 2

    Q$ = CHR$(34) 'quotation mark
    inFunc$ = LEFT$(IN$, LEN(IN$) - 4)
    FOR i = 32 TO 64
        IF INSTR(inFunc$, CHR$(i)) THEN
            inFunc$ = ReplaceStringItem(inFunc$, CHR$(i), "")
        END IF
    NEXT
    FOR i = 91 TO 96
        IF INSTR(inFunc$, CHR$(i)) THEN
            IF i <> 92 THEN
                inFunc$ = ReplaceStringItem(inFunc$, CHR$(i), "")
            END IF
        END IF
    NEXT
    PRINT #2, "FUNCTION __" + StripDirectory(inFunc$) + "& '"; IN$
    PRINT #2, "DIM v&"
    PRINT #2, "DIM A$"
    PRINT #2, "DIM btemp$"
    PRINT #2, "DIM i&"
    PRINT #2, "DIM B$"
    PRINT #2, "DIM C%"
    PRINT #2, "DIM F$"
    PRINT #2, "DIM C$"
    PRINT #2, "DIM j"
    PRINT #2, "DIM t%"
    PRINT #2, "DIM B&"
    PRINT #2, "DIM X$"
    PRINT #2, "v&=_NEWIMAGE("; wid; ","; hih; ",32)"
    PRINT #2, "DIM m AS _MEM:m=_MEMIMAGE(v&)"
    PRINT #2, "A$ = "; Q$; Q$
    PRINT #2, "A$ = A$ + "; Q$;

    BC& = 1

    DO
        a$ = MID$(INDATA$, BC&, 3)
        BC& = BC& + 3: LL& = LL& + 4
        IF LL& = 60 THEN
            LL& = 0
            PRINT #2, E$(a$);: PRINT #2, Q$
            PRINT #2, "A$ = A$ + "; Q$;
        ELSE
            PRINT #2, E$(a$);
        END IF
        IF LEN(INDATA$) - BC& < 3 THEN
            a$ = MID$(INDATA$, LEN(INDATA$) - BC&, 1): B$ = E$(a$)
            SELECT CASE LEN(B$)
                CASE 0: a$ = Q$
                CASE 1: a$ = "%%%" + B$ + Q$
                CASE 2: a$ = "%%" + B$ + Q$
                CASE 3: a$ = "%" + B$ + Q$
            END SELECT: PRINT #2, a$;: EXIT DO
        END IF
    LOOP: PRINT #2, ""

    PRINT #2, "btemp$="; Q$; Q$
    PRINT #2, "FOR i&=1TO LEN(A$) STEP 4:B$=MID$(A$,i&,4)"
    PRINT #2, "IF INSTR(1,B$,"; Q$; "%"; Q$; ") THEN"
    PRINT #2, "FOR C%=1 TO LEN(B$):F$=MID$(B$,C%,1)"
    PRINT #2, "IF F$<>"; Q$; "%"; Q$; "THEN C$=C$+F$"
    PRINT #2, "NEXT:B$=C$:END IF:FOR j=1 TO LEN(B$)"
    PRINT #2, "IF MID$(B$,j,1)="; Q$; "#"; Q$; " THEN"
    PRINT #2, "MID$(B$,j)="; Q$; "@"; Q$; ":END IF:NEXT"
    PRINT #2, "FOR t%=LEN(B$) TO 1 STEP-1"
    PRINT #2, "B&=B&*64+ASC(MID$(B$,t%))-48"
    PRINT #2, "NEXT:X$="; Q$; Q$; ":FOR t%=1 TO LEN(B$)-1"
    PRINT #2, "X$=X$+CHR$(B& AND 255):B&=B&\256"
    PRINT #2, "NEXT:btemp$=btemp$+X$:NEXT"
    PRINT #2, "btemp$=_INFLATE$(btemp$)"
    PRINT #2, "_MEMPUT m, m.OFFSET, btemp$: _MEMFREE m"
    PRINT #2, "__" + inFunc$ + "& = _COPYIMAGE(v&): _FREEIMAGE v&"
    PRINT #2, "END FUNCTION"
    SYSTEM 1
ELSE
    SYSTEM 0
END IF

FUNCTION E$ (B$)

    FOR T% = LEN(B$) TO 1 STEP -1
        B& = B& * 256 + ASC(MID$(B$, T%))
    NEXT

    a$ = ""
    FOR T% = 1 TO LEN(B$) + 1
        g$ = CHR$(48 + (B& AND 63)): B& = B& \ 64
        'If @ is here, replace it with #
        'To fix problem posting code in the QB64 forum.
        'It'll be restored during the decoding process.
        IF g$ = "@" THEN g$ = "#"
        a$ = a$ + g$
    NEXT: E$ = a$

END FUNCTION
'$INCLUDE:'StripDirectory$.BM'
'$INCLUDE:'Replace.BM'
