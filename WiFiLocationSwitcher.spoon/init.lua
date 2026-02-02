--- === WiFiLocationSwitcher ===
---
--- TVING DEV WiFi에 연결되면 location을 'WeWork 17F'로 변경하고,
--- 끊어지면 'Auto'로 변경합니다.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "WiFiLocationSwitcher"
obj.version = "1.0"
obj.author = "User"
obj.license = "MIT"

--- WiFiLocationSwitcher.logger
--- Variable
--- Logger object
obj.logger = hs.logger.new('WiFiLocationSwitcher')

--- WiFiLocationSwitcher.targetSSID
--- Variable
--- 감지할 WiFi SSID (기본값: "TVING DEV")
obj.targetSSID = "TVING DEV"

--- WiFiLocationSwitcher.workLocation
--- Variable
--- WiFi 연결 시 설정할 location (기본값: "WeWork 17F")
obj.workLocation = "WeWork 17F"

--- WiFiLocationSwitcher.autoLocation
--- Variable
--- WiFi 해제 시 설정할 location (기본값: "Auto")
obj.autoLocation = "Auto"

-- WiFi 변경 감지 watcher
obj.wifiWatcher = nil

-- 현재 SSID 가져오기
function obj:getCurrentSSID()
    return hs.wifi.currentNetwork()
end

-- Location 변경하기
function obj:setLocation(locationName)
    local output, status, type, rc = hs.execute("networksetup -switchtolocation '" .. locationName .. "'")
    if status then
        self.logger.i("Successfully changed location to: " .. locationName)
    else
        self.logger.e("Failed to change location to: " .. locationName .. ". Error: " .. tostring(output))
    end
end

-- WiFi 변경 콜백
function obj:wifiChanged()
    local currentSSID = self:getCurrentSSID()
    self.logger.i("Current SSID detected: " .. (currentSSID or "Disconnected"))

    if currentSSID == self.targetSSID then
        self:setLocation(self.workLocation)
    else
        self:setLocation(self.autoLocation)
    end
end

--- WiFiLocationSwitcher:start()
--- Method
--- WiFi 감지 시작
function obj:start()
    -- 위치 서비스 권한 요청을 유도하기 위해 시작
    hs.location.start()

    if self.wifiWatcher == nil then
        self.wifiWatcher = hs.wifi.watcher.new(function()
            self:wifiChanged()
        end)
    end
    self.wifiWatcher:start()
    self.logger.i("WiFiLocationSwitcher started")

    -- 현재 상태에 맞게 초기화
    self:wifiChanged()

    return self
end

--- WiFiLocationSwitcher:stop()
--- Method
--- WiFi 감지 중지
function obj:stop()
    hs.location.stop()
    if self.wifiWatcher then
        self.wifiWatcher:stop()
    end
    self.logger.i("WiFiLocationSwitcher stopped")
    return self
end

return obj
