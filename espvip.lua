local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local espEnabled = true
local aimEnabled = true

-- Hàm tạo thông báo hiển thị
local function showNotification(message)
    local gui = Instance.new("ScreenGui")
    gui.Name = "NotificationGUI"
    gui.Parent = player.PlayerGui

    local textLabel = Instance.new("TextLabel", gui)
    textLabel.Size = UDim2.new(0.5, 0, 0.1, 0) -- Kích thước giao diện
    textLabel.Position = UDim2.new(0.25, 0, 0.9, 0) -- Vị trí ở dưới cùng
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

-- Hàm tạo Beam (tia xuyên tường với 7 màu)
local function createBeam(origin, target)
    local attachment1 = Instance.new("Attachment", origin)
    local attachment2 = Instance.new("Attachment", target)

    local beam = Instance.new("Beam", origin)
    beam.Attachment0 = attachment1
    beam.Attachment1 = attachment2
    beam.FaceCamera = true
    beam.Width0 = 0.1
    beam.Width1 = 0.1

    -- Tạo tia 7 màu
    beam.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(math.random(), 1, 1)),
        ColorSequenceKeypoint.new(0.2, Color3.fromHSV(math.random(), 1, 1)),
        ColorSequenceKeypoint.new(0.4, Color3.fromHSV(math.random(), 1, 1)),
        ColorSequenceKeypoint.new(0.6, Color3.fromHSV(math.random(), 1, 1)),
        ColorSequenceKeypoint.new(0.8, Color3.fromHSV(math.random(), 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(math.random(), 1, 1))
    })
    beam.LightEmission = 1
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local espEnabled = true
local aimEnabled = true

-- Hàm tạo thông báo hiển thị
local function showNotification(message)
    local gui = Instance.new("ScreenGui")
    gui.Name = "NotificationGUI"
    gui.Parent = player.PlayerGui

    local textLabel = Instance.new("TextLabel", gui)
    textLabel.Size = UDim2.new(0.5, 0, 0.1, 0) -- Kích thước giao diện
    textLabel.Position = UDim2.new(0.25, 0, 0.9, 0) -- Vị trí ở dưới cùng
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

-- Hàm tạo Beam (tia xuyên tường với 7 màu)
local function createBeam(origin, target)
    local attachment1 = Instance.new("Attachment", origin)
    local attachment2 = Instance.new("Attachment", target)

    local beam = Instance.new("Beam", origin)
    beam.Attachment0 = attachment1
    beam.Attachment1 = attachment2
    beam.FaceCamera = true
    beam.Width0 = 0.1
    beam.Width1 = 0.1

    -- Tạo tia 7 màu
    beam.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(math.random(), 1, 1)),
        ColorSequenceKeypoint.new(0.2, Color3.fromHSV(math.random(), 1, 1)),
        ColorSequenceKeypoint.new(0.4, Color3.fromHSV(math.random(), 1, 1)),
        ColorSequenceKeypoint.new(0.6, Color3.fromHSV(math.random(), 1, 1)),
        ColorSequenceKeypoint.new(0.8, Color3.fromHSV(math.random(), 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(math.random(), 1, 1))
    })
    beam.LightEmission = 1
    return beam
end

-- Hàm Auto Aim vào đầu của kẻ địch
local function autoAim()
    while aimEnabled do
        for _, obj in pairs(game.Players:GetPlayers()) do
            if obj ~= player and obj.Character and obj.Character:FindFirstChild("Humanoid") then
                local enemyCharacter = obj.Character
                local head = enemyCharacter:FindFirstChild("Head")
                if head then
                    -- Tự động nhắm vào đầu kẻ địch
                    character:SetPrimaryPartCFrame(CFrame.new(character.PrimaryPart.Position, head.Position))
                end
            end
        end
        wait(0.1)  -- Cập nhật mỗi 0.1 giây
    end
end

-- Hàm để hiển thị ESP (với tia xuyên tường)
local function updateESP()
    for _, obj in pairs(game.Players:GetPlayers()) do
        if obj ~= player and obj.Character and obj.Character:FindFirstChild("Humanoid") then
            local enemyCharacter = obj.Character
            local humanoid = enemyCharacter.Humanoid

            -- Tạo tia xuyên tường hiển thị 7 màu
            createBeam(character.PrimaryPart, enemyCharacter.PrimaryPart)
        end
    end
end

-- Hiển thị thông báo "Code by Hà Hữu Xuyên 🇻🇳" khi bắt đầu chạy script
showNotification("Code by Hà Hữu Xuyên 🇻🇳")

-- Bắt đầu các chức năng
if espEnabled then
    -- Cập nhật ESP liên tục
    while true do
        updateESP()
        wait(0.1) -- Cập nhật ESP mỗi 0.1 giây
    end
end

if aimEnabled then
    -- Tự động aim vào đầu kẻ địch
    autoAim()
    end
