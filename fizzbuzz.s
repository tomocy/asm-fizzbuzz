.text
.global main
main:
     mov $1, %rcx
 .print_begin:
     cmp $31, %rcx
     jz .print_end
     mov $0, %rdx
     mov %rcx, %rax
     mov $15, %rdi
     div %rdi
     cmp $0, %rdx
     jz .print_fizzbuzz
     mov $0, %rdx
     mov %rcx, %rax
     mov $3, %rdi
     div %rdi
     cmp $0, %rdx
     jz .print_fizz
     mov $0, %rdx
     mov %rcx, %rax
     mov $5, %rdi
     div %rdi
     cmp $0, %rdx
     jz .print_buzz
     push %rcx
     mov %rcx, %rdi
     call print_number
     pop %rcx
     jmp .print_newline
 .print_fizz:
     push %rcx
     mov $1, %rdi
     lea fizz(%rip), %rsi
     mov $4, %rdx
     mov $1, %rax
     syscall
     pop %rcx
     jmp .print_newline
 .print_buzz:
     push %rcx
     mov $1, %rdi
     lea buzz(%rip), %rsi
     mov $4, %rdx
     mov $1, %rax
     syscall
     pop %rcx
     jmp .print_newline
 .print_fizzbuzz:
     push %rcx
     mov $1, %rdi
     lea fizzbuzz(%rip), %rsi
     mov $8, %rdx
     mov $1, %rax
     syscall
     pop %rcx
     jmp .print_newline
 .print_newline:
     push %rcx
     mov $1, %rdi
     lea newline(%rip), %rsi
     mov $1, %rdx
     mov $1, %rax
     syscall
     pop %rcx
     inc %rcx
     jmp .print_begin
 .print_end:
    mov $0x3c, %rax
    syscall

.text
print_number:
    push %rbp
    mov %rsp, %rbp

    mov %rdi, %r8

    # Count the digists of the number to allocate the just right size of the buffer for the number to print.
    mov $1, %rcx
    mov %r8, %r9
.count_digits_begin:
    mov $0, %rdx
    mov %r9, %rax
    mov $10, %r10
    div %r10
    cmp $0, %rax
    jz .count_digits_end
    inc %rcx
    mov %rax, %r9
    jmp .count_digits_begin
.count_digits_end:

    mov $1, %rdi

    # Calculate the buffer address of the number to print for RSI.
    # Allocate the number of the bytes for the number in the stack frame,
    # and assign the digits one by one as the one byte characters.
    sub %rcx, %rsp
    mov %rsp, %rsi
    mov %rcx, %r9
    mov $0, %rcx
.assign_chars_begin:
    cmp %rcx, %r9
    jz .assign_chars_end
    mov $0, %rdx
    mov %r8, %rax
    mov $10, %r10
    div %r10
    mov %rax, %r8
    mov %rdx, %r10
    add $0x30, %r10
    mov %rsi, %r11
    add %r9, %r11
    sub $1, %r11
    sub %rcx, %r11
    mov %r10b, (%r11)
    inc %rcx
    jmp .assign_chars_begin
.assign_chars_end:

    mov $4, %rdx
    mov $1, %rax
    syscall

    mov %rbp, %rsp
    pop %rbp
    ret

.data
fizz:
    .ascii "fizz"
.data
buzz:
    .ascii "buzz"
.data
fizzbuzz:
    .ascii "fizzbuzz"
.data
newline:
    .ascii "\n"
