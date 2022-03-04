import pandas as pd
import numpy as np

train_df = pd.read_csv('train.csv')
test_df = pd.read_csv('test.csv')
correct_answer_df = pd.read_csv("answers.csv", header=None)
train_arr = np.array(train_df)
test_arr = np.array(test_df)

data_size = len(train_arr)
number_of_spam = 0
for i in range(0, data_size):
    if train_arr[i][-1] == 1:
        number_of_spam += 1
number_of_not_spam = data_size - number_of_spam
spam_probability = number_of_spam / data_size
not_spam_probability = 1 - spam_probability
######
ftr = len(train_arr[0])-1

counter = np.zeros((2, ftr))
for i in range(0, data_size):
    for j in range(0, ftr):
        if train_arr[i][j] == 1:
            tmp = int(train_arr[i][-1])
            counter[tmp][j] += 1

p = np.zeros((2, ftr))
for i in range(0,2):
    for j in range(0,ftr):
        if i == 0:
            p[i][j] = counter[i][j]/number_of_not_spam
        else:
            p[i][j] = counter[i][j] / number_of_spam
tmp = pd.DataFrame(p)
#####
n = len(test_arr)
predict = np.zeros(n)
for i in range(0, n):
    spam_prime = spam_probability
    for j in range(0, ftr):
        if test_arr[i][j] == 1:
            spam_prime *= p[1][j]
        else:
            spam_prime *= (1 - p[1][j])
    spm = spam_prime
    not_spam_prime = not_spam_probability
    for j in range(0, ftr):
        if test_arr[i][j] == 1:
            not_spam_prime *= p[0][j]
        else:
            not_spam_prime *= (1 - p[0][j])
    nt_spm = not_spam_prime
    if spm > nt_spm:
        predict[i]=1
    else:
        predict[i]=0
output = pd.DataFrame(predict)
output.to_csv("SPM_9731020.csv", index=False, header=False)
compare = pd.concat([output, correct_answer_df], axis=1)
diff = np.asarray(output) == np.asarray(correct_answer_df)
tmp = pd.DataFrame(compare)
accuracy = np.sum(diff)/len(diff)
print ("Accuracy:", accuracy)