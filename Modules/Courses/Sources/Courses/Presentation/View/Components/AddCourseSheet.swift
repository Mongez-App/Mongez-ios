import SwiftUI
import Common
import PhotosUI

struct AddCourseSheet: View {
    @ObservedObject var viewModel: CoursesViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                
                HStack {
                    Text("Add New Course")
                        .font(AppTheme.textStyle(size: 22, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.gray200)
                            .frame(width: 28, height: 28)
                            .background(
                                Circle()
                                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.3))
                            )
                    }
                }
                .padding(.top, AppTheme.Spacing.small)
                
                
                HStack(spacing: 0) {
                    tabButton(
                        title: "Online Course",
                        icon: "link",
                        isSelected: viewModel.addCourseTab == .onlineCourse,
                        action: { viewModel.addCourseTab = .onlineCourse }
                    )
                    
                    tabButton(
                        title: "Upload Material",
                        icon: "folder",
                        isSelected: viewModel.addCourseTab == .uploadMaterial,
                        action: { viewModel.addCourseTab = .uploadMaterial }
                    )
                }
                .padding(AppTheme.Spacing.xxxSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.2))
                )
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                        switch viewModel.addCourseTab {
                        case .onlineCourse:
                            onlineCourseForm
                        case .uploadMaterial:
                            uploadMaterialForm
                        }
                    }
                }
                
                Spacer()
                
                
                Button(action: {
                    viewModel.addCourse()
                    dismiss()
                }) {
                    Text("Add Course")
                        .font(AppTheme.textStyle(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.white100)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.small)
                        .background(AppTheme.Colors.purple200)
                        .cornerRadius(AppTheme.radius.small)
                }
                .padding(.bottom, AppTheme.Spacing.small)
            }
            .padding(.horizontal, AppTheme.Spacing.large)
            .background(AppTheme.Colors.white100.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    
    private var onlineCourseForm: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Course URL")
                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            
            TextField("https://example.com/course-link", text: $viewModel.courseURL)
                .font(AppTheme.textStyle(size: 14, weight: .regular))
                .foregroundColor(AppTheme.Colors.black100)
                .padding(AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                )
                .autocapitalization(.none)
                .keyboardType(.URL)
            
            deadlinePicker
        }
    }
    
    
    private var uploadMaterialForm: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Course Name")
                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            
            TextField("e.g. Operating Systems", text: $viewModel.courseName)
                .font(AppTheme.textStyle(size: 14, weight: .regular))
                .foregroundColor(AppTheme.Colors.black100)
                .padding(AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                )
            
            deadlinePicker
            
            
            Text("Thumbnail")
                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            
            PhotosPicker(
                selection: $viewModel.selectedImageItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                if let imageData = viewModel.selectedImageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                        )
                } else {
                    VStack(spacing: AppTheme.Spacing.xxSmall) {
                        Image(systemName: "photo")
                            .font(.system(size: 28))
                            .foregroundColor(AppTheme.Colors.green100)
                        
                        Text("Upload cover image")
                            .font(AppTheme.textStyle(size: 13, weight: .medium))
                            .foregroundColor(AppTheme.Colors.black100)
                        
                        Text("PNG or JPG, up to 5 MB")
                            .font(AppTheme.textStyle(size: 11, weight: .regular))
                            .foregroundColor(AppTheme.Colors.gray200)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.medium)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .stroke(AppTheme.Colors.gray100, style: StrokeStyle(lineWidth: 1, dash: [6, 3]))
                    )
                }
            }
            
            
            HStack {
                Text("Course Material")
                    .font(AppTheme.textStyle(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                Text("(PDFs, slides, notes)")
                    .font(AppTheme.textStyle(size: 12, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
            }
            
            VStack(spacing: AppTheme.Spacing.xxSmall) {
                Image(systemName: "plus")
                    .font(.system(size: 24))
                    .foregroundColor(AppTheme.Colors.purple200)
                
                Text("Upload material")
                    .font(AppTheme.textStyle(size: 13, weight: .medium))
                    .foregroundColor(AppTheme.Colors.black100)
                
                Text("Tap to browse files")
                    .font(AppTheme.textStyle(size: 11, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .stroke(AppTheme.Colors.gray100, style: StrokeStyle(lineWidth: 1, dash: [6, 3]))
            )
            
            
            HStack(spacing: AppTheme.Spacing.xxSmall) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.red100, opacity: 0.1))
                        .frame(width: 36, height: 36)
                    
                    Text("PDF")
                        .font(AppTheme.textStyle(size: 9, weight: .bold))
                        .foregroundColor(AppTheme.Colors.red100)
                }
                
                Text("Chapter 1 - Introduction.pdf")
                    .font(AppTheme.textStyle(size: 13, weight: .regular))
                    .foregroundColor(AppTheme.Colors.black100)
                    .lineLimit(1)
                
                Spacer()
                
                Text("4.2 MB")
                    .font(AppTheme.textStyle(size: 11, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
            }
            .padding(AppTheme.Spacing.xxSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .stroke(AppTheme.Colors.gray100, lineWidth: 1)
            )
        }
    }
    
    
    private var deadlinePicker: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text("Deadline")
                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            
            HStack {
                DatePicker(
                    "",
                    selection: $viewModel.courseDeadline,
                    in: Date()...,
                    displayedComponents: .date
                )
                .labelsHidden()
                .accentColor(AppTheme.Colors.purple200)
                
                Spacer()
                
                Image(systemName: "calendar")
                    .foregroundColor(AppTheme.Colors.purple200)
                    .font(.system(size: 18))
            }
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .padding(.vertical, AppTheme.Spacing.xxSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .stroke(AppTheme.Colors.gray100, lineWidth: 1)
            )
        }
    }
    
    
    private func tabButton(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.xxxSmall) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                
                Text(title)
                    .font(AppTheme.textStyle(size: 13, weight: .medium))
            }
            .foregroundColor(isSelected ? AppTheme.Colors.purple200 : AppTheme.Colors.gray200)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.xxSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small - 2)
                    .fill(isSelected ? Color.white : Color.clear)
                    .appShadow(opacity: isSelected ? 0.1 : 0, radius: 4, y: 1)
            )
        }
    }
}

struct AddCourseSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddCourseSheet(viewModel: CoursesViewModel())
    }
}
