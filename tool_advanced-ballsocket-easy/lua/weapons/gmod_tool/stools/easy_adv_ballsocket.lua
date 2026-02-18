--Easy Advanced Ballsocket by PTugaSantos

TOOL.Category = "Constraints"
TOOL.Name = "Easy Advanced Ballsocket"

TOOL.ClientConVar[ "xlock" ] = 0
TOOL.ClientConVar[ "ylock" ] = 0
TOOL.ClientConVar[ "zlock" ] = 0
TOOL.ClientConVar[ "onlyrotation" ] = 1
TOOL.ClientConVar[ "nocollide" ] = 1
TOOL.ClientConVar[ "lockvalue" ] = 0.1

if CLIENT then
    language.Add( "tool.easy_adv_ballsocket.name", "Easy Advanced Ballsocket" )
    language.Add( "tool.easy_adv_ballsocket.desc", "It does Magic's!" )
    language.Add( "tool.easy_adv_ballsocket.0", "Primary: Select first entity." )
	language.Add( "tool.easy_adv_ballsocket.1", "Primary: Select second entity.")
	language.Add( "tool.easy_adv_ballsocket.xlock", "Lock X-Axis.")
	language.Add( "tool.easy_adv_ballsocket.ylock", "Lock Y-Axis.")
	language.Add( "tool.easy_adv_ballsocket.zlock", "Lock Z-Axis.")
	language.Add( "tool.easy_adv_ballsocket.onlyrotation", "Free Movement.")
	language.Add( "tool.easy_adv_ballsocket.nocollide", "No-Collide Entities.")
end

local function IsReallyValid( Ent )
	if Ent and Ent:IsValid() and not Ent:IsPlayer() or Ent:IsWorld() then return true end
end

local function MessagePlayer( Ply, Msg )
	Ply:SendLua( "GAMEMODE:AddNotify('" .. Msg .. "',NOTIFY_GENERIC,7);" )
end

function TOOL:LeftClick( trace )
	local Ent = trace.Entity
	local Ply = self:GetOwner()
	if not IsReallyValid( Ent ) then return false end
	
	if (self:GetStage() == 0) then if Ent:IsWorld() then return false end end -- First Entity cant be World!
	
	if CLIENT then return true end -- Is Client?
	
	if (self:GetStage() == 0) then
		if Ent:IsWorld() then return false end
	
		self.Ent = Ent
		
		self:SetStage(1)
	elseif (self:GetStage() == 1) then
		local Constraints = {}
	
		local XLock = self:GetClientNumber( "xlock", 0 )
		local YLock = self:GetClientNumber( "ylock", 0 ) 
		local ZLock = self:GetClientNumber( "zlock", 0 )
		local Lock_Value = self:GetClientNumber( "lockvalue", 0 )
		
		local OnlyRotation = self:GetClientNumber( "onlyrotation", 0 )
		local NoCollide = self:GetClientNumber( "nocollide", 0 )
		
		if (XLock == 0) and (YLock == 0) and (ZLock == 0) then
			MessagePlayer( Ply, "[ERROR] Any Lock Selected!" )
			
			self:SetStage(0)
			
			return false
		end
		
		if (XLock == 1) then
			local Constraint = constraint.AdvBallsocket( self.Ent, Ent, 0, 0, Vector(0, 0, 0), Vector(0, 0, 0), 0, 0, -Lock_Value, -180, -180, Lock_Value, 180, 180, 0, 0, 0, OnlyRotation, NoCollide )
			table.Add( Constraints, {Constraint} )
		end
			
		if (YLock == 1) then
			local Constraint = constraint.AdvBallsocket( self.Ent, Ent, 0, 0, Vector(0, 0, 0), Vector(0, 0, 0), 0, 0, -180, -Lock_Value, -180, 180, Lock_Value, 180, 0, 0, 0, OnlyRotation, NoCollide )
			table.Add( Constraints, {Constraint} )
		end
			
		if (ZLock == 1) then
			local Constraint = constraint.AdvBallsocket( self.Ent, Ent, 0, 0, Vector(0, 0, 0), Vector(0, 0, 0), 0, 0, -180, -180, -Lock_Value, 180, 180, Lock_Value, 0, 0, 0, OnlyRotation, NoCollide )
			table.Add( Constraints, {Constraint} )
		end
		
		local Constraint = constraint.AdvBallsocket( self.Ent, Ent, 0, 0, Vector(0, 0, 0), Vector(0, 0, 0), 0, 0, ((XLock == 1) and -Lock_Value or -180), ((YLock == 1) and -Lock_Value or -180), ((ZLock == 1) and -Lock_Value or -180), ((XLock == 1) and Lock_Value or 180), ((YLock == 1) and Lock_Value or 180), ((ZLock == 1) and Lock_Value or 180), 0, 0, 0, OnlyRotation, NoCollide )
		table.Add( Constraints, {Constraint} )
		
		undo.Create( "Easy Advanced Ballsocket" )
			for Key, Constraint in pairs( Constraints ) do
				undo.AddEntity( Constraint )
			end
			undo.SetPlayer( Ply )
		undo.Finish()
		
		self:SetStage(0)
		
		MessagePlayer( Ply, "Advanced Ballsocket created successfully!" )
	end
	
	return true
end

function TOOL:Reload( trace )
	if not (self:GetStage() == 0) then return false end
	
	local Ply = self:GetOwner()
	
	local Ent = trace.Entity
	if not IsReallyValid( Ent ) then return false end

	if CLIENT then return true end -- Is Client?
	
	local Removed = constraint.RemoveConstraints( Ent, "AdvBallsocket" )
	
	if Removed then
		MessagePlayer( Ply, "Advanced Ballsocket removed successfully!" )
	end
	
	return true
end

function TOOL.BuildCPanel( Panel )
	Panel:AddControl("Header", {
		Text = "Easy Advanced Ballsocket",
		Description = "Settings:"
	})
	
	Panel:AddControl("CheckBox", {
		Label = "#tool.easy_adv_ballsocket.xlock",
		Description = "",
		Command = "easy_adv_ballsocket_xlock"
	})
	
	Panel:AddControl("CheckBox", {
		Label = "#tool.easy_adv_ballsocket.ylock",
		Description = "",
		Command = "easy_adv_ballsocket_ylock"
	})
	
	Panel:AddControl("CheckBox", {
		Label = "#tool.easy_adv_ballsocket.zlock",
		Description = "",
		Command = "easy_adv_ballsocket_zlock"
	})
	
	Panel:AddControl("Label", {
		Text = ""
	})
	
	Panel:AddControl("CheckBox", {
		Label = "#tool.easy_adv_ballsocket.onlyrotation",
		Description = "",
		Command = "easy_adv_ballsocket_onlyrotation"
	})
	
	Panel:AddControl("CheckBox", {
		Label = "#tool.easy_adv_ballsocket.nocollide",
		Description = "",
		Command = "easy_adv_ballsocket_nocollide"
	})
end