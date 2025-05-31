/* SmartSemaphore
 * Author: Marlus e Rodrigo
 * Creation date: 12/05/2025
 */

MACHINE
    SmartSemaphore

SETS 
     SEMAPHORE = {LEFT,RIGHT,AHEAD};
     COLOR = {GREEN,YELLOW,RED};
     DIRECTION = {NORTH, SOUTH, EAST, WEST};
     STATE = {NS, LO, DNS, DLO} // Norte-Sul, Leste-Oeste, Diagonal Norte-Sul, Diagonal Leste-Oeste
     
CONSTANTS

    min_time,
    max_time,
    max_cars
    
PROPERTIES

     min_time:1..10  & 
     max_time:0..10 & 
     max_cars:0..10 &
     max_time > min_time

VARIABLES
    semaphoreNS, 
    semaphoreOL, 
    semaphoreLO, 
    semaphoreSN, 
    cars,
    time,
    order,
    has_priority,
    priority,
    timer

INVARIANT

     // Tipagens
     semaphoreNS : SEMAPHORE --> COLOR &
     semaphoreSN : SEMAPHORE --> COLOR &
     semaphoreLO : SEMAPHORE --> COLOR &
     semaphoreOL : SEMAPHORE --> COLOR &
     cars : DIRECTION --> 0..max_cars   &
     time: STATE --> 0..max_time &
     order: seq(STATE) &
     has_priority: BOOL &
     priority: STATE &
     timer: 0..max_time &

      // Requisitos de segurança
 ((semaphoreNS(AHEAD) = GREEN)  or (semaphoreSN(AHEAD) = GREEN)) => (semaphoreLO(AHEAD) = RED & semaphoreOL(AHEAD) = RED) &  // NS
   ((semaphoreLO(AHEAD) = GREEN)  or (semaphoreOL(AHEAD) = GREEN)) => (semaphoreSN(AHEAD) = RED & semaphoreNS(AHEAD) = RED) &  // LO

   (semaphoreNS(LEFT) = GREEN or semaphoreSN(LEFT) = GREEN) 
         => (semaphoreLO(LEFT) = RED &  semaphoreLO(AHEAD) = RED &  semaphoreOL(LEFT) = RED &  semaphoreOL(AHEAD) = RED) & // DNS

    (semaphoreOL(LEFT) = GREEN or semaphoreLO(LEFT) = GREEN) 
         => (semaphoreNS(LEFT) = RED &  semaphoreNS(AHEAD) = RED &  semaphoreSN(LEFT) = RED &  semaphoreSN(AHEAD) = RED)   // DLO


INITIALISATION

     semaphoreNS := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||
     semaphoreSN := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||   
     semaphoreLO := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} ||  
     semaphoreOL := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} ||
     cars := DIRECTION * {0}   ||
     time := STATE * {max_time} ||
     order := [LO, DNS, DLO, NS] ||
     has_priority := FALSE ||
     timer := max_time ||
     priority := NS

OPERATIONS 

    prioritize (ss) =
        PRE ss : STATE & has_priority = FALSE
        THEN has_priority := TRUE || priority := ss || timer := max_time
        END;

   calculate_times = 
       // Previne divisão por 0
       PRE max({(cars(NORTH) + cars(SOUTH)), (cars(EAST) + cars(WEST))}) /=0
       THEN 
            time := time <+ {NS |-> max({((cars(NORTH) + cars(SOUTH)) * max_time) / (max({cars(NORTH) + cars(SOUTH), cars(EAST) + cars(WEST)})), min_time}),
                                        LO |-> max({((cars(EAST) + cars(WEST)) * max_time) / (max({cars(NORTH) + cars(SOUTH), cars(EAST) + cars(WEST)})), min_time}), 
                                        DNS |-> max({((cars(NORTH) + cars(SOUTH)) * max_time) / (max({cars(NORTH) + cars(SOUTH), cars(EAST) + cars(WEST)})), min_time}),
                                        DLO |-> max({((cars(EAST) + cars(WEST)) * max_time) / (max({cars(NORTH) + cars(SOUTH), cars(EAST) + cars(WEST)})), min_time})}  ||
            cars := DIRECTION * {0}
          
       END;

   addCars(nn,dd) = 
        PRE nn : NATURAL & dd : DIRECTION & cars(dd) + nn < max_cars
        THEN cars(dd) := cars(dd) + nn
        END;

    nt <-- process_semaphore =
        PRE has_priority = FALSE
        THEN
            IF timer > 0 
           THEN timer := timer - 1 || nt := timer -1  
            ELSE
                  timer := time(order(2)) || order := order \|/ 1 ^ [order(1)] || nt := time(order(2)) ||
                 IF order(2) = LO THEN 
                     semaphoreNS := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||
                     semaphoreSN := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||   
                     semaphoreLO := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} ||  
                     semaphoreOL := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} 
                ELSIF order(2) = DNS THEN 
                    semaphoreNS := {LEFT |-> GREEN, RIGHT |-> RED, AHEAD |-> GREEN} ||
                    semaphoreSN := {LEFT |-> GREEN, RIGHT |-> RED, AHEAD |-> GREEN} ||
                    semaphoreLO := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} ||
                    semaphoreOL :=  {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} 
                ELSIF order(2) = DLO THEN  
                    semaphoreNS := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN}  ||
                    semaphoreSN :=  {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} ||
                    semaphoreLO := {LEFT |-> GREEN, RIGHT |-> RED, AHEAD |-> GREEN} ||
                    semaphoreOL :=  {LEFT |-> GREEN, RIGHT |-> RED, AHEAD |-> GREEN} 
                 ELSE
                    semaphoreNS :=  {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} ||  
                    semaphoreSN :={LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} ||  
                    semaphoreLO := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||   
                    semaphoreOL := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} 
                END
            END 
         END;

    nt <-- process_semaphore_priority =
        PRE has_priority = TRUE
        THEN
            IF timer > 0 
           THEN timer := timer - 1 || nt := timer -1  
            ELSE
                 timer := time(order(2)) || nt := time(order(2)) ||
                 IF priority = LO THEN 
                    semaphoreNS := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||
                    semaphoreSN := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||   
                    semaphoreLO := {LEFT |-> GREEN, RIGHT |-> GREEN, AHEAD |-> GREEN} ||  
                    semaphoreOL := {LEFT |-> GREEN, RIGHT |-> GREEN, AHEAD |-> GREEN} 
                ELSIF priority = DNS THEN 
                    semaphoreNS := {LEFT |-> GREEN, RIGHT |-> RED, AHEAD |-> GREEN} ||
                    semaphoreSN := {LEFT |-> GREEN, RIGHT |-> RED, AHEAD |-> GREEN} ||
                    semaphoreLO := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} ||
                    semaphoreOL :=  {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} 
                ELSIF priority = DLO THEN  
                    semaphoreNS := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN}  ||
                    semaphoreSN :=  {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} ||
                    semaphoreLO := {LEFT |-> GREEN, RIGHT |-> RED, AHEAD |-> GREEN} ||
                    semaphoreOL :=  {LEFT |-> GREEN, RIGHT |-> RED, AHEAD |-> GREEN} 
                 ELSE
                    semaphoreNS :=  {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} ||  
                    semaphoreSN :={LEFT |-> RED, RIGHT |-> RED, AHEAD |-> GREEN} ||  
                    semaphoreLO := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||   
                    semaphoreOL := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} 
                END || has_priority := FALSE
            END 
         END;
 
    sl, sr,sa <-- status_semaphoreNS = 
        BEGIN
            sl :: semaphoreNS[{LEFT}] ||
            sr :: semaphoreNS[{RIGHT}] ||
            sa :: semaphoreNS[{LEFT}]
       END;
 
    sl, sr,sa <-- status_semaphoreSN = 
        BEGIN
            sl :: semaphoreSN[{LEFT}] ||
            sr :: semaphoreSN[{RIGHT}] ||
            sa :: semaphoreSN[{LEFT}]
        END;
    sl, sr,sa <-- status_semaphoreLO = 
         BEGIN
            sl :: semaphoreLO[{LEFT}] ||
            sr :: semaphoreLO[{RIGHT}] ||
            sa :: semaphoreLO[{LEFT}]
        END;

   sl, sr,sa <-- status_semaphoreOL = 
          BEGIN
            sl :: semaphoreOL[{LEFT}] ||
            sr :: semaphoreOL[{RIGHT}] ||
            sa :: semaphoreOL[{LEFT}]
        END
       
END
