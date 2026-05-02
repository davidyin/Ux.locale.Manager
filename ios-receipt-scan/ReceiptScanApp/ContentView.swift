import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \ReceiptRecord.dateScanned, order: .reverse) private var receipts: [ReceiptRecord]

    var body: some View {
        NavigationStack {
            List(receipts) { receipt in
                VStack(alignment: .leading, spacing: 4) {
                    Text(receipt.merchant).font(.headline)
                    Text(receipt.dateScanned.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if let total = receipt.payment.total {
                        Text("Total: \(total, format: .currency(code: "USD"))")
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Receipts")
            .toolbar {
                NavigationLink {
                    ReceiptScanView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
