--0 for down, 1 for up, 2 for -Z, 3 for +Z, 4 for -X and 5 for +X.
DOWN = 0
UP = 1
NORTH = 2
SOUTH = 3
WEST = 4
EAST = 5

deMungeId = function(uuid)
  local subt = bit.band(uuid, 0x7fff)
  local dexorm = bit.bxor(subt, 0x3a69)
  local metadata = nil
  if dexorm ~= 28262 then -- item takes dmg
    metadata = bit.bxor(dexorm, 0x6e6c)
  end
  local id = bit.bxor((uuid-subt)/0x8000, 0x4f89)
  return id, metadata
end

local directions = { [0]=0,[1]=1,[2]=2,[3]=3,[4]=4,[5]=5,["down"] = 0, ["up"] = 1, ["-Z"] = 2, ["+Z"] = 3, ["-X"] = 4, ["+X"] = 5, ["+Y"] = 1, ["-Y"] = 0}
directions.south = directions["+Z"]
directions.east = directions["+X"]
directions.north = directions["-Z"]
directions.west = directions["-X"]


print('sorting...')
s = peripheral.wrap('right')

while true do
  local event, uuid, count = os.pullEvent('isort_item')
  print(uuid..','..count)
  id, meta = deMungeId(uuid)
  print('item '..id)
  if id == 3 then
    s.sort(directions.west)
  else
    s.sort(directions.north)
  end
end

-- for k,v in pairs(s.list(SOUTH)) do
--   id, meta = deMungeId(k)
--   print('id: '..id..', meta: '..meta..', count: '..v)
-- end
