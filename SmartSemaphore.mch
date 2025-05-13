/* SmartSemaphore
 * Author: Marlus e Rodrigo
 * Creation date: 12/05/2025
 */
MACHINE
    SmartSemaphore

SETS 
	SEMAPHORE = {LEFT,RIGHT,AHEAD};
	COLORS = {GREEN,YELLOW,RED};
	DIRECTIONS = {NORTH, SOUTH, EAST, WEST}


VARIABLES
    semaphoreNS, semaphoreOL, semaphoreLO, semaphoreSN, cars

INVARIANT
    	semaphoreNS : SEMAPHORE --> COLORS &
	semaphoreSN : SEMAPHORE --> COLORS &
	semaphoreLO : SEMAPHORE --> COLORS &
	semaphoreOL : SEMAPHORE --> COLORS &
	cars : DIRECTIONS >->> NAT  

INITIALISATION
    	semaphoreNS := {LEFT|->RED, RIGHT|->RED,AHEAD|->RED} ||
	semaphoreSN := {LEFT|->RED, RIGHT|->RED,AHEAD|->RED} ||   
	semaphoreLO := {LEFT|->RED, RIGHT|->RED,AHEAD|->RED} ||  
	semaphoreOL := {LEFT|->RED, RIGHT|->RED,AHEAD|->RED} ||
	cars := DIRECTIONS * {0}  
OPERATIONS 
/*
alter_semaphoreNS_AH_to_green = 
PRE semaphoreNS[{AHEAD}] = {RED}
THEN semaphoreNS := semaphoreNS <+ ({AHEAD |-> GREEN}) 
END;
*/

/*
addCars(nn,dd) = 
PRE nn : NAT & dd : DIRECTION
THEN cars := cars <+ {cars[dd] + nn}
END; 
*/

sl, sr,sa <-- status_semaphoreNS = 
	sl, sr, sa := semaphoreNS[{LEFT}], semaphoreNS[{RIGHT}], semaphoreNS[{AHEAD}] 
       

END
