include ProjectMacros.asm
.model huge
.stack 64

.data
;PUR DB 0
;P1POWER DB 0 
;P2POWER DB 0
head1col dw 70        ;Player 1 beginning of headcolumn
head2col dw 250        ;Player 1 beginning of headcolumn
head1prev dw 50
head2prev dw 260
player1dec dw 5       ;Player 1 step
player2dec dw 5       ;Player 2 step
player1pos dw 0       ;Player 1 Position--->if it is player on the left then 0/ if it is the player on the right then 1
player2pos dw 1       ;Player 2 Position
player1row dw 130     ;Player 1 beginning of height body
player2row dw 130     ;Player 2 beginning of height body
player1health dw 100
player2health dw 100
;if shield is activated then 1 if deactivated then 0
;when shield button is pressed shield is activated until player starts hitting or starts getting hit--->deactivates
player1shieldhead dw 0; player1 head shield
player1shieldbelly dw 0 ;player 1 body shield
player2shieldhead dw 0  ;player2 head shield
player2shieldbelly dw 0 ;player2 body shield
pos db 0 ;col
poss db 0 ;row
clr db 0
game_name db 'MORTAL KOMBAT'
mes1 db 'press 1 to Start'
mes2 db 'press 3 to Exit'
player1name db 20 dup (' ')
player2name db 20 dup (' ')
mes3 db 'enter player1 name:','$'
mes4 db 'enter player2 name:','$'
roundno db '0'
roundwp1 dw 0
roundwp2 dw 0
winm db 1h,1h,1h
mes5 db 'round: '
mes6 db 'the winner is:'
p1nc dw 0   ;counter char of p1 name
p2nc dw 0   ;counter char of p2 name
GAMEPAUSED db 'GAME PAUSED... ','$' 
PLAYAGAIN db 'IF YOU WANT TO PLAY AGAIN PRESS P... ','$'
mes7 db 'press 2 for controls'
inst db 'press any key to continue','$' ;ekto el controls hena 
p1power db '+++','$'
p1powercount dw 3 
p2power db '+++','$'
p2powercount dw 3

.code                 ;Ring Dimensions--->      Column: from 40 to 280    ///////   height: from row 50 to 160
main    proc far
mov ax,@data
mov ds,ax
EBDA2: 
mov ah,0              ;video mode
mov al,13h            ;
int 10h               ;
mov pos,13                 ;Display Game Name
mov poss,2                 ;
mov clr,0Ch                ;
mov cx,13                  ;
mov si, offset game_name   ;
disp

mov cx,16                  ;Display press 1 to start
mov pos,10                 ;
mov poss,5                 ;
mov clr,09h                ;
mov si, offset mes1        ;
disp
mov cx,19                  ;Display press 2 to exit
mov pos,10                 ;
mov poss,6                 ;
mov clr,09h                ;
mov si, offset mes7        ;
disp
mov cx,15
mov pos,10
mov poss,7
mov clr,09h
mov si, offset mes2
disp


CHECK: 
mov ah,0
int 16h
cmp al,32h 
jz  exit 
cmp al,31h 
jz  start
jmp check

start:
TNAME  mes3,player1name   
TNAME  mes4,player2name

mov bx,offset p1nc
mov si,offset player1name+2 
mov cx,20
call countn

mov bx,offset p2nc
mov si,offset player2name+2
 mov cx,15
call countn


 
mov ax,head1col
cmp ax,head2col
jb below
ja  above
below:
mov ax,1
mov player2pos,ax
mov ax,0
mov player1pos,ax
jmp rest
above:
mov ax,1
mov player1pos,ax
mov ax,0
mov player2pos,ax

rest:
inc roundno
mov ah,0    ;video mode
mov al,13h       ;
int 10h          ;

mov player1health,100
mov player2health,100

mov pos,1                  ;Display Game Name
mov poss,1                 ;
mov clr,0Ch                ;
mov cx,p1nc                  ;
mov si, offset player1name+2 ;
DISP                       ;
mov pos,25                  ;Display Game Name
mov poss,1                 ;
mov clr,09h                ;
mov cx,p2nc                 ;
mov si, offset player2name+2 ;
DISP                       ;
mov pos,13                       ;print round no
mov poss,1
mov clr,0fh
mov cx,7
mov si, offset mes5
disp
mov pos,19                      ;print round no
mov poss,1
mov clr,0fh
mov cx,1
mov si, offset roundno
disp
mov pos,0                       ;print rounds of p1
mov poss,2
mov clr,0Ch
mov cx, roundwp1
mov si, offset winm
disp 
mov pos,20                       ;print rounds of p2
mov poss,2
mov clr,09h
mov cx, roundwp2
mov si, offset winm
disp 
mov pos,1                       ;print rounds of p1
mov poss,4
mov clr,00h
mov cx, 3
mov si, offset p1power
disp      
mov pos,20                       ;print rounds of p1
mov poss,4
mov clr,00h
mov cx, 3
mov si, offset p2power
disp
mov pos,1                       ;print rounds of p1
mov poss,4
mov clr,04h
mov cx, p1powercount
mov si, offset p1power
disp      
mov pos,20                       ;print rounds of p1
mov poss,4
mov clr,01h
mov cx, p2powercount
mov si, offset p2power
disp

;Draw VerticalLine1
mov cx,39        ;Column
mov dx,50        ;Row
mov al,0EH       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
back1: int 10h
inc dx
cmp dx,200
jnz back1
;Draw LineBetween
mov cx,39        ;Column
mov dx,160       ;Row
mov al,0EH       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
backbet: int 10h
inc cx
cmp cx,280
jnz backbet

;Draw VerticalLine2
mov cx,280       ;Column
mov dx,50        ;Row
mov al,0EH       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
back2: int 10h
inc dx
cmp dx,200
jnz back2

;If you want to change cursor mov bh,0 before using the interrupt that changes the cursor 
disphead:DisplayPlayers head1col,head2col,player1row,player2row ;Macro that draws players
CLEARHEALTHBARS
DISPHEALTHBARS player1health,player2health
mov ax,head1col
mov head1prev,ax
mov ax,head2col
mov head2prev,ax
mov si,head1col    ;Now SI has the offset of player's 1 head location on the ring
mov di,head2col    ;Now DI has the offset of player's 2 head location on the ring
mov ah,0
int 16h                    ;
CMP AL,20H                 ;
JZ  FOKELPAUSE             ;
JNZ check1right            ; 
FOKELPAUSE:               
mov pos,13                 ;Display Game Name
mov poss,6                 ;
mov clr,0Ch                ;
mov cx,13                  ;
mov si, offset GAMEPAUSED  ;
DISP                       ;
mov ah,0                   ;
int 16h                    ;
CMP AL,20H                 ;
JNZ FOKELPAUSE             ; 
mov pos,13                 ;Display Game Name
mov poss,6                 ;
mov clr,00h                ; 
mov cx,13                  ;
mov si, offset GAMEPAUSED  ; 
DISP                       ; 
;Player 1 left/right movement checks
check1right:               ;Here check if player 1 pressed the right button or not ->jumps to left button pressed check loop
cmp aL,44H                 ;if he pressed then jumps to Checkmarr1 if the player can move right or not
jz mov1right               ;if it will hit a barrier or a player it will not move to right and nothing happens
cmp al,64H                 ;if it the road is clear it will continue to move the headpos to the right and draw player in new position
jz mov1right               ;after function is finished jumps to com where it gets another action from the user the clears screen and display players with new positions
jnz check1left             ;
mov1right:                 ;
jmp checkmarr1             ;
continuer1:mov ax,head1col ;
add ax,5                   ;
mov head1col,ax            ;
;
JMP com                    ;
checkmarr1:                ;
mov ax,head1col            ;
add ax,10                  ;
cmp ax,280                 ;
jb con                     ;
jae com                    ;
con:sub ax,10              ;
cmp head2col,ax            ;
jb continuer1              ;
jae con1                   ;
con1:mov ax,head1col       ;
add ax,15                  ;
cmp ax,head2col            ;
jb continuer1              ;
jae com                    ;

check1left:                ;Here check if player 1 pressed the left button or not-->jumps to check if player 2 moved or not
cmp al,41h                 ;if he pressed then jumps to Checkmarl1 if the player can move left or not
jz mov1left                ;if it will hit a barrier or a player it will not move to left and nothing happens
cmp al,61h                 ;if it the road is clear it will continue to move the headpos to the left and draw player in new position
jz mov1left                ;after function is finished jumps to com where it gets another action from the user the clears screen and display players with new positions
jnz check2right            ;
mov1left:                  ;
jmp checkmarl1             ;
continuel1:                ;
mov ax,head1col            ;
sub ax,5                   ;
mov head1col,ax            ;

jmp com                    ;
checkmarl1:                ;
mov ax,head1col            ;
cmp ax,40                  ;
ja con2                    ;
jbe com                    ;
con2:mov ax,head1col       ;
add ax,10                  ;
cmp ax,head2col            ;
jb continuel1              ;
jae con11                  ;
con11:mov ax,head1col      ;
sub ax,15                  ;
cmp head2col,ax            ;
jb continuel1              ;
jae com                    ;

;Player 2 left/right movement checks
check2right:               ;Here check if player 2 pressed the right button or not ->jumps to left button pressed check loop
cmp al,36H                 ;if he pressed then jumps to Checkmarl1 if the player can move right or not
jz mov2right               ;if it will hit a barrier or a player it will not move to right and nothing happens
jnz check2left             ;if it the road is clear it will continue to move the headpos to the right and draw player in new position
mov2right:                 ;after function is finished jumps to com where it gets another action from the user the clears screen and display players with new positions
jmp checkmar2r             ;
continuer2:mov ax,head2col ;
add ax,5                   ;
mov head2col,ax            ;
JMP com                    ;
checkmar2r:                ;
mov ax,head2col            ;
add ax,10                  ;
cmp ax,280                 ;
jb con12                   ;
jae com                    ;
con12:sub ax,10            ;
cmp head1col,ax            ;
jb continuer2              ;
jae con14                  ;
con14:mov ax,head2col      ;
add ax,15                  ;
cmp ax,head1col            ;
jb continuer2              ;
jae com                    ;

check2left:                ;Here check if player 2 pressed the left button or not-->jumps to check if player 1 jumped or not
cmp al,34h                 ;if he pressed then jumps to Checkmarl2 if the player can move left or not
jz mov2left                ;if it will hit a barrier or a player it will not move to left and nothing happens
jnz Laserp1               ;if it the road is clear it will continue to move the headpos to the left and draw player in new position
mov2left:                  ;after function is finished jumps to com where it gets another action from the user the clears screen and display players with new positions
jmp checkmarl2             ;
continuel2:mov ax,head2col ;
sub ax,5                   ;
mov head2col,ax            ;             
jmp com                    ;
checkmarl2:                ;
mov ax,head2col            ;
cmp ax,40                  ;
ja con23                   ;
jbe com                    ;
con23:mov ax,head2col      ;
add ax,10                  ;
cmp ax,head1col            ;
jb continuel2              ;
jae con112                 ;
con112:mov ax,head2col     ;
sub ax,15                  ;
cmp head1col,ax            ;
jb continuel2              ;
jae com                    ;

Laserp1:
Cmp al ,53h
JZ OSH
jnz Laserp2
cmp al,73h
JZ OSH
jnz Laserp2
OSH:
CMP P1POWERCOUNT,0
JZ Laserp2
DEC P1POWERCOUNT
sub player2health,5 
cmp player1pos,0
jz ltt1
jnz rtt1
;ersm lazer r to l
rtt1:
mov cx,head1col        ;Column 
yala22:
dec cx
mov dx,135       ;Row
mov al,04H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
backbet22: int 10h
cmp cx,head2col
jz delete22
dec cx
cmp cx,41
jnz backbet22
jmp delete22
cmp cx,41
jnz yala22
delete22: 
mov di,0FFFFH
De1:
dec di
cmp di,0
jnz De1

mov cx,279       ;Column 
mov dx,135       ;Row
mov al,00H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
backbetm22: int 10h 
dec cx
cmp cx,41
jnz backbetm22
JMP LASERP2
ltt1:
;ersm lazer l to r
mov cx,head1col        ;Column 
yala1:
INC cx
mov dx,135       ;Row
mov al,04H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
backbet1: int 10h
cmp cx,head2col
jz delete1
INC cx
cmp cx,279
jnz backbet1
jmp delete1
cmp cx,279
jnz yala1
delete1:
mov di,0FFFFH
De2:
dec di
cmp di,0
jnz De2
mov cx,41       ;Column 
mov dx,135       ;Row
mov al,00H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
backbetm1: int 10h 
INC cx
cmp cx,279
jnz backbetm1
 
Laserp2:
cmp al,35h
JZ OSH2
jnz checkjumpr1
OSH2:
CMP P2POWERCOUNT,0
JZ checkjumpr1
DEC P2POWERCOUNT
sub player1health,5 
cmp player2pos,0
jnz rtt2
jz ltt2
;ersm lazer r to l
rtt2:
mov cx,head2col        ;Column 
yala3:
dec cx
mov dx,135      ;Row
mov al,01H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
backbet3: int 10h
cmp cx,head1col
jz delete3
dec cx
cmp cx,41
jnz backbet3
jmp delete3
cmp cx,41
jnz yala3
delete3: 
mov di,0FFFFH
De3:
dec di
cmp di,0
jnz De3
mov cx,279       ;Column 
mov dx,135       ;Row
mov al,00H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
backbetm3: int 10h 
dec cx
cmp cx,41
jnz backbetm3
JMP checkjumpr1
ltt2:
;ersm lazer l to r
mov cx,head1col        ;Column 
yala4:
inc cx
mov dx,135       ;Row
mov al,01H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
backbet4: int 10h
cmp cx,head2col
jz delete4
inc cx
cmp cx,279
jnz backbet4
jmp delete4
cmp cx,279
jnz yala4
delete4:
mov di,0FFFFH
De4:
dec di
cmp di,0
jnz De4
mov cx,41        ;Column 
mov dx,135       ;Row
mov al,00H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
backbetm4: int 10h 
inc cx
cmp cx,279
jnz backbetm4


;Player 1 jumping checks
checkjumpr1:                                               ; check if player 1 pressed jump right
cmp al,57h                                                 ; check if he is the player on the left or not
jz jr1                                                     ; check if there is a space for him to jump in
cmp al,77H                                                 ; then draw him jumping
jnz checkjumpl1                                            ; then draw him in his new position
jr1:                                                       ;
mov ax,head1col                                            ;
add ax,40                                                  ;
cmp ax,280                                                 ;
ja com                                                     ;
mov bx,head2col                                            ;
mov cx,bx                                                  ;
add cx,10                                                  ;
cmp ax,bx                                                  ;
jb jr11                                                    ;
sub ax,10                                                  ;
cmp ax,cx                                                  ;
jbe com                                                    ;
mov si,head1col                                            ;
add si,30                                                  ;
cmp si,head2col                                            ;
jb jr11                                                    ;
mov si,1                                                   ;
mov player1pos,si                                          ;
mov si,0                                                   ;
mov player2pos,si                                          ;
jr11:                                                      ;
mov ax,head1col                                            ;
add ax,15                                                  ;
mov head1col,ax                                            ;
ClearPlayers head1prev,head2prev,player1row,player2row     ;clears the display
DisplayPlayers head1col,head2col,95,player2row             ;draws the players again if player 1 jumped showing him jumping
ClearPlayers head1col,head2col,95,player2row               ;clears the display again
mov ax,head1col                                            ;
add ax,15                                                  ;
mov head1col,ax                                            ;
DisplayPlayers head1col,head2col,player1row,player2row  ;display the players with the new position of player 1 after the jump
mov head1prev,ax                                           ;
jmp com                                                    ;

checkjumpl1:                                               ;check if player 1 pressed jump left
cmp al,58H                                                 ;check if he is the player on the right or not
jz jl1                                                     ; check if there is a space for him to jump in
cmp al,78H                                                 ; then draw him jumping
jnz checkjumpr2                                            ; then draw him in his new position
jl1:mov ax,head1col                                        ;
sub ax,30                                                  ;
cmp ax,39                                                  ;
jb com                                                     ;
mov ax,head1col                                            ;
mov bx,head2col                                            ;
add bx,10                                                  ;
sub ax,30                                                  ;
cmp ax,bx                                                  ;
ja jl11                                                    ;
add ax,10                                                  ;
sub bx,10                                                  ;
cmp ax,bx                                                  ;
jae com                                                    ;
mov si,0                                                   ;
mov player1pos,si                                          ;
mov si,1                                                   ;
mov player2pos,si                                          ;
jl11:                                                      ;
mov ax,head1col                                            ;
sub ax,15                                                  ;
mov head1col,ax                                            ;
ClearPlayers head1prev,head2prev,player1row,player2row     ;
DisplayPlayers head1col,head2col,95,player2row             ;
ClearPlayers head1col,head2col,95,player2row               ;
mov ax,head1col                                            ;
sub ax,15                                                  ;
mov head1col,ax                                            ;
DisplayPlayers head1col,head2col,player1row,player2row     ;
mov head1prev,ax                                           ;
jmp com
checkjumpr2:                                               ;player 2 jump right
cmp al,38h                                                 ;
jnz checkjumpl2                                            ;
jr2:                                                       ;
mov ax,head2col                                            ;
add ax,40                                                  ;
cmp ax,280                                                 ;
ja com                                                     ;
mov bx,head1col                                            ;
mov cx,bx                                                  ;
add cx,10                                                  ;
cmp ax,bx                                                  ;
jb jr22                                                    ;
sub ax,10                                                  ;
cmp ax,cx                                                  ;
jbe com                                                    ;
mov si,head2col                                            ;
add si,30                                                  ;
cmp si,head1col                                            ;
jb jr22                                                    ;
mov si,1                                                   ;
mov player2pos,si                                          ;
mov si,0                                                   ;
mov player1pos,si                                          ;
jr22:                                                      ;
mov ax,head2col                                            ;
add ax,15                                                  ;
mov head2col,ax                                            ;
ClearPlayers head1prev,head2prev,player1row,player2row     ;
DisplayPlayers head1col,head2col,player1row,95             ;
ClearPlayers head1col,head2col,player1row,95               ;
mov ax,head2col                                            ;
add ax,15                                                  ;
mov head2col,ax                                            ;
DisplayPlayers head1col,head2col,player1row,player2row     ;
mov head2prev,ax                                           ;
jmp com
checkjumpl2:
cmp al,32h
jnz checkfightmode
jl2:mov ax,head2col
sub ax,30
cmp ax,39
jb com
mov ax,head2col
mov bx,head1col
add bx,10
sub ax,30
cmp ax,bx
ja jl22
add ax,10
sub bx,10
cmp ax,bx
jae com
mov si,0
mov player2pos,si
mov si,1
mov player1pos,si
jl22:
mov ax,head2col
sub ax,15
mov head2col,ax
ClearPlayers head1prev,head2prev,player1row,player2row
DisplayPlayers head1col,head2col,player1row,95
ClearPlayers head1col,head2col,player1row,95
mov ax,head2col
sub ax,15
mov head2col,ax
DisplayPlayers head1col,head2col,player1row,player2row
mov head2prev,ax
jmp com
checkfightmode:
checkshield1:
cmp al,5AH
jz sh
cmp al,7Ah
jz sh
cmp al,43h
jz sh1
cmp al,63h
jz sh1
jnz fightplayer1
sh:
cmp player1pos,0
jnz rt
jz  lt

rt:
mov cx,head1col
mov dx,player1row
add cx,4
add dx,15
mov si,dx
add si,4
mov al,0EH
mov ah,0CH
Shield:int 10h
inc dx
cmp dx,si
jnz Shield

mov di,0FFFFH
Del1:
dec di
cmp di,0
jnz Del1

mov cx,head1col
mov dx,player1row
add cx,4
add dx,15
mov si,dx
add si,4
mov al,00H
mov ah,0CH
Shield1:int 10h
inc dx
cmp dx,si
jnz Shield1
jmp esc
lt:
mov cx,head1col
add cx,6
mov dx,player1row
add dx,15
mov si,dx
add si,4
mov al,0EH
mov ah,0CH
shi3:int 10h
inc dx
cmp dx,si
jnz shi3

mov di,0FFFFH
Del3:
dec di
cmp di,0
jnz Del3

mov cx,head1col
add cx,6
mov dx,player1row
add dx,15
mov si,dx
add si,4
mov al,00H
mov ah,0CH
shield32:int 10h
inc dx
cmp dx,si
jnz shield32
esc:
mov ax,1
mov player1shieldbelly,ax
mov ax,0
mov player1shieldhead,ax
jmp com

sh1:
cmp player1pos,0
jnz rt2
jz lt2
rt2:

mov cx,head1col                            ;draw shield on head
mov dx,player1row
mov si,dx
add si,10
mov al,0EH
mov ah,0CH
ShieldH:int 10h
inc dx
cmp dx,si
jnz ShieldH

mov di,0FFFFH                             ;delay
Del2:
dec di
cmp di,0
jnz Del2
;draw using black on it
mov cx,head1col
mov dx,player1row
mov si,dx
add si,10
mov al,00H
mov ah,0CH
Shield2:int 10h
inc dx
cmp dx,si
jnz Shield2
jmp esc2
lt2:
mov cx,head1col
mov dx,player1row
add cx,10
mov si,dx
add si,10
mov al,0EH
mov ah,0CH
ShieldHead:int 10h
inc dx
cmp dx,si
jnz ShieldHead

mov di,0FFFFH
Delee2:
dec di
cmp di,0
jnz Delee2

mov cx,head1col
mov dx,player1row
add cx,10
mov si,dx
add si,10
mov al,00H
mov ah,0CH
ShieldHh2:int 10h
inc dx
cmp dx,si
jnz ShieldHh2

esc2:
mov ax,0
mov player1shieldbelly,ax
mov ax,1
mov player1shieldhead,ax
jmp com

fightplayer1: ;player1 want to fight player2
cmp al,45h
jz upper
cmp al,65H
jz upper
cmp al,51H
jz straight
cmp al,71H
jz straight
jnz checkshield2
upper:
cmp player1pos,1                  ;to know position of player
jz right1
jnz left1

right1:
mov cx,head1col                   ;column
add cx,5                          ;middle of the head
mov dx,player1row                 ;row
add dx,17                         ;above middle of the body
mov si,dx
sub si,10
mov al,0EH                        ;draw pixel color
mov ah,0CH                        ;draw pixel command
UPP1:int 10h
dec cx                            ;draw left
mov bx,head1col
sub bx,6                          ;to loop until reaches wanted position
dec dx                            ;until reaches si to go up in diagonal direction
cmp cx,bx
jnz UPP
UPP:
cmp dx,si
JNZ UPP1

Mov di,0FFFFH                      ;Delay for uppercut to appear
Delay2:
dec di
cmp di,0
jnz Delay2

mov cx,head1col                  ;draw on it with black to delete it
add cx,5
mov dx,player1row
add dx,17
mov si,dx
sub si,10
mov al,00H
mov ah,0CH
UP1:int 10h
dec cx
mov bx,head1col
sub bx,6
dec dx
cmp cx,bx
jnz UP
UP:
cmp dx,si
JNZ UP1
jmp after1

left1:

mov cx,head1col              ;column
add cx,5                     ;to be at the middle of the head
mov dx,player1row            ;row
add dx,17                    ;to be above the middle of the body
mov si,dx
sub si,10                    ;to reach wanted position
mov al,0EH
mov ah,0CH
UPPPER1:int 10h
inc cx                       ;loop to go right
mov bx,head1col
sub bx,6
dec dx                       ;loop to go up
cmp cx,bx
jnz UPPPER
UPPPER:
cmp dx,si
JNZ UPPPER1

Mov di,0FFFFH                 ;Delay for uppercut to appear
Delay3:
dec di
cmp di,0
jnz Delay3

mov cx,head1col               ;Draw on it with black to delete it
add cx,5
mov dx,player1row
add dx,17
mov si,dx
sub si,10
mov al,00H
mov ah,0CH
UPER41:int 10h
inc cx
mov bx,head1col
sub bx,6
dec dx
cmp cx,bx
jnz UPPER41
UPPER41:
cmp dx,si
JNZ UPER41

after1:
mov cx,20
mov dx,10
mov si,0
jmp hop
straight:
CMP player1pos,1                          ;to know position of player
jz right
jnz left

right:

mov cx,head1col               ;Punch
add cx,5
mov dx,player1row          ;Column
add dx,17                  ;Row
mov al,0EH               ;Pixel color
mov ah,0CH               ;Draw Pixel Command
box:int 10h
dec cx
mov bx,head1col
sub bx,11
cmp cx,bx
jnz box

mov di,0FFFFH           ;To delay for punch to appear on screen
Delay:
dec di
cmp di,0
jnz Delay

mov cx,head1col        ;Draw Black to delete punch
add cx,5
mov dx,player1row          ;Column
add dx,17                  ;Row
mov al,00H               ;Pixel color
mov ah,0CH               ;Draw Pixel Command
box2:int 10h
dec cx
mov bx,head1col
sub bx,11
cmp cx,bx
jnz box2
jmp after:
left:
mov cx,head1col
add cx,5
mov dx,player1row          ;Column
add dx,17                  ;Row
mov al,0EH               ;Pixel color
mov ah,0CH               ;Draw Pixel Command
box11:int 10h
inc cx
mov bx,head1col
add bx,20
cmp cx,bx
jnz box11

mov di,0FFFFH
Delay11:
dec di
cmp di,0
jnz Delay11

mov cx,head1col
add cx,5
mov dx,player1row          ;Column
add dx,17                  ;Row
mov al,00H               ;Pixel color
mov ah,0CH               ;Draw Pixel Command
boxx3:int 10h
inc cx
mov bx,head1col
add bx,20
cmp cx,bx
jnz boxx3
after:
mov cx,10
mov dx,5
mov si,1
jmp hop
hop:
mov player1shieldbelly,0
mov player1shieldhead,0
cmp player1pos,1
jz fightleft
fightright:
mov ax,head1col
add ax,10
mov bx,head2col
sub bx,5
cmp ax,bx
jz fight5
jnz check10r
fightleft:
mov ax,head1col
sub ax,5
mov bx,head2col
add bx,10
cmp ax,bx
jz fight5
jnz check10l
check10r:
mov ax,head1col
add ax,10
mov bx,head2col
sub bx,10
cmp ax,bx
jz fight10
jnz com
check10l:
mov ax,head1col
sub ax,10
mov bx,head2col
add bx,10
cmp ax,bx
jz fight10
jnz com
fight5:
cmp si,0
jz chkupper
jnz chkstraight
chkupper:cmp player2shieldhead,1
jnz hit
mov player2shieldhead,0
jmp com
chkstraight:cmp player2shieldbelly,1
jnz hit
mov player2shieldbelly,0
jmp com
hit:mov ax,player2health
cmp player2health,cx
jbe pw1
sub ax,cx
mov player2health,ax


jmp com
fight10:
cmp si,0
jz chkupper1
jnz chkstraight1
chkupper1:cmp player2shieldhead,1
jnz hit1
mov player2shieldhead,0
jmp com
chkstraight1:cmp player2shieldbelly,1
jnz hit1
mov player2shieldbelly,0
jmp com
hit1:mov ax,player2health
cmp player2health,dx
jbe pw1
sub ax,dx
mov player2health,ax
jmp com

checkshield2:
cmp al,31h
jz sh3
cmp al,33h
jz sh4
jnz fightplayer2
sh3:
cmp player2pos,1
jnz rt1
jz lt1

rt1:                                                 ;to shield belly we draw the shield
mov cx,head2col
add cx,6
mov dx,player2row
add dx,15
mov si,dx
add si,4
mov al,0EH
mov ah,0CH
shield3:int 10h
inc dx
cmp dx,si
jnz shield3

mov di,0FFFFH                                     ;delay
Dele3:
dec di
cmp di,0
jnz Dele3

mov cx,head2col                                 ;draw on it with black
add cx,6
mov dx,player2row
add dx,15
mov si,dx
add si,4
mov al,00H
mov ah,0CH
shield31:int 10h
inc dx
cmp dx,si
jnz shield31
jmp esc1
lt1:
mov cx,head2col
mov dx,player2row
add cx,4
add dx,15
mov si,dx
add si,4
mov al,0EH
mov ah,0CH
Shi2:int 10h
inc dx
cmp dx,si
jnz Shi2

mov di,0FFFFH
Dell2:
dec di
cmp di,0
jnz Dell2

mov cx,head2col
mov dx,player2row
add cx,4
add dx,15
mov si,dx
add si,4
mov al,00H
mov ah,0CH
Shieldh1:int 10h
inc dx
cmp dx,si
jnz Shieldh1

esc1:
mov ax,1
mov player2shieldbelly,ax
mov ax,0
mov player2shieldhead,ax
jmp com
sh4:
cmp player2pos,1                            ;cmp position to know if player is on left or right
jnz rt3
jz lt3

rt3:
mov cx,head2col                             ;draw shield on face
mov dx,player2row
add cx,10
mov si,dx
add si,10
mov al,0EH
mov ah,0CH
Shieldhh1:int 10h
inc dx
cmp dx,si
jnz Shieldhh1

mov di,0FFFFH
Della2:
dec di
cmp di,0
jnz Della2

mov cx,head2col
mov dx,player2row
add cx,10
mov si,dx
add si,10
mov al,00H
mov ah,0CH
ShieldH2:int 10h
inc dx
cmp dx,si
jnz ShieldH2
jmp esc3
lt3:
mov cx,head2col
mov dx,player2row
mov si,dx
add si,10
mov al,0EH
mov ah,0CH
ShieldHh:int 10h
inc dx
cmp dx,si
jnz ShieldHh

mov di,0FFFFH
Dele2:
dec di                         ;delay
cmp di,0
jnz Dele2

mov cx,head2col                      ;draw on it with black
mov dx,player2row
mov si,dx
add si,10
mov al,00H
mov ah,0CH
Sshieldh2:int 10h
inc dx
cmp dx,si
jnz Sshieldh2

esc3:
mov ax,0
mov player2shieldbelly,ax
mov ax,1
mov player2shieldhead,ax
jmp com

fightplayer2:
cmp al,39h
jz upper2
cmp al,37H
jz straight2
jnz com
upper2:
cmp player2pos,0
jz right2
jnz left2
right2:
mov cx,head2col              ;column
add cx,5                     ;to be at the middle of the head
mov dx,player2row            ;row
add dx,17                    ;to be above the middle of the body
mov si,dx
sub si,10                    ;to reach wanted position
mov al,0EH
mov ah,0CH
UPPP1:int 10h
inc cx                       ;loop to go right
mov bx,head2col
sub bx,6
dec dx                       ;loop to go up
cmp cx,bx
jnz UPPP
UPPP:
cmp dx,si
JNZ UPPP1

Mov di,0FFFFH                 ;Delay for uppercut to appear
Delayy3:
dec di
cmp di,0
jnz Delayy3

mov cx,head2col               ;Draw on it with black to delete it
add cx,5
mov dx,player2row
add dx,17
mov si,dx
sub si,10
mov al,00H
mov ah,0CH
UP41:int 10h
inc cx
mov bx,head2col
sub bx,6
dec dx
cmp cx,bx
jnz UPP41
UPP41:
cmp dx,si
JNZ UP41
jmp after2

left2:
mov cx,head2col                   ;column
add cx,5                          ;middle of the head
mov dx,player2row                 ;row
add dx,17                         ;above middle of the body
mov si,dx
sub si,10
mov al,0EH                        ;draw pixel color
mov ah,0CH                        ;draw pixel command
UPPER1:int 10h
dec cx                            ;draw left
mov bx,head2col
sub bx,6                          ;to loop until reaches wanted position
dec dx                            ;until reaches si to go up in diagonal direction
cmp cx,bx
jnz UPPERR
UPPERR:
cmp dx,si
JNZ UPPER1

Mov di,0FFFFH                      ;Delay for uppercut to appear
Delayy2:
dec di
cmp di,0
jnz Delayy2

mov cx,head2col                  ;draw on it with black to delete it
add cx,5
mov dx,player2row
add dx,17
mov si,dx
sub si,10
mov al,00H
mov ah,0CH
UPER1:int 10h
dec cx
mov bx,head2col
sub bx,6
dec dx
cmp cx,bx
jnz UPER
UPER:
cmp dx,si
JNZ UPER1
after2:

mov cx,20
mov dx,10
mov si,0
jmp hop2
straight2:

cmp player2pos,0
jz right3
jnz left3

right3:
mov cx,head2col
add cx,5
mov dx,player2row          ;Column
add dx,17                  ;Row
mov al,0EH               ;Pixel color
mov ah,0CH               ;Draw Pixel Command
box1:int 10h
inc cx
mov bx,head2col
add bx,20
cmp cx,bx
jnz box1

mov di,0FFFFH
Delay1:
dec di
cmp di,0
jnz Delay1

mov cx,head2col
add cx,5
mov dx,player2row          ;Column
add dx,17                  ;Row
mov al,00H               ;Pixel color
mov ah,0CH               ;Draw Pixel Command
box3:int 10h
inc cx
mov bx,head2col
add bx,20
cmp cx,bx
jnz box3
jmp after3
left3:
mov cx,head2col               ;Punch
add cx,5
mov dx,player2row          ;Column
add dx,17                  ;Row
mov al,0EH               ;Pixel color
mov ah,0CH               ;Draw Pixel Command
punch:int 10h
dec cx
mov bx,head2col
sub bx,11
cmp cx,bx
jnz punch

mov di,0FFFFH           ;To delay for punch to appear on screen
Delayy:
dec di
cmp di,0
jnz Delayy

mov cx,head2col        ;Draw Black to delete punch
add cx,5
mov dx,player2row          ;Column
add dx,17                  ;Row
mov al,00H               ;Pixel color
mov ah,0CH               ;Draw Pixel Command
punch2:int 10h
dec cx
mov bx,head2col
sub bx,11
cmp cx,bx
jnz punch2

after3:
mov cx,10
mov dx,5
mov si,1
jmp hop2
hop2:
mov player2shieldbelly,0
mov player2shieldhead,0
cmp player2pos,1
jz fightleft2
fightright2:
mov ax,head2col
add ax,10
mov bx,head1col
sub bx,5
cmp ax,bx
jz fight52
jnz check10r2
fightleft2:
mov ax,head2col
sub ax,5
mov bx,head1col
add bx,10
cmp ax,bx
jz fight52
jnz check10l2
check10r2:
mov ax,head2col
add ax,10
mov bx,head1col
sub bx,10
cmp ax,bx
jz fight102
jnz com
check10l2:
mov ax,head2col
sub ax,10
mov bx,head1col
add bx,10
cmp ax,bx
jz fight102
jnz com
fight52:
cmp si,0
jz chkupper3
jnz chkstraight3
chkupper3:cmp player1shieldhead,1
jnz hit3
mov player1shieldhead,0
jmp com
chkstraight3:cmp player1shieldbelly,1
jnz hit3
mov player1shieldbelly,0
jmp com
hit3:mov ax,player1health
cmp player1health,cx
jbe pw2
sub ax,cx
mov player1health,ax
jmp com
fight102:
cmp si,0
jz chkupper4
jnz chkstraight4
chkupper4:cmp player1shieldhead,1
jnz hit4
mov player1shieldhead,0
jmp com
chkstraight4:cmp player1shieldbelly,1
jnz hit4
mov player1shieldbelly,0
jmp com
hit4:mov ax,player1health
cmp player1health,cx
jbe pw2
sub ax,dx
mov player1health,ax
jmp com
com:
mov ah,1
int 16h
ClearPlayers head1prev,head2prev,player1row,player2row ; Macro that clears players
jmp disphead

Exit:
mov ah,0x4C
int 0x21

main   endp

pw1:
inc  roundwp1

cmp  roundwp1,3
jae dpw1

jmp rest

pw2:
inc  roundwp2

cmp  roundwp2,3
jae dpw2

jmp rest

dpw1:

mov ah,0
mov al,03h
int 10h


mov ah,2
mov dx,0000h
int 10h

mov pos,0
mov poss,0
mov clr,0fh
mov cx,15
mov si, offset mes6
disp

mov pos,15
mov poss,0
mov clr,0Ch
mov cx,p1nc
mov si, offset player1name+2
disp 

mov pos,6                 ;Display Game Name
mov poss,6                 ;
mov clr,0Ch                ; 
mov cx,35                  ;
mov si, offset PLAYAGAIN  ;
DISP
mov ah,0                   ;
int 16h
cmp aL,50H                 ;if he pressed then jumps to Checkmarr1 if the player can move right or not
jz EBDA2               ;if it will hit a barrier or a player it will not move to right and nothing happens
cmp al,70H                 ;if it the road is clear it will continue to move the headpos to the right and draw player in new position
jz EBDA2 
jmp  Exit

dpw2:
mov ah,0
mov al,03h
int 10h

mov ax,0600h
mov bh,07
mov cx,0
mov dx,184FH
int 10h

mov ah,2
mov dx,0000h
int 10h

mov pos,0
mov poss,0
mov clr,0fh
mov cx,15
mov si, offset mes6
disp


mov pos,15
mov poss,0
mov clr,09h
mov cx,p2nc
mov si, offset player2name+2
disp
mov pos,6                 ;Display Game Name
mov poss,6                 ;
mov clr,0Ch                ; 
mov cx,35                  ;
mov si, offset PLAYAGAIN  ;
DISP
mov ah,0                   ;
int 16h
cmp aL,50H                 ;if he pressed then jumps to Checkmarr1 if the player can move right or not
jz EBDA2               ;if it will hit a barrier or a player it will not move to right and nothing happens
cmp al,70H                 ;if it the road is clear it will continue to move the headpos to the right and draw player in new position
jz EBDA2
jmp  Exit



countn proc
    count:
    cmp [si],0dh
    jz gob
    inc [bx]
    inc si 
    loop count
    

gob:       RET    
countn ENDP   

instt: 
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
    mov ah,2
    mov dx,0A0Ah
    int 10h

    mov ah,9
    mov dx,offset inst
    int 21h  
    
    mov ah,0
    int 16h
    
    jmp start
   