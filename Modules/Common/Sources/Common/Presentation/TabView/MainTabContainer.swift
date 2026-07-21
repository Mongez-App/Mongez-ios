import SwiftUI

public struct MainTabContainer<Content: View>: View {
    @Binding public var selectedTab: AppTab
    @ViewBuilder public let content: (AppTab) -> Content
    
    public init(
        selectedTab: Binding<AppTab>,
        @ViewBuilder content: @escaping (AppTab) -> Content
    ) {
        self._selectedTab = selectedTab
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            content(selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            TabBarView(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
