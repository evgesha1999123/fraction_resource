function draw_labels()
    local screen_width, screen_height = guiGetScreenSize()
    local client_id = getElementData(getLocalPlayer(), "ID")
    local string_value_id_for_label = "Ваш ID : " .. client_id

    dxDrawText(string_value_id_for_label, 600, screen_height - 540, screen_width, screen_height, tocolor(0, 0, 0, 255), 3.02, "sans")
    dxDrawText(string_value_id_for_label, 600, screen_height - 540, screen_width, screen_height, tocolor(0, 255, 0, 255), 3, "sans")
end


addEventHandler("onClientRender", root, draw_labels)
