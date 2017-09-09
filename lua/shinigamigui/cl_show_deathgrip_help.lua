--LANG.AddToLanguage("english", "TA_DG_INFO", "ACTIVE DEATHGRIP")
-- TODO add ConVar
hook.Add( "HUDDrawTargetID", "TA_DG_INFO", function()

  local client = LocalPlayer()
  --local SafeTranslate = LANG.TryTranslation

  local trace = client:GetEyeTrace(MASK_SHOT)
  local ent = trace.Entity
  if (not IsValid(ent)) or ent.NoTarget then return end

  local text = "WARNING: ACTIVE DEATHGRIP"
  local color = Color( 255, 0, 255, 255 )
  local x = ScrW() / 2.0
  local y = ScrH() / 2.0
  surface.SetFont( "TargetID" )
  local w, h = surface.GetTextSize( text )
  x = x - w / 2
  y = y - 30

  if IsValid(ent:GetNWEntity("ttt_driver", nil)) then
    ent = ent:GetNWEntity("ttt_driver", nil)
    if ent == client then return end
  end

  if ent:IsPlayer() then
    if not ent:GetNWBool("disguised", false) and client.DeathGrip == ent then
      draw.SimpleText( text, "TargetID", x+1, y+1, COLOR_BLACK )
      draw.SimpleText( text, "TargetID", x, y, color )
    end
  end

end )
