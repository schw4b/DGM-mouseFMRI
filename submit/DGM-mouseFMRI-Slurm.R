#!/usr/bin/env Rscript

# l:wqibraries and paths ----
library(DGM)
library(testit)
library(data.table)

PATH_TS  = '~/Drive/mouseFMRI'
PATH_RES = '~/Drive/DGM_mouseFMRI'
PATH_PROJ= '~/DGM-mouseFMRI'
INFO     = 'mouseFMRI_Nn18'

COUNT=0

# variables ----
N  = 34
Nn = 18
Nt = 900 # no. of samples

# read subject IDs ----
f = list.files(path=PATH_TS, pattern='*.txt')
assert(length(f) == N)
EIDS = substring(f, 18, 22)

# create a lookup table across subjects and nodes ----
mysubs = sort(rep(EIDS[1:N],Nn))
mynodes = rep(1:Nn,N)
TABLE = cbind(mysubs,mynodes)

# assign task ID ----
l = COUNT + as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID")) # iterator for lookup TABLE that runs multicore

# read data
f = list.files(path=PATH_TS, pattern=sprintf('*%s.txt', TABLE[l,1]))
d = as.matrix(fread(file.path(PATH_TS, f)))
d = d[1:Nt,1:Nn] # cuttoff for subjects with more samples
assert(nrow(d) == Nt)
assert(ncol(d) == Nn)

# mean center time series
d=scaleTs(d)

# calculate networks, will write txt files
if (!file.exists(file.path(PATH_RES,sprintf("%s_%s_node_%03d.txt", TABLE[l,1], INFO, as.numeric(TABLE[l,2]))))) {
   m=node(d, as.numeric(TABLE[l,2]), id=sprintf("%s_%s", TABLE[l,1], INFO),
          path = PATH_RES, method="both")
}

q(save="no")
