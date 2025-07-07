
MACHINE         
   SemaphoreOrder
    
SEES 
   SmartSemaphore_ctx

VARIABLES         
   order

INVARIANT         
   order : seq(STATE) & size(order) <= 4

INITIALISATION    
   order := <>

OPERATIONS

      add_last(ss) =
        PRE ss : STATE & size(order) < 4
        THEN order := order <- ss
        END;
      
      nn <-- next =
        PRE size(order) > 0
        THEN nn := first(order) || order := tail(order)
        END

END