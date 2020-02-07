#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Feb 10 17:06:23 2019

This program outputs a data file with the kmodulus values of all 8 sections
of ATPase segname PROG

@author: jvant
"""

import sys
sys.path.insert(0, '/shared/F1-F0_ATPase/')

import Calc_mod03 as Calc
import json 
from scipy import *

with open('torsional_kmods.txt','w') as file:
    file.write(json.dumps(Calc.calc_all_combined_kmodulus((linspace(1,8,8)))))
