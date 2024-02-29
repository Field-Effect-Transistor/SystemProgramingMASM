.686 
.model flat, stdcall 
option casemap:none 
include \masm32\include\windows.inc 
include \masm32\include\kernel32.inc 
includelib \masm32\lib\kernel32.lib 
 
.data  
A dd 5d0h, 2720q, 10111010000b ;A4
B dd 00A5h, 0AB3Ch ; B3u
Cc dd 512h ;C4
LBL LABEL BYTE 
D dq 3.14e8 ;D fd
E dt 11111010b ;10
F dq 12356789ABCDEFh ;8
K  equ 4019d 
Message db 'Shapoval',13,10 
NumberOfCharsToWrite dd $-Message 
hConsoleOutput dd 0 
NumberOfCharsWritten dd 0 
 
.code 
start: 
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