/* SmartSemaphore
 * Author: Rodrigo
 * Creation date: 12/05/2025
 */

MACHINE
    SmartSemaphore

SEES
    SmartSemaphore_ctx

VARIABLES

    semaphores,
    paths,
    cars,
    time,
    order,
    has_priority,
    priority,
    timer,
    yellow_timer

INVARIANT

     cars : DIRECTION --> 0..max_cars   &
     time: STATE --> 0..max_time &
     order: seq(STATE) &
     has_priority: BOOL &
     priority: STATE &
     timer: 0..max_time &
     yellow_timer: 0..yellow_time &
     semaphores: SEMAPHORE --> COLOR &
     paths: SEMAPHORE --> POW((0..5) * (0..5)) &
     card({ s1, s2 | s1 : semaphores~[{GREEN}] & s2 : semaphores~[{GREEN}] & s1 /= s2 & paths(s1) /\ paths(s2) /= {} }) = 0
     

INITIALISATION

     semaphores := (SEMAPHORE * {RED}) <+ {LO_A |-> GREEN, OL_A |-> GREEN} ||
     cars := DIRECTION * {0}   ||
     time := STATE * {max_time} ||
     order := [LO, NS, DNS, DLO] ||
     has_priority := FALSE ||
     timer := max_time ||
     priority := NS || 
     yellow_timer := yellow_time ||
     paths := {
	NS_L |-> {0 |-> 2, 1 |-> 2, 2 |-> 3, 3 |-> 4, 3 |-> 5}, 
        NS_A |-> {
           0 |-> 0, 1 |-> 0, 2 |-> 0, 3 |-> 0, 4 |-> 0, 5 |-> 0,
           0 |-> 1, 1 |-> 1, 2 |-> 1, 3 |-> 1, 4 |-> 1, 5 |-> 1,
           0 |-> 2, 1 |-> 2, 2 |-> 2, 3 |-> 2, 4 |-> 2, 5 |-> 2
	}, 
        NS_R |-> {0 |-> 0},
	SN_L |-> {5 |-> 3, 4 |-> 3, 3 |-> 2, 2 |-> 1, 2 |-> 0}, 
        SN_A |-> {
           0 |-> 3, 1 |-> 3, 2 |-> 3, 3 |-> 3, 4 |-> 3, 5 |-> 3,
           0 |-> 4, 1 |-> 4, 2 |-> 4, 3 |-> 4, 4 |-> 4, 5 |-> 4,
           0 |-> 5, 1 |-> 5, 2 |-> 5, 3 |-> 5, 4 |-> 5, 5 |-> 5
	}, 
        SN_R |-> {5 |-> 5},
	LO_L |-> {2 |-> 5, 2 |-> 4, 3 |-> 3, 4 |-> 2, 5 |-> 2}, 
        LO_A |-> {
           0 |-> 0, 0 |-> 1, 0 |-> 2, 0 |-> 3, 0 |-> 4, 0 |-> 5,
           1 |-> 0, 1 |-> 1, 1 |-> 2, 1 |-> 3, 1 |-> 4, 1 |-> 5, 
           2 |-> 0, 2 |-> 1, 2 |-> 2, 2 |-> 3, 2 |-> 4, 2 |-> 5
        }, 
        LO_R |-> {0 |-> 5},
        OL_L |-> {3 |-> 0, 3 |-> 1, 2 |-> 2, 1 |-> 3, 0 |-> 3}, 
        OL_A |-> {
           3 |-> 0, 3 |-> 1, 3 |-> 2, 3 |-> 3, 3 |-> 4, 3 |-> 5,
           4 |-> 0, 4 |-> 1, 4 |-> 2, 4 |-> 3, 4 |-> 4, 4 |-> 5, 
           5 |-> 0, 5 |-> 1, 5 |-> 2, 5 |-> 3, 5 |-> 4, 5 |-> 5
	}, 
        OL_R |-> {5 |-> 0}
      }

OPERATIONS 

    prioritize (ss) =
        PRE ss : STATE & has_priority = FALSE & first(order) /= ss
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
        PRE nn : NAT & dd : DIRECTION & cars(dd) + nn < max_cars
        THEN cars(dd) := cars(dd) + nn
        END;

   
    st, yt <-- process_semaphore =
        PRE has_priority = FALSE
        THEN
            IF timer > 0 
            	THEN timer := timer - 1 || st := timer -1 || yt := yellow_timer
            ELSIF (timer = 0 & yellow_timer > 0) THEN
                  IF order(1) = LO THEN 
                             semaphores := (SEMAPHORE * {RED}) <+ {LO_A |-> YELLOW, OL_A |-> YELLOW}

                 ELSIF order(1) = DNS THEN
                             semaphores := (SEMAPHORE * {RED}) <+ {SN_L |-> YELLOW, SN_R |-> YELLOW, NS_L |-> YELLOW, 
                                    NS_R |-> YELLOW, OL_R |-> YELLOW, LO_R |-> YELLOW}
                        
                 ELSIF order(1) = DLO THEN  
                             semaphores := (SEMAPHORE * {RED}) <+ {SN_R |-> YELLOW, NS_R |-> YELLOW, OL_R |-> YELLOW, 
                                   OL_L |-> YELLOW, LO_R |-> YELLOW, LO_L |-> YELLOW}

                 ELSE
                    semaphores := (SEMAPHORE * {RED}) <+ {NS_A |-> YELLOW, SN_A |-> YELLOW}               
                 END ||
                yellow_timer := yellow_timer -1 || st := timer || yt := yellow_timer -1       	
            ELSE
                timer := time(order(2)) || order := order \|/ 1 ^ [order(1)] ||
                 IF order(2) = LO THEN 
		        semaphores := (SEMAPHORE * {RED}) <+ {LO_A |-> GREEN, OL_A |-> GREEN}

                 ELSIF order(2) = DNS THEN
                        semaphores := (SEMAPHORE * {RED}) <+ {SN_L |-> GREEN, SN_R |-> GREEN, NS_L |-> GREEN, 
                              NS_R |-> GREEN, OL_R |-> GREEN, LO_R |-> GREEN}
                        
                 ELSIF order(2) = DLO THEN  
                        semaphores := (SEMAPHORE * {RED}) <+ {SN_R |-> GREEN, NS_R |-> GREEN, OL_R |-> GREEN, 
                               OL_L |-> GREEN, LO_R |-> GREEN, LO_L |-> GREEN}

                 ELSE
                        semaphores := (SEMAPHORE * {RED}) <+ {NS_A |-> GREEN, SN_A |-> GREEN}               
                 END ||
                yt := yellow_timer || st := time(order(2)) || yellow_timer := yellow_time
            END 
         END;

     st, yt <-- process_semaphore_priority =
        PRE has_priority = TRUE
        THEN
            IF timer > 0 
            	THEN timer := timer - 1 || st := timer -1 || yt := yellow_timer
            ELSIF (timer = 0 & yellow_timer > 0) THEN
                  IF order(1) = LO THEN 
                             semaphores := (SEMAPHORE * {RED}) <+ {LO_A |-> YELLOW, OL_A |-> YELLOW}

                 ELSIF order(1) = DNS THEN
                             semaphores := (SEMAPHORE * {RED}) <+ {SN_L |-> YELLOW, SN_R |-> YELLOW, NS_L |-> YELLOW, 
                                    NS_R |-> YELLOW, OL_R |-> YELLOW, LO_R |-> YELLOW}
                        
                 ELSIF order(1) = DLO THEN  
                             semaphores := (SEMAPHORE * {RED}) <+ {SN_R |-> YELLOW, NS_R |-> YELLOW, OL_R |-> YELLOW, 
                                   OL_L |-> YELLOW, LO_R |-> YELLOW, LO_L |-> YELLOW}

                 ELSE
                    semaphores := (SEMAPHORE * {RED}) <+ {NS_A |-> YELLOW, SN_A |-> YELLOW}                      
                END ||
                yellow_timer := yellow_timer -1 || st := timer || yt := yellow_timer -1       	
            ELSE
                 timer := time(order(2)) ||
                 IF order(2) = LO THEN 
		        semaphores := (SEMAPHORE * {RED}) <+ {LO_A |-> GREEN, OL_A |-> GREEN}

                 ELSIF order(2) = DNS THEN
                        semaphores := (SEMAPHORE * {RED}) <+ {SN_L |-> GREEN, SN_R |-> GREEN, NS_L |-> GREEN, 
                              NS_R |-> GREEN, OL_R |-> GREEN, LO_R |-> GREEN}
                        
                 ELSIF order(2) = DLO THEN  
                        semaphores := (SEMAPHORE * {RED}) <+ {SN_R |-> GREEN, NS_R |-> GREEN, OL_R |-> GREEN, 
                               OL_L |-> GREEN, LO_R |-> GREEN, LO_L |-> GREEN}

                 ELSE
                        semaphores := (SEMAPHORE * {RED}) <+ {NS_A |-> GREEN, SN_A |-> GREEN}               
                 END ||
                yt := yellow_timer || st := time(order(2)) || has_priority := FALSE || yellow_timer := yellow_time
            END 
       END;
 
     ll, aa, rr <-- status_semaphoreNS = 
       BEGIN
           ll := semaphores(NS_L) ||  aa := semaphores(NS_A) ||  rr := semaphores(NS_R)
       END;
    
     ll, aa, rr <-- status_semaphoreSN = 
        BEGIN
           ll := semaphores(SN_L) ||  aa := semaphores(SN_A) ||  rr := semaphores(SN_R)
       END;
    
     ll, aa, rr <-- status_semaphoreLO = 
        BEGIN
           ll := semaphores(LO_L) ||  aa := semaphores(LO_A) ||  rr := semaphores(LO_R)
       END;

     ll, aa, rr <-- status_semaphoreOL = 
        BEGIN
           ll := semaphores(OL_L) ||  aa := semaphores(OL_A) ||  rr := semaphores(OL_R)
       END

END

