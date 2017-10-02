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

local DPanelGH = nil

local function clearPanelGH()
  if DPanelGH and IsValid( DPanelGH ) then
    DPanelGH:Remove()
  end
end

hook.Add( "TTTEndRound", "TTTShinigamiGUIHintCleanUp", clearPanelGH )
hook.Add( "TTTPrepareRound", "TTTShinigamiGUIHintCleanUp", clearPanelGH )

net.Receive( "TTTShinigamiInfoGUIHint", function()

  DPanelGH = vgui.Create( "DPanel" )
  DPanelGH:SetPos( ScrW() - 76, ScrH() / 4 )
  DPanelGH:SetSize( 66, 66 )
  DPanelGH:SetBackgroundColor( Color( 255, 255, 255, 150) )

  local icon = vgui.Create( "DImage", DPanelGH )
  icon:SetPos( 1, 1 )
  icon:SetSize( 64, 64 )
  icon:SetImage( "vgui/ttt/icon_shini" )
end )
