function call_fool_label_text(string_fool_text)
    outputChatBox(string_fool_text, root, 255, 0, 0)
end

function unset_leader(player_element)
    if isElement(player_element) then
        setElementData(player_element, "IS_LEAD", nil)
        setElementData(getPlayerTeam(player_element), "NAME_OF_LEAD", nil)
        outputChatBox("LEAD IS NO MORE LEAD!!!")
    end
end

function set_leader(player_element, fraction_element)
    setElementData(player_element, "IS_LEAD", true)
    setElementData(fraction_element, "NAME_OF_LEAD", getPlayerName(player_element))
    outputChatBox(getPlayerName(player_element) .. " is now LEAD!")
end

function set_fraction_data(player_element, fraction_element, prompt_player_id, string_text_when_success, bool_need_to_make_lead)
    if prompt_player_id == getElementID(player_element) then
        if fraction_element == nil and getElementData(player_element, "IS_LEAD") == true then 
            unset_leader(player_element) 
            outputChatBox("Удаление из лидеров - успешно!")
        end

        if bool_need_to_make_lead then
            if not isElement(getPlayerTeam(player_element)) or getTeamName(getPlayerTeam(player_element)) ~= getTeamName(fraction_element) then setPlayerTeam(player_element, fraction_element) end
            if getElementData(player_element, "IS_LEAD") == true and getElementData(fraction_element, "NAME_OF_LEAD") == getPlayerName(player_element) then outputChatBox("Игрок уже является лидером!") return end
            if (getElementData(fraction_element, "NAME_OF_LEAD") ~= false and getElementData(fraction_element, "NAME_OF_LEAD") ~= nil ) and getElementData(fraction_element, "NAME_OF_LEAD") ~= getPlayerName(player_element) then 
                unset_leader(getPlayerFromName(getElementData(fraction_element, "NAME_OF_LEAD")))
                outputChatBox("Лидер переназначен!") 
            end
            set_leader(player_element, fraction_element)
            outputChatBox(string_text_when_success)
            return
        end

        if setPlayerTeam(player_element, fraction_element) then 
            outputChatBox(string_text_when_success)
        else outputChatBox("ОШИБКА!") end
    end 
end

function intersection(prompt_player_id, prompt_fraction_id, cmd)

    if prompt_fraction_id == nil and cmd == "set_player_fraction" and ( isElement(getElementByID(prompt_player_id)) and getElementType(getElementByID(prompt_player_id)) == "player" ) then 
        set_fraction_data(getElementByID(prompt_player_id), nil, prompt_player_id, "Удаление - успешно!", false) 
    elseif prompt_fraction_id == nil and cmd == set_player_fraction and ( not(isElement(getElementByID(prompt_player_id))) or getElementType(getElementByID(prompt_player_id)) ~= "player" ) then
        call_fool_label_text("Синтаксис: /set_player_fraction <ID существующего игрока> <строковый ID существующей фракции> или /set_player_Fraction <ID существующего игрока>, для удаления игрока из фракции")
    end



    if prompt_fraction_id ~= nil and cmd == "set_player_fraction" and (  isElement(getElementByID(prompt_player_id)) and getElementType(getElementByID(prompt_player_id)) == "player" ) and ( isElement(getElementByID(prompt_fraction_id)) and getElementType(getElementByID(prompt_fraction_id)) == "team"  ) then 
        set_fraction_data(getElementByID(prompt_player_id), getElementByID(prompt_fraction_id), prompt_player_id, "Добавление - успешно!", false) 
    elseif prompt_fraction_id ~= nil and cmd == "set_player_fraction" and ( not(isElement(getElementByID(prompt_player_id))) or getElementType(getElementByID(prompt_player_id)) ~= "player" or not(isElement(getElementByID(prompt_fraction_id))) or getElementType(getElementByID(prompt_fraction_id)) ~= "team" ) then
        call_fool_label_text("Синтаксис: /set_player_fraction <ID существующего игрока> <строковый ID существующей фракции> или /set_player_Fraction <ID существующего игрока>, для удаления игрока из фракции")
    end



    if cmd == "set_player_fraction_leader" and ( isElement(getElementByID(prompt_player_id)) and getElementType(getElementByID(prompt_player_id)) == "player" ) and ( isElement(getElementByID(prompt_fraction_id)) and getElementType(getElementByID(prompt_fraction_id)) == "team" ) then 
        set_fraction_data(getElementByID(prompt_player_id), getElementByID(prompt_fraction_id), prompt_player_id, "Назначение лидером - успешно!", true) 
    elseif cmd == "set_player_fraction_leader" and ( not(isElement(getElementByID(prompt_player_id))) or getElementType(getElementByID(prompt_player_id)) ~= "player" or not(isElement(getElementByID(prompt_fraction_id))) or getElementType(getElementByID(prompt_fraction_id)) ~= "team") then
        call_fool_label_text("Синтаксис: /set_player_fraction_leader <ID существующего игрока> <строковый ID существующей фракции>")
    end

end

function validate_input_data(root, cmd, ...)
    if (#{...} == 0) or (#{...} > 2) then call_fool_label_text("Ошибка синтаксиса!") return end
    if #{...} ~= 2 and cmd == "set_player_fraction_leader" then call_fool_label_text("Ошибка синтаксиса!") return end
    if #{...} == 1 and cmd == "set_player_fraction" then 
        local prompt_player_id = table.concat({...}, " ", 1, 1)
        intersection(prompt_player_id, prompt_fraction_id, cmd)
    else
        local prompt_player_id = table.concat({...}, " ", 1, 1)
        local prompt_fraction_id = table.concat({...}, " ", 2, 2)
        intersection(prompt_player_id, prompt_fraction_id, cmd)
    end
end

function send_message_for_mates(self_element, message)
    if isElement(self_element) and getElementType(self_element) == "player" and getPlayerTeam(self_element) then
        local fraction_members_list = getPlayersInTeam(getPlayerTeam(self_element))
        local message = "(* " .. getTeamName(getPlayerTeam(self_element)) .. " *) : " .. getPlayerName(self_element) .. " >> " .. message
        for index = 1, #fraction_members_list do
            triggerClientEvent(fraction_members_list[index], "displayMessageForMates", root, message)
        end
    end
end

function create_fraction(list_of_fractions)
    createTeam("city_mayor")
    setElementID(getTeamFromName("city_mayor"), "city_mayor")
end

function server_check_before_open_gui(client_player_element)
    if isElement(client_player_element) and getElementType(client_player_element) == "player" and getPlayerTeam(client_player_element) then
        triggerClientEvent(client_player_element, "onGuiDrawOnClient", root, getPlayerTeam(client_player_element))
    elseif isElement(client_player_element) and getElementType(client_player_element) == "player" and not (isElement(getPlayerTeam(client_player_element))) then
        triggerClientEvent(client_player_element, "onGuiDrawOnClient", root, getPlayerTeam(client_player_element), "Вступите во фракцию, чтобы открыть меню")
    else triggerClientEvent(client_player_element, "onGuiDrawOnClient", root, getPlayerTeam(client_player_element), "BAD DATA ERROR =C") 
    end
end

function on_client_lead_of_fraction_free_member_by_gui_handler(client_player_element, gui_members_list_cureselection)
    if isElement(client_player_element) and getElementType(client_player_element) == "player" and getPlayerTeam(client_player_element) and getElementData(client_player_element, "IS_LEAD") == true and ( getTeamName(getPlayerTeam(client_player_element)) == getTeamName(getPlayerTeam(getElementByID(gui_members_list_cureselection))) ) then
        set_fraction_data(getElementByID(gui_members_list_cureselection), nil, gui_members_list_cureselection, "Удаление - успешно!", false) 
        triggerClientEvent(client_player_element, "onGuiMemberListRedraw", root, gui_members_list_cureselection)
    end
end

function on_client_lead_of_fraction_invite_player_by_gui(client_player_element, edit_entry_id_value)
    if isElement(client_player_element) and getElementType(client_player_element) == "player" and getPlayerTeam(client_player_element) and getElementData(client_player_element, "IS_LEAD") == true and isElement(getElementByID(edit_entry_id_value)) and getElementType(getElementByID(edit_entry_id_value)) == "player" and getPlayerTeam(getElementByID(edit_entry_id_value)) == false then
        triggerClientEvent(getElementByID(edit_entry_id_value), "onClientRecievedInvite", root, edit_entry_id_value, getTeamName(getPlayerTeam(client_player_element)))
    end
end

function on_client_player_accept_invite_event_handler(client_player_element, fraction_element)
    if isElement(client_player_element) and getElementType(client_player_element) == "player" and isElement(fraction_element) and  ( not isElement(getPlayerTeam(client_player_element)) or (isElement(getPlayerTeam(client_player_element)) and getTeamName( getPlayerTeam(client_player_element)) ~= getTeamName(fraction_element)) ) then
        set_fraction_data(client_player_element, fraction_element, getElementID(client_player_element), "Игрок " .. getPlayerName(client_player_element) .. " теперь участник фракции " .. getTeamName(fraction_element), false)
        triggerClientEvent(getPlayerFromName(getElementData(fraction_element, "NAME_OF_LEAD")), "onNewPlayerJoinRedrawGui", root, client_player_element)
    end
end



addEvent("validateClientOnGuiDrawEvent", true)

addEvent("validateClientFractionChatEvent", true)

addEvent("onClientLeadOfFractionFreeMemberByGui", true)

addEvent("onClientLeadOfFractionInvitePlayerByGui", true)

addEvent("onClientPlayerAcceptInvite", true)


addEventHandler("onResourceStart", root, create_fraction)

addCommandHandler("set_player_fraction_leader", validate_input_data)

addCommandHandler("set_player_fraction", validate_input_data)

addEventHandler("validateClientFractionChatEvent", root, send_message_for_mates)

addEventHandler("validateClientOnGuiDrawEvent", root, server_check_before_open_gui)

addEventHandler("onClientLeadOfFractionFreeMemberByGui", root, on_client_lead_of_fraction_free_member_by_gui_handler)

addEventHandler("onClientLeadOfFractionInvitePlayerByGui", root, on_client_lead_of_fraction_invite_player_by_gui)

addEventHandler("onClientPlayerAcceptInvite", root, on_client_player_accept_invite_event_handler)