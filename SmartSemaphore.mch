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
    max_time
    
PROPERTIES

     min_time:NAT1  & max_time:NAT1

VARIABLES
    semaphoreNS, 
    semaphoreOL, 
    semaphoreLO, 
    semaphoreSN, 
    cars,
    time,
    order,
    has_priority,
    timer

INVARIANT

     // Tipagens
     semaphoreNS : SEMAPHORE --> COLOR &
     semaphoreSN : SEMAPHORE --> COLOR &
     semaphoreLO : SEMAPHORE --> COLOR &
     semaphoreOL : SEMAPHORE --> COLOR &
     cars : DIRECTION --> NAT   &
     time: STATE --> 0..max_time &
     order: seq(STATE) &
     has_priority: BOOL &
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
     semaphoreLO := {LEFT |-> GREEN, RIGHT |-> GREEN, AHEAD |-> GREEN} ||  
     semaphoreOL := {LEFT |-> GREEN, RIGHT |-> GREEN, AHEAD |-> GREEN} ||
     cars := DIRECTION * {0}   ||
     time := STATE * {max_time} ||
     order := [LO, DNS, DLO, NS] ||
     has_priority := FALSE ||
     timer := max_time

OPERATIONS 

    prioritize (ss) =
        PRE ss : STATE & ss /= order(1) & has_priority = FALSE
        THEN has_priority := TRUE || order := ss -> order 
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
        PRE nn : NATURAL & dd : DIRECTION
        THEN cars(dd) := cars(dd) + nn
        END;

    nt <-- process_semaphore =
        PRE 1=1
        THEN
            IF timer > 0 
           THEN timer := timer - 1 || nt := timer -1  
           // Colocar um ELSIF aqui para os semáforos amarelos?
            ELSE
                  IF has_priority = TRUE THEN timer := time(order(2)) || order := order \|/ 1 || nt := time(order(2))
                  ELSE  timer := time(order(2)) || order := order \|/ 1 ^ [order(1)] || nt := time(order(2)) END || 
                 IF order(2) = LO THEN 
                    semaphoreNS := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||
                    semaphoreSN := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||   
                    semaphoreLO := {LEFT |-> GREEN, RIGHT |-> GREEN, AHEAD |-> GREEN} ||  
                    semaphoreOL := {LEFT |-> GREEN, RIGHT |-> GREEN, AHEAD |-> GREEN} 
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
                    semaphoreNS :=  {LEFT |-> GREEN, RIGHT |-> GREEN, AHEAD |-> GREEN} ||  
                    semaphoreSN :={LEFT |-> GREEN, RIGHT |-> GREEN, AHEAD |-> GREEN} ||  
                    semaphoreLO := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||   
                    semaphoreOL := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} 
                END
            END 
         END;
 
    sl, sr,sa <-- status_semaphoreNS = 
        sl, sr, sa := semaphoreNS[{LEFT}], semaphoreNS[{RIGHT}], semaphoreNS[{AHEAD}] ;

    sl, sr,sa <-- status_semaphoreSN = 
        sl, sr, sa := semaphoreSN[{LEFT}], semaphoreSN[{RIGHT}], semaphoreSN[{AHEAD}] ;

    sl, sr,sa <-- status_semaphoreLO = 
        sl, sr, sa := semaphoreLO[{LEFT}], semaphoreLO[{RIGHT}], semaphoreLO[{AHEAD}] ;

   sl, sr,sa <-- status_semaphoreOL = 
        sl, sr, sa := semaphoreOL[{LEFT}], semaphoreOL[{RIGHT}], semaphoreOL[{AHEAD}] ;

    sq <-- show_sequency =
         sq := order;

   cs <-- current_state =
         cs := order(1)


/*
   tt, t2, t3 <-- tests =
   tt := ((cars(NORTH) + cars(SOUTH)) * max_time) / (max({cars(NORTH) + cars(SOUTH), cars(EAST) + cars(WEST)}))  ||
   t2 := (cars(NORTH) + cars(SOUTH)) ||
   t3 := (cars(NORTH) + cars(SOUTH)) / (max({cars(NORTH) + cars(SOUTH), cars(EAST) + cars(WEST)})) 
*/
       
END
