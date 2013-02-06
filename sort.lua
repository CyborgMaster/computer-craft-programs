--0 for down, 1 for up, 2 for -Z, 3 for +Z, 4 for -X and 5 for +X.
DOWN = 0
UP = 1
NORTH = 2
SOUTH = 3
WEST = 4
EAST = 5

print('sorting...')
s = peripheral.wrap('right')
-- for k,v in pairs(s) do
--   print(k)
-- end
for k,v in pairs(s.list(SOUTH)) do
  print(k..', '..v)
end