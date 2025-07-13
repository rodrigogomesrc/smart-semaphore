#ifndef _Priority_h
#define _Priority_h

#include <stdint.h>
#include <stdbool.h>
/* Clause SEES */
#include "SmartSemaphore_ctx.h"

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
#define Priority__SIZE 4
#define Priority__BOUND 3
/* Array and record constants */



/* Clause CONCRETE_VARIABLES */

extern void Priority__INITIALISATION(void);

/* Clause OPERATIONS */

extern void Priority__current(SmartSemaphore_ctx__STATE *ss);
extern void Priority__next(SmartSemaphore_ctx__STATE *ss);
extern void Priority__advance(SmartSemaphore_ctx__STATE *ss);

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _Priority_h */
