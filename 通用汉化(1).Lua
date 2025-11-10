local Translations = {
-- Main 模块
["Enable Hitbox"] = "启用 hitbox",
["Hitbox Size"] = "Hitbox 大小",
["Hitbox Transparency"] = "Hitbox 透明度",
["No Collision"] = "无碰撞",
["Enable Aimbot (Instant)"] = "启用自瞄（瞬间）",
["Aimbot Teammate Check"] = "自瞄队友检测",
["Wall Check (raycast)"] = "穿墙检测（射线）",
["Show FOV Circle"] = "显示 FOV 圈",
["FOV Size"] = "FOV 大小",

-- ESP 模块
["Enable ESP"] = "启用 ESP",
["Show Boxes"] = "显示方框",
["Show Names"] = "显示名称",
["Show Tracers"] = "显示射线",
["Show Health Bars"] = "显示血条",
["Hide Teammates"] = "隐藏队友",
["Ignore Hitbox (force)"] = "强制忽略 Hitbox",

-- Gun Mods 模块
["Galil"] = "加利尔",
["Ak47"] = "AK47",
["AUG"] = "AUG",
["AWP"] = "AWP",
["Nova"] = "Nova 霰弹枪",
["Meg7"] = "MAG7 霰弹枪",
["Famas"] = "法玛斯",
["Negev"] = "内格夫",
["SSG08"] = "SSG08 狙击枪",
["Tec9"] = "Tec9 手枪",
["UMP"] = "UMP 冲锋枪",
["USP"] = "USP 手枪",
["XM1014"] = "XM1014 霰弹枪",
["Zeus"] = "电击枪",
["Apply All Mods"] = "应用所有模组",
["Revert All Mods"] = "还原所有模组",
["M4A1"] = "M4A1",
["G3SG1"] = "G3SG1 狙击枪",
["MP9"] = "MP9 冲锋枪",
["DesertEagle"] = "沙漠之鹰",
["Bizon"] = "野牛冲锋枪",
["DualElites"] = "双持精英手枪",
["Falchion"] = " Falchion 刀",
["Five-Seven"] = "FN57 手枪",
["Glock"] = "格洛克手枪",
["CZ75"] = "CZ75 手枪",
["MP5game"] = "MP5（游戏版）",
["P90"] = "P90 冲锋枪",
["MP7"] = "MP7 冲锋枪",
["MP5"] = "MP5 冲锋枪",
["MAC10"] = "MAC10 冲锋枪",
["M4A4"] = "M4A4"
}

local function translateText(text)
    if not text or type(text) ~= "string" then return text end
    
    if Translations[text] then
        return Translations[text]
    end
    
    for en, cn in pairs(Translations) do
        if text:find(en) then
            return text:gsub(en, cn)
        end
    end
    
    return text
end

local function setupTranslationEngine()
    local success, err = pcall(function()
        local oldIndex = getrawmetatable(game).__newindex
        setreadonly(getrawmetatable(game), false)
        
        getrawmetatable(game).__newindex = newcclosure(function(t, k, v)
            if (t:IsA("TextLabel") or t:IsA("TextButton") or t:IsA("TextBox")) and k == "Text" then
                v = translateText(tostring(v))
            end
            return oldIndex(t, k, v)
        end)
        
        setreadonly(getrawmetatable(game), true)
    end)
    
    if not success then
        warn("元表劫持失败:", err)
       
        local translated = {}
        local function scanAndTranslate()
            for _, gui in ipairs(game:GetService("CoreGui"):GetDescendants()) do
                if (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox")) and not translated[gui] then
                    pcall(function()
                        local text = gui.Text
                        if text and text ~= "" then
                            local translatedText = translateText(text)
                            if translatedText ~= text then
                                gui.Text = translatedText
                                translated[gui] = true
                            end
                        end
                    end)
                end
            end
            
            local player = game:GetService("Players").LocalPlayer
            if player and player:FindFirstChild("PlayerGui") then
                for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
                    if (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox")) and not translated[gui] then
                        pcall(function()
                            local text = gui.Text
                            if text and text ~= "" then
                                local translatedText = translateText(text)
                                if translatedText ~= text then
                                    gui.Text = translatedText
                                    translated[gui] = true
                                end
                            end
                        end)
                    end
                end
            end
        end
        
        local function setupDescendantListener(parent)
            parent.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                    task.wait(0.1)
                    pcall(function()
                        local text = descendant.Text
                        if text and text ~= "" then
                            local translatedText = translateText(text)
                            if translatedText ~= text then
                                descendant.Text = translatedText
                            end
                        end
                    end)
                end
            end)
        end
        
        pcall(setupDescendantListener, game:GetService("CoreGui"))
        local player = game:GetService("Players").LocalPlayer
        if player and player:FindFirstChild("PlayerGui") then
            pcall(setupDescendantListener, player.PlayerGui)
        end
        
        while true do
            scanAndTranslate()
            task.wait(3)
        end
    end
end

task.wait(2)

setupTranslationEngine()

local success, err = pcall(function()
--这下面填加载外部脚本
loadstring(game:HttpGet("https://raw.githubusercontent.com/Joshingtonn123/JoshScript/refs/heads/main/SyrexGenesisXDefuseDivision"))()

end)

if not success then
    warn("加载失败:", err)
end