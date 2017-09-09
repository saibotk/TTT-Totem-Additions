local DPanelGH = nil

local function clearPanelGH()
  print( "Shini Info Gui cleanup" )
  if DPanelGH then
    print( " -- success" )
    DPanelGH:Remove()
  end
end

hook.Add( "TTTEndRound", "TTTShinigamiGUIHintCleanUp", clearPanelGH )
hook.Add( "TTTPrepareRound", "TTTShinigamiGUIHintCleanUp", clearPanelGH )

net.Receive( "TTTShinigamiInfoGUIHint", function()
  print( "-- SHINIINFOGUI: Shinigami active this round! --" )

  DPanelGH = vgui.Create( "DPanel" )
  DPanelGH:SetPos( ScrW() - 76, ScrH() / 4 )
  DPanelGH:SetSize( 66, 66 )
  DPanelGH:SetBackgroundColor( Color( 255, 255, 255, 150) )

  local icon = vgui.Create( "DImage", DPanelGH )
  icon:SetPos( 1, 1 )
  icon:SetSize( 64, 64 )
  icon:SetImage( "vgui/ttt/icon_shini" )
end )
