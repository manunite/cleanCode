public class Receipt {
    var items = [ReceiptItem]()
    var discounts = [Discount]()

    public func getTotalPrice() -> Double {
        var total: Double = 0.0

        items.forEach {
            total += $0.totalPrice
        }
        
        discounts.forEach {
            total -= $0.discountAmount
        }
        
        return total
    }

    public func addProduct(p: Product, quantity: Double, price: Double, totalPrice: Double) {
        self.items.append(ReceiptItem(product: p, price: price, totalPrice: totalPrice, quantity: quantity))
    }

    public func addDiscount(discount: Discount) {
        self.discounts.append(discount)
    }
}
