-------------------------------------------------------------------------------
--    ENHANCED NOTIFICATION FRAMEWORK
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

print( "Loading ENHANCED NOTIFICATIONS FRAMEWORK..." )

-- Initialize global object
ENHANCED_NOTIFICATIONS = { notif_table={} }

-------------------------------------------------------------------------------
-- Signature:   NewNotification( table )  table = {title, subtext, color, image}
-- Description: Creates a new notification with the given parameters, updates notification table / positions
--              parameters are optional, atleast give a title or subtext or image
-- Returns:     Nothing
-------------------------------------------------------------------------------
function ENHANCED_NOTIFICATIONS:NewNotification(t)
    setmetatable(t,{__index={title=nil, image=nil, subtext=nil, color=Color(90, 90, 90, 250), lifetime=5}})
    if not t.title and not t.subtext and not t.image then return end
    -- print("Creating Notification...")
    -- Add notif to table
    table.insert( self.notif_table, 1, self:CreateNotificationElement( t.title, t.color, t.subtext, t.image, tonumber(t.lifetime) ) )

    self:Update()
end

-------------------------------------------------------------------------------
-- Signature:   Update()
-- Description: Updates positions of stored notifications and cleans up the table
-- Returns:     Nothing
-------------------------------------------------------------------------------
function ENHANCED_NOTIFICATIONS:Update()
    local offset = 8
    local curY = 0
    for v, k in pairs( self.notif_table ) do
        if !IsValid( k ) and k:GetAlpha() == 0 then
            if IsValid( k ) then k:Remove() end
            table.remove( self.notif_table, v )
        end
    end

    for v, k in pairs(self.notif_table) do
        if IsValid( k ) and k:GetAlpha() >= 0 then
            k:SetPos( 15, 15 + curY )
            local w, h = k:GetSize()
            curY = curY + h + offset
        end
    end
end

-------------------------------------------------------------------------------
-- Signature:   FindNotification( table ) table = { title, subtext, image }
-- Description: Returns the id of the first found notification matching one of
--              the parameters (optional, atleast give one parameter)
-- Returns:     Int id (in notif_table)
-------------------------------------------------------------------------------
function ENHANCED_NOTIFICATIONS:FindNotification(t)
    setmetatable(t,{__index={title=nil, subtext=nil, image=nil}})
    if not t.title and not t.subtext and not t.image then return end

    for i, v in pairs( self.notif_table ) do
        local bg = v:GetChild( 0 )
        for _, k in pairs( bg:GetChildren() ) do
            if ( k:GetClassName() == "DLabel" and ( k:GetText() == t.title or k:GetText() == t.subtext ) ) or ( k:GetClassName() == "DImage" and k:GetImage() == t.image ) then
                return i
            end
        end
    end
end

-------------------------------------------------------------------------------
-- Signature:   RemoveNotification( id )
-- Description: Removes a notification and invokes Update()
-- Returns:     Nothing
-------------------------------------------------------------------------------
function ENHANCED_NOTIFICATIONS:RemoveNotification( id )
    if IsVaild(self.notif_table[id]) then self.notif_table[id]:Remove() end
    table.remove( self.notif_table, id )
    self:Update()
end

-------------------------------------------------------------------------------
-- Signature:   Clear()
-- Description: Clears the entire notification table and marks all elements to be removed
-- Returns:     Nothing
-------------------------------------------------------------------------------
function ENHANCED_NOTIFICATIONS:Clear()
    for v, k in pairs( self.notif_table ) do
        if IsValid( k ) then k:Remove() end
        table.remove( self.notif_table, v )
    end
end

-------------------------------------------------------------------------------
-- Signature:   GetVersion()
-- Description: Returns the version of Enhanced Notification Framework
-- Returns:     String
-------------------------------------------------------------------------------
function ENHANCED_NOTIFICATIONS:GetVersion()
    return "1.1"
end

-------------------------------------------------------------------------------
-- Signature:   CreateNotificationElement( title, color, subtext, image )
-- Description: Creates the vgui elements with the given parameters
-- Returns:     DNotify object
-------------------------------------------------------------------------------
function ENHANCED_NOTIFICATIONS:CreateNotificationElement( title, color, subtext, image )

    local notif = vgui.Create( "DNotify" )

    -- Set default values for sizes / positions
    local w, h = 300, 74
    local posXTitle, posYTitle = 80, 5
    local sizeXTitle, sizeYTitle = 215, 32
    local posXSub, posYSub = 80, 37
    local sizeXSub, sizeYSub = 215, 32

    -- Check elements to determine size / positions
    if image and not title and not subtext then
        w = 74
        h = 74
    elseif image and ( title or subtext ) then
        w = 300
        h = 74

        posXTitle, posYTitle = 80, 5
        sizeXTitle, sizeYTitle = 215, 32

        posXSub, posYSub = 80, 37
        sizeXSub, sizeYSub = 215, 32
    elseif not image then
        w = 300
        h = 74
        -- Only title:
        if not subtext and title then
            h = 42
        end
        posXTitle, posYTitle = 12, 5
        sizeXTitle, sizeYTitle = 290, 32

        posXSub, posYSub = 12, 37
        sizeXSub, sizeYSub = 290, 32
    end

    notif:SetSize( w, h )

    notif:SetLife( lifetime or 5 )

    -- Create background panel
    local bg = vgui.Create( "DPanel", notif )
    bg:Dock(FILL)
    bg:SetBackgroundColor( color )

    -- Add icon GUI element
    if image then
        local img = vgui.Create( "DImage", bg )
        img:SetPos( 5, 5 )
        img:SetSize( 64, 64 )
        img:SetImage( image )
    end

    -- Add title label
    if title then
        local lblTitle = vgui.Create( "DLabel", bg )
        lblTitle:SetPos( posXTitle, posYTitle )
        lblTitle:SetSize( 215, 32 )
        lblTitle:SetText( title )
        lblTitle:SetTextColor( Color( 255, 250, 250 ) )
        lblTitle:SetFont( "Trebuchet24" )
        lblTitle:SetWrap( false )
    end

    -- Add subtext label
    if subtext then
        local lblSubtext = vgui.Create( "DLabel", bg )
        lblSubtext:SetPos( posXSub, posYSub )
        lblSubtext:SetSize( sizeXSub, sizeYSub )
        lblSubtext:SetText( subtext )
        lblSubtext:SetTextColor( Color( 255, 250, 250 ) )
        lblSubtext:SetFont( "HudHintTextLarge" )
        lblSubtext:SetWrap( false )
    end

    -- Add all to notification
    notif:AddItem( bg )

    return notif
end
