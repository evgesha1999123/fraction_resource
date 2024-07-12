function button_decline_invite_event_handler(button)
    if button == "left" then
        guiSetVisible(input_dialog_invite_window, false)
        showCursor(false)
        destroyElement(input_dialog_invite_window)
    end
end

function button_accept_invite_event_handler(button)
    if button == "left" then
        triggerServerEvent("onClientPlayerAcceptInvite", root, getLocalPlayer(), fraction_element)

        guiSetVisible(input_dialog_invite_window, false)
        showCursor(false)
        destroyElement(input_dialog_invite_window)
    end
end

function gui_button_click_handler_on_invite_player(button)
    if button == "left" then
        triggerServerEvent("onClientLeadOfFractionInvitePlayerByGui", root, getLocalPlayer(), guiGetText(edit_entry_id))
    end
end

function redraw_gui_when_player_kicked(gui_members_list_cureselection)
    guiGridListRemoveRow(members_list_content, guiGridListGetSelectedItem(members_list_content))
end

function gui_button_click_handler_on_free_member(button_free_member)
    if button_free_member == "left" then
        local rr, cc = guiGridListGetSelectedItem(members_list_content)
        if guiGridListGetItemText(members_list_content, rr, cc) == getElementID(getLocalPlayer()) then outputChatBox("Нельзя кикать себя", 255, 0, 0) return
        elseif  rr == -1 and cc == 0 then return
        else triggerServerEvent("onClientLeadOfFractionFreeMemberByGui", root, getLocalPlayer(), guiGridListGetItemText(members_list_content, rr, cc)) end
    end
end

function on_gui_draw(fraction_element, message_when_unavailable)
    if not fraction_element then outputChatBox(message_when_unavailable, 255, 255, 255) return 
    else
        if not isElement(window) then
            window = guiCreateWindow(0, 0, 0.5, 0.4, "Панель фракции " .. getTeamName(fraction_element), true)
            local panel_mainframe = guiCreateTabPanel ( 0, 0.1, 1, 1, true, window )
            local tab_list_of_members = guiCreateTab( "Список участников", panel_mainframe )

            members_list_content = guiCreateGridList(0, 0, 1, 0.8, true, tab_list_of_members)
            _member_list_ID = guiGridListAddColumn(members_list_content, "ID", 0.1)
            _member_list_NAME = guiGridListAddColumn(members_list_content, "Имя участника", 0.7)
            
            for xx, player in ipairs(getPlayersInTeam(fraction_element)) do
                guiGridListAddRow(members_list_content, getElementID(player), getPlayerName(player))
            end

            showCursor(true)
            guiWindowSetSizable ( window, false )

            if getElementData(fraction_element, "NAME_OF_LEAD") == getPlayerName(getLocalPlayer()) then 
                local button_free_member = guiCreateButton(0.75, 0.8, 0.2, 0.1, "Уволить", true, tab_list_of_members)
                local tab_city_management = guiCreateTab( "Управление городом", panel_mainframe ) 
                edit_entry_id = guiCreateEdit(0.1, 0.8, 0.2, 0.1, "ID игрока", true, tab_list_of_members)
                local button_invite_player_to_fraction = guiCreateButton(0.4, 0.8, 0.2, 0.1, "Пригласить", true, tab_list_of_members)

                addEventHandler("onClientGUIClick", button_free_member, gui_button_click_handler_on_free_member, false)
                addEventHandler("onClientGUIClick", button_invite_player_to_fraction, gui_button_click_handler_on_invite_player, false)
            end
        else 
            guiSetVisible(window, false)
            showCursor(false)
            destroyElement(window)
        end
    end
end

function handle_fraction_menu_button_press(key)
    triggerServerEvent("validateClientOnGuiDrawEvent", root, getLocalPlayer())
end

function init_client_binds()
    bindKey("p", "down", handle_fraction_menu_button_press)
end

function output_on_client_side(message)
    outputChatBox(message)
end

function send_validation_request_to_server(cmd, ...)
    local message = table.concat ( { ... }, " " )
    local self_element = getLocalPlayer()
    triggerServerEvent("validateClientFractionChatEvent", root, self_element, message)
end

function on_client_recieved_invite_handler(player_id, fraction_name)
    if getElementID(getLocalPlayer()) == player_id and isElement(getTeamFromName(fraction_name)) and (not(isElement(input_dialog_invite_window))) then 
        fraction_element = getTeamFromName(fraction_name)
        input_dialog_invite_window = guiCreateWindow(0.1, 0.3, 0.7, 0.3, "Приглашение от лидера фракции", true)
        local info_label = guiCreateLabel(0.1, 0.3, 1, 0.2,  getElementData(fraction_element, "NAME_OF_LEAD") .. " приглашает вас вступить в " .. fraction_name, true, input_dialog_invite_window)
        local button_accept_invite = guiCreateButton(0.3, 0.5, 0.2, 0.1, "Принять", true, input_dialog_invite_window)
        local button_decline_invite = guiCreateButton(0.6, 0.5, 0.2, 0.1, "Отклонить", true, input_dialog_invite_window)

        showCursor(true)
        guiWindowSetSizable ( window, false )

        addEventHandler("onClientGUIClick", button_accept_invite, button_accept_invite_event_handler, false)
        addEventHandler("onClientGUIClick", button_decline_invite, button_decline_invite_event_handler, false)
    end
end

function on_new_player_join_redraw_gui_event_handler(new_player_element)
    guiGridListAddRow(members_list_content, getElementID(new_player_element), getPlayerName(new_player_element))
end


addEvent("displayMessageForMates", true)

addEvent("onGuiDrawOnClient", true)

addEvent("onGuiMemberListRedraw", true)

addEvent("onClientRecievedInvite", true)

addEvent("onNewPlayerJoinRedrawGui", true)



addCommandHandler("f", send_validation_request_to_server)

addEventHandler("displayMessageForMates", root, output_on_client_side)

addEventHandler("onClientResourceStart", root, init_client_binds)

addEventHandler("onGuiDrawOnClient", root, on_gui_draw)

addEventHandler("onGuiKeyRebind", root, rebind_key_for_close_menu)

addEventHandler("onGuiMemberListRedraw", root, redraw_gui_when_player_kicked)

addEventHandler("onClientRecievedInvite", root, on_client_recieved_invite_handler)

addEventHandler("onNewPlayerJoinRedrawGui", root, on_new_player_join_redraw_gui_event_handler)