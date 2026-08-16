import SwiftUI
import Common

public struct OrgTeamCardView: View {
    let team: OrgTeam
    let isPending: Bool
    
    public init(team: OrgTeam, isPending: Bool = false) {
        self.team = team
        self.isPending = isPending
    }
    
    private var placeholderColor: Color {
        let colors: [Color] = [
            AppTheme.Colors.purple100,
            AppTheme.Colors.blue100,
            AppTheme.Colors.red100,
            AppTheme.Colors.yellow100,
            AppTheme.Colors.green100
        ]
        let index = abs(team.teamId.hashValue) % colors.count
        return colors[index]
    }
    
    private var initials: String {
        let components = team.name.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        if components.count >= 2 {
            let first = components[0].prefix(1).uppercased()
            let second = components[1].prefix(1).uppercased()
            return first + second
        } else if let first = components.first, first.count >= 2 {
            return String(first.prefix(2)).uppercased()
        } else {
            return String(team.name.prefix(2)).uppercased()
        }
    }
    
    private var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: team.appliedAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMM d"
            return displayFormatter.string(from: date)
        }
        return team.appliedAt
    }
    
    public var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            if let url = URL(string: team.imageUrl), !team.imageUrl.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 56, height: 56)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
                    case .failure:
                        fallbackImage
                    @unknown default:
                        fallbackImage
                    }
                }
            } else {
                fallbackImage
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                Text(team.name)
                    .font(AppTheme.textStyle(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                HStack {
                    Text(team.organizationName)
                        .font(AppTheme.textStyle(size: 12, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray300)
                    
                    Spacer()
                    
                    if isPending {
                        Text("Applied \(formattedDate)")
                            .font(AppTheme.textStyle(size: 12, weight: .regular))
                            .foregroundColor(AppTheme.Colors.gray300)
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.small)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                .background(AppTheme.Colors.white100)
                .cornerRadius(AppTheme.radius.small)
        )
    }
    
    private var fallbackImage: some View {
        RoundedRectangle(cornerRadius: AppTheme.radius.small)
            .fill(placeholderColor)
            .frame(width: 56, height: 56)
            .overlay(
                Text(initials)
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.white100)
            )
    }
}

#Preview {
    VStack(spacing: 16) {
        let samplePendingTeam = OrgTeam(
            teamId: "1",
            name: "Team Name",
            imageUrl: "",
            organizationName: "Organization Name",
            appliedAt: "2024-05-25T10:00:00Z",
            status: "PENDING"
        )
        OrgTeamCardView(team: samplePendingTeam, isPending: true)
        
        let sampleTrendingTeam = OrgTeam(
            teamId: "2",
            name: "Team Name",
            imageUrl: "",
            organizationName: "Organization Name",
            appliedAt: "",
            status: "NOT_A_MEMBER"
        )
        OrgTeamCardView(team: sampleTrendingTeam, isPending: false)
    }
    .padding()
}
