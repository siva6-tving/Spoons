## siva6 spoons
1. install
```
git clone https://github.com/siva6-tving/Spoons.git ~/.hammerspoon/Spoons
```
2. create init.lua (at ~/.hammerspoon/init.lua)
```
-- Key mapping for vim
hs.loadSpoon("KeyMappingForVIM")
spoon.KeyMappingForVIM:start()

-- Move screen left and right
hs.loadSpoon("WindowScreenLeftAndRight")
spoon.WindowScreenLeftAndRight:bindHotkeys(spoon.WindowScreenLeftAndRight.defaultHotkeys)

-- WiFi Location Switcher
hs.loadSpoon("WiFiLocationSwitcher")
spoon.WiFiLocationSwitcher:start()

-- Battery Alert
hs.loadSpoon("BatteryAlert")
spoon.BatteryAlert:start()
```

3. reload hammerspoon
