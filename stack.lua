-- Takes items in and only outputs half stacks
-- This is to prevent barrels from backing up when redpower tubes pipe stuff into them

print('Reducing stack size...')

checkInventory = function()
  local dropped
  repeat
    dropped = false
    for i = 1,16 do
      local count = turtle.getItemCount(i)
      if (count > 0) then
        turtle.select(i)
        turtle.drop(32)
        dropped = true
        sleep(0.5)
        if count > 32 then
          turtle.drop(32)
          dropped = true
          sleep(0.5)
        end
      end
    end
  until not dropped
end


while true do
  local uuid, count = os.pullEvent('redstone')
  if redstone.getInput('back') then
    checkInventory()
  end
end
