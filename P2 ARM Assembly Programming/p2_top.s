.globl binary_search
binary_search:
    // Save link register and other registers to be modified
    PUSH {LR, R4-R7}

    // Store function parameters in other registers to free R0-R2 for general use 
    MOV R4, R0 // Numbers array base address
    MOV R5, R1 // Key
    MOV R6, R2 // Array length

    // Initialize search indices
    MOV R0, #0 // Start index
    SUB R7, R6, #1 // End index (length - 1)

SearchLoop:
    // Check if start > end (key not found)
    CMP R0, R7
    BGT NotFound

    // Calculate middle index
    ADD R2, R0, R7 // Start + end
    ASR R2, R2, #1 // Divide sum by 2

    // Get value at middle
    LDR R3, [R4, R2, LSL #2] // Value = numbers[middle]

    // Compare value with key
    CMP R3, R5
    BEQ Found
    BLT IncreaseStart
    BGT DecreaseEnd

IncreaseStart:
    // Start = middle + 1
    ADD R0, R2, #1 
    B SearchLoop

DecreaseEnd:
    // End = middle - 1
    SUB R7, R2, #1 
    B SearchLoop

Found:
    // Return middle as result
    MOV R0, R2
    B Exit

NotFound:
    // Key not found, return -1
    MOV R0, #-1
    B Exit

Exit:
    // Restore the saved changes
    POP {LR, R4-R7}    
    BX LR // Return
