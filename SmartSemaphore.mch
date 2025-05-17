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
    sequence,
    has_priority,
    current_state

INVARIANT

     // Tipagens
     semaphoreNS : SEMAPHORE --> COLOR &
     semaphoreSN : SEMAPHORE --> COLOR &
     semaphoreLO : SEMAPHORE --> COLOR &
     semaphoreOL : SEMAPHORE --> COLOR &
     cars : DIRECTION --> NAT   &
     time: STATE --> 0..max_time &
     sequence: perm(STATE) &
     has_priority: BOOL &
     current_state: STATE &

      // Requisitos de segurança

     // TODO: Simplificar essas quatro expressões (provavelmente usando OR)
    (semaphoreNS[{AHEAD}] = {GREEN}) => (semaphoreLO[{AHEAD}]  \/ semaphoreOL[{AHEAD}] = {RED} ) &
    (semaphoreSN[{AHEAD}] = {GREEN}) => (semaphoreLO[{AHEAD}]  \/ semaphoreOL[{AHEAD}] = {RED} ) &
    (semaphoreLO[{AHEAD}] = {GREEN}) => (semaphoreNS[{AHEAD}]  \/ semaphoreSN[{AHEAD}] = {RED} ) &
    (semaphoreOL[{AHEAD}] = {GREEN}) => (semaphoreNS[{AHEAD}]  \/ semaphoreSN[{AHEAD}] = {RED} ) &
   

     ( (semaphoreNS[{AHEAD}] = {RED} & semaphoreNS[{LEFT}] = {RED}) <=>  
            (semaphoreSN[{AHEAD}] = {RED} & semaphoreSN[{LEFT}] = {RED}) 
               & semaphoreLO[{AHEAD}]  = {RED} & semaphoreOL[{AHEAD}]  = {RED})  &

      ((semaphoreLO[{AHEAD}] = {RED} & semaphoreLO[{LEFT}] = {RED}) <=>  
            (semaphoreOL[{AHEAD}] = {RED} & semaphoreOL[{LEFT}] = {RED})  
                & semaphoreNS[{AHEAD}]  = {RED} & semaphoreSN[{AHEAD}]  = {RED})


INITIALISATION

     semaphoreNS := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||
     semaphoreSN := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||   
     semaphoreLO := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||  
     semaphoreOL := {LEFT |-> RED, RIGHT |-> RED, AHEAD |-> RED} ||
     cars := DIRECTION * {0}   ||
     time := STATE * {5} ||
     sequence := [LO, DNS, DLO, NS] ||
     has_priority := FALSE ||
     current_state := NS 

OPERATIONS 

    /*
    TODO: quando tiver prioridade e for para o próximo estado do semáforo, 
eu tenho que remover o estado colocado na frente e ir pro próximo
    */
    prioritize (ss) =
        PRE ss : STATE & ss /= current_state & has_priority = FALSE
        THEN has_priority := TRUE || sequence := ss -> sequence 
        END;

   calculate_times = 
       // Previne divisão por 0
       PRE max({(cars(NORTH) + cars(SOUTH)), (cars(EAST) + cars(WEST))}) /=0
       THEN 
            time := time <+ {NS |-> max({((cars(NORTH) + cars(SOUTH)) * max_time) / (max({cars(NORTH) + cars(SOUTH), cars(EAST) + cars(WEST)})), min_time}),
                                        LO |-> max({((cars(EAST) + cars(WEST)) * max_time) / (max({cars(NORTH) + cars(SOUTH), cars(EAST) + cars(WEST)})), min_time})     }  ||
            cars := DIRECTION * {0}
          
       END;

   addCars(nn,dd) = 
        PRE nn : NATURAL & dd : DIRECTION
        THEN cars(dd) := cars(dd) + nn
        END;
 
    sl, sr,sa <-- status_semaphoreNS = 
        sl, sr, sa := semaphoreNS[{LEFT}], semaphoreNS[{RIGHT}], semaphoreNS[{AHEAD}] ;

    sq <-- show_sequency =
         sq := sequence


/*
   tt, t2, t3 <-- tests =
   tt := ((cars(NORTH) + cars(SOUTH)) * max_time) / (max({cars(NORTH) + cars(SOUTH), cars(EAST) + cars(WEST)}))  ||
   t2 := (cars(NORTH) + cars(SOUTH)) ||
   t3 := (cars(NORTH) + cars(SOUTH)) / (max({cars(NORTH) + cars(SOUTH), cars(EAST) + cars(WEST)})) 
*/
       
END
