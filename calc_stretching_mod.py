#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Feb 10 21:12:50 2019

@author: jvant
"""

import sys
sys.path.insert(0, '/shared/F1-F0_ATPase/')

import Calc_mod03 as Calc
import json 
from scipy import *

with open('stretching_kmods.txt','w') as file:
    file.write(json.dumps(Calc.kmodulus(Calc.grab_std(loadtxt('Dist.dat')))))

