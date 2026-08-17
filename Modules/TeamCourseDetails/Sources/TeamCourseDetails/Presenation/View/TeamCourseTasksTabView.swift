//
//  File.swift
//
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct TeamCourseTasksTabView: View {
    @ObservedObject var viewModel: TeamCourseDetailsViewModel
    
    public init(viewModel: TeamCourseDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text("This feature is coming soon")
                .font(.custom("Urbanist-SemiBold", size: 18))
                .foregroundColor(AppTheme.Colors.gray300)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
