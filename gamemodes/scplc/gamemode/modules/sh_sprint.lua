hook.Add( "StartCommand", "SLCSprint", function( ply, cmd )
	if cmd:KeyDown( IN_WALK ) then cmd:RemoveKey( IN_WALK ) end

	if ply:IsBot() then return end
	if ply:SCPTeam() == TEAM_SPEC then return end
	if ply:SCPTeam() == TEAM_SCP then return end
	if SERVER and ply:IsAboutToSpawn() then return end
	if !ply.GetStamina then return end

	if cmd:KeyDown( IN_JUMP ) then
		if ply:OnGround() and !ply:InVehicle() then
			if ply.Exhausted then
				cmd:RemoveKey( IN_JUMP )
			elseif !ply.Jumping then
				ply.Jumping = true
				ply.StaminaRegen = CurTime() + 1.5

				local stamina = ply:GetStamina()
				local mask = ply:GetWeapon( "item_slc_gasmask" )
				if IsValid( mask ) and mask:GetEnabled() and mask:GetUpgraded() then
					stamina = stamina - 5

					if stamina < 0 then
						stamina = 0
					end

					ply:SetStamina( stamina )
				else
					stamina = stamina - 10

					if stamina < 0 then
						stamina = 0
					end

					ply:SetStamina( stamina )
				end
			end
		end
	else
		ply.Jumping = false
	end

	if ply:GetWalkSpeed() == ply:GetRunSpeed() then return end

	if ( ply:OnGround() or ply:WaterLevel() != 0 ) and !ply:InVehicle() then
		if cmd:KeyDown( IN_SPEED ) and ( cmd:KeyDown( IN_FORWARD ) or cmd:KeyDown( IN_BACK ) or cmd:KeyDown( IN_MOVELEFT ) or cmd:KeyDown( IN_MOVERIGHT ) ) and ply:GetMoveType() == MOVETYPE_WALK then
			if ply.Exhausted then
				cmd:RemoveKey( IN_SPEED )
			else
				ply.Running = true
			end
		end
	end

	if ply.Exhausted then
		local ang = ply:EyeAngles()

		if !ply.ExhaustCam then
			ply.ExhaustCam = ang.p
		end

		ply.ExhaustCam = math.Approach( ply.ExhaustCam, 30 + math.TimedSinWave( 0.5, 0, 5 ), 0.1 )
		ang.p = ply.ExhaustCam


		cmd:SetViewAngles( ang )
	elseif ply.ExhaustCam then
		ply.ExhaustCam = nil
	end
end )

hook.Add( "OnPlayerHitGround", "SLCBHop", function( ply, water, floater, speed )
	ply.JumpPenalty = CurTime() + 0.3
end )

hook.Add( "Move", "SLCBHop", function( ply, mv )
	if ply.JumpPenalty and ply.JumpPenalty >= CurTime() then
		local vel = mv:GetVelocity()

		local new = vel * 0.985
		new.z = vel.z

		mv:SetVelocity( new )
	end
end )

local function CalcStamina( ply )
	if !ply.Stamina then
		ply.Stamina = true
		ply.Exhausted = false
		ply.StaminaRegen = 0
		ply.RunCheck = 0
	end

	if !ply.Stamina then return end

	if ply:SCPTeam() == TEAM_SPEC or ROUND.post then
		ply:SetStamina( 100 )
		ply.Exhausted = false

		if SERVER and ply.Breathing then
			ply.Breathing = false
			ply:StopSound( "SLCPlayer.Breathing" )
		end

		return
	end

	local stamina = ply:GetStamina()
	local max_stamina = ply:GetMaxStamina()
	local stamina_limit = ply:GetStaminaLimit()
	//print( ply, max_stamina )

	local data = {
		regen_delay = 0.2,
		regen_rate_exhausted = 1,
		regen_rate = 2,
		regen_rate_mask = 4,

		use_delay = 0.125,
		regen_delay_running = 1,
		use_rate = 1,
		use_rate_mask = 0.5,
	}
	
	local skip = hook.Run( "SLCStamina", ply, data, stamina, max_stamina, stamina_limit )
	if skip then
		return
	end

	if stamina_limit > max_stamina then
		stamina_limit = max_stamina
	end

	if ply.StaminaRegen < CurTime() then
		ply.StaminaRegen = CurTime() + data.regen_delay

		local mask = ply:GetWeapon( "item_slc_gasmask" )
		if ply.Exhausted then
			stamina = stamina + data.regen_rate_exhausted
		elseif IsValid( mask ) and mask:GetEnabled() and mask:GetUpgraded() then
			stamina = stamina + data.regen_rate_mask
		else
			stamina = stamina + data.regen_rate
		end
	end

	if stamina > stamina_limit then
		stamina = stamina_limit
	end

	if ply.RunCheck < CurTime() then
		ply.RunCheck = CurTime() + data.use_delay

		if ply.Running then
			ply.Running = false
			ply.StaminaRegen = CurTime() + data.regen_delay_running

			local mask = ply:GetWeapon( "item_slc_gasmask" )
			if IsValid( mask ) and mask:GetEnabled() and mask:GetUpgraded() then
				//ply.Stamina = math.max( ply.Stamina - 1, 0 )
				stamina = stamina - data.use_rate_mask

				if stamina < 0 then
					stamina = 0
				end
			else
				//ply.Stamina = math.max( ply.Stamina - 1, 0 )
				stamina = stamina - data.use_rate

				if stamina < 0 then
					stamina = 0
				end
			end
		end
	end

	if stamina <= 0 and !ply.Exhausted then
		ply.Exhausted = true

		if SERVER then
			ply:PushSpeed( 0.2, -1, -1, "SLC_Exhaust" )
		end
	elseif stamina >= 30 and ply.Exhausted then
		ply.Exhausted = false

		if SERVER then
			ply:PopSpeed( "SLC_Exhaust" )
			ply.StaminaSpeed = 0
		end
	end

	if SERVER then
		if stamina < 50 and !ply.Breathing then
			ply.Breathing = true
			ply:EmitSound( "SLCPlayer.Breathing" )
		elseif stamina > 50 and ply.Breathing then
			ply.Breathing = false
			ply:StopSound( "SLCPlayer.Breathing" )
		end
	end

	ply:SetStamina( stamina )
end

hook.Add( "Tick", "SCPStaminaTick", function()
	if SERVER then
		for k, ply in pairs( player.GetAll() ) do
			CalcStamina( ply )
		end
	else
		CalcStamina( LocalPlayer() )
	end
end )