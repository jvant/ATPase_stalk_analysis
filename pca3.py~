#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns; sns.set()
from sklearn.decomposition import PCA
from scipy.constants import *

# rng = np.random.RandomState(1)
# X = np.dot(rng.rand(2, 2), rng.randn(2, 200)).T
# plt.scatter(X[:, 0], X[:, 1])
# plt.axis('equal');
# plt.show()
# print(type(X))
# print(X)

X = np.array([np.loadtxt('Pta2.dat'), np.loadtxt('Ptb2.dat'), np.loadtxt('Ptc2.dat')])
X = X.T
print(type(X))
print(X)

#exit()
#pca = PCA(n_components=3)
#pca.fit(X)

pca = PCA(n_components=1)
pca.fit(X)
print(pca.components_)

print("Explained var ratio",pca.explained_variance_ratio_)

X_pca = pca.transform(X)
print("original shape:   ", X.shape)
print("transformed shape:", X_pca.shape)

X_new = pca.inverse_transform(X_pca)
#plt.hist(X_pca)
plt.hist(X[:,[0]])
plt.show()
plt.scatter(X[:, 0], X[:, 1], alpha=0.2)
plt.scatter(X_new[:, 0], X_new[:, 1], alpha=0.8)
plt.axis('equal');

np.savetxt('PCAa.dat', X_pca)
print(X_pca)
print("STD of X_pca",np.std(X_pca))
print(X_new)
print("STD of X_new",np.std(X_new))

plt.show()
print("whereami")
def kmodulus(std):
    temp = 300
    return k * temp/pow(std,2) * 10**21 # Gives values in pNnm
print(kmodulus(np.std(X_pca)))
print(kmodulus(np.std(X_new)))

