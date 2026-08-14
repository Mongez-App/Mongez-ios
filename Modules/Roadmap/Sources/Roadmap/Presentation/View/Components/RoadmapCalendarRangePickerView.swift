//
//  RoadmapCalendarRangePickerView.swift
//
//

import SwiftUI
import Common

/// Custom month grid used for picking a date range in the roadmap filter sheet.
/// Weeks start on Sunday; the grid begins at the first Sunday of the displayed month
/// (a lone leading partial week is dropped entirely) and ends at the last day of the
/// month without padding a trailing partial week beyond blank trailing columns.
struct RoadmapCalendarRangePickerView: View {
    @Binding var range: ClosedRange<Date>?

    let referenceDate: Date

    private let rowHeight: CGFloat = 44

    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }

    private var weeks: [[Date?]] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: referenceDate) else {
            return []
        }

        var days: [Date] = []
        var day = monthInterval.start
        while day < monthInterval.end {
            days.append(day)
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }

        let firstSundayIndex = days.firstIndex { calendar.component(.weekday, from: $0) == 1 } ?? 0
        let visibleDays = Array(days[firstSundayIndex...])

        var result: [[Date?]] = []
        var current: [Date?] = []
        for visibleDay in visibleDays {
            current.append(visibleDay)
            if current.count == 7 {
                result.append(current)
                current = []
            }
        }
        if !current.isEmpty {
            while current.count < 7 { current.append(nil) }
            result.append(current)
        }
        return result
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(weeks.enumerated()), id: \.offset) { _, week in
                weekRow(week)
            }
        }
    }

    private func weekRow(_ week: [Date?]) -> some View {
        GeometryReader { geometry in
            let columnWidth = geometry.size.width / 7

            ZStack(alignment: .topLeading) {
                rangeBackground(for: week, columnWidth: columnWidth)

                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { index in
                        dayCell(week[index])
                            .frame(width: columnWidth, height: rowHeight)
                    }
                }
            }
        }
        .frame(height: rowHeight)
    }

    @ViewBuilder
    private func rangeBackground(for week: [Date?], columnWidth: CGFloat) -> some View {
        if let range {
            let selectedIndices = week.indices.filter { index in
                guard let date = week[index] else { return false }
                return range.contains(calendar.startOfDay(for: date))
            }

            if let minIndex = selectedIndices.min(), let maxIndex = selectedIndices.max() {
                let startDay = calendar.startOfDay(for: range.lowerBound)
                let endDay = calendar.startOfDay(for: range.upperBound)
                let isStartInRow = week[minIndex].map { calendar.startOfDay(for: $0) == startDay } ?? false
                let isEndInRow = week[maxIndex].map { calendar.startOfDay(for: $0) == endDay } ?? false
                let corner = rowHeight / 2

                Rectangle()
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.12))
                    .frame(width: columnWidth * CGFloat(maxIndex - minIndex + 1), height: rowHeight)
                    .offset(x: columnWidth * CGFloat(minIndex))

                if isStartInRow {
                    CustomRoundedCorners(
                        tl: corner,
                        tr: (isEndInRow && maxIndex == minIndex) ? corner : 0,
                        bl: corner,
                        br: (isEndInRow && maxIndex == minIndex) ? corner : 0
                    )
                    .fill(AppTheme.Colors.purple200)
                    .frame(width: columnWidth, height: rowHeight)
                    .offset(x: columnWidth * CGFloat(minIndex))
                }

                if isEndInRow, !(isStartInRow && maxIndex == minIndex) {
                    CustomRoundedCorners(
                        tl: 0,
                        tr: corner,
                        bl: 0,
                        br: corner
                    )
                    .fill(AppTheme.Colors.purple200)
                    .frame(width: columnWidth, height: rowHeight)
                    .offset(x: columnWidth * CGFloat(maxIndex))
                }
            }
        }
    }

    private func dayCell(_ date: Date?) -> some View {
        Group {
            if let date {
                let day = calendar.startOfDay(for: date)
                Text("\(calendar.component(.day, from: date))")
                    .font(AppTheme.textStyle(size: 16, weight: textWeight(for: day)))
                    .foregroundColor(textColor(for: day))
            } else {
                Color.clear
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            if let date { select(date) }
        }
    }

    private func textColor(for day: Date) -> Color {
        guard let range else { return AppTheme.Colors.black100 }
        let start = calendar.startOfDay(for: range.lowerBound)
        let end = calendar.startOfDay(for: range.upperBound)
        if day == start || day == end {
            return AppTheme.Colors.white100
        }
        if range.contains(day) {
            return AppTheme.Colors.purple200
        }
        return AppTheme.Colors.black100
    }

    private func textWeight(for day: Date) -> Font.Weight {
        guard let range else { return .regular }
        let start = calendar.startOfDay(for: range.lowerBound)
        let end = calendar.startOfDay(for: range.upperBound)
        if day == start || day == end {
            return .bold
        }
        if range.contains(day) {
            return .semibold
        }
        return .regular
    }

    private func select(_ date: Date) {
        let day = calendar.startOfDay(for: date)
        guard let current = range else {
            range = day...day
            return
        }
        if current.lowerBound == current.upperBound {
            range = day < current.lowerBound ? day...current.upperBound : current.lowerBound...day
        } else {
            range = day...day
        }
    }
}

struct CustomRoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}
