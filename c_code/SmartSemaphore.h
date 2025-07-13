#ifndef _SmartSemaphore_h
#define _SmartSemaphore_h

#include <stdint.h>
#include <stdbool.h>
/* Clause SEES */
#include "SmartSemaphore_ctx.h"

/* Clause IMPORTS */
#include "Priority.h"

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
/* Array and record constants */

/* Clause CONCRETE_VARIABLES */

extern void SmartSemaphore__INITIALISATION(void);

/* Clause OPERATIONS */

extern void SmartSemaphore__prioritize(SmartSemaphore_ctx__STATE ss);
extern void SmartSemaphore__pre_op_prioritize(SmartSemaphore_ctx__STATE ss, bool *status);
extern void SmartSemaphore__calculate_times(void);
extern void SmartSemaphore__pre_calculate_times(bool *status);
extern void SmartSemaphore__addCars(int32_t nn, SmartSemaphore_ctx__DIRECTION dd);
extern void SmartSemaphore__pre_op_addCars(int32_t nn, SmartSemaphore_ctx__DIRECTION dd, bool *status);
extern void SmartSemaphore__process_semaphore(int32_t *st, int32_t *yt);
extern void SmartSemaphore__pre_op_process_semaphore(bool *status);
extern void SmartSemaphore__process_semaphore_priority(int32_t *st, int32_t *yt);
extern void SmartSemaphore__pre_op_process_semaphore_priority(bool *status);
extern void SmartSemaphore__status_semaphoreNS(SmartSemaphore_ctx__COLOR *ll, SmartSemaphore_ctx__COLOR *aa, SmartSemaphore_ctx__COLOR *rr);
extern void SmartSemaphore__status_semaphoreSN(SmartSemaphore_ctx__COLOR *ll, SmartSemaphore_ctx__COLOR *aa, SmartSemaphore_ctx__COLOR *rr);
extern void SmartSemaphore__status_semaphoreLO(SmartSemaphore_ctx__COLOR *ll, SmartSemaphore_ctx__COLOR *aa, SmartSemaphore_ctx__COLOR *rr);
extern void SmartSemaphore__status_semaphoreOL(SmartSemaphore_ctx__COLOR *ll, SmartSemaphore_ctx__COLOR *aa, SmartSemaphore_ctx__COLOR *rr);

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _SmartSemaphore_h */
