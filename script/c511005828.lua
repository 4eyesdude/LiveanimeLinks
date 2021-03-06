--Sword of Dark Destrution (DOR)
--scripted by GameMaster (GM)
function c511005828.initial_effect(c)
--+500atk/def warrior water,fire,wind,dark
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetTarget(c511005828.target)
e1:SetOperation(c511005828.activate)
c:RegisterEffect(e1)
end

function c511005828.filter(c)
return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_WIND+ATTRIBUTE_DARK+ATTRIBUTE_FIRE) and c:IsFaceup()
end

function c511005828.target(e,tp,eg,ep,ev,re,r,rp,chk)
local tc=Duel.GetFirstTarget()
if chk==0 then return Duel.IsExistingTarget(c511005828.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
Duel.SelectTarget(tp,c511005828.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc)
end

function c511005828.activate(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
if tc:IsRelateToEffect(e)  then
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetValue(500)
e1:SetReset(RESET_EVENT+0x1fe0000)
tc:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EFFECT_UPDATE_DEFENSE)
tc:RegisterEffect(e2)
end
end
