//
//  ContentView.swift
//  Mongez
//
//  Created by mohamed sharaf on 15/07/2026.
//
import Common
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        ZStack{
            AppTheme.Colors.purple100.ignoresSafeArea()
            Text("Shady")
                .foregroundColor(AppTheme.Colors.gray100)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
