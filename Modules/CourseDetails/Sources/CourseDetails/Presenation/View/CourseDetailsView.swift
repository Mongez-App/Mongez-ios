//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common
import UniformTypeIdentifiers

public struct CourseDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CourseDetailsViewModel
    @State private var showEditSheet: Bool = false
    @State private var showDeleteCourseWarning: Bool = false
    @State private var materialToDelete: String? = nil
    
    public init(viewModel: CourseDetailsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CourseHeaderView(
                title: viewModel.courseName,
                onBack: { dismiss() },
                onEdit: { showEditSheet = true },
                onDelete: {
                    showDeleteCourseWarning = true
                }
            )
            .sheet(isPresented: $showEditSheet) {
                EditCourseSheetView(initialCourseName: viewModel.courseName) { name in
                    Task {
                        await viewModel.updateCourse(name: name)
                    }
                }
                    .presentationDetents([.fraction(0.85)])
            }
            
            CourseTabBarView(selectedTab: $viewModel.selectedTab)
            
            if viewModel.selectedTab == 0 {
                CourseMaterialsTabView(
                    materials: viewModel.materials,
                    courseType: viewModel.courseType,
                    onUploadAction: {
                        viewModel.showFileImporter = true
                    },
                    onDeleteMaterial: { materialId in
                        materialToDelete = materialId
                    }
                )
            } else {
                CourseTasksTabView(viewModel: viewModel)
            }
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .task {
            await viewModel.loadData()
        }
        .fileImporter(
            isPresented: $viewModel.showFileImporter,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    Task {
                        await viewModel.uploadMaterial(fileURL: url)
                    }
                }
            case .failure(let error):
                print("Error selecting file: \(error.localizedDescription)")
            }
        }
        .overlay {
            if viewModel.isUploading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Uploading...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
            if showDeleteCourseWarning {
                WarningAlertView(
                    title: "Delete Course",
                    subtitle: "Are you sure you want to delete this course?",
                    onPrimaryAction: {
                        showDeleteCourseWarning = false
                        Task {
                            await viewModel.deleteCourse()
                            dismiss()
                        }
                    },
                    onCancel: {
                        showDeleteCourseWarning = false
                    }
                )
            }
            if let materialId = materialToDelete {
                WarningAlertView(
                    title: "Delete Material",
                    subtitle: "Are you sure you want to delete this material?",
                    onPrimaryAction: {
                        let id = materialId
                        materialToDelete = nil
                        Task {
                            await viewModel.deleteMaterial(materialId: id)
                        }
                    },
                    onCancel: {
                        materialToDelete = nil
                    }
                )
            }
        }
    }
}
