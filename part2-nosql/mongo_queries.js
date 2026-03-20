// Connect to MongoDB
// Use: use ecommerce_db

// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    product_id: "ELEC001",
    name: "UltraBook Pro X1",
    category: "Electronics",
    price: 89999,
    description: "High-performance laptop with 16GB RAM and 1TB SSD",
    specifications: {
      brand: "TechMaster",
      model: "UM-X1-2024",
      weight: "1.2 kg",
      dimensions: {
        width: "30.4 cm",
        depth: "21.2 cm",
        height: "1.5 cm"
      },
      processor: "Intel Core i7-1355U",
      ram: "16GB LPDDR5",
      storage: "1TB NVMe SSD",
      display: "14-inch 4K OLED",
      battery_life: "12 hours"
    },
    warranty: {
      period_months: 24,
      type: "Manufacturer Warranty",
      terms: "Parts and labor included"
    },
    voltage: "100-240V",
    power_consumption: "65W",
    in_stock: true,
    ratings: [
      { user_id: "USER123", rating: 4.5, review: "Excellent performance for development work" },
      { user_id: "USER456", rating: 5, review: "Battery life is amazing!" }
    ],
    created_at: new Date("2024-01-15T10:30:00Z")
  },
  {
    product_id: "CLTH001",
    name: "Premium Cotton T-Shirt",
    category: "Clothing",
    price: 1299,
    description: "100% organic cotton t-shirt with classic fit",
    specifications: {
      brand: "NatureWear",
      material: "100% Organic Cotton",
      sizes_available: ["S", "M", "L", "XL", "XXL"],
      colors: [
        { color_name: "Navy Blue", hex_code: "#000080", stock_quantity: 50 },
        { color_name: "Charcoal Gray", hex_code: "#36454F", stock_quantity: 35 },
        { color_name: "Forest Green", hex_code: "#228B22", stock_quantity: 28 }
      ],
      care_instructions: ["Machine wash cold", "Tumble dry low", "Do not bleach"],
      fit: "Regular",
      fabric_weight: "180 GSM"
    },
    manufacturer_details: {
      name: "EcoFashion Ltd",
      country: "India",
      certifications: ["GOTS Certified", "Fair Trade"]
    },
    in_stock: true,
    ratings: [{ user_id: "USER789", rating: 4, review: "Very comfortable fabric" }],
    created_at: new Date("2024-01-10T14:15:00Z")
  },
  {
    product_id: "GROC001",
    name: "Organic Whole Wheat Bread",
    category: "Groceries",
    price: 89,
    description: "Freshly baked organic whole wheat bread, no preservatives",
    specifications: {
      brand: "FreshFarm",
      weight: "400g",
      ingredients: ["Organic whole wheat flour", "Water", "Organic yeast", "Sea salt"],
      allergens: ["Gluten"],
      dietary_info: ["Vegan", "No added sugar", "High fiber"],
      storage_instructions: "Store in cool, dry place. Refrigerate after opening."
    },
    expiry_details: {
      expiry_date: new Date("2024-02-28"),
      manufacturing_date: new Date("2024-01-20"),
      batch_number: "FW240120-001",
      shelf_life_days: 40
    },
    nutritional_info: {
      serving_size: "50g (1 slice)",
      calories: 120,
      protein: "4g",
      carbohydrates: "22g",
      fat: "1.5g",
      fiber: "3g"
    },
    in_stock: true,
    created_at: new Date("2024-01-20T08:00:00Z")
  }
]);

// OP2: find() — retrieve all Electronics products with price > 20000
db.products.find({
  category: "Electronics",
  price: { $gt: 20000 }
}).pretty();

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find({
  category: "Groceries",
  "expiry_details.expiry_date": { $lt: new Date("2025-01-01") }
}).pretty();

// OP4: updateOne() — add a "discount_percent" field to a specific product
// Example: Add 15% discount to the UltraBook Pro X1
db.products.updateOne(
  { product_id: "ELEC001" },
  { 
    $set: { 
      discount_percent: 15,
      discounted_price: 89999 * 0.85,
      discount_valid_until: new Date("2024-03-31")
    } 
  }
);

// Verify the update
db.products.findOne({ product_id: "ELEC001" });

// OP5: createIndex() — create an index on category field and explain why
db.products.createIndex(
  { category: 1 },
  { 
    name: "idx_category",
    background: true
  }
);

// Explain why this index is beneficial:
/*
REASONING FOR INDEX ON CATEGORY FIELD:

1. Query Performance: The e-commerce platform will frequently query products by category
   (e.g., "show all Electronics", "filter by Groceries"). Without an index, MongoDB would
   perform a collection scan (COLLSCAN) for every category query, which becomes
   increasingly slow as the product catalog grows.

2. Filtering Efficiency: Category is a highly selective filter used in combination with
   price ranges, availability, and sorting. An index on category allows MongoDB to
   quickly locate relevant documents before applying additional filters.

3. Aggregation Performance: Analytics queries that group by category (e.g., average price
   per category, total inventory value by category) benefit significantly from this index.

4. Compound Index Potential: This single-field index can serve as a prefix for compound
   indexes like { category: 1, price: -1 } for category-based price sorting.

5. Cardinality: With only 3 categories (Electronics, Clothing, Groceries), the index
   has low cardinality but still provides significant performance benefits by reducing
   the number of documents scanned in queries with category filters.
*/

// Optional: Verify the index was created
db.products.getIndexes();