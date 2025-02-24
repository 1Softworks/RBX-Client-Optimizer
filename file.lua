local Optimizer = {Enabled = false}

local function DisableEffects()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = not Optimizer.Enabled
        end
        if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = not Optimizer.Enabled
        end
    end
end

local function MaximizePerformance()
    local lighting = game:GetService("Lighting")
    if Optimizer.Enabled then
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Brightness = 2
        settings().Rendering.QualityLevel = 1
        settings().Physics.PhysicsEnvironmentalThrottle = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        settings().Physics.AllowSleep = true
        settings().Physics.ForceCSGv2 = false
        settings().Physics.DisableCSGv2 = true
        settings().Rendering.EagerBulkExecution = true
        
        game:GetService("StarterGui"):SetCore("TopbarEnabled", false)
        
        settings().Network.IncomingReplicationLag = 0
        settings().Rendering.MaxTextureSize = 64
        settings().Rendering.MaxPartCount = 100000
    else
        lighting.GlobalShadows = true
        lighting.FogEnd = 100000
        lighting.Brightness = 3
        settings().Rendering.QualityLevel = 7
        settings().Physics.PhysicsEnvironmentalThrottle = 0
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
        settings().Physics.AllowSleep = false
        settings().Physics.ForceCSGv2 = true
        settings().Physics.DisableCSGv2 = false
        settings().Rendering.EagerBulkExecution = false
        
        game:GetService("StarterGui"):SetCore("TopbarEnabled", true)
        
        settings().Network.IncomingReplicationLag = 1
        settings().Rendering.MaxTextureSize = 1024
        settings().Rendering.MaxPartCount = 500000
    end
end

local function OptimizeInstances()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CastShadow = not Optimizer.Enabled
            v.Reflectance = Optimizer.Enabled and 0 or v.Reflectance
            v.Material = Optimizer.Enabled and Enum.Material.SmoothPlastic or v.Material
        end
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = Optimizer.Enabled and 1 or 0
        end
        if v:IsA("MeshPart") then
            v.RenderFidelity = Optimizer.Enabled and Enum.RenderFidelity.Performance or Enum.RenderFidelity.Precise
        end
    end
    
    game:GetService("Debris"):SetAutoCleanupEnabled(true)
    game:GetService("ContentProvider"):SetBaseUrl("")
end

local function CleanMemory()
    if Optimizer.Enabled then
        game:GetService("Debris"):AddItem(Instance.new("Model"), 0)
        settings().Physics.ThrottleAdjustTime = 2
        game:GetService("RunService"):Set3dRenderingEnabled(false)
        game:GetService("RunService"):setThrottleFramerateEnabled(true)
    else
        game:GetService("RunService"):Set3dRenderingEnabled(true)
        game:GetService("RunService"):setThrottleFramerateEnabled(false)
    end
end

local function ToggleOptimizer()
    Optimizer.Enabled = not Optimizer.Enabled
    DisableEffects()
    MaximizePerformance()
    OptimizeInstances()
    CleanMemory()
    print("Enhanced FPS Optimizer: " .. (Optimizer.Enabled and "ON" or "OFF"))
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        ToggleOptimizer()
    end
end)

ToggleOptimizer()

game:GetService("RunService").Heartbeat:Connect(function()
    if Optimizer.Enabled then
        CleanMemory()
    end
end)
