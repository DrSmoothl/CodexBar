#if os(Linux)
import CodexBarCore
import Testing
@testable import CodexBarCLI

struct MistralLinuxTests {
    @Test
    func `Mistral manual cookie header does not require browser support`() {
        #expect(!CodexBarCLI.sourceModeRequiresWebSupport(
            .auto,
            provider: .mistral,
            settings: ProviderSettingsSnapshot.make(
                mistral: .init(cookieSource: .manual, manualCookieHeader: "ory_session_abc=1; csrftoken=2"))))
    }

    @Test
    func `Mistral automatic cookie import still requires browser support`() {
        #expect(CodexBarCLI.sourceModeRequiresWebSupport(
            .auto,
            provider: .mistral,
            settings: ProviderSettingsSnapshot.make(
                mistral: .init(cookieSource: .auto, manualCookieHeader: nil))))
    }

    @Test
    func `Mistral manual source without a header still requires browser support`() {
        #expect(CodexBarCLI.sourceModeRequiresWebSupport(
            .auto,
            provider: .mistral,
            settings: ProviderSettingsSnapshot.make(
                mistral: .init(cookieSource: .manual, manualCookieHeader: "  "))))
    }
}
#endif
