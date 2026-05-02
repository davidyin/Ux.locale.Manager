import Foundation
import SwiftData

@MainActor
final class ReceiptStore: ObservableObject {
    func save(parsed: ParsedReceipt, rawText: String, context: ModelContext) {
        let record = ReceiptRecord(
            merchant: parsed.merchant,
            rawText: rawText,
            items: parsed.items,
            payment: parsed.payment
        )
        context.insert(record)
        try? context.save()
    }
}
