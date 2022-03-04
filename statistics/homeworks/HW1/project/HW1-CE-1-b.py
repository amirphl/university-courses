import random
number_of_expriments = 10000
exp2_n = 0
exp2_f = 0
a = b = a_prime = b_prime = None
while number_of_expriments != 0:
    a = random.randint(0, 1)
    b = random.randint(0, 1)
    c = random.randint(0, 1)
    if c == 1:
        a_prime = a
        b_prime = b
    elif c == 0:
        a_prime = b
        b_prime = a

    if a_prime == 1:
        number_of_expriments -= 1
        exp2_n += 1
        if b_prime == 1:
            exp2_f += 1

print (exp2_f * 1.0) / exp2_n
