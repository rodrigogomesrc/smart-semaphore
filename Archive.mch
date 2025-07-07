MACHINE        
    Archive
    
SEES
   SmartSemaphore_ctx

VARIABLES         
    read, entries

INVARIANT         
    read : NAT & entries : seq(STATE)

INITIALISATION    
    read := 0 || 
    entries := {}

OPERATIONS

  ee <-- lookup =
      PRE read : NAT1 & read <= size(entries)
      THEN ee := entries(read) 
      END;

  resetread = 
      read := 0;

  incread = 
      read := read + 1;

  enter(ee) =
      PRE ee : STATE
      THEN 
          entries := entries <- ee
      END

END
