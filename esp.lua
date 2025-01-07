local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local espEnabled = false
local aimEnabled = false
local wallhackEnabled = false

-- Hàm tạo thông báo hiển thị
local function showNotification(message)
    local gui = Instance.new("ScreenGui")
    gui.Name = "NotificationGUI"
    gui.Parent = player.PlayerGui

    local textLabel = Instance.new("TextLabel", gui)
    textLabel.Size = UDim2.new(0.5, 0, 0.1, 0) -- Kích thước giao diện
    textLabel.Position = UDim2.new(0.25, 0, 0.1, 0) -- Vị trí ở giữa trên màn hình
    textLabel.BackgroundColor3 = Color3.new(0, 0, 0) -- Màu nền đen
    textLabel.BackgroundTransparency = 0.5 -- Độ trong suốt
    textLabel.TextColor3 = Color3.new(1, 1, 1) -- Màu chữ trắng
    textLabel.TextScaled = true -- Chữ tự động co giãn
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Text = message

    -- Tự động xóa thông báo sau 5 giây
    wait(5)
    gui:Destroy()
end

-- Hàm tạo Beam (tia)
local function createBeam(origin, target, color)
    local attachment1 = Instance.new("Attachment", origin)
    local attachment2 = Instance.new("Attachment", target)

    local beam = Instance.new("Beam", origin)
    beam.Attachment0 = attachment1
    beam.Attachment1 = attachment2
    beam.FaceCamera = true
    beam.Width0 = 0.1
    beam.Width1 = 0.1
    beam.Color = ColorSequence.new(color) -- Tia có thể thay đổi màu
    beam.LightEmission = 1
    return beam
end

-- Hàm tìm kẻ địch gần nhất
local function findNearestEnemy()
    local closestEnemy = nil
    local closestDistance = math.huge -- Khoảng cách ban đầu là vô cực

    for _, obj in pairs(game.Players:GetPlayers()) do
        if obj ~= player and obj.Character and obj.Character:FindFirstChild("Humanoid") then
            local enemyCharacter = obj.Character
            local distance = (character.PrimaryPart.Position - enemyCharacter.PrimaryPart.Position).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestEnemy = enemyCharacter
            end
        end
    end
    return closestEnemy
end

-- Hàm ESP (Hiển thị kẻ địch và đồng đội với màu khác nhau)
local function updateESP()
    for _, obj in pairs(game.Players:GetPlayers()) do
        if obj.Character and obj.Character:FindFirstChild("Humanoid") then
            local enemyCharacter = obj.Character
            local humanoid = enemyCharacter.Humanoid

            -- Tạo tia tới kẻ địch
            local beamColor = (obj.Team == player.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)  -- Xanh cho đồng đội, Đỏ cho kẻ địch
            createBeam(character.PrimaryPart, enemyCharacter.PrimaryPart, beamColor)
        end
    end
end

-- Hàm Aim tự động vào kẻ địch gần nhất
local function autoAim()
    while aimEnabled do
        local enemy = findNearestEnemy()
        if enemy then
            -- Tự động nhắm vào kẻ địch
            character:SetPrimaryPartCFrame(CFrame.new(character.PrimaryPart.Position, enemy.PrimaryPart.Position))
        end
        wait(0.1)  -- Lặp lại mỗi 0.1 giây
    end
end

-- Hàm hiển thị menu giao diện
local function createMenu()
    -- Nếu menu đã tồn tại, không tạo lại
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("MenuGUI") then return end

    local gui = Instance.new("ScreenGui")
    gui.Name = "MenuGUI"
    gui.Parent = player.PlayerGui

    -- Tạo khung menu
    local menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 300, 0, 250)
    menuFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
    menuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    menuFrame.Parent = gui

    -- Tạo tiêu đề menu
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    titleLabel.Text = "Xuyên X Hub 🇻🇳"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = menuFrame

    -- Tạo avatar (cờ Việt Nam)
    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(0, 40, 0, 40)
    avatarImage.Position = UDim2.new(0, 10, 0, 10)
    avatarImage.Image = "rbxassetid://6460073050"  -- Cờ Việt Nam (hãy thay đổi asset ID nếu cần)
    avatarImage.Parent = menuFrame

    -- Tạo nút ESP
    local espButton = Instance.new("TextButton")
    espButton.Size = UDim2.new(1, 0, 0, 50)
    espButton.Position = UDim2.new(0, 0, 0.1, 0)
    espButton.Text = "Bật/Tắt ESP"
    espButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    espButton.TextColor3 = Color3.new(1, 1, 1)
    espButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        showNotification("ESP " .. (espEnabled and "Bật" or "Tắt"))
    end)
    espButton.Parent = menuFrame

    -- Tạo nút Aimbot
    local aimbotButton = Instance.new("TextButton")
    aimbotButton.Size = UDim2.new(1, 0, 0, 50)
    aimbotButton.Position = UDim2.new(0, 0, 0.3, 0)
    aimbotButton.Text = "Bật/Tắt Aimbot"
    aimbotButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    aimbotButton.TextColor3 = Color3.new(1, 1, 1)
    aimbotButton.MouseButton1Click:Connect(function()
        aimEnabled = not aimEnabled
        if aimEnabled then
            autoAim()  -- Bắt đầu aim tự động nếu bật tính năng
        end
        showNotification("Aimbot " .. (aimEnabled and "Bật" or "Tắt"))
    end)
    aimbotButton.Parent = menuFrame

    -- Tạo nút Xuyên Tường
    local wallhackButton = Instance.new("TextButton")
    wallhackButton.Size = UDim2.new(1, 0, 0, 50)
    wallhackButton.Position = UDim2.new(0, 0, 0.5, 0)
    wallhackButton.Text = "Bật/Tắt Xuyên Tường"
    wallhackButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    wallhackButton.TextColor3 = Color3.new(1, 1, 1)
    wallhackButton.MouseButton1Click:Connect(function()
        wallhackEnabled = not wallhackEnabled
        showNotification("Xuyên Tường " .. (wallhackEnabled and "Bật" or "Tắt"))
    end)
    wallhackButton.Parent = menuFrame
end

-- Hàm để khôi phục lại menu khi nhân vật hồi sinh
player.CharacterAdded:Connect(function()
    -- Tạo lại menu khi nhân vật hồi sinh
    createMenu()
end)

-- Gọi hàm tạo menu khi script chạy
createMenu()    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = menuFrame

    -- Tạo avatar (cờ Việt Nam)
    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(0, 40, 0, 40)
    avatarImage.Position = UDim2.new(0, 10, 0, 10)
    avatarImage.Image = "rbxassetid://6460073050"  -- Cờ Việt Nam (hãy thay đổi asset ID nếu cần)
    avatarImage.Parent = menuFrame

    -- Tạo nút ESP
    local espButton = Instance.new("TextButton")
    espButton.Size = UDim2.new(1, 0, 0, 50)
    espButton.Position = UDim2.new(0, 0, 0.1, 0)
    espButton.Text = "Bật/Tắt ESP"
    espButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    espButton.TextColor3 = Color3.new(1, 1, 1)
    espButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        showNotification("ESP " .. (espEnabled and "Bật" or "Tắt"))
    end)
    espButton.Parent = menuFrame

    -- Tạo nút Aimbot
    local aimbotButton = Instance.new("TextButton")
    aimbotButton.Size = UDim2.new(1, 0, 0, 50)
    aimbotButton.Position = UDim2.new(0, 0, 0.3, 0)
    aimbotButton.Text = "Bật/Tắt Aimbot"
    aimbotButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    aimbotButton.TextColor3 = Color3.new(1, 1, 1)
    aimbotButton.MouseButton1Click:Connect(function()
        aimEnabled = not aimEnabled
        if aimEnabled then
            autoAim()  -- Bắt đầu aim tự động nếu bật tính năng
        end
        showNotification("Aimbot " .. (aimEnabled and "Bật" or "Tắt"))
    end)
    aimbotButton.Parent = menuFrame

    -- Tạo nút Xuyên Tường
    local wallhackButton = Instance.new("TextButton")
    wallhackButton.Size = UDim2.new(1, 0, 0, 50)
    wallhackButton.Position = UDim2.new(0, 0, 0.5, 0)
    wallhackButton.Text = "Bật/Tắt Xuyên Tường"
    wallhackButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    wallhackButton.TextColor3 = Color3.new(1, 1, 1)
    wallhackButton.MouseButton1Click:Connect(function()
        wallhackEnabled = not wallhackEnabled
        showNotification("Xuyên Tường " .. (wallhackEnabled and "Bật" or "Tắt"))
    end)
    wallhackButton.Parent = menuFrame
end

-- Gọi hàm tạo menu khi script chạy
createMenu()
