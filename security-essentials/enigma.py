

m_value = [23,13,24,0,7,15,14,6,25,16,22,1,19,18,5,11,17,2,21,12,20,4,10,9,3,8]


cipher = 'ndgdbhkzxscogmsbstp'
k = 23
counter = 1;

for cr in cipher:
	elem = ord(cr) - 97
	elem -= (k + counter - 1) % 26
	index = -1
	if elem >= 0:
		for i in range(0,len(m_value)):
			if m_value[i] == elem:
				index = i
				break
		print(chr(index + 97) , end = '')
	elem = ord(cr) - 97
	elem += 26
	elem -= (k + counter - 1) % 26
	index = -1
	if elem >= 0:
		for i in range(0,len(m_value)):
			if m_value[i] == elem:
				index = i
				break
		print(chr(index + 97) , end = '')
	elem = ord(cr) - 97
	elem += 52
	elem -= (k + counter - 1) % 26
	index = -1
	if elem >= 0:
		for i in range(0,len(m_value)):
			if m_value[i] == elem:
				index = i
				break
		print(chr(index + 97) , end = '')

	print()
	counter += 1
	