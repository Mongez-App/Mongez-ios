import Foundation

class InMemoryCourseDataSource {
    static let shared = InMemoryCourseDataSource()
    
    private var courses: [Course]
    
    private init() {
        let calendar = Calendar.current
        let now = Date()
        
        courses = [
            Course(
                id: "course_uuid_9982",
                name: "Operating Systems",
                courseCode: "CS301",
                startDate: calendar.date(byAdding: .day, value: -30, to: now) ?? now,
                examDate: calendar.date(byAdding: .day, value: 26, to: now) ?? now,
                hasMaterials: true,
                completionPercentage: 70.0
            ),
            Course(
                id: "course_uuid_1102",
                name: "Algorithms",
                courseCode: "CS401",
                startDate: calendar.date(byAdding: .day, value: -20, to: now) ?? now,
                examDate: calendar.date(byAdding: .day, value: 40, to: now) ?? now,
                hasMaterials: true,
                completionPercentage: 34.0
            ),
            Course(
                id: "course_uuid_2203",
                name: "Networks",
                courseCode: "CS305",
                startDate: calendar.date(byAdding: .day, value: -45, to: now) ?? now,
                examDate: calendar.date(byAdding: .day, value: 15, to: now) ?? now,
                hasMaterials: true,
                completionPercentage: 90.0
            ),
            Course(
                id: "course_uuid_3304",
                name: "Data Structures",
                courseCode: "CS201",
                startDate: calendar.date(byAdding: .day, value: -60, to: now) ?? now,
                examDate: calendar.date(byAdding: .day, value: 10, to: now) ?? now,
                hasMaterials: true,
                completionPercentage: 85.0
            ),
            Course(
                id: "course_uuid_4405",
                name: "UI/UX Design",
                courseCode: "CUSTOM_01",
                startDate: calendar.date(byAdding: .day, value: -10, to: now) ?? now,
                examDate: calendar.date(byAdding: .day, value: 50, to: now) ?? now,
                hasMaterials: false,
                completionPercentage: 15.0
            ),
            Course(
                id: "course_uuid_5506",
                name: "Machine Learning",
                courseCode: "CS501",
                startDate: calendar.date(byAdding: .day, value: -5, to: now) ?? now,
                examDate: calendar.date(byAdding: .day, value: 60, to: now) ?? now,
                hasMaterials: true,
                completionPercentage: 8.0
            )
        ]
    }
    
    func getAll() -> [Course] {
        return courses.filter { !$0.isHidden }
    }
    
    func add(_ course: Course) {
        courses.append(course)
    }
    
    func delete(id: String) {
        courses.removeAll { $0.id == id }
    }
    
    func search(query: String) -> [Course] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else {
            return getAll()
        }
        return getAll().filter {
            $0.name.lowercased().contains(trimmed) ||
            $0.courseCode.lowercased().contains(trimmed)
        }
    }
}
