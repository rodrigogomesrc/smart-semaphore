
MACHINE         
   SemaphoreOrder
    
SEES 
   SmartSemaphore_ctx

VARIABLES         
   contents

INVARIANT         
   contents : seq(STATE) & size(contents) <= 4

INITIALISATION    
   contents := <>

OPERATIONS

     input(ee) =
        PRE ee : STATE & size(contents) < 4
        THEN contents := contents <- ee
        END;
      
     ee <-- output =
        PRE size(contents) > 0
        THEN ee := first(contents) || contents := tail(contents)
        END

END