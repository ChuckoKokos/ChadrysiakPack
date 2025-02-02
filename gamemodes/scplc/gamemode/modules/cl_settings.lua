SLC_SETTINGS = {}
local DEFAULT_SETTINGS = {}
local WINDOW_PANELS = {}

local MATS = {
	blur = Material( "pp/blurscreen" ),
	exit = Material( "slc/hud/exit.png", "smooth" ),
	reset = Material( "slc/hud/refresh.png", "smooth" )
}

local COLOR = {
	white = Color( 255, 255, 255, 255 ),
	black = Color( 0, 0, 0, 255 ),
	inactive = Color( 125, 125, 125, 255 ),
	border = Color( 175, 175, 175, 255 ),
	hover = Color( 75, 75, 75, 255 ),
	selected = Color( 115, 115, 115, 25 ),
	conflict = Color( 225, 50, 50, 255 ),
}

--[[-------------------------------------------------------------------------
Local functions
---------------------------------------------------------------------------]]
local function translateButton( button )
	local t, key = string.match( button, "(%a+):(.+)" )
	if t and key then
		key = string.lower( key )

		if t == "key" then
			key = string.match( key, "key_(w+)" ) or key
			return input.GetKeyCode( key ), key, nil
		elseif t == "code" then
			local num_key = tonumber( key )
			if num_key then
				return num_key, input.GetKeyName( num_key ), nil
			end
		elseif t == "bind" then
			local bind_key = input.LookupBinding( key )
			if bind_key then
				return input.GetKeyCode( bind_key ), bind_key, key
			end

			return nil, nil, key
		end
	end
end

local function checkForConflicts()
	for name1, bind1 in pairs( SLC_SETTINGS ) do
		if bind1.stype == "bind" then
			bind1.key_conflict = false

			for name2, bind2 in pairs( SLC_SETTINGS ) do
				if bind1 != bind2 and bind2.stype == "bind" then
					if bind1.key_code and bind2.key_code and bind1.key_code == bind2.key_code then
						bind1.key_conflict = true
						//bind2.key_conflict = true
						break
					end
				end
			end

			/*if bind1.key_code then
				local bind = input.LookupKeyBinding( bind1.key_code )
				if bind then
					//bind1.key_conflict = true
				end
			end*/
		end
	end
end

local function processSettingsEntry( k )
	local v = SLC_SETTINGS[k]
	if v then
		if v.stype == "bind" then
			v.key_conflict = false

			local code, key, bind = translateButton( v.value )
			if code and key then
				v.key_code = code
				v.key = key
			else
				v.key_code = nil
				v.key = nil
			end

			v.bind = bind
		end
	end
end

local function processAllSettings()
	for k, v in pairs( SLC_SETTINGS ) do
		processSettingsEntry( k )
	end

	checkForConflicts()
end

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function GetSettingsEntry( name )
	return SLC_SETTINGS[name]
end

function GetBindButton( name )
	if SLC_SETTINGS[name] then
		return SLC_SETTINGS[name].key_code, SLC_SETTINGS[name].key
	end
end

function SaveSettings()
	local tab = {}

	for k, v in pairs( SLC_SETTINGS ) do
		tab[k] = v.value
	end

	file.Write( "slc/client_settings.json", util.TableToJSON( tab ) )
end

local settingsID = 1
function RegisterSettingsEntry( name, stype, default )
	SLC_SETTINGS[name] = {
		id = settingsID,
		stype = stype,
		default = default,
		//value = nil,
	}

	settingsID = settingsID + 1
end

function AddSettingsPanel( name, fn, show )
	table.insert( WINDOW_PANELS, { name = name, create = fn, show = show } )
end

--[[-------------------------------------------------------------------------
Open window
---------------------------------------------------------------------------]]
function OpenSettingsWindow()
	if IsValid( SLC_SETTINGS_WINDOW ) then return end
	processAllSettings()

	local w, h = ScrW(), ScrH()

	local window = vgui.Create( "DFrame" )
	SLC_SETTINGS_WINDOW = window

	window:SetSize( w * 0.75, h * 0.8 )
	window:SetTitle( "" )

	window:ShowCloseButton( false )
	window:SetDraggable( false )

	window:Center()
	window:MakePopup()

	window:DockPadding( 0, 0, 0, 0 )

	window.Paint = function( self, pw, ph )
		render.UpdateScreenEffectTexture()
		MATS.blur:SetFloat( "$blur", 8 )

		if !recomputed then
			recomputed = true
			MATS.blur:Recompute()
		end

		surface.SetDrawColor( COLOR.border )
		surface.DisableClipping( true )
		surface.DrawRect( -1, -1,  pw + 2, ph + 2 )
		surface.DisableClipping( false )

		surface.SetDrawColor( COLOR.white )
		surface.SetMaterial( MATS.blur )
		surface.DrawTexturedRect( -w * 0.125, -h * 0.1, w, h )

		surface.SetDrawColor( Color( 0, 0, 0, 175 ) )
		surface.DrawRect( 0, 0, pw, ph )
	end

	local upper_pnl = vgui.Create( "DPanel", window )
	upper_pnl:SetTall( h * 0.035 )
	upper_pnl:Dock( TOP )
	upper_pnl:DockMargin( 0, 0, 0, 0 )

	upper_pnl.Paint = function( self, pw, ph )
		surface.SetDrawColor( COLOR.black )
		surface.DrawRect( 0, 0, pw, ph )

		draw.Text{
			text = LANG.settings.settings,
			pos = { pw * 0.01, ph * 0.5 },
			font = "SCPHUDMedium",
			color = COLOR.white,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}
	end

	local close_btn = vgui.Create( "DButton", upper_pnl )
	close_btn:SetWide( w * 0.02 )
	close_btn:Dock( RIGHT )
	close_btn:DockMargin( 0, h * 0.007, w * 0.007, h * 0.007 )
	close_btn:SetText( "" )

	close_btn.Paint = function( self, pw, ph )
		draw.RoundedBox( 6, 0, 0, pw, ph, Color( 255, 0, 0, 150 ))

		surface.SetDrawColor( COLOR.white )
		surface.SetMaterial( MATS.exit )
		surface.DrawTexturedRect( pw * 0.5 - h * 0.008, ph * 0.5 - h * 0.007, h * 0.0175, h * 0.0175 )
	end

	close_btn.DoClick = function( self )
		window:Close()
	end

	local side_menu = vgui.Create( "DScrollPanel", window )
	side_menu:SetWide( w * 0.15 )
	side_menu:Dock( LEFT )
	side_menu:DockMargin( w * 0.01, w * 0.01, 0, w * 0.01 )
	side_menu:GetCanvas():DockPadding( 0, w * 0.005, w * 0.005, w * 0.005 )

	side_menu:GetVBar():SetWide( 0 )

	side_menu.Paint = function( self, pw, ph )
		surface.SetDrawColor( COLOR.border )
		surface.DrawLine( pw - 1, 0, pw - 1, ph )
		//surface.DrawOutlinedRect( 0, 0, pw, ph )
	end

	local main_panel = vgui.Create( "DScrollPanel", window )
	main_panel:Dock( FILL )
	main_panel:DockMargin( w * 0.01, w * 0.01, w * 0.01, w * 0.01 )
	main_panel:GetCanvas():DockPadding( 0, w * 0.005, w * 0.005, w * 0.005 )

	main_panel:GetVBar():SetWide( 0 )

	main_panel.Paint = function( self, pw, ph )
	end

	for i, v in ipairs( WINDOW_PANELS ) do
		if !v.show or v.show() then
			local btn = vgui.Create( "DButton", side_menu )
			btn:SetTall( h * 0.05 )
			btn:Dock( TOP )
			btn:SetText( "" )

			btn.Paint = function( self, pw, ph )
				if i == main_panel.SelectedMenu then
					surface.SetDrawColor( COLOR.selected )
					surface.DrawRect( 0, 0, pw, ph )
				end

				if self:IsHovered() then
					surface.SetDrawColor( COLOR.hover )
					surface.DrawRect( 0, 0, pw, ph )
				end

				if i == main_panel.SelectedMenu then
					surface.SetDrawColor( COLOR.white )
					surface.DrawLine( 0, ph - 1, pw * 0.8, ph - 1 )
				else
					surface.SetDrawColor( Color( 100, 100, 100, 255 ) )
					surface.DrawLine( 0, ph - 1, pw * 0.8, ph - 1 )
				end

				draw.Text{
					text = LANG.settings.panels[v.name] or v.name,
					pos = { pw * 0.01, ph * 0.5 },
					font = "SCPHUDSmall",
					color = COLOR.white,
					xalign = TEXT_ALIGN_LEFT,
					yalign = TEXT_ALIGN_CENTER,
				}
			end

			btn.DoClick = function( self )
				if main_panel.SelectedMenu != i then
					main_panel:Clear()

					main_panel.SelectedMenu = i
					main_panel.SelectedMenuName = v.name

					v.create( main_panel )
				end
			end
		end
	end

	local first = WINDOW_PANELS[1]
	if first then
		main_panel.SelectedMenu = 1
		main_panel.SelectedMenuName = first.name
		first.create( main_panel )
	end
end

--[[-------------------------------------------------------------------------
Base hooks
---------------------------------------------------------------------------]]
hook.Add( "SLCGamemodeLoaded", "SLCSettings", function()
	hook.Run( "SLCRegisterSettings" )
	for k, v in pairs( SLC_SETTINGS ) do
		DEFAULT_SETTINGS[k] = v.defalt
	end

	local data = {}

	if !file.Exists( "slc/client_settings.json", "data" ) then
		file.Write( "slc/client_settings.json", util.TableToJSON( DEFAULT_SETTINGS ) )
	else
		local tab = util.JSONToTable( file.Read( "slc/client_settings.json" ) )
		if tab then
			data = tab
		else
			print( "Client settings file is corrupted!" )
		end
	end

	for k, v in pairs( SLC_SETTINGS ) do
		v.value = data[k] or v.default
		processSettingsEntry( k )
	end

	checkForConflicts()
	//PrintTable( SLC_SETTINGS )
	SaveSettings()
end )

hook.Add( "SLCRegisterSettings", "SLCBaseSettings", function()
	RegisterSettingsEntry( "eq_button", "bind", "bind:+menu" )
	RegisterSettingsEntry( "upgrade_tree_button", "bind", "bind:+zoom" )
	RegisterSettingsEntry( "ppshop_button", "bind", "key:F1" )
	RegisterSettingsEntry( "settings_button", "bind", "none" )
end )

hook.Add( "SLCFactoryReset", "SLCSettingsReset", function()
	for k, v in pairs( SLC_SETTINGS ) do
		v.value = v.default
	end

	SaveSettings()
	processAllSettings()
end )

--[[-------------------------------------------------------------------------
Binds panel
---------------------------------------------------------------------------]]
AddSettingsPanel( "binds", function( parent )
	local binds = {}

	for k, v in pairs( SLC_SETTINGS ) do
		if v.stype == "bind" then
			table.insert( binds, { name = k, data = v } )
		end
	end

	table.sort( binds, function( a, b ) return a.data.id < b.data.id end )

	local w, h = ScrW(), ScrH()
	for i, v in ipairs( binds ) do
		local pnl = vgui.Create( "DPanel", parent )
		pnl:SetTall( h * 0.08 )
		pnl:Dock( TOP )
		pnl:DockMargin( 0, h * 0.01, 0, 0 )

		pnl.Paint = function( self, pw, ph )
			surface.SetDrawColor( COLOR.border )
			surface.DrawLine( 0, ph - 1, pw, ph - 1 )
		end

		local options_margin = w * 0.008
		local options = vgui.Create( "DPanel", pnl )
		options:SetWide( h * 0.16 )
		options:Dock( RIGHT )
		options:DockPadding( options_margin, options_margin, options_margin, options_margin )

		options.Paint = function( self, pw, ph ) end

		local btn_width = h * 0.08 - options_margin * 1.5

		local clear_btn
		local reset_btn = vgui.Create( "DButton", options )
		reset_btn:SetWide( btn_width )
		reset_btn:Dock( LEFT )
		reset_btn:SetText( "" )
		reset_btn.Paint = function( self, pw, ph )
			if self:IsEnabled() and self:IsHovered() then
				surface.SetDrawColor( COLOR.hover )
				surface.DrawRect( 0, 0, pw, ph )
			end

			surface.SetDrawColor( COLOR.white )
			surface.DrawOutlinedRect( 0, 0, pw, ph )

			if !self:IsEnabled() then
				surface.SetDrawColor( COLOR.inactive )
			end

			local ico_size = pw * 0.4
			surface.SetMaterial( MATS.reset )
			surface.DrawTexturedRect( pw * 0.5 - ico_size * 0.5, ph * 0.5 - ico_size * 0.5, ico_size, ico_size )
		end
		reset_btn.DoClick = function( self )
			v.data.value = v.data.default

			processSettingsEntry( v.name )
			checkForConflicts()
			SaveSettings()

			reset_btn:SetEnabled( v.data.value != v.data.default )
			clear_btn:SetEnabled( v.data.value != "none" )
		end

		local rb_enabled = reset_btn.SetEnabled
		reset_btn.SetEnabled = function( self, enabled )
			self:SetCursor( enabled and "hand" or "arrow" )
			rb_enabled( self, enabled )
		end

		reset_btn:SetEnabled( v.data.value != v.data.default )

		clear_btn = vgui.Create( "DButton", options )
		clear_btn:SetWide( btn_width )
		clear_btn:Dock( RIGHT )
		clear_btn:SetText( "" )
		clear_btn.Paint = function( self, pw, ph )
			if self:IsEnabled() and self:IsHovered() then
				surface.SetDrawColor( COLOR.hover )
				surface.DrawRect( 0, 0, pw, ph )
			end

			surface.SetDrawColor( COLOR.white )
			surface.DrawOutlinedRect( 0, 0, pw, ph )

			if !self:IsEnabled() then
				surface.SetDrawColor( COLOR.inactive )
			end

			local ico_size = pw * 0.4
			surface.SetMaterial( MATS.exit )
			surface.DrawTexturedRect( pw * 0.5 - ico_size * 0.5, ph * 0.5 - ico_size * 0.5, ico_size, ico_size )
		end
		clear_btn.DoClick = function( self )
			v.data.value = "none"

			processSettingsEntry( v.name )
			checkForConflicts()
			SaveSettings()

			reset_btn:SetEnabled( v.data.value != v.data.default )
			clear_btn:SetEnabled( v.data.value != "none" )
		end

		local cb_enabled = clear_btn.SetEnabled
		clear_btn.SetEnabled = function( self, enabled )
			self:SetCursor( enabled and "hand" or "arrow" )
			cb_enabled( self, enabled )
		end

		clear_btn:SetEnabled( v.data.value != "none" )

		local binder = vgui.Create( "DBinder", pnl )
		binder:SetWide( w * 0.15 )
		binder:Dock( RIGHT )
		binder:DockMargin( options_margin, options_margin, options_margin, options_margin )
		binder:SetText( "" )

		binder.SetText = function() end
		binder.DoRightClick = function() end

		binder.Paint = function( self, pw, ph )
			if self:IsHovered() or self.Trapping then
				surface.SetDrawColor( COLOR.hover )
				surface.DrawRect( 0, 0, pw, ph )
			end

			surface.SetDrawColor( COLOR.white )
			surface.DrawOutlinedRect( 0, 0, pw, ph )

			local b_text = ""
			local b_color = COLOR.white

			if self.Trapping then
				b_text = LANG.settings.press_key
			else
				b_text = v.data.key and string.upper( v.data.key ) or LANG.settings.none

				if v.data.bind then
					b_text = b_text.."  /  "..v.data.bind
				end

				if v.data.key_conflict then
					b_color = COLOR.conflict
				end
			end

			draw.Text{
				text = b_text,
				pos = { pw * 0.5, ph * 0.5 },
				font = "SCPHUDSmall",
				color = b_color,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end

		binder.OnChange = function( self, value )
			if value != v.data.key_code then
				if value == 66 then
					v.data.value = "none"
				else
					v.data.value = "key:"..string.upper( input.GetKeyName( value ) )
				end

				reset_btn:SetEnabled( v.data.value != v.data.default )
				clear_btn:SetEnabled( v.data.value != "none" )

				processSettingsEntry( v.name )
				checkForConflicts()
				SaveSettings()
			end
		end

		local name = vgui.Create( "DLabel", pnl )
		name:Dock( FILL )
		name:DockMargin( options_margin, options_margin, options_margin, options_margin )
		name:SetText( "" )

		name.Paint = function( self, pw, ph )
			//surface.SetDrawColor( COLOR.white )
			//surface.DrawOutlinedRect( 0, 0, pw, ph )

			draw.Text{
				text = LANG.settings.binds[v.name] or v.name,
				pos = { 0, ph * 0.5 },
				font = "SCPHUDMedium",
				color = COLOR.white,
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}
		end
	end
end)

--[[-------------------------------------------------------------------------
Reset panel
---------------------------------------------------------------------------]]
AddSettingsPanel( "reset", function( parent )
	local w, h = ScrW(), ScrH()

	local side_panel_left = vgui.Create( "DPanel", parent )
	side_panel_left:SetWide( w * 0.15 )
	side_panel_left:Dock( LEFT )
	side_panel_left.Paint = function() end

	local side_panel_right = vgui.Create( "DPanel", parent )
	side_panel_right:SetWide( w * 0.15 )
	side_panel_right:Dock( RIGHT )
	side_panel_right.Paint = function() end

	local client_btn = vgui.Create( "DButton", parent )
	client_btn:SetTall( h * 0.075 )
	client_btn:Dock( TOP )
	client_btn:DockMargin( 0, h * 0.075, 0, 0 )
	client_btn:SetText( "" )

	client_btn.Paint = function( self, pw, ph )
		if self:IsHovered() then
			surface.SetDrawColor( COLOR.hover )
			surface.DrawRect( 0, 0, pw, ph )
		end

		surface.SetDrawColor( COLOR.white )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		draw.Text{
			text = LANG.settings.client_reset,
			pos = { pw * 0.5, ph * 0.5 },
			font = "SCPHUDMedium",
			color = COLOR.conflict,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end

	client_btn.DoClick = function( self )
		SLCPopupIfEmpty( LANG.settings.client_reset, LANG.settings.client_reset_desc, true, function( i )
			if i == 1 then
				SLC_SETTINGS_WINDOW:Close()
				hook.Run( "SLCFactoryReset" )
			end	
		end, LANG.settings.popup_continue, LANG.settings.popup_cancel )
	end

	if LocalPlayer():IsSuperAdmin() then
		local server_btn = vgui.Create( "DButton", parent )
		server_btn:SetTall( h * 0.075 )
		server_btn:Dock( TOP )
		server_btn:DockMargin( 0, h * 0.2, 0, 0 )
		server_btn:SetText( "" )

		server_btn.Paint = function( self, pw, ph )
			if self:IsHovered() then
				surface.SetDrawColor( COLOR.hover )
				surface.DrawRect( 0, 0, pw, ph )
			end

			surface.SetDrawColor( COLOR.white )
			surface.DrawOutlinedRect( 0, 0, pw, ph )

			draw.Text{
				text = LANG.settings.server_reset,
				pos = { pw * 0.5, ph * 0.5 },
				font = "SCPHUDMedium",
				color = COLOR.conflict,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end

		server_btn.DoClick = function( self )
			SLCPopupIfEmpty( LANG.settings.server_reset, LANG.settings.server_reset_desc, true, nil, LANG.settings.popup_ok )
		end
	end
end )

/*timer.Simple( 0.1, function()
	if IsValid( SLC_SETTINGS_WINDOW ) then SLC_SETTINGS_WINDOW:Close() end
	OpenSettingsWindow()
end )*/