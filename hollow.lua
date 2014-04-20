-- Direction Constants
EAST  = vector.new( 1,  0,  0)
WEST  = vector.new(-1,  0,  0)
NORTH = vector.new( 0,  1,  0)
SOUTH = vector.new( 0, -1,  0)
UP    = vector.new( 0,  0,  1)
DOWN  = vector.new( 0,  0, -1)

ORIGIN = vector.new(0, 0, 0)

-- Start at origin
position = ORIGIN

--- Will be a vector that points to the opposite corner of the room
roomVector = vector.new()

-- Start facing NORTH
facing = NORTH

isnan = function(x) return x ~= x end

isDirection = function(v)
  return vecEql(v, NORTH) or
    vecEql(v, SOUTH) or
    vecEql(v, EAST) or
    vecEql(v, WEST)
end

checkFuel = function()
  if turtle.getFuelLevel() <= 0 then
    print('Out of fuel! Place fuel in slot 2.')
    oldSelected = turtle.getSelected()
    turtle.select(2)
    while true do
      turtle.refuel()
      if turtle.getFuelLevel > 0 then break end
      sleep(10)
    end
    turtle.select(oldSelected)
  end
end

moveForward = function()
  digForward()
  checkFuel()
  while not turtle.forward() do
    print('Something is in my way!')
    sleep(1)
  end
  position = position + facing
end

digForward = function()
  while turtle.detect() do -- loop to handle sand and gravel
    turtle.dig()
  end
end

moveUp = function()
  digUp()
  checkFuel()
  while not turtle.up() do
    print('Something is in my way!')
    sleep(1)
  end
  position = position + UP
end

digUp = function()
  while turtle.detectUp() do -- loop to handle sand and gravel
    turtle.digUp()
  end
end

moveDown = function()
  digDown()
  checkFuel()
  while not turtle.down() do
    print('Something is in my way!')
    sleep(1)
  end
  position = position + DOWN
end

digDown = function()
  if turtle.detectDown() then
    turtle.digDown()
  end
end

turnLeft = function()
  turtle.turnLeft()
  if vecEql(facing, EAST) then
    facing = NORTH
  elseif vecEql(facing, NORTH) then
    facing = WEST
  elseif vecEql(facing, WEST) then
    facing = SOUTH
  elseif vecEql(facing, SOUTH) then
    facing = EAST
  end
end

turnRight = function()
  turtle.turnRight()
  if vecEql(facing, EAST) then
    facing = SOUTH
  elseif vecEql(facing, SOUTH) then
    facing = WEST
  elseif vecEql(facing, WEST) then
    facing = NORTH
  elseif vecEql(facing, NORTH) then
    facing = EAST
  end
end

move = function(direction)
  direction = direction:normalize()
  if vecEql(direction, UP) then
    moveUp()
  elseif vecEql(direction, DOWN) then
    moveDown()
  else
    face(direction)
    moveForward()
  end
end

face = function(direction)
  if vecEql(facing, direction) then
    return
  end

  if not(isDirection(direction)) then
    error(direction..' is not a valid direction vector')
  end

  --print('Turning to face: ', direction)
  if vecEql(facing, NORTH) then
    if vecEql(direction, EAST) then
      turnRight()
    elseif vecEql(direction, WEST) then
      turnLeft()
    elseif vecEql(direction, SOUTH) then
      turnRight()
      turnRight()
    end
  elseif vecEql(facing, EAST) then
    if vecEql(direction, SOUTH) then
      turnRight()
    elseif vecEql(direction, NORTH) then
      turnLeft()
    elseif vecEql(direction, WEST) then
      turnRight()
      turnRight()
    end
  elseif vecEql(facing, SOUTH) then
    if vecEql(direction, WEST) then
      turnRight()
    elseif vecEql(direction, EAST) then
      turnLeft()
    elseif vecEql(direction, NORTH) then
      turnRight()
      turnRight()
    end
  elseif vecEql(facing, WEST) then
    if vecEql(direction, NORTH) then
      turnRight()
    elseif vecEql(direction, SOUTH) then
      turnLeft()
    elseif vecEql(direction, EAST) then
      turnRight()
      turnRight()
    end
  end
end

vecEql = function(v1, v2)
  return v1.x == v2.x and v1.y == v2.y and v1.z == v2.z
end

goHome = function()
  print('Going home...')
  goTo(vector.new(0, 0, 0))
end

goTo = function(loc)
  local dir

  print('Going to ', loc)

  --print('matching x...')
  if position.x ~= loc.x then
    dir = vector.new(loc.x-position.x, 0, 0)
    while position.x ~= loc.x do
      move(dir)
    end
  end
  --print('matching y...')
  if position.y ~= loc.y then
    dir = vector.new(0, loc.y-position.y, 0)
    while position.y ~= loc.y do
      move(dir)
    end
  end
  --print('matching z...')
  if (position.z ~= loc.z) then
    dir = vector.new(0, 0, loc.z-position.z)
    while position.z ~= loc.z do
      move(dir)
    end
  end
end

inside = function(boundary1, boundary2, vector)
  return boundary1.x <= vector.x and vector.x <= boundary2.x and
    boundary1.y <= vector.y and vector.y <= boundary2.y and
    boundary1.z <= vector.z and vector.z <= boundary2.z
end

insideRoom = function(vector)
  return inside(ORIGIN, roomVector, vector)
end

bounce = function(direction, reach, beforeEvery)
  reach = reach or 0
  beforeEvery = beforeEvery or function() end
  while true do
    beforeEvery()
    moved = false
    for i=1, reach * 2 + 1 do
      if not insideRoom(position + direction * (reach + 1)) then break end
      move(direction)
      moved = true
    end
    if not moved then break end
  end
  return direction * -1;
end

discoverRoomSize = function()
  local x, y, z

  -- Z direction
  while not turtle.compareUp() do
    moveUp()
  end
  -- Eat the border item
  moveUp()
  z = position.z
  print('Z: ', z + 1)

  -- Y direction
  while not turtle.compare() do
    moveForward()
  end
  -- Eat the border item
  moveForward()
  y = position.y
  print('Y: ', y + 1)

  -- X direction
  turnRight()
  while not turtle.compare() do
    moveForward()
  end
  -- Eat the border item
  moveForward()
  x = position.x
  print('X: ', x + 1)

  return vector.new(x, y, z)
end

if turtle.getItemCount(1) ~= 1 then
  error("Put 1 of the border item into slot one first")
end
turtle.select(1)

print('Hollowing room...')

print('Discovering room size...')
roomVector = discoverRoomSize()

print('Going to start location...')
goTo(vector.new(0, 0, roomVector.z - 1)) -- Go one below because we dig up

xDir = vector.new(1, 0, 0)
zDir = vector.new(0, 0, -1)

while true do
  print('Hollowing slice...')
  zDir = bounce(
    zDir, 1,
    function()
      xDir = bounce(
        xDir, 0,
        function()
          if insideRoom(position + UP) then digUp() end
          if insideRoom(position + DOWN) then digDown() end
        end)
    end)
  if not insideRoom(position + NORTH) then break end
  move(NORTH)
end

goHome()
face(NORTH)

print('Finished hollowing room of size: ', roomVector + vector.new(1, 1, 1))
