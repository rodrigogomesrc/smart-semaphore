MACHINE SizeCounter
    
CONSTANTS
    maximum_sze
    
PROPERTIES
    maximum_sze : NAT1

VARIABLES
    sze

INVARIANT 
    sze : NAT & sze <= maximum_sze

INITIALISATION 
    sze := 0

OPERATIONS

szeinc = 
	IF sze < maximum_sze
	THEN sze := sze + 1
	ELSE skip
    END;

szedec = 
	IF sze > 0 
	THEN sze := sze - 1
	ELSE skip
    END;

ss <-- szeget = ss := sze

END