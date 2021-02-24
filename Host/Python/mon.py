import tether

def dumpMem(adr,n):
    for i in range(n):
        b = tether.Load(adr+i)
        print(adr+i, b)
        
    
