import SwiftUI
import Common

struct CourseCardView: View {
    let course: Course
    let onDelete: () -> Void
    
    private var progressColor: Color {
        if course.completionPercentage >= 70 {
            return AppTheme.Colors.green100
        } else if course.completionPercentage >= 35 {
            return AppTheme.Colors.yellow100
        } else {
            return AppTheme.Colors.purple200
        }
    }
    
    private var iconName: String {
        switch course.courseCode.prefix(2) {
        case "CS":
            let code = Int(course.courseCode.dropFirst(2)) ?? 0
            switch code {
            case 0..<250: return "externaldrive.connected.to.line.below"
            case 250..<350: return "globe.americas"
            case 350..<450: return "function"
            case 450..<550: return "wifi.router"
            default: return "brain.head.profile"
            }
        default:
            return "paintbrush.pointed"
        }
    }
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            
            ZStack {
                if let imageData = course.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
                } else {
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .fill(
                            LinearGradient(
                                colors: [
                                    AppTheme.Colors.black100,
                                    AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.4)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 30, weight: .light))
                        .foregroundColor(AppTheme.Colors.green100)
                }
            }
            
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                Text(course.name)
                    .font(AppTheme.textStyle(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .lineLimit(1)
                
                Text("Progress")
                    .font(AppTheme.textStyle(size: 12, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
                
                HStack(spacing: AppTheme.Spacing.xxSmall) {
                    Text("\(Int(course.completionPercentage))%")
                        .font(AppTheme.textStyle(size: 16, weight: .bold))
                        .foregroundColor(progressColor)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.5))
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(progressColor)
                                .frame(
                                    width: geometry.size.width * CGFloat(course.completionPercentage / 100.0),
                                    height: 6
                                )
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                    }
                    .frame(height: 20)
                    
                    Text("\(Int(course.completionPercentage))%")
                        .font(AppTheme.textStyle(size: 11, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray200)
                }
            }
        }
        .padding(AppTheme.Spacing.xSmall)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .fill(Color.white)
                .appShadow(opacity: 0.08, radius: 8, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.5), lineWidth: 1)
        )
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete Course", systemImage: "trash")
            }
        }
    }
}

struct CourseCardView_Previews: PreviewProvider {
    static var previews: some View {
        CourseCardView(
            course: Course(
                name: "Operating Systems",
                courseCode: "CS301",
                startDate: Date(),
                examDate: Date().addingTimeInterval(86400 * 30),
                hasMaterials: true,
                completionPercentage: 75.0
            ),
            onDelete: {}
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
