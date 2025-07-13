/* WARNING if type checker is not performed, translation could contain errors ! */

#include "Priority.h"

/* Clause SEES */
#include "SmartSemaphore_ctx.h"

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */

#define Priority__SIZE 5
#define Priority__BOUND 4
/* Array and record constants */
/* Clause CONCRETE_VARIABLES */

static int32_t Priority__cursor;
static int32_t Priority__current_size;
static SmartSemaphore_ctx__STATE Priority__order_i[Priority__BOUND+1];
/* Clause INITIALISATION */
void Priority__INITIALISATION(void)
{
    
    unsigned int i = 0;
    {
        Priority__cursor = 0;
        Priority__current_size = 0;
        for(i = 0; i <= Priority__BOUND;i++)
        {
            Priority__order_i[i] = SmartSemaphore_ctx__NS;
        }
    }
}

/* Clause OPERATIONS */

void Priority__insert(SmartSemaphore_ctx__STATE ss)
{
    Priority__current_size = Priority__current_size+1;
    Priority__order_i[Priority__current_size] = ss;
}

void Priority__current(SmartSemaphore_ctx__STATE *ss)
{
    (*ss) = Priority__order_i[Priority__cursor];
}

void Priority__next(SmartSemaphore_ctx__STATE *ss)
{
    (*ss) = Priority__order_i[Priority__cursor+1];
}

void Priority__advance(SmartSemaphore_ctx__STATE *ss)
{
    (*ss) = Priority__order_i[Priority__cursor];
    {
        int32_t ii;
        
        ii = Priority__current_size-1;
        if(Priority__cursor == ii)
        {
            Priority__cursor = 0;
        }
        else
        {
            Priority__cursor = Priority__cursor+1;
        }
    }
}

