args = { ... }
name = args[1]

print('Downloading '..name..' ...')

local f, h
f = http.get('http://jrm.homenet.org/ComputerCraft/'..name..'.lua')
if not f then
  error('Could not download file '..name..'!')
end
h = fs.open(shell.resolve(name), 'w')
h.write(f.readAll())
h.close()