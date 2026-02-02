--- === BatteryAlert ===
---
--- 배터리가 20% 이하로 떨어지거나 80% 이상으로 충전되었을 때 알림

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "BatteryAlert"
obj.version = "1.0"
obj.author = "User"
obj.license = "MIT"

obj.logger = hs.logger.new('BatteryAlert')

-- 알림 임계값
obj.lowThreshold = 20
obj.highThreshold = 80

-- 배터리 watcher
obj.batteryWatcher = nil

-- 이전 배터리 레벨 추적
obj.previousLevel = nil

-- 배터리 변경 콜백
function obj:batteryChanged()
    local rawLevel = hs.battery.percentage()
    local currentLevel = math.floor(rawLevel + 0.5) -- 반올림

    self.logger.d(string.format("Battery: %.2f%% -> %d%%", rawLevel, currentLevel))

    if self.previousLevel == nil then
        self.previousLevel = currentLevel
        self.logger.i("Initialized at " .. currentLevel .. "%")
        return
    end

    -- 이전 레벨과 같으면 skip
    if self.previousLevel == currentLevel then
        return
    end

    -- 20% 이하로 떨어질 때 (21% -> 20%)
    if self.previousLevel > self.lowThreshold and currentLevel <= self.lowThreshold then
        hs.notify.new({
            title = "⚠️ 배터리 부족",
            informativeText = "배터리가 " .. currentLevel .. "%입니다. 충전이 필요합니다.",
            autoWithdraw = false,
            withdrawAfter = 0,
            alwaysPresent = true
        }):send()
        self.logger.i("Battery dropped to " .. currentLevel .. "%")
    end

    -- 80% 이상으로 올라갈 때 (79% -> 80%)
    if self.previousLevel < self.highThreshold and currentLevel >= self.highThreshold then
        hs.notify.new({
            title = "✅ 배터리 충전 완료",
            informativeText = "배터리가 " .. currentLevel .. "%에 도달했습니다. 충전기를 분리하세요.",
            autoWithdraw = false,
            withdrawAfter = 0,
            alwaysPresent = true
        }):send()
        self.logger.i("Battery reached " .. currentLevel .. "%")
    end

    self.previousLevel = currentLevel
end

--- BatteryAlert:start()
--- Method
--- 배터리 모니터링 시작
function obj:start()
    -- 현재 배터리 레벨로 초기화 (반올림)
    local rawLevel = hs.battery.percentage()
    self.previousLevel = math.floor(rawLevel + 0.5)
    self.logger.i(string.format("BatteryAlert started at %.2f%% (%d%%)", rawLevel, self.previousLevel))

    if self.batteryWatcher == nil then
        self.batteryWatcher = hs.battery.watcher.new(function()
            self:batteryChanged()
        end)
    end
    self.batteryWatcher:start()
    return self
end

--- BatteryAlert:stop()
--- Method
--- 배터리 모니터링 중지
function obj:stop()
    if self.batteryWatcher then
        self.batteryWatcher:stop()
    end
    self.logger.i("BatteryAlert stopped")
    return self
end

return obj
