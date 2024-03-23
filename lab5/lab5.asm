.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data 

X dd -1, 2, -3, 4, -5, 6, -7, 8, -9, 10		;масив
A dd 5
N equ ($-X) / type X - 1		    	;розмір масиву
Res dd 0				        	    ;результат

Result	db 13, 10, 'Result =                   ', 13, 10
NumberOfCharsToWrite dd $-Result
format db '%d', 0
hConsoleOutput dd 0
NumberOfCharsWritten dd 0

.code

;якщо Х > 0
x_g_0:
    cmp A, eax
    jge A_ge_x  ;перевірка, чи Х <= A
    jmp return

;якщо Х <= A
A_ge_x:
    add edx, 1  ;інкремент
    jmp return

start:

;обчислення к-сти повторів А
mov ecx, N
mov edx, 0
L:
	mov eax, [X + ecx * type X - type X] 
    cmp eax, 0 
    jg x_g_0    ;перевірка, чи Х > 0
    return:
	loop L
mov Res, edx

;вивід результату
push Res
push offset format
push offset [Result+11]
call wsprintfA
push -11
call GetStdHandle
mov hConsoleOutput, eax
push 0
push offset NumberOfCharsWritten
push NumberOfCharsToWrite
push offset Result
push hConsoleOutput
call WriteConsoleA

push 0
call ExitProcess
end start