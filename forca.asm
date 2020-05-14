jmp inicio

msg_inicial db "Pressione 1 para jogar e qualquer outra coisa para sair",0Dh,0Ah,0Ah,0h
msg_jogo db "Digite a palavra a ser usada, e pressione ENTER quando estiver pronto ",0Dh,0Ah,0Ah,0h
resposta db "                                    ",0h
estado_atual db "                                               ",0Dh,0Ah,0Ah,0h 
quantidade dw "%d"
quantidade_2 dw "%d"
vidas dw "%d"
condicao dw "%d"
ganhou dw "%d"
vitoria db "GANHOU",0h
derrota db "PERDEU, RESPOSTA CORRETA:",0h

5_vidas db "  ***",0Dh,0Ah
    db " *****",0Dh,0Ah
    db "  ***",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "*******",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "  * *",0Dh,0Ah
    db " *   *",0Dh,0Ah
    db " *   *",0h

4_vidas db "  ***",0Dh,0Ah
    db " *****",0Dh,0Ah
    db "  ***",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "*******",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "  *",0Dh,0Ah
    db " *",0Dh,0Ah
    db " *",0h 
    
3_vidas db "  ***",0Dh,0Ah
    db " *****",0Dh,0Ah
    db "  ***",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "*******",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0h
    

2_vidas db "  ***",0Dh,0Ah
    db " *****",0Dh,0Ah
    db "  ***",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "****",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0h
    
1_vidas db "  ***",0Dh,0Ah
    db " *****",0Dh,0Ah
    db "  ***",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0Dh,0Ah
    db "   *",0h
    
0_vidas db "  ***",0Dh,0Ah
    db " *****",0Dh,0Ah
    db "  ***",0h
    
           

inicio:
mov al,0
mov ah,0
int 10h
mov si,0
msg1:
mov al,msg_inicial[si]
cmp al,0h
jz key
mov ah,0eh
int 10h
inc si
jnz msg1

key:
mov ah,1
int 16h
jz key
mov ah,0
int 16h
cmp al,49
jnz fim 

mov al,0
mov ah,0
int 10h
mov si,0
msg2:
mov al,msg_jogo[si]
cmp al,0h
jz key2:
mov ah,0eh
int 10h
inc si
jnz msg2 

key2:
mov quantidade,0
mov quantidade_2,0
kkey2:
mov ah,1
int 16h
jz kkey2
cmp al,13
jz prox
cmp al,8
jz backspace:
inc quantidade
add quantidade_2,2
push ax
kkey3:
mov ah,0
int 16h
mov ah,0eh
int 10h
jmp kkey2

backspace:
cmp quantidade,0
jnz sapcio 
mov ah,0
int 16h
jz key2
sapcio:
dec quantidade
sub quantidade_2,2
pop ax
mov ah,0
int 16h
mov ah,0eh
int 10h
mov al,0
int 10h
mov al,8
int 10h
jmp kkey2

prox:
cmp quantidade,0
mov ah,0
int 16h
jz inicio
mov ganhou,0
mov si,quantidade 
mov bx,quantidade_2
prox2:
pop ax
mov resposta[si],al
cmp al,45
jz hifen
mov estado_atual[bx],95
hifen2: 
dec bx
mov estado_atual[bx],32
dec bx
dec si
cmp si,0
jnz prox2 


mov vidas,5
main:
mov si,1
mov al,0
mov ah,0
int 10h
loop:
mov al,estado_atual[si]
cmp al,0h
jz cond
mov ah,0eh
int 10h
inc si
jnz loop

cond:
cmp vidas,5
jz cinco_vidas
cmp vidas,4
jz quatro_vidas
cmp vidas,3
jz tres_vidas
cmp vidas,2
jz duas_vidas
cmp vidas,1
jz uma_vidas
cmp vidas,0
jz zero_vidas
continuacao:
mov bx,ganhou
cmp bx,quantidade
jz victory

key3:
mov ah,1
int 16h
jz key3
mov ah,0
int 16h
cmp al,13
jz inicio

mov si,0
mov bx,0
mov condicao,0
compara:
inc si
add bx,2
cmp al,resposta[si]
jz certo
certo2:
cmp si,quantidade
jnz compara

cmp condicao,0
jz errado
jnz main 
 
certo: 
inc condicao
mov cl,estado_atual[bx]
cmp cl,al
jz certo2:
mov estado_atual[bx],al
inc ganhou
cmp si,quantidade
jz main 
jmp certo2:

errado:
dec vidas
cmp vidas,-1
jz lose
jmp main
 
victory:
mov al,0
mov ah,0
int 10h
mov si,0
victory2:
mov al,vitoria[si]
cmp al,0h
jz limpa
mov ah,0eh
int 10h
inc si
jnz victory2

lose:
mov al,0
mov ah,0
int 10h
mov si,0
lose2:
mov al,derrota[si]
cmp al,0h
jz resposta_correta
mov ah,0eh
int 10h
inc si
jnz lose2 

resposta_correta:
mov si,0
resposta_correta2:
mov al,resposta[si]
cmp al,0h
jz limpa
mov ah,0eh
int 10h
inc si
jnz resposta_correta2 

limpa:
mov si,quantidade

limpa2:
mov resposta[si],32
cmp si,0
dec si
jnz limpa2

mov si,quantidade_2
limpa3:
mov estado_atual[si],32
cmp si,0 
dec si
jnz limpa3
jz inicio

cinco_vidas:
mov si,0
cinco2_vidas:
mov al,5_vidas[si]
cmp al,0h
jz continuacao
mov ah,0eh
int 10h
inc si
jnz cinco2_vidas

quatro_vidas:
mov si,0
quatro2_vidas:
mov al,4_vidas[si]
cmp al,0h
jz continuacao
mov ah,0eh
int 10h
inc si
jnz quatro2_vidas

tres_vidas:
mov si,0
tres2_vidas:
mov al,3_vidas[si]
cmp al,0h
jz continuacao
mov ah,0eh
int 10h
inc si
jnz tres2_vidas

duas_vidas:
mov si,0
duas2_vidas:
mov al,2_vidas[si]
cmp al,0h
jz continuacao
mov ah,0eh
int 10h
inc si
jnz duas2_vidas

uma_vidas:
mov si,0
uma2_vidas:
mov al,1_vidas[si]
cmp al,0h
jz continuacao
mov ah,0eh
int 10h
inc si
jnz uma2_vidas

zero_vidas:
mov si,0
zero2_vidas:
mov al,0_vidas[si]
cmp al,0h
jz continuacao
mov ah,0eh
int 10h
inc si
jnz zero2_vidas

hifen: 
inc ganhou
mov estado_atual[bx],45
jmp hifen2


fim:
