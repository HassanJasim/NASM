%include "asm_io.inc" 

SECTION .data

fmt: db "%d",10,0
str1: db    "         o|o         ",0
str2: db    "        oo|oo        ",0
str3: db    "       ooo|ooo       ",0
str4: db    "      oooo|oooo      ",0
str5: db    "     ooooo|ooooo     ",0
str6: db    "    oooooo|oooooo    ",0
str7: db    "   ooooooo|ooooooo   ",0
str8: db    "  oooooooo|oooooooo  ",0
str9: db    " ooooooooo|ooooooooo ",0
strBase: db "XXXXXXXXXXXXXXXXXXXXX",0
arr: dd 0,0,0,0,0,0,0,0,0
msg1: db "Initial Configuration",10,0
msg2: db "Final Configuration",10,0
msgerror: db "Incorrect number of arguments", 10,0
msge: db "Number out of range", 10,0
tempVar: dd 0
discs: dd 0
msg: db "%d",10,0

SECTION .text
extern printf
global asm_main


showp:
	enter 0,0
	pusha
	
	
	mov ebx, dword[discs]
	loop:
	dec ebx
	cmp ebx, 0
	je end_loop
	mov ecx, arr
	mov esi, [ecx + ebx*4]
	case1: cmp esi, 1
	jne case2
	mov eax, str1
	call print_string
	call print_nl
	jmp loop
	case2: cmp esi, 2
	jne case3
	mov eax, str2
	call print_string
	call print_nl
	jmp loop
	case3: cmp esi, 3
	jne case4
	mov eax, str3
	call print_string
	call print_nl
	jmp loop
	case4: cmp esi, 4
	jne case5
	mov eax, str4
	call print_string
	call print_nl
	jmp loop
	case5: cmp esi, 5
	jne case6
	mov eax, str5
	call print_string
	call print_nl
	jmp loop
	case6: cmp esi, 6
	jne case7
	mov eax, str6
	call print_string
	call print_nl
	jmp loop
	case7: cmp esi, 7
	jne case8
	mov eax, str7
	call print_string
	call print_nl
	jmp loop
	case8: cmp esi, 8
	jne case9
	mov eax, str8
	call print_string
	call print_nl
	jmp loop
	case9: cmp esi, 9
	jne end_loop
	mov eax, str9
	call print_string
	call print_nl
	jmp loop



	end_loop:
	mov eax, strBase
	call print_string
	call print_nl
	popa
	mov eax, 0
	leave 
	call read_char                    
	ret

; end subroutine showp


sorthem:
        enter 0,0
        pusha

        mov ecx, dword [ebp+8] ; Storing my array argument into ecx
        mov edx, dword [ebp+12] ; Storing the number of disks into edx

	cmp edx, 1
	je sorthem_end

	sub edx, 1
	push edx
	;add edx, 1

	add ecx, 4
	push ecx
	;sub ecx, 4
	
	call sorthem

	add esp, 8

	mov ebx, 0 ; i = 0 COUNTER

loop1:

	sub edx, 1
	cmp ebx, edx
	je loop_end
	add edx,1

	mov eax, [ecx+ebx*4]
	cmp eax, [ecx+ebx*4+4]
	ja loop_end

	mov eax, [ecx+ebx*4]
	cmp eax, [ecx+ebx*4+4]
	jb loop2

loop2:

     	; swapping elements

	mov eax, dword[ecx+ebx*4]
	mov [tempVar], eax

	mov eax, dword[ecx+ebx*4+4]
	mov [ecx+ebx*4], eax

	mov eax, dword [tempVar]
	mov [ecx+ebx*4+4], eax

	add ebx, 1

	jmp loop1

loop_end:

	push dword[discs]
	push arr
	call showp
	add esp, 8

sorthem_end:

        popa
        leave
        ret
; end subroutine sorthem


asm_main:
	push ebp
	mov ebp, esp

	mov eax, dword [ebp + 8]
	mov ebx, dword [ebp + 12]
	cmp eax, 2
	jne InputError

	
	mov eax, dword [ebx + 4]
	mov al, byte [eax]

	cmp al, '2'
	jb InputE
	cmp al, '9'
	ja InputE

	mov ecx, arr

	sub al, '0'
	add al, 1
	mov edx, 0
	mov dl, al
	push edx
	push ecx
	call rconf
	pop ecx
	pop edx
	mov dword[discs], edx
	mov eax, msg1
	call print_string              
	push edx
	push ecx
	call showp
	pop ecx
	pop edx
	push edx
	push ecx
	call sorthem
	pop ecx
	pop edx

	mov eax, msg2
	call print_string                  
	push edx
	push ecx
	call showp
	pop ecx
	pop edx

	jmp DONE


InputError:
	push msgerror
	call printf
	jmp DONE
InputE:
	push msge
	call printf
	jmp DONE

DONE:

	mov esp, ebp    
	pop ebp
	ret             
