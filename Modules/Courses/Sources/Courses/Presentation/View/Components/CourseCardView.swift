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
                        .frame(width: 135, height: 135)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.meduim))
                } else {
                    RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
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
                        .frame(width: 135, height: 135)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppTheme.Colors.green100)
                }
            }
            
            
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
                            Text("\(Int(course.completionPercentage))%")
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
                                        .frame(width: geometry.size.width * CGFloat(course.completionPercentage / 100.0))
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
        .frame(width: 343, height: 167)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.large)
                .fill(AppTheme.Colors.white100)
                .appShadow(opacity: 0.5, radius: 5, y: 0)
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
