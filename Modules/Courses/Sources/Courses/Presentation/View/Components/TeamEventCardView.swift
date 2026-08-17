import SwiftUI
import Common

public struct TeamEventCardView: View {
    let event: TeamEvent
    
    public init(event: TeamEvent) {
        self.event = event
    }
    
    private var eventColor: Color {
        let type = event.eventType.lowercased()
        if type.contains("assignment") {
            return AppTheme.Colors.green100
        } else if type.contains("quiz") {
            return AppTheme.Colors.yellow100
        } else if type.contains("midterm") {
            return AppTheme.Colors.purple200
        } else if type.contains("exam") {
            return AppTheme.Colors.red100
        } else {
            return AppTheme.Colors.blue100
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.courseName)
                        .font(AppTheme.textStyle(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                        .lineLimit(1)
                    
                    Text(event.eventType)
                        .font(AppTheme.textStyle(size: 10, weight: .medium))
                        .foregroundColor(eventColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppTheme.Colors.changeOpacity(color: eventColor, opacity: 0.1))
                        )
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "calendar")
                        .foregroundColor(AppTheme.Colors.gray300)
                        .font(.system(size: 14))
                }
            }
            
            Spacer()
            
            HStack {
                Text(event.eventDate)
                    .font(AppTheme.textStyle(size: 11, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
                
                Spacer()
                
                Text("\(event.daysLeft) days left")
                    .font(AppTheme.textStyle(size: 11, weight: .bold))
                    .foregroundColor(event.daysLeft <= 3 ? AppTheme.Colors.red100 : AppTheme.Colors.purple200)
            }
        }
        .padding(AppTheme.Spacing.small)
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .fill(AppTheme.Colors.white100)
                .appShadow(opacity: 0.3, radius: 4, y: 0)
        )
    }
}
