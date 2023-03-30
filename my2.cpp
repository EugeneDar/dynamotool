#include "dr_api.h"
#include "drmgr.h"

#ifdef WINDOWS
#    define DISPLAY_STRING(msg) dr_messagebox(msg)
#else
#    define DISPLAY_STRING(msg) dr_printf("%s\n", msg);
#endif

#define NULL_TERMINATE(buf) (buf)[(sizeof((buf)) / sizeof((buf)[0])) - 1] = '\0'

static dr_emit_flags_t
event_app_instruction(void *drcontext, void *tag, instrlist_t *bb, instr_t *instr,
                      bool for_trace, bool translating, void *user_data);
static void
exit_event(void);

static int push_count = 0;
static void *count_mutex; /* for multithread support */

DR_EXPORT void
dr_client_main(client_id_t id, int argc, const char *argv[])
{
    dr_set_client_name("DynamoRIO Sample Client 'push_count'", "http://dynamorio.org/issues");
    if (!drmgr_init())
        DR_ASSERT(false);
    dr_register_exit_event(exit_event);
    if (!drmgr_register_bb_instrumentation_event(NULL, event_app_instruction, NULL))
        DR_ASSERT(false);
    count_mutex = dr_mutex_create();
}

static void
exit_event(void)
{
#ifdef SHOW_RESULTS
    char msg[512];
    int len;
    len = dr_snprintf(msg, sizeof(msg) / sizeof(msg[0]),
                      "Instrumentation results:\n"
                      "  saw %d push instructions\n",
                      push_count);
    DR_ASSERT(len > 0);
    NULL_TERMINATE(msg);
    DISPLAY_STRING(msg);
#endif /* SHOW_RESULTS */

    dr_mutex_destroy(count_mutex);
    drmgr_exit();
}

static void
callback(app_pc addr)
{
    /* instead of a lock could use atomic operations to increment the counters */
    dr_mutex_lock(count_mutex);
    push_count++;
    dr_mutex_unlock(count_mutex);
}

static dr_emit_flags_t
event_app_instruction(void *drcontext, void *tag, instrlist_t *bb, instr_t *instr,
                      bool for_trace, bool translating, void *user_data)
{
    /* if find push, insert a clean call to our instrumentation routine */
    if (instr_get_opcode(instr) == OP_push || instr_get_opcode(instr) == OP_pushf || instr_get_opcode(instr) == OP_push_imm || instr_get_opcode(instr) == OP_pusha) {
        dr_insert_clean_call(drcontext, bb, instr, (void *)callback, false /*no fp save*/,
                             1, OPND_CREATE_INTPTR(instr_get_app_pc(instr)));
    }
    return DR_EMIT_DEFAULT;
}
