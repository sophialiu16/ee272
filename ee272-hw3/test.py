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

def block3D():
	C0 = 2
	X0 = 3
	Y0 = 4
	C = 4
	X = 6
	Y = 8

	for y0 in range(Y/Y0):
		for x0 in range(X/X0):
			for c0 in range(C/C0):
				for y in range(Y0):
					for x in range(X0):
						for c in range(C0):
							print(c + x*C + y*C*X + c0*C0 + x0*X0*C + y0*Y0*X*C)
					
block3D()

