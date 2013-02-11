args = { ... }
name = args[1]

print('Downloading '..name..' ...')

local f, h
f = http.get('http://jrm.homenet.org/ComputerCraft/'..name..'.lua.txt')
h = fs.open(shell.resolve(name), 'w')
h.write(f.readAll())
h.close()