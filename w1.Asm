; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit  DB   0AH, 0DH, "Press Enter to Exit",0AH,0DH,0

         .DATA
S SDWORD ?
inpA DB 'Input a:',13,10,0
inpB DB 'Input b:',13,10,0
inpC DB 'Input c:',13,10,0
inpY DB 'Input y:',13,10,0
res DB 'Result=', 0
err DB 13,10,'Division by zero is coming. Please enter another numbers',13,10,0
valstr DB 15 DUP (' '), 0

         .DATA?
A SDWORD ?
B SDWORD ?
CV SDWORD ?
Y SDWORD ?
buffer DB 15 DUP (?)

         .CODE
Start:  
        XOR    EAX,EAX
restart:        
        Invoke StdOut, ADDR inpA
        Invoke StdIn, ADDR buffer,LengthOf buffer
        Invoke StripLF, ADDR buffer
        Invoke atol, ADDR buffer
        mov A,EAX
        
        Invoke StdOut, ADDR inpB
        Invoke StdIn, ADDR buffer,LengthOf buffer
        Invoke StripLF, ADDR buffer
        Invoke atol, ADDR buffer
        mov B,EAX
        
        Invoke StdOut, ADDR inpC
        Invoke StdIn, ADDR buffer,LengthOf buffer
        Invoke StripLF, ADDR buffer
        Invoke atol, ADDR buffer
        mov CV,EAX
        
        Invoke StdOut, ADDR inpY
        Invoke StdIn, ADDR buffer,LengthOf buffer
        Invoke StripLF, ADDR buffer
        Invoke atol, ADDR buffer
        mov  Y,EAX
        
        mov EAX, B
        imul EAX
        push EAX
        mov EAX, A
        pop EBX
        sub EAX,EBX
        mov EBX, Y
        sub EBX, A
        cmp EBX,0
        jne continue
        Invoke StdOut, ADDR err
        jmp restart
continue:
        cdq
        idiv EBX
        push EAX
        mov EAX, A
        imul EAX
        pop EBX
        add EAX, EBX
        sub EAX, CV
        mov S, EAX
        
        Invoke dwtoa, S, ADDR valstr
        Invoke StdOut, ADDR res
        Invoke StdOut, ADDR valstr
        
         
         Invoke StdOut, ADDR MsgExit
         Invoke StdIn, ADDR buffer, LengthOf buffer		
	
         Invoke ExitProcess,0
         End    Start

