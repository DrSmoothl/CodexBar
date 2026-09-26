import Foundation
import Testing
@testable import CodexBar
@testable import CodexBarCore

extension ProviderSettingsDescriptorTests {
    @Test
    func `Muse browser team quota is opt in and the chosen team reaches the snapshot`() throws {
        let fixture = try self.makeSettingsFixture(suite: "ProviderSettingsDescriptorTests-muse")
        let implementation = MuseProviderImplementation()
        let context = fixture.settingsContext(provider: .muse)
        let picker = try #require(implementation.settingsPickers(context: context).first)
        let fields = implementation.settingsFields(context: context)
        let team = try #require(fields.first { $0.id == "muse-web-team-id" })
        let snapshotContext = ProviderSettingsSnapshotContext(settings: fixture.settings, tokenOverride: nil)
        #expect(picker.binding.wrappedValue == "off")
        #expect(team.isVisible?() == false)
        let defaults = try ProviderSettingsSnapshot(
            contributions: [#require(implementation.settingsSnapshot(context: snapshotContext))])
        #expect(defaults[MuseProviderSettingsKey.self]?.cookieSource == .off)
        #expect(defaults[MuseProviderSettingsKey.self]?.webTeamID == nil)
        picker.binding.wrappedValue = "auto"
        team.binding.wrappedValue = " 424242424242 "
        #expect(team.isVisible?() == true)
        #expect(fixture.settings.providerConfig(for: .muse)?.workspaceID == "424242424242")
        let chosen = try ProviderSettingsSnapshot(
            contributions: [#require(implementation.settingsSnapshot(context: snapshotContext))])
        #expect(chosen[MuseProviderSettingsKey.self]?.cookieSource == .auto)
        #expect(chosen[MuseProviderSettingsKey.self]?.webTeamID == "424242424242")
    }
}
