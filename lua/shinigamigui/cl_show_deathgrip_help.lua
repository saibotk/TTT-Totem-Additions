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

--LANG.AddToLanguage("english", "TA_DG_INFO", "ACTIVE DEATHGRIP")
local function CheckTTT()
    if gamemode.Get("terrortown") and TTTVote then
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
            if not ent:GetNWBool("disguised", false) and ( client.DeathGrip == ent or client.TeammatesDG == ent ) then
              draw.SimpleText( text, "TargetID", x+1, y+1, COLOR_BLACK )
              draw.SimpleText( text, "TargetID", x, y, color )
            end
          end

        end )

        hook.Add( "TTTPrepareRound", "TTTTADGHCleanUp", function()
            if LocalPlayer().TeammatesDG then LocalPlayer().TeammatesDG = nil end
        end )
    end
end
hook.Add("PostGamemodeLoaded", "LoadTTTTADGHelp", CheckTTT)
