-- Direction Constants
east  = vector.new( 1,  0,  0)
west  = vector.new(-1,  0,  0)
north = vector.new( 0,  1,  0)
south = vector.new( 0, -1,  0)
up    = vector.new( 0,  0,  1)
down  = vector.new( 0,  0, -1)

-- Start at origin
position = vector.new(0, 0, 0)

-- Start facing north
facing = north

goForward = function()
  if turtle.detect() then
    turtle.dig()
  end
  turtle.forward()
  position = position + facing
end

goUp = function()
  if turtle.detectUp() then
    turtle.digUp()
  end
  turtle.up()
  position = position + up
end

goDown = function()
  if turtle.detectUp() then
    turtle.digUp()
  end
  turtle.up()
  position = position + down
end

go = function(direction)
  direction = direction:normalize()
  if vecEql(direction, up) then
    goUp()
  elseif vecEql(direction, down) then
    goDown()
  else
    turnTowards(direction)
    goForward()
  end
end

turnLeft = function()
  turtle.turnLeft()
  if vecEql(facing, east) then
    facing = north
  elseif vecEql(facing, north) then
    facing = west
  elseif vecEql(facing, west) then
    facing = south
  elseif vecEql(facing, south) then
    facing = east
  end
end

turnRight = function()
  turtle.turnRight()
  if vecEql(facing, east) then
    facing = south
  elseif vecEql(facing, south) then
    facing = west
  elseif vecEql(facing, west) then
    facing = north
  elseif vecEql(facing, north) then
    facing = east
  end
end

turnTowards = function(direction)
  if vecEql(facing, direction) then
    return
  end

  if vecEql(facing, north) then
    if vecEql(direction, east) then
      turnRight()
    elseif vecEql(direction, west) then
      turnLeft()
    elseif vecEql(direction, south) then
      turnRight()
      turnRight()
    end
  elseif vecEql(facing, east) then
    if vecEql(direction, south) then
      turnRight()
    elseif vecEql(direction, north) then
      turnLeft()
    elseif vecEql(direction, west) then
      turnRight()
      turnRight()
    end
  elseif vecEql(facing, south) then
    if vecEql(direction, west) then
      turnRight()
    elseif vecEql(direction, east) then
      turnLeft()
    elseif vecEql(direction, north) then
      turnRight()
      turnRight()
    end
  elseif vecEql(facing, west) then
    if vecEql(direction, north) then
      turnRight()
    elseif vecEql(direction, south) then
      turnLeft()
    elseif vecEql(direction, east) then
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

  if (position.z ~= 0) then
    dir = vector.new(0, 0, -postion.z)
    while position.z ~= 0 do
      go(dir)
    end
  end
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
end

if turtle.getItemCount(1) ~= 1 then
  error("Put 1 of the border item into slot one first")
end

print('Hollowing room...')

turtle.select(1)
while not turtle.compare() do
  goForward()
end

goHome()

print(position)
