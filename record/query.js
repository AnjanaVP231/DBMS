// 1. Create Database & Collection
use labDB;
db.createCollection("users");

// 2. Insert Documents
db.users.insertMany([
  { name: "Alice", age: 25, city: "Delhi", skills: ["Java", "Python"], address: { state: "DL" } },
  { name: "Bob", age: 30, city: "Mumbai", skills: ["C", "C++"], address: { state: "MH" } },
  { name: "Charlie", age: 28, city: "Chennai", skills: ["Python"], address: { state: "TN" } }
]);

// 3. Read
db.users.find();

// 4. Projection
db.users.find({}, { name: 1, age: 1, _id: 0 });

// 5. Update Queries
db.users.updateOne(
  { name: "Alice" },
  { $set: { age: 26 } }
);

// 6. Delete Queries
db.users.deleteOne({ name: "Charlie" });

// 7. Sorting
db.users.find().sort({ age: 1 });
db.users.find().sort({ age: -1 });

// 8. Limit & Skip
db.users.find().limit(2);
db.users.find().skip(1);

// 9. Aggregation Framework
db.users.aggregate([
  { $match: { age: { $gt: 25 } } },
  { $sort: { age: -1 } }
]);

// 10. Match and Group
db.users.aggregate([
  { $match: { age: { $gt: 20 } } },
  { $group: { _id: "$city", total: { $sum: 1 } } }
]);

// 11. Lookup (Join-like)
db.createCollection("orders");

db.orders.insertMany([
  { user: "Alice", product: "Laptop" },
  { user: "Bob", product: "Phone" }
]);

db.users.aggregate([
  {
    $lookup: {
      from: "orders",
      localField: "name",
      foreignField: "user",
      as: "orders"
    }
  }
]);

// 12. Indexing
db.users.createIndex({ name: 1 });

// 13. Text Search
db.users.createIndex({ city: "text" });
db.users.find({ $text: { $search: "Delhi" } });

// 14. Count Documents
db.users.countDocuments();

// 15. Distinct Values
db.users.distinct("city");

// 16. Embedded Document Query
db.users.find({ "address.state": "MH" });

// 17. Array Query
db.users.find({ skills: "Python" });

// 18. Bulk Operations
db.users.insertMany([
  { name: "David", age: 35 },
  { name: "Eva", age: 22 }
]);
