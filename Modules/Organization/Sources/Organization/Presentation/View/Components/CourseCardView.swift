//
//  CourseCardView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

/// Course row shown inside a team's Courses tab.
struct CourseCardView: View {
    let course: TeamCourse

    private var initials: String {
        let words = course.name.split(separator: " ")
        let letters = words.prefix(2).compactMap { $0.first.map(String.init) }
        return letters.joined().uppercased()
    }

    var body: some View {
        HStack(spacing: AppTheme.Spacing.medium) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(OrganizationTheme.Colors.accent)
                    .frame(width: 132, height: 132)

                Text(initials)
                    .font(AppTheme.textStyle(size: 32, weight: .semibold))
                    .foregroundColor(OrganizationTheme.Colors.white100)
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text(course.name)
                    .font(AppTheme.textStyle(size: 18, weight: .semibold))
                    .foregroundColor(OrganizationTheme.Colors.primaryText)
                    .lineLimit(2)

                HStack {
                    Text("Progress")
                        .font(AppTheme.textStyle(size: 11, weight: .regular))
                        .foregroundColor(OrganizationTheme.Colors.subtitleText)

                    Spacer()

                    Text("\(Int(course.completionPercentage))%")
                        .font(AppTheme.textStyle(size: 12, weight: .semibold))
                        .foregroundColor(OrganizationTheme.Colors.accent)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(OrganizationTheme.Colors.border)
                            .frame(height: 8)

                        Capsule()
                            .fill(OrganizationTheme.Colors.accent)
                            .frame(
                                width: geo.size.width * min(max(CGFloat(course.completionPercentage) / 100, 0), 1),
                                height: 8
                            )
                    }
                }
                .frame(height: 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(AppTheme.Spacing.xSmall)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(OrganizationTheme.Colors.white100)
                .shadow(color: OrganizationTheme.Colors.accent.opacity(0.15), radius: 15, x: 0, y: 0)
        )
    }
}

#Preview {
    CourseCardView(course: TeamCourse.getMockCourses(teamId: "t1")[0])
        .padding()
        .background(OrganizationTheme.Colors.background)
}
