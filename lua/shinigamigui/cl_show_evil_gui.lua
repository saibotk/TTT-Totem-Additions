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

local DPanelEG = nil

local function clearPanelEG()
  if DPanelEG and IsValid(DPanelEG) then
    DPanelEG:Remove()
  end
end

hook.Add( "TTTEndRound", "TTTShinigamiGUICleanUp", clearPanelEG )
hook.Add( "TTTPrepareRound", "TTTShinigamiGUICleanUp", clearPanelEG )

net.Receive("TTTShinigamiInfoGUI", function()
  clearPanelEG()

  local num = net.ReadUInt(8)
  local EvilTbl = {}
  for i=1, num do
    table.insert( EvilTbl, net.ReadString() )
  end

  --ToDo add row / column system
  local lineHeight = 25
  local lineWidth = 300
  local margin = 5


  DPanelEG = vgui.Create( "DPanel" )
  local panelHeight = (lineHeight + margin) * num
  local panelWidth = lineWidth
  local panelPosX = ( ScrW() / 2 ) - ( panelWidth / 2 )
  local panelPosY = ScrH() - panelHeight - 95

  DPanelEG:SetPos( panelPosX, panelPosY ) -- Set the position of the panel
  DPanelEG:SetSize( panelWidth, panelHeight ) -- Set the size of the panel
  DPanelEG:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
  -- Create Labels
  for i, ply in pairs( EvilTbl ) do
    local pan = vgui.Create( "DPanel", DPanelEG )

    pan:SetPos( 0, ( lineHeight + margin ) * (i - 1) )
    pan:SetSize( panelWidth, lineHeight )
    pan:SetBackgroundColor( Color( 255, 0, 0, 170 ) )

    local lblPlayerNick = vgui.Create( "DLabel", pan )
    lblPlayerNick:SetText( ply )
    lblPlayerNick:SetTextColor( Color( 255, 250, 250 ) )
    lblPlayerNick:SetFont( "Trebuchet24" )
    lblPlayerNick:Dock( FILL )
    lblPlayerNick:SetContentAlignment( 5 )
  end

end )
