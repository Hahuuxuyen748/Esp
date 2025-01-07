local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local head = character:WaitForChild("Head")
local mouse = player:GetMouse()

-- Tạo BillboardGui để hiển thị tên và máu người chơi
local billboardGui = Instance.new("BillboardGui")
billboardGui.Adornee = head
billboardGui.Size = UDim2.new(0, 200, 0, 100)
billboardGui.StudsOffset = Vector3.new(0, 3, 0)  -- Điều chỉnh vị trí hiển thị

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundTransparency = 1  -- Nền trong suốt
frame.Parent = billboardGui

-- Tạo TextLabel để hiển thị tên người chơi
local nameLabel = Instance.new("TextLabel")
nameLabel.Parent = frame
nameLabel.Text = player.Name
nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Màu trắng
nameLabel.BackgroundTransparency = 1
nameLabel.TextScaled = true

-- Tạo TextLabel để hiển thị máu người chơi
local healthLabel = Instance.new("TextLabel")
healthLabel.Parent = frame
healthLabel.Text = "HP: " .. math.floor(humanoid.Health)
healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Màu đỏ cho máu
healthLabel.BackgroundTransparency = 1
healthLabel.TextScaled = true

-- Cập nhật máu khi thay đổi
humanoid.HealthChanged:Connect(function()
    healthLabel.Text = "HP: " .. math.floor(humanoid.Health)
end)

billboardGui.Parent = character

-- Tạo Part và Beam cho chiêu
local startPart = Instance.new("Part")
startPart.Size = Vector3.new(1, 1, 1)
startPart.Position = character.HumanoidRootPart.Position  -- Vị trí người chơi
startPart.Anchored = true
startPart.CanCollide = false
startPart.Parent = workspace

local laserBeam = Instance.new("Beam")
laserBeam.Parent = startPart
laserBeam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))  -- Màu đỏ
laserBeam.Width0 = 0.2
laserBeam.Width1 = 0.2
laserBeam.Attachment0 = Instance.new("Attachment", startPart)
laserBeam.Attachment1 = Instance.new("Attachment", workspace)  -- Đầu tia laser

-- Tạo vòng tròn aim
local aimCircle = Instance.new("Part")
aimCircle.Shape = Enum.PartType.Ball
aimCircle.Size = Vector3.new(5, 1, 5)  -- Đặt kích thước vòng tròn aim
aimCircle.Anchored = true
aimCircle.CanCollide = false
aimCircle.Material = Enum.Material.Neon
aimCircle.Color = Color3.fromRGB(0, 255, 0)  -- Màu xanh lá cho vòng tròn aim
aimCircle.Parent = workspace

-- Cập nhật vòng tròn aim theo vị trí chuột
mouse.Move:Connect(function()
    aimCircle.Position = mouse.Hit.p
end)

-- Tạo thông báo "Code by Hà Hữu Xuyên 🇻🇳"
local function createCodeNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player.PlayerGui
    
    local label = Instance.new("TextLabel")
    label.Parent = screenGui
    label.Size = UDim2.new(0, 300, 0, 50)
    label.Position = UDim2.new(0.5, -150, 0.1, 0)
    label.Text = "Code by Hà Hữu Xuyên 🇻🇳"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.TextStrokeTransparency = 0.8
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    -- Thời gian hiển thị thông báo
    wait(2)
    screenGui:Destroy()
end

-- Khi sử dụng chiêu
local function onUseSkill()
    startPart.Position = character.HumanoidRootPart.Position  -- Cập nhật vị trí bắt đầu của tia laser
    laserBeam.Attachment1.Position = mouse.Hit.p  -- Cập nhật vị trí kết thúc của tia laser
    aimCircle.Visible = false  -- Ẩn vòng tròn aim khi chiêu được sử dụng
end

-- Hiển thị vòng tròn aim khi nhấn phím E
local function onActivateSkill()
    aimCircle.Visible = true  -- Hiển thị vòng tròn aim khi sử dụng chiêu
    wait(2)  -- Đợi 2 giây (hoặc thời gian phù hợp với chiêu)
    onUseSkill()  -- Kích hoạt chiêu và ẩn vòng tròn aim
    createCodeNotification()  -- Hiển thị thông báo "Code by Hà Hữu Xuyên 🇻🇳"
end

-- Gán sự kiện sử dụng chiêu (nhấn phím E)
player.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        onActivateSkill()
    end
end)
        for _, enemy in pairs(enemies) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                -- Dịch chuyển đến vị trí của kẻ địch
                character:SetPrimaryPartCFrame(enemy.PrimaryPart.CFrame)
            end
        end
        wait(1) -- Dịch chuyển tới địch mỗi giây
    end
end

-- Hàm khởi tạo lại các chức năng sau khi respawn
local function onCharacterAdded(newCharacter)
    character = newCharacter
    -- Hiển thị thông báo khi bắt đầu script
    showNotification()

    -- Bắt đầu auto aim, ESP và teleport
    autoAim()
    espEnemies()
    teleportToEnemy()
end

-- Gọi hàm khi nhân vật mới được tạo (sau khi chết và hồi sinh)
player.CharacterAdded:Connect(onCharacterAdded)

-- Khi bắt đầu, nếu nhân vật đã có thì sẽ kích hoạt ngay
if player.Character then
    onCharacterAdded(player.Character)
end
        for _, enemy in pairs(enemies) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                -- Dịch chuyển đến vị trí của kẻ địch
                character:SetPrimaryPartCFrame(enemy.PrimaryPart.CFrame)
            end
        end
        wait(1) -- Dịch chuyển tới địch mỗi giây
    end
end

-- Hàm khởi tạo lại các chức năng sau khi respawn
local function onCharacterAdded(newCharacter)
    character = newCharacter
    -- Hiển thị thông báo khi bắt đầu script
    showNotification()

    -- Bắt đầu auto aim, ESP và teleport
    autoAim()
    espEnemies()
    teleportToEnemy()
end

-- Gọi hàm khi nhân vật mới được tạo (sau khi chết và hồi sinh)
player.CharacterAdded:Connect(onCharacterAdded)

-- Khi bắt đầu, nếu nhân vật đã có thì sẽ kích hoạt ngay
if player.Character then
    onCharacterAdded(player.Character)
end
