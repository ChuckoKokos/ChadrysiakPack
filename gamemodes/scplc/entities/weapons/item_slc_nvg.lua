SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "NVG"

SWEP.WorldModel		= "models/mishka/models/nvg.mdl"

SWEP.ShouldDrawViewModel = false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.Selectable 	= false
SWEP.Toggleable 	= true
SWEP.EnableHolsterThink	= true
SWEP.HasBattery 	= true
SWEP.HolsterBatteryUsage = true
SWEP.BatteryUsage 	= 1

SWEP.scp914upgrade = "item_slc_nvgplus"

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:Think()
	self:CallBaseClass( "Think" )

	/*local wep = self.Owner:GetWeapon( "item_slc_nvgplus" ) --REMOVE

	if IsValid( wep ) and wep:GetEnabled() and self:GetBattery() > 0 then
		wep:SetEnabled( false )
	end*/
end

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	end
end

if CLIENT then
	local overlay = Material( "effects/combine_binocoverlay" )
	hook.Add( "SLCScreenMod", "NVG", function( clr )
		local ply = LocalPlayer()
		local wep = ply:GetWeapon( "item_slc_nvg" )
		local wep2 = ply:GetWeapon( "item_slc_nvgplus" )

		if IsValid( wep ) and wep:GetEnabled() and wep:GetBattery() > 0 then
			render.SetMaterial( overlay )
			render.DrawScreenQuad()

			DrawBloom( 0.2, 5, 7, 7, 3, 1, 1, 1, 1 )

			clr.colour = 0.5
			clr.brightness = clr.brightness
			clr.contrast = clr.contrast + 2
			clr.add_g = -0.01
			clr.add_r = -0.1
			clr.add_b = -0.1
			clr.mul_g = 2
		elseif IsValid( wep2 ) and wep2:GetEnabled() and wep2:GetBattery() > 0 then
			render.SetMaterial( overlay )
			render.DrawScreenQuad()

			DrawBloom( 0.2, 5, 7, 7, 3, 1, 1, 1, 1 )

			clr.colour = 0.5
			clr.brightness = clr.brightness
			clr.contrast = clr.contrast + 2
			clr.add_g = -0.1
			clr.add_r = -0.1
			clr.add_b = 0.2
			clr.mul_g = 2
		end
	end )
end

function SWEP:OnSelect()
	if self:GetBattery() <= 0 then return end
	self:SetEnabled( !self:GetEnabled() )
end

hook.Add( "HUDPaint", "NVGPLUSWALLHACK", function()
	local wep = ply:GetWeapon( "item_slc_nvgplus" )
	if IsValid( wep ) and wep:GetEnabled() then
		for k, v in pairs( ents.FindInSphere( wep.Owner:GetPos(), 2048 ) ) do
			if v:IsPlayer() == true and v:SCPClass() ~= "spectator" then
				local Name = v:SCPClass()
				local Position = ( v:GetPos() ):ToScreen()
				local Dist = math.floor(v:GetPos():Distance(wep.Owner:GetShootPos())/40)
				local color = Color( 255, 255, 255 )
				draw.DrawText( Name.. " ["..Dist.."]", "DermaDefault", Position.x, Position.y, Color( 255, 255, 255, 255 ), 1 )
			else end
		end
	end
end )