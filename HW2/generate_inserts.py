"""
Генерує hw2_data.sql з INSERT-statements на основі CSV-файлів HW2.
Запустити: python generate_inserts.py
"""

import csv
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
OUTPUT_FILE = os.path.join(BASE_DIR, "hw2_data.sql")

# (csv_filename, table_name, [columns])
TABLES = [
    ("categories.csv",    "categories",    ["id", "name", "description"]),
    ("suppliers.csv",     "suppliers",     ["id", "name", "contact", "address", "city", "postal_code", "country", "phone"]),
    ("shippers.csv",      "shippers",      ["id", "name", "phone"]),
    ("customers.csv",     "customers",     ["id", "name", "contact", "address", "city", "postal_code", "country"]),
    ("employees.csv",     "employees",     ["employee_id", "last_name", "first_name", "birthdate", "photo", "notes"]),
    ("products.csv",      "products",      ["id", "name", "supplier_id", "category_id", "unit", "price"]),
    ("orders.csv",        "orders",        ["id", "customer_id", "employee_id", "date", "shipper_id"]),
    ("order_details.csv", "order_details", ["id", "order_id", "product_id", "quantity"]),
]


def escape(value: str) -> str:
    """Екранує значення для SQL."""
    if value == "" or value is None:
        return "NULL"
    value = value.replace("\\", "\\\\").replace("'", "\\'")
    return f"'{value}'"


with open(OUTPUT_FILE, "w", encoding="utf-8") as out:
    out.write("USE northwind;\n\n")

    for csv_file, table, columns in TABLES:
        path = os.path.join(BASE_DIR, csv_file)
        col_list = ", ".join(columns)

        rows = []
        with open(path, newline="", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            for row in reader:
                values = ", ".join(escape(row[c]) for c in columns)
                rows.append(f"({values})")

        if rows:
            # Вставляємо батчами по 100 рядків
            batch_size = 100
            for i in range(0, len(rows), batch_size):
                batch = rows[i:i + batch_size]
                out.write(f"INSERT INTO {table} ({col_list}) VALUES\n")
                out.write(",\n".join(f"  {r}" for r in batch))
                out.write(";\n\n")

        print(f"  {table}: {len(rows)} rows")

print(f"\nГотово! Файл збережено: {OUTPUT_FILE}")
