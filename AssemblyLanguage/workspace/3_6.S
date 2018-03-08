assume cs:main

main segment
    mov ax,2
    add ax,ax
    add ax,ax
    mov ax,4C00
    int 21
main ends

end
