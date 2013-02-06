args = { ... }
name = args[1]
print('running '..name..' ...')
f = http.get('http://jrm.homenet.org/ComputerCraft/'..name..'.lua.txt')
loadstring(f.readAll())()
