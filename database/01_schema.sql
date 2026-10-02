CREATE DATABASE IF NOT EXISTS customer_intelligence;
USE customer_intelligence;

DROP TABLE IF EXISTS returns;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    gender VARCHAR(20),
    age INT,
    city VARCHAR(50),
    signup_date DATE,
    acquisition_channel VARCHAR(30)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(120) NOT NULL,
    category VARCHAR(50),
    brand VARCHAR(50),
    cost_price DECIMAL(10,2),
    selling_price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE,
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    unit_price DECIMAL(10,2),
    discount DECIMAL(5,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(12,2),
    payment_method VARCHAR(30),
    payment_status VARCHAR(20),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_item_id INT NOT NULL,
    quantity_returned INT,
    return_reason VARCHAR(50),
    refund_amount DECIMAL(12,2),
    return_date DATE,
    FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id)
);

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    snapshot_date DATE,
    units_received INT,
    units_sold INT,
    closing_stock INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
