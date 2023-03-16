public class Teller {
  
  private let catalog: SupermarketCatalog
  private var offers = [Product: Offer]()
  
  public init(catalog: SupermarketCatalog) {
    self.catalog = catalog
  }
  
  public func addSpecialOffer(offerType: SpecialOfferType, product: Product, argument: Double) {
    self.offers[product] = Offer(offerType: offerType, product: product, argument: argument)
  }
  
  public func checksOutArticlesFrom(theCart: ShoppingCart) -> Receipt {
    let receipt = Receipt()
    let productQuantities = theCart.items
    
    productQuantities.forEach {
      let unitPrice = catalog.getUnitPrice(product: $0.product)
      let price = $0.quantity * unitPrice
      let priceTo3dp = round(100 * price) / 100
      receipt.addProduct(p: $0.product, quantity: $0.quantity, price: unitPrice, totalPrice: priceTo3dp)
    }
    
    theCart.handleOffers(receipt: receipt, offers: offers, catalog: catalog)
    
    return receipt
  }
  
}
