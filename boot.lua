print("Bootstrapping Jeremy's code...")
if fs.exists('/jeremy') and fs.isDir('/jeremy') then
  print('removing existing install')
  fs.delete('/jeremy')
end

fs.makeDir('/jeremy')

getFile = function(name)
  local f, h
  f = http.get('http://jrm.homenet.org/ComputerCraft/'..name..'.lua.txt')
  h = fs.open('/jeremy/'..name, 'w')
  h.write(f.readAll())
  h.close()
end

getFile('run')
getFile('boot')
getFile('get')