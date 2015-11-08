# Monte Carlo DR results for beam-width errors

# Imported packages
from numpy import *
import sys
# Define Monte Carlo parameters
nant = 1000
sigma = 1e-1
alpha = 1e-2
rho = 9e-3
n=100

#Initialization
nbasl = nant*(nant-1)/2
s = zeros(n, dtype=float)
alpha2 = alpha * alpha
rho2 = rho * rho
rho_0 = 0.0
# Loop over Monte Carlo realization
for mc in range(n):
    # alphai = random.normal(0,sigma,nant) * alpha
    alphai = random.normal(0,sigma,nant) 
    # Iterate over baseline
    ssum = 0.0
    for i in range(nant-1):
        for j in range(i, nant):
            argval = - ((rho - rho_0)/(alphai[i])) ** 2 - ((rho - rho_0)/(alphai[j])) ** 2
            argval += 2 * rho2 / alpha2
            ssum += exp(argval)
    s[mc] = ssum/nbasl
    # print mc, s[mc]

# Print results
print "Mean intensity: ", s.mean()
drmc = 1 / s.std()
drmemo = (sqrt(nant))*(alpha/rho)*(alpha/rho)*(alpha/sigma)
print "Sigma intensity: ", s.std(), ", DR= ", drmc
print "DR_MEMO= ", drmemo, ", DR_ratio (memo/MC) = ", drmemo / drmc
sys.stdout=open("AK_beam_Na%s_sigma%s_fract%s.txt" % (nant,sigma,rho/alpha),'w')
print "Beam-width Errors:"
print "rho =", rho, ", alpha = ", alpha, ", rho/alpha = ", rho/alpha
print "Na =", nant, ", sigma = ", sigma, ", num mc = ",n
print "Mean intensity: ", s.mean()
print "Sigma intensity: ", s.std()
print "DR_MC = ", drmc
print "DR_MEMO= ", drmemo, ", DR_ratio (memo/MC) = ", drmemo / drmc

"""
EXAMPLE OUTPUT:

bash-3.2$ python AK_mc_dr_beam_sigma1_Na1000_rho4.py &
[1] 15090
bash-3.2$ 
bash-3.2$ Mean intensity:  3.93489642428
Sigma intensity:  0.0656971112256 , DR=  15.2213694232
DR_MEMO=  3.90404649404 , DR_ratio (memo/MC) =  0.256484576749

[1]+  Done                    python AK_mc_dr_beam_sigma1_Na1000_rho4.py
"""



