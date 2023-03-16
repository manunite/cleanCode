public class ShoppingCart {
  
  public var items = [ProductQuantity]()
  public var productQuantities = [Product: Double]()
  
  func addItem(product: Product) {
    self.addItemQuantity(product: product, quantity: 1.0)
  }
  
  public func addItemQuantity(product: Product , quantity: Double) {
    items.append(ProductQuantity(product: product, quantity:quantity))
    if productQuantities[product] != nil {
      productQuantities[product] = productQuantities[product]! + quantity
    } else {
      productQuantities[product] = quantity
    }
  }
  
  func handleOffers(receipt: Receipt, offers: [Product: Offer], catalog: SupermarketCatalog) {
    productQuantities.enumerated().forEach {
      let product: Product = $0.element.key
      let quantity: Double = $0.element.value
      
      if let offer = offers[product] {
        let unitPrice: Double = catalog.getUnitPrice(product: product)
        let quantityAsInt: Int = Int(quantity)
        var discount: Discount? = nil
        
        switch offer.offerType {
        case .ThreeForTwo:
          let count: Int = 3
          let quantityPerCount: Int = quantityAsInt / count
          
          if quantityAsInt > 2 {
            let left: Double = Double(quantityPerCount * 2) * unitPrice
            let right: Double = Double(quantityAsInt % 3) * unitPrice
            let lastPart: Double = left + right
            let discountAmount = ((quantity) * unitPrice) - lastPart
            
            discount = Discount(description: "3 for 2", discountAmount: discountAmount, product: product)
          }
          
        case .TenPercentDiscount:
          discount =  Discount(description: "\(offer.argument)% off", discountAmount: quantity * unitPrice * offer.argument / 100.0, product: product)
          
        case .TwoForAmount:
          let count: Int = 2
          
          if (quantityAsInt >= 2) {
            let intDivision: Int = quantityAsInt / count
            let pricePerUnit: Double = (offer.argument * Double(intDivision))
            let theTotal: Double = Double(quantityAsInt % 2) * unitPrice
            let total: Double = pricePerUnit + theTotal
            let discountN: Double = unitPrice * quantity - total
            
            discount = Discount(description:  "2 for \(offer.argument)", discountAmount: discountN, product: product)
          }
          
        case .FiveForAmount:
          let count: Int = 5
          let quantityPerCount: Int = quantityAsInt / count
          
          if quantityAsInt >= 5 {
            let left: Double = unitPrice * quantity
            let right: Double = (offer.argument * Double(quantityPerCount)) + (Double(quantityAsInt % 5) * unitPrice)
            let discountTotal = left - right
            
            discount = Discount(description: "\(count) for \(offer.argument)", discountAmount: discountTotal,  product: product)
          }
        }
        
        if let discount = discount {
          receipt.addDiscount(discount: discount)
        }
        
      }
    }
  }
}
