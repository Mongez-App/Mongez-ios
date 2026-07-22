import SwiftUI

public struct TabBarView: View {
    @Binding public var selectedTab: AppTab
    
    public init(selectedTab: Binding<AppTab>) {
        self._selectedTab = selectedTab
    }
    
    public var body: some View {
        HStack {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 6) {
                        Image(tab.iconName, bundle: .main)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Circle()
                            .frame(width: 4.5, height: 4.5)
                            .opacity(selectedTab == tab ? 1 : 0)
                    }
                    .foregroundColor(selectedTab == tab ? AppTheme.Colors.purple200 : AppTheme.Colors.gray300)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, AppTheme.Spacing.xSmall)
        .padding(.vertical, AppTheme.Spacing.xxxSmall)
        .background(AppTheme.Colors.white100)
        .clipShape(Capsule())
        .appShadow(opacity: 0.55, radius: 6)
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.xxSmall)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppTheme.Colors.white100
                .ignoresSafeArea()

            VStack {
                Spacer()
                TabBarView(selectedTab: .constant(.dashboard))
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
