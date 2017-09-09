local DPanelEG = nil

local function clearPanelEG()
  if DPanelEG then
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
  -- maybe Add line width calc?

  DPanelEG = vgui.Create( "DPanel" )
  local panelHeight = (lineHeight + margin) * num
  local panelWidth = lineWidth
  local panelPosX = ( ScrW() / 2 ) - ( panelWidth / 2 )
  local panelPosY = ScrH() - panelHeight - 95

  print("panel H W PX PY: ", panelHeight, panelWidth, panelPosX, panelPosY)

  DPanelEG:SetPos( panelPosX, panelPosY ) -- Set the position of the panel
  DPanelEG:SetSize( panelWidth, panelHeight ) -- Set the size of the panel
  DPanelEG:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
  -- Create Labels
  for i, ply in pairs( EvilTbl ) do
    local pan = vgui.Create( "DPanel", DPanelEG )

    print("labelpanel H W PX PY: ", lineHeight, panelWidth, 0, lineHeight * (i - 1), ply)

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
