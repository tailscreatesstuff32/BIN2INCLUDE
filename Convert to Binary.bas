': This program uses
': InForm - GUI library for QB64 - Beta version 8
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------
' Dialog flag constants (use + or OR to use more than 1 flag value)
CONST OFN_ALLOWMULTISELECT = &H200& '  Allows the user to select more than one file, not recommended!
CONST OFN_CREATEPROMPT = &H2000& '     Prompts if a file not found should be created(GetOpenFileName only).
CONST OFN_EXTENSIONDIFFERENT = &H400& 'Allows user to specify file extension other than default extension.
CONST OFN_FILEMUSTEXIST = &H1000& '    Chechs File name exists(GetOpenFileName only).
CONST OFN_HIDEREADONLY = &H4& '        Hides read-only checkbox(GetOpenFileName only)
CONST OFN_NOCHANGEDIR = &H8& '         Restores the current directory to original value if user changed
CONST OFN_NODEREFERENCELINKS = &H100000& 'Returns path and file name of selected shortcut(.LNK) file instead of file referenced.
CONST OFN_NONETWORKBUTTON = &H20000& ' Hides and disables the Network button.
CONST OFN_NOREADONLYRETURN = &H8000& ' Prevents selection of read-only files, or files in read-only subdirectory.
CONST OFN_NOVALIDATE = &H100& '        Allows invalid file name characters.
CONST OFN_OVERWRITEPROMPT = &H2& '     Prompts if file already exists(GetSaveFileName only)
CONST OFN_PATHMUSTEXIST = &H800& '     Checks Path name exists (set with OFN_FILEMUSTEXIST).
CONST OFN_READONLY = &H1& '            Checks read-only checkbox. Returns if checkbox is checked
CONST OFN_SHAREAWARE = &H4000& '       Ignores sharing violations in networking
CONST OFN_SHOWHELP = &H10& '           Shows the help button (useless!)
'--------------------------------------------------------------------------------------------

DEFINT A-Z
TYPE FILEDIALOGTYPE
    lStructSize AS LONG '        For the DLL call
    hwndOwner AS LONG '          Dialog will hide behind window when not set correctly
    hInstance AS LONG '          Handle to a module that contains a dialog box template.
    lpstrFilter AS _OFFSET '     Pointer of the string of file filters
    lpstrCustFilter AS _OFFSET
    nMaxCustFilter AS LONG
    nFilterIndex AS LONG '       One based starting filter index to use when dialog is called
    lpstrFile AS _OFFSET '       String full of 0's for the selected file name
    nMaxFile AS LONG '           Maximum length of the string stuffed with 0's minus 1
    lpstrFileTitle AS _OFFSET '  Same as lpstrFile
    nMaxFileTitle AS LONG '      Same as nMaxFile
    lpstrInitialDir AS _OFFSET ' Starting directory
    lpstrTitle AS _OFFSET '      Dialog title
    flags AS LONG '              Dialog flags
    nFileOffset AS INTEGER '     Zero-based offset from path beginning to file name string pointed to by lpstrFile
    nFileExtension AS INTEGER '  Zero-based offset from path beginning to file extension string pointed to by lpstrFile.
    lpstrDefExt AS _OFFSET '     Default/selected file extension
    lCustData AS LONG
    lpfnHook AS LONG
    lpTemplateName AS _OFFSET
END TYPE

DECLARE DYNAMIC LIBRARY "comdlg32" ' Library declarations using _OFFSET types
    FUNCTION GetOpenFileNameA& (DIALOGPARAMS AS FILEDIALOGTYPE) ' The Open file dialog
    FUNCTION GetSaveFileNameA& (DIALOGPARAMS AS FILEDIALOGTYPE) ' The Save file dialog
END DECLARE

DECLARE LIBRARY
    FUNCTION FindWindow& (BYVAL ClassName AS _OFFSET, WindowName$) ' To get hWnd handle
END DECLARE

DEFINT A-Z
DECLARE FUNCTION E$ (B$)

$EXEICON:'binary-icon-11870-Windows.ico'
': Controls' IDs: ------------------------------------------------------------------
DIM SHARED ConvertToBinary AS LONG
DIM SHARED SelectedFileTB AS LONG
DIM SHARED OpenBT AS LONG
DIM SHARED CONVERTBT AS LONG
DIM SHARED SaveBT AS LONG
DIM SHARED OutputFileTB AS LONG
DIM SHARED ListBox1 AS LONG
'$INCLUDE:'InForm\InForm.ui'
'$INCLUDE:'InForm\xp.uitheme'
'$INCLUDE:'Convert to Binary.frm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    SetFrameRate 60
    IF COMMAND$ <> "" THEN
        Text(SelectedFileTB) = COMMAND$
        IF INSTR(COMMAND$, ".") THEN
            Text(OutputFileTB) = LEFT$(COMMAND$, LEN(COMMAND$) - 3) + "bin.bas"
        ELSE
            Text(OutputFileTB) = COMMAND$ + "bin.bas"
        END IF
        Control(CONVERTBT).Disabled = False
    END IF
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE ConvertToBinary

        CASE SelectedFileTB

        CASE OpenBT
            DO
                hWnd& = FindWindow(0, "Convert to Binary" + CHR$(0)) 'get window handle using _TITLE string
            LOOP UNTIL hWnd&
            Filter$ = "All files (*.*)|*.*"
            Flags& = OFN_FILEMUSTEXIST + OFN_NOCHANGEDIR + OFN_READONLY '    add flag constants here
            OFile$ = GetOpenFileName$("Open File" + CHR$(0), ".\", Filter$ + CHR$(0), 1, Flags&, hWnd&)
            IF OFile$ <> "" THEN
                Control(CONVERTBT).Disabled = False
                Text(SelectedFileTB) = OFile$
                IF INSTR(OFile$, ".") THEN
                    Text(OutputFileTB) = LEFT$(OFile$, LEN(OFile$) - 3) + "bin.bas"
                ELSE
                    Text(OutputFileTB) = OFile$ + "bin.bas"
                END IF

            ELSE
                Text(SelectedFileTB) = ""
            END IF
        CASE CONVERTBT
            a = bin2bas(Text(SelectedFileTB), Text(OutputFileTB))
        CASE OutputFileTB

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE ConvertToBinary

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
        CASE ConvertToBinary

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
        CASE ConvertToBinary

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
        CASE ConvertToBinary

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

    END SELECT
END SUB

SUB __UI_FormResized

END SUB
FUNCTION bin2bas (IN$, OUT$)
    ResetList ListBox1
    OPEN IN$ FOR BINARY AS 1
    IF LOF(1) = 0 THEN
        CLOSE
    else
    OPEN OUT$ FOR OUTPUT AS 2
    AddItem ListBox1, TIME$ + ": Opening file: " + IN$
    Q$ = CHR$(34) 'quotation mark
    AddItem ListBox1, TIME$ + ": Processing file..."
    PRINT #2, "A$ = "; Q$; Q$
    PRINT #2, "A$ = A$ + "; Q$;
    AddItem ListBox1, TIME$ + ": Converting lines..."
    x = 1
    DO
        s = s + 1
        a$ = INPUT$(3, 1)
        BC& = BC& + 3: LL& = LL& + 4
        IF LL& = 60 THEN
            LL& = 0
            PRINT #2, E$(a$);: PRINT #2, Q$
            PRINT #2, "A$ = A$ + "; Q$;
        ELSE
            PRINT #2, E$(a$);
        END IF
        IF LOF(1) - BC& < 3 THEN
            a$ = INPUT$(LOF(1) - BC&, 1): B$ = E$(a$)
            SELECT CASE LEN(B$)
                CASE 0: a$ = Q$
                CASE 1: a$ = "%%%" + B$ + Q$
                CASE 2: a$ = "%%" + B$ + Q$
                CASE 3: a$ = "%" + B$ + Q$
            END SELECT: PRINT #2, a$;: EXIT DO
        END IF
        IF s = 1 THEN
            ReplaceItem ListBox1, 3, TIME$ + ": Converting lines...\"
        ELSEIF s = 2 THEN
            ReplaceItem ListBox1, 3, TIME$ + ": Converting lines...|"
        ELSEIF s = 3 THEN
            ReplaceItem ListBox1, 3, TIME$ + ": Converting lines.../"
        ELSE
            ReplaceItem ListBox1, 3, TIME$ + ": Converting lines...--"
            s = 1
        END IF
        x = x + 1
    LOOP: PRINT #2, ""
    AddItem ListBox1, TIME$ + ": DONE"
    AddItem ListBox1, TIME$ + ": Writing decoding function to file..."
    PRINT #2, "btemp$="; Q$; Q$
    PRINT #2, "FOR i&=1TO LEN(A$) STEP 4:B$=MID$(A$,i&,4)"
    PRINT #2, "IF INSTR(1,B$,"; Q$; "%"; Q$; ") THEN"
    PRINT #2, "FOR C%=1 TO LEN(B$):F$=MID$(B$,C%,1)"
    PRINT #2, "IF F$<>"; Q$; "%"; Q$; "THEN C$=C$+F$"
    PRINT #2, "NEXT:B$=C$"
    PRINT #2, "END IF:FOR t%=LEN(B$) TO 1 STEP-1"
    PRINT #2, "B&=B&*64+ASC(MID$(B$,t%))-48"
    PRINT #2, "NEXT:X$="; Q$; Q$; ":FOR t%=1 TO LEN(B$)-1"
    PRINT #2, "X$=X$+CHR$(B& AND 255):B&=B&\256"
    PRINT #2, "NEXT:btemp$=btemp$+X$:NEXT"
    PRINT #2, "BASFILE$=btemp$:btemp$="; Q$; Q$
    PRINT #2, "IF _FILEEXISTS(" + Q$ + StripDirectory$(IN$) + Q$ + ") = 0 THEN"
    PRINT #2, "OPEN "; Q$; StripDirectory$(IN$); Q$; " FOR OUTPUT AS #1"
    PRINT #2, "PRINT #1, BASFILE$;"
    PRINT #2, "CLOSE #1"
    PRINT #2, "END IF"
    CLOSE #1
    CLOSE #2
    AddItem ListBox1, TIME$ + ": DONE"
    AddItem ListBox1, TIME$ + ": File exported to " + OUT$
    Text(SelectedFileTB) = ""
    Text(OutputFileTB) = ""
    Control(CONVERTBT).Disabled = True
    end if
END FUNCTION

FUNCTION E$ (B$)
    FOR T% = LEN(B$) TO 1 STEP -1
        B& = B& * 256 + ASC(MID$(B$, T%))
    NEXT

    a$ = ""
    FOR T% = 1 TO LEN(B$) + 1
        g$ = CHR$(48 + (B& AND 63)): B& = B& \ 64
        'If < and > are here, replace them with # and *
        'Just so there's no HTML tag problems with forums.
        'They'll be restored during the decoding process..
        'IF g$ = "<" THEN g$ = "#"
        'IF g$ = ">" THEN g$ = "*"
        a$ = a$ + g$
    NEXT: E$ = a$
END FUNCTION

FUNCTION GetOpenFileName$ (Title$, InitialDir$, Filter$, FilterIndex, Flags&, hWnd&)
    '  Title$      - The dialog title.
    '  InitialDir$ - If this left blank, it will use the directory where the last opened file is
    '  located. Specify ".\" if you want to always use the current directory.
    '  Filter$     - File filters separated by pipes (|) in the same format as using VB6 common dialogs.
    '  FilterIndex - The initial file filter to use. Will be altered by user during the call.
    '  Flags&      - Dialog flags. Will be altered by the user during the call.
    '  hWnd&       - Your program's window handle that should be aquired by the FindWindow function.
    '
    ' Returns: Blank when cancel is clicked otherwise, the file name selected by the user.
    ' FilterIndex and Flags& will be changed depending on the user's selections.

    DIM OpenCall AS FILEDIALOGTYPE ' Needed for dialog call

    fFilter$ = Filter$
    FOR R = 1 TO LEN(fFilter$) ' Replace the pipes with character zero
        IF MID$(fFilter$, R, 1) = "|" THEN MID$(fFilter$, R, 1) = CHR$(0)
    NEXT R
    fFilter$ = fFilter$ + CHR$(0)

    lpstrFile$ = STRING$(2048, 0) ' For the returned file name
    lpstrDefExt$ = STRING$(10, 0) ' Extension will not be added when this is not specified
    OpenCall.lStructSize = LEN(OpenCall)
    OpenCall.hwndOwner = hWnd&
    OpenCall.lpstrFilter = _OFFSET(fFilter$)
    OpenCall.nFilterIndex = FilterIndex
    OpenCall.lpstrFile = _OFFSET(lpstrFile$)
    OpenCall.nMaxFile = LEN(lpstrFile$) - 1
    OpenCall.lpstrFileTitle = OpenCall.lpstrFile
    OpenCall.nMaxFileTitle = OpenCall.nMaxFile
    OpenCall.lpstrInitialDir = _OFFSET(InitialDir$)
    OpenCall.lpstrTitle = _OFFSET(Title$)
    OpenCall.lpstrDefExt = _OFFSET(lpstrDefExt$)
    OpenCall.flags = Flags&

    Result = GetOpenFileNameA&(OpenCall) '            Do Open File dialog call!

    IF Result THEN ' Trim the remaining zeros
        GetOpenFileName$ = LEFT$(lpstrFile$, INSTR(lpstrFile$, CHR$(0)) - 1)
        Flags& = OpenCall.flags
        FilterIndex = OpenCall.nFilterIndex
    END IF

END FUNCTION

FUNCTION StripDirectory$ (OFile$)
    DO
        OFile$ = RIGHT$(OFile$, LEN(OFile$) - INSTR(OFile$, "\"))
    LOOP WHILE INSTR(OFile$, "\")
    StripDirectory$ = OFile$
END FUNCTION
