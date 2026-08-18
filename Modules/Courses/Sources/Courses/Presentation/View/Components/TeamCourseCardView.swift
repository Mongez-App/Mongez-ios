import SwiftUI
import Common

public struct TeamCourseCardView: View {
    let course: TeamCourse
    
    public init(course: TeamCourse) {
        self.course = course
    }

    private var progressColor: Color {
        if course.progress >= 70 {
            return AppTheme.Colors.green100
        } else if course.progress >= 35 {
            return AppTheme.Colors.yellow100
        } else {
            return AppTheme.Colors.purple200
        }
    }
    
    private var initials: String {
        let words = course.name.split(separator: " ")
        let initials = words.prefix(2).compactMap { $0.first.map(String.init) }
        return initials.joined().uppercased()
    }

    public var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {

            ZStack {
                if let thumbnailUrl = course.thumbnailUrl, let url = URL(string: thumbnailUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                                .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.2))
                            Text(initials)
                                .font(AppTheme.textStyle(size: 28, weight: .bold))
                                .foregroundColor(AppTheme.Colors.purple200)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.2))
                        
                    Text(initials)
                        .font(AppTheme.textStyle(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.Colors.purple200)
                }
            }
            .frame(width: 135, height: 135)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.meduim))

            VStack(alignment: .leading, spacing: 0) {
                Text(course.name)
                    .font(AppTheme.textStyle(size: 22, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Progress")
                        .font(AppTheme.textStyle(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.Colors.gray300)

                    VStack(spacing: 4) {
                        HStack {
                            Spacer()
                            Text("\(Int(course.progress))%")
                                .font(AppTheme.textStyle(size: 16, weight: .bold))
                                .foregroundColor(progressColor)
                        }

                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.3))
                            .frame(height: 8)
                            .overlay(alignment: .leading) {
                                GeometryReader { geometry in
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(progressColor)
                                        .frame(width: geometry.size.width * CGFloat(course.progress / 100.0))
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
            }
            .frame(height: 135)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(AppTheme.Spacing.small)
        .frame(maxWidth: .infinity)
        .frame(height: 167)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.large)
                .fill(AppTheme.Colors.white100)
                .appShadow(opacity: 0.5, radius: 5, y: 0)
        )
    }
}
