local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Hàm tạo thông báo hiển thị
local function showNotification()
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
    textLabel.Text = "Code by Hà Hữu Xuyên 🇻🇳"

    -- Tự động xóa thông báo sau 5 giây
    wait(5)
    gui:Destroy()
end

-- Hàm tạo Beam (tia)
local function createBeam(origin, target)
    local attachment1 = Instance.new("Attachment", origin)
    local attachment2 = Instance.new("Attachment", target)

    local beam = Instance.new("Beam", origin)
    beam.Attachment0 = attachment1
    beam.Attachment1 = attachment2
    beam.FaceCamera = true
    beam.Width0 = 0.1
    beam.Width1 = 0.1
    beam.Color = ColorSequence.new(Color3.new(1, 0, 0)) -- Tia màu đỏ
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

-- Theo dõi và tạo tia tới kẻ địch
local function trackEnemies()
    while true do
        local enemy = findNearestEnemy()
        if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local beam = createBeam(character.PrimaryPart, enemy.PrimaryPart)
            wait(0.1) -- Tia tồn tại trong 0.1 giây
            beam:Destroy()
        end
        wait(0.5) -- Tìm kiếm kẻ địch mỗi 0.5 giây
    end
end

-- Hiển thị thông báo khi bắt đầu script
showNotification()

-- Bắt đầu theo dõi kẻ địch
trackEnemies()