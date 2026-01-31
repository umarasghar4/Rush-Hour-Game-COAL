; ========================================
; Umar Asghar
; 24i - 2532
; BS - DS (B)
; Coal Project
; Rush Hour Game
; ====================

INCLUDE Irvine32.inc

.data
    ;MENU STRINGS
    titleMsg BYTE "========================================", 0
    titleMsg2 BYTE "     RUSH HOUR TAXI GAME", 0
    titleMsg3 BYTE "========================================", 0
    
    menuMsg1 BYTE "1. Start New Game", 0
    menuMsg2 BYTE "2. Continue Game", 0
    menuMsg3 BYTE "3. Change Difficulty Level", 0
    menuMsg4 BYTE "4. View Leaderboard", 0
    menuMsg5 BYTE "5. Instructions", 0
    menuMsg6 BYTE "6. Exit", 0
    menuMsg7 BYTE "Select option: ", 0
    
    instructionsMsg1 BYTE " INSTRUCTIONS ", 0
    instructionsMsg2 BYTE "Arrow Keys: Move Taxi", 0
    instructionsMsg3 BYTE "SPACEBAR: Pick/Drop Passenger", 0
    instructionsMsg4 BYTE "P: Pause Game", 0
    instructionsMsg5 BYTE "Objective: Pick up passengers and", 0
    instructionsMsg6 BYTE "drop them at destinations (GREEN)", 0
    instructionsMsg7 BYTE "Points: +10 per successful drop", 0
    instructionsMsg8 BYTE "         +10 bonus items", 0
    instructionsMsg9 BYTE "         -5 hit passenger", 0
    instructionsMsg10 BYTE "Avoid obstacles and other cars!", 0
    
    ; TAXI SELECTION 
    taxiSelectMsg1 BYTE "Select Taxi Color:", 0
    taxiSelectMsg2 BYTE "1. Yellow Taxi (Fast)", 0
    taxiSelectMsg3 BYTE "2. Red Taxi (Strong)", 0
    taxiSelectMsg4 BYTE "3. Random", 0
    taxiSelectMsg5 BYTE "Choice: ", 0
    
    namePrompt BYTE "Enter your name: ", 0
    
    ;  DIFFICULTY LEVELS 
    difficultyMsg1 BYTE "Select Difficulty:", 0
    difficultyMsg2 BYTE "1. Easy", 0
    difficultyMsg3 BYTE "2. Medium", 0
    difficultyMsg4 BYTE "3. Hard", 0
    difficultyMsg5 BYTE "Choice: ", 0
    
    ;  GAME MODE SELECTION 
    modeMsg1 BYTE "Select Game Mode:", 0
    modeMsg2 BYTE "1. Career Mode", 0
    modeMsg3 BYTE "2. Time Mode", 0
    modeMsg4 BYTE "3. Endless Mode", 0
    modeMsg5 BYTE "Choice: ", 0
    
    ;  LEADERBOARD 
    leaderboardFile BYTE "highscores.txt", 0
    leaderboardTitle BYTE " LEADERBOARD ", 0
    noScoresMsg BYTE "No high scores yet!", 0
    
    ;  SAVE/LOAD 
    saveFile BYTE "savegame.txt", 0
    saveMsg BYTE "Game saved successfully!", 0
    loadMsg BYTE "Game loaded successfully!", 0
    noSaveMsg BYTE "No saved game found!", 0
    pausedMsg BYTE "GAME PAUSED - Press P to continue", 0
    
    ;  GAME CONSTANTS 
    BOARD_SIZE = 20
    MAX_PASSENGERS = 5
    MIN_PASSENGERS = 3
    
    ;  PLAYER DATA 
    playerName BYTE 50 DUP(0)
    playerScore DWORD 0
    taxiColor BYTE 0
    gameMode BYTE 1
    difficulty BYTE 1
    gamePaused BYTE 0
    gameRunning BYTE 0
    taxiX BYTE 0
    taxiY BYTE 0
    hasPassenger BYTE 0
    passengerDestX BYTE 0
    passengerDestY BYTE 0
    passengersDelivered DWORD 0
    
    ;  BOARD DATA 
    board BYTE 400 DUP(0)
    
    ;  PASSENGERS 
    passengerCount BYTE 0
    passengerX BYTE 5 DUP(0)
    passengerY BYTE 5 DUP(0)
    passengerActive BYTE 5 DUP(0)
    
    
    ;  OBSTACLES 
    obstacleCount BYTE 0
    obstacleX BYTE 15 DUP(0)
    obstacleY BYTE 15 DUP(0)
    obstacleType BYTE 15 DUP(0)

    ;  NPC CARS 
    npcCarCount BYTE 0
    npcCarX BYTE 8 DUP(0)
    npcCarY BYTE 8 DUP(0)
    npcCarDir BYTE 8 DUP(0)
    npcCarType BYTE 8 DUP(0)
    
    ;  BONUS ITEMS 
    bonusCount BYTE 0
    bonusX BYTE 5 DUP(0)
    bonusY BYTE 5 DUP(0)
    bonusActive BYTE 5 DUP(0)
    
    ;  GAME MESSAGES 
    scoreMsg BYTE "Score: ", 0
    passengersMsg BYTE "Passengers: ", 0
    escapeMsg BYTE "ESC: Main Menu", 0
    
    ;  LEADERBOARD DATA 
    highScoreNames BYTE 500 DUP(0)
    highScores DWORD 10 DUP(0)
    highScoreCount BYTE 0
    
    ;  TEMPORARY VARIABLES 
    choice BYTE 0
    fileHandle DWORD 0
    tempBuffer BYTE 100 DUP(0)
    tempX BYTE 0
    tempY BYTE 0
    moveCounter DWORD 0
    keyPressed WORD 0
    tempValue BYTE 0

       ; LEGENDS
    legendTaxi BYTE " T = Taxi  ", 0
    legendPassenger BYTE " P = Passenger  ", 0  
    legendDest BYTE " D = Destination  ", 0
    legendTree BYTE " ", 5, " = Tree  ", 0      ; ASCII 5 for tree
    legendBox BYTE " ", 4, " = Box  ", 0        ; ASCII 4 for box
    legendCar BYTE " C = Other Car  ", 0
    legendBonus BYTE " $ = Bonus  ", 0
    carryingMsg BYTE "Carrying Passenger", 0

    ;  COLOR CONSTANTS 
    TITLE_COLOR = 14        ; yellow
    MENU_COLOR = 11          ; light Cyan
    OPTION_COLOR = 7        ; White
    PROMPT_COLOR = 10   ; light green
    ERROR_COLOR = 12   ; light Red
    INFO_COLOR = 9    ; light blue
    SCORE_COLOR = 13    ;light magenta
    LEGEND_COLOR = 8 ; grey

    TAXI_YELLOW = 14  
    TAXI_RED = 12       
    PASSENGER_COLOR = 11   
    DESTINATION_COLOR = 10 
    TREE_COLOR = 2        
    BOX_COLOR = 6         
    NPC_CAR_COLOR = 5       
    BONUS_COLOR = 14        
    WALL_COLOR = 8    
    ROAD_COLOR = 7          
    RED_TAXI_SELECTED = 12   
    YELLOW_TAXI_SELECTED = 14 

.code
main PROC
    call Randomize
      ; Sometimes Randomize doesn't work on first call
    ; Had to add delay here earlier
    
MainMenuLoop:
    call DisplayMenu
    call ReadChar
    mov choice, al
    
    cmp choice, '1'
    je StartNewGame
    cmp choice, '2'
    je ContinueGame
    cmp choice, '3'
    je ChangeDifficulty
    cmp choice, '4'
    je ViewLeaderboard
    cmp choice, '5'
    je ShowInstructions
    cmp choice, '6'
    je ExitGame
    jmp MainMenuLoop
    
StartNewGame:
    call InitNewGame
    call GameLoop
    jmp MainMenuLoop
    
ContinueGame:
    call LoadGame
    cmp eax, 0
    je MainMenuLoop
    call GameLoop
    jmp MainMenuLoop
    
ChangeDifficulty:
    call SelectDifficulty
    jmp MainMenuLoop
    
ViewLeaderboard:
    call DisplayLeaderboard
    call WaitMsg
    jmp MainMenuLoop
    
ShowInstructions:
    call Clrscr
    
    ; Title color
    mov eax, TITLE_COLOR
    call SetTextColor
    
    mov edx, OFFSET instructionsMsg1
    call WriteString
    call Crlf
    call Crlf
    
    ; Instructions color
    mov eax, INFO_COLOR
    call SetTextColor
    
    mov edx, OFFSET instructionsMsg2
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET instructionsMsg3
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET instructionsMsg4
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET instructionsMsg5
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET instructionsMsg6
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET instructionsMsg7
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET instructionsMsg8
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET instructionsMsg9
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET instructionsMsg10
    call WriteString
    call Crlf
    call Crlf
    
    ; Reset color and wait
    mov eax, 7
    call SetTextColor
    
    call WaitMsg
    jmp MainMenuLoop
    
ExitGame:
    exit
    
main ENDP

DisplayMenu PROC
    call Clrscr

    ; Took me 3 tries to get colors right
    ; The formula kept giving wrong results
    
    ; Display title with color and spacing
    mov eax, TITLE_COLOR
    call SetTextColor
    
    mov edx, OFFSET titleMsg
    call WriteString
    call Crlf
    
    mov edx, OFFSET titleMsg2
    call WriteString
    call Crlf
    
    mov edx, OFFSET titleMsg3
    call WriteString
    call Crlf
    call Crlf
    call Crlf  ; Extra spacing
    
    ; Display menu options with different color
    mov eax, MENU_COLOR
    call SetTextColor
    
    mov edx, OFFSET menuMsg1
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET menuMsg2
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET menuMsg3
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET menuMsg4
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET menuMsg5
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET menuMsg6
    call WriteString
    call Crlf
    call Crlf
    call Crlf  ; Extra spacing before prompt
    
    ; Display prompt with different color
    mov eax, PROMPT_COLOR
    call SetTextColor
    
    mov edx, OFFSET menuMsg7
    call WriteString
    
    ; Reset to default color
    mov eax, 7
    call SetTextColor
    
    ret
DisplayMenu ENDP

InitNewGame PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    call SelectTaxi
    
    call Clrscr
    
    ; Name prompt with color
    mov eax, PROMPT_COLOR
    call SetTextColor
    mov edx, OFFSET namePrompt
    call WriteString
    
    ; Reset for input
    mov eax, 7
    call SetTextColor
    
    mov edx, OFFSET playerName
    mov ecx, 50
    call ReadString
    
    call SelectGameMode
    
    ; Initialize game variables
    mov playerScore, 0
    mov passengersDelivered, 0
    mov hasPassenger, 0
    mov gameRunning, 1
    mov gamePaused, 0
    mov moveCounter, 0
    
    call GenerateBoard
    call PlaceTaxiStart
    call GeneratePassengers
    call GenerateObstacles
    call GenerateNPCCars
    call GenerateBonusItems
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
InitNewGame ENDP

SelectTaxi PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
SelectTaxiLoop:
    call Clrscr
    
    ; Title
    mov eax, TITLE_COLOR
    call SetTextColor
    mov edx, OFFSET taxiSelectMsg1
    call WriteString
    call Crlf
    call Crlf
    
    mov eax, TAXI_YELLOW
    call SetTextColor
    mov edx, OFFSET taxiSelectMsg2
    call WriteString
    call Crlf
    call Crlf
    
    ; Red Taxi option in red
    mov eax, TAXI_RED
    call SetTextColor
    mov edx, OFFSET taxiSelectMsg3
    call WriteString
    call Crlf
    call Crlf
    
    ; Random option in white
    mov eax, 7
    call SetTextColor
    mov edx, OFFSET taxiSelectMsg4
    call WriteString
    call Crlf
    call Crlf
    call Crlf
    
    ; Prompt
    mov eax, PROMPT_COLOR
    call SetTextColor
    mov edx, OFFSET taxiSelectMsg5
    call WriteString
    
    ; Reset color for input
    mov eax, 7
    call SetTextColor
    
    call ReadChar
    
    cmp al, '1'
    je YellowTaxi
    cmp al, '2'
    je RedTaxi
    cmp al, '3'
    je RandomTaxi
    jmp SelectTaxiLoop
    
YellowTaxi:
    mov taxiColor, 1
    jmp TaxiSelected
    
RedTaxi:
    mov taxiColor, 2
    jmp TaxiSelected
    
RandomTaxi:
    mov eax, 2
    call RandomRange
    add eax, 1
    mov taxiColor, al
    
TaxiSelected:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
SelectTaxi ENDP

SelectDifficulty PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
SelectDiffLoop:
    call Clrscr
    mov edx, OFFSET difficultyMsg1
    call WriteString
    call Crlf
    mov edx, OFFSET difficultyMsg2
    call WriteString
    call Crlf
    mov edx, OFFSET difficultyMsg3
    call WriteString
    call Crlf
    mov edx, OFFSET difficultyMsg4
    call WriteString
    call Crlf
    mov edx, OFFSET difficultyMsg5
    call WriteString
    
    call ReadChar
    
    cmp al, '1'
    jl SelectDiffLoop
    cmp al, '3'
    jg SelectDiffLoop
    
    sub al, '0'
    mov difficulty, al
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
SelectDifficulty ENDP

SelectGameMode PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
SelectModeLoop:
    call Clrscr
    mov edx, OFFSET modeMsg1
    call WriteString
    call Crlf
    mov edx, OFFSET modeMsg2
    call WriteString
    call Crlf
    mov edx, OFFSET modeMsg3
    call WriteString
    call Crlf
    mov edx, OFFSET modeMsg4
    call WriteString
    call Crlf
    mov edx, OFFSET modeMsg5
    call WriteString
    
    call ReadChar
    
    cmp al, '1'
    jl SelectModeLoop
    cmp al, '3'
    jg SelectModeLoop
    
    sub al, '0'
    mov gameMode, al
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
SelectGameMode ENDP

SaveGame PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov edx, OFFSET saveFile
    call CreateOutputFile
    mov fileHandle, eax
    cmp eax, INVALID_HANDLE_VALUE
    je SaveFailed
    
    ; Save player name
    mov eax, fileHandle
    mov edx, OFFSET playerName
    mov ecx, 50
    call WriteToFile
    
    ; Save player score
    mov eax, fileHandle
    mov edx, OFFSET playerScore
    mov ecx, 4
    call WriteToFile
    
    mov eax, fileHandle
    mov edx, OFFSET taxiColor
    mov ecx, 1
    call WriteToFile
    
    ; Save taxi position
    mov eax, fileHandle
    mov edx, OFFSET taxiX
    mov ecx, 2  ; X and Y
    call WriteToFile
    
    ; Save game state
    mov eax, fileHandle
    mov edx, OFFSET hasPassenger
    mov ecx, 1
    call WriteToFile
    
    ; Save destination if carrying passenger
    cmp hasPassenger, 1
    jne SkipDestSave
    mov eax, fileHandle
    mov edx, OFFSET passengerDestX
    mov ecx, 2  ; X and Y
    call WriteToFile
SkipDestSave:
    
    ; Save passengers delivered count
    mov eax, fileHandle
    mov edx, OFFSET passengersDelivered
    mov ecx, 4
    call WriteToFile
    
    ; Save game mode and difficulty
    mov eax, fileHandle
    mov edx, OFFSET gameMode
    mov ecx, 2  ; gameMode and difficulty
    call WriteToFile
    
    mov eax, fileHandle
    call CloseFile
    
    mov edx, OFFSET saveMsg
    call WriteString
    call Crlf
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    mov eax, 1
    ret
    
SaveFailed:
    mov edx, OFFSET noSaveMsg
    call WriteString
    call Crlf
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    mov eax, 0
    ret
SaveGame ENDP

LoadGame PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov edx, OFFSET saveFile
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je LoadFailed
    
    mov fileHandle, eax
    
    mov eax, fileHandle
    mov edx, OFFSET playerName
    mov ecx, 50
    call ReadFromFile
    
    mov eax, fileHandle
    mov edx, OFFSET playerScore
    mov ecx, 4
    call ReadFromFile
    
    mov eax, fileHandle
    mov edx, OFFSET taxiColor
    mov ecx, 1
    call ReadFromFile
    
    mov eax, fileHandle
    call CloseFile
    
    mov gameRunning, 1
    mov gamePaused, 0

     ; Load taxi position
    mov eax, fileHandle
    mov edx, OFFSET taxiX
    mov ecx, 2
    call ReadFromFile
    
    ; Load hasPassenger
    mov eax, fileHandle
    mov edx, OFFSET hasPassenger
    mov ecx, 1
    call ReadFromFile
    
    mov edx, OFFSET loadMsg
    call WriteString
    call Crlf


    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    mov eax, 1
    ret
    
LoadFailed:
    mov edx, OFFSET noSaveMsg
    call WriteString
    call Crlf
    call WaitMsg
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    mov eax, 0
    ret
LoadGame ENDP

DisplayLeaderboard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    call Clrscr
    call LoadLeaderboard
    
    ; Title with color
    mov eax, TITLE_COLOR
    call SetTextColor
    mov edx, OFFSET leaderboardTitle
    call WriteString
    call Crlf
    call Crlf
    
    cmp highScoreCount, 0
    je NoScores
    
    ; Display scores with alternating colors
    mov ecx, 0
    mov cl, highScoreCount
    mov esi, 0
    mov ebx, 0
    
DisplayScoreLoop:
    push ecx
    
    ; Alternate colors for readability
    mov eax, ebx
    and eax, 1
    cmp eax, 0
    je EvenRow
    mov eax, 7  ; White for odd rows
    jmp SetRowColor
EvenRow:
    mov eax, 8  ; Gray for even rows
SetRowColor:
    call SetTextColor
    
    ; Display rank
    mov eax, ebx
    add eax, 1
    call WriteDec
    mov al, '.'
    call WriteChar
    mov al, ' '
    call WriteChar
    
    ; Display name
    mov edx, OFFSET highScoreNames
    add edx, esi
    call WriteString
    
    ; Add spacing
    mov al, ' '
    call WriteChar
    call WriteChar
    
    ; Display separator
    mov al, '-'
    call WriteChar
    mov al, ' '
    call WriteChar
    call WriteChar
    
    ; Display score
    mov eax, [highScores + ebx*4]
    call WriteDec
    call Crlf
    
    add esi, 50
    inc ebx
    pop ecx
    loop DisplayScoreLoop
    
    jmp EndDisplayScores
    
NoScores:
    mov eax, ERROR_COLOR
    call SetTextColor
    mov edx, OFFSET noScoresMsg
    call WriteString
    call Crlf
    
EndDisplayScores:
    ; Reset to default color
    mov eax, 7
    call SetTextColor
    
    call Crlf
    call Crlf
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DisplayLeaderboard ENDP

LoadLeaderboard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov edx, OFFSET leaderboardFile
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je LeaderboardEmpty
    
    mov fileHandle, eax
    
    mov eax, fileHandle
    mov edx, OFFSET highScoreCount
    mov ecx, 1
    call ReadFromFile
    
    cmp highScoreCount, 0
    je CloseLeaderboard
    
    mov eax, fileHandle
    mov edx, OFFSET highScoreNames
    movzx ecx, highScoreCount
    imul ecx, 50
    call ReadFromFile
    
    mov eax, fileHandle
    mov edx, OFFSET highScores
    movzx ecx, highScoreCount
    imul ecx, 4
    call ReadFromFile
    
CloseLeaderboard:
    mov eax, fileHandle
    call CloseFile
    
LeaderboardEmpty:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
LoadLeaderboard ENDP

UpdateLeaderboard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Load existing leaderboard
    call LoadLeaderboard
    
    ; Check if we should update the leaderboard
    cmp highScoreCount, 10
    jge CheckIfHighScore  ; If already 10 scores, check if new score is better
    
    ; Add new score
    movzx eax, highScoreCount
    
    ; Copy name to highScoreNames array
    mov esi, OFFSET playerName
    mov edi, OFFSET highScoreNames
    mov ebx, 50
    mul ebx  ; eax = highScoreCount * 50
    add edi, eax  ; edi points to position for new name
    
    mov ecx, 50
CopyName:
    mov dl, [esi]
    mov [edi], dl
    inc esi     
    inc edi     
    loop CopyName
    
    ; Store score
    movzx ebx, highScoreCount
    mov eax, playerScore
    mov [highScores + ebx*4], eax  
    
    ; Increment count
    inc highScoreCount
    
    jmp SaveLeaderboard
    
CheckIfHighScore:
    ; Find lowest score to replace
    mov ecx, 0
    mov cl, highScoreCount
    mov esi, 0
    mov ebx, 0  ; Will store index of lowest score
    mov eax, [highScores]  ; First score
    
FindLowestLoop:
    mov eax, [highScores + esi*4]  ; Get current score
    cmp eax, [highScores + ebx*4]  ; Compare with current lowest
    jge NotLower
    mov ebx, esi  ; New lowest score index
NotLower:
    inc esi
    loop FindLowestLoop
    
    ; Compare with current player score
    mov eax, playerScore
    cmp eax, [highScores + ebx*4]
    jle UpdateDone  ; Not a high score
    
    ; Replace lowest score with new score
    ; Copy name
    mov esi, OFFSET playerName
    mov edi, OFFSET highScoreNames
    mov eax, ebx
    mov ecx, 50
    mul ecx  ; eax = index * 50
    add edi, eax  ; edi points to position to replace
    
    mov ecx, 50
ReplaceName:
    mov dl, [esi]
    mov [edi], dl
    inc esi
    inc edi
    loop ReplaceName
    
    ; Replace score
    mov eax, playerScore
    mov [highScores + ebx*4], eax
    
SaveLeaderboard:
    ; Save updated leaderboard to file
    mov edx, OFFSET leaderboardFile
    call CreateOutputFile
    mov fileHandle, eax
    cmp eax, INVALID_HANDLE_VALUE
    je UpdateFailed
    
    ; Write count
    mov eax, fileHandle
    mov edx, OFFSET highScoreCount
    mov ecx, 1
    call WriteToFile
    
    ; Write all names
    mov eax, fileHandle
    mov edx, OFFSET highScoreNames
    movzx ecx, highScoreCount
    imul ecx, 50
    call WriteToFile
    
    ; Write all scores
    mov eax, fileHandle
    mov edx, OFFSET highScores
    movzx ecx, highScoreCount
    imul ecx, 4
    call WriteToFile
    
    mov eax, fileHandle
    call CloseFile
    
UpdateFailed:
UpdateDone:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
UpdateLeaderboard ENDP

MoveNPCCars PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov ecx, 0
    mov cl, npcCarCount
    mov esi, 0
    
MoveNPCLoop:
    cmp ecx, 0
    je MoveNPCDone
    
    ; Get current direction
    mov al, [npcCarDir + esi]
    
    ; Save current position
    mov bl, [npcCarX + esi]
    mov bh, [npcCarY + esi]
    
    cmp al, 0  ; Up
    je MoveNPCUp
    cmp al, 1  ; Down
    je MoveNPCDown
    cmp al, 2  ; Left
    je MoveNPCLeft
    cmp al, 3  ; Right
    je MoveNPCRight
    
MoveNPCUp:
    dec bh
    jmp CheckNPCMove
    
MoveNPCDown:
    inc bh
    jmp CheckNPCMove
    
MoveNPCLeft:
    dec bl
    jmp CheckNPCMove
    
MoveNPCRight:
    inc bl
    
CheckNPCMove:
    ; Check if new position is valid
    mov tempX, bl
    mov tempY, bh
    
    ; Check bounds
    cmp bl, 0
    jl ChangeNPCDir
    cmp bl, 19
    jg ChangeNPCDir
    cmp bh, 0
    jl ChangeNPCDir
    cmp bh, 19
    jg ChangeNPCDir
    
    ; Check if it's a road
    call IsRoad
    cmp al, 0
    jne ChangeNPCDir
    
    ; Check if position is free (not occupied by another NPC or obstacle)
    push eax
    call CheckPositionFree
    cmp eax, 0
    pop eax
    je ChangeNPCDir
    
    ; Move the NPC car
    mov [npcCarX + esi], bl
    mov [npcCarY + esi], bh
    jmp NextNPC
    
ChangeNPCDir:
    ; Change direction randomly
    mov eax, 4
    call RandomRange
    mov [npcCarDir + esi], al
    
NextNPC:
    inc esi
    dec ecx
    jmp MoveNPCLoop
    
MoveNPCDone:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
MoveNPCCars ENDP


PauseGame PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov gamePaused, 1
    call Clrscr
    mov edx, OFFSET pausedMsg
    call WriteString
    call Crlf
    
PauseLoop:
    call ReadChar
    cmp al, 'p'
    je UnpauseGame
    cmp al, 'P'
    je UnpauseGame
    jmp PauseLoop
    
UnpauseGame:
    mov gamePaused, 0
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
PauseGame ENDP

GenerateBoard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Clear entire board with 0 (roads)
    mov ecx, 400
    mov edi, OFFSET board
    mov al, 0
ClearBoard:
    mov [edi], al
    inc edi
    loop ClearBoard
    
    ; Create border walls (1 = wall) - Only outer border
    mov ecx, 20
    mov esi, 0
CreateBorder:
    ; Top border (row 0)
    mov [board + esi], byte ptr 1
    
    ; Bottom border (row 19)
    mov [board + 380 + esi], byte ptr 1
    
    ; Left border (column 0)
    mov eax, esi
    mov ebx, 20
    mul ebx
    mov [board + eax], byte ptr 1
    
    ; Right border (column 19)
    mov [board + eax + 19], byte ptr 1
    
    inc esi
    loop CreateBorder
    
    ; Remove internal walls - keep only the outer border
    ; All internal positions should be roads (0)
    
    ; Create some decorative obstacles near edges (not blocking main paths)
    ; These will be obstacles that taxi can navigate around
    
    ; Top-left corner obstacles (small cluster)
    mov [board + 2*20 + 2], byte ptr 1
    mov [board + 2*20 + 3], byte ptr 1
    mov [board + 3*20 + 2], byte ptr 1
    
    ; Top-right corner obstacles
    mov [board + 2*20 + 16], byte ptr 1
    mov [board + 2*20 + 17], byte ptr 1
    mov [board + 3*20 + 17], byte ptr 1
    
    ; Bottom-left corner obstacles
    mov [board + 16*20 + 2], byte ptr 1
    mov [board + 16*20 + 3], byte ptr 1
    mov [board + 17*20 + 2], byte ptr 1
    
    ; Bottom-right corner obstacles
    mov [board + 16*20 + 16], byte ptr 1
    mov [board + 16*20 + 17], byte ptr 1
    mov [board + 17*20 + 17], byte ptr 1
    
    ; Center area - keep clear for taxi movement
    ; Create 4 small obstacle islands that don't block paths
    
    ; Island 1: Top-center
    mov [board + 4*20 + 9], byte ptr 1
    mov [board + 4*20 + 10], byte ptr 1
    
    ; Island 2: Bottom-center
    mov [board + 15*20 + 9], byte ptr 1
    mov [board + 15*20 + 10], byte ptr 1
    
    ; Island 3: Left-center
    mov [board + 9*20 + 4], byte ptr 1
    mov [board + 10*20 + 4], byte ptr 1
    
    ; Island 4: Right-center
    mov [board + 9*20 + 15], byte ptr 1
    mov [board + 10*20 + 15], byte ptr 1
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
GenerateBoard ENDP

PlaceTaxiStart PROC
    mov taxiX, 10
    mov taxiY, 10
    ret
PlaceTaxiStart ENDP

IsRoad PROC
    push ebx
    push edx
    
    ; Check bounds first
    mov al, tempX
    cmp al, 0
    jl NotRoad
    cmp al, 19
    jg NotRoad
    mov al, tempY
    cmp al, 0
    jl NotRoad
    cmp al, 19
    jg NotRoad
    
    ; Calculate board position
    movzx eax, tempY
    mov ebx, 20
    mul ebx
    movzx ebx, tempX
    add eax, ebx
    
    ; Check board value
    mov dl, [board + eax]
    cmp dl, 0
    je IsRoadTrue
    
    ; It's a wall or obstacle
NotRoad:
    mov al, 1        ; 1 = not road (wall/obstacle)
    jmp IsRoadDone
    
IsRoadTrue:
    mov al, 0        ; 0 = road
    
IsRoadDone:
    pop edx
    pop ebx
    ret
IsRoad ENDP

CheckPositionFree PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov al, taxiX
    cmp al, tempX
    jne CheckPassengers
    mov al, taxiY
    cmp al, tempY
    jne CheckPassengers
    jmp PositionNotFree
    
CheckPassengers:
    mov ecx, 0
    mov cl, passengerCount
    mov esi, 0
CheckPassLoop:
    cmp ecx, 0
    je CheckObstacles
    mov al, [passengerX + esi]
    cmp al, tempX
    jne NextPass
    mov al, [passengerY + esi]
    cmp al, tempY
    jne NextPass
    jmp PositionNotFree
NextPass:
    inc esi
    dec ecx
    jmp CheckPassLoop
    
CheckObstacles:
    mov ecx, 0
    mov cl, obstacleCount
    mov esi, 0
CheckObsLoop:
    cmp ecx, 0
    je CheckNPC
    mov al, [obstacleX + esi]
    cmp al, tempX
    jne NextObs
    mov al, [obstacleY + esi]
    cmp al, tempY
    jne NextObs
    jmp PositionNotFree
NextObs:
    inc esi
    dec ecx
    jmp CheckObsLoop
    
CheckNPC:
    mov ecx, 0
    mov cl, npcCarCount
    mov esi, 0
CheckNPCLoop:
    cmp ecx, 0
    je PositionFree
    mov al, [npcCarX + esi]
    cmp al, tempX
    jne NextNPC
    mov al, [npcCarY + esi]
    cmp al, tempY
    jne NextNPC
    jmp PositionNotFree
NextNPC:
    inc esi
    dec ecx
    jmp CheckNPCLoop
    
PositionFree:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    mov eax, 1
    ret
    
PositionNotFree:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    mov eax, 0
    ret
CheckPositionFree ENDP

GeneratePassengers PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov passengerCount, 3
    
    ; Fixed passenger positions
    ; Passenger 1 at (3,3)
    mov [passengerX + 0], byte ptr 3
    mov [passengerY + 0], byte ptr 3
    mov [passengerActive + 0], byte ptr 1
    
    ; Passenger 2 at (3,16)
    mov [passengerX + 1], byte ptr 3
    mov [passengerY + 1], byte ptr 16
    mov [passengerActive + 1], byte ptr 1
    
    ; Passenger 3 at (16,3)
    mov [passengerX + 2], byte ptr 16
    mov [passengerY + 2], byte ptr 3
    mov [passengerActive + 2], byte ptr 1
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
GeneratePassengers ENDP

GenerateObstacles PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov obstacleCount, 8  ; Fixed number of obstacles
    
    ; Fixed obstacle positions (on roads, not walls)
    ; Obstacle 1 - Tree at (2,2)
    mov [obstacleX + 0], byte ptr 2
    mov [obstacleY + 0], byte ptr 2
    mov [obstacleType + 0], byte ptr 1  ; Tree
    
    ; Obstacle 2 - Box at (2,17)
    mov [obstacleX + 1], byte ptr 2
    mov [obstacleY + 1], byte ptr 17
    mov [obstacleType + 1], byte ptr 2  ; Box
    
    ; Obstacle 3 - Tree at (5,8)
    mov [obstacleX + 2], byte ptr 5
    mov [obstacleY + 2], byte ptr 8
    mov [obstacleType + 2], byte ptr 1  ; Tree
    
    ; Obstacle 4 - Box at (5,11)
    mov [obstacleX + 3], byte ptr 5
    mov [obstacleY + 3], byte ptr 11
    mov [obstacleType + 3], byte ptr 2  ; Box
    
    ; Obstacle 5 - Tree at (8,5)
    mov [obstacleX + 4], byte ptr 8
    mov [obstacleY + 4], byte ptr 5
    mov [obstacleType + 4], byte ptr 1  ; Tree
    
    ; Obstacle 6 - Box at (8,14)
    mov [obstacleX + 5], byte ptr 8
    mov [obstacleY + 5], byte ptr 14
    mov [obstacleType + 5], byte ptr 2  ; Box
    
    ; Obstacle 7 - Tree at (11,8)
    mov [obstacleX + 6], byte ptr 11
    mov [obstacleY + 6], byte ptr 8
    mov [obstacleType + 6], byte ptr 1  ; Tree
    
    ; Obstacle 8 - Box at (11,11)
    mov [obstacleX + 7], byte ptr 11
    mov [obstacleY + 7], byte ptr 11
    mov [obstacleType + 7], byte ptr 2  ; Box
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
GenerateObstacles ENDP

GenerateNPCCars PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov npcCarCount, 3
    
    mov ecx, 3
    mov esi, 0
GenNPCLoop:
    push ecx
    
FindNPCPos:
    mov eax, 18
    call RandomRange
    add eax, 1
    mov tempX, al
    
    mov eax, 18
    call RandomRange
    add eax, 1
    mov tempY, al
    
    call IsRoad
    cmp al, 0
    jne FindNPCPos
    
    push eax
    call CheckPositionFree
    cmp eax, 0
    pop eax
    je FindNPCPos
    
    mov al, tempX
    mov [npcCarX + esi], al
    mov al, tempY
    mov [npcCarY + esi], al
    
    ; All NPC cars are type 1 (regular car)
    mov [npcCarType + esi], byte ptr 1
    
    ; Random direction
    mov eax, 4
    call RandomRange
    mov [npcCarDir + esi], al
    
    inc esi
    pop ecx
    loop GenNPCLoop
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
GenerateNPCCars ENDP

GenerateBonusItems PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov bonusCount, 2
    
    ; Fixed bonus positions
    ; Bonus 1 at (4,4)
    mov [bonusX + 0], byte ptr 4
    mov [bonusY + 0], byte ptr 4
    mov [bonusActive + 0], byte ptr 1
    
    ; Bonus 2 at (15,15)
    mov [bonusX + 1], byte ptr 15
    mov [bonusY + 1], byte ptr 15
    mov [bonusActive + 1], byte ptr 1
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
GenerateBonusItems ENDP

GameLoop PROC
    call Clrscr
    
GameLoopStart:
    cmp gameRunning, 0
    je GameLoopEnd

    call DisplayGame

    inc moveCounter
    mov eax, moveCounter
    and eax, 3  ; Move NPCs every 4th frame (adjust for speed)
    cmp eax, 0
    jne SkipNPCMove
    call MoveNPCCars
SkipNPCMove:
    
    call ReadKey
    jz NoKeyPressed
    
    mov keyPressed, ax

    ; Check for ESC key (ASCII 1Bh or scan code 01h)
    cmp al, 1Bh      ; ESC key ASCII
    je ReturnToMenu
    cmp ah, 01h      ; ESC key scan code
    je ReturnToMenu
    
    cmp al, 'p'
    je DoPause
    cmp al, 'P'
    je DoPause
    cmp al, ' '
    je DoSpacebar
    cmp ah, 48h
    je DoUp
    cmp ah, 50h
    je DoDown
    cmp ah, 4Bh
    je DoLeft
    cmp ah, 4Dh
    je DoRight
    jmp NoKeyPressed

ReturnToMenu:
    mov gameRunning, 0
    jmp GameLoopEnd

DoPause:
    call PauseGame
    jmp GameLoopStart

DoSpacebar:
    call HandleSpacebar
    jmp NoKeyPressed

DoUp:
    call MoveTaxiUp
    jmp NoKeyPressed

DoDown:
    call MoveTaxiDown
    jmp NoKeyPressed

DoLeft:
    call MoveTaxiLeft
    jmp NoKeyPressed

DoRight:
    call MoveTaxiRight

NoKeyPressed:
    mov eax, 100
    call Delay
    jmp GameLoopStart

GameLoopEnd:
    ; Only update leaderboard if game ended normally (not by ESC)
    cmp gameRunning, 0
    jne SkipLeaderboardUpdate
    mov eax, playerScore
    cmp eax, 0
    jle SkipLeaderboardUpdate
    call UpdateLeaderboard
SkipLeaderboardUpdate:
    ret
GameLoop ENDP

DisplayGame PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ; Display score at top
    mov dl, 0
    mov dh, 0
    call Gotoxy
    
    mov eax, SCORE_COLOR
    call SetTextColor
    mov edx, OFFSET scoreMsg
    call WriteString

     ; checking if score is negative
    mov eax, playerScore
    test eax, eax
    jns DisplayPositiveScore
    
    ; Display negative sign
    push eax
    mov al, '-'
    call WriteChar
    pop eax
    
    ; Convert to positive for display
    neg eax
    
DisplayPositiveScore:
    call WriteDec
    
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    
    mov edx, OFFSET passengersMsg
    call WriteString
    mov eax, passengersDelivered
    call WriteDec
    
    cmp hasPassenger, 1
    jne NoPassengerDisplay
    
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    
    mov eax, 10
    call SetTextColor
    mov edx, OFFSET carryingMsg
    call WriteString
    
NoPassengerDisplay:
    ; Display escape hint at top right
    mov dl, 50
    mov dh, 0
    call Gotoxy
    
    mov eax, 12  ; Light Red for escape key
    call SetTextColor
    mov edx, OFFSET escapeMsg
    call WriteString
    
    call Crlf
    call Crlf
    
    mov eax, 7
    call SetTextColor
    
    ; Rest of the display code remains the same...
    mov ebx, 0
DisplayRowLoop:
    mov ecx, 0
DisplayColLoop:
    mov tempX, cl
    mov tempY, bl
    
    call GetDisplayChar
    call WriteChar
    mov al, ' '
    call WriteChar
    
    inc ecx
    cmp ecx, BOARD_SIZE
    jl DisplayColLoop
    
    call Crlf
    inc ebx
    cmp ebx, BOARD_SIZE
    jl DisplayRowLoop

     ; Display legend
    call Crlf
    call Crlf
    
    mov eax, LEGEND_COLOR
    call SetTextColor
    mov edx, OFFSET legendTaxi
    call WriteString
    
    mov eax, 11
    call SetTextColor
    mov edx, OFFSET legendPassenger
    call WriteString
    
    mov eax, 10
    call SetTextColor
    mov edx, OFFSET legendDest
    call WriteString
    
    call Crlf
    
    mov eax, 2  ; Green
    call SetTextColor
    mov edx, OFFSET legendTree
    call WriteString
    
    mov eax, 6  ; Brown
    call SetTextColor
    mov edx, OFFSET legendBox
    call WriteString
    
    mov eax, 5  ; Purple
    call SetTextColor
    mov edx, OFFSET legendCar
    call WriteString
    
    mov eax, 14 ; Yellow
    call SetTextColor
    mov edx, OFFSET legendBonus
    call WriteString
    
    mov eax, 7
    call SetTextColor

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DisplayGame ENDP

GetDisplayChar PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ; Check for taxi first
    mov al, taxiX
    cmp al, tempX
    jne CheckPassengerDisplay
    mov al, taxiY
    cmp al, tempY
    jne CheckPassengerDisplay
    
    ; Display taxi with color based on taxiColor
    mov al, taxiColor
    cmp al, 1
    je DisplayYellowTaxi
    cmp al, 2
    je DisplayRedTaxi
    
DisplayYellowTaxi:
    mov eax, TAXI_YELLOW
    call SetTextColor
    mov al, 'T'
    jmp DisplayCharDone
    
DisplayRedTaxi:
    mov eax, TAXI_RED
    call SetTextColor
    mov al, 'T'
    jmp DisplayCharDone

CheckPassengerDisplay:
    mov ecx, 0
    mov cl, passengerCount
    mov esi, 0
CheckPassDisp:
    cmp ecx, 0
    je CheckDestDisplay
    dec ecx
    mov al, [passengerActive + esi]
    cmp al, 0
    je NextPassDisp
    mov al, [passengerX + esi]
    cmp al, tempX
    jne NextPassDisp
    mov al, [passengerY + esi]
    cmp al, tempY
    jne NextPassDisp
    
    mov eax, PASSENGER_COLOR
    call SetTextColor
    mov al, 'P'
    jmp DisplayCharDone
    
NextPassDisp:
    inc esi
    jmp CheckPassDisp

CheckDestDisplay:
    cmp hasPassenger, 1
    jne CheckObstacleDisplay
    mov al, passengerDestX
    cmp al, tempX
    jne CheckObstacleDisplay
    mov al, passengerDestY
    cmp al, tempY
    jne CheckObstacleDisplay
    
    mov eax, DESTINATION_COLOR
    call SetTextColor
    mov al, 'D'
    jmp DisplayCharDone

CheckObstacleDisplay:
    mov ecx, 0
    mov cl, obstacleCount
    mov esi, 0
CheckObsDisp:
    cmp ecx, 0
    je CheckNPCDisplay
    dec ecx
    mov al, [obstacleX + esi]
    cmp al, tempX
    jne NextObsDisp
    mov al, [obstacleY + esi]
    cmp al, tempY
    jne NextObsDisp
    
    mov al, [obstacleType + esi]
    cmp al, 1
    je TreeDisplay
    cmp al, 2
    je BoxDisplay
    
TreeDisplay:
    mov eax, TREE_COLOR
    call SetTextColor
    mov al, 5   ; Tree symbol (ASCII 5)
    jmp DisplayCharDone
    
BoxDisplay:
    mov eax, BOX_COLOR
    call SetTextColor
    mov al, 4   ; Diamond symbol (ASCII 4)
    jmp DisplayCharDone
    
NextObsDisp:
    inc esi
    jmp CheckObsDisp

CheckNPCDisplay:
    mov ecx, 0
    mov cl, npcCarCount
    mov esi, 0
CheckNPCDisp:
    cmp ecx, 0
    je CheckBonusDisplay
    dec ecx
    mov al, [npcCarX + esi]
    cmp al, tempX
    jne NextNPCDisp
    mov al, [npcCarY + esi]
    cmp al, tempY
    jne NextNPCDisp
    
    mov eax, NPC_CAR_COLOR
    call SetTextColor
    mov al, 'C'
    jmp DisplayCharDone
    
NextNPCDisp:
    inc esi
    jmp CheckNPCDisp

CheckBonusDisplay:
    mov ecx, 0
    mov cl, bonusCount
    mov esi, 0
CheckBonusDisp:
    cmp ecx, 0
    je CheckBoardDisplay
    dec ecx
    mov al, [bonusActive + esi]
    cmp al, 0
    je NextBonusDisp
    mov al, [bonusX + esi]
    cmp al, tempX
    jne NextBonusDisp
    mov al, [bonusY + esi]
    cmp al, tempY
    jne NextBonusDisp
    
    mov eax, BONUS_COLOR
    call SetTextColor
    mov al, '$'
    jmp DisplayCharDone
    
NextBonusDisp:
    inc esi
    jmp CheckBonusDisp

CheckBoardDisplay:
    call IsRoad
    cmp al, 0
    je IsRoadChar
    
    ; It's a wall or obstacle tile from the board
    mov eax, WALL_COLOR
    call SetTextColor
    mov al, 178     ; Wall character
    jmp DisplayCharDone

IsRoadChar:
    mov eax, ROAD_COLOR
    call SetTextColor
    mov al, '.'     ; Road character

DisplayCharDone:
    mov tempValue, al
    mov eax, 7      ; Reset to default color
    call SetTextColor
    mov al, tempValue
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
GetDisplayChar ENDP

MoveTaxiUp PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov al, taxiY
    cmp al, 1
    jle CannotMoveUp
    
    mov al, taxiY
    dec al
    mov tempY, al
    mov al, taxiX
    mov tempX, al
    
    call IsRoad
    cmp al, 0
    jne CannotMoveUp
    
    ; Check for collision and deduct points if any
    call CheckCollision
    
    ; Check if position is free (except for taxi itself)
    push eax
    call CheckPositionFree
    cmp eax, 0
    pop eax
    je CannotMoveUp
    
    ; Move the taxi
    mov al, tempY
    mov taxiY, al
    
CannotMoveUp:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
MoveTaxiUp ENDP

MoveTaxiDown PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov al, taxiY
    cmp al, 19
    jge CannotMoveDown
    
    mov al, taxiY
    inc al
    mov tempY, al
    mov al, taxiX
    mov tempX, al
    
    call IsRoad
    cmp al, 0
    jne CannotMoveDown
    
    push eax
    call CheckPositionFree
    cmp eax, 0
    pop eax
    je CannotMoveDown
    
    call CheckCollision
    cmp eax, 0
    je CannotMoveDown
    
    mov al, tempY
    mov taxiY, al
    
CannotMoveDown:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
MoveTaxiDown ENDP

MoveTaxiLeft PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov al, taxiX
    cmp al, 0
    je CannotMoveLeft
    
    mov al, taxiX
    dec al
    mov tempX, al
    mov al, taxiY
    mov tempY, al
    
    call IsRoad
    cmp al, 0
    jne CannotMoveLeft
    
    push eax
    call CheckPositionFree
    cmp eax, 0
    pop eax
    je CannotMoveLeft
    
    call CheckCollision
    cmp eax, 0
    je CannotMoveLeft
    
    mov al, tempX
    mov taxiX, al
    
CannotMoveLeft:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
MoveTaxiLeft ENDP

MoveTaxiRight PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov al, taxiX
    cmp al, 19
    jge CannotMoveRight
    
    mov al, taxiX
    inc al
    mov tempX, al
    mov al, taxiY
    mov tempY, al
    
    call IsRoad
    cmp al, 0
    jne CannotMoveRight
    
    push eax
    call CheckPositionFree
    cmp eax, 0
    pop eax
    je CannotMoveRight
    
    call CheckCollision
    cmp eax, 0
    je CannotMoveRight
    
    mov al, tempX
    mov taxiX, al
    
CannotMoveRight:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
    MoveTaxiRight ENDP     
    
CheckCollision PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ecx, 0
    mov cl, passengerCount
    mov esi, 0
    
CheckPassColl:
    cmp ecx, 0
    je CheckObsColl
    dec ecx
    
    mov al, [passengerActive + esi]
    cmp al, 0
    je NextPassColl
    mov al, [passengerX + esi]
    cmp al, tempX
    jne NextPassColl
    mov al, [passengerY + esi]
    cmp al, tempY
    jne NextPassColl
    
    ; Hit a person: -5 points
    mov eax, playerScore
    sub eax, 5
    mov playerScore, eax
    jmp CollisionFound
    
NextPassColl:
    inc esi
    jmp CheckPassColl

CheckObsColl:
    mov ecx, 0
    mov cl, obstacleCount
    mov esi, 0
    
CheckObsCollLoop:
    cmp ecx, 0
    je CheckNPCColl
    dec ecx
    
    mov al, [obstacleX + esi]
    cmp al, tempX
    jne NextObsColl
    mov al, [obstacleY + esi]
    cmp al, tempY
    jne NextObsColl
    
    ; here we are to check taxi color for obstacle collision
    mov al, taxiColor
    cmp al, 1          
    je YellowTaxiObs
    cmp al, 2      
    je RedTaxiObs
    jmp NextObsColl    
    
YellowTaxiObs:
    ; Yellow taxi hits obstacle: -4 points
    mov eax, playerScore
    sub eax, 4
    mov playerScore, eax
    jmp CollisionFound
    
RedTaxiObs:
    ; Red taxi hits obstacle: -2 points
    mov eax, playerScore
    sub eax, 2
    mov playerScore, eax
    jmp CollisionFound
    
NextObsColl:
    inc esi
    jmp CheckObsCollLoop

CheckNPCColl:
    mov ecx, 0
    mov cl, npcCarCount
    mov esi, 0
    
CheckNPCCollLoop:
    cmp ecx, 0
    je CheckBonusColl
    dec ecx
    
    mov al, [npcCarX + esi]
    cmp al, tempX
    jne NextNPCColl
    mov al, [npcCarY + esi]
    cmp al, tempY
    jne NextNPCColl
    
    ; Check taxi color for car collision
    mov al, taxiColor
    cmp al, 1         
    je YellowTaxiCar
    cmp al, 2         
    je RedTaxiCar
    jmp NextNPCColl    
    
YellowTaxiCar:
    ; Yellow taxi hits car: -2 points
    mov eax, playerScore
    sub eax, 2
    mov playerScore, eax
    jmp CollisionFound
    
RedTaxiCar:
    ; Red taxi hits car: -3 points
    mov eax, playerScore
    sub eax, 3
    mov playerScore, eax
    jmp CollisionFound
    
NextNPCColl:
    inc esi
    jmp CheckNPCCollLoop

CheckBonusColl:
    mov ecx, 0
    mov cl, bonusCount
    mov esi, 0
    
CheckBonusCollLoop:
    cmp ecx, 0
    je NoCollision
    dec ecx
    
    mov al, [bonusActive + esi]
    cmp al, 0
    je NextBonusColl
    mov al, [bonusX + esi]
    cmp al, tempX
    jne NextBonusColl
    mov al, [bonusY + esi]
    cmp al, tempY
    jne NextBonusColl
    
    ; Collect bonus: +10 points
    mov [bonusActive + esi], byte ptr 0
    mov eax, playerScore
    add eax, 10
    mov playerScore, eax
    
NextBonusColl:
    inc esi
    jmp CheckBonusCollLoop

NoCollision:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    mov eax, 1
    ret

CollisionFound:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    mov eax, 0
    ret
CheckCollision ENDP

HandleSpacebar PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    cmp hasPassenger, 0
    je TryPickup
    
    mov al, taxiX
    cmp al, passengerDestX
    jne CannotDrop
    mov al, taxiY
    cmp al, passengerDestY
    jne CannotDrop
    
    mov hasPassenger, 0
    mov eax, playerScore
    add eax, 10
    mov playerScore, eax
    mov eax, passengersDelivered
    add eax, 1
    mov passengersDelivered, eax
    jmp CannotDrop
    
TryPickup:
    mov ecx, 0
    mov cl, passengerCount
    mov esi, 0
CheckPickupLoop:
    cmp ecx, 0
    je CannotDrop
    mov al, [passengerActive + esi]
    cmp al, 0
    je NextPickup
    mov al, [passengerX + esi]
    mov ah, taxiX
    sub al, ah
    cmp al, -1
    jl NextPickup
    cmp al, 1
    jg NextPickup
    mov al, [passengerY + esi]
    mov ah, taxiY
    sub al, ah
    cmp al, -1
    jl NextPickup
    cmp al, 1
    jg NextPickup
    
    mov [passengerActive + esi], byte ptr 0
    mov hasPassenger, 1
    call GenerateDestination
    jmp CannotDrop
    
NextPickup:
    inc esi
    dec ecx
    jmp CheckPickupLoop
    
CannotDrop:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
HandleSpacebar ENDP

GenerateDestination PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
GenDestLoop:
    mov eax, 18
    call RandomRange
    add eax, 1
    mov passengerDestX, al
    mov tempX, al
    
    mov eax, 18
    call RandomRange
    add eax, 1
    mov passengerDestY, al
    mov tempY, al
    
    call IsRoad
    cmp al, 0
    jne GenDestLoop
    
    mov al, taxiX
    cmp al, tempX
    jne DestOk
    mov al, taxiY
    cmp al, tempY
    je GenDestLoop
    
DestOk:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
GenerateDestination ENDP

END main