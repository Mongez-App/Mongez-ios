import SwiftUI
import Common

public struct OrganizationsView: View {
    @StateObject private var viewModel: OrganizationsViewModel
    
    public init(viewModel: OrganizationsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
            Text("Organizations")
                .font(AppTheme.textStyle(size: 24, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
                .padding(.horizontal, AppTheme.Spacing.large)
            
            // Segmented Control
            HStack {
                ForEach(OrganizationTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation {
                            viewModel.selectedTab = tab
                        }
                    }) {
                        Text(tabTitle(for: tab))
                            .font(AppTheme.textStyle(size: 14, weight: .medium))
                            .foregroundColor(viewModel.selectedTab == tab ? AppTheme.Colors.black100 : AppTheme.Colors.gray300)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .fill(viewModel.selectedTab == tab ? AppTheme.Colors.white100 : Color.clear)
                            )
                    }
                }
            }
            .padding(4)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(AppTheme.Colors.gray100.opacity(0.4))
            .cornerRadius(AppTheme.radius.meduim)
            .padding(.horizontal, AppTheme.Spacing.large)
            
            TabView(selection: $viewModel.selectedTab) {
                UserTeamsView(viewModel: viewModel)
                    .tag(OrganizationTab.myTeams)
                
                DiscoverView(viewModel: viewModel)
                    .tag(OrganizationTab.discover)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: viewModel.selectedTab)
        }
        .padding(.top, AppTheme.Spacing.large)
        .background(AppTheme.Colors.white100.ignoresSafeArea())
    }

    // `OrganizationTab.rawValue` is a plain String, so `Text(tab.rawValue)` would not
    // auto-localize (Text(String) never resolves against the String Catalog). Map each
    // fixed tab case to a LocalizedStringKey literal here instead.
    private func tabTitle(for tab: OrganizationTab) -> LocalizedStringKey {
        switch tab {
        case .myTeams:
            return "My Teams"
        case .discover:
            return "Discover"
        }
    }
}

