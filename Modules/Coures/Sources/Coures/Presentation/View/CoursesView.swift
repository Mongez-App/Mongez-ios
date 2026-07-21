import SwiftUI
import Common

public struct CoursesView: View {
    @ObservedObject public var viewModel: CoursesViewModel
        
    public init(viewModel: CoursesViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AppTheme.Colors.white100.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                headerSection
                
                
                searchSection
                
                
                if viewModel.courses.isEmpty && !viewModel.isLoading {
                    EmptyCoursesView(
                        isSearching: !viewModel.searchText.isEmpty,
                        onAddCourse: {
                            viewModel.showAddCourseSheet = true
                        }
                    )
                } else {
                    coursesList
                }
            }
            
            
            fabButton
        }
        .sheet(isPresented: $viewModel.showAddCourseSheet) {
            AddCourseSheet(viewModel: viewModel)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .overlay {
            if viewModel.showDeleteConfirmation {
                DeleteConfirmationDialog(
                    courseName: viewModel.courseToDelete?.name ?? "",
                    onConfirm: { viewModel.confirmDelete() },
                    onCancel: { viewModel.cancelDelete() }
                )
            }
        }
    }
    
    
    private var headerSection: some View {
        HStack {
            Text("My Courses")
                .font(AppTheme.textStyle(size: 28, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell.badge")
                    .font(.system(size: 22))
                    .foregroundColor(AppTheme.Colors.purple200)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.top, AppTheme.Spacing.medium)
        .padding(.bottom, AppTheme.Spacing.small)
    }
    
    
    private var searchSection: some View {
        HStack(spacing: AppTheme.Spacing.xSmall) {
            HStack(spacing: AppTheme.Spacing.xxSmall) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.Colors.gray200)
                    .font(.system(size: 16))
                
                TextField("Search courses...", text: $viewModel.searchText)
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(AppTheme.Colors.black100)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.Colors.gray200)
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .padding(.vertical, AppTheme.Spacing.xSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .stroke(AppTheme.Colors.gray100, lineWidth: 1)
            )
            
            Button(action: {}) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppTheme.Colors.purple200)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.small)
    }
    
    
    private var coursesList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: AppTheme.Spacing.small) {
                ForEach(viewModel.courses) { course in
                    Button(action: {
                        viewModel.selectCourse(id: course.id)
                    }) {
                        CourseCardView(
                            course: course,
                            onDelete: {
                                viewModel.requestDelete(course: course)
                            }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
            }
            .padding(.horizontal, AppTheme.Spacing.large)
            .padding(.top, AppTheme.Spacing.xxSmall)
            .padding(.bottom, 80)
        }
    }
    
    
    private var fabButton: some View {
        Button(action: {
            viewModel.resetAddCourseForm()
            viewModel.showAddCourseSheet = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(AppTheme.Colors.white100)
                .frame(width: 56, height: 56)
                .background(AppTheme.Colors.purple200)
                .clipShape(Circle())
                .appShadow(opacity: 0.3, radius: 8, y: 4)
        }
        .padding(.trailing, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.large)
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView(viewModel: CoursesViewModel())
    }
}
