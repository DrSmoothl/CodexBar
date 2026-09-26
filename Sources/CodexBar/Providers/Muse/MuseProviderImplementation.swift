import CodexBarCore
import Foundation

struct MuseProviderImplementation: ProviderImplementation {
    let id: UsageProvider = .muse

    @MainActor
    func presentation(context _: ProviderPresentationContext) -> ProviderPresentation {
        ProviderPresentation { _ in "oauth" }
    }

    @MainActor
    func observeSettings(_ settings: SettingsStore) {
        _ = settings.museWebTeamID
    }

    /// The shared cookie snapshot defaults to Automatic; Muse reads a browser session only after an explicit choice.
    @MainActor
    func settingsSnapshot(context: ProviderSettingsSnapshotContext) -> ProviderSettingsSnapshotContribution? {
        ProviderSettingsSnapshotContribution(
            MuseProviderSettings(
                cookieSource: context.settings.museCookieSource,
                manualCookieHeader: context.settings.museCookieHeader,
                webTeamID: context.settings.museWebTeamID.isEmpty ? nil : context.settings.museWebTeamID),
            for: MuseProviderSettingsKey.self)
    }

    @MainActor
    func isAvailable(context: ProviderAvailabilityContext) -> Bool {
        MuseCredentials.hasLogin(environment: context.environment)
    }

    /// The dev.meta.ai session only fills quotas that the Muse login response leaves out.
    @MainActor
    func settingsPickers(context: ProviderSettingsContext) -> [ProviderSettingsPickerDescriptor] {
        [
            ProviderCookieSourceUI.picker(
                id: "muse-cookie-source",
                context: context,
                source: \.museCookieSource,
                allowsOff: true,
                subtitles: {
                    .init(
                        auto: L("Automatically imports browser cookies."),
                        manual: L("Paste a Cookie header or cURL capture from %@.", "dev.meta.ai"),
                        off: L("%@ cookies are disabled.", "Muse Code"))
                }),
        ]
    }

    @MainActor
    func settingsFields(context: ProviderSettingsContext) -> [ProviderSettingsFieldDescriptor] {
        [
            ProviderSettingsFieldDescriptor(
                id: "muse-cookie",
                title: "",
                subtitle: "",
                kind: .secure,
                placeholder: "Cookie: llama_dev_sess=...",
                binding: context.binding(\.museCookieHeader),
                actions: [
                    ProviderSettingsActionDescriptor.openURL(
                        id: "muse-open-usage",
                        title: "Open dev.meta.ai",
                        url: URL(string: "https://dev.meta.ai/usage")),
                ],
                isVisible: { context.settings.museCookieSource == .manual }),
            ProviderSettingsFieldDescriptor(
                id: "muse-web-team-id",
                title: "Browser team ID",
                subtitle: "The dev.meta.ai team whose quota fills in when the login response omits it. "
                    + "The Muse menu lists the teams your browser session can see.",
                kind: .plain,
                placeholder: "Team ID",
                binding: context.binding(\.museWebTeamID),
                actions: [],
                isVisible: { context.settings.museCookieSource != .off }),
        ]
    }
}
