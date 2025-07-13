/* Priority
 * Author: rodri
 * Creation date: 11/07/2025
 */
MACHINE
      Priority
      
SEES
    SmartSemaphore_ctx
    
CONSTANTS
      
    SIZE, 
    BOUND
    
PROPERTIES
    SIZE: NAT1 
    & SIZE = 4 
    & BOUND: NAT1 
    & BOUND = 3

VARIABLES
    order

INVARIANT
      
    order: seq(STATE) &
    size(order) = SIZE  

INITIALISATION
    order := [NS, LO, DNS, DLO]

OPERATIONS
 
    ss <-- current =
    PRE 1=1 
    THEN
        ss := order(1)
    END;

    ss <-- next =
    PRE 1 = 1
    THEN
        ss := order(2)
    END;

    ss <-- advance =
    PRE 1=1 
    THEN
        ss := order(1) ||
        order := (tail(order) <- order(1))
    END
END
