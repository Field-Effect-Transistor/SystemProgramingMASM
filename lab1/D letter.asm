.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
.data
hConsoleOutput dd 0
NumberOfCharsWritten dd 0
Symbol db 2 dup(60 dup (32), 10,13); 1-2
db 23 dup(32), 20 dup(219), 10, 13; 3
db 19 dup(32), 26 dup(219), 10, 13; 4
db 17 dup(32), 3 dup(219), 25 dup(176), 2 dup(219), 10, 13; 5
db 17 dup(32), 2 dup(219), 9 dup(176), 9 dup(219), 9 dup(176), 2 dup(219), 10, 13; 6
db 17 dup(32), 1 dup(219), 9 dup(176), 2 dup(219), 7 dup(32), 2 dup(219), 8 dup(176), 2 dup(219), 10, 13; 7
db 17 dup(32), 1 dup(219), 9 dup(176), 1 dup(219), 8 dup(32), 2 dup(219), 8 dup(176), 2 dup(219), 10, 13; 8
db 5 dup(16 dup(32), 2 dup(219), 8 dup(176), 2 dup(219), 8 dup(32), 2 dup(219), 8 dup(176), 2 dup(219), 10, 13); 9-13
db 16 dup(32), 1 dup(219), 9 dup(176), 2 dup(219), 8 dup(32), 2 dup(219), 8 dup(176), 2 dup(219), 10, 13; 14
db 15 dup(32), 2 dup(219), 9 dup(176), 2 dup(219), 8 dup(32), 2 dup(219), 8 dup(176), 2 dup(219), 10, 13; 15
db 15 dup(32), 2 dup(219), 7 dup(176), 3 dup(219), 9 dup(32), 2 dup(219), 8 dup(176), 2 dup(219), 10, 13; 16
db 14 dup(32), 2 dup(219), 7 dup(176), 3 dup(219), 10 dup(32), 2 dup(219), 8 dup(176), 2 dup(219), 10, 13; 17
db 10 dup(32), 5 dup(219), 9 dup(176), 13 dup(219), 9 dup(176), 4 dup(219), 10, 13; 18
db 9 dup(32), 6 dup(219), 13 dup(176), 9 dup(219), 11 dup(176), 3 dup(219), 10, 13; 19 
db 8 dup(32), 2 dup(219), 38 dup(176), 3 dup(219), 10, 13; 20
db 7 dup(32), 2 dup(219), 18 dup(176), 13 dup(219), 9 dup(176), 2 dup(219), 10, 13; 21 
db 7 dup(32), 2 dup(219), 7 dup(176), 25 dup(219), 8 dup(176), 2 dup(219), 10, 13; 22 
db 7 dup(32), 2 dup(219), 7 dup(176), 3 dup(219), 21 dup(32), 2 dup(219), 7 dup(176), 3 dup(219), 10, 13;23
db 7 dup(32), 2 dup(219), 6 dup(176), 3 dup(219), 22 dup(32), 2 dup(219), 7 dup(176), 3 dup(219), 10, 13;24
db 9 dup(32), 8 dup(219), 24 dup(32), 9 dup(219), 10, 13; 25
db 11 dup(32), 4 dup(219) , 28 dup(32), 4 dup(219), 10, 13; 26
db 2 dup(60 dup(32), 10, 13); 27-28
NumberOfCharsToWrite dd $-Symbol
ReadBuf db 128 dup(?)
hConsoleInput dd 0
.code
start:
call AllocConsole
push -11
call GetStdHandle
mov hConsoleOutput, eax
push 0
push offset NumberOfCharsWritten
push NumberOfCharsToWrite
push offset Symbol
push hConsoleOutput
call WriteConsoleA
push -10
call GetStdHandle
mov hConsoleInput, eax
push 0
push offset NumberOfCharsWritten
push 128
push offset ReadBuf
push hConsoleInput
call ReadConsoleA
push 0
call ExitProcess
end start