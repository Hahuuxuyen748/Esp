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

-- Hàm tìm tất cả địch
local function findEnemies()
    local enemies = {}
    for _, obj in pairs(game.Players:GetPlayers()) do
        if obj ~= player and obj.Character and obj.Character:FindFirstChild("Humanoid") then
            table.insert(enemies, obj.Character)
        end
    end
    return enemies
end

-- Hàm theo dõi và tạo tia cho tất cả địch
local function trackEnemies()
    while true do
        local enemies = findEnemies()
        for _, enemy in pairs(enemies) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                local beam = createBeam(character.PrimaryPart, enemy.PrimaryPart)
                wait(0.1) -- Tia tồn tại trong 0.1 giây
                beam:Destroy()
            end
        end
        wait(0.5) -- Tìm kiếm kẻ địch mỗi 0.5 giây
    end
end

-- Hàm thực hiện auto aim (auto ghim đầu)
local function autoAim()
    while true do
        local enemies = findEnemies()
        for _, enemy in pairs(enemies) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                -- Cách đơn giản nhất để aim vào đầu kẻ địch
                local head = enemy:FindFirstChild("Head")
                if head then
                    character:SetPrimaryPartCFrame(CFrame.new(head.Position)) -- Ghim đầu vào đầu kẻ địch
                end
            end
        end
        wait(0.1) -- Điều chỉnh tốc độ aim
    end
end

-- Hàm khởi tạo lại các chức năng sau khi respawn
local function onCharacterAdded(newCharacter)
    character = newCharacter
    -- Hiển thị thông báo khi bắt đầu script
    showNotification()
    
    -- Bắt đầu theo dõi kẻ địch và thực hiện auto aim
    trackEnemies()
    autoAim()
end

-- Gọi hàm khi nhân vật mới được tạo (sau khi chết và hồi sinh)
player.CharacterAdded:Connect(onCharacterAdded)

-- Khi bắt đầu, nếu nhân vật đã có thì sẽ kích hoạt ngay
if player.Character then
    onCharacterAdded(player.Character)
end
