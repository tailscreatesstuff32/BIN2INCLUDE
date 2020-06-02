': This program uses
': InForm - GUI library for QB64 - v1.1
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------
$VERSIONINFO:CompanyName=SpriggsySpriggs
$VERSIONINFO:FileDescription=BIN2INCLUDE
$VERSIONINFO:LegalCopyright=(c) 2019-2020 SpriggsySpriggs
$VERSIONINFO:ProductName=BIN2INCLUDE
$VERSIONINFO:Web=https://github.com/SpriggsySpriggs/BIN2BAS64
$VERSIONINFO:Comments=Converts a binary file into an INCLUDE-able
$VERSIONINFO:FILEVERSION#=2,5,0,0
$VERSIONINFO:PRODUCTVERSION#=2,5,0,0
'$CONSOLE
'_CONSOLE ON
__binary
__makeshortcut
'$INCLUDE:'Open-SaveFile.BI'
DEFINT A-Z
DECLARE FUNCTION E$ (B$)
_TITLE "BIN2INCLUDE"
$EXEICON:'binary.ico'
_ICON
': Controls' IDs: ------------------------------------------------------------------
DIM SHARED BIN2INCLUDE AS LONG
DIM SHARED SelectedFileTB AS LONG
DIM SHARED OpenBT AS LONG
DIM SHARED CONVERTBT AS LONG
DIM SHARED SaveBT AS LONG
DIM SHARED OutputFileTB AS LONG
DIM SHARED ListBox1 AS LONG
DIM SHARED ClearLogBT AS LONG
DIM SHARED BIN2BASRB AS LONG
DIM SHARED PIC2MEMRB AS LONG
DIM SHARED ResetBT AS LONG
'$INCLUDE:'InForm\InForm.ui'
'$INCLUDE:'InForm\xp.uitheme'
'$INCLUDE:'BIN2INCLUDE.frm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    IF _FILEEXISTS(_DIR$("desktop") + "\BIN2INCLUDE.lnk") = 0 THEN
        a = make_shortcut(COMMAND$(0), _DIR$("desktop") + "\BIN2INCLUDE.lnk")
    END IF
    '_TITLE "BIN2INCLUDE"
    Control(OpenBT).HelperCanvas = __opensmall&
    Control(CONVERTBT).HelperCanvas = __convert&
    Control(ResetBT).HelperCanvas = __reset&
    Control(ClearLogBT).HelperCanvas = __deletesmall&
    Control(OpenBT).Disabled = True
    SetFrameRate 60
    _ACCEPTFILEDROP
    AddItem ListBox1, "Open a file above or drag and drop."
    AddItem ListBox1, "Select BIN2BAS to convert a binary file to BM or select PIC2MEM to convert an image to MEM."
    AddItem ListBox1, "To compile a file that is creating memory errors,"
    AddItem ListBox1, "consult the readme on https://github.com/SpriggsySpriggs/BIN2INCLUDE"
    '_SCREENMOVE _MIDDLE
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    IF _TOTALDROPPEDFILES THEN
        drop$ = _DROPPEDFILE
        IF _FILEEXISTS(drop$) THEN
            IF checkExt(drop$) = 0 AND Control(PIC2MEMRB).Value = False THEN
                Control(BIN2BASRB).Value = True
                Control(PIC2MEMRB).Disabled = True
                Text(SelectedFileTB) = drop$
                Text(OutputFileTB) = drop$ + ".BM"
                Control(CONVERTBT).Disabled = False
            ELSEIF checkExt(drop$) AND Control(PIC2MEMRB).Value = True THEN
                Control(BIN2BASRB).Disabled = True
                Text(SelectedFileTB) = drop$
                Text(OutputFileTB) = drop$ + ".MEM"
                Control(CONVERTBT).Disabled = False
            ELSEIF checkExt(drop$) = 0 AND Control(PIC2MEMRB).Value = True THEN
                Answer = MessageBox("Unsupported file type for PIC2MEM", "", MsgBox_OkOnly + MsgBox_Exclamation)
                Control(BIN2BASRB).Disabled = False
            END IF
        END IF
    END IF
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE BIN2INCLUDE

        CASE SelectedFileTB

        CASE OpenBT
            IF Control(BIN2BASRB).Value = True THEN
                $IF 32BIT THEN
                    hWnd& = _WINDOWHANDLE
                    Filter$ = "All files (*.*)|*.*"
                    Flags& = OFN_FILEMUSTEXIST + OFN_NOCHANGEDIR + OFN_READONLY '    add flag constants here
                    OFile$ = GetOpenFileName("Open File" + CHR$(0), ".\", Filter$ + CHR$(0), 1, Flags&, hWnd&)
                $ELSE
                    OFile$ = GetOpenFileName64("Open File", ".\", "All files (*.*)|*.*")
                $END IF
                Control(PIC2MEMRB).Disabled = True
            ELSEIF Control(PIC2MEMRB).Value = True THEN
                $IF 32BIT THEN
                    hWnd& = _WINDOWHANDLE
                    Filter$ = "BMP Image (.BMP)|*.BMP|JPG/JPEG Image (.JPG;.JPEG)|*.JPG;*.JPEG|PNG Image (.PNG)|*.PNG|GIF Image (.GIF)|*.GIF|All Supported Image Files (.BMP;.JPG;.JPEG;.PNG;.GIF)|*.BMP;*.JPG;*.PNG;*.JPEG;*.GIF"
                    Flags& = OFN_FILEMUSTEXIST + OFN_NOCHANGEDIR + OFN_READONLY '    add flag constants here
                    OFile$ = GetOpenFileName("Open Image" + CHR$(0), ".\", Filter$ + CHR$(0), 1, Flags&, hWnd&)
                $ELSE
                    OFile$ = GetOpenFileName64("Open Image", ".\", "BMP Image (.BMP)|*.BMP|JPG/JPEG Image (.JPG;.JPEG)|*.JPG;*.JPEG|PNG Image (.PNG)|*.PNG|GIF Image (.GIF)|*.GIF|All Supported Image Files (.BMP;.JPG;.JPEG;.PNG;.GIF)|*.BMP;*.JPG;*.PNG;*.JPEG;*.GIF")
                $END IF
                Control(BIN2BASRB).Disabled = True
            END IF
            IF OFile$ <> "" THEN
                IF checkExt(OFile$) = 0 AND Control(PIC2MEMRB).Value = True THEN
                    Answer = MessageBox("Unsupported file type for PIC2MEM", "", MsgBox_OkOnly + MsgBox_Exclamation)
                    Control(BIN2BASRB).Disabled = False
                ELSEIF checkExt(OFile$) AND Control(PIC2MEMRB).Value = True THEN
                    Control(CONVERTBT).Disabled = False
                    Text(SelectedFileTB) = OFile$
                    Text(OutputFileTB) = OFile$ + ".MEM"
                ELSE
                    Control(CONVERTBT).Disabled = False
                    Text(SelectedFileTB) = OFile$
                    Text(OutputFileTB) = OFile$ + ".BM"
                END IF
            ELSE
                Text(SelectedFileTB) = ""
                Text(OutputFileTB) = ""
                Control(BIN2BASRB).Disabled = False
                Control(PIC2MEMRB).Disabled = False
                Control(CONVERTBT).Disabled = True
            END IF
        CASE CONVERTBT
            IF Control(BIN2BASRB).Value = True THEN
                _TITLE _TITLE$ + " - WORKING..."
                a = bin2bas(Text(SelectedFileTB), Text(OutputFileTB))
                Control(PIC2MEMRB).Disabled = False
                _TITLE "BIN2INCLUDE"
            ELSEIF Control(PIC2MEMRB).Value = True THEN
                _TITLE _TITLE$ + " - WORKING..."
                a = pic2mem(Text(SelectedFileTB), Text(OutputFileTB))
                Control(BIN2BASRB).Disabled = False
                _TITLE "BIN2INCLUDE"
            ELSE
                Answer = MessageBox("Select an option, first", "BIN2BAS or PIC2MEM?", MsgBox_OkOnly + MsgBox_Exclamation)
            END IF
        CASE OutputFileTB

        CASE ListBox1

        CASE ClearLogBT
            ResetList ListBox1

        CASE ResetBT
            ResetScreen
    END SELECT
END SUB

SUB ResetScreen
    'ResetList ListBox1
    Text(SelectedFileTB) = ""
    Text(OutputFileTB) = ""
    Control(BIN2BASRB).Disabled = False
    Control(PIC2MEMRB).Disabled = False
    Control(CONVERTBT).Disabled = True
    ToolTip(ListBox1) = ""
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE BIN2INCLUDE

        CASE SelectedFileTB

        CASE OpenBT

        CASE CONVERTBT

        CASE SaveBT

        CASE OutputFileTB

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE BIN2INCLUDE

        CASE SelectedFileTB

        CASE OpenBT

        CASE CONVERTBT

        CASE SaveBT

        CASE OutputFileTB

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE SelectedFileTB

        CASE OpenBT

        CASE CONVERTBT

        CASE SaveBT

        CASE OutputFileTB

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
        CASE SelectedFileTB

        CASE OpenBT

        CASE CONVERTBT

        CASE SaveBT

        CASE OutputFileTB

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE BIN2INCLUDE

        CASE SelectedFileTB

        CASE OpenBT

        CASE CONVERTBT

        CASE SaveBT

        CASE OutputFileTB

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE BIN2INCLUDE

        CASE SelectedFileTB

        CASE OpenBT

        CASE CONVERTBT

        CASE SaveBT

        CASE OutputFileTB

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    SELECT CASE id
        CASE SelectedFileTB

        CASE OpenBT

        CASE CONVERTBT

        CASE OutputFileTB

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
        CASE SelectedFileTB

        CASE OutputFileTB

    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE ListBox1

        CASE BIN2BASRB
            Control(OpenBT).Disabled = False
            _TITLE "BIN2INCLUDE - BIN2BAS"
        CASE PIC2MEMRB
            Control(OpenBT).Disabled = False
            _TITLE "BIN2INCLUDE - PIC2MEM"
    END SELECT
END SUB

SUB __UI_FormResized

END SUB
FUNCTION bin2bas (IN$, OUT$)
    OPEN IN$ FOR BINARY AS 1
    IF LOF(1) = 0 THEN
        CLOSE
    ELSE
        INDATA$ = (INPUT$(LOF(1), 1))

        'Compress it
        INDATA$ = _DEFLATE$(INDATA$)
        OPEN OUT$ FOR OUTPUT AS 2
        Q$ = CHR$(34) 'quotation mark
        inFunc$ = LEFT$(IN$, LEN(IN$) - 4)
        FOR i = 32 TO 64
            IF INSTR(inFunc$, CHR$(i)) THEN
                inFunc$ = String.Replace(inFunc$, CHR$(i), "")
            END IF
        NEXT
        FOR i = 91 TO 96
            IF INSTR(inFunc$, CHR$(i)) THEN
                IF i <> 92 THEN
                    inFunc$ = String.Replace(inFunc$, CHR$(i), "")
                END IF
            END IF
        NEXT
        PRINT #2, "SUB __" + StripDirectory(inFunc$)
        PRINT #2, "IF _FILEEXISTS(" + Q$ + StripDirectory(IN$) + Q$ + ") = 0 THEN 'remove this line if you are compiling in FreeBasic"
        AddItem ListBox1, TIME$ + ": Opening file: " + IN$
        AddItem ListBox1, TIME$ + ": Processing file..."
        PRINT #2, "'#lang "; Q$; "qb"; Q$; " 'uncomment this line if compiling in FreeBasic"
        PRINT #2, "DIM A$"
        PRINT #2, "A$ = "; Q$; Q$
        PRINT #2, "A$ = A$ + "; Q$;
        AddItem ListBox1, TIME$ + ": Converting lines..."
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
        AddItem ListBox1, TIME$ + ": DONE"
        AddItem ListBox1, TIME$ + ": Writing decoding function to file..."
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
        PRINT #2, "DIM BASFILE$"
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
        PRINT #2, "BASFILE$=_INFLATE$(btemp$):btemp$="; Q$; Q$
        PRINT #2, "OPEN "; Q$; IN$; Q$; " FOR OUTPUT AS #1"
        PRINT #2, "PRINT #1, BASFILE$;"
        PRINT #2, "CLOSE #1"
        PRINT #2, "END IF 'remove this line if you are compiling in FreeBasic"
        PRINT #2, "END SUB"
        CLOSE #1
        CLOSE #2
        AddItem ListBox1, TIME$ + ": DONE"
        AddItem ListBox1, TIME$ + ": File exported to " + OUT$
        ToolTip(ListBox1) = TIME$ + ": File exported to " + OUT$
        Text(SelectedFileTB) = ""
        Text(OutputFileTB) = ""
        Control(CONVERTBT).Disabled = True
        Control(OpenBT).Disabled = True
        Control(BIN2BASRB).Value = False
        Control(PIC2MEMRB).Value = False
    END IF
END FUNCTION

FUNCTION pic2mem (IN$, OUT$)
    AddItem ListBox1, TIME$ + ": Opening file: " + IN$
    AddItem ListBox1, TIME$ + ": Processing file..."
    a = _SHELLHIDE("pic2mem.exe " + CHR$(34) + IN$ + CHR$(34) + " " + CHR$(34) + OUT$ + CHR$(34))
    IF a = 1 THEN
        AddItem ListBox1, TIME$ + ": Image converted to MEM successfully"
        AddItem ListBox1, TIME$ + ": File exported to " + OUT$
        ToolTip(ListBox1) = TIME$ + ": File exported to " + OUT$
        Text(SelectedFileTB) = ""
        Text(OutputFileTB) = ""
        Control(CONVERTBT).Disabled = True
        Control(OpenBT).Disabled = True
        Control(BIN2BASRB).Value = False
        Control(PIC2MEMRB).Value = False
    ELSE
        AddItem ListBox1, TIME$ + ": Image could not be converted. Try again"
    END IF
    pic2mem = a
END FUNCTION

FUNCTION checkExt (OFile$)
    '*.BMP;*.JPG;*.PNG;*.JPEG;*.GIF)|*.BMP;*.JPG;*.PNG;*.JPEG;*.GIF"
    IF UCASE$(RIGHT$(OFile$,  4)) <> ".BMP" AND UCASE$(RIGHT$(OFile$,  4)) <> ".JPG" _
    AND UCASE$(RIGHT$(OFile$, 4)) <> ".PNG" AND UCASE$(RIGHT$(OFile$,  5)) <> ".JPEG" _
    AND UCASE$(RIGHT$(OFile$,  4)) <> ".GIF" THEN
        checkExt = 0
    ELSE
        checkExt = 1
    END IF
END FUNCTION

FUNCTION E$ (B$)

    FOR T% = LEN(B$) TO 1 STEP -1
        B& = B& * 256 + ASC(MID$(B$, T%))
    NEXT

    a$ = ""
    FOR T% = 1 TO LEN(B$) + 1
        g$ = CHR$(48 + (B& AND 63)): B& = B& \ 64
        IF g$ = "@" THEN g$ = "#"
        a$ = a$ + g$
    NEXT: E$ = a$

END FUNCTION

FUNCTION StripDirectory$ (OFile$)
    OFile$ = MID$(OFile$, _INSTRREV(OFile$, "\") + 1)
    StripDirectory = OFile$
END FUNCTION
'$INCLUDE:'OpenFile.BM'
'$INCLUDE:'Replace.BM'
'$INCLUDE:'open-small.png.MEM'
'$INCLUDE:'convert.png.MEM'
'$INCLUDE:'reset.png.MEM'
'$INCLUDE:'delete-small.png.MEM'
'$INCLUDE:'binary.ico.BM'
'$INCLUDE:'make_shortcut.BM'
