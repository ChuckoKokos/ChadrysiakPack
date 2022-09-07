local assessmentct = 0
hook.Add( "PlayerSay", "RequestDAssessment", function( ply, text )
	if ( string.lower( text ) == "/requestassessment" ) then
		if ply:SCPTeam() == 1 then return end
		if ply:SCPTeam() ~= 4 then timer.Simple( 0.1, function() ply:ChatPrint( "You don't have access to this command." ) end ) return end
		if CurTime() < assessmentct then timer.Simple( 0.1, function() ply:ChatPrint( "This is on cooldown." ) end ) return end
		DAnnouncement()
		assessmentct = CurTime() + 120
	end
end )

function DAnnouncement()
	local DNumber = 0
	for k, v in pairs( ents.FindByClass( "player" ) ) do
		if v:SCPTeam() == TEAM_CLASSD then
		DNumber = DNumber + 1
		else end
	end
	if DNumber > 1 then
		BroadcastLua( 'surface.PlaySound("intercom/AnnouncCameraFound1.mp3")' )
	return end
	if DNumber == 1 then
		BroadcastLua( 'surface.PlaySound("intercom/AnnouncCameraFound2.mp3")' )
	return end
	if DNumber == 0 then
		BroadcastLua( 'surface.PlaySound("intercom/AnnouncCameraNoFound.mp3")' )
	return end
end