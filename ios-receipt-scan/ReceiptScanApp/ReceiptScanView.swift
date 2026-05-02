import SwiftUI
import UIKit

struct ReceiptScanView: View {
    @State private var showingCamera = false
    @State private var showingLibrary = false
    @State private var selectedImage: UIImage?
    @State private var isProcessing = false
    @State private var rawText = ""
    @State private var parsed: ParsedReceipt?

    private let ocr = OCRService()

    var body: some View {
        NavigationStack {
            Form {
                Section("Input") {
                    Button("Scan with Camera") { showingCamera = true }
                    Button("Choose from Photos") { showingLibrary = true }
                }

                if let selectedImage {
                    Section("Preview") {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 240)
                    }
                }

                if isProcessing {
                    ProgressView("Extracting receipt text…")
                }

                if let parsed {
                    NavigationLink("Review Extracted Data") {
                        ReceiptReviewView(parsed: parsed, rawText: rawText)
                    }
                }
            }
            .navigationTitle("New Receipt")
            .sheet(isPresented: $showingCamera) {
                ImagePicker(sourceType: .camera) { image in
                    selectedImage = image
                    Task { await process(image: image) }
                }
            }
            .sheet(isPresented: $showingLibrary) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    selectedImage = image
                    Task { await process(image: image) }
                }
            }
        }
    }

    @MainActor
    private func process(image: UIImage) async {
        isProcessing = true
        defer { isProcessing = false }

        do {
            rawText = try await ocr.recognizeText(in: image)
            parsed = ReceiptParser.parse(rawText: rawText)
        } catch {
            rawText = ""
            parsed = nil
        }
    }
}
