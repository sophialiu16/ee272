import fileinput


def convertfile(fin, fout):
    f = open(fout, 'w')
    for line in fileinput.input([fin]):
        x = int(line)
        if x < 0: 
            x = (2**32 + x) 
        f.write(format(x, 'x'))
        f.write('\n')

def main():
  convertfile("layer1_gold_ofmap.txt", "layer1_gold_ofmap_.mem")
  
if __name__== "__main__":
  main()
