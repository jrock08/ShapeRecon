from multiprocessing import Pool;
import time;
import os;
import functools;

class RunCode(object):
    def __init__(self,FUNC,STAGE,NUM_SHARDS):
        self.FUNC = FUNC
        self.NUM_SHARDS = NUM_SHARDS
        self.STAGE = STAGE
    def __call__(self,SHARD_NUM):
        COMMANDSTR = \
        """nice matlab -nodesktop -nosplash -r "try, {func}({stage},{shard_num},{num_shards});, catch err, getReport(err), end, exit" > sharded_text_output/{stage}_{shard_num}.txt""" .format(func = self.FUNC, \
                                                                     stage = self.STAGE, \
                                                                     shard_num = SHARD_NUM, \
                                                                     num_shards = self.NUM_SHARDS)
        print COMMANDSTR
        os.system(COMMANDSTR)

# Spawn multiple threads
NUM_SHARDS = 1;
threads = Pool(NUM_SHARDS)
STAGE = "{'MATCHING','DEFORMATION'}"
threads.map(RunCode("test_sharded",STAGE,NUM_SHARDS),range(1,NUM_SHARDS+1))

NUM_SHARDS = 6;
threads = Pool(NUM_SHARDS)
STAGE = "{'RECONSTRUCTION'}"
threads.map(RunCode("test_sharded",STAGE,NUM_SHARDS),range(1,NUM_SHARDS+1)) 

NUM_SHARDS = 1;
threads = Pool(NUM_SHARDS)
STAGE = "{'METRIC_COMPUTATION','IMAGE_GENERATION'}"
threads.map(RunCode("test_sharded",STAGE,NUM_SHARDS),range(1,NUM_SHARDS+1)) 


        
