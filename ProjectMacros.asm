Macro Displayplayers head1col,head2col,player1row,player2row  
;Draw head1 
Local lk,backhead1,back1_3saya,back2_3saya,lk2,backhead2
mov dx,player1row   ;Row 
mov si,dx
add si,10
mov bx,head1col
add bx,10 

lk:
mov cx,head1col   ;Column
mov al,4H    ;Pixel color
mov ah,0CH  ;Draw Pixel Command
backhead1: int 10h
inc Cx
cmp Cx,bx
jnz backhead1  
INC DX
CMP DX,si
jnz lk     

;Draw Player1 3saya
mov bx,head1col
add bx,5
mov cx,bx  ;Column
mov dx,player1row   ;Row
add dx,10
mov si,dx 
add si,20
mov al,0EH   ;Pixel color
mov ah,0CH  ;Draw Pixel Command
back1_3saya: int 10h
inc dx
cmp dx,si
jnz back1_3saya         


;Draw head2       1
mov bx,head2col
add bx,10 
mov dx,player2row   ;Row
mov si,dx
add si,10
lk2:
mov cx,head2col   ;Column
mov al,1H    ;Pixel color
mov ah,0CH  ;Draw Pixel Command
backhead2: int 10h
inc Cx
cmp Cx,bx
jnz backhead2
INC DX
CMP DX,si
jnz lk2   

;Draw Player2 3saya
mov bx,head2col
add bx,5
mov cx,bx   ;Column
mov dx,player2row   ;Row 
add dx,10
mov si,dx
add si,20
mov al,0EH   ;Pixel color
mov ah,0CH  ;Draw Pixel Command
back2_3saya: int 10h
inc dx
cmp dx,si
jnz back2_3saya  
ENDM Displayplayers 

Macro ClearPlayers head1col,head2col,player1row,player2row
Local lk3,backhead13,back1_3saya3,back2_3saya3,lk23,backhead23 
mov dx,player1row   ;Row 
mov si,dx
add si,10
mov bx,head1col
add bx,10
lk3:
mov cx,head1col   ;Column
mov al,0H    ;Pixel color
mov ah,0CH  ;Draw Pixel Command
backhead13: int 10h
inc Cx
cmp Cx,bx
jnz backhead13  
INC DX
CMP DX,si
jnz lk3     

;Draw Player1 3saya
mov bx,head1col
add bx,5
mov cx,bx  ;Column
mov dx,player1row   ;Row
add dx,10
mov si,dx 
add si,20
mov al,0H   ;Pixel color
mov ah,0CH  ;Draw Pixel Command
back1_3saya3: int 10h
inc dx
cmp dx,si
jnz back1_3saya3

;Draw head2
mov bx,head2col
add bx,10 
mov dx,player2row   ;Row 
mov si,dx
add si,10
lk23:
mov cx,head2col   ;Column
mov al,0H    ;Pixel color
mov ah,0CH  ;Draw Pixel Command
backhead23: int 10h
inc Cx
cmp Cx,bx
jnz backhead23
INC DX
CMP DX,si
jnz lk23   

;Draw Player2 3saya
mov bx,head2col
add bx,5
mov cx,bx   ;Column
mov dx,player2row   ;Row
add dx,10
mov si,dx 
add si,20
mov al,0H   ;Pixel color
mov ah,0CH  ;Draw Pixel Command
back2_3saya3: int 10h
inc dx
cmp dx,si
jnz back2_3saya3  
ENDM ClearPLayers     

MACRO  disp
    local disc, abort
       cmp cx,0
       jz abort 
        disc:
        xor dx,dx
        mov ah,2          
        mov dl,pos
        mov dh,poss      
        int 10h 
        
        xor dx,dx
        mov dx,cx          
        mov ah,9          
        mov bh,0          
        mov al,[si]        
        mov cx,1        
        mov bl,CLR        
        int 10h
        
        mov cx,dx
        inc pos 
        inc si 
        loop disc 
        abort: 


ENDM disp  

MACRO TNAME mes3,player1name
mov ah,2
mov dx,0000h
int 10h 
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
   
    mov ah,9
    mov dx,offset mes3
    int 21h
    
    mov ah,0AH
    mov dx,offset player1name
    int 21h 

ENDM TNAME     

MACRO DISPHEALTHBARS player1health,player2health

cmp player1health,0
jz etla3bara1
mov bx,0
mov cx,30        ;Column
mov dx,20      ;Row
mov al,4H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
yy: int 10h
inc bx 
inc cx
cmp bx,player1health
jnz yy


mov bx,0
mov cx,30        ;Column
mov dx,21      ;Row
mov al,4H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
yy2: int 10h
inc bx 
inc cx
cmp bx,player1health
jnz yy2

etla3bara1:
cmp player2health,0
jz etla3bara2
mov bx,0
mov cx,198        ;Column
mov dx,20      ;Row
mov al,1H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
zz: int 10h
inc bx 
inc cx
cmp bx,player2health
jnz zz

mov bx,0
mov cx,198        ;Column
mov dx,21      ;Row
mov al,1H       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
zz2: int 10h
inc bx 
inc cx
cmp bx,player2health
jnz zz2
etla3bara2: cmp bx,cx
ENDM DISPHEALTHBARS

MACRO CLEARHEALTHBARS 
mov cx,30       ;Column
mov dx,20      ;Row
mov al,0FH       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
y: int 10h 
inc cx
cmp cx,130
jnz y

mov cx,30        ;Column
mov dx,21      ;Row
mov al,0FH       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
y2: int 10h 
inc cx
cmp cx,130
jnz y2

mov cx,198        ;Column
mov dx,20      ;Row
mov al,0FH       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
z: int 10h 
inc cx
cmp cx,298
jnz z

mov cx,198        ;Column
mov dx,21      ;Row
mov al,0FH       ;Pixel color
mov ah,0CH       ;Draw Pixel Command
z2: int 10h 
inc cx
cmp cx,298
jnz z2

ENDM CLEARHEALTHBARS   

