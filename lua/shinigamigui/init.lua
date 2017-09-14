-------------------------------------------------------------------------------
--    TTT Totem Additions
--    Copyright (C) 2017 saibotk (tkindanight)
-------------------------------------------------------------------------------
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------------

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_show_evil_gui.lua" )
AddCSLuaFile( "cl_show_gui_hint.lua" )
AddCSLuaFile( "cl_show_deathgrip_help.lua" )
AddCSLuaFile( "cl_deathgrip_team_notice.lua" )

local tttTotemAdditionsShiniGUIInfo = CreateConVar("ttt_totem_additions_shinigui_info","1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Should TTT Totem Additions Shinigami Traitor GUI be active?"):GetBool()
local tttTotemAdditionsShiniGUIHint = CreateConVar("ttt_totem_additions_shinigui_hint","1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Should TTT Totem Additions Shinigami hint sign be active?"):GetBool()
local tttTotemAdditionsShiniGUIDGHelp = CreateConVar("ttt_totem_additions_shinigui_deathgrip_help", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Should TTT Totem Additions Shinigami DeathGrip Info be active?"):GetBool()

util.AddNetworkString( "TTTShinigamiInfoGUI" )
util.AddNetworkString( "TTTShinigamiInfoGUIHint" )
util.AddNetworkString( "TA_DG_NOTIF" )

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

local function SameTeam(ply, ply_o )
    if IsValid( ply ) and IsValid( ply_o ) and ply:IsActive() and ( ( ply.GetTeam and ply:GetTeam() == ply_o:GetTeam() and not ply_o:GetDetective() ) or ( ply:GetRole() == ply_o:GetRole() ) ) and ply != ply_o then
        return true
    end
    return false
end

local function GetAliveTeammemberTableDG( ply_o, dg )
    local teammembers = {}
    local players = player.GetAll()
    if not players then return teammembers end
    for _, ply in pairs( players ) do
      -- Added Compat for TTT Totem by GamefreakDE
      if SameTeam(ply, ply_o) then
          if dg then
              if ply != ply_o.DeathGrip then
                  table.insert(teammembers, ply)
              end
          else
              table.insert(teammembers, ply)
          end
      end
    end

    return teammembers
end

hook.Add( "TTTBeginRound", "TTTDeathgripNotif", function()

    timer.Simple( 0.7, function()
        local players = player.GetAll()
        local ply = nil
        if not players then return end
        for k,v in pairs(players) do
            if v.DeathGrip then
              ply = v
              break
            end
        end

        if not ply then return end

        net.Start( "TA_DG_NOTIF" )
        net.WriteEntity(ply)
        net.WriteEntity(ply.DeathGrip)
        net.Send(GetAliveTeammemberTableDG(ply, true))
        if not SameTeam( ply, ply.DeathGrip ) then
            net.Start( "TA_DG_NOTIF" )
            net.WriteEntity(ply.DeathGrip)
            net.WriteEntity(ply)
            net.Send(GetAliveTeammemberTableDG(ply.DeathGrip, true))
        end
    end  )
end )
