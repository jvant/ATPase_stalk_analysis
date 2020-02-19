#!/usr/bin/env python

############################################################## 
# 
# Author:               John Vant 
# Email:              jvant@asu.edu 
# Affiliation:   ASU Biodesign Institute 
# Date Created:          200207
# 
############################################################## 
# 
# Usage: 
# 
############################################################## 
# 
# Notes: 
# 
############################################################## 

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns; sns.set()
from sklearn.decomposition import PCA
from scipy.constants import *

############################################################## 
# Def Fun
def kmodulus(std):
    temp = 300
    return k * temp/pow(std,2) * 10**21 # Gives values in pNnm

############################################################## 
# Main
outdat = []
for i in range(1,10):
    X = np.array([np.loadtxt('Pta%s.dat' % i),
                  np.loadtxt('Ptb%s.dat' % i),
                  np.loadtxt('Ptc%s.dat' % i)])
    X = X.T
    
    pca = PCA(n_components=1)
    pca.fit(X)
    X_pca = pca.transform(X)
    kmod = kmodulus(np.std(X_pca))
    print("original shape:   ", X.shape)
    print("transformed shape:", X_pca.shape)
    print("Explained var ratio",pca.explained_variance_ratio_)
    print(kmod)
    outdat.append(kmod)
    
np.savetxt('PCA.dat', outdat)
