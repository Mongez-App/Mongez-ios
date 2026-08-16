import SwiftUI
import PDFKit

public struct WebView: View {
    public let url: URL
    @State private var pdfDocument: PDFDocument?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        ZStack {
            if let document = pdfDocument {
                PDFViewWrapper(document: document)
            } else if isLoading {
                ProgressView("Loading PDF...")
            } else {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("Failed to load PDF")
                        .font(.headline)
                        .padding(.top, 8)
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            loadPDF()
        }
    }
    
    private func loadPDF() {
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    await MainActor.run {
                        self.errorMessage = "Invalid response type. URL scheme might not be supported (e.g. content://)."
                        self.isLoading = false
                    }
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    await MainActor.run {
                        self.errorMessage = "Server returned status code \(httpResponse.statusCode)\nHost: \(url.host ?? "unknown")"
                        self.isLoading = false
                    }
                    return
                }
                
                // Let's create the document from the data
                if let document = PDFDocument(data: data) {
                    await MainActor.run {
                        self.pdfDocument = document
                        self.isLoading = false
                    }
                } else {
                    await MainActor.run {
                        self.errorMessage = "The downloaded data is not a valid PDF file."
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

public struct PDFViewWrapper: UIViewRepresentable {
    let document: PDFDocument
    
    public func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        return pdfView
    }
    
    public func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = document
    }
}
