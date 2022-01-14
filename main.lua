random_ost = RegisterMod("Random OST", 1)

MMC.RemoveMusicCallback(random_ost)

-- Music names to be randomized
-- number is the amount of versions (3 == all, 2 == without DannyB)
local trackNamesToAmount = {
  ['Basement'] = 3,
  ['Caves'] = 3,
  ['Depths'] = 3,
  ['Cellar'] = 3,
  ['Catacombs'] = 3,
  ['Necropolis'] = 3,
  ['Womb'] = 3,
  ['Game Over'] = 3,
  ['Boss'] = 3,
  ['Cathedral'] = 3,
  ['Sheol'] = 3,
  ['Dark Room'] = 3,
  ['Chest'] = 3,
  ['Burning Basement'] = 3,
  ['Flooded Caves'] = 3,
  ['Dank Depths'] = 3,
  ['Scarred Womb'] = 3,
  ['Blue Womb'] = 3,
  ['Utero'] = 3,
  ['Boss (Depths - Mom)'] = 3,
  ["Boss (Womb - Mom's Heart)"] = 3,
  ['Boss (Cathedral - Isaac)'] = 3,
  ['Boss (Sheol - Satan)'] = 3,
  ['Boss (Dark Room)'] = 3,
  ['Boss (Chest - ???)'] = 3,
  ['Boss (alternate)'] = 3,
  ['Boss (Blue Womb - Hush)'] = 3,
  ['Boss (Ultra Greed)'] = 3,
  ['Library Room'] = 3,
  ['Secret Room'] = 3,
  ['Secret Room Alt'] = 2,
  ['Devil Room'] = 3,
  ['Angel Room'] = 3,
  ['Shop Room'] = 3,
  ['Arcade Room'] = 3,
  ['Boss Room (empty)'] = 3,
  ['Challenge Room (fight)'] = 3,
  ['Boss Rush'] = 2,
  ['Boss Rush (jingle)'] = 2,
  ['Boss (alternate alternate)'] = 2,
  ['Boss Death Alternate Alternate (jingle)'] = 2,
  ['Boss (Mother)'] = 2,
  ['Planetarium'] = 2,
  ['Secret Room Alt Alt'] = 2,
  ['Boss Room (empty, twisted)'] = 2,
  ['Credits'] = 3,
  ['Title Screen (Afterbirth)'] = 3,
  ['Title Screen (Repentance)'] = 3,
  ['Game start (jingle, twisted)'] = 2,
  ['Credits Alt'] = 2,
  ['Credits Alt Final'] = 2,
  ['Boss Death (jingle)'] = 3,
  ['Secret Room Find (jingle)'] = 3,
  ['Treasure Room Entry (jingle) 1'] = 3,
  ['Treasure Room Entry (jingle) 2'] = 3,
  ['Treasure Room Entry (jingle) 3'] = 3,
  ['Treasure Room Entry (jingle) 4'] = 3,
  ['Challenge Room Entry (jingle)'] = 3,
  ['Challenge Room Outro (jingle)'] = 3,
  ['Game Over (jingle)'] = 3,
  ['Game start (jingle)'] = 3,
  ['Boss Death Alternate (jingle)'] = 3,
  ['Boss Hush Death (jingle)'] = 3,
  ['Void'] = 3,
  ['Boss (Void)'] = 3,
  ['Downpour'] = 2,
  ['Mines'] = 2,
  ['Mausoleum'] = 2,
  ['Corpse'] = 2,
  ['not done'] = 2,
  ['Downpour (reversed)'] = 2,
}

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local MusicToRandom = {}
-- Executes when the run starts
local function UpdateMusicToRandom()
  
  for trackName, trackAmount in pairs(trackNamesToAmount) do
    
    local trackID = Isaac.GetMusicIdByName(trackName)
    rand = math.random(1, trackAmount)
    while rand == MusicToRandom[trackID] do
      rand = math.random(1, trackAmount)
    end
    MusicToRandom[trackID] = rand
    --MusicToRandom[trackID] = 3
    
  end
end

local currentMusic = MMC.GetMusicTrack()
local roomsWithStageMusic = {
  RoomType.ROOM_DEFAULT, 
  RoomType.ROOM_TREASURE, 
  RoomType.ROOM_CHALLENGE,
  RoomType.ROOM_CURSE,
  RoomType.ROOM_SACRIFICE,
}

local function LaunchUpdateMusicToRandom()
  local newCurrentMusic = MMC.GetMusicTrack()
  local roomType = Game():GetRoom():GetType()
  if newCurrentMusic ~= currentMusic 
  and not has_value(roomsWithStageMusic, roomType)
  and type(newCurrentMusic) ~= "table" then
    currentMusic = newCurrentMusic
    UpdateMusicToRandom()
  end
end

UpdateMusicToRandom()
random_ost:AddCallback(ModCallbacks.MC_POST_RENDER, LaunchUpdateMusicToRandom)

for trackName, _ in pairs(trackNamesToAmount) do
  local trackId = Isaac.GetMusicIdByName(trackName)

  MMC.AddMusicCallback(random_ost, function(self, trackId)
  
          if MusicToRandom[trackId] == 2 then
            return Isaac.GetMusicIdByName(trackName .. " mudeth")
            
          elseif MusicToRandom[trackId] == 3 then
            return Isaac.GetMusicIdByName(trackName .. " dannyb")
            
          else
            -- 0: prevent the new track and continue the current one
            -- -1: stop all music 
            -- nil: do nothing
            return nil
          end
  
  end, trackId)
end