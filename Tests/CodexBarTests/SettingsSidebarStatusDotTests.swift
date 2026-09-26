import CodexBarCore
import Testing
@testable import CodexBar

struct SettingsSidebarStatusDotTests {
    @Test
    func `Critical status describes provider service health`() {
        CodexBarLocalizationOverride.$appLanguage.withValue("en") {
            #expect(SettingsSidebarStatusDot.statusDescription(for: .critical)
                == "Provider service status: Critical issue")
        }
    }

    @Test
    func `Major status describes provider service health`() {
        CodexBarLocalizationOverride.$appLanguage.withValue("en") {
            #expect(SettingsSidebarStatusDot.statusDescription(for: .major)
                == "Provider service status: Major outage")
        }
    }
}
