import random
number_of_expriments = 10000
exp1_n = 0
exp1_f = 0
a = b = None
while number_of_expriments != 0:
    a = random.randint(0, 1)
    b = random.randint(0, 1)
    if a == 1:
        number_of_expriments -= 1
        exp1_n += 1
        if b == 1:
            exp1_f += 1

print (exp1_f * 1.0) / exp1_n