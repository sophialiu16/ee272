def block():
	X0 = 2
	Y0 = 3
	X = 4
	Y = 6

	for y0 in range(Y/Y0): 
		for x0 in range(X/X0):
			for y in range(Y0):
				for x in range(X0):
					print(x + y*X + x0*X0 + y0*X*Y0, " ")
block()

