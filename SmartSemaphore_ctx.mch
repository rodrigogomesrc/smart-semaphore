/* SmartSemaphore
 * Author: Rodrigo
 * Creation date: 06/07/2025
 */

MACHINE
    SmartSemaphore_ctx

SETS 
     SEMAPHORE = {
	NS_L, NS_A, NS_R,
	SN_L, SN_A, SN_R,
	LO_L, LO_A, LO_R,
        OL_L, OL_A, OL_R
     };
     COLOR = {GREEN,YELLOW,RED};
     DIRECTION = {NORTH, SOUTH, EAST, WEST};
     STATE = {NS, LO, DNS, DLO} // Norte-Sul, Leste-Oeste, Diagonal Norte-Sul, Diagonal Leste-Oeste
     
CONSTANTS

    min_time,
    max_time,
    max_cars,
    yellow_time
    
PROPERTIES

     min_time: 2..10  & 
     max_time: 0..10 & 
     max_cars: 0..10 &
     max_time > min_time &
     yellow_time: 0..5 

END
