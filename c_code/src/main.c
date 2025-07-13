#include <stdio.h>
#include <stdlib.h> 
#include <stdbool.h>
#include <string.h>

#include "SmartSemaphore_ctx.h"
#include "SmartSemaphore.h"


const char* color_to_string(SmartSemaphore_ctx__COLOR c)
{
    switch (c)
    {
        case SmartSemaphore_ctx__GREEN:  return "GREEN";
        case SmartSemaphore_ctx__YELLOW: return "YELLOW";
        case SmartSemaphore_ctx__RED:    return "RED";
        default:                         return "???";
    }
}


void clear_screen()
{
#ifdef _WIN32
    system("cls");
#else
    system("clear");
#endif
}

int main()
{
    SmartSemaphore_ctx__INITIALISATION();
    Priority__INITIALISATION();
    SmartSemaphore__INITIALISATION();
    
    int32_t st = 0;
    int32_t yt = 0;
    char command_buffer[100];
    bool running = true;

    while (running)
    {

        bool can_run_priority;
        SmartSemaphore__pre_op_process_semaphore_priority(&can_run_priority);
        if (can_run_priority)
        {
            SmartSemaphore__process_semaphore_priority(&st, &yt);
        }
        else
        {
            SmartSemaphore__process_semaphore(&st, &yt);
        }
        
        clear_screen();

        SmartSemaphore_ctx__COLOR ns_l, ns_a, ns_r, sn_l, sn_a, sn_r, lo_l, lo_a, lo_r, ol_l, ol_a, ol_r;
        SmartSemaphore__status_semaphoreNS(&ns_l, &ns_a, &ns_r);
        SmartSemaphore__status_semaphoreSN(&sn_l, &sn_a, &sn_r);
        SmartSemaphore__status_semaphoreLO(&lo_l, &lo_a, &lo_r);
        SmartSemaphore__status_semaphoreOL(&ol_l, &ol_a, &ol_r);

        bool is_priority_mode_active = true;
        {
            bool can_prio_test;
            SmartSemaphore__pre_op_prioritize(SmartSemaphore_ctx__NS, &can_prio_test);
            if (can_prio_test)
            {
                is_priority_mode_active = false;
            }
            else
            {
                SmartSemaphore__pre_op_prioritize(SmartSemaphore_ctx__LO, &can_prio_test);
                if (can_prio_test)
                {
                    is_priority_mode_active = false;
                }
            }
        }
        
        const char* estado_string;
        if ((ns_a == SmartSemaphore_ctx__GREEN || ns_a == SmartSemaphore_ctx__YELLOW) ||
            (sn_a == SmartSemaphore_ctx__GREEN || sn_a == SmartSemaphore_ctx__YELLOW))
        {
            estado_string = "Norte-Sul (NS)";
        }
        else if ((lo_a == SmartSemaphore_ctx__GREEN || lo_a == SmartSemaphore_ctx__YELLOW) ||
                 (ol_a == SmartSemaphore_ctx__GREEN || ol_a == SmartSemaphore_ctx__YELLOW))
        {
            estado_string = "Leste-Oeste (LO)";
        }
        else if ((ns_l == SmartSemaphore_ctx__GREEN || ns_l == SmartSemaphore_ctx__YELLOW) &&
                 (ns_r == SmartSemaphore_ctx__GREEN || ns_r == SmartSemaphore_ctx__YELLOW) &&
                 (sn_l == SmartSemaphore_ctx__GREEN || sn_l == SmartSemaphore_ctx__YELLOW) &&
                 (sn_r == SmartSemaphore_ctx__GREEN || sn_r == SmartSemaphore_ctx__YELLOW))
        {
            estado_string = "Diagonal N-S (DNS)";
        }
        else if ((lo_l == SmartSemaphore_ctx__GREEN || lo_l == SmartSemaphore_ctx__YELLOW) &&
                 (lo_r == SmartSemaphore_ctx__GREEN || lo_r == SmartSemaphore_ctx__YELLOW) &&
                 (ol_l == SmartSemaphore_ctx__GREEN || ol_l == SmartSemaphore_ctx__YELLOW) &&
                 (ol_r == SmartSemaphore_ctx__GREEN || ol_r == SmartSemaphore_ctx__YELLOW))
        {
            estado_string = "Diagonal L-O (DLO)";
        }
        else
        {
            estado_string = "Indefinido";
        }
        

        printf("=========================== CICLO ATUAL ===========================\n");
        printf(" Modo: %-10s | T. Verde: %-3ds | T. Amarelo: %-3ds | Estado: %s\n", is_priority_mode_active ? "PRIORIDADE" : "NORMAL", st, yt, estado_string);
        printf("-----------------------------------------------------------------\n\n");
        
        printf("ESTADO DOS SEMÁFOROS:\n");
        printf(" Norte -> [LEFT, AHEAD, RIGHT] = [%-6s, %-6s, %-6s]\n", color_to_string(ns_l), color_to_string(ns_a), color_to_string(ns_r));
        printf(" Sul   -> [LEFT, AHEAD, RIGHT] = [%-6s, %-6s, %-6s]\n", color_to_string(sn_l), color_to_string(sn_a), color_to_string(sn_r));
        printf(" Leste -> [LEFT, AHEAD, RIGHT] = [%-6s, %-6s, %-6s]\n", color_to_string(lo_l), color_to_string(lo_a), color_to_string(lo_r));
        printf(" Oeste -> [LEFT, AHEAD, RIGHT] = [%-6s, %-6s, %-6s]\n\n", color_to_string(ol_l), color_to_string(ol_a), color_to_string(ol_r));

        printf("-----------------------------------------------------------------\n");
        printf("COMANDOS:\n");
        printf(" > add <num> <dir> (direções: north, south, east, west | ex: add 10 north)\n");
        
        if (!is_priority_mode_active)
        {
            printf(" > prio <estado>   (estados: ns, lo, dns, dlo)\n");
        }
        
        bool can_calculate;
        SmartSemaphore__pre_calculate_times(&can_calculate);
        if (can_calculate)
        {
            printf(" > calc\n");
        }

        printf(" > quit\n\n");
        printf("Pressione ENTER para o próximo ciclo ou digite um comando:\n> ");


        if (fgets(command_buffer, sizeof(command_buffer), stdin) != NULL)
        {
            command_buffer[strcspn(command_buffer, "\n")] = 0;

            if (strlen(command_buffer) > 0)
            {
                int num;
                char arg1[20];

                if (strncmp(command_buffer, "add", 3) == 0)
                {
                    sscanf(command_buffer, "add %d %s", &num, arg1);
                    SmartSemaphore_ctx__DIRECTION dir = SmartSemaphore_ctx__NORTH;
                    if (strcmp(arg1, "south") == 0)
                    {
                        dir = SmartSemaphore_ctx__SOUTH;
                    }
                    else if (strcmp(arg1, "east") == 0)
                    {
                        dir = SmartSemaphore_ctx__EAST;
                    }
                    else if (strcmp(arg1, "west") == 0)
                    {
                        dir = SmartSemaphore_ctx__WEST;
                    }
                    SmartSemaphore__addCars(num, dir);
                }
                else if (strncmp(command_buffer, "prio", 4) == 0)
                {
                    sscanf(command_buffer, "prio %s", arg1);
                    SmartSemaphore_ctx__STATE priority_state = SmartSemaphore_ctx__NS;
                    if (strcmp(arg1, "lo") == 0)
                    {
                        priority_state = SmartSemaphore_ctx__LO;
                    }
                    else if (strcmp(arg1, "dns") == 0)
                    {
                        priority_state = SmartSemaphore_ctx__DNS;
                    }
                    else if (strcmp(arg1, "dlo") == 0)
                    {
                        priority_state = SmartSemaphore_ctx__DLO;
                    }

                    bool allow_priority;
                    SmartSemaphore__pre_op_prioritize(priority_state, &allow_priority);
                    if (allow_priority)
                    {
                        SmartSemaphore__prioritize(priority_state);
                    }
                }
                else if (strcmp(command_buffer, "calc") == 0)
                {
                    SmartSemaphore__calculate_times();
                }
                else if (strcmp(command_buffer, "quit") == 0)
                {
                    running = false;
                }
            }
        }
    }

    printf("\nSimulação encerrada.\n");
    return 0;
}