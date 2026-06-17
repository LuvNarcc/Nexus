if not _G.Active then _G.Active = {} end

local Module = {}

function Module:Notify(Type, Name, Msg, Duration)
	task.spawn(function()
		local Colors = if Type == "Error"
			then { Color3.fromRGB(255, 74, 84),  Color3.fromRGB(255, 46, 58)  }
			else { Color3.fromRGB(93, 157, 249), Color3.fromRGB(59, 184, 249) }

		local NotifGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("NotifGui") or (function()
			local Gui = Instance.new("ScreenGui")
			Gui.Name = "NotifGui"
			Gui.DisplayOrder = 10
			Gui.Parent = game:GetService("CoreGui").RobloxGui
			return Gui
		end)()

		if #_G.Active >= 5 then
			local Oldest = _G.Active[#_G.Active]
			table.remove(_G.Active, #_G.Active)
			Oldest:Destroy()
		end

		local Main = Instance.new("Frame")
		local Top = Instance.new("Frame")
		local Title = Instance.new("TextLabel")
		local TopBar = Instance.new("Frame")
		local Message = Instance.new("TextLabel")
		local ProgressBar = Instance.new("Frame")

		Main.Name = "Main"
		Main.Parent = NotifGui
		Main.AnchorPoint = Vector2.new(1, 1)
		Main.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
		Main.BorderSizePixel = 0
		Main.Position = UDim2.new(1, 170, 1, -20)
		Main.Size = UDim2.new(0, 169.5, 0, 90)

		local MainCorner = Instance.new("UICorner")
		MainCorner.CornerRadius = UDim.new(0, 3)
		MainCorner.Parent = Main

		Top.Name = "Top"
		Top.Parent = Main
		Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Top.BorderSizePixel = 0
		Top.Size = UDim2.new(0, 169, 0, 19.5)

		local TopCorner = Instance.new("UICorner")
		TopCorner.CornerRadius = UDim.new(0, 3)
		TopCorner.Parent = Top

		local TopGradient = Instance.new("UIGradient")
		TopGradient.Color = ColorSequence.new(Colors[1], Colors[2])
		TopGradient.Rotation = 0
		TopGradient.Parent = Top

		Title.Name = "Title"
		Title.Parent = Top
		Title.BackgroundTransparency = 1
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0.0207100585, 0, 0.102564104, 0)
		Title.Size = UDim2.new(0, 162, 0, 15.5)
		Title.ZIndex = 3
		Title.Font = Enum.Font.Gotham
		Title.Text = Name
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 12.5

		TopBar.Name = "TopBar"
		TopBar.Parent = Main
		TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TopBar.BorderSizePixel = 0
		TopBar.Position = UDim2.new(0, 0, 0.157894731, 0)
		TopBar.Size = UDim2.new(0, 169, 0, 6)

		local TopBarGradient = Instance.new("UIGradient")
		TopBarGradient.Color = ColorSequence.new(Colors[1], Colors[2])
		TopBarGradient.Rotation = 0
		TopBarGradient.Parent = TopBar

		Message.Name = "Message"
		Message.Parent = Main
		Message.BackgroundTransparency = 1
		Message.BorderSizePixel = 0
		Message.Position = UDim2.new(0.0177601501, 0, 0.35, 0)
		Message.Size = UDim2.new(0, 162, 0, 40)
		Message.ZIndex = 3
		Message.Font = Enum.Font.Gotham
		Message.Text = Msg
		Message.TextColor3 = Color3.fromRGB(255, 255, 255)
		Message.TextSize = 11
		Message.TextWrapped = true
		Message.TextXAlignment = Enum.TextXAlignment.Center
		Message.TextYAlignment = Enum.TextYAlignment.Center

		ProgressBar.Name = "ProgressBar"
		ProgressBar.Parent = Main
		ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ProgressBar.BorderSizePixel = 0
		ProgressBar.Position = UDim2.new(0, 0, 1, -3)
		ProgressBar.Size = UDim2.new(0, 0, 0, 3)

		local ProgressGradient = Instance.new("UIGradient")
		ProgressGradient.Color = ColorSequence.new(Colors[1], Colors[2])
		ProgressGradient.Rotation = 0
		ProgressGradient.Parent = ProgressBar

		table.insert(_G.Active, 1, Main)

		for Index, ActiveMain in ipairs(_G.Active) do
			game:GetService("TweenService"):Create(ActiveMain, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, -20, 1, -20 - 100 * (Index - 1))
			}):Play()
		end

		game:GetService("TweenService"):Create(ProgressBar, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, 3)
		}):Play()

		task.wait(Duration)

		for Index, ActiveMain in ipairs(_G.Active) do
			if ActiveMain == Main then
				table.remove(_G.Active, Index)
				break
			end
		end

		for Index, ActiveMain in ipairs(_G.Active) do
			game:GetService("TweenService"):Create(ActiveMain, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, -20, 1, -20 - 100 * (Index - 1))
			}):Play()
		end

		local CurrentY = Main.Position.Y.Offset
		local TweenOut = game:GetService("TweenService"):Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 170, 1, CurrentY)
		})
		TweenOut:Play()
		TweenOut.Completed:Wait()

		Main:Destroy()
	end)
end

return Module
