eq = 'TTTAAAACCTAATCAAGAACAGATATACAAAGTTCAAAACCTAGTGCAGAACAAAATGTAAATCCTAAAACATAAATCCAAAACAGAGAGGGAAAAGGAGTAGAGAAATTAGCAAGTCAG'

def p_kmer(s,i,k=40):
    a = '*'
    return a*(i-1) + s[i-1:i+39] + (80-i)*a

import random
t = []
for i in xrange(1,100):
    t.append(random.randint(1,80))

for i in sorted(t):
    b = p_kmer(seq,i,40)
    print b
