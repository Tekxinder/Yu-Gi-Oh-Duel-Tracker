#Include JSON.ahk
#NoEnv
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%


; === CONFIGURATION ===
global savePath := A_ScriptDir . "\Show_Card.jpg" 
cacheDir := A_ScriptDir . "\Cache"
global apiUrl := "https://db.ygoprodeck.com/api/v7/cardinfo.php"
global isDownloading := false
global showDetails := false

global TimerRunning := false
global TimeLeft := 50 * 60
SetTimer, UpdateTimer, 1000, Off

prevLP1 := 8000
prevLP2 := 8000
victory1 := 0
victory2 := 0
global nRound := 1
global win := 0
global loss := 0
global draw := 0

;=====INTERFACE=====
Gui, Add, Tab2,w160 h23, Duel|Card Search|Log
;=====PAGE Duel=====
;Chono
Gui, Tab, 1
Gui, Font, s9, Segoe UI ;
Gui, Add, GroupBox, x10 y+10 w360 h60 , Chrono :
Gui, Add, Button, x20 y60 w80 h30 gStartStop, Start/Stop
Gui, Font, s18 bold ;
Gui, Add, Text, x+50 vTimerText cDA4F49 , 50:00
Gui, Font, s9 normal ;
Gui, Add, Button, x+60 w80 h30 gResetTimer, Reset

;Joueur 1
Gui, Font, s9 normal ;
Gui, Add, GroupBox, x10 w360 h150, Joueur 1
Gui, Add, Edit, x20 y130 w120 vPlayer1Name gAutoSave, Player
Gui, Add, Edit, x+20 w120 vDeck1 gAutoSave, Deck
Gui, Add, Checkbox, x+20 vLockPlayer1Name gToggleLock1, Lock
Gui, Font, s14 bold ;
Gui, Add, Edit, x20 y+20 w80 h30 vLP1 gAutoSave Center, 8000
Gui, Font, s9 normal ;
Gui, Add, Edit, x+10 w40 h30 vLPChange1 Center, 100
Gui, Add, Button, x+10 w40 h30 gDecreaseLP1 , -
Gui, Add, Button, x+10 w40 h30 gIncreaseLP1 , +
Gui, Add, Button, x+10 w80 h30 gHalfLP1, ½ PV
Gui, Add, Button, x20 y+10 w80 h30 gAddVictory1, + Victoiry
Gui, Font, s10 bold;
Gui, Add, Text, x+20 vVictory1, 0

;Joueur 2
Gui, Font, s9 normal ;
Gui, Add, GroupBox, x10  w360 h150, Joueur 2
Gui, Add, Edit, x20 y290 w120 vPlayer2Name gAutoSave, Opponent
Gui, Add, Edit, x+20 w120 vDeck2 gAutoSave, Deck
Gui, Add, Checkbox, x+20 vLockPlayer2Name gToggleLock2, Lock
Gui, Font, s14 bold ;
Gui, Add, Edit, x20 y+20 w80 h30 vLP2 gAutoSave Center, 8000
Gui, Font, s9 normal ;
Gui, Add, Edit, x+10 w40 h30 vLPChange2 Center, 100
Gui, Add, Button, x+10 w40 h30 gDecreaseLP2, -
Gui, Add, Button, x+10 w40 h30 gIncreaseLP2, +
Gui, Add, Button, x+10 w80 h30 gHalfLP2, ½ PV
Gui, Add, Button, x20 y+10 w80 h30 gAddVictory2, + Victoiry
Gui, Font, s10 bold;
Gui, Add, Text, x+20 vVictory2, 0
Gui, Font, s9 normal ;

;Tournoi
Gui, Add, GroupBox, x10 w360 h50, Tournament
Gui, Font, s15 bold ;
Gui, Add, Text, x20 y430 w110 vTRound , Round : 1 
Gui, Font, s10 ;
Gui, Add, Button, x+10 w40 h30 gIncreaseWin , + W
Gui, Add, Text, x+10 w19 vTWin , 0
Gui, Add, Button, x+10 w40 h30 gIncreaseloss , + L
Gui, Add, Text, x+10 w19 vTLoss , 0
Gui, Add, Button, x+10 w40 h30 gIncreaseDraw, + D
Gui, Add, Text, x+10 w19 vTDraw , 0

;Bouton Fonctionelle
Gui, Font, s9 normal ;
Gui, Add, Button, x10 w120 h30 gResetLP, Reset LP
Gui, Add, Button, x+10 w90 h30 gCalc, Calc
Gui, Add, Button, x+10 w120 h30 gReset, Reset all

;=====PAGE Card Search=====
Gui, Tab, 2
Gui, Font, s10 ;
Gui, Add, Text, x10 y+5 , Card Name :
Gui, Add, Edit, vCardName w240 hWndhCardName
Gui, Add, Button, Default gRechercherCartes x+20 w90 h23 , Search
Gui, Add, Text, x10 y+5 w240 h20 vStatusText, Ready
Gui, Add, ListBox, vSelectedCard w350 h100 gChoisirCarte
Gui, Add, Button, x100 y+10 w180 h30 gShowDetails, Show Informations
Gui, Add, Picture, vCardImage y+10 w180 h250

; Ajoutez ces contrôles pour afficher les détails
Gui, Add, Text, x10 y250 w350 vDetailName, Nom: 
Gui, Add, Text, y+5 w350 vDetailType, Type: 
Gui, Add, Text, y+5 w350 vDetailRace, Race/Attribut: 
Gui, Add, Text, y+5 w350 vDetailStats, ATK/DEF/Niveau: 
Gui, Add, Edit, y+5 w350 h150 ReadOnly vDetailDesc
; Cacher les contrôles de détails au démarrage
GuiControl, Hide, DetailName
GuiControl, Hide, DetailType
GuiControl, Hide, DetailRace
GuiControl, Hide, DetailStats
GuiControl, Hide, DetailDesc

;=====PAGE Log=====
Gui, Tab, 3
Gui, Add, GroupBox, x10 y+10 w360 h460, Log
Gui, Add, Edit, x20 y60 w340 h390 vLogBox ReadOnly
Gui, Add, Button, x130 y+10 w120 h30 gLogReset, Reset Log

LoadData()
Gui, Show, AutoSize, YGO Duel Tracker
Winset, AlwaysOnTop, On, YGO Duel Tracker
Return

;Creation de fichier si inexistant ou Réinitialisation des fichier 
LoadData() {
    Gosub, SaveResult
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

;=====TIMER=====

StartStop:
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
TimeLeft := 50 * 60
GuiControl,, TimerText, 50:00
Gosub, TimeSave
Return

;=====SAUVGARDE=====

;Systeme de sauvegarde du timer
TimeSave:
    minutes := Floor(TimeLeft / 60)
    seconds := Mod(TimeLeft, 60)
    Time := Format("{:02}:{:02}", minutes, seconds)

    FileDelete, timer.txt

    FileAppend, %Time%, timer.txt
Return

;Systeme de sauvegarde des informations Joueurs
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

;Fonction de sauvegarde des informations Joueurs
SaveData(name, deck, lp, victory, player) {
    FileDelete, %player%_name.txt
    FileDelete, %player%_deck.txt
    FileDelete, %player%_lp.txt
    FileDelete, %player%_victory.txt
    While (FileExist(%player%_name.txt) || FileExist(%player%_deck.txt) || FileExist(%player%_lp.txt) || FileExist(%player%_victory.txt)){
        ;Sert juste à loop jusqu'à ce que tous les fichiers soient supprimés
    }
    FileAppend, %name%, %player%_name.txt
    FileAppend, %deck%, %player%_deck.txt
    FileAppend, %lp%, %player%_lp.txt
    FileAppend, %victory%, %player%_victory.txt
}

;Sauvegarde Résultat de Tournoi
SaveResult:
    FileDelete, tournamant_result.txt
    FileDelete, round.txt

    FileAppend, %win%-%loss%-%draw% , Tournamant_result.txt
    FileAppend, Round : %nRound% , round.txt
Return

;=====Gestion Information Joueur 1=====

;Soustraire Point de vie
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

;Ajout Point de vie
IncreaseLP1:
    GuiControlGet, lp,, LP1
    prevLP1 := lp
    GuiControlGet, change,, LPChange1
    lp := lp + change
    GuiControl,, LP1, % lp
    Gosub, AutoSave
    LogAction("LP1 incremented by " change " to " lp)
Return

;Divisé Point de vie
HalfLP1:
    GuiControlGet, lp,, LP1
    lp := Floor(lp / 2)
    GuiControl,, LP1, % lp
    Gosub, AutoSave
    LogAction("LP1 halved to " lp)
Return

;Ajout Victoire
AddVictory1:
    if (victory1 < 2 ) {
        victory1++
        GuiControl,, Victory1, %victory1%
        Gosub, ResetLP
        Gosub, AutoSave
        LogAction("Victory added for Player 1. Total: " victory1)
    }
Return
;=====Gestion Information Joueur 2=====

;Soustraire Point de vie
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

;Ajout Point de vie
IncreaseLP2:
    GuiControlGet, lp,, LP2
    prevLP2 := lp
    GuiControlGet, change,, LPChange2
    lp := lp + change
    GuiControl,, LP2, % lp
    Gosub, AutoSave
    LogAction("LP2 incremented by " change " to " lp)
Return

;Divisé Point de vie
HalfLP2:
    GuiControlGet, lp,, LP2
    lp := Floor(lp / 2)
    GuiControl,, LP2, % lp
    Gosub, AutoSave
    LogAction("LP2 halved to " lp)
Return

;Ajout Victoire
AddVictory2:
    if (victory2 < 2 ) {
        victory2++
        GuiControl,, Victory2, %victory2%
        Gosub, ResetLP
        Gosub, AutoSave
        LogAction("Victory added for Player 2. Total: " victory2)
    }
Return

;=====RESET=====

;Reset point de vie
ResetLP:
    GuiControl,, LP1, 8000
    GuiControl,, LP2, 8000
    Gosub, AutoSave
    LogAction("LP reset")
Return

;Vérouillage Information Joueur 1
ToggleLock1:
GuiControlGet, state,, LockPlayer1Name
for _, ctrl in ["Player1Name", "Deck1"]
    GuiControl, Disablee%state%, %ctrl%
Return

;Vérouillage Information Joueur 2
ToggleLock2:
GuiControlGet, state,, LockPlayer2Name
for _, ctrl in ["Player2Name", "Deck2"]
    GuiControl, Disable%state%, %ctrl%
Return

;Reset Joueur / LP / Victoire
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

;=====Gestion Score Tournoi=====

;Ajoue Victoire
IncreaseWin:
win ++
GuiControl,, TWin, %win%
NRound ++
GuiControl,, TRound, Round : %nRound%
Gosub, SaveResult
Gosub, Reset
Return

;Ajoue Défaite
IncreaseLoss:
loss++
GuiControl,, TLoss, %loss%
NRound ++
GuiControl,, TRound, Round : %nRound%
Gosub, SaveResult
Gosub, Reset
Return

;Ajoue Egalité
IncreaseDraw:
draw++
GuiControl,, TDraw, %draw%
nRound ++
GuiControl,, TRound, Round : %nRound%
Gosub, SaveResult
Gosub, Reset
Return

;Ouvrir Calculatrice
Calc:
#c::
{
    If not WinExist("Calculator")
        Run "calc" ;
    else
        WinActivate ;
}


;===== GESTION LOGS =====
LogReset:
GuiControl,, LogBox, 
Return

LogAction(action) {
    GuiControlGet, logText,, LogBox
    GuiControl,, LogBox, % logText "`n" action
}

; === Section Card Search ===
ShowDetails:
Gui, Submit, NoHide

; Basculer entre les modes
showDetails := !showDetails

if (showDetails) {
    ; Mode détails - cacher l'image et afficher les textes
    GuiControl, Hide, CardImage
    GuiControl,, ShowDetails, Show Card
    
    if (!SelectedCard || !IsObject(results))
        Return

    ; Trouver la carte sélectionnée
    selectedIndex := 0
    for index, card in results {
        if (card.name = SelectedCard) {
            selectedIndex := index
            break
        }
    }

    if (selectedIndex = 0)
        Return

    cardData := results[selectedIndex]

    ; Mettre à jour les informations
    GuiControl,, DetailName, % "Nom: " cardData.name
    GuiControl,, DetailType, % "Type: " cardData.type
    GuiControl,, DetailRace, % (cardData.race ? "Race: " cardData.race : "") 
                          . (cardData.attribute ? " | Attribut: " cardData.attribute : "")
                          
    GuiControl,, DetailStats, % "ATK: " (cardData.atk ? cardData.atk : "N/A")
                          . " | DEF: " (cardData.def ? cardData.def : "N/A")
                          . " | " (cardData.level ? "Niveau " cardData.level 
                                          : cardData.linkval ? "Lien " cardData.linkval 
                                          : "")
                          . (cardData.scale ? " | Échelle " cardData.scale : "")

    GuiControl,, DetailDesc, % cardData.desc

    ; Afficher les contrôles de détails
    GuiControl, Show, DetailName
    GuiControl, Show, DetailType
    GuiControl, Show, DetailRace
    GuiControl, Show, DetailStats
    GuiControl, Show, DetailDesc
} else {
    ; Mode carte - cacher les textes et afficher l'image
    GuiControl, Hide, DetailName
    GuiControl, Hide, DetailType
    GuiControl, Hide, DetailRace
    GuiControl, Hide, DetailStats
    GuiControl, Hide, DetailDesc
    GuiControl, Show, CardImage
    GuiControl,, ShowDetails, Show Information
}
Return

; === FONCTIONS PRINCIPALES ===
RechercherCartes:
Gui, Submit, NoHide
if (CardName = "") {
    MsgBox, 16, Erreur, Veuillez entrer un nom.
    Return
}

ShowLoading("Recherche en cours...")
encodedCardName := URLEncode(CardName)
url := apiUrl . "?fname=" . encodedCardName

try {
    http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    http.SetTimeouts(10000, 10000, 10000, 10000)
    http.Open("GET", url, true)
    http.Send()
    http.WaitForResponse()
    
    if (http.Status != 200) {
        ShowError("Erreur API: " http.Status " - " http.StatusText)
        Return
    }
    
    response := http.ResponseText
    data := JSON.Load(response)
    
    global results := []
    listItems := ""
    
    for index, card in data.data {
        results.Push(card)
        listItems .= card.name . "|"
    }
    
    if (results.Length() = 0) {
        ShowError("Aucune carte trouvée.")
        Return
    }
    
    GuiControl,, SelectedCard, |%listItems%
    HideLoading()
} catch e {
    ShowError("Erreur: " e.message)
}
Return

ChoisirCarte:
Gui, Submit, NoHide
if (SelectedCard = "")
    Return

; Réinitialiser à l'affichage de la carte
showDetails := false
GuiControl,, ShowDetails, Show Information

; Cacher les détails et afficher l'image
GuiControl, Hide, DetailName
GuiControl, Hide, DetailType
GuiControl, Hide, DetailRace
GuiControl, Hide, DetailStats
GuiControl, Hide, DetailDesc
GuiControl, Show, CardImage

selectedIndex := 0
for index, card in results {
    if (card.name = SelectedCard) {
        selectedIndex := index
        break
    }
}

if (selectedIndex = 0) {
    ShowError("Carte non trouvée dans les résultats.")
    Return
}

cardData := results[selectedIndex]

; Vérifier le cache
IfNotExist, %cacheDir%
{
    FileCreateDir, %cacheDir%
    MsgBox, Dossier créé : %cacheDir%
}
cacheFile := cacheDir . "\" . cardData.id . ".jpg"
if FileExist(cacheFile) {
    GuiControl,, CardImage, %cacheFile%
    FileCopy, %cacheFile%, %savePath%, 1
    Return
}

; Télécharger l'image
ShowLoading("Download picture...")
imageURL := cardData.card_images[1].image_url

try {
    imageRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    imageRequest.SetTimeouts(10000, 10000, 10000, 10000)
    imageRequest.Open("GET", imageURL, true)
    imageRequest.Send()
    imageRequest.WaitForResponse()
    
    if (imageRequest.Status = 200) {
        ; Sauvegarde dans le cache
        stream := ComObjCreate("ADODB.Stream")
        stream.Type := 1
        stream.Open()
        stream.Write(imageRequest.ResponseBody)
        stream.SaveToFile(cacheFile, 2)
        
        ; Copie également vers savePath
        FileCopy, %cacheFile%, %savePath%, 1
        
        stream.Close()
        
        GuiControl,, CardImage, %savePath%
        HideLoading()
    } else {
        ShowError("Échec du téléchargement: " imageRequest.Status)
    }
} catch e {
    ShowError("Erreur téléchargement: " e.message)
}
Return

ShowLoading(message) {
    GuiControl,, StatusText, %message%
    Gui, +Disabled
    isDownloading := true
}

HideLoading() {
    GuiControl,, StatusText, Ready
    Gui, -Disabled
    isDownloading := false
}

ShowError(message) {
    MsgBox, 16, Erreur, %message%
    HideLoading()
}

URLEncode(str) {
    out := ""
    Loop, Parse, str
    {
        char := A_LoopField
        if char is alnum
            out .= char
        else {
            hex := Format("{:02X}", Asc(char))
            out .= "%" . hex
        }
    }
    return out
}

;=====FERMETURE APPLICATION=====
GuiClose:
ExitApp

Esc::ExitApp