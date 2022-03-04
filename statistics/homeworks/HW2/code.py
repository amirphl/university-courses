import matplotlib.pyplot as plt
import numpy as np

mu, sigma = 0, 1

for n in [10, 100, 1000, 10000]:
    numbers=  np.random.normal(mu, sigma, n)
    print ("\n\n\n n =", n)
    plt.xlim(-10, 10)
    plt.hist(numbers, bins=20, normed=True)
    plt.show()

