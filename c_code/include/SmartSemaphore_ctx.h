#ifndef _SmartSemaphore_ctx_h
#define _SmartSemaphore_ctx_h

#include <stdint.h>
#include <stdbool.h>
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */
typedef enum
{
    SmartSemaphore_ctx__NS_L,
    SmartSemaphore_ctx__NS_A,
    SmartSemaphore_ctx__NS_R,
    SmartSemaphore_ctx__SN_L,
    SmartSemaphore_ctx__SN_A,
    SmartSemaphore_ctx__SN_R,
    SmartSemaphore_ctx__LO_L,
    SmartSemaphore_ctx__LO_A,
    SmartSemaphore_ctx__LO_R,
    SmartSemaphore_ctx__OL_L,
    SmartSemaphore_ctx__OL_A,
    SmartSemaphore_ctx__OL_R
    
} SmartSemaphore_ctx__SEMAPHORE;
#define SmartSemaphore_ctx__SEMAPHORE__max 12
typedef enum
{
    SmartSemaphore_ctx__GREEN,
    SmartSemaphore_ctx__YELLOW,
    SmartSemaphore_ctx__RED
    
} SmartSemaphore_ctx__COLOR;
#define SmartSemaphore_ctx__COLOR__max 3
typedef enum
{
    SmartSemaphore_ctx__NORTH,
    SmartSemaphore_ctx__SOUTH,
    SmartSemaphore_ctx__EAST,
    SmartSemaphore_ctx__WEST
    
} SmartSemaphore_ctx__DIRECTION;
#define SmartSemaphore_ctx__DIRECTION__max 4
typedef enum
{
    SmartSemaphore_ctx__NS,
    SmartSemaphore_ctx__LO,
    SmartSemaphore_ctx__DNS,
    SmartSemaphore_ctx__DLO
    
} SmartSemaphore_ctx__STATE;
#define SmartSemaphore_ctx__STATE__max 4
typedef enum
{
    SmartSemaphore_ctx__TRANSITIONING,
    SmartSemaphore_ctx__ACTIVE,
    SmartSemaphore_ctx__EXITING
    
} SmartSemaphore_ctx__PRIORITY_PHASE;
#define SmartSemaphore_ctx__PRIORITY_PHASE__max 3

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
#define SmartSemaphore_ctx__min_time 20
#define SmartSemaphore_ctx__max_time 60
#define SmartSemaphore_ctx__max_cars 50
#define SmartSemaphore_ctx__yellow_time 10
/* Array and record constants */





/* Clause CONCRETE_VARIABLES */

extern void SmartSemaphore_ctx__INITIALISATION(void);


#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _SmartSemaphore_ctx_h */
