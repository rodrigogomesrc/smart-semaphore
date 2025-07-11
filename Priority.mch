/* Priority
 * Author: rodri
 * Creation date: 11/07/2025
 */
MACHINE
      Priority
      
SEES
     SmartSemaphore_ctx
     
CONSTANTS
   SIZE
   
PROPERTIES
   SIZE = 4
     
VARIABLES
  order
  
INVARIANT
  order: seq(STATE) &
  size(order) <= SIZE
  
INITIALISATION
   order := <>
  
OPERATIONS
      
   insert(ss) =
   PRE ss:STATE & size(order) < SIZE
   THEN     
         order := order <- ss
   END;
   
   ss <-- current = 
   PRE size(order) >= 1 
   THEN
         ss := order(1)
   END;
   
   ss <-- next = 
   PRE size(order) > 1 
   THEN
         ss := order(2)
   END;
   
   ss <-- advance =
   PRE size(order) > 1 
   THEN
         ss := order(1) || order := order \|/ 1 ^ [order(1)]
   END
      

END
