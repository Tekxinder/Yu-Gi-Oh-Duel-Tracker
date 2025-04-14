global TimerRunning := false
global TimeLeft := 45 * 60
SetTimer, UpdateTimer, 1000, Off

prevLP1 := 8000
prevLP2 := 8000
victory1 := 0
victory2 := 0
global nRound := 1
global win := 0
global loss := 0
global draw := 0

Gui, Font, s9, Segoe UI ;
Gui, Add, GroupBox, x10 y10 w360 h50 , Chrono :
Gui, Add, Button, x20 y25 w80 h30 gStartPause, Start/Stop
Gui, Add, Button, x280 y25 w80 h30 gResetTimer, Reset
Gui, Font, s21 bold ;
Gui, Add, Text, x160 y18 vTimerText cDA4F49 , 45:00

Gui, Font, s9 normal ;
Gui, Add, GroupBox, x10 y70 w360 h150, Joueur 1
Gui, Add, Edit, x20 y90 w120 vPlayer1Name gAutoSave, Player
Gui, Add, Edit, x150 y90 w120 vDeck1 gAutoSave, Deck
Gui, Add, Checkbox, x280 y90 vLockPlayer1Name gToggleLock1, Lock
Gui, Font, s14 bold ;
Gui, Add, Edit, x20 y130 w80 h30 vLP1 gAutoSave Center, 8000
Gui, Font, s9 normal ;
Gui, Add, Edit, x110 y130 w40 h30 vLPChange1 Center, 100
Gui, Add, Button, x160 y130 w40 h30 gDecreaseLP1 , -
Gui, Add, Button, x210 y130 w40 h30 gIncreaseLP1 , +
Gui, Add, Button, x260 y130 w80 h30 gHalfLP1, ½ PV
Gui, Add, Button, x20 y175 w80 h30 gAddVictory1, + Victoiry
Gui, Font, s10 bold;
Gui, Add, Text, x110 y180 vVictory1, 0
Gui, Font, s9 normal ;

Gui, Add, GroupBox, x10 y230 w360 h150, Joueur 2
Gui, Add, Edit, x20 y250 w120 vPlayer2Name gAutoSave, Opponent
Gui, Add, Edit, x150 y250 w120 vDeck2 gAutoSave, Deck
Gui, Add, Checkbox, x280 y250 vLockPlayer2Name gToggleLock2, Lock
Gui, Font, s14 bold ;
Gui, Add, Edit, x20 y290 w80 h30 vLP2 gAutoSave Center, 8000
Gui, Font, s9 normal ;
Gui, Add, Edit, x110 y290 w40 h30 vLPChange2 Center, 100
Gui, Add, Button, x160 y290 w40 h30 gDecreaseLP2, -
Gui, Add, Button, x210 y290 w40 h30 gIncreaseLP2, +
Gui, Add, Button, x260 y290 w80 h30 gHalfLP2, ½ PV
Gui, Add, Button, x20 y335 w80 h30 gAddVictory2, + Victoiry
Gui, Font, s10 bold;
Gui, Add, Text, x110 y340 vVictory2, 0
Gui, Font, s9 normal ;

Gui, Add, GroupBox, x10 y390 w360 h50, Tournament
Gui, Font, s15 bold ;
Gui, Add, Text, x20 y405 w140 vTRound , Round : 1 
Gui, Font, s10 ;
Gui, Add, Text, x210 y410 w19 vTWin , 0
Gui, Add, Text, x280 y410 w19 vTLoss , 0
Gui, Add, Text, x350 y410 w19 vTDraw , 0
Gui, Font, s9 normal ;
Gui, Add, Button, x160 y405 w40 h30 gIncreaseWin , + W
Gui, Add, Button, x230 y405 w40 h30 gIncreaseloss , + L
Gui, Add, Button, x300 y405 w40 h30 gIncreaseDraw, + D

Gui, Add, Button, x10 y450 w120 h30 gResetLP, Reset LP
Gui, Add, Button, x145 y450 w90 h30 gCalc, Calc
Gui, Add, Button, x250 y450 w120 h30 gReset, Reset all

Gui, Add, GroupBox, x390 y10 w200 h470, Log
Gui, Add, Edit, x400 y30 w180 h400 vLogBox ReadOnly
Gui, Add, Button, x430 y440 w120 h30 gLogReset, Reset Log

LoadData()
Gosub, SaveResult
Gui, Show, AutoSize, YGO Duel Tracker
Return

ToggleLock1:
GuiControlGet, state,, LockPlayer1Name
for _, ctrl in ["Player1Name", "Deck1"]
    GuiControl, Disablee%state%, %ctrl%
Return

ToggleLock2:
GuiControlGet, state,, LockPlayer2Name
for _, ctrl in ["Player2Name", "Deck2"]
    GuiControl, Disable%state%, %ctrl%
Return

StartPause:
TimerRunning := !TimerRunning
If (TimerRunning) {
    SetTimer, UpdateTimer, 1000
} Else {
    SetTimer, UpdateTimer, Off
}
Return

UpdateTimer:
If (TimerRunning && TimeLeft > 0) {
    TimeLeft--
    minutes := Floor(TimeLeft / 60)
    seconds := Mod(TimeLeft, 60)
    GuiControl,, TimerText, % Format("{:02}:{:02}", minutes, seconds)
    Gosub, TimeSave
} Else If (TimeLeft = 0) {
    SetTimer, UpdateTimer, Off
    TimerRunning := False
    Gosub, TimeSave
    SoundPlay, alarm.mp3  ;
}

Return

ResetTimer:
SetTimer, UpdateTimer, Off
TimerRunning := False
TimeLeft := 45 * 60
GuiControl,, TimerText, 45:00
Gosub, TimeSave
Return

TimeSave:
    minutes := Floor(TimeLeft / 60)
    seconds := Mod(TimeLeft, 60)
    Time := Format("{:02}:{:02}", minutes, seconds)

    FileDelete, timer.txt

    FileAppend, %Time%, timer.txt
Return


AutoSave:
    ; Vérifiez si les données ont changé avant de sauvegarder
    GuiControlGet, name1,, Player1Name
    GuiControlGet, deck1,, Deck1
    GuiControlGet, lp1,, LP1
    GuiControlGet, victory1,, Victory1
    GuiControlGet, name2,, Player2Name
    GuiControlGet, deck2,, Deck2
    GuiControlGet, lp2,, LP2
    GuiControlGet, victory2,, Victory2

    ; Sauvegarde uniquement si les données ont changé
    If (name1 != prevName1 || deck1 != prevDeck1 || lp1 != prevLP1 || victory1 != prevVictory1) {
        SaveData(name1, deck1, lp1, victory1, "player1")
        prevName1 := name1
        prevDeck1 := deck1
        prevLP1 := lp1
        prevVictory1 := victory1
    }

    If (name2 != prevName2 || deck2 != prevDeck2 || lp2 != prevLP2 || victory2 != prevVictory2) {
        SaveData(name2, deck2, lp2, victory2, "player2")
        prevName2 := name2
        prevDeck2 := deck2
        prevLP2 := lp2
        prevVictory2 := victory2
    }
Return

SaveData(name, deck, lp, victory, player) {
    FileDelete, %player%_name.txt
    FileDelete, %player%_deck.txt
    FileDelete, %player%_lp.txt
    FileDelete, %player%_victory.txt

    FileAppend, %name%, %player%_name.txt
    FileAppend, %deck%, %player%_deck.txt
    FileAppend, %lp%, %player%_lp.txt
    FileAppend, %victory%, %player%_victory.txt
}

LoadData() {
    Loop, 2 {
        player := A_Index
        name := (player = 1) ? "Player" : "Opponent"
        deck := "Deck"
        lp := "8000"

        For type in ["name", "deck", "lp"] {
            file := "player" player "_" type ".txt"
            IfExist, %file%
                FileRead, %type%, %file%
        }

        GuiControl,, Player%player%Name, % name
        GuiControl,, Deck%player%, % deck
        GuiControl,, LP%player%, % lp
    }
}

DecreaseLP1:
    GuiControlGet, lp,, LP1
    prevLP1 := lp
    GuiControlGet, change,, LPChange1
    if (lp > change){
        lp := lp - change
    }
    Else{
        lp:= 0
    }
    GuiControl,, LP1, % lp
    Gosub, AutoSave
    LogAction("LP1 decremented by " change " to " lp)
Return

IncreaseLP1:
    GuiControlGet, lp,, LP1
    prevLP1 := lp
    GuiControlGet, change,, LPChange1
    lp := lp + change
    GuiControl,, LP1, % lp
    Gosub, AutoSave
    LogAction("LP1 incremented by " change " to " lp)
Return

DecreaseLP2:
    GuiControlGet, lp,, LP2
    prevLP2 := lp
    GuiControlGet, change,, LPChange2
   if (lp > change){
        lp := lp - change
    }
    Else{
        lp:= 0
    }
    GuiControl,, LP2, % lp
    Gosub, AutoSave
    LogAction("LP2 decremented by " change " to " lp)
Return

IncreaseLP2:
    GuiControlGet, lp,, LP2
    prevLP2 := lp
    GuiControlGet, change,, LPChange2
    lp := lp + change
    GuiControl,, LP2, % lp
    Gosub, AutoSave
    LogAction("LP2 incremented by " change " to " lp)
Return

HalfLP1:
    GuiControlGet, lp,, LP1
    lp := Floor(lp / 2)
    GuiControl,, LP1, % lp
    Gosub, AutoSave
    LogAction("LP1 halved to " lp)
Return

HalfLP2:
    GuiControlGet, lp,, LP2
    lp := Floor(lp / 2)
    GuiControl,, LP2, % lp
    Gosub, AutoSave
    LogAction("LP2 halved to " lp)
Return

AddVictory1:
    if (victory1 < 2 ) {
        victory1++
        GuiControl,, Victory1, %victory1%
        Gosub, AutoSave
        LogAction("Victory added for Player 1. Total: " victory1)
    }
Return

AddVictory2:
    if (victory2 < 2 ) {
        victory2++
        GuiControl,, Victory2, %victory2%
        Gosub, AutoSave
        LogAction("Victory added for Player 2. Total: " victory2)
    }
Return

ResetLP:
    GuiControl,, LP1, 8000
    GuiControl,, LP2, 8000
    Gosub, AutoSave
    LogAction("LP reset")
Return

Reset:
    GuiControlGet, lock1,, LockPlayer1Name
    GuiControlGet, lock2,, LockPlayer2Name

    if (!lock1) {
        GuiControl,, Player1Name, Player
        GuiControl,, Deck1, Deck
    }
    if (!lock2) {
        GuiControl,, Player2Name, Opponent
        GuiControl,, Deck2, Deck
    }
    GuiControl,, LP1, 8000
    GuiControl,, LP2, 8000
    victories1 := 0
    victories2 := 0
    GuiControl,, Victory1, 0
    GuiControl,, Victory2, 0
    Gosub, ResetTimer
    Gosub, AutoSave
    LogAction("Complete reset")
Return

LogReset:
GuiControl,, LogBox, 
Return

LogAction(action) {
    GuiControlGet, logText,, LogBox
    GuiControl,, LogBox, % logText "`n" action
}

IncreaseWin:
win ++
GuiControl,, TWin, %win%
NRound ++
GuiControl,, TRound, Round : %nRound%
Gosub, SaveResult
Gosub, Reset
Return

IncreaseLoss:
loss++
GuiControl,, TLoss, %loss%
NRound ++
GuiControl,, TRound, Round : %nRound%
Gosub, SaveResult
Gosub, Reset
Return

IncreaseDraw:
draw++
GuiControl,, TDraw, %draw%
nRound ++
GuiControl,, TRound, Round : %nRound%
Gosub, SaveResult
Gosub, Reset
Return

SaveResult:
    FileDelete, tournamant_result.txt
    FileDelete, round.txt

    FileAppend, %win%-%loss%-%draw% , Tournamant_result.txt
    FileAppend, Round : %nRound% , round.txt
Return

Calc:
#c::
    if not WinExist("Calculator")
    {
        Run calc.exe
        WinWait Calculator
    }
    WinActivate Calculator
Return

GuiClose:
ExitApp

Esc::ExitApp