import SwiftUI
import SwiftData

@main
struct ReceiptScanAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [ReceiptRecord.self])
        }
    }
}
