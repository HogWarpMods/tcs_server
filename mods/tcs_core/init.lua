local players = {}
local playerCount = 0
local tick = 0

registerForEvent("player_joined", function(Player)
   playerCount = playerCount + 1
   players[Player.id] = initPlayer(Player)
end)

registerForEvent("player_left", function(Player)
   playerCount = playerCount - 1
   players[Player.id] = nil
end)

registerForEvent("update", function(delta)
   tick = tick + delta

   if tick > 120 then
      tick = 0

      print("Player Online: "..playerCount.."/4")
      for k, v in pairs(players) do
         print("Player ID: "..v.id.." is online with house: "..v.house.." and gender: ".. v.gender)
      end
   end
end)

--==================================================
-- PLAYER FUNC
--==================================================
function initPlayer(Player)
   local self = {}
   self.id = Player.id
   self.gear = Player.gear
   self.gender = Player.gender
   self.house = Player.house
   self.movement = Player.movement

   return self
end

--==================================================
-- FUNC
--==================================================
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end