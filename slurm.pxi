# DEFINITIONS FOR INPUT VALUES
SLURM_VERSION_NUMBER = 0x0f0801
INFINITE   = 0xffffffff
INFINITE64 = 0xffffffffffffffff
NO_VAL     = 0xfffffffe
NO_VAL64   = 0xfffffffffffffffe
SLURM_BATCH_SCRIPT = 0xfffffffe
SLURM_EXTERN_CONT  = 0xffffffff

JOB_STATE_BASE  = 0x000000ff
JOB_STATE_FLAGS = 0xffffff00

JOB_LAUNCH_FAILED = 0x00000100
JOB_UPDATE_DB     = 0x00000200
JOB_REQUEUE       = 0x00000400
JOB_REQUEUE_HOLD  = 0x00000800
JOB_SPECIAL_EXIT  = 0x00001000
JOB_RESIZING      = 0x00002000
JOB_CONFIGURING   = 0x00004000
JOB_COMPLETING    = 0x00008000
JOB_STOPPED       = 0x00010000

READY_NODE_STATE = 0x01
READY_JOB_STATE  = 0x02

MAIL_JOB_BEGIN     = 0x0001
MAIL_JOB_END       = 0x0002
MAIL_JOB_FAIL      = 0x0004
MAIL_JOB_REQUEUE   = 0x0008
MAIL_JOB_TIME100   = 0x0010
MAIL_JOB_TIME90    = 0x0020
MAIL_JOB_TIME80    = 0x0040
MAIL_JOB_TIME50    = 0x0080
MAIL_JOB_STAGE_OUT = 0x0100

PARTITION_SUBMIT   = 0x01
PARTITION_SCHED    = 0x02 
PARTITION_INACTIVE = 0x00

ACCT_GATHER_PROFILE_NOT_SET = 0x00000000
ACCT_GATHER_PROFILE_NONE    = 0x00000001
ACCT_GATHER_PROFILE_ENERGY  = 0x00000002
ACCT_GATHER_PROFILE_TASK    = 0x00000004
ACCT_GATHER_PROFILE_LUSTRE  = 0x00000008
ACCT_GATHER_PROFILE_NETWORK = 0x00000010
ACCT_GATHER_PROFILE_ALL     = 0xffffffff

SLURM_DIST_STATE_BASE    = 0x00FFFF
SLURM_DIST_STATE_FLAGS   = 0xFF0000
SLURM_DIST_PACK_NODES    = 0x800000
SLURM_DIST_NO_PACK_NODES = 0x400000

SLURM_DIST_NODEMASK     = 0xF00F
SLURM_DIST_SOCKMASK     = 0xF0F0
SLURM_DIST_COREMASK     = 0xFF00
SLURM_DIST_NODESOCKMASK = 0xF0FF

CPU_FREQ_RANGE_FLAG       = 0x80000000
CPU_FREQ_LOW              = 0x80000001
CPU_FREQ_MEDIUM           = 0x80000002
CPU_FREQ_HIGH             = 0x80000003
CPU_FREQ_HIGHM1           = 0x80000004
CPU_FREQ_CONSERVATIVE     = 0x88000000
CPU_FREQ_ONDEMAND         = 0x84000000
CPU_FREQ_PERFORMANCE      = 0x82000000
CPU_FREQ_POWERSAVE        = 0x81000000
CPU_FREQ_USERSPACE        = 0x80800000
CPU_FREQ_GOV_MASK         = 0x8ff00000
CPU_FREQ_PERFORMANCE_OLD  = 0x80000005
CPU_FREQ_POWERSAVE_OLD    = 0x80000006
CPU_FREQ_USERSPACE_OLD    = 0x80000007
CPU_FREQ_ONDEMAND_OLD     = 0x80000008
CPU_FREQ_CONSERVATIVE_OLD = 0x80000009

NODE_STATE_BASE       = 0x000f
NODE_STATE_FLAGS      = 0xfff0
NODE_STATE_NET        = 0x0010
NODE_STATE_RES        = 0x0020
NODE_STATE_UNDRAIN    = 0x0040
NODE_STATE_CLOUD      = 0x0080
NODE_RESUME           = 0x0100
NODE_STATE_DRAIN      = 0x0200
NODE_STATE_COMPLETING = 0x0400
NODE_STATE_NO_RESPOND = 0x0800
NODE_STATE_POWER_SAVE = 0x1000
NODE_STATE_FAIL       = 0x2000
NODE_STATE_POWER_UP   = 0x4000
NODE_STATE_MAINT      = 0x8000

SHOW_ALL     = 0x0001
SHOW_DETAIL  = 0x0002
SHOW_DETAIL2 = 0x0004
SHOW_MIXED   = 0x0008

STAT_COMMAND_RESET = 0x0000
STAT_COMMAND_GET   = 0x0001
