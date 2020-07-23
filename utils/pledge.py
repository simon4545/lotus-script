#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import os
import subprocess as sp
import re
import logging

LOG_FORMAT = "%(asctime)s %(levelname)s %(message)s"
DATE_FORMAT = "%m-%d-%Y %H:%M:%S"

logging.basicConfig(filename='pledge.log', level=logging.NOTSET, format=LOG_FORMAT, datefmt=DATE_FORMAT)

os.environ["LOTUS_PATH"] = "/data2/lotus-calibration/daemon"
os.environ["LOTUS_STORAGE_PATH"] = "/data2/lotus-calibration/miner"
os.environ["WORKER_PATH"] = "/data2/lotus-calibration/worker"
os.environ["FIL_PROOFS_PARAMETER_CACHE"] = "/data2/proofs/v27"

if __name__ == "__main__":
    # worker_list = sp.Popen(["./lotus-miner", "workers", "list"], stdout=sp.PIPE, stderr=sp.PIPE).stdout
    # worker_list = sp.run(["./lotus-miner", "workers", "list"], capture_output=True)
    worker_list = open("./test.log", 'r', encoding='utf-8',
               errors='ignore')
    # try:
    #     worker_list = sp.run("./lotus-miner workers list", capture_output=True)
    # except:
    #     logging.error("Your miner is already exploded!")

    # for line in worker_list.stdout.readlines():
    #     print(line)

    worker_text = ""
    for line in worker_list.readlines():
        worker_text = worker_text + line.strip()

    worker_info_list = re.finditer(r'Worker ([\w\W]*?) core', worker_text, re.MULTILINE)

    for info in worker_info_list:
        # Worker 0 is miner, do noting.
        if (info.group(1)[0:1] == "0"):
            continue

        # Check CPU usage
        if (info.group(1)[-1] == "0"):
            logging.info("Make a sector.")
            # worker_list = sp.Popen(["./lotus-miner", "sectors", "pledge"])
        else:
            logging.info("Worker {worker_id} has {core_num} core(s) in use.".format(worker_id = info.group(1)[0:1], core_num = info.group(1)[-1]))