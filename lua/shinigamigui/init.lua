AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_show_evil_gui.lua" )
AddCSLuaFile( "cl_show_gui_hint.lua" )

local tttTotemAdditionsShiniGUIInfo = CreateConVar("ttt_totem_additions_shinigui_info","1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Should TTT Totem Additions Shinigami Traitor GUI be active?"):GetBool()
local tttTotemAdditionsShiniGUIHint = CreateConVar("ttt_totem_additions_shinigui_hint","1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Should TTT Totem Additions Shinigami hint sign be active?"):GetBool()

util.AddNetworkString( "TTTShinigamiInfoGUI" )
util.AddNetworkString( "TTTShinigamiInfoGUIHint" )

hook.Add( "PostPlayerDeath", "TTTShinigamiGUI", function(ply)
  if not tttTotemAdditionsShiniGUIInfo then return end
  if ply:GetShinigami() and !ply.ShinigamiRespawned and ( GetRoundState() == ROUND_ACTIVE or GetRoundState() == ROUND_POST ) then
    timer.Simple( 0.2, function()
      local tbl = {}
      for k,v in pairs( player.GetAll() ) do
        if v:GetEvil() then
          table.insert( tbl, v:Nick() )
        end
      end
      net.Start( "TTTShinigamiInfoGUI" )
      net.WriteUInt( #tbl, 8 )
      for k,v in pairs( tbl ) do
        net.WriteString( v )
      end
      net.Send( ply )
    end )
  end
end )

hook.Add( "TTTBeginRound", "TTTShinigamiGUIHint", function()
  if not tttTotemAdditionsShiniGUIHint then return end
  timer.Simple( 0.6, function()
    local aliveplayers = util.GetAlivePlayers()

      for k,v in pairs(aliveplayers) do
        if v:GetShinigami() then
          net.Start( "TTTShinigamiInfoGUIHint" )
          --net.WriteBool( true )
          net.Broadcast()
          break
        end
      end
  end  )
end )
