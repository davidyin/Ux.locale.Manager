import SwiftUI
import SwiftData

struct ReceiptReviewView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State var parsed: ParsedReceipt
    let rawText: String
    @StateObject private var store = ReceiptStore()

    var body: some View {
        Form {
            Section("Merchant") {
                TextField("Merchant", text: $parsed.merchant)
            }

            Section("Items") {
                ForEach($parsed.items) { $item in
                    VStack(alignment: .leading) {
                        TextField("Name", text: $item.name)
                        HStack {
                            TextField("Qty", value: $item.quantity, format: .number)
                            TextField("Price", value: $item.price, format: .currency(code: "USD"))
                        }
                    }
                }
            }

            Section("Payment") {
                TextField("Method", text: Binding($parsed.payment.paymentMethod, replacingNilWith: ""))
                TextField("Card last 4", text: Binding($parsed.payment.cardLast4, replacingNilWith: ""))
                TextField("Subtotal", value: Binding($parsed.payment.subtotal, default: 0), format: .currency(code: "USD"))
                TextField("Tax", value: Binding($parsed.payment.tax, default: 0), format: .currency(code: "USD"))
                TextField("Tip", value: Binding($parsed.payment.tip, default: 0), format: .currency(code: "USD"))
                TextField("Total", value: Binding($parsed.payment.total, default: 0), format: .currency(code: "USD"))
            }

            Button("Save Receipt") {
                store.save(parsed: parsed, rawText: rawText, context: modelContext)
                dismiss()
            }
        }
        .navigationTitle("Review")
    }
}

private extension Binding where Value == String? {
    init(_ source: Binding<String?>, replacingNilWith defaultValue: String) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0.isEmpty ? nil : $0 }
        )
    }
}

private extension Binding where Value == Double? {
    init(_ source: Binding<Double?>, default defaultValue: Double) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}
