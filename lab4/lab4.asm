.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data 

A	db	100
B	db	25
X	dw	0

Hello	db 13, 10
        db '  X = (a-b)/b    if a < b', 13, 10
	    db '  X = -57        if a = b', 13, 10
	    db '  X = -4b/a      if a > b', 13, 10
Operands	db 13, 10, '  A =      B =      ', 13, 10
NumberOfCharsToWrite_Hello dd $-Hello
Error		db 13, 10, '  Error - divide by zero!', 13, 10
NumberOfCharsToWrite_Error dd $-Error
Result		db 13, 10, '  X =           ', 13, 10
NumberOfCharsToWrite_Result dd $-Result
format db '%hd', 0
hConsoleOutput dd 0
NumberOfCharsWritten dd 0

.code
start:
;Вивід повідомлення Hello
mov al, A
cbw
push ax
push offset format
push offset [Operands+8]
call wsprintfA
mov al, B
cbw
push ax
push offset format
push offset [Operands+17]
call wsprintfA
push -11
call GetStdHandle
mov hConsoleOutput, eax
push 0
push offset NumberOfCharsWritten
push NumberOfCharsToWrite_Hello
push offset Hello
push hConsoleOutput
call WriteConsoleA

;перевірка на рівніст A та B
mov al, A 
cmp al, B
jne A_ne_B
mov X, -57
jmp Output_Result

A_ne_B:
jg A_g_B
cmp B, 0
je Output_Error
;Обчислення Х при a<b
mov al, A
sub al, B
cbw
idiv B
mov X, ax
jmp Output_Result

A_g_B:
cmp A, 0
je Output_Error
;обчислення Х при a>b
mov al, B
cbw
mov bx, ax
mov ax, -4
imul ax, bx
idiv A
mov X, ax
jmp Output_Result

;вивід результату
Output_Result:
push X
push offset format
push offset [Result+8]
call wsprintfA
push offset NumberOfCharsWritten
push NumberOfCharsToWrite_Result
push offset Result
push hConsoleOutput
call WriteConsoleA
jmp exit

;вивід повідомлення про ділення на 0
Output_Error:
push offset NumberOfCharsWritten
push NumberOfCharsToWrite_Error
push offset Error
push hConsoleOutput
call WriteConsoleA
jmp exit

;вихід з програми
exit:
push 0
call ExitProcess
end start
