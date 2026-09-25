import Testing
@testable import CodexBarCore

struct CodexProviderDescriptorTests {
    @Test
    func `usage dashboard opens Codex analytics rather than the retired settings route`() {
        #expect(
            CodexProviderDescriptor.descriptor.metadata.dashboardURL ==
                "https://chatgpt.com/codex/cloud/settings/analytics#usage")
    }
}
