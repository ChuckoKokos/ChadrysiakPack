SCPTeams = {
	REG = {},
	SCORE = {}
}

local info_num = 0
function SCPTeams.AddTeamInfo( name )
	local key = "INFO_"..string.upper( name )

	if SCPTeams[key] then
		return SCPTeams[key]
	end

	if info_num > 31 then
		ErrorNoHalt( "Cannot add new TeamInfo! Maximum amount is 32\n" )
		return
	end

	local info = bit.lshift( 1, info_num )
	info_num = info_num + 1

	SCPTeams[key] = info

	return info
end

function SCPTeams.Register( name, info, clr, reward, canescape )
	_G["TEAM_"..name] = table.insert( SCPTeams.REG, { info = info or 0, color = clr, name = name, reward = math.floor( reward ), canescape = canescape } )
end

function SCPTeams.AddInfo( team, info )
	local t = SCPTeams.REG[team]
	if t then
		t.info = bit.bor( t.info, info )
	end
end

function SCPTeams.SetupAllies( tab )
	if !istable( tab ) then
		tab = { tab }
	end

	for k, v in pairs( tab ) do
		local t = SCPTeams.REG[v]
		t.relations = t.relations or {}

		for _k, _v in pairs( tab ) do
			if v != _v then
				t.relations[_v] = true
			end
		end
	end
end

function SCPTeams.SetupEscort( team, tab )
	tab = istable( tab ) and tab or { tab }

	local t = SCPTeams.REG[team]
	t.escort = t.escort or {}

	for k, v in pairs( tab ) do
		t.escort[v] = true
	end
end

function SCPTeams.IsAlly( team1, team2 )
	if team1 == team2 then return true end

	local t = SCPTeams.REG[team1]
	if t and t.relations then
		return t.relations[team2] == true
	end
end

function SCPTeams.GetAllies( team, includeSelf )
	local t = SCPTeams.REG[team]

	if t then
		local allies = {}

		if t.relations then
			for k, v in pairs( t.relations ) do
				if v == true then
					table.insert( allies, k )
				end
			end
		end

		if includeSelf then
			table.insert( allies, team )
		end

		return allies
	end
end

function SCPTeams.CanEscort( team1, team2 )
	if !SCPTeams.REG[team1] then return end
	if !SCPTeams.REG[team1].escort then return end

	if team2 == true then
		return true
	end

	return SCPTeams.REG[team1].escort[team2]
end

function SCPTeams.CanEscape( team )
	if !SCPTeams.REG[team] then return end

	return SCPTeams.REG[team].canescape
end

function SCPTeams.GetName( team )
	if !SCPTeams.REG[team] then return end

	return SCPTeams.REG[team].name
end

function SCPTeams.GetColor( team )
	if !SCPTeams.REG[team] then return end

	return SCPTeams.REG[team].color
end

function SCPTeams.GetReward( team )
	if !SCPTeams.REG[team] then return end

	return SCPTeams.REG[team].reward
end

function SCPTeams.SetScore( team, score )
	SCPTeams.SCORE[team] = score
end

function SCPTeams.GetScore( team, score )
	if !SCPTeams.SCORE[team] then
		SCPTeams.SCORE[team] = 0
	end

	return SCPTeams.SCORE[team]
end

function SCPTeams.AddScore( team, score )
	if !SCPTeams.SCORE[team] then
		SCPTeams.SCORE[team] = 0
	end

	SCPTeams.SCORE[team] = SCPTeams.SCORE[team] + score
end

function SCPTeams.HighestScore()
	local score = 0
	local team

	for k, v in pairs( SCPTeams.SCORE ) do
		if v > score then
			score = v
			team = { k }
		elseif v > 0 and v == score then
			table.insert( team, k )
		end
	end

	if !team then
		return
	end

	return #team == 1 and team[1] or team
end

function SCPTeams.ResetScore()
	for k, v in pairs( SCPTeams.SCORE ) do
		SCPTeams.SCORE[k] = 0
	end
end

function SCPTeams.HasInfo( team, info )
	local t = SCPTeams.REG[team]

	if t then
		if !t.info then
			t.info = 0
		end

		return bit.band( t.info, info ) == info
	end
end

function SCPTeams.GetPlayersByTeam( team )
	local plys = {}

	for k, v in pairs( player.GetAll() ) do
		if v:SCPTeam() == team then
			table.insert( plys, v )
		end
	end

	return plys
end

function SCPTeams.GetPlayersByInfo( info, alive )
	local plys = {}

	for k, v in pairs( player.GetAll() ) do
		if SCPTeams.HasInfo( v:SCPTeam(), info ) and ( !alive or v:Alive() ) then
			table.insert( plys, v )
		end
	end

	return plys
end

local ply = FindMetaTable( "Player" )

function ply:SCPTeam()
	if !self.Get_SCPTeam then
		self:DataTables()
	end

	return self:Get_SCPTeam()
end

function ply:SetSCPTeam( team )
	if !self.Set_SCPTeam then
		self:DataTables()
	end

	self:Set_SCPTeam( team )
	self:Set_SCPPersonaT( team )
end

SCPTeams.AddTeamInfo( "ALIVE" )
SCPTeams.AddTeamInfo( "HUMAN" )
SCPTeams.AddTeamInfo( "SCP" )
SCPTeams.AddTeamInfo( "STAFF" )

--TODO team guards
SCPTeams.Register( "SPEC", 0, Color( 150, 150, 150 ), 0 )
SCPTeams.Register( "CLASSD", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_HUMAN ), Color( 242, 125, 25 ), 1, true )
SCPTeams.Register( "SCI", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_HUMAN, SCPTeams.INFO_STAFF ), Color( 60, 200, 215 ), 2, true )
SCPTeams.Register( "MTF", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_HUMAN, SCPTeams.INFO_STAFF ), Color( 30, 50, 180 ), 3, false )
SCPTeams.Register( "CI", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_HUMAN ), Color( 10, 80, 5 ), 3, true )
SCPTeams.Register( "BANDITS", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_HUMAN ), Color( 87, 86, 9 ), 3, true )
SCPTeams.Register( "SCP", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_SCP ), Color( 100, 0, 0 ), 10, true )

SCPTeams.SetupAllies( { TEAM_CLASSD, TEAM_CI } )
SCPTeams.SetupAllies( { TEAM_SCI, TEAM_MTF } )

SCPTeams.SetupEscort( TEAM_MTF, TEAM_SCI )
SCPTeams.SetupEscort( TEAM_CI, TEAM_CLASSD )