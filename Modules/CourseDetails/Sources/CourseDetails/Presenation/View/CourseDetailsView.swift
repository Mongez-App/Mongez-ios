import Foundation
import SwiftUI
import Common
import UniformTypeIdentifiers

public struct CourseDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CourseDetailsViewModel
    @State private var showEditSheet: Bool = false
    
    public init(viewModel: CourseDetailsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CourseHeaderView(
                title: "Course Details",
                onBack: { dismiss() },
                onEdit: { showEditSheet = true },
                onDelete: {  }
            )
            .sheet(isPresented: $showEditSheet) {
                EditCourseSheetView()
                    .presentationDetents([.fraction(0.85)])
            }
            
            CourseTabBarView(selectedTab: $viewModel.selectedTab)
            
            if viewModel.selectedTab == 0 {
                CourseMaterialsTabView(
                    materials: viewModel.materials,
                    onUploadAction: { viewModel.showFileImporter = true }
                )
            } else {
                CourseTasksTabView(viewModel: viewModel)
            }
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .fileImporter(
            isPresented: $viewModel.showFileImporter,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    viewModel.uploadMaterial(from: url)
                }
            case .failure(let error):
                viewModel.uploadError = error.localizedDescription
            }
        }
        .overlay {
            if viewModel.isUploading {
                ProgressView("Uploading...")
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .alert("Upload Error", isPresented: .init(
            get: { viewModel.uploadError != nil },
            set: { if !$0 { viewModel.uploadError = nil } }
        )) {
            Button("OK", role: .cancel) { viewModel.uploadError = nil }
        } message: {
            Text(viewModel.uploadError ?? "")
        }
        .task {
            await viewModel.loadData()
        }
    }
}
