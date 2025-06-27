class IPricingCalculator {
  // Returns fixed tax rate for a location, can be extended for dynamic rates
  static double getTaxRateForLocation(String location) {
    // For now, always 10%
    return 0.10;
  }

  // Returns fixed shipping cost for a location, can be extended for dynamic costs
  static double getShippingCost(String location) {
    // For now, always $5.00
    return 5.00;
  }

  // Calculates tax amount on product price based on location, returns as fixed string with 2 decimals
  static String calculateTax(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;
    return taxAmount.toStringAsFixed(2);
  }

  // Calculates shipping cost, returns as string with fixed decimals (let's say 2)
  static String calculateShippingCost(double shippingCost, String location) {
    // For now, ignoring passed shippingCost and location param and using getShippingCost
    double cost = getShippingCost(location);
    return cost.toStringAsFixed(2);
  }

  // Calculates total price: product price + tax + shipping, returns total price as double
  static double calculateTotalPrice(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;
    double shippingCost = getShippingCost(location);
    double totalPrice = productPrice + taxAmount + shippingCost;
    return totalPrice;
  }
}
