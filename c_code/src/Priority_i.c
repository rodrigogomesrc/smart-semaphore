/* WARNING if type checker is not performed, translation could contain errors ! */

#include "Priority.h"

/* Clause SEES */
#include "SmartSemaphore_ctx.h"

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */

#define Priority__SIZE 4
#define Priority__BOUND 3
/* Array and record constants */
/* Clause CONCRETE_VARIABLES */

static int32_t Priority__cursor;
static SmartSemaphore_ctx__STATE Priority__order_i[4];
/* Clause INITIALISATION */
void Priority__INITIALISATION(void)
{
    
    {
        Priority__cursor = 0;
        Priority__order_i[0] = SmartSemaphore_ctx__NS;
        Priority__order_i[1] = SmartSemaphore_ctx__LO;
        Priority__order_i[2] = SmartSemaphore_ctx__DNS;
        Priority__order_i[3] = SmartSemaphore_ctx__DLO;
    }
}

/* Clause OPERATIONS */

void Priority__current(SmartSemaphore_ctx__STATE *ss)
{
    (*ss) = Priority__order_i[Priority__cursor];
}

void Priority__next(SmartSemaphore_ctx__STATE *ss)
{
    (*ss) = Priority__order_i[(Priority__cursor+1) % Priority__SIZE];
}

void Priority__advance(SmartSemaphore_ctx__STATE *ss)
{
    (*ss) = Priority__order_i[Priority__cursor];
    Priority__cursor = (Priority__cursor+1) % Priority__SIZE;
}

