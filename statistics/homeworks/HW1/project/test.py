import csv
ifile = open('mytest.csv', 'rb')
reader = csv.reader(ifile)

i = 0
a = []
for row in reader:
    for fe in row:
        i += 1
        print fe

print '     ' + str(i)
