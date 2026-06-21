# ✨ NriculLib

**Your Personal Script Library - Supercharged!**

A powerful, customizable UI library for Roblox with an intuitive API and beautiful theming system.

---

## 🚀 Quick Start

Load the library into your script:

```text
local Lib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Actusis-Nricul/NriculLib/refs/heads/main/NriculLib'))()
```

---

## 📦 Components

### 🖼️ **Window**

Create the main UI window with full customization:

```text
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

```text
local Tab = Window:CreateTab("Tab", "star")
```

### 🏷️ **Sections**

Group related elements together:

```text
Tab:CreateSection("Section")
```

### 📝 **Labels**

Display text labels with icons:

```text
Tab:CreateLabel("Label", "star")
```

### ➖ **Dividers**

Separate content visually:

```text
Tab:CreateDivider()
```

### 💬 **Paragraphs**

Show formatted text content:

```text
Tab:CreateParagraph({

    Title = "Paragraph",

    Content = "Paragraph",

})
```

### 🔘 **Buttons**

Create interactive buttons:

```text
Tab:CreateButton({

    Name = "Button",

    Icon = "star",

    Callback = function()

    end,

})
```

### 🎚️ **Toggles**

Add on/off switches:

```text
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

### 🎯 **Dropdowns**

Let users select from options:

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

### 📊 **Sliders**

Capture numeric input with range control:

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

### 🎨 **Color Picker**

Let users choose colors:

```text
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

---

**Made with ❤️ by Actusis-Nricul**
