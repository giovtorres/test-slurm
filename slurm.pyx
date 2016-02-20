# cython: embedsignature=True
# cython: profile=False

from libc.stdint cimport uint16_t, uint32_t, uint64_t
from libc.stdlib cimport free
from pwd import getpwuid

cdef extern from "stdio.h":
    ctypedef struct FILE
    cdef FILE *stdout

cdef extern from "time.h":
    ctypedef long time_t

include "slurm.pxi"

cpdef api_version():
    return (SLURM_VERSION_MAJOR(SLURM_VERSION_NUMBER), 
            SLURM_VERSION_MINOR(SLURM_VERSION_NUMBER),
            SLURM_VERSION_MICRO(SLURM_VERSION_NUMBER))


cdef class Node:

    def __cinit__(self):
        self._node_info_ptr = NULL
        self._show_flags = 0

    def __dealloc__(self):
        pass


    cpdef get_node(self, char *_node=NULL):
        cdef:
            int i = 0
            int rc
            int total_used
            char *cloud_str
            char *comp_str
            char *drain_str
            char *power_str
            uint16_t err_cpus
            uint16_t alloc_cpus
            uint32_t alloc_memory
            uint32_t node_state
            dict node_info

        if _node == NULL:
            rc = slurm_load_node(<time_t> NULL, &self._node_info_ptr, SHOW_ALL)
        else:
            rc = slurm_load_node_single(&self._node_info_ptr,
                                        _node, self._show_flags)

        if rc == SLURM_SUCCESS:
            self._node_dict = {}
            for i in xrange(self._node_info_ptr.record_count):
                node_info = {}
                cloud_str = ""
                comp_str = ""
                drain_str = ""
                power_str = ""
                err_cpus = 0
                alloc_cpus = 0

                node_info["arch"] = strOrNone(self._node_info_ptr.node_array[i].arch)
                node_info["boards"] = self._node_info_ptr.node_array[i].boards
                node_info["boot_time"] = self._node_info_ptr.node_array[i].boot_time
                node_info["cores"] = self._node_info_ptr.node_array[i].cores
                node_info["core_spec_cnt"] = self._node_info_ptr.node_array[i].core_spec_cnt
                node_info["cpu_load"] = (self._node_info_ptr.node_array[i].cpu_load / 100.0)
                node_info["free_mem"] = self._node_info_ptr.node_array[i].free_mem

                node_info["cpus"] = self._node_info_ptr.node_array[i].cpus
                total_used = self._node_info_ptr.node_array[i].cpus

                node_info["cpu_spec_list"] = listOrNone(self._node_info_ptr.node_array[i].cpu_spec_list)
                node_info["features"] = listOrNone(self._node_info_ptr.node_array[i].features)
                node_info["gres"] = listOrNone(self._node_info_ptr.node_array[i].gres)
                node_info["gres_drain"] = listOrNone(self._node_info_ptr.node_array[i].gres_drain)
                node_info["gres_used"] = listOrNone(self._node_info_ptr.node_array[i].gres_used)
                node_info["mem_spec_limit"] = self._node_info_ptr.node_array[i].mem_spec_limit
                node_info["name"] = self._node_info_ptr.node_array[i].name
                node_info["node_addr"] = self._node_info_ptr.node_array[i].node_addr
                node_info["node_hostname"] = self._node_info_ptr.node_array[i].node_hostname

                node_info["os"] = self._node_info_ptr.node_array[i].os
                
                if self._node_info_ptr.node_array[i].owner == NO_VAL:
                    node_info["owner"] = None
                else:
                    node_info["owner"] = self._node_info_ptr.node_array[i].owner

                node_info["real_memory"] = self._node_info_ptr.node_array[i].real_memory
                node_info["slurmd_start_time"] = self._node_info_ptr.node_array[i].slurmd_start_time
                node_info["sockets"] = self._node_info_ptr.node_array[i].sockets
                node_info["threads"] = self._node_info_ptr.node_array[i].threads
                node_info["tmp_disk"] = self._node_info_ptr.node_array[i].tmp_disk
                node_info["weight"] = self._node_info_ptr.node_array[i].weight
                node_info["tres_fmt_str"] = strOrNone(self._node_info_ptr.node_array[i].tres_fmt_str)
                node_info["version"] = strOrNone(self._node_info_ptr.node_array[i].version)

                node_state = self._node_info_ptr.node_array[i].node_state
                if (node_state & NODE_STATE_CLOUD):
                    node_state &= (~NODE_STATE_CLOUD)
                    cloud_str = "+CLOUD"

                if (node_state & NODE_STATE_COMPLETING):
                    node_state &= (~NODE_STATE_COMPLETING)
                    comp_str = "+COMPLETING"

                if (node_state & NODE_STATE_DRAIN):
                    node_state &= (~NODE_STATE_DRAIN)
                    drain_str = "+DRAIN"

                if (node_state & NODE_STATE_FAIL):
                    node_state &= (~NODE_STATE_FAIL)
                    drain_str = "+FAIL"

                if (node_state & NODE_STATE_POWER_SAVE):
                    node_state &= (~NODE_STATE_POWER_SAVE)
                    power_str = "+POWER"

                slurm_get_select_nodeinfo(self._node_info_ptr.node_array[i].select_nodeinfo,
                                          SELECT_NODEDATA_SUBCNT,
                                          NODE_STATE_ALLOCATED,
                                          &alloc_cpus)
                node_info["alloc_cpus"] = alloc_cpus
                total_used -= alloc_cpus
                
                slurm_get_select_nodeinfo(self._node_info_ptr.node_array[i].select_nodeinfo,
                                          SELECT_NODEDATA_SUBCNT,
                                          NODE_STATE_ERROR,
                                          &err_cpus)
                node_info["err_cpus"] = err_cpus
                total_used -= err_cpus

                if ((alloc_cpus and err_cpus) or (total_used and
                    (total_used != self._node_info_ptr.node_array[i].cpus))):
                    node_state &= NODE_STATE_FLAGS
                    node_state |= NODE_STATE_MIXED

                node_info["node_state"] = (slurm_node_state_string(node_state) +
                                           cloud_str + comp_str +
                                           drain_str + power_str)

                slurm_get_select_nodeinfo(self._node_info_ptr.node_array[i].select_nodeinfo,
                                          SELECT_NODEDATA_MEM_ALLOC,
                                          NODE_STATE_ALLOCATED,
                                          &alloc_memory)
                node_info["alloc_memory"] = alloc_memory

                # Power Consumption Line
                if (not self._node_info_ptr.node_array[i].power or
                    (self._node_info_ptr.node_array[i].power.cap_watts == NO_VAL)):
                    node_info["cap_watts"] = None
                else:
                    node_info["cap_watts"] = self._node_info_ptr.node_array[i].power.cap_watts

                if (not self._node_info_ptr.node_array[i].energy or
                    self._node_info_ptr.node_array[i].energy.current_watts == NO_VAL):
                    node_info["current_watts"] = None
                    node_info["lowest_joules"] = None
                    node_info["consumed_joules"] = None
                else:
                    node_info["current_watts"] = self._node_info_ptr.node_array[i].energy.current_watts
                    node_info["lowest_joules"] = self._node_info_ptr.node_array[i].energy.base_consumed_energy
                    node_info["consumed_joules"] = self._node_info_ptr.node_array[i].energy.consumed_energy
                    
                # External Sensors Line
                if not self._node_info_ptr.node_array[i].ext_sensors:
                    node_info["ext_sensors_joules"] = None
                    node_info["ext_sensors_watts"] = None
                    node_info["ext_sensors_temp"] = None
                else:
                    if self._node_info_ptr.node_array[i].ext_sensors.consumed_energy == NO_VAL:
                        node_info["ext_sensors_joules"] = None
                    else:
                        node_info["ext_sensors_joules"] = self._node_info_ptr.node_array[i].ext_sensors.consumed_energy

                    if self._node_info_ptr.node_array[i].ext_sensors.current_watts == NO_VAL:
                        node_info["ext_sensors_watts"] = None
                    else:
                        node_info["ext_sensors_watts"] = self._node_info_ptr.node_array[i].ext_sensors.current_watts

                    if self._node_info_ptr.node_array[i].ext_sensors.temperature == NO_VAL:
                        node_info["ext_sensors_temp"] = None
                    else:
                        node_info["ext_sensors_temp"] = self._node_info_ptr.node_array[i].ext_sensors.temperature

                # Reason Line
                node_info["reason"] = strOrNone(self._node_info_ptr.node_array[i].reason)
                if self._node_info_ptr.node_array[i].reason_time == 0:
                    node_info["reason_time"] = None
                else:
                    node_info["reason_time"] = self._node_info_ptr.node_array[i].reason_time

                if self._node_info_ptr.node_array[i].reason_uid == NO_VAL:
                    node_info["reason_uid"] = None
                else:
                    node_info["reason_uid"] = self._node_info_ptr.node_array[i].reason_uid


                self._node_dict[self._node_info_ptr.node_array[i].name] = node_info

            slurm_free_node_info_msg(self._node_info_ptr)
            self._node_info_ptr = NULL
            return self._node_dict
        else:
            # Raise exception instead
            slurm_perror("slurm_load_node_single error")
            return


    cpdef update_node(self):
        pass


cdef class Job:

    def __cinit__(self):
        self._job_info_ptr = NULL
        self._show_flags = 0

    def __dealloc__(self):
        pass


    cpdef get_job(self, uint32_t _jobid):
        cdef:
#            int i
            int rc
#            dict node_info

        rc = slurm_load_job(&self._job_info_ptr, _jobid, SHOW_ALL)
        if rc == SLURM_SUCCESS:
            self._job_dict = {}
            slurm_free_job_info_msg(self._job_info_ptr)
            self._job_info_ptr = NULL
            return self._job_dict
        else:
            slurm_perror("slurm_load_job error")
            return


cdef class Conf:

    def __cinit__(self):
        self._conf_info_msg_ptr = NULL
        self._conf_dict = {}

    def __dealloc__(self):
        self.__destroy()

    cpdef __destroy(self):
        if self._conf_info_msg_ptr is not NULL:
            slurm_free_ctl_conf(self._conf_info_msg_ptr)

    cpdef load_conf(self):
        rc = slurm_load_ctl_conf(<time_t> NULL, &self._conf_info_msg_ptr)
        if rc != SLURM_SUCCESS:
            slurm_perror("slurm_load_ctl_conf error")
            return

    cpdef print_conf(self):
        if self._conf_info_msg_ptr is not NULL:
            slurm_print_ctl_conf (stdout, self._conf_info_msg_ptr)


cdef class Stat:
    def __cinit__(self):
        self._buf = NULL
        self._stat_dict = {}

    def __dealloc__(self):
        self._buf = NULL

    cpdef get_stats(self):
        cdef:
            int i
            int rc
            dict rpc_type_stats
            dict rpc_user_stats

        self._req.command_id = STAT_COMMAND_GET

        rc = slurm_get_statistics(&self._buf,
                                  <stats_info_request_msg_t*>&self._req)

        if rc == SLURM_SUCCESS:
            self._stat_dict["parts_packed"] = self._buf.parts_packed
            self._stat_dict["req_time"] = self._buf.req_time
            self._stat_dict["req_time_start"] = self._buf.req_time_start
            self._stat_dict["server_thread_count"] = self._buf.server_thread_count
            self._stat_dict["agent_queue_size"] = self._buf.agent_queue_size

            self._stat_dict["schedule_cycle_max"] = self._buf.schedule_cycle_max
            self._stat_dict["schedule_cycle_last"] = self._buf.schedule_cycle_last
            self._stat_dict["schedule_cycle_sum"] = self._buf.schedule_cycle_sum
            self._stat_dict["schedule_cycle_counter"] = self._buf.schedule_cycle_counter
            self._stat_dict["schedule_cycle_depth"] = self._buf.schedule_cycle_depth
            self._stat_dict["schedule_queue_len"] = self._buf.schedule_queue_len

            self._stat_dict["jobs_submitted"] = self._buf.jobs_submitted
            self._stat_dict["jobs_started"] = self._buf.jobs_started
            self._stat_dict["jobs_completed"] = self._buf.jobs_completed
            self._stat_dict["jobs_canceled"] = self._buf.jobs_canceled
            self._stat_dict["jobs_failed"] = self._buf.jobs_failed

            self._stat_dict["bf_backfilled_jobs"] = self._buf.bf_backfilled_jobs
            self._stat_dict["bf_last_backfilled_jobs"] = self._buf.bf_last_backfilled_jobs
            self._stat_dict["bf_cycle_counter"] = self._buf.bf_cycle_counter
            self._stat_dict["bf_cycle_sum"] = self._buf.bf_cycle_sum
            self._stat_dict["bf_cycle_last"] = self._buf.bf_cycle_last
            self._stat_dict["bf_cycle_max"] = self._buf.bf_cycle_max
            self._stat_dict["bf_last_depth"] = self._buf.bf_last_depth
            self._stat_dict["bf_last_depth_try"] = self._buf.bf_last_depth_try
            self._stat_dict["bf_depth_sum"] = self._buf.bf_depth_sum
            self._stat_dict["bf_depth_try_sum"] = self._buf.bf_depth_try_sum
            self._stat_dict["bf_queue_len"] = self._buf.bf_queue_len
            self._stat_dict["bf_queue_len_sum"] = self._buf.bf_queue_len_sum
            self._stat_dict["bf_when_last_cycle"] = self._buf.bf_when_last_cycle
            self._stat_dict["bf_active"] = self._buf.bf_active

            rpc_type_stats = {}

            for i in xrange(self._buf.rpc_type_size):
                rpc_type = self.__rpc_num2string(self._buf.rpc_type_id[i])
                #rpc_type = rpc_num2string(self._buf.rpc_type_id[i])
                rpc_type_stats[rpc_type] = {}
                rpc_type_stats[rpc_type]["id"] = self._buf.rpc_type_id[i]
                rpc_type_stats[rpc_type]["count"] = self._buf.rpc_type_cnt[i]
                rpc_type_stats[rpc_type]["ave_time"] = (self._buf.rpc_type_time[i] /
                                                        self._buf.rpc_type_cnt[i])
                rpc_type_stats[rpc_type]["total_time"] = self._buf.rpc_type_time[i]
            self._stat_dict["rpc_type_stats"] = rpc_type_stats

            rpc_user_stats = {}

            for i in xrange(self._buf.rpc_user_size):
                rpc_user = getpwuid(self._buf.rpc_user_id[i])[0]
                rpc_user_stats[rpc_user] = {}
                rpc_user_stats[rpc_user]["id"] = self._buf.rpc_user_id[i]
                rpc_user_stats[rpc_user]["count"] = self._buf.rpc_user_cnt[i]
                rpc_user_stats[rpc_user]["ave_time"] = (self._buf.rpc_user_time[i] /
                                                        self._buf.rpc_user_cnt[i])
                rpc_user_stats[rpc_user]["total_time"] = self._buf.rpc_user_time[i]
            self._stat_dict["rpc_user_stats"] = rpc_user_stats
                
            slurm_free_stats_response_msg(self._buf)
            return self._stat_dict
        else:
            slurm_perror("slurm_get_statistics error")
            return


    cpdef reset_stats(self) :
        self._req.command_id = STAT_COMMAND_RESET
        # This leaks memory
        rc = slurm_reset_statistics(<stats_info_request_msg_t*>&self._req)

        if rc == SLURM_SUCCESS:
            return rc
        else:
            slurm_perror("slurm_reset_statistics")


    cpdef __rpc_num2string(self, uint16_t opcode):
        num2string = {
            1001: "REQUEST_NODE_REGISTRATION_STATUS",
            1002: "MESSAGE_NODE_REGISTRATION_STATUS",
            1003: "REQUEST_RECONFIGURE",
            1004: "RESPONSE_RECONFIGURE",
            1005: "REQUEST_SHUTDOWN",
            1006: "REQUEST_SHUTDOWN_IMMEDIATE",
            1007: "RESPONSE_SHUTDOWN",
            1008: "REQUEST_PING",
            1009: "REQUEST_CONTROL",
            1010: "REQUEST_SET_DEBUG_LEVEL",
            1011: "REQUEST_HEALTH_CHECK",
            1012: "REQUEST_TAKEOVER",
            1013: "REQUEST_SET_SCHEDLOG_LEVEL",
            1014: "REQUEST_SET_DEBUG_FLAGS",
            1015: "REQUEST_REBOOT_NODES",
            1016: "RESPONSE_PING_SLURMD",
            1017: "REQUEST_ACCT_GATHER_UPDATE",
            1018: "RESPONSE_ACCT_GATHER_UPDATE",
            1019: "REQUEST_ACCT_GATHER_ENERGY",
            1020: "RESPONSE_ACCT_GATHER_ENERGY",
            1021: "REQUEST_LICENSE_INFO",
            1022: "RESPONSE_LICENSE_INFO",

            2001: "REQUEST_BUILD_INFO",
            2002: "RESPONSE_BUILD_INFO",
            2003: "REQUEST_JOB_INFO",
            2004: "RESPONSE_JOB_INFO",
            2005: "REQUEST_JOB_STEP_INFO",
            2006: "RESPONSE_JOB_STEP_INFO",
            2007: "REQUEST_NODE_INFO",
            2008: "RESPONSE_NODE_INFO",
            2009: "REQUEST_PARTITION_INFO",
            2010: "RESPONSE_PARTITION_INFO",
            2011: "REQUEST_ACCTING_INFO",
            2012: "RESPONSE_ACCOUNTING_INFO",
            2013: "REQUEST_JOB_ID",
            2014: "RESPONSE_JOB_ID",
            2015: "REQUEST_BLOCK_INFO",
            2016: "RESPONSE_BLOCK_INFO",
            2017: "REQUEST_TRIGGER_SET",
            2018: "REQUEST_TRIGGER_GET",
            2019: "REQUEST_TRIGGER_CLEAR",
            2020: "RESPONSE_TRIGGER_GET",
            2021: "REQUEST_JOB_INFO_SINGLE",
            2022: "REQUEST_SHARE_INFO",
            2023: "RESPONSE_SHARE_INFO",
            2024: "REQUEST_RESERVATION_INFO",
            2025: "RESPONSE_RESERVATION_INFO",
            2026: "REQUEST_PRIORITY_FACTORS",
            2027: "RESPONSE_PRIORITY_FACTORS",
            2028: "REQUEST_TOPO_INFO",
            2029: "RESPONSE_TOPO_INFO",
            2030: "REQUEST_TRIGGER_PULL",
            2031: "REQUEST_FRONT_END_INFO",
            2032: "RESPONSE_FRONT_END_INFO",
            2033: "REQUEST_SPANK_ENVIRONMENT",
            2034: "RESPONCE_SPANK_ENVIRONMENT",
            2035: "REQUEST_STATS_INFO",
            2036: "RESPONSE_STATS_INFO",
            2037: "REQUEST_BURST_BUFFER_INFO",
            2038: "RESPONSE_BURST_BUFFER_INFO",
            2039: "REQUEST_JOB_USER_INFO",
            2040: "REQUEST_NODE_INFO_SINGLE",
            2041: "REQUEST_POWERCAP_INFO",
            2042: "RESPONSE_POWERCAP_INFO",
            2043: "REQUEST_ASSOC_MGR_INFO",
            2044: "RESPONSE_ASSOC_MGR_INFO",
            2045: "REQUEST_SICP_INFO_DEFUNCT",
            2046: "RESPONSE_SICP_INFO_DEFUNCT",
            2047: "REQUEST_LAYOUT_INFO",
            2048: "RESPONSE_LAYOUT_INFO",

            3001: "REQUEST_UPDATE_JOB",
            3002: "REQUEST_UPDATE_NODE",
            3003: "REQUEST_CREATE_PARTITION",
            3004: "REQUEST_DELETE_PARTITION",
            3005: "REQUEST_UPDATE_PARTITION",
            3006: "REQUEST_CREATE_RESERVATION",
            3007: "RESPONSE_CREATE_RESERVATION",
            3008: "REQUEST_DELETE_RESERVATION",
            3009: "REQUEST_UPDATE_RESERVATION",
            3010: "REQUEST_UPDATE_BLOCK",
            3011: "REQUEST_UPDATE_FRONT_END",
            3012: "REQUEST_UPDATE_LAYOUT",
            3013: "REQUEST_UPDATE_POWERCAP",

            4001: "REQUEST_RESOURCE_ALLOCATION",
            4002: "RESPONSE_RESOURCE_ALLOCATION",
            4003: "REQUEST_SUBMIT_BATCH_JOB",
            4004: "RESPONSE_SUBMIT_BATCH_JOB",
            4005: "REQUEST_BATCH_JOB_LAUNCH",
            4006: "REQUEST_CANCEL_JOB",
            4007: "RESPONSE_CANCEL_JOB",
            4008: "REQUEST_JOB_RESOURCE",
            4009: "RESPONSE_JOB_RESOURCE",
            4010: "REQUEST_JOB_ATTACH",
            4011: "RESPONSE_JOB_ATTACH",
            4012: "REQUEST_JOB_WILL_RUN",
            4013: "RESPONSE_JOB_WILL_RUN",
            4014: "REQUEST_JOB_ALLOCATION_INFO",
            4015: "RESPONSE_JOB_ALLOCATION_INFO",
            4016: "REQUEST_JOB_ALLOCATION_INFO_LITE",
            4017: "RESPONSE_JOB_ALLOCATION_INFO_LITE",
            4018: "REQUEST_UPDATE_JOB_TIME",
            4019: "REQUEST_JOB_READY",
            4020: "RESPONSE_JOB_READY",
            4021: "REQUEST_JOB_END_TIME",
            4022: "REQUEST_JOB_NOTIFY",
            4023: "REQUEST_JOB_SBCAST_CRED",
            4024: "RESPONSE_JOB_SBCAST_CRED",

            5001: "REQUEST_JOB_STEP_CREATE",
            5002: "RESPONSE_JOB_STEP_CREATE",
            5003: "REQUEST_RUN_JOB_STEP",
            5004: "RESPONSE_RUN_JOB_STEP",
            5005: "REQUEST_CANCEL_JOB_STEP",
            5006: "RESPONSE_CANCEL_JOB_STEP",
            5007: "REQUEST_UPDATE_JOB_STEP",
            5008: "DEFUNCT_RESPONSE_COMPLETE_JOB_STEP",
            5009: "REQUEST_CHECKPOINT",
            5010: "RESPONSE_CHECKPOINT",
            5011: "REQUEST_CHECKPOINT_COMP",
            5012: "REQUEST_CHECKPOINT_TASK_COMP",
            5013: "RESPONSE_CHECKPOINT_COMP",
            5014: "REQUEST_SUSPEND",
            5015: "RESPONSE_SUSPEND",
            5016: "REQUEST_STEP_COMPLETE",
            5017: "REQUEST_COMPLETE_JOB_ALLOCATION",
            5018: "REQUEST_COMPLETE_BATCH_SCRIPT",
            5019: "REQUEST_JOB_STEP_STAT",
            5020: "RESPONSE_JOB_STEP_STAT",
            5021: "REQUEST_STEP_LAYOUT",
            5022: "RESPONSE_STEP_LAYOUT",
            5023: "REQUEST_JOB_REQUEUE",
            5024: "REQUEST_DAEMON_STATUS",
            5025: "RESPONSE_SLURMD_STATUS",
            5026: "RESPONSE_SLURMCTLD_STATUS",
            5027: "REQUEST_JOB_STEP_PIDS",
            5028: "RESPONSE_JOB_STEP_PIDS",
            5029: "REQUEST_FORWARD_DATA",
            5030: "REQUEST_COMPLETE_BATCH_JOB",
            5031: "REQUEST_SUSPEND_INT",
            5032: "REQUEST_KILL_JOB",
            5033: "REQUEST_KILL_JOBSTEP",
            5034: "RESPONSE_JOB_ARRAY_ERRORS",
            5035: "REQUEST_NETWORK_CALLERID",
            5036: "RESPONSE_NETWORK_CALLERID",
            5037: "REQUEST_STEP_COMPLETE_AGGR",
            5038: "REQUEST_TOP_JOB",

            6001: "REQUEST_LAUNCH_TASKS",
            6002: "RESPONSE_LAUNCH_TASKS",
            6003: "MESSAGE_TASK_EXIT",
            6004: "REQUEST_SIGNAL_TASKS",
            6005: "REQUEST_CHECKPOINT_TASKS",
            6006: "REQUEST_TERMINATE_TASKS",
            6007: "REQUEST_REATTACH_TASKS",
            6008: "RESPONSE_REATTACH_TASKS",
            6009: "REQUEST_KILL_TIMELIMIT",
            6010: "REQUEST_SIGNAL_JOB",
            6011: "REQUEST_TERMINATE_JOB",
            6012: "MESSAGE_EPILOG_COMPLETE",
            6013: "REQUEST_ABORT_JOB",
            6014: "REQUEST_FILE_BCAST",
            6015: "TASK_USER_MANAGED_IO_STREAM",
            6016: "REQUEST_KILL_PREEMPTED",
            6017: "REQUEST_LAUNCH_PROLOG",
            6018: "REQUEST_COMPLETE_PROLOG",
            6019: "RESPONSE_PROLOG_EXECUTING",

            7001: "SRUN_PING",
            7002: "SRUN_TIMEOUT",
            7003: "SRUN_NODE_FAIL",
            7004: "SRUN_JOB_COMPLETE",
            7005: "SRUN_USER_MSG",
            7006: "SRUN_EXEC",
            7007: "SRUN_STEP_MISSING",
            7008: "SRUN_REQUEST_SUSPEND",

            7201: "PMI_KVS_PUT_REQ",
            7202: "PMI_KVS_PUT_RESP",
            7203: "PMI_KVS_GET_REQ",
            7204: "PMI_KVS_GET_RESP",

            8001: "RESPONSE_SLURM_RC",
            8002: "RESPONSE_SLURM_RC_MSG",

            9001: "RESPONSE_FORWARD_FAILED",

            10001: "ACCOUNTING_UPDATE_MSG",
            10002: "ACCOUNTING_FIRST_REG",
            10003: "ACCOUNTING_REGISTER_CTLD",

            11001: "MESSAGE_COMPOSITE",
            11002: "RESPONSE_MESSAGE_COMPOSITE" }

        return num2string[opcode]
