# NriculLib
MY VERY OWN SCRIPT LIB!!!


# Load With This:
```text
local Lib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Actusis-Nricul/NriculLib/refs/heads/main/NriculLib'))()
```

Window
```text
local Window = Lib:CreateGui({

    Name = "NriculLibExample",

    Theme = "Default",

    MinimizeKeybind = "K",

    ToggleUIKeybind = "L",

    Discord = {

        Enabled = false,

        Invite = "invitecodehere",

        RememberJoins = true,

    },

    KeySystem = false,

    KeySettings = {

        Title = "NriculLib",

        Subtitle = "Key System",

        Note = "Note here",

        FileName = "key",

        SaveKey = true,

        Key = {"key"},

    },

})
```

Tabs
```text
local Tab = Window:CreateTab("Tab", "star")
```

Sections
```text
Tab:CreateSection("Section")
```

Labels
```text
Tab:CreateLabel("Label", "star")
```

Dividers
```text
Tab:CreateDivider()
```

Paragraphs
```text
Tab:CreateParagraph({

    Title = "Paragraph",

    Content = "Paragraph",

})
```

Buttons
```text
Tab:CreateButton({

    Name = "Button",

    Icon = "star",

    Callback = function()

    end,

})
```

Toggles
```text
Tab:CreateToggle({

    Name = "Toggle",

    CurrentValue = false,

    Flag = "Toggle1",

    Callback = function(Value)

    end,

})
```

Inputs
```text
Tab:CreateInput({

    Name = "Input",

    CurrentValue = "",

    PlaceholderText = "Input",

    RemoveTextAfterFocusLost = false,

    Flag = "Input1",

    Callback = function(Text)

    end,

})
```

Dropdowns
```text
Tab:CreateDropdown({

    Name = "Dropdown",

    Options = {"Option 1", "Option 2"},

    CurrentOption = {"Option 1"},

    MultipleOptions = false,

    Flag = "Dropdown1",

    Callback = function(Options)

    end,

})
```

Sliders
```text
Tab:CreateSlider({

    Name = "Slider",

    Range = {0, 100},

    Increment = 1,

    Suffix = "",

    CurrentValue = 50,

    Flag = "Slider1",

    Callback = function(Value)

    end,

})
```

Colour Picker
```text
Tab:CreateColorPicker({

    Name = "Color Picker",

    Color = Color3.fromRGB(255, 255, 255),

    Flag = "ColorPicker1",

    Callback = function(Value)

    end,

})
```

Keybinds
```text
Tab:CreateKeybind({

    Name = "Keybind",

    CurrentKeybind = "None",

    HoldToInteract = false,

    Flag = "Keybind1",

    Callback = function(Keybind)

    end,

})
```
