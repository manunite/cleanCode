public class ReceiptPrinter {
    
    private var columns: Int = 40
    
    public init(columns: Int) {
        self.columns = columns
    }

    private static func presentQuantity(item: ReceiptItem ) -> String {
        return ProductUnit.Each == item.product.unit
        ? String(format: "%x", Int(item.quantity))
        : String(format: "%.3f", item.quantity)
    }
    
    private static func getWhitespace(whitespaceSize: Int) -> String {
        var whitespace = ""
        for _ in 0..<whitespaceSize {
            whitespace.append(" ")
        }
        
        return whitespace
    }
    
    public func printReceipt(receipt: Receipt) -> String {
        var result: String = ""
        
        receipt.items.forEach {
            let price: String = String(format: "%.2f", $0.totalPrice)
            let quantity: String = ReceiptPrinter.presentQuantity(item: $0)
            let name: String = $0.product.name
            let unitPrice: String = String(format :"%.2f", $0.price)
            
            let whitespaceSize: Int = columns - name.count - price.count
            let line: String = String.init(format: "%@%@%@\n", name, ReceiptPrinter.getWhitespace(whitespaceSize: whitespaceSize), price)
            
            var surfix: String = ""
            if ($0.quantity != 1) {
                surfix = String.init(format: "  %@ * %@\n", unitPrice, quantity)
            }
            
            result.append(line + surfix)
        }
        
        var discountString: String = ""
        receipt.discounts.forEach {
            let productPresentation = $0.product.name
            let pricePresentation = String(format: "%.2f", $0.discountAmount)
            let description = $0.description
            
            let whiteSpace: String = ReceiptPrinter.getWhitespace(whitespaceSize: self.columns - 3 - productPresentation.count - description.count - pricePresentation.count)
            
            let appendString: String = String.init(format: "%@(%@)%@-%@\n", description, productPresentation, whiteSpace, pricePresentation)
            discountString.append(appendString)
        }
        
        result.append(discountString)
        result.append("\n")
        
        let pricePresentation = String(format: "%.2f", Double(receipt.getTotalPrice()))
        let total = "Total: "
        let whitespace = ReceiptPrinter.getWhitespace(whitespaceSize: self.columns - total.count - pricePresentation.count)
        
        let appendString: String = String.init(format: "%@%@%@", total, whitespace, pricePresentation)
        result.append(appendString)
        
        return result
    }
}
