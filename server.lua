function set_id_for_players()
    local all_players_list = getElementsByType("player")
    for index = 1, #all_players_list do                     
        setElementID(all_players_list[index], "" .. index)
        setElementData(all_players_list[index], "NAME", getPlayerName(all_players_list[index]))
        setElementData(all_players_list[index], "ID", index) -- Я уже потом понял, что есть setElementID, больше не буду так делать
        outputDebugString("PLAYER [" .. getElementData(all_players_list[index], "NAME") .. "] ID [" .. getElementData(all_players_list[index], "ID") .. "]")
    end
end

addEventHandler("onResourceStart", root, set_id_for_players)

addEventHandler("onPlayerJoin", root, set_id_for_players)

addEventHandler("onPlayerQuit", root, set_id_for_players)