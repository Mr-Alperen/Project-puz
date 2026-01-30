section .text
global _start

%define PIT_CMD     0x43
%define PIT_CH2     0x42
%define SPEAKER     0x61

%define DOT_LEN     8000000
%define DASH_LEN    DOT_LEN*3
%define GAP_LEN     DOT_LEN

_start:
    call speaker_on

   
    call dot
    call gap
    call dot
    call gap
    call dot
    call gap
    call dot
    call letter_gap

    ; E (.)
    call dot
    call letter_gap

    ; L (.-..)
    call dot
    call gap
    call dash
    call gap
    call dot
    call gap
    call dot
    call letter_gap

    ; P (.--.)
    call dot
    call gap
    call dash
    call gap
    call dash
    call gap
    call dot

    call speaker_off

    mov rax, 60
    xor rdi, rdi
    syscall

; ------------------------

speaker_on:
    mov al, 0xB6
    out PIT_CMD, al

    mov ax, 1193        ; ~1000 Hz tone
    out PIT_CH2, al
    mov al, ah
    out PIT_CH2, al

    in al, SPEAKER
    or al, 3
    out SPEAKER, al
    ret

speaker_off:
    in al, SPEAKER
    and al, 0xFC
    out SPEAKER, al
    ret

dot:
    mov rcx, DOT_LEN
    call delay
    ret

dash:
    mov rcx, DASH_LEN
    call delay
    ret

gap:
    call speaker_off
    mov rcx, GAP_LEN
    call delay
    call speaker_on
    ret

letter_gap:
    call speaker_off
    mov rcx, DASH_LEN
    call delay
    call speaker_on
    ret

delay:
.loop:
    loop .loop
    ret
