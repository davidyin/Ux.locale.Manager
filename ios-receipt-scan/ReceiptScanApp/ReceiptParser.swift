import Foundation

struct ParsedReceipt {
    var merchant: String
    var items: [ReceiptItem]
    var payment: PaymentInfo
}

enum ReceiptParser {
    static func parse(rawText: String) -> ParsedReceipt {
        let lines = rawText
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let merchant = lines.first ?? "Unknown Merchant"
        var items: [ReceiptItem] = []
        var payment = PaymentInfo()

        let moneyRegex = try? NSRegularExpression(pattern: #"\$?([0-9]+(?:\.[0-9]{2}))"#)

        for line in lines {
            let lower = line.lowercased()
            if lower.contains("subtotal") { payment.subtotal = extractAmount(from: line, regex: moneyRegex) }
            else if lower.contains("tax") { payment.tax = extractAmount(from: line, regex: moneyRegex) }
            else if lower.contains("tip") { payment.tip = extractAmount(from: line, regex: moneyRegex) }
            else if lower.contains("total") { payment.total = extractAmount(from: line, regex: moneyRegex) }
            else if lower.contains("visa") || lower.contains("mastercard") || lower.contains("amex") || lower.contains("card") {
                payment.paymentMethod = line
                payment.cardLast4 = extractLast4(from: line)
            } else if let item = parseItem(line: line, regex: moneyRegex) {
                items.append(item)
            }
        }

        return ParsedReceipt(merchant: merchant, items: items, payment: payment)
    }

    private static func parseItem(line: String, regex: NSRegularExpression?) -> ReceiptItem? {
        guard let price = extractAmount(from: line, regex: regex), price > 0 else { return nil }
        let normalized = line.replacingOccurrences(of: "$", with: "")
        let components = normalized.split(separator: " ").map(String.init)
        guard components.count >= 2 else { return nil }

        var quantity = 1.0
        if let first = Double(components.first ?? "") { quantity = first }

        let name = components.dropFirst().dropLast().joined(separator: " ")
        let finalName = name.isEmpty ? components.dropLast().joined(separator: " ") : name

        return ReceiptItem(name: finalName, quantity: quantity, price: price)
    }

    private static func extractAmount(from text: String, regex: NSRegularExpression?) -> Double? {
        guard let regex else { return nil }
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        guard let match = regex.matches(in: text, range: range).last,
              let valueRange = Range(match.range(at: 1), in: text) else { return nil }
        return Double(text[valueRange])
    }

    private static func extractLast4(from text: String) -> String? {
        let digits = text.filter(\.isNumber)
        guard digits.count >= 4 else { return nil }
        return String(digits.suffix(4))
    }
}
