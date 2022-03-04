import csv
ifile = open('train.csv', 'rb')
reader = csv.reader(ifile)

spams = 0
first_features = []
second_features = []
rownum = -1
for i in range(1, 59):
    first_features.append(0)
    second_features.append(0)
for row in reader:
    rownum += 1
    if rownum == 0:
        continue
    if row[len(row) - 1] == '1.0':
        spams += 1
        i = 0
        for fe in row:
            first_features[i] += float(fe)
            i += 1
    else:
        j = 0
        for fe in row:
            second_features[j] += float(fe)
            j += 1
# print 'spams : ' + str(spams)
# print 'number of rows : ' + str(rownum)
# print '-----------------------'
prob_spam = (spams * 1.0 )/ rownum
p_spam = []
for element in first_features:
    # print (element) / spams
    p_spam.append((element) / spams)

# print '-----------------------'

p_spam_prime = []
for element in second_features:
    # print (element) / (rownum - spams)
    p_spam_prime.append((element) / (rownum - spams))

# print '-----------------------'

ifile.close()

ifile = open('test.csv', 'rb')
reader = csv.reader(ifile)
output = []
rownum = -1
for row in reader:
    rownum += 1
    if rownum == 0:
        continue

    i = 0
    is_spam = 1.0
    for fe in row:
        if fe == '1.0':
            is_spam *=p_spam[i]
        else:
            is_spam *= (1.0 - p_spam[i])
        i += 1    
    is_spam *= prob_spam

    i = 0
    is_not_spam = 1.0
    for fe in row:
        if fe == '1.0':
            is_not_spam *=p_spam_prime[i]
        else:
            is_not_spam *= (1.0 - p_spam_prime[i])
        i += 1
    is_not_spam *= 1.0 - prob_spam

    if is_spam >= is_not_spam:
        # print str(is_spam) + '   ' + str(is_not_spam) + '    ' + 'spam'
        output.append("1")
    else:
        # print str(is_spam) + '   ' + str(is_not_spam) + '    ' + 'not spam'
        output.append("0")

ifile.close()

ifile = open('SPM_9531014.csv', 'wb')
with ifile:
    writer = csv.writer(ifile)
    writer.writerows(output)
ifile.close()