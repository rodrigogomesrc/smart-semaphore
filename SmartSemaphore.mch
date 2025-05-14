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

                 // Tipagens
    	semaphoreNS : SEMAPHORE --> COLORS &
	semaphoreSN : SEMAPHORE --> COLORS &
	semaphoreLO : SEMAPHORE --> COLORS &
	semaphoreOL : SEMAPHORE --> COLORS &
	cars : DIRECTIONS --> NAT   &

                 // Requisitos de segurança
                 semaphoreNS[{AHEAD}] = {GREEN} <=> semaphoreLO[{AHEAD}] = {RED} &
                 semaphoreSN[{AHEAD}] = {GREEN} <=> semaphoreOL[{AHEAD}] = {RED} &

                 (semaphoreNS[{LEFT}] = semaphoreNS[{RIGHT}]) <=> (semaphoreSN[{LEFT}] = semaphoreSN[{RIGHT}] )  &
                 (semaphoreLO[{LEFT}] = semaphoreLO[{RIGHT}]) <=> (semaphoreOL[{LEFT}] = semaphoreOL[{RIGHT}] )
      



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


sl, sr,sa <-- status_semaphoreNS = 
	sl, sr, sa := semaphoreNS[{LEFT}], semaphoreNS[{RIGHT}], semaphoreNS[{AHEAD}] 
       

END
