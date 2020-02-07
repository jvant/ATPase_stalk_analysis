#!/python

print('is this working?')
# Load libraries
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn import datasets

# Load the data
digits = datasets.load_digits()
print(type(digits))
digitsa = np.loadtxt('Pta1.dat')
digitsb = np.loadtxt('Ptb1.dat')
digitsc = np.loadtxt('Ptc1.dat')
digits = [digitsa, digitsb, digitsc]
print(digits)

# Standardize the feature matrix
X = StandardScaler().fit_transform(digits.data)

# Create a PCA that will retain 99% of the variance
pca = PCA(n_components=0.99, whiten=True)

# Conduct PCA
X_pca = pca.fit_transform(X)

# Show results
print('Original number of features:', X.shape[1])
print('Reduced number of features:', X_pca.shape[1])

exit()
