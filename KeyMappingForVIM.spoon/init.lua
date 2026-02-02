--- === KeyMappingForVIM ===
---
--- ESC 키를 누르면 영어 입력 소스로 자동 전환하는 Vim 키 매핑

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "KeyMappingForVIM"
obj.version = "1.0"
obj.author = "User"
obj.license = "MIT"

--- KeyMappingForVIM.logger
--- Variable
--- Logger object
obj.logger = hs.logger.new('KeyMappingForVIM')

--- KeyMappingForVIM.inputEnglish
--- Variable
--- 영어 입력 소스 ID (기본값: "com.apple.keylayout.ABC")
obj.inputEnglish = "com.apple.keylayout.ABC"

--- KeyMappingForVIM.inputKorean
--- Variable
--- 한글 입력 소스 ID (기본값: "com.apple.inputmethod.Korean.2SetKorean")
obj.inputKorean = "com.apple.inputmethod.Korean.2SetKorean"

-- ESC 핫키 바인딩
obj.esc_bind = nil

-- 영어로 전환하고 ESC 키 전송
function obj:convertToEngWithEsc()
    local inputSource = hs.keycodes.currentSourceID()
    if not (inputSource == self.inputEnglish) then
        hs.eventtap.keyStroke({}, 'right')
        hs.keycodes.currentSourceID(self.inputEnglish)
    end
    self.esc_bind:disable()
    hs.eventtap.keyStroke({}, 'escape')
    self.esc_bind:enable()
end

--- KeyMappingForVIM:start()
--- Method
--- ESC 키 매핑 시작
function obj:start()
    if self.esc_bind == nil then
        self.esc_bind = hs.hotkey.new({}, 'escape', function()
            self:convertToEngWithEsc()
        end)
    end
    self.esc_bind:enable()
    self.logger.i("KeyMappingForVIM started")
    return self
end

--- KeyMappingForVIM:stop()
--- Method
--- ESC 키 매핑 중지
function obj:stop()
    if self.esc_bind then
        self.esc_bind:disable()
    end
    self.logger.i("KeyMappingForVIM stopped")
    return self
end

return obj
