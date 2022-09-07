SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "SCP035"

SWEP.WorldModel		= "models/vinrax/props/scp035/035_mask.mdl"

SWEP.ShouldDrawViewModel = false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.Selectable = false

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:OnSelect()
	if SERVER then
		self:Remove()
		self.Owner:SetSCPTeam( TEAM_SCP )
		self.Owner:DropVest()
		self.Owner:SetModel( "models/vinrax/player/035_player.mdl" )
		self.Owner:SetSCPHuman( true )
		self.Owner.Is035 = true
		local maxhealth = self.Owner:GetMaxHealth() * 1.5
		local health = self.Owner:Health() * 1.5
		self.Owner:SetMaxHealth( maxhealth )
		self.Owner:SetHealth( health )
	end
end

function SWEP:DrawWorldModel()
	if !IsValid( self:GetOwner() ) then
		self:DrawModel()
	end
end