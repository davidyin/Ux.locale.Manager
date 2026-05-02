import Foundation
import SwiftData

struct ReceiptItem: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var quantity: Double
    var price: Double
}

struct PaymentInfo: Codable, Hashable {
    var subtotal: Double?
    var tax: Double?
    var tip: Double?
    var total: Double?
    var paymentMethod: String?
    var cardLast4: String?
    var transactionDate: Date?
}

@Model
final class ReceiptRecord {
    var id: UUID
    var merchant: String
    var dateScanned: Date
    var rawText: String
    var itemsData: Data
    var paymentData: Data

    init(
        id: UUID = UUID(),
        merchant: String,
        dateScanned: Date = .now,
        rawText: String,
        items: [ReceiptItem],
        payment: PaymentInfo
    ) {
        self.id = id
        self.merchant = merchant
        self.dateScanned = dateScanned
        self.rawText = rawText
        self.itemsData = (try? JSONEncoder().encode(items)) ?? Data()
        self.paymentData = (try? JSONEncoder().encode(payment)) ?? Data()
    }

    var items: [ReceiptItem] {
        get { (try? JSONDecoder().decode([ReceiptItem].self, from: itemsData)) ?? [] }
        set { itemsData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    var payment: PaymentInfo {
        get { (try? JSONDecoder().decode(PaymentInfo.self, from: paymentData)) ?? PaymentInfo() }
        set { paymentData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }
}
