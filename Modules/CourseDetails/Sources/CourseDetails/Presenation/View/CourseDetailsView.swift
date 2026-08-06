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
                    onUploadAction: { viewModel.showFileImporter = true },
                    onDeleteAction: { material in
                        viewModel.requestDeleteMaterial(material)
                    }
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
            allowedContentTypes: CourseDetailsView.supportedMaterialTypes,
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
            if viewModel.isUploading || viewModel.isDeletingMaterialId != nil {
                ProgressView(viewModel.isDeletingMaterialId != nil ? "Deleting..." : "Uploading...")
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .alert(
            "Error",
            isPresented: .init(
                get: { viewModel.uploadError != nil || viewModel.deleteError != nil },
                set: { if !$0 { viewModel.uploadError = nil; viewModel.deleteError = nil } }
            )
        ) {
            Button("OK", role: .cancel) {
                viewModel.uploadError = nil
                viewModel.deleteError = nil
            }
        } message: {
            Text(viewModel.uploadError ?? viewModel.deleteError ?? "")
        }
        .confirmationDialog(
            "Delete this material?",
            isPresented: .init(
                get: { viewModel.materialPendingDeletion != nil },
                set: { if !$0 { viewModel.materialPendingDeletion = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                viewModel.confirmDeleteMaterial()
            }
            Button("Cancel", role: .cancel) {
                viewModel.materialPendingDeletion = nil
            }
        } message: {
            Text("Deleting this material will regenerate the task plan for this course.")
        }
        .task {
            await viewModel.loadData()
        }
    }

    /// PDF, DOC/DOCX and TXT materials are supported by the study plan generator.
    private static var supportedMaterialTypes: [UTType] {
        var types: [UTType] = [.pdf, .plainText, .text]
        if let doc = UTType(filenameExtension: "doc") { types.append(doc) }
        if let docx = UTType(filenameExtension: "docx") { types.append(docx) }
        return types
    }
}