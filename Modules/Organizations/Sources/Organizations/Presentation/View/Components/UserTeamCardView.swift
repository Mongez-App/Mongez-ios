//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import SwiftUI
import Common

public struct UserTeamCardView: View {
    let team: Team
    
    public init(team: Team) {
        self.team = team
    }
    
    private var placeholderColor: Color {
        let colors: [Color] = [
            AppTheme.Colors.yellow100,
            AppTheme.Colors.red100,
            AppTheme.Colors.green100,
            AppTheme.Colors.purple100,
            AppTheme.Colors.blue100
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
    
    private var eventChips: [String] {
        if team.events.isEmpty {
            return ["No events this week"]
        }
        
        var counts: [String: Int] = [:]
        for event in team.events {
            counts[event.eventType.lowercased(), default: 0] += 1
        }
        
        return counts.map { key, count in
            let plural = count > 1 ? "s" : ""
            if key == "quiz" {
                let pluralQuiz = count > 1 ? "zes" : ""
                return "\(count) quiz\(pluralQuiz)"
            }
            return "\(count) \(key)\(plural)"
        }.sorted()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            HStack(spacing: AppTheme.Spacing.small) {
                if let url = URL(string: team.imageUrl), !team.imageUrl.isEmpty {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 48, height: 48)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 48, height: 48)
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
                    
                    Text(team.organizationName)
                        .font(AppTheme.textStyle(size: 12, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray300)
                }
                Spacer()
            }
            
            VStack(spacing: AppTheme.Spacing.xxxSmall) {
                HStack {
                    Text("Team Progress")
                        .font(AppTheme.textStyle(size: 10, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray300)
                    Spacer()
                    Text("\(Int(team.completionPercentage * 100))%")
                        .font(AppTheme.textStyle(size: 10, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.purple200)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.Colors.gray100)
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.Colors.purple200)
                            .frame(width: geometry.size.width * CGFloat(team.completionPercentage), height: 6)
                    }
                }
                .frame(height: 6)
            }
            .padding(.vertical, AppTheme.Spacing.xxxSmall)
            
            Divider()
                .background(AppTheme.Colors.gray100)
            
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.Spacing.xxSmall) {
                        ForEach(eventChips, id: \.self) { chip in
                            Text(chip.capitalized)
                                .font(AppTheme.textStyle(size: 12, weight: .medium))
                                .foregroundColor(AppTheme.Colors.purple200)
                                .padding(.horizontal, AppTheme.Spacing.small)
                                .padding(.vertical, AppTheme.Spacing.xxSmall)
                                .background(AppTheme.Colors.purple200.opacity(0.1))
                                .cornerRadius(AppTheme.radius.small)
                        }
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(AppTheme.Colors.purple200)
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .padding(AppTheme.Spacing.small)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                .background(AppTheme.Colors.white100)
                .cornerRadius(AppTheme.radius.meduim)
        )
    }
    
    private var fallbackImage: some View {
        RoundedRectangle(cornerRadius: AppTheme.radius.small)
            .fill(placeholderColor)
            .frame(width: 48, height: 48)
            .overlay(
                Text(initials)
                    .font(AppTheme.textStyle(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.white100)
            )
    }
}

struct UserTeamCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTeam = Team(
            teamId: "team123",
            name: "Design Team",
            organizationName: "Mongez",
            imageUrl: "",
            completionPercentage: 0.55, 
            events: []
        )
        return UserTeamCardView(team: sampleTeam).padding(16)
    }
}
