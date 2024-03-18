.686 
.model flat, stdcall 
option casemap:none 
include \masm32\include\windows.inc 
include \masm32\include\kernel32.inc 
include \masm32\include\user32.inc 
includelib \masm32\lib\kernel32.lib 
includelib \masm32\lib\user32.lib 
 
.data  
    K EQU  4019h
    A DW -12d
    B DW 12d
    Cc DB 1
    D DW 200d
    E DB 10d
    TEMP1 DD ?
    TEMP2 DW ?
    TEMP3 DW ?
    X DD ?
 
Message db 'X = A * B + A * C - D / E + K =           ', 13, 10 
NumberOfCharsToWrite dd $-Message 
format db '%d', 0 
hConsoleOutput dd 0 
NumberOfCharsWritten dd 0 
 
.code 
start: 
; TEMP1 = A * B
mov ax, A; A -> eax
CWDE
IMUL ax, B; A(eax) * B -> eax
mov TEMP1, eax ; (A * B)(eax) -> TEMP1

; TEMP2 = A * C
mov al, Cc ; Cc -> al
CBW
IMUL ax, A ; C(al) * A -> ax
mov TEMP2, ax ; (A * C)(ax) -> TEMP2

; TEMP3 = D / E
mov ax, D ; D -> eax
IDIV E ; D(eax) / E -> ax
mov TEMP3, ax ; (D / E)(ax) -> TEMP3

; X = TEMP1 + TEMP2 - TEMP3 + K
; X = TEMP2 - TEMP3 + TEMP1 + K
mov ax, TEMP2 ; TEMP2 -> ax
sub ax, TEMP3 ; TEMP2 (ax) - TEMP3 -> ax
CWDE ; ax -> eax
add eax, TEMP1 ; (TEMP2 - TEMP3)(eax) + TEMP1 -> eax
add eax, K ; (TEMP2 - TEMP3 + TEMP1)(eax) + K -> eax
mov X, eax ; (TEMP2 - TEMP3 + TEMP1 + K)(eax) -> X

push X 
push offset format 
push offset [Message+32] 
call wsprintfA 
 
push -11 
call GetStdHandle 
mov hConsoleOutput, eax 
push 0 
push offset NumberOfCharsWritten 
push NumberOfCharsToWrite 
push offset Message 
push hConsoleOutput 
call WriteConsoleA 
push 0 
call ExitProcess 
end start