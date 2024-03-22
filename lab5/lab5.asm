.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data 

X dd 5, 2, 6, 4, 5, 4, 3, 5, 9, 5		;масив
A dd 5
N equ ($-X) / type X - 1		    	;розмір масиву
Res dd 0				        	    ;результат

Result	db 13, 10, 'Result =                   ', 13, 10
NumberOfCharsToWrite dd $-Result
format db '%d', 0
hConsoleOutput dd 0
NumberOfCharsWritten dd 0

.code
start:

;обчислення к-сти повторів А
mov ecx, N
mov edx, 0
L:
	mov eax, [X + ecx * type X - type X] 
    cmp eax, A
    jne skip
	add edx, 1
    skip:
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