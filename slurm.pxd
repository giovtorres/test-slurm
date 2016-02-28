from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t
from libc.stdint cimport int32_t
from cpython cimport bool

cdef extern from "stdio.h":
    ctypedef struct FILE
    cdef FILE *stdout

cdef extern from "time.h":
    ctypedef long time_t

cdef extern from "Python.h":
    int __LINE__
    const char *__FILE__
    const char *__FUNCTION__

include "slurm.pxi"

#
# Main Slurm API
#

#cdef inline SLURM_VERSION_NUM(long a, long b, long c):
#    return (((a) << 16) + ((b) << 8) + (c))
#
#cdef inline SLURM_VERSION_MAJOR(long a):
#    return (((a) >> 16) & 0xff)
#
#cdef inline SLURM_VERSION_MINOR(long a):
#    return (((a) >> 8) & 0xff)
#
#cdef inline SLURM_VERSION_MICRO(long a):
#    return ((a) & 0xff)

#cdef inline PARTITION_DOWN:
#    return PARTITION_SUBMIT

#cdef inline PARTITION_UP:
#    return (PARTITION_SUBMIT | PARTITION_SCHED)

#cdef inline PARTITION_DRAIN:
#    return PARTITION_SCHED

#
# Declarations from slurm.h
#

cdef extern from "slurm/slurm.h" nogil:

    # DEFINITIONS FOR VERSION MANAGEMENT
    long int SLURM_VERSION_NUMBER
    int SLURM_VERSION_NUM(int a, int b, int c)
    int SLURM_VERSION_MAJOR(int a)
    int SLURM_VERSION_MINOR(int a)
    int SLURM_VERSION_MICRO(int a)

    # DEFINITIONS FOR INPUT VALUES
    long int INFINITE
    long long int INFINITE64
    long int NO_VAL
    long long int NO_VAL64
    int MAX_TASKS_PER_NODE

    long int SLURM_BATCH_SCRIPT
    long int SLURM_EXTERN_CONT

    int DEFAULT_EIO_SHUTDOWN_WAIT
    long int SLURM_ID_HASH_NUM

    #SLURM_ID_HASH(uint32_t _jobid, uint32_t _stepid)

    #SLURM_ID_HASH_JOB_ID(hash_id)

    #SLURM_ID_HASH_STEP_ID(hash_id)

    enum job_states:
        JOB_PENDING
        JOB_RUNNING
        JOB_SUSPENDED
        JOB_COMPLETE
        JOB_CANCELLED
        JOB_FAILED
        JOB_TIMEOUT
        JOB_NODE_FAIL
        JOB_PREEMPTED
        JOB_BOOT_FAIL
        JOB_END

    long int JOB_STATE_BASE
    long int JOB_STATE_FLAGS

    long int JOB_LAUNCH_FAILED
    long int JOB_UPDATE_DB
    long int JOB_REQUEUE
    long int JOB_REQUEUE_HOLD
    long int JOB_SPECIAL_EXIT
    long int JOB_RESIZING
    long int JOB_CONFIGURING
    long int JOB_COMPLETING
    long int JOB_STOPPED

    enum job_state_reason:
        WAIT_NO_REASON
        WAIT_PRIORITY
        WAIT_DEPENDENCY
        WAIT_RESOURCES
        WAIT_PART_NODE_LIMIT
        WAIT_PART_TIME_LIMIT
        WAIT_PART_DOWN
        WAIT_PART_INACTIVE
        WAIT_HELD
        WAIT_TIME
        WAIT_LICENSES
        WAIT_ASSOC_JOB_LIMIT
        WAIT_ASSOC_RESOURCE_LIMIT
        WAIT_ASSOC_TIME_LIMIT
        WAIT_RESERVATION
        WAIT_NODE_NOT_AVAIL
        WAIT_HELD_USER
        WAIT_FRONT_END
        FAIL_DOWN_PARTITION
        FAIL_DOWN_NODE
        FAIL_BAD_CONSTRAINTS
        FAIL_SYSTEM
        FAIL_LAUNCH
        FAIL_EXIT_CODE
        FAIL_TIMEOUT
        FAIL_INACTIVE_LIMIT
        FAIL_ACCOUNT
        FAIL_QOS
        WAIT_QOS_THRES
        WAIT_QOS_JOB_LIMIT
        WAIT_QOS_RESOURCE_LIMIT
        WAIT_QOS_TIME_LIMIT
        WAIT_BLOCK_MAX_ERR
        WAIT_BLOCK_D_ACTION
        WAIT_CLEANING
        WAIT_PROLOG
        WAIT_QOS
        WAIT_ACCOUNT
        WAIT_DEP_INVALID
        WAIT_QOS_GRP_CPU
        WAIT_QOS_GRP_CPU_MIN
        WAIT_QOS_GRP_CPU_RUN_MIN
        WAIT_QOS_GRP_JOB
        WAIT_QOS_GRP_MEM
        WAIT_QOS_GRP_NODE
        WAIT_QOS_GRP_SUB_JOB
        WAIT_QOS_GRP_WALL
        WAIT_QOS_MAX_CPU_PER_JOB
        WAIT_QOS_MAX_CPU_MINS_PER_JOB
        WAIT_QOS_MAX_NODE_PER_JOB
        WAIT_QOS_MAX_WALL_PER_JOB
        WAIT_QOS_MAX_CPU_PER_USER
        WAIT_QOS_MAX_JOB_PER_USER
        WAIT_QOS_MAX_NODE_PER_USER
        WAIT_QOS_MAX_SUB_JOB
        WAIT_QOS_MIN_CPU
        WAIT_ASSOC_GRP_CPU
        WAIT_ASSOC_GRP_CPU_MIN
        WAIT_ASSOC_GRP_CPU_RUN_MIN
        WAIT_ASSOC_GRP_JOB
        WAIT_ASSOC_GRP_MEM
        WAIT_ASSOC_GRP_NODE
        WAIT_ASSOC_GRP_SUB_JOB
        WAIT_ASSOC_GRP_WALL
        WAIT_ASSOC_MAX_JOBS
        WAIT_ASSOC_MAX_CPU_PER_JOB
        WAIT_ASSOC_MAX_CPU_MINS_PER_JOB
        WAIT_ASSOC_MAX_NODE_PER_JOB
        WAIT_ASSOC_MAX_WALL_PER_JOB
        WAIT_ASSOC_MAX_SUB_JOB
        WAIT_MAX_REQUEUE
        WAIT_ARRAY_TASK_LIMIT
        WAIT_BURST_BUFFER_RESOURCE
        WAIT_BURST_BUFFER_STAGING
        FAIL_BURST_BUFFER_OP
        WAIT_POWER_NOT_AVAIL
        WAIT_POWER_RESERVED
        WAIT_ASSOC_GRP_UNK
        WAIT_ASSOC_GRP_UNK_MIN
        WAIT_ASSOC_GRP_UNK_RUN_MIN
        WAIT_ASSOC_MAX_UNK_PER_JOB
        WAIT_ASSOC_MAX_UNK_PER_NODE
        WAIT_ASSOC_MAX_UNK_MINS_PER_JOB
        WAIT_ASSOC_MAX_CPU_PER_NODE
        WAIT_ASSOC_GRP_MEM_MIN
        WAIT_ASSOC_GRP_MEM_RUN_MIN
        WAIT_ASSOC_MAX_MEM_PER_JOB
        WAIT_ASSOC_MAX_MEM_PER_NODE
        WAIT_ASSOC_MAX_MEM_MINS_PER_JOB
        WAIT_ASSOC_GRP_NODE_MIN
        WAIT_ASSOC_GRP_NODE_RUN_MIN
        WAIT_ASSOC_MAX_NODE_MINS_PER_JOB
        WAIT_ASSOC_GRP_ENERGY
        WAIT_ASSOC_GRP_ENERGY_MIN
        WAIT_ASSOC_GRP_ENERGY_RUN_MIN
        WAIT_ASSOC_MAX_ENERGY_PER_JOB
        WAIT_ASSOC_MAX_ENERGY_PER_NODE
        WAIT_ASSOC_MAX_ENERGY_MINS_PER_JOB
        WAIT_ASSOC_GRP_GRES
        WAIT_ASSOC_GRP_GRES_MIN
        WAIT_ASSOC_GRP_GRES_RUN_MIN
        WAIT_ASSOC_MAX_GRES_PER_JOB
        WAIT_ASSOC_MAX_GRES_PER_NODE
        WAIT_ASSOC_MAX_GRES_MINS_PER_JOB
        WAIT_ASSOC_GRP_LIC
        WAIT_ASSOC_GRP_LIC_MIN
        WAIT_ASSOC_GRP_LIC_RUN_MIN
        WAIT_ASSOC_MAX_LIC_PER_JOB
        WAIT_ASSOC_MAX_LIC_MINS_PER_JOB
        WAIT_ASSOC_GRP_BB
        WAIT_ASSOC_GRP_BB_MIN
        WAIT_ASSOC_GRP_BB_RUN_MIN
        WAIT_ASSOC_MAX_BB_PER_JOB
        WAIT_ASSOC_MAX_BB_PER_NODE
        WAIT_ASSOC_MAX_BB_MINS_PER_JOB
        WAIT_QOS_GRP_UNK
        WAIT_QOS_GRP_UNK_MIN
        WAIT_QOS_GRP_UNK_RUN_MIN
        WAIT_QOS_MAX_UNK_PER_JOB
        WAIT_QOS_MAX_UNK_PER_NODE
        WAIT_QOS_MAX_UNK_PER_USER
        WAIT_QOS_MAX_UNK_MINS_PER_JOB
        WAIT_QOS_MIN_UNK
        WAIT_QOS_MAX_CPU_PER_NODE
        WAIT_QOS_GRP_MEM_MIN
        WAIT_QOS_GRP_MEM_RUN_MIN
        WAIT_QOS_MAX_MEM_MINS_PER_JOB
        WAIT_QOS_MAX_MEM_PER_JOB
        WAIT_QOS_MAX_MEM_PER_NODE
        WAIT_QOS_MAX_MEM_PER_USER
        WAIT_QOS_MIN_MEM
        WAIT_QOS_GRP_ENERGY
        WAIT_QOS_GRP_ENERGY_MIN
        WAIT_QOS_GRP_ENERGY_RUN_MIN
        WAIT_QOS_MAX_ENERGY_PER_JOB
        WAIT_QOS_MAX_ENERGY_PER_NODE
        WAIT_QOS_MAX_ENERGY_PER_USER
        WAIT_QOS_MAX_ENERGY_MINS_PER_JOB
        WAIT_QOS_MIN_ENERGY
        WAIT_QOS_GRP_NODE_MIN
        WAIT_QOS_GRP_NODE_RUN_MIN
        WAIT_QOS_MAX_NODE_MINS_PER_JOB
        WAIT_QOS_MIN_NODE
        WAIT_QOS_GRP_GRES
        WAIT_QOS_GRP_GRES_MIN
        WAIT_QOS_GRP_GRES_RUN_MIN
        WAIT_QOS_MAX_GRES_PER_JOB
        WAIT_QOS_MIN_GRES
        WAIT_QOS_GRP_LIC
        WAIT_QOS_GRP_LIC_MIN
        WAIT_QOS_GRP_LIC_RUN_MIN
        WAIT_QOS_MAX_LIC_PER_JOB
        WAIT_QOS_MAX_LIC_PER_USER
        WAIT_QOS_MAX_LIC_MINS_PER_JOB
        WAIT_QOS_MIN_LIC
        WAIT_QOS_GRP_BB
        WAIT_QOS_GRP_BB_MIN
        WAIT_QOS_GRP_BB_RUN_MIN
        WAIT_QOS_MAX_BB_PER_JOB
        WAIT_QOS_MAX_BB_PER_NODE
        WAIT_QOS_MAX_BB_PER_USER
        WAIT_QOS_MAX_BB_MINS_PER_JOB
        WAIT_QOS_MIN_BB
        FAIL_DEADLINE

    enum job_acct_types:
        JOB_START
        JOB_STEP
        JOB_SUSPEND
        JOB_TERMINATED

    enum connection_type:
        SELECT_MESH
        SELECT_TORUS
        SELECT_NAV
        SELECT_SMALL
        SELECT_HTC_S
        SELECT_HTC_D
        SELECT_HTC_V
        SELECT_HTC_L     

    int READY_JOB_FATAL
    int READY_JOB_ERROR
    int NICE_OFFSET

    enum node_use_type:
        SELECT_COPROCESSOR_MODE
        SELECT_VIRTUAL_NODE_MODE
        SELECT_NAV_MODE 

    enum select_jobdata_type:
        SELECT_JOBDATA_GEOMETRY
        SELECT_JOBDATA_ROTATE
        SELECT_JOBDATA_CONN_TYPE
        SELECT_JOBDATA_BLOCK_ID
        SELECT_JOBDATA_NODES
        SELECT_JOBDATA_IONODES
        SELECT_JOBDATA_NODE_CNT
        SELECT_JOBDATA_ALTERED
        SELECT_JOBDATA_BLRTS_IMAGE
        SELECT_JOBDATA_LINUX_IMAGE
        SELECT_JOBDATA_MLOADER_IMAGE
        SELECT_JOBDATA_RAMDISK_IMAGE
        SELECT_JOBDATA_REBOOT
        SELECT_JOBDATA_RESV_ID
        SELECT_JOBDATA_PAGG_ID
        SELECT_JOBDATA_PTR
        SELECT_JOBDATA_BLOCK_PTR
        SELECT_JOBDATA_DIM_CNT
        SELECT_JOBDATA_BLOCK_NODE_CNT
        SELECT_JOBDATA_START_LOC
        SELECT_JOBDATA_USER_NAME
        SELECT_JOBDATA_CONFIRMED
        SELECT_JOBDATA_CLEANING
        SELECT_JOBDATA_NETWORK

    enum select_nodedata_type:
        SELECT_NODEDATA_BITMAP_SIZE
        SELECT_NODEDATA_SUBGRP_SIZE
        SELECT_NODEDATA_SUBCNT
        SELECT_NODEDATA_BITMAP
        SELECT_NODEDATA_STR
        SELECT_NODEDATA_PTR
        SELECT_NODEDATA_EXTRA_INFO
        SELECT_NODEDATA_RACK_MP
        SELECT_NODEDATA_MEM_ALLOC

    enum select_print_mode:
        SELECT_PRINT_HEAD
        SELECT_PRINT_DATA
        SELECT_PRINT_MIXED
        SELECT_PRINT_MIXED_SHORT
        SELECT_PRINT_BG_ID
        SELECT_PRINT_NODES
        SELECT_PRINT_CONNECTION
        SELECT_PRINT_ROTATE
        SELECT_PRINT_GEOMETRY
        SELECT_PRINT_START
        SELECT_PRINT_BLRTS_IMAGE
        SELECT_PRINT_LINUX_IMAGE
        SELECT_PRINT_MLOADER_IMAGE
        SELECT_PRINT_RAMDISK_IMAGE
        SELECT_PRINT_REBOOT
        SELECT_PRINT_RESV_ID
        SELECT_PRINT_START_LOC

    enum select_node_cnt:
        SELECT_GET_NODE_SCALING
        SELECT_GET_NODE_CPU_CNT
        SELECT_GET_MP_CPU_CNT
        SELECT_APPLY_NODE_MIN_OFFSET
        SELECT_APPLY_NODE_MAX_OFFSET
        SELECT_SET_NODE_CNT
        SELECT_SET_MP_CNT 

    enum acct_gather_profile_info:
        ACCT_GATHER_PROFILE_DIR
        ACCT_GATHER_PROFILE_DEFAULT
        ACCT_GATHER_PROFILE_RUNNING

    enum jobacct_data_type:
        JOBACCT_DATA_TOTAL
        JOBACCT_DATA_PIPE
        JOBACCT_DATA_RUSAGE
        JOBACCT_DATA_MAX_VSIZE
        JOBACCT_DATA_MAX_VSIZE_ID
        JOBACCT_DATA_TOT_VSIZE
        JOBACCT_DATA_MAX_RSS
        JOBACCT_DATA_MAX_RSS_ID
        JOBACCT_DATA_TOT_RSS
        JOBACCT_DATA_MAX_PAGES
        JOBACCT_DATA_MAX_PAGES_ID
        JOBACCT_DATA_TOT_PAGES
        JOBACCT_DATA_MIN_CPU
        JOBACCT_DATA_MIN_CPU_ID
        JOBACCT_DATA_TOT_CPU
        JOBACCT_DATA_ACT_CPUFREQ
        JOBACCT_DATA_CONSUMED_ENERGY
        JOBACCT_DATA_MAX_DISK_READ
        JOBACCT_DATA_MAX_DISK_READ_ID
        JOBACCT_DATA_TOT_DISK_READ
        JOBACCT_DATA_MAX_DISK_WRITE
        JOBACCT_DATA_MAX_DISK_WRITE_ID
        JOBACCT_DATA_TOT_DISK_WRITE

    enum acct_energy_type:
        ENERGY_DATA_JOULES_TASK
        ENERGY_DATA_STRUCT
        ENERGY_DATA_RECONFIG
        ENERGY_DATA_PROFILE
        ENERGY_DATA_LAST_POLL
        ENERGY_DATA_SENSOR_CNT
        ENERGY_DATA_NODE_ENERGY
        ENERGY_DATA_NODE_ENERGY_UP

    ctypedef enum task_dist_states_t:
        SLURM_DIST_CYCLIC               = 0x0001
        SLURM_DIST_BLOCK                = 0x0002
        SLURM_DIST_ARBITRARY            = 0x0003
        SLURM_DIST_PLANE                = 0x0004
        SLURM_DIST_CYCLIC_CYCLIC        = 0x0011
        SLURM_DIST_CYCLIC_BLOCK         = 0x0021
        SLURM_DIST_CYCLIC_CFULL         = 0x0031
        SLURM_DIST_BLOCK_CYCLIC         = 0x0012
        SLURM_DIST_BLOCK_BLOCK          = 0x0022
        SLURM_DIST_BLOCK_CFULL          = 0x0032
        SLURM_DIST_CYCLIC_CYCLIC_CYCLIC = 0x0111
        SLURM_DIST_CYCLIC_CYCLIC_BLOCK  = 0x0211
        SLURM_DIST_CYCLIC_CYCLIC_CFULL  = 0x0311
        SLURM_DIST_CYCLIC_BLOCK_CYCLIC  = 0x0121
        SLURM_DIST_CYCLIC_BLOCK_BLOCK   = 0x0221
        SLURM_DIST_CYCLIC_BLOCK_CFULL   = 0x0321
        SLURM_DIST_CYCLIC_CFULL_CYCLIC  = 0x0131
        SLURM_DIST_CYCLIC_CFULL_BLOCK   = 0x0231
        SLURM_DIST_CYCLIC_CFULL_CFULL   = 0x0331
        SLURM_DIST_BLOCK_CYCLIC_CYCLIC  = 0x0112
        SLURM_DIST_BLOCK_CYCLIC_BLOCK   = 0x0212
        SLURM_DIST_BLOCK_CYCLIC_CFULL   = 0x0312
        SLURM_DIST_BLOCK_BLOCK_CYCLIC   = 0x0122
        SLURM_DIST_BLOCK_BLOCK_BLOCK    = 0x0222
        SLURM_DIST_BLOCK_BLOCK_CFULL    = 0x0322
        SLURM_DIST_BLOCK_CFULL_CYCLIC   = 0x0132
        SLURM_DIST_BLOCK_CFULL_BLOCK    = 0x0232
        SLURM_DIST_BLOCK_CFULL_CFULL    = 0x0332

        SLURM_DIST_NODECYCLIC           = 0x0001
        SLURM_DIST_NODEBLOCK            = 0x0002
        SLURM_DIST_SOCKCYCLIC           = 0x0010
        SLURM_DIST_SOCKBLOCK            = 0x0020
        SLURM_DIST_SOCKCFULL            = 0x0030
        SLURM_DIST_CORECYCLIC           = 0x0100
        SLURM_DIST_COREBLOCK            = 0x0200
        SLURM_DIST_CORECFULL            = 0x0300

        SLURM_DIST_NO_LLLP              = 0x1000
        SLURM_DIST_UNKNOWN              = 0x2000

    ctypedef enum cpu_bind_type_t:
        CPU_BIND_VERBOSE    = 0x0001
        CPU_BIND_TO_THREADS = 0x0002
        CPU_BIND_TO_CORES   = 0x0004
        CPU_BIND_TO_SOCKETS = 0x0008
        CPU_BIND_TO_LDOMS   = 0x0010
        CPU_BIND_TO_BOARDS  = 0x1000
        CPU_BIND_NONE       = 0x0020
        CPU_BIND_RANK       = 0x0040
        CPU_BIND_MAP        = 0x0080
        CPU_BIND_MASK       = 0x0100
        CPU_BIND_LDRANK     = 0x0200
        CPU_BIND_LDMAP      = 0x0400
        CPU_BIND_LDMASK     = 0x0800

        CPU_BIND_ONE_THREAD_PER_CORE = 0x2000

        CPU_BIND_CPUSETS   = 0x8000

        CPU_AUTO_BIND_TO_THREADS = 0x04000
        CPU_AUTO_BIND_TO_CORES   = 0x10000
        CPU_AUTO_BIND_TO_SOCKETS = 0x20000

    ctypedef enum mem_bind_type_t:
        ACCEL_BIND_VERBOSE         = 0x01
        ACCEL_BIND_CLOSEST_GPU     = 0x02
        ACCEL_BIND_CLOSEST_MIC     = 0x04
        ACCEL_BIND_CLOSEST_NIC     = 0x08

    ctypedef enum accel_bind_type_t:
        ACCEL_BIND_VERBOSE         = 0x01
        ACCEL_BIND_CLOSEST_GPU     = 0x02
        ACCEL_BIND_CLOSEST_MIC     = 0x04
        ACCEL_BIND_CLOSEST_NIC     = 0x08

    cdef enum node_states:
        NODE_STATE_UNKNOWN
        NODE_STATE_DOWN
        NODE_STATE_IDLE
        NODE_STATE_ALLOCATED
        NODE_STATE_ERROR
        NODE_STATE_MIXED
        NODE_STATE_FUTURE
        NODE_STATE_END

    int OPEN_MODE_APPEND
    int OPEN_MODE_TRUNCATE
    int SLURM_SSL_SIGNATURE_LENGTH

    int SHOW_ALL
    int SHOW_DETAIL
    int SHOW_DETAIL2
    int SHOW_MIXED

    enum ctx_keys:
        SLURM_STEP_CTX_STEPID
        SLURM_STEP_CTX_TASKS
        SLURM_STEP_CTX_TID
        SLURM_STEP_CTX_RESP
        SLURM_STEP_CTX_CRED
        SLURM_STEP_CTX_SWITCH_JOB
        SLURM_STEP_CTX_NUM_HOSTS
        SLURM_STEP_CTX_HOST
        SLURM_STEP_CTX_JOBID
        SLURM_STEP_CTX_USER_MANAGED_SOCKETS

    long int MEM_PER_CPU
    int SHARED_FORCE

    # PROTOCOL DATA STRUCTURE DEFINITIONS
    ctypedef struct dynamic_plugin_data_t:
        void     *data
        uint32_t plugin_id

    ctypedef struct acct_gather_energy_t:
        uint64_t base_consumed_energy
        uint32_t base_watts
        uint64_t consumed_energy
        uint32_t current_watts
        uint64_t previous_consumed_energy
        time_t   poll_time

    ctypedef struct ext_sensors_data_t:
        uint64_t consumed_energy
        uint32_t temperature
        time_t energy_update_time
        uint32_t current_watts

    ctypedef struct power_mgmt_data_t:
        uint32_t cap_watts
        uint32_t current_watts
        uint64_t joule_counter
        uint32_t new_cap_watts
        uint32_t max_watts
        uint32_t min_watts
        time_t new_job_time
        uint16_t state
        uint64_t time_usec

    ctypedef struct node_info_t:
        char *arch
        uint16_t boards
        time_t boot_time
        uint16_t cores
        uint16_t core_spec_cnt
        uint32_t cpu_load
        uint32_t free_mem
        uint16_t cpus
        char *cpu_spec_list
        acct_gather_energy_t *energy
        ext_sensors_data_t *ext_sensors
        power_mgmt_data_t *power
        char *features
        char *gres
        char *gres_drain
        char *gres_used
        uint32_t mem_spec_limit
        char *name
        char *node_addr
        char *node_hostname
        uint32_t node_state
        char *os
        uint32_t owner
        uint32_t real_memory
        char *reason
        time_t reason_time
        uint32_t reason_uid
        dynamic_plugin_data_t *select_nodeinfo
        time_t slurmd_start_time
        uint16_t sockets
        uint16_t threads
        uint32_t tmp_disk
        uint32_t weight
        char *tres_fmt_str
        char *version

    ctypedef struct node_info_msg_t:
        time_t last_update
        uint32_t node_scaling
        uint32_t record_count
        node_info_t *node_array

    ctypedef struct update_node_msg_t:
        char *features
        char *gres
        char *node_addr
        char *node_hostname
        char *node_names
        uint32_t node_state
        char *reason
        uint32_t reason_uid
        uint32_t weight

    ctypedef struct job_resources_t:
        pass

    ctypedef struct slurm_job_info_t:
        char *account
        char    *alloc_node
        uint32_t alloc_sid
        void *array_bitmap
        uint32_t array_job_id
        uint32_t array_task_id
        uint32_t array_max_tasks
        char *array_task_str
        uint32_t assoc_id
        uint16_t batch_flag
        char *batch_host
        char *batch_script
        uint32_t bitflags
        uint16_t boards_per_node
        char *burst_buffer
        char *command
        char *comment
        uint16_t contiguous
        uint16_t core_spec
        uint16_t cores_per_socket
        double billable_tres
        uint16_t cpus_per_task
        uint32_t cpu_freq_min
        uint32_t cpu_freq_max
        uint32_t cpu_freq_gov
        char *dependency
        uint32_t derived_ec
        time_t eligible_time
        time_t end_time
        char *exc_nodes
        int32_t *exc_node_inx
        uint32_t exit_code
        char *features
        char *gres
        uint32_t group_id
        uint32_t job_id
        job_resources_t *job_resrcs
        uint32_t job_state
        char *licenses
        uint32_t max_cpus
        uint32_t max_nodes
        char *name
        char *network
        char *nodes
        uint16_t nice
        int32_t *node_inx
        uint16_t ntasks_per_core
        uint16_t ntasks_per_node
        uint16_t ntasks_per_socket
        uint16_t ntasks_per_board
        uint32_t num_nodes
        uint32_t num_cpus
        char *partition
        uint32_t pn_min_memory
        uint16_t pn_min_cpus
        uint32_t pn_min_tmp_disk
        uint8_t power_flags
        time_t preempt_time
        time_t pre_sus_time
        uint32_t priority
        uint32_t profile
        char *qos
        uint8_t reboot
        char *req_nodes
        int32_t *req_node_inx
        uint32_t req_switch
        uint16_t requeue
        time_t resize_time
        uint16_t restart_cnt
        char *resv_name
        char *sched_nodes
        dynamic_plugin_data_t *select_jobinfo
        uint16_t shared
        uint16_t show_flags
        uint8_t sicp_mode
        uint16_t sockets_per_board
        uint16_t sockets_per_node
        time_t start_time
        char *state_desc
        uint16_t state_reason
        char *std_err
        char *std_in
        char *std_out
        time_t submit_time
        time_t suspend_time
        uint32_t time_limit
        uint32_t time_min
        uint16_t threads_per_core
        char *tres_req_str
        char *tres_alloc_str
        uint32_t user_id
        uint32_t wait4switch
        char *wckey
        char *work_dir

    ctypedef slurm_job_info_t job_info_t

    ctypedef struct job_info_msg_t:
        time_t last_update
        uint32_t record_count
        slurm_job_info_t *job_array

    ctypedef struct job_desc_msg_t:
        pass

    int STAT_COMMAND_RESET
    int STAT_COMMAND_GET

    ctypedef struct stats_info_request_msg_t:
        uint16_t command_id

    ctypedef struct stats_info_response_msg_t:
        uint32_t parts_packed
        time_t req_time
        time_t req_time_start
        uint32_t server_thread_count
        uint32_t agent_queue_size

        uint32_t schedule_cycle_max
        uint32_t schedule_cycle_last
        uint32_t schedule_cycle_sum
        uint32_t schedule_cycle_counter
        uint32_t schedule_cycle_depth
        uint32_t schedule_queue_len

        uint32_t jobs_submitted
        uint32_t jobs_started
        uint32_t jobs_completed
        uint32_t jobs_canceled
        uint32_t jobs_failed

        uint32_t bf_backfilled_jobs
        uint32_t bf_last_backfilled_jobs
        uint32_t bf_cycle_counter
        uint64_t bf_cycle_sum
        uint32_t bf_cycle_last
        uint32_t bf_cycle_max
        uint32_t bf_last_depth
        uint32_t bf_last_depth_try
        uint32_t bf_depth_sum
        uint32_t bf_depth_try_sum
        uint32_t bf_queue_len
        uint32_t bf_queue_len_sum
        time_t   bf_when_last_cycle
        uint32_t bf_active

        uint32_t rpc_type_size
        uint16_t *rpc_type_id
        uint32_t *rpc_type_cnt
        uint64_t *rpc_type_time

        uint32_t rpc_user_size
        uint32_t *rpc_user_id
        uint32_t *rpc_user_cnt
        uint64_t *rpc_user_time


    # SLURM NODE CONFIGURATION READ/PRINT/UPDATE FUNCTIONS
    int slurm_load_node(time_t update_time,
                        node_info_msg_t **resp,
                        uint16_t show_flags)

    int slurm_load_node_single(node_info_msg_t **resp,
                               char *node_name,
                               uint16_t show_flags)

    int slurm_get_node_energy(char *host, uint16_t delta,
                              uint16_t *sensors_cnt,
                              acct_gather_energy_t **energy)

    void slurm_free_node_info_msg (node_info_msg_t *node_info_ptr)
    void slurm_init_update_node_msg(update_node_msg_t * update_node_msg)
    int slurm_update_node(update_node_msg_t * node_msg)


    # SLURM JOB CONTROL CONFIGURATION READ/PRINT/UPDATE FUNCTIONS
    void slurm_free_job_info_msg (job_info_msg_t * job_buffer_ptr)
    int slurm_get_end_time (uint32_t jobid, time_t *end_time_ptr)
    void slurm_get_job_stderr (char *buf, int buf_size, job_info_t *job_ptr)
    void slurm_get_job_stdin (char *buf, int buf_size, job_info_t *job_ptr)
    void slurm_get_job_stdout (char *buf, int buf_size, job_info_t *job_ptr)
    long slurm_get_rem_time (uint32_t jobid)
    int slurm_job_node_ready (uint32_t job_id)

    int slurm_load_job (job_info_msg_t **resp,
                        uint32_t jobid,
                        uint16_t show_flags)

    int slurm_load_job_user (job_info_msg_t **job_info_msg_pptr,
                             uint32_t user_id,
                             uint16_t show_flags)

    int slurm_load_jobs (time_t update_time,
                         job_info_msg_t **job_info_msg_pptr,
                         uint16_t show_flags)

    int slurm_notify_job (uint32_t job_id, char *message)
    int slurm_pid2jobid (int job_pid, uint32_t * job_id_ptr)
    int slurm_update_job (job_desc_msg_t * job_msg)
    uint32_t slurm_xlate_job_id (char *job_id_str)


    # SLURM CONTROL CONFIGURATION READ/PRINT/UPDATE FUNCTIONS
    long slurm_api_version()
    int slurm_load_ctl_conf (time_t update_time,
                             slurm_ctl_conf_t **slurm_ctl_conf_ptr)

    void slurm_free_ctl_conf (slurm_ctl_conf_t* slurm_ctl_conf_ptr)
    void slurm_print_ctl_conf (FILE * out,
                               slurm_ctl_conf_t* slurm_ctl_conf_ptr)

    void slurm_write_ctl_conf (slurm_ctl_conf_t* slurm_ctl_conf_ptr,
                               node_info_msg_t* node_info_ptr,
                               partition_info_msg_t* part_info_ptr)

    void *slurm_ctl_conf_2_key_pairs (slurm_ctl_conf_t* slurm_ctl_conf_ptr)
    void slurm_print_key_pairs (FILE *out, void *key_pairs, char *title)
    int slurm_load_slurmd_status (slurmd_status_t **slurmd_status_ptr)
    void slurm_free_slurmd_status (slurmd_status_t* slurmd_status_ptr)
    void slurm_print_slurmd_status (FILE* out,
                                    slurmd_status_t * slurmd_status_ptr)

    #void slurm_init_update_step_msg (step_update_request_msg_t * step_msg)
    int slurm_get_statistics (stats_info_response_msg_t **buf,
                              stats_info_request_msg_t *req)

    int slurm_reset_statistics (stats_info_request_msg_t *req)

    # SLURM SELECT READ/PRINT/UPDATE FUNCTIONS
    int slurm_get_select_jobinfo (dynamic_plugin_data_t *jobinfo,
                                  select_jobdata_type data_type,
                                  void *data)

    int slurm_get_select_nodeinfo (dynamic_plugin_data_t *nodeinfo,
                                   select_nodedata_type data_type,
                                   node_states state,
                                   void *data)

    ctypedef struct partition_info_msg_t:
        time_t last_update
        uint32_t record_count
        partition_info_t *partition_array

    ctypedef struct partition_info_t:
        char *allow_alloc_nodes
        char *allow_accounts
        char *allow_groups
        char *allow_qos
        char *alternate
        char *billing_weights_str
        uint16_t cr_type
        uint32_t def_mem_per_cpu
        uint32_t default_time
        char *deny_accounts
        char *deny_qos
        uint16_t flags
        uint32_t grace_time
        uint32_t max_cpus_per_node
        uint32_t max_mem_per_cpu
        uint32_t max_nodes
        uint16_t max_share
        uint32_t max_time
        uint32_t min_nodes
        char *name
        int32_t *node_inx
        char *nodes
        uint16_t preempt_mode
        uint16_t priority
        char *qos_char
        uint16_t state_up
        uint32_t total_cpus
        uint32_t total_nodes
        char    *tres_fmt_str

    ctypedef struct slurm_ctl_conf_t:
        time_t last_update
        char *accounting_storage_tres
        uint16_t accounting_storage_enforce
        char *accounting_storage_backup_host
        char *accounting_storage_host
        char *accounting_storage_loc
        char *accounting_storage_pass
        uint32_t accounting_storage_port
        char *accounting_storage_type
        char *accounting_storage_user
        uint16_t acctng_store_job_comment
        void *acct_gather_conf
        char *acct_gather_energy_type
        char *acct_gather_profile_type
        char *acct_gather_infiniband_type
        char *acct_gather_filesystem_type
        uint16_t acct_gather_node_freq
        char *authinfo
        char *authtype
        char *backup_addr
        char *backup_controller
        uint16_t batch_start_timeout
        char *bb_type
        time_t boot_time
        char *checkpoint_type
        char *chos_loc
        char *core_spec_plugin
        char *cluster_name
        uint16_t complete_wait
        char *control_addr
        char *control_machine
        uint32_t cpu_freq_def
        uint32_t cpu_freq_govs
        char *crypto_type
        uint64_t debug_flags
        uint32_t def_mem_per_cpu
        uint16_t disable_root_jobs
        uint16_t eio_timeout
        uint16_t enforce_part_limits
        char *epilog
        uint32_t epilog_msg_time
        char *epilog_slurmctld
        char *ext_sensors_type
        uint16_t ext_sensors_freq
        void *ext_sensors_conf
        uint16_t fast_schedule
        uint32_t first_job_id
        uint16_t fs_dampening_factor
        uint16_t get_env_timeout
        char * gres_plugins
        uint16_t group_info
        uint32_t hash_val
        uint16_t health_check_interval
        uint16_t health_check_node_state
        char * health_check_program
        uint16_t inactive_limit
        char *job_acct_gather_freq
        char *job_acct_gather_type
        char *job_acct_gather_params
        char *job_ckpt_dir
        char *job_comp_host
        char *job_comp_loc
        char *job_comp_pass
        uint32_t job_comp_port
        char *job_comp_type
        char *job_comp_user
        char *job_container_plugin
        char *job_credential_private_key
        char *job_credential_public_certificate
        uint16_t job_file_append
        uint16_t job_requeue
        char *job_submit_plugins
        uint16_t keep_alive_time
        uint16_t kill_on_bad_exit
        uint16_t kill_wait
        char *launch_params
        char *launch_type
        char *layouts
        char *licenses
        char *licenses_used
        uint16_t log_fmt
        char *mail_prog
        uint32_t max_array_sz
        uint32_t max_job_cnt
        uint32_t max_job_id
        uint32_t max_mem_per_cpu
        uint32_t max_step_cnt
        uint16_t max_tasks_per_node
        uint16_t mem_limit_enforce
        uint32_t min_job_age
        char *mpi_default
        char *mpi_params
        char *msg_aggr_params
        uint16_t msg_timeout
        uint32_t next_job_id
        char *node_prefix
        uint16_t over_time_limit
        char *plugindir
        char *plugstack
        char *power_parameters
        char *power_plugin
        uint16_t preempt_mode
        char *preempt_type
        uint32_t priority_decay_hl
        uint32_t priority_calc_period
        uint16_t priority_favor_small
        uint16_t priority_flags
        uint32_t priority_max_age
        char *priority_params
        uint16_t priority_reset_period
        char *priority_type
        uint32_t priority_weight_age
        uint32_t priority_weight_fs
        uint32_t priority_weight_js
        uint32_t priority_weight_part
        uint32_t priority_weight_qos
        char    *priority_weight_tres
        uint16_t private_data
        char *proctrack_type
        char *prolog
        uint16_t prolog_epilog_timeout
        char *prolog_slurmctld
        uint16_t propagate_prio_process
        uint16_t prolog_flags
        char *propagate_rlimits
        char *propagate_rlimits_except
        char *reboot_program
        uint16_t reconfig_flags
        char *requeue_exit
        char *requeue_exit_hold
        char *resume_program
        uint16_t resume_rate
        uint16_t resume_timeout
        char *resv_epilog
        uint16_t resv_over_run
        char *resv_prolog
        uint16_t ret2service
        char *route_plugin
        char *salloc_default_command
        char *sched_logfile
        uint16_t sched_log_level
        char *sched_params
        uint16_t sched_time_slice
        char *schedtype
        uint16_t schedport
        uint16_t schedrootfltr
        char *select_type
        void *select_conf_key_pairs
        uint16_t select_type_param
        char *slurm_conf
        uint32_t slurm_user_id
        char *slurm_user_name
        uint32_t slurmd_user_id
        char *slurmd_user_name
        uint16_t slurmctld_debug
        char *slurmctld_logfile
        char *slurmctld_pidfile
        char *slurmctld_plugstack
        uint32_t slurmctld_port
        uint16_t slurmctld_port_count
        uint16_t slurmctld_timeout
        uint16_t slurmd_debug
        char *slurmd_logfile
        char *slurmd_pidfile
        char *slurmd_plugstack
        uint32_t slurmd_port
        char *slurmd_spooldir
        uint16_t slurmd_timeout
        char *srun_epilog
        uint16_t *srun_port_range
        char *srun_prolog
        char *state_save_location
        char *suspend_exc_nodes
        char *suspend_exc_parts
        char *suspend_program
        uint16_t suspend_rate
        uint32_t suspend_time
        uint16_t suspend_timeout
        char *switch_type
        char *task_epilog
        char *task_plugin
        uint32_t task_plugin_param
        char *task_prolog
        char *tmp_fs
        char *topology_param
        char *topology_plugin
        uint16_t track_wckey
        uint16_t tree_width
        char *unkillable_program
        uint16_t unkillable_timeout
        uint16_t use_pam
        uint16_t use_spec_resources
        char *version
        uint16_t vsize_factor
        uint16_t wait_time
        uint16_t z_16
        uint32_t z_32
        char *z_char

    ctypedef struct slurmd_status_t:
        time_t booted
        time_t last_slurmctld_msg
        uint16_t slurmd_debug
        uint16_t actual_cpus
        uint16_t actual_boards
        uint16_t actual_sockets
        uint16_t actual_cores
        uint16_t actual_threads
        uint32_t actual_real_mem
        uint32_t actual_tmp_disk
        uint32_t pid
        char *hostname
        char *slurmd_logfile
        char *step_list
        char *version

#
# Declarations from slurm_errno.h
#

cdef extern from "slurm/slurm_errno.h" nogil:
    int SLURM_SUCCESS
    int SLURM_ERROR
    int SLURM_FAILURE

    int SLURM_SOCKET_ERROR
    int SLURM_PROTOCOL_SUCCESS
    int SLURM_PROTOCOL_ERROR

    enum:
        SLURM_UNEXPECTED_MSG_ERROR = 1000
        SLURM_COMMUNICATIONS_CONNECTION_ERROR
        SLURM_COMMUNICATIONS_SEND_ERROR
        SLURM_COMMUNICATIONS_RECEIVE_ERROR
        SLURM_COMMUNICATIONS_SHUTDOWN_ERROR
        SLURM_PROTOCOL_VERSION_ERROR
        SLURM_PROTOCOL_IO_STREAM_VERSION_ERROR
        SLURM_PROTOCOL_AUTHENTICATION_ERROR
        SLURM_PROTOCOL_INSANE_MSG_LENGTH
        SLURM_MPI_PLUGIN_NAME_INVALID
        SLURM_MPI_PLUGIN_PRELAUNCH_SETUP_FAILED
        SLURM_PLUGIN_NAME_INVALID
        SLURM_UNKNOWN_FORWARD_ADDR

        SLURMCTLD_COMMUNICATIONS_CONNECTION_ERROR = 1800
        SLURMCTLD_COMMUNICATIONS_SEND_ERROR
        SLURMCTLD_COMMUNICATIONS_RECEIVE_ERROR
        SLURMCTLD_COMMUNICATIONS_SHUTDOWN_ERROR

        SLURM_NO_CHANGE_IN_DATA = 1900

        SLURM_PROTOCOL_SOCKET_IMPL_ZERO_RECV_LENGTH = 5000
        SLURM_PROTOCOL_SOCKET_IMPL_NEGATIVE_RECV_LENGTH
        SLURM_PROTOCOL_SOCKET_IMPL_NOT_ALL_DATA_SENT
        ESLURM_PROTOCOL_INCOMPLETE_PACKET
        SLURM_PROTOCOL_SOCKET_IMPL_TIMEOUT
        SLURM_PROTOCOL_SOCKET_ZERO_BYTES_SENT


    char * slurm_strerror (int errnum)
    void slurm_seterrno (int errnum)
    int slurm_get_errno ()
    void slurm_perror (char *msg)


#
# Declarations outside of slurm.h
#

cdef extern void slurm_free_stats_response_msg (stats_info_response_msg_t *msg)
cdef extern void *slurm_xmalloc(size_t, bool, const char *, int, const char *)
cdef extern void slurm_xfree(void **, const char *, int, const char *)
cdef extern char *slurm_node_state_string(uint32_t inx)
cdef extern char *slurm_job_state_string(uint32_t inx)
cdef extern char *slurm_job_reason_string(job_state_reason inx)

#cdef inline void* xmalloc(size_t __sz):
#    return slurm_xmalloc(__sz, True,  __FILE__, __LINE__, __FUNCTION__)
#
#cdef inline xfree (void *__p):
#    return slurm_xfree(<void**>&(__p), __FILE__, __LINE__, __FUNCTION__)

cdef inline IS_NODE_ALLOCATED(node_info_t _X):
    return (_X.node_state & NODE_STATE_BASE) == NODE_STATE_ALLOCATED

cdef inline IS_NODE_COMPLETING(node_info_t _X):
    return (_X.node_state & NODE_STATE_COMPLETING)

#
# Defined job states
#

cdef inline IS_JOB_PENDING(slurm_job_info_t _X):
    return (_X.job_state & JOB_STATE_BASE) == JOB_PENDING

cdef inline IS_JOB_RUNNING(slurm_job_info_t _X):
    return (_X.job_state & JOB_STATE_BASE) == JOB_RUNNING

cdef inline IS_JOB_SUSPENDED(slurm_job_info_t _X):
    return (_X.job_state & JOB_STATE_BASE) == JOB_SUSPENDED

cdef inline IS_JOB_COMPLETE(slurm_job_info_t _X):
    return (_X.job_state & JOB_STATE_BASE) == JOB_COMPLETE

cdef inline IS_JOB_CANCELLED(slurm_job_info_t _X):
    return (_X.job_state & JOB_STATE_BASE) == JOB_CANCELLED

cdef inline IS_JOB_FAILED(slurm_job_info_t _X):
    return (_X.job_state & JOB_STATE_BASE) == JOB_FAILED

cdef inline IS_JOB_TIMEOUT(slurm_job_info_t _X):
    return (_X.job_state & JOB_STATE_BASE) == JOB_TIMEOUT

cdef inline IS_JOB_NODE_FAILED(slurm_job_info_t _X):
    return (_X.job_state & JOB_STATE_BASE) == JOB_NODE_FAIL

#
# Derived job states
#

cdef inline IS_JOB_COMPLETING(job_info_t _X):
    return _X.job_state & JOB_COMPLETING

cdef inline IS_JOB_CONFIGURING(job_info_t _X):
    return _X.job_state & JOB_CONFIGURING

cdef inline IS_JOB_STARTED(job_info_t _X):
    return (_X.job_state & JOB_STATE_BASE) > JOB_PENDING

cdef inline IS_JOB_FINISHED(job_info_t _X):
    return (_X.job_state & JOB_STATE_BASE) > JOB_SUSPENDED

cdef inline IS_JOB_COMPLETED(job_info_t _X):
    return (IS_JOB_FINISHED(_X) and (_X.job_state & JOB_COMPLETING) == 0)

cdef inline IS_JOB_RESIZING(job_info_t _X):
    return _X.job_state & JOB_RESIZING

cdef inline IS_JOB_REQUEUED(job_info_t _X):
    return _X.job_state & JOB_REQUEUE

cdef inline IS_JOB_UPDATE_DB(job_info_t _X):
    return _X.job_state & JOB_UPDATE_DB

#
# slurm cython module c-level declarations
#

cdef class Node:
    cdef:
        node_info_msg_t *_node_info_ptr
        update_node_msg_t update_node_msg
        uint16_t _show_flags
        dict _node_dict

    cpdef find_id(self, char *_node)
    cpdef ids(self)
    cpdef get_node(self, char *_node=?)
    cpdef get_nodes(self)
    cpdef int update_node(self, dict _update_dict)

cdef class Job:
    cdef:
        job_info_msg_t *_job_info_ptr
        uint16_t _show_flags
        dict _job_dict

    cpdef get_job(self, uint32_t jobid)
    cpdef get_jobs(self)

cdef class Conf:
    cdef:
        slurm_ctl_conf_t *_conf_info_msg_ptr
        dict _conf_dict

    cpdef get(self)

cdef class Stat:
    cdef:
        stats_info_request_msg_t _req # casted to pointer type later
        stats_info_response_msg_t *_buf
        dict _stat_dict

    cpdef get_stats(self)
    cpdef reset_stats(self)
    cpdef __rpc_num2string(self, uint16_t opcode)
