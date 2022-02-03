TITLE Composite Numbers     (program4_powdrild.asm)

; Author: David Powdrill
; Last Modified: 05/09/2020
; OSU email address: powdrild@oregonstate.edu
; Course number/section: 271-400
; Project Number: 04                 Due Date: 5/10/2020
; Description: A program that asks the user to input the number of composite numbers they'd like to be displayed (1-400) and then displays that number of composite numbers in chronological order. 

INCLUDE Irvine32.inc

UPPER_LIMIT = 400
LOWER_LIMIT = 1

.data
intro				BYTE	"Composite Numbers	Programmed by David ", 0
ec_1				BYTE	"**EC: Align the output columns. ", 0
instruct_1			BYTE	"Enter the number of composite numbers you would like to see. ", 0
instruct_2			BYTE	"I'll accept orders for up to 400 composites. ", 0
prompt_1			BYTE	"Enter the number of composites to display [1 .. 400]: ", 0
error				BYTE	"Out of range. Try again. ", 0
goodBye				BYTE	"Results certified by David. Goodbye. ", 0
compNum				DWORD	?											;number of composite numbers to display
compCount			DWORD	0											;count of composite numbers displayed for new line
value				DWORD	4											;value that is being tested
divisor				DWORD	2											;divisor to check if composite
invalid				DWORD	0											;invalid range counter

.code
main PROC
	call	introduction
	call	getUserData
	call	showComposites
	call	farewell
	exit	; exit to operating system
main ENDP

;----------------------------------------------------------
introduction	PROC
;
; Displays title, author, extra credit done, and program instructions.
;
; Preconditions: None
;
; Postconditions: None
;
; Receives: None
;
; Returns: None 
;----------------------------------------------------------
	
	;prints title and author
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf

	;prints extra credit
	mov		edx, OFFSET ec_1
	call	WriteString
	call	CrLf
	call	CrLf

	;prints instructions
	mov		edx, OFFSET instruct_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruct_2
	call	WriteString
	call	CrLf
	call	CrLf
	
	ret

introduction		ENDP

;---------------------------------------------------------
getUserData		PROC
;
; Gets the number of composites to be displayed and calls validate.
; 
; Preconditions: None
;
; Postconditons: changes registers eax and ebx
;
; Receives: 
;	compNum		= number of composites to display
;
; Returns:
;	compNum		= number of composites to display
;	invalid		= invalid range counter
;---------------------------------------------------------
prompt:
	;sets invalid to 0
	mov		ebx, invalid
	mov		ebx, 0
	mov		invalid, ebx
	
	;prompts user to enter number of composites desired
	mov		edx, OFFSET prompt_1
	call	WriteString

	;stores number of composties
	call	ReadInt
	mov		compNum, eax

	;validates number of composites is in range
	call	validate

	;if invalid entry repeat prompt
	mov		ebx, invalid
	cmp		ebx, 0
	jg		prompt

	ret


getUserData		ENDP

;---------------------------------------------------------
validate		PROC
;
; Validates that the number of composites wished to be displayed 
; is in range. 
;
; Preconditions: user has entered a value
;
; Postconditions: changes register eax if invalid. 
;
; Receives: 
;	eax			= number of composites to display
; 
; Returns: 
;	if valid compNum = number of composites
;	if invalid error = error message
;---------------------------------------------------------
	
	;checks to see num is in limit
	cmp		eax, LOWER_LIMIT
	jl		error1
	cmp		eax, UPPER_LIMIT
	jg		error1
	call	CrLf
	jmp		validend

error1:
	;prints error message when number is out of range
	mov		edx, OFFSET error
	call	WriteString
	call	CrLf

	;increase invalid by 1
	mov		eax, invalid
	inc		eax
	mov		invalid, eax
	jmp		validend

validend:
	ret

validate		ENDP

;---------------------------------------------------------
showComposites	PROC
;
; Determines if the value is a composite number
;
; Preconditions: compNum is validated within range
;
; Postconditions: changes registers eax, ebx, ecx, and edx.
;
; Receives: 
;	compNum		= number of composites to display
;	value		= value that is tested if composite
;	divisor		= divisor to check for composite
;
; Returns: 
;	compNum		= number of composites to display (0)
;	value		= value that is tested if composite
;	divisor		= divisor to check for composite
;---------------------------------------------------------
	
	mov		ecx, compNum
	mov		eax, value
compcheck:
	;checks to see if made to the end of divisors
	mov		ebx, divisor
	cmp		ebx, value
	je		notcomposite

	;divides value by divisor
	mov		eax, value
	mov		ebx, divisor
	xor		edx, edx
	div		ebx						;divides value by divisor

	;checks for remainder
	cmp		edx, 0
	jne		incdivisor				;if there is a remainder
	call	isComposite

	;sets divisor back to start 
	mov		ebx, divisor
	mov		ebx, 2
	mov		divisor, ebx
	loop	compcheck
	jmp		complete				;if all composite numbers have been displayed

incdivisor:
	;increases divisor by 1
	mov		ebx, divisor
	inc		ebx
	mov		divisor, ebx
	jmp		compcheck

complete:
	ret

notcomposite:
	;increases value by 1
	mov		eax, value
	inc		eax
	mov		value, eax

	;sets divisor back to start
	mov		ebx, divisor
	mov		ebx, 2
	mov		divisor, ebx
	jmp		compcheck



showComposites	ENDP

;---------------------------------------------------------
isComposite	PROC
;
; Displays composite numbers in rows of 10 composite numbers
; each.
;
; Preconditions: value is composite
;
; Postconditions: changes registers eax, ebx, edx
;
; Receives: 
;	value		= value that is tested to be composite
;	compCount	= number of composite numbers displayed
;
; Returns:
;	value		= value that is tested to be composite
;	compCount	= number of composite numbers displayed
;---------------------------------------------------------
	;checks if new line needed
	mov		eax, compCount
	cmp		eax, 9
	jg		newline					;if there are 10 composites on the line already

	;displays composite number
	mov		eax, value
	call	WriteDec
	mov		al, 9					;tab character
	call	WriteChar

	;increases count of composites displayed per line
	mov		ebx, compCount
	inc		ebx
	mov		compCount, ebx
	jmp		complete1

newline:
	;starts a new line
	call	CrLf

	;displays composite number
	mov		eax, value
	call	WriteDec
	mov		al, 9					;tab character
	call	WriteChar

	;resets count of composites displayed per line
	mov		edx, compCount
	mov		edx, 1
	mov		compCount, edx
	jmp		complete1

complete1:
	;increases value by 1 
	mov		eax, value
	inc		eax
	mov		value, eax

	ret

isComposite		ENDP

;---------------------------------------------------------
farewell		PROC
;
; Displays a farewell message to the user. 
;
; Preconditions: All composite numbers have been displayed. 
;
; Postconditions: None
;
; Receives: None
;
; Returns: None
;---------------------------------------------------------
	;prints farwell message to user
	call	CrLf
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	
	ret

farewell		ENDP

END main

