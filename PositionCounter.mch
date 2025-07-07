MACHINE PositionCounter
    
SEES SmartSemaphore_ctx

VARIABLES 
    pos

INVARIANT         
    pos : NAT & pos < 4

INITIALISATION   
   pos := 0

OPERATIONS

      posinc = pos := (pos + 1) mod 4;

      pp <-- posget = pp := pos

END
