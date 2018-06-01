--Battle City
--Scripted by Edo9300
--Updated by Larry126
function c511004014.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(0xff)
	e1:SetOperation(c511004014.op)
	c:RegisterEffect(e1)
	local proc=Duel.SendtoGrave
	Duel.SendtoGrave=function(tg,r,tp)
		if tp then
			if userdatatype(tg)=='Card' then
				tg:RegisterFlagEffect(511004018,RESET_EVENT+0x1fe0000,0,1)
			elseif userdatatype(tg)=='Group' then
				for tc in aux.Next(tg) do tc:RegisterFlagEffect(511004018,RESET_EVENT+0x1fe0000,0,1) end
			end
			return proc(tg,r,tp)
		end
		return proc(tg,r,tp)
	end
end
function c511004014.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,511004014)==0 and Duel.GetFlagEffect(1-tp,511004014)==0 then
		Duel.ConfirmCards(1-tp,c)
		Duel.RegisterFlagEffect(tp,511004014,0,0,0)
		--To controler's grave
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE) 
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetTarget(c511004014.reptg)
		e1:SetValue(c511004014.repval)
		Duel.RegisterEffect(e1,tp)
		--Double Tribute
		local e2=Effect.GlobalEffect()
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e2:SetCode(EFFECT_DOUBLE_TRIBUTE)
		e2:SetTarget(function(e,c)return c:GetSummonLocation()==LOCATION_EXTRA and c:GetMaterialCount()==2 end)
		e2:SetValue(1)
		Duel.RegisterEffect(e2,tp)
		--Triple Tribute
		local e2a=Effect.GlobalEffect()
		e2a:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2a:SetType(EFFECT_TYPE_FIELD)
		e2a:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e2a:SetCode(EFFECT_DOUBLE_TRIBUTE)
		e2a:SetTarget(function(e,c)return c:GetSummonLocation()==LOCATION_EXTRA and c:GetMaterialCount()>=3 end)
		e2a:SetValue(1)
		Duel.RegisterEffect(e2a,tp)
		--faceup def
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DEVINE_LIGHT)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetTargetRange(1,1)
		Duel.RegisterEffect(e3,tp)
		--summon with 3 tribute
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetCode(EFFECT_LIMIT_SUMMON_PROC)
		e4:SetTargetRange(0xff,0xff)
		e4:SetTarget(function(e,c)return c:GetLevel()>=10 and c:GetFlagEffect(511004015)==1 end)
		e4:SetCondition(c511004014.ttcon)
		e4:SetOperation(c511004014.ttop)
		e4:SetValue(SUMMON_TYPE_ADVANCE)
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetTarget(function(e,c)return c:GetLevel()>=10 and c:GetFlagEffect(511004017)==1 end)
		e5:SetCode(EFFECT_LIMIT_SET_PROC)
		Duel.RegisterEffect(e5,tp)
		--Cannot Attack
		local e6=Effect.GlobalEffect()
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_CANNOT_ATTACK)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE) 
		e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e6:SetTarget(function(e,c) return c:IsStatus(STATUS_SPSUMMON_TURN) and (c:GetSummonLocation()==LOCATION_EXTRA or (c:IsAttribute(ATTRIBUTE_DEVINE) and c:GetSummonLocation()==LOCATION_GRAVE)) and c:GetFlagEffect(511004016)==0 end)
		Duel.RegisterEffect(e6,tp)
		--Quick
		local e7=Effect.GlobalEffect()
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_BECOME_QUICK)
		e7:SetTargetRange(0xff,0xff)
		e7:SetCondition(function(e)return Duel.GetCurrentPhase()>=0x08 and Duel.GetCurrentPhase()<=0x80 end)
		Duel.RegisterEffect(e7,tp)
		local e7a=Effect.GlobalEffect()
		e7a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e7a:SetType(EFFECT_TYPE_FIELD)
		e7a:SetCode(EFFECT_BECOME_QUICK)
		e7a:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e7a:SetTarget(function(e,c) return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown() and Duel.GetTurnPlayer()~=c:GetControler() end)
		Duel.RegisterEffect(e7a,tp)
		--Negate
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE) 
		e8:SetCode(EVENT_CHAIN_SOLVING)
		e8:SetOperation(c511004014.negop)
		Duel.RegisterEffect(e8,tp)
		local e9=e8:Clone()
		e9:SetCode(EVENT_DESTROYED)
		e9:SetOperation(c511004014.negop2)
		Duel.RegisterEffect(e9,tp)
		--block
		local e10=Effect.GlobalEffect()
		e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e10:SetCode(EVENT_SUMMON_SUCCESS)
		e10:SetOperation(c511004014.block)
		Duel.RegisterEffect(e10,tp)
		local e10a=e10:Clone()
		e10a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(e10a,tp)
		local e10b=e10:Clone()
		e10b:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e10b,tp)
		--Attack
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE) 
		e11:SetCode(EVENT_LEAVE_FIELD)
		e11:SetCondition(function(e,tp) local ph=Duel.GetCurrentPhase() return ph>=PHASE_BATTLE_STEP and ph<PHASE_DAMAGE
			and Duel.GetAttackTarget()~=nil and not Duel.GetAttackTarget():IsReason(REASON_BATTLE) and Duel.GetAttackTarget():GetFlagEffect(511004019)==0 end)
		e11:SetOperation(function() Duel.NegateAttack() end)
		Duel.RegisterEffect(e11,tp)
		local e11a=e11:Clone()
		e11a:SetCode(EVENT_BE_MATERIAL)
		Duel.RegisterEffect(e11a,tp)
		if Duel.SelectYesNo(tp,aux.Stringid(4013,14)) and Duel.SelectYesNo(tp,aux.Stringid(4013,14)) then
			--manga rules
			local e12=Effect.GlobalEffect()
			e12:SetType(EFFECT_TYPE_FIELD)
			e12:SetCode(EFFECT_HAND_LIMIT)
			e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e12:SetTargetRange(1,1)
			e12:SetValue(7)
			Duel.RegisterEffect(e12,tp)
			local e13=e12:Clone()
			e13:SetCode(EFFECT_MAX_MZONE)
			e13:SetValue(c511004014.mvalue)
			Duel.RegisterEffect(e13,tp)
			local e14=e12:Clone()
			e14:SetCode(EFFECT_MAX_SZONE)
			e14:SetValue(c511004014.svalue)
			Duel.RegisterEffect(e14,tp)
			local e15=e12:Clone()
			e15:SetCode(EFFECT_CANNOT_ACTIVATE)
			e15:SetValue(c511004014.aclimit)
			Duel.RegisterEffect(e15,tp)
			local e16=e12:Clone()
			e16:SetCode(EFFECT_CANNOT_SSET)
			e16:SetTarget(c511004014.setlimit)
			Duel.RegisterEffect(e16,tp)
			local e17=Effect.GlobalEffect()
			e17:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e17:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e17:SetCode(EVENT_CHAINING)
			e17:SetOperation(c511004014.aclimit1)
			Duel.RegisterEffect(e17,tp)
			local e18=e17:Clone()
			e18:SetCode(EVENT_CHAIN_NEGATED)
			e18:SetOperation(c511004014.aclimit2)
			Duel.RegisterEffect(e18,tp)
			local e19=e17:Clone()
			e19:SetCode(EVENT_SSET)
			e19:SetOperation(c511004014.checkop)
			Duel.RegisterEffect(e19,tp)
		end
	end
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	if c:IsPreviousLocation(LOCATION_HAND) then
		Duel.Draw(tp,1,REASON_RULE)
	end
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsHasEffect),tp,0xff,0xff,nil,EFFECT_LIMIT_SUMMON_PROC)
	local g2=Duel.GetMatchingGroup(aux.NOT(Card.IsHasEffect),tp,0xff,0xff,nil,EFFECT_LIMIT_SET_PROC)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(511004015,0,0,0)
	end
	for tc2 in aux.Next(g2) do
		tc2:RegisterFlagEffect(511004017,0,0,0)
	end
end
function c511004014.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetTributeCount(c)>=3
end
function c511004014.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c511004014.negop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetFlagEffect(511000173)>0 and re:IsActiveType(TYPE_TRAP+TYPE_SPELL) then
		Duel.NegateEffect(ev)
	end
end
function c511004014.negop2(e,tp,eg,ep,ev,re,r,rp)
	for ec in aux.Next(eg) do
		ec:RegisterFlagEffect(511000173,0,RESET_CHAIN,1)
	end
end
function c511004014.tgfilter(c,te)
	return c:IsCanBeEffectTarget(te) and c:IsControler(tp)
end
function c511004014.atgfilter(c,ap)
	return Duel.GetAttacker():GetAttackableTarget():IsContains(c) and c:IsControler(ap)
end
function c511004014.block(e,tp,eg,ep,ev,re,r,rp)
	local te,tg=Duel.GetChainInfo(ev+1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	if te and te~=re and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and #tg==1 then
		local g=eg:Filter(c511004014.tgfilter,nil,te,tg:GetFirst():GetControler())
		if #g>0 and Duel.SelectYesNo(g:GetFirst():GetSummonPlayer(),aux.Stringid(68823957,1)) then
			local p=g:GetFirst():GetSummonPlayer()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TARGET)
			local rg=g:Select(p,1,1,nil)
			Duel.ChangeTargetCard(ev+1,rg)
		end
	end
	local ac=Duel.GetAttacker()
	if (Duel.CheckEvent(EVENT_BE_BATTLE_TARGET) or Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE))
		and not ac:IsStatus(STATUS_ATTACK_CANCELED) then
		local ap=1-ac:GetControler()
		local at=Duel.GetAttackTarget()
		local ag=eg:Filter(c511004014.atgfilter,nil,ap)
		if #ag>0 and Duel.SelectYesNo(ag:GetFirst():GetSummonPlayer(),aux.Stringid(68823957,0)) then
			local p=ag:GetFirst():GetSummonPlayer()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATTACKTARGET)
			local atg=ag:Select(p,1,1,nil)
			Duel.HintSelection(atg)
			Duel.ChangeAttackTarget(atg:GetFirst())
			atg:GetFirst():RegisterFlagEffect(511004019,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
		else
			Duel.ChangeAttackTarget(at)
			if at then at:RegisterFlagEffect(511004019,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1) end		 
		end
	end
end
function c511004014.repfilter(c)
	return c:GetDestination()==LOCATION_GRAVE and c:GetFlagEffect(511004018)==0 and c:GetControler()~=c:GetOwner()
end
function c511004014.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c511004014.repfilter,1,nil) end
	local g=eg:Filter(c511004014.repfilter,nil)
	for c in aux.Next(g) do
		if c:GetReason()&REASON_DESTROY==REASON_DESTROY then
			c:RegisterFlagEffect(511000173,RESET_CHAIN,0,1)
		end
		Duel.SendtoGrave(c,c:GetReason(),c:GetControler())
	end
	return true
end
function c511004014.repval(e,c)
	return c:GetControler()~=c:GetOwner() and c:GetDestination()==LOCATION_GRAVE and c:GetFlagEffect(511004018)==0
end
function c511004014.mvalue(e,fp,rp,r)
	return 5-Duel.GetFieldGroupCount(fp,LOCATION_SZONE,0)
end
function c511004014.svalue(e,fp,rp,r)
	local ct=5
	for i=5,7 do
		if Duel.GetFieldCard(fp,LOCATION_SZONE,i) then ct=ct-1 end
	end
	return ct-Duel.GetFieldGroupCount(fp,LOCATION_MZONE,0)
end
function c511004014.acfilter(c)
	return c:GetFlagEffect(EFFECT_TYPE_ACTIVATE)>0
end
function c511004014.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	if re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsLocation(LOCATION_HAND) then
		return Duel.IsExistingMatchingCard(c511004014.acfilter,tp,0xff,0,1,nil)
	end
	if re:IsActiveType(TYPE_FIELD) then
		return not Duel.GetFieldCard(tp,LOCATION_SZONE,5) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>4
	elseif re:IsActiveType(TYPE_PENDULUM) then
		return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>4
	end
	return false
end
function c511004014.setlimit(e,c,tp)
	return (((c:IsType(TYPE_SPELL) and Duel.GetFlagEffect(c:GetControler(),TYPE_SPELL)>0)
		or (c:IsType(TYPE_TRAP) and Duel.GetFlagEffect(c:GetControler(),TYPE_TRAP)>0)) and c:IsLocation(LOCATION_HAND))
		or (c:IsType(TYPE_FIELD) and not Duel.GetFieldCard(tp,LOCATION_SZONE,5) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>4)
end
function c511004014.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsPreviousLocation(LOCATION_HAND) then
		re:GetHandler():RegisterFlagEffect(EFFECT_TYPE_ACTIVATE,RESET_PHASE+PHASE_END,0,1)
	end
end
function c511004014.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsPreviousLocation(LOCATION_HAND) then
		re:GetHandler():ResetFlagEffect(EFFECT_TYPE_ACTIVATE)
	end
end
function c511004014.checkop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND)
	if #hg>0 then
		if hg:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
			Duel.RegisterFlagEffect(rp,TYPE_SPELL,RESET_PHASE+PHASE_END,0,1)
		end
		if hg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
			Duel.RegisterFlagEffect(rp,TYPE_TRAP,RESET_PHASE+PHASE_END,0,1)
		end
	end
end