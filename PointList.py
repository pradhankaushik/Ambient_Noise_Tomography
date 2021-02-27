# Two blank list to store latitude and longitude information of stations
longitude = []
latitude = []
#reading text file having coordinates of stations
ff = open('long_lat.txt','r')
lines = ff.readlines()
for x in lines:
	longitude.append(x.split()[0])
for y in lines:
	latitude.append(y.split()[1])
#converted string values to floating values
for i in range(len(latitude)):
	latitude[i] = float(latitude[i])
for j in range(len(longitude)):
	longitude[j] = float(longitude[j])
#opening a file to write the possible list of unique selection of station pairs
f = open('long_lat.txt','w')
for i in range(len(longitude)):
	for j in range(i+1,len(latitude)):
		print >>f,longitude[i],latitude[i]
		print >>f,longitude[j],latitude[j]
ff.close()
f.close()
