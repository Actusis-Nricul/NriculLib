# ✨ NriculLib

**Your Personal Script Library - Supercharged!**

A powerful, customizable UI library for Roblox with an intuitive API and beautiful theming system.

---

## 🚀 Quick Start

Load the library into your script:

```luau
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Actusis-Nricul/NriculLib/refs/heads/main/NriculLib.luau"))()
```

---

## 📦 Components

### 🖼️ **Window**

Create the main UI window with full customization:

```luau
local Window = Lib:CreateGui({

    Name = "NriculLibExample",

    Theme = "Default",

    MinimizeKeybind = "K",

    ToggleUIKeybind = "L",

    Discord = {

        Enabled = false,

        Invite = "invitecodehere", -- has to be ABCD for discord.gg/ABCD for example

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

### 📑 **Tabs**

Organize your UI into manageable sections:

```luau
local Tab = Window:CreateTab("Tab", "star")
```

### 🏷️ **Sections**

Group related elements together:

```luau
Tab:CreateSection("Section")
```

### 📝 **Labels**

Display text labels with icons:

```luau
Tab:CreateLabel("Label", "star")
```

### ➖ **Dividers**

Separate content visually:

```luau
Tab:CreateDivider()
```

### 💬 **Paragraphs**

Show formatted text content:

```luau
Tab:CreateParagraph({

    Title = "Paragraph",

    Content = "Paragraph",

})
```

### 🔘 **Buttons**

Create interactive buttons:

```luau
Tab:CreateButton({

    Name = "Button",

    Icon = "star",

    Callback = function()

    end,

})
```

### 🎚️ **Toggles**

Add on/off switches:

```luau
Tab:CreateToggle({

    Name = "Toggle",

    CurrentValue = false,

    Flag = "Toggle1",

    Callback = function(Value)

    end,

})
```

### ⌨️ **Inputs**

Get user text input:

```luau
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

### 🎯 **Dropdowns**

Let users select from options:

```luau
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

### 📊 **Sliders**

Capture numeric input with range control:

```luau
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

### 🎨 **Color Picker**

Let users choose colors:

```luau
Tab:CreateColorPicker({

    Name = "Color Picker",

    Color = Color3.fromRGB(255, 255, 255),

    Flag = "ColorPicker1",

    Callback = function(Value)

    end,

})
```

### ⌨️ **Keybinds**

Allow users to set custom keybindings:

```luau
Tab:CreateKeybind({

    Name = "Keybind",

    CurrentKeybind = "None",

    HoldToInteract = false,

    Flag = "Keybind1",

    Callback = function(Keybind)

    end,

})
```

---

**Made with ❤️ by Actusis-Nricul**