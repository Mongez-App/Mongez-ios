import SwiftUI
import Common

public struct JoinTeamBottomSheet: View {
    let team: OrgTeam
    @Binding var inviteCode: String
    let onSubmit: () -> Void
    
    public init(team: OrgTeam, inviteCode: Binding<String>, onSubmit: @escaping () -> Void) {
        self.team = team
        self._inviteCode = inviteCode
        self.onSubmit = onSubmit
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
    
    // PENDING, NOT_A_MEMBER, ALREADY_A_MEMBER
    private var statusConfig: (title: String, color: Color) {
        switch team.status {
        case "ALREADY_A_MEMBER":
            return ("Already a member", AppTheme.Colors.green100)
        case "NOT_A_MEMBER":
            return ("Not a member", AppTheme.Colors.purple200)
        case "PENDING":
            return ("Pending", AppTheme.Colors.orange100)
        default:
            return (team.status.capitalized, AppTheme.Colors.gray300)
        }
    }
    
    public var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            // Drag handle
            RoundedRectangle(cornerRadius: 2)
                .fill(AppTheme.Colors.gray200)
                .frame(width: 40, height: 4)
                .padding(.top, AppTheme.Spacing.small)
            
            // Image
            if let url = URL(string: team.imageUrl), !team.imageUrl.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 80)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    case .failure:
                        fallbackImage
                    @unknown default:
                        fallbackImage
                    }
                }
            } else {
                fallbackImage
            }
            
            // Text Info
            VStack(spacing: AppTheme.Spacing.xxxSmall) {
                Text(team.name)
                    .font(AppTheme.textStyle(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                Text(team.organizationName)
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray300)
            }
            
            // Status Chip
            Text(statusConfig.title)
                .font(AppTheme.textStyle(size: 12, weight: .medium))
                .foregroundColor(statusConfig.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(statusConfig.color.opacity(0.15))
                .cornerRadius(16)
            
            if team.status == "NOT_A_MEMBER" {
                HStack(spacing: AppTheme.Spacing.small) {
                    TextField("Enter Invite Code or Team ID", text: $inviteCode)
                        .font(AppTheme.textStyle(size: 14, weight: .regular))
                        .padding(.horizontal, AppTheme.Spacing.small)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                        )
                    
                    Button(action: onSubmit) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(width: 48, height: 48)
                            .background(AppTheme.Colors.purple200)
                            .cornerRadius(AppTheme.radius.small)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.large)
            }
            
            Spacer()
        }
        .padding(.bottom, AppTheme.Spacing.xLarge)
    }
    
    private var fallbackImage: some View {
        Circle()
            .fill(placeholderColor)
            .frame(width: 80, height: 80)
            .overlay(
                Text(initials)
                    .font(AppTheme.textStyle(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.white100)
            )
    }
}

struct JoinTeamBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            let team1 = OrgTeam(teamId: "1", name: "Team Name", imageUrl: "", organizationName: "Organization Name", appliedAt: "", status: "NOT_A_MEMBER")
            JoinTeamBottomSheet(team: team1, inviteCode: .constant(""), onSubmit: {})
                .frame(height: 350)
                .background(Color.white)
                .cornerRadius(24)
            
            let team2 = OrgTeam(teamId: "2", name: "Team Name", imageUrl: "", organizationName: "Organization Name", appliedAt: "", status: "ALREADY_A_MEMBER")
            JoinTeamBottomSheet(team: team2, inviteCode: .constant(""), onSubmit: {})
                .frame(height: 250)
                .background(Color.white)
                .cornerRadius(24)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
