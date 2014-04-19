-- Direction Constants
EAST  = vector.new( 1,  0,  0)
WEST  = vector.new(-1,  0,  0)
NORTH = vector.new( 0,  1,  0)
SOUTH = vector.new( 0, -1,  0)
UP    = vector.new( 0,  0,  1)
DOWN  = vector.new( 0,  0, -1)

-- Start at origin
position = vector.new(0, 0, 0)

--- Will be a vector that points to the opposite corner of the room
roomVector = vector.new()

-- Start facing NORTH
facing = NORTH

goForward = function()
  while turtle.detect() do -- loop to handle sand and gravel
    turtle.dig()
  end
  while not turtle.forward() do
    print('Something is in my way!')
    sleep(1)
  end
  position = position + facing
end

goUp = function()
  while turtle.detectUp() do -- loop to handle sand and gravel
    turtle.digUp()
  end
  while not turtle.up() do
    print('Something is in my way!')
    sleep(1)
  end
  position = position + UP
end

goDown = function()
  if turtle.detectDown() then
    turtle.digDown()
  end
  while not turtle.down() do
    print('Something is in my way!')
    sleep(1)
  end
  position = position + DOWN
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

go = function(direction)
  direction = direction:normalize()
  if vecEql(direction, UP) then
    goUp()
  elseif vecEql(direction, DOWN) then
    goDown()
  else
    face(direction)
    goForward()
  end
end

face = function(direction)
  if vecEql(facing, direction) then
    return
  end

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
  local dir
  print('Going home...');

  if position.x ~= 0 then
    dir = vector.new(-position.x, 0, 0)
    while position.x ~= 0 do
      go(dir)
    end
  end
  if position.y ~= 0 then
    dir = vector.new(0, -position.y, 0)
    while position.y ~= 0 do
      go(dir)
    end
  end
  if (position.z ~= 0) then
    dir = vector.new(0, 0, -position.z)
    while position.z ~= 0 do
      go(dir)
    end
  end
end

forwardToBorder = function()
  while not turtle.compare() do
    goForward()
  end
  -- Eat the border item
  goForward()
end

if turtle.getItemCount(1) ~= 1 then
  error("Put 1 of the border item into slot one first")
end
turtle.select(1)

print('Hollowing room...')
print('Discovering room size...')

-- Z direction
while not turtle.compareUp() do
  goUp()
end
-- Eat the border item
goUp()
roomVector.z = position.z
print('Z: ', roomVector.z + 1)

-- Y direction
forwardToBorder()
roomVector.y = position.y
print('Y: ', roomVector.y + 1)

-- X direction
turnRight()
forwardToBorder()
roomVector.x = position.x
print('X: ', roomVector.x + 1)

goHome()
face(NORTH)

print('Size: ', roomVector + vector.new(1, 1, 1))
