args = { ... }
name = args[1]
print('running '..name..' ...')
f = http.get('http://jrm.homenet.org/ComputerCraft/'..name..'.lua')
if not f then
  error('Could not download file '..name..'!')
end
loadstring(f.readAll())()
