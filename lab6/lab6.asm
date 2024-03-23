.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\msvcrt.lib

.data 

X dd 10 dup(0)			;масив 
N equ ($-X) / type X    ;розмір масиву
A dd 0					;число, яке потрібно знайти у масиві
Res dd 0				;результат

hConsoleInput dd 0		;дескриптор консолі для вводу
hConsoleOutput dd 0		;дескриптор консолі для виводу
NumberOfChars dd 0		;кількість введених/виведених символів
ReadBuf db 32 dup(0)	;буфер для введених символів
MessageToGetA db 'Input A: ', 10, 13
NumberOfChToWMessageToGetA dd $-MessageToGetA
Message db 'Input elements of array:', 10, 13
NumberOfChToWMessage dd $-Message
Format	db 'Result = %d', 0
Result	db	32 dup (0), 10, 13
NumberOfChToWResult dd $-Result

.code
start:
call Input

push dword ptr A	;третій параметр - число
push dword ptr N	;другий параметр - кількість елементів у масиві
push offset X		;перший параметр - адреса масиву
call Calculation
mov Res, eax

call Output

invoke ExitProcess, 0

;процедура вводу даних - параметри передаються через глобальні змінні
Input proc
	;отримання числа А
	invoke GetStdHandle, -11
	mov hConsoleOutput, eax
	invoke WriteConsoleA, hConsoleOutput, addr MessageToGetA, NumberOfChToWMessageToGetA, addr NumberOfChars, 0
	invoke GetStdHandle, -10
	mov hConsoleInput, eax
	invoke ReadConsoleA, hConsoleInput, addr ReadBuf, 32, addr NumberOfChars, 0
	invoke crt_atoi, addr ReadBuf
	mov A, eax

	;отримання масиву
	invoke GetStdHandle, -11
	mov hConsoleOutput, eax
	invoke WriteConsoleA, hConsoleOutput, addr Message, NumberOfChToWMessage, addr NumberOfChars, 0
	invoke GetStdHandle, -10
	mov hConsoleInput, eax
	mov ecx, dword ptr N
	lea ebx, X
	mov edi, 0
	L_input:
		push ecx
		invoke ReadConsoleA, hConsoleInput, addr ReadBuf, 32, addr NumberOfChars, 0
		invoke crt_atoi, addr ReadBuf
		pop ecx
		mov [ebx][edi], eax
		add edi, 4
		loop L_input
	ret
Input endp

;процедура обчислення суми в циклі - параметри передаються через стек, результат в регістрі eax
Calculation proc 
	push ebp
	mov ebp, esp
	mov ebx, [ebp + 8]	;перший параметр - адреса масиву
	mov ecx, [ebp + 12]	;другий параметр - кількість елементів у масиві
	mov edx, 0
	L:
		mov eax, 0
		cmp [ebx + ecx * type X - type X], eax
		jg x_g_0	;перевірка, чи Х > 0
		ReturnToLoop:
		loop L
	mov eax, edx		;результат в регістрі eax
	pop ebp
	ret 8

	;Х > 0
	x_g_0:
		mov eax, [ebp + 16] ;третій параметр - число
		cmp eax, [ebx + ecx * type X - type X]
		jge A_ge_x ;перевірка, чи Х <= A
		jmp ReturnToLoop
	
	;Х <= A
	A_ge_x:
		add edx, 1
		jmp ReturnToLoop

Calculation endp

;процедура виводу даних - параметри передаються через глобальні змінні
Output proc
	invoke wsprintfA, addr Result, addr Format, Res
	invoke GetStdHandle, -11
	mov hConsoleOutput, eax
	invoke WriteConsoleA, hConsoleOutput, addr Result, NumberOfChToWResult, addr NumberOfChars, 0
	ret
Output endp

end start