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

-- Create notification framework
if not ENHANCED_NOTIFICATIONS then
    include( "enhancednotificationscore/cl_init.lua" )
end

-- Receive Callback
net.Receive( "TA_DG_NOTIF", function()
    -- Read sent information
    local ply = net.ReadEntity()
    local dgply = net.ReadEntity()
    local bgColor = Color( 255, 80, 190, 240 )
    ENHANCED_NOTIFICATIONS:NewNotification({title=ply:GetName(),subtext="in DeathGrip with " .. dgply:GetName(),color=bgColor,lifetime=20})
end )
