MACHINE VArray
    
SEES SmartSemaphore_ctx

CONSTANTS 
   max_index
    
PROPERTIES       
   max_index:NAT & max_index = 4

VARIABLES 
   array

INVARIANT         
   array : 0..max_index --> STATE

INITIALISATION 
   array :: 0..max_index --> STATE

OPERATIONS

      set(ii,vv) =
        PRE ii : 0..max_index & vv : STATE
        THEN array(ii) := vv
        END;
      
      vv <-- get(ii) =
        PRE ii : 0..max_index
        THEN vv := array(ii)
        END

END