/* WARNING if type checker is not performed, translation could contain errors ! */
#include <stdio.h>
#include "SmartSemaphore.h"

/* Clause SEES */
#include "SmartSemaphore_ctx.h"

/* Clause IMPORTS */
#include "Priority.h"

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */

/* Array and record constants */

const SmartSemaphore_ctx__DIRECTION SmartSemaphore__direction_enum[4] = {SmartSemaphore_ctx__NORTH,SmartSemaphore_ctx__SOUTH,SmartSemaphore_ctx__EAST,SmartSemaphore_ctx__WEST};

const SmartSemaphore_ctx__STATE SmartSemaphore__time_enum[4] = {SmartSemaphore_ctx__NS,SmartSemaphore_ctx__LO,SmartSemaphore_ctx__DNS,SmartSemaphore_ctx__DLO};

const SmartSemaphore_ctx__COLOR SmartSemaphore__color_enum[3] = {SmartSemaphore_ctx__GREEN,SmartSemaphore_ctx__YELLOW,SmartSemaphore_ctx__RED};

const SmartSemaphore_ctx__SEMAPHORE SmartSemaphore__semaphore_enum[12] = {SmartSemaphore_ctx__NS_L,SmartSemaphore_ctx__NS_A,SmartSemaphore_ctx__NS_R,SmartSemaphore_ctx__SN_L,SmartSemaphore_ctx__SN_A,SmartSemaphore_ctx__SN_R,SmartSemaphore_ctx__LO_L,SmartSemaphore_ctx__LO_A,SmartSemaphore_ctx__LO_R,SmartSemaphore_ctx__OL_L,SmartSemaphore_ctx__OL_A,SmartSemaphore_ctx__OL_R};
/* Clause CONCRETE_VARIABLES */

static int32_t SmartSemaphore__cars_i[4];
static int32_t SmartSemaphore__time_i[4];
static int32_t SmartSemaphore__semaphores_i[12];
static bool SmartSemaphore__has_priority;
static SmartSemaphore_ctx__STATE SmartSemaphore__priority;
static int32_t SmartSemaphore__timer;
static int32_t SmartSemaphore__yellow_timer;
static SmartSemaphore_ctx__PRIORITY_PHASE SmartSemaphore__priority_phase;
/* Clause INITIALISATION */
void SmartSemaphore__INITIALISATION(void)
{
    
    unsigned int i = 0;
    Priority__INITIALISATION();
    {
        for(i = 0; i <= 3;i++)
        {
            SmartSemaphore__cars_i[i] = 0;
        }
        for(i = 0; i <= 3;i++)
        {
            SmartSemaphore__time_i[i] = SmartSemaphore_ctx__max_time;
        }
        for(i = 0; i <= 11;i++)
        {
            SmartSemaphore__semaphores_i[i] = 2;
        }
        SmartSemaphore__semaphores_i[7] = 0;
        SmartSemaphore__semaphores_i[10] = 0;
        SmartSemaphore__has_priority = false;
        SmartSemaphore__priority = SmartSemaphore_ctx__NS;
        SmartSemaphore__timer = SmartSemaphore_ctx__max_time;
        SmartSemaphore__yellow_timer = SmartSemaphore_ctx__yellow_time;
        SmartSemaphore__priority_phase = SmartSemaphore_ctx__TRANSITIONING;
    }
}

/* Clause OPERATIONS */

void SmartSemaphore__prioritize(SmartSemaphore_ctx__STATE ss)
{
    SmartSemaphore__has_priority = true;
    SmartSemaphore__priority = ss;
    SmartSemaphore__timer = SmartSemaphore_ctx__max_time;
    SmartSemaphore__yellow_timer = SmartSemaphore_ctx__yellow_time;
}

void SmartSemaphore__pre_op_prioritize(SmartSemaphore_ctx__STATE ss, bool *status)
{
    {
        SmartSemaphore_ctx__STATE cc;
        
        Priority__current(&cc);
        (*status) = (((SmartSemaphore__has_priority == false) &&((cc) != (ss))) ? true : false);
    }
}

void SmartSemaphore__calculate_times(void)
{
    {
        int32_t sumNS;
        int32_t sumLO;
        int32_t max_denominator;
        int32_t timeNS;
        int32_t timeLO;
        int32_t timeDNS;
        int32_t timeDLO;
        
        sumNS = SmartSemaphore__cars_i[0]+SmartSemaphore__cars_i[1];
        sumLO = SmartSemaphore__cars_i[2]+SmartSemaphore__cars_i[3];
        if((sumNS) > (sumLO))
        {
            max_denominator = sumNS;
        }
        else
        {
            max_denominator = sumLO;
        }
        if((max_denominator) != (0))
        {
            {
                int32_t tempTimeNS_DNS;
                
                tempTimeNS_DNS = (sumNS * SmartSemaphore_ctx__max_time) / max_denominator;
                if((tempTimeNS_DNS) > (SmartSemaphore_ctx__min_time))
                {
                    timeNS = tempTimeNS_DNS;
                    timeDNS = tempTimeNS_DNS;
                }
                else
                {
                    timeNS = SmartSemaphore_ctx__min_time;
                    timeDNS = SmartSemaphore_ctx__min_time;
                }
            }
            {
                int32_t tempTimeLO_DLO;
                
                tempTimeLO_DLO = (sumLO * SmartSemaphore_ctx__max_time) / max_denominator;
                if((tempTimeLO_DLO) > (SmartSemaphore_ctx__min_time))
                {
                    timeLO = tempTimeLO_DLO;
                    timeDLO = tempTimeLO_DLO;
                }
                else
                {
                    timeLO = SmartSemaphore_ctx__min_time;
                    timeDLO = SmartSemaphore_ctx__min_time;
                }
            }
        }
        else
        {
            timeNS = SmartSemaphore_ctx__min_time;
            timeDNS = SmartSemaphore_ctx__min_time;
            timeLO = SmartSemaphore_ctx__min_time;
            timeDLO = SmartSemaphore_ctx__min_time;
        }
        SmartSemaphore__time_i[0] = timeNS;
        SmartSemaphore__time_i[1] = timeLO;
        SmartSemaphore__time_i[2] = timeDNS;
        SmartSemaphore__time_i[3] = timeDLO;
        SmartSemaphore__cars_i[0] = 0;
        SmartSemaphore__cars_i[1] = 0;
        SmartSemaphore__cars_i[2] = 0;
        SmartSemaphore__cars_i[3] = 0;
    }
}

void SmartSemaphore__pre_calculate_times(bool *status)
{
    (*status) = true;
}

void SmartSemaphore__addCars(int32_t nn, SmartSemaphore_ctx__DIRECTION dd)
{
    if(dd == SmartSemaphore_ctx__NORTH)
    {
        SmartSemaphore__cars_i[0] = SmartSemaphore__cars_i[0]+nn;
    }
    else if(dd == SmartSemaphore_ctx__SOUTH)
    {
        SmartSemaphore__cars_i[1] = SmartSemaphore__cars_i[1]+nn;
    }
    else if(dd == SmartSemaphore_ctx__EAST)
    {
        SmartSemaphore__cars_i[2] = SmartSemaphore__cars_i[2]+nn;
    }
    else
    {
        SmartSemaphore__cars_i[3] = SmartSemaphore__cars_i[3]+nn;
    }
}

void SmartSemaphore__pre_op_addCars(int32_t nn, SmartSemaphore_ctx__DIRECTION dd, bool *status)
{
    {
        int32_t ii;
        int32_t jj;
        
        if(dd == SmartSemaphore_ctx__NORTH)
        {
            ii = SmartSemaphore__cars_i[0];
        }
        else if(dd == SmartSemaphore_ctx__SOUTH)
        {
            ii = SmartSemaphore__cars_i[1];
        }
        else if(dd == SmartSemaphore_ctx__EAST)
        {
            ii = SmartSemaphore__cars_i[2];
        }
        else
        {
            ii = SmartSemaphore__cars_i[3];
        }
        jj = ii+nn;
        (*status) = (((jj) < (SmartSemaphore_ctx__max_cars)) ? true : false);
    }
}

void SmartSemaphore__process_semaphore(int32_t *st, int32_t *yt)
{
    unsigned int i = 0;
    {
        if((SmartSemaphore__timer) > (0))
        {
            SmartSemaphore__timer = SmartSemaphore__timer-1;
            (*st) = SmartSemaphore__timer;
            (*yt) = SmartSemaphore__yellow_timer;
        }
        else if(((SmartSemaphore__timer == 0) &&
            ((SmartSemaphore__yellow_timer) > (0))))
        {
            {
                SmartSemaphore_ctx__STATE current_state;
                
                Priority__current(&current_state);
                if(current_state == SmartSemaphore_ctx__LO)
                {
                    for(i = 0; i <= 11;i++)
                    {
                        SmartSemaphore__semaphores_i[i] = 2;
                    }
                    SmartSemaphore__semaphores_i[7] = 1;
                    SmartSemaphore__semaphores_i[10] = 1;
                }
                else if(current_state == SmartSemaphore_ctx__DNS)
                {
                    for(i = 0; i <= 11;i++)
                    {
                        SmartSemaphore__semaphores_i[i] = 2;
                    }
                    SmartSemaphore__semaphores_i[3] = 1;
                    SmartSemaphore__semaphores_i[5] = 1;
                    SmartSemaphore__semaphores_i[0] = 1;
                    SmartSemaphore__semaphores_i[2] = 1;
                    SmartSemaphore__semaphores_i[11] = 1;
                    SmartSemaphore__semaphores_i[8] = 1;
                }
                else if(current_state == SmartSemaphore_ctx__DLO)
                {
                    for(i = 0; i <= 11;i++)
                    {
                        SmartSemaphore__semaphores_i[i] = 2;
                    }
                    SmartSemaphore__semaphores_i[5] = 1;
                    SmartSemaphore__semaphores_i[2] = 1;
                    SmartSemaphore__semaphores_i[11] = 1;
                    SmartSemaphore__semaphores_i[9] = 1;
                    SmartSemaphore__semaphores_i[8] = 1;
                    SmartSemaphore__semaphores_i[6] = 1;
                }
                else
                {
                    for(i = 0; i <= 11;i++)
                    {
                        SmartSemaphore__semaphores_i[i] = 2;
                    }
                    SmartSemaphore__semaphores_i[7] = 1;
                    SmartSemaphore__semaphores_i[10] = 1;
                }
                SmartSemaphore__yellow_timer = SmartSemaphore__yellow_timer-1;
                (*st) = SmartSemaphore__timer;
                (*yt) = SmartSemaphore__yellow_timer;
            }
        }
        else
        {
            {
                SmartSemaphore_ctx__STATE next_state;
                SmartSemaphore_ctx__STATE ss;
                
                Priority__advance(&ss);
                Priority__current(&next_state);
                if(next_state == SmartSemaphore_ctx__NS)
                {
                    SmartSemaphore__timer = SmartSemaphore__time_i[0];
                }
                else if(next_state == SmartSemaphore_ctx__LO)
                {
                    SmartSemaphore__timer = SmartSemaphore__time_i[1];
                }
                else if(next_state == SmartSemaphore_ctx__DNS)
                {
                    SmartSemaphore__timer = SmartSemaphore__time_i[2];
                }
                else
                {
                    SmartSemaphore__timer = SmartSemaphore__time_i[3];
                }
                if(next_state == SmartSemaphore_ctx__LO)
                {
                    for(i = 0; i <= 11;i++)
                    {
                        SmartSemaphore__semaphores_i[i] = 2;
                    }
                    SmartSemaphore__semaphores_i[7] = 0;
                    SmartSemaphore__semaphores_i[10] = 0;
                }
                else if(next_state == SmartSemaphore_ctx__DNS)
                {
                    for(i = 0; i <= 11;i++)
                    {
                        SmartSemaphore__semaphores_i[i] = 2;
                    }
                    SmartSemaphore__semaphores_i[3] = 0;
                    SmartSemaphore__semaphores_i[5] = 0;
                    SmartSemaphore__semaphores_i[0] = 0;
                    SmartSemaphore__semaphores_i[2] = 0;
                    SmartSemaphore__semaphores_i[11] = 0;
                    SmartSemaphore__semaphores_i[8] = 0;
                }
                else if(next_state == SmartSemaphore_ctx__DLO)
                {
                    for(i = 0; i <= 11;i++)
                    {
                        SmartSemaphore__semaphores_i[i] = 2;
                    }
                    SmartSemaphore__semaphores_i[5] = 0;
                    SmartSemaphore__semaphores_i[2] = 0;
                    SmartSemaphore__semaphores_i[11] = 0;
                    SmartSemaphore__semaphores_i[9] = 0;
                    SmartSemaphore__semaphores_i[8] = 0;
                    SmartSemaphore__semaphores_i[6] = 0;
                }
                else
                {
                    for(i = 0; i <= 11;i++)
                    {
                        SmartSemaphore__semaphores_i[i] = 2;
                    }
                    SmartSemaphore__semaphores_i[1] = 0;
                    SmartSemaphore__semaphores_i[4] = 0;
                }
                SmartSemaphore__yellow_timer = SmartSemaphore_ctx__yellow_time;
                (*yt) = SmartSemaphore__yellow_timer;
                (*st) = SmartSemaphore__timer;
            }
        }
    }
}

void SmartSemaphore__pre_op_process_semaphore(bool *status)
{
    (*status) = ((SmartSemaphore__has_priority == false) ? true : false);
}

void SmartSemaphore__process_semaphore_priority(int32_t *st, int32_t *yt)
{
    unsigned int i = 0;
    {
        if(SmartSemaphore__priority_phase == SmartSemaphore_ctx__TRANSITIONING)
        {
            if((SmartSemaphore__yellow_timer) > (0))
            {
                SmartSemaphore__yellow_timer = SmartSemaphore__yellow_timer-1;
                (*st) = SmartSemaphore__timer;
                (*yt) = SmartSemaphore__yellow_timer;
                for(i = 0; i <= 11;i++)
                {
                    SmartSemaphore__semaphores_i[i] = 2;
                }
                SmartSemaphore_ctx__STATE current_order_state;
 
                Priority__current(&current_order_state);

                if(current_order_state == SmartSemaphore_ctx__LO)
                {
                    SmartSemaphore__semaphores_i[7] = 1;
                    SmartSemaphore__semaphores_i[10] = 1;
                }
                else if(current_order_state == SmartSemaphore_ctx__DNS)
                {
                    SmartSemaphore__semaphores_i[3] = 1;
                    SmartSemaphore__semaphores_i[5] = 1;
                    SmartSemaphore__semaphores_i[0] = 1;
                    SmartSemaphore__semaphores_i[2] = 1;
                    SmartSemaphore__semaphores_i[11] = 1;
                    SmartSemaphore__semaphores_i[8] = 1;
                }
                else if(current_order_state == SmartSemaphore_ctx__DLO)
                {
                    SmartSemaphore__semaphores_i[5] = 1;
                    SmartSemaphore__semaphores_i[2] = 1;
                    SmartSemaphore__semaphores_i[11] = 1;
                    SmartSemaphore__semaphores_i[9] = 1;
                    SmartSemaphore__semaphores_i[8] = 1;
                    SmartSemaphore__semaphores_i[6] = 1;
                }
                else
                {
                    SmartSemaphore__semaphores_i[7] = 1;
                    SmartSemaphore__semaphores_i[10] = 1;
                }
            }
            else
            {
                SmartSemaphore__priority_phase = SmartSemaphore_ctx__ACTIVE;
                SmartSemaphore__yellow_timer = SmartSemaphore_ctx__yellow_time;
                (*st) = SmartSemaphore__timer;
                (*yt) = SmartSemaphore__yellow_timer;
            }
        }
        else if(SmartSemaphore__priority_phase == SmartSemaphore_ctx__ACTIVE)
        {
            if((SmartSemaphore__timer) > (0))
            {
                SmartSemaphore__timer = SmartSemaphore__timer-1;
                (*st) = SmartSemaphore__timer-1;
                (*yt) = 0;
                for(i = 0; i <= 11;i++)
                {
                    SmartSemaphore__semaphores_i[i] = 2;
                }

                if(SmartSemaphore__priority == SmartSemaphore_ctx__LO)
                {
                    SmartSemaphore__semaphores_i[7] = 0;
                    SmartSemaphore__semaphores_i[10] = 0;
                }
                else if(SmartSemaphore__priority == SmartSemaphore_ctx__DNS)
                {
                    SmartSemaphore__semaphores_i[3] = 0;
                    SmartSemaphore__semaphores_i[5] = 0;
                    SmartSemaphore__semaphores_i[0] = 0;
                    SmartSemaphore__semaphores_i[2] = 0;
                    SmartSemaphore__semaphores_i[11] = 0;
                    SmartSemaphore__semaphores_i[8] = 0;
                }
                else if(SmartSemaphore__priority == SmartSemaphore_ctx__DLO)
                {
                    SmartSemaphore__semaphores_i[5] = 0;
                    SmartSemaphore__semaphores_i[2] = 0;
                    SmartSemaphore__semaphores_i[11] = 0;
                    SmartSemaphore__semaphores_i[9] = 0;
                    SmartSemaphore__semaphores_i[8] = 0;
                    SmartSemaphore__semaphores_i[6] = 0;
                }
                else
                {
                    SmartSemaphore__semaphores_i[1] = 0;
                    SmartSemaphore__semaphores_i[4] = 0;
                }
            }
            else
            {
                SmartSemaphore__priority_phase = SmartSemaphore_ctx__EXITING;
                SmartSemaphore__timer = 0;
                (*st) = 0;
                (*yt) = 0;
            }
        }
        else if(SmartSemaphore__priority_phase == SmartSemaphore_ctx__EXITING)
        {
            if((SmartSemaphore__yellow_timer) > (0))
            {
                SmartSemaphore__yellow_timer = SmartSemaphore__yellow_timer-1;
                (*st) = 0;
                (*yt) = SmartSemaphore__yellow_timer-1;
                for(i = 0; i <= 11;i++)
                {
                    SmartSemaphore__semaphores_i[i] = 2;
                }
                if(SmartSemaphore__priority == SmartSemaphore_ctx__LO)
                {
                    SmartSemaphore__semaphores_i[7] = 1;
                    SmartSemaphore__semaphores_i[10] = 1;
                }
                else if(SmartSemaphore__priority == SmartSemaphore_ctx__DNS)
                {
                    SmartSemaphore__semaphores_i[3] = 1;
                    SmartSemaphore__semaphores_i[5] = 1;
                    SmartSemaphore__semaphores_i[0] = 1;
                    SmartSemaphore__semaphores_i[2] = 1;
                    SmartSemaphore__semaphores_i[11] = 1;
                    SmartSemaphore__semaphores_i[8] = 1;
                }
                else if(SmartSemaphore__priority == SmartSemaphore_ctx__DLO)
                {
                    SmartSemaphore__semaphores_i[5] = 1;
                    SmartSemaphore__semaphores_i[2] = 1;
                    SmartSemaphore__semaphores_i[11] = 1;
                    SmartSemaphore__semaphores_i[9] = 1;
                    SmartSemaphore__semaphores_i[8] = 1;
                    SmartSemaphore__semaphores_i[6] = 1;
                }
                else
                {
                    SmartSemaphore__semaphores_i[7] = 1;
                    SmartSemaphore__semaphores_i[10] = 1;
                }
            }
            else
            {
                SmartSemaphore__has_priority = false;
                {
                    SmartSemaphore_ctx__STATE current_state;
                    Priority__current(&current_state);

                    if(current_state == SmartSemaphore_ctx__NS)
                    {
                        SmartSemaphore__timer = SmartSemaphore__time_i[0];
                    }
                    else if(current_state == SmartSemaphore_ctx__LO)
                    {
                        SmartSemaphore__timer = SmartSemaphore__time_i[1];
                    }
                    else if(current_state == SmartSemaphore_ctx__DNS)
                    {
                        SmartSemaphore__timer = SmartSemaphore__time_i[2];
                    }
                    else
                    {
                        SmartSemaphore__timer = SmartSemaphore__time_i[3];
                    }
                }
                SmartSemaphore__yellow_timer = SmartSemaphore_ctx__yellow_time;
                {
                    SmartSemaphore_ctx__STATE current_state;
                    
                    Priority__current(&current_state);

                    for(i = 0; i <= 11;i++)
                    {
                        SmartSemaphore__semaphores_i[i] = 2;
                    }
                    if(current_state == SmartSemaphore_ctx__LO)
                    {
                        SmartSemaphore__semaphores_i[7] = 0;
                        SmartSemaphore__semaphores_i[10] = 0;
                    }
                    else if(current_state == SmartSemaphore_ctx__DNS)
                    {
                        SmartSemaphore__semaphores_i[3] = 0;
                        SmartSemaphore__semaphores_i[5] = 0;
                        SmartSemaphore__semaphores_i[0] = 0;
                        SmartSemaphore__semaphores_i[2] = 0;
                        SmartSemaphore__semaphores_i[11] = 0;
                        SmartSemaphore__semaphores_i[8] = 0;
                    }
                    else if(current_state == SmartSemaphore_ctx__DLO)
                    {
                        SmartSemaphore__semaphores_i[5] = 0;
                        SmartSemaphore__semaphores_i[2] = 0;
                        SmartSemaphore__semaphores_i[11] = 0;
                        SmartSemaphore__semaphores_i[9] = 0;
                        SmartSemaphore__semaphores_i[8] = 0;
                        SmartSemaphore__semaphores_i[6] = 0;
                    }
                    else
                    {
                        SmartSemaphore__semaphores_i[1] = 0;
                        SmartSemaphore__semaphores_i[4] = 0;
                    }
                }
                (*st) = SmartSemaphore__timer;
                (*yt) = SmartSemaphore__yellow_timer;
            }
        }
    }
}

void SmartSemaphore__pre_op_process_semaphore_priority(bool *status)
{
    (*status) = SmartSemaphore__has_priority;
}

void SmartSemaphore__status_semaphoreNS(SmartSemaphore_ctx__COLOR *ll, SmartSemaphore_ctx__COLOR *aa, SmartSemaphore_ctx__COLOR *rr)
{
    {
        int32_t ll_c;
        int32_t aa_c;
        int32_t rr_c;
        
        ll_c = SmartSemaphore__semaphores_i[0];
        aa_c = SmartSemaphore__semaphores_i[1];
        rr_c = SmartSemaphore__semaphores_i[2];
        (*ll) = SmartSemaphore__color_enum[ll_c];
        (*aa) = SmartSemaphore__color_enum[aa_c];
        (*rr) = SmartSemaphore__color_enum[rr_c];
    }
}

void SmartSemaphore__status_semaphoreSN(SmartSemaphore_ctx__COLOR *ll, SmartSemaphore_ctx__COLOR *aa, SmartSemaphore_ctx__COLOR *rr)
{
    {
        int32_t ll_c;
        int32_t aa_c;
        int32_t rr_c;
        
        ll_c = SmartSemaphore__semaphores_i[3];
        aa_c = SmartSemaphore__semaphores_i[4];
        rr_c = SmartSemaphore__semaphores_i[5];
        (*ll) = SmartSemaphore__color_enum[ll_c];
        (*aa) = SmartSemaphore__color_enum[aa_c];
        (*rr) = SmartSemaphore__color_enum[rr_c];
    }
}

void SmartSemaphore__status_semaphoreLO(SmartSemaphore_ctx__COLOR *ll, SmartSemaphore_ctx__COLOR *aa, SmartSemaphore_ctx__COLOR *rr)
{
    {
        int32_t ll_c;
        int32_t aa_c;
        int32_t rr_c;
        
        ll_c = SmartSemaphore__semaphores_i[6];
        aa_c = SmartSemaphore__semaphores_i[7];
        rr_c = SmartSemaphore__semaphores_i[8];
        (*ll) = SmartSemaphore__color_enum[ll_c];
        (*aa) = SmartSemaphore__color_enum[aa_c];
        (*rr) = SmartSemaphore__color_enum[rr_c];
    }
}

void SmartSemaphore__status_semaphoreOL(SmartSemaphore_ctx__COLOR *ll, SmartSemaphore_ctx__COLOR *aa, SmartSemaphore_ctx__COLOR *rr)
{
    {
        int32_t ll_c;
        int32_t aa_c;
        int32_t rr_c;
        
        ll_c = SmartSemaphore__semaphores_i[9];
        aa_c = SmartSemaphore__semaphores_i[10];
        rr_c = SmartSemaphore__semaphores_i[11];
        (*ll) = SmartSemaphore__color_enum[ll_c];
        (*aa) = SmartSemaphore__color_enum[aa_c];
        (*rr) = SmartSemaphore__color_enum[rr_c];
    }
}

