# Receipt Scan iOS App (SwiftUI)

A SwiftUI sample app that scans a receipt, extracts purchased items and payment details, then lets users review/edit before saving.

## Features

- Scan/import receipt image using camera or photo library.
- OCR with Apple Vision (`VNRecognizeTextRequest`).
- Heuristic parsing for:
  - Line items (`name`, `quantity`, `price`).
  - Payment info (`subtotal`, `tax`, `tip`, `total`, `payment method`, `last4`, `transaction date`).
- Editable review screen for corrected data.
- Local persistence with `SwiftData`.

## Requirements

- iOS 17+
- Xcode 15+

## Project structure

- `ReceiptScanAppApp.swift`: App entry.
- `Models.swift`: Item/payment/receipt models.
- `OCRService.swift`: Vision OCR extraction.
- `ReceiptParser.swift`: Parsing raw text to structured data.
- `ReceiptStore.swift`: Save/list receipts.
- `ContentView.swift`: List + add receipt flow.
- `ReceiptScanView.swift`: Image capture/import and OCR processing.
- `ReceiptReviewView.swift`: Edit item/payment fields and save.

## Notes

To enable camera usage in a full Xcode app target, add:

- `NSCameraUsageDescription`
- `NSPhotoLibraryUsageDescription`

in your app `Info.plist`.
