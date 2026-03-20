-- Create and use the database
CREATE DATABASE IF NOT EXISTS retail_db;
USE retail_db;

-- Drop existing tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS SalesRepresentatives;
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL UNIQUE,
    customer_city VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create SalesRepresentatives table
CREATE TABLE SalesRepresentatives (
    sales_rep_id VARCHAR(10) PRIMARY KEY,
    sales_rep_name VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(100) NOT NULL UNIQUE,
    office_address VARCHAR(200) NOT NULL,
    hire_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Products table
CREATE TABLE Products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Orders table (header)
CREATE TABLE Orders (
    order_id VARCHAR(10) PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id VARCHAR(10) NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (sales_rep_id) REFERENCES SalesRepresentatives(sales_rep_id)
);

-- Create OrderDetails table (line items)
CREATE TABLE OrderDetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price_at_time DECIMAL(10, 2) NOT NULL CHECK (unit_price_at_time > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert sample data for Customers (based on actual data)
INSERT INTO Customers (customer_id, customer_name, customer_email, customer_city) VALUES
('C001', 'Rohan Mehta', 'rohan@gmail.com', 'Mumbai'),
('C002', 'Priya Sharma', 'priya@gmail.com', 'Delhi'),
('C003', 'Amit Verma', 'amit@gmail.com', 'Bangalore'),
('C004', 'Sneha Iyer', 'sneha@gmail.com', 'Chennai'),
('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
('C006', 'Neha Gupta', 'neha@gmail.com', 'Delhi'),
('C007', 'Arjun Nair', 'arjun@gmail.com', 'Bangalore'),
('C008', 'Kavya Rao', 'kavya@gmail.com', 'Hyderabad');

-- Insert sample data for SalesRepresentatives
INSERT INTO SalesRepresentatives (sales_rep_id, sales_rep_name, sales_rep_email, office_address) VALUES
('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
('SR02', 'Anita Desai', 'anita@corp.com', 'Delhi Office, Connaught Place, New Delhi - 110001'),
('SR03', 'Ravi Kumar', 'ravi@corp.com', 'South Zone, MG Road, Bangalore - 560001');

-- Insert sample data for Products
INSERT INTO Products (product_id, product_name, category, unit_price) VALUES
('P001', 'Laptop', 'Electronics', 55000.00),
('P002', 'Mouse', 'Electronics', 800.00),
('P003', 'Desk Chair', 'Furniture', 8500.00),
('P004', 'Notebook', 'Stationery', 120.00),
('P005', 'Headphones', 'Electronics', 3200.00),
('P006', 'Standing Desk', 'Furniture', 22000.00),
('P007', 'Pen Set', 'Stationery', 250.00),
('P008', 'Webcam', 'Electronics', 2100.00);

-- Insert sample data for Orders (based on actual data)
INSERT INTO Orders (order_id, order_date, customer_id, sales_rep_id) VALUES
('ORD1000', '2023-05-21', 'C002', 'SR03'),
('ORD1001', '2023-02-22', 'C004', 'SR03'),
('ORD1002', '2023-01-17', 'C002', 'SR02'),
('ORD1003', '2023-09-16', 'C002', 'SR01'),
('ORD1004', '2023-11-29', 'C001', 'SR01'),
('ORD1005', '2023-10-29', 'C007', 'SR02'),
('ORD1006', '2023-12-24', 'C001', 'SR01'),
('ORD1007', '2023-04-21', 'C006', 'SR01'),
('ORD1008', '2023-02-19', 'C002', 'SR02'),
('ORD1009', '2023-01-23', 'C006', 'SR02'),
('ORD1010', '2023-10-10', 'C002', 'SR01');

-- Insert sample data for OrderDetails
INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price_at_time) VALUES
('ORD1000', 'P001', 2, 55000.00),
('ORD1001', 'P002', 5, 800.00),
('ORD1002', 'P005', 1, 3200.00),
('ORD1003', 'P002', 5, 800.00),
('ORD1004', 'P005', 5, 3200.00),
('ORD1005', 'P002', 3, 800.00),
('ORD1006', 'P007', 4, 250.00),
('ORD1007', 'P003', 3, 8500.00),
('ORD1008', 'P001', 3, 55000.00),
('ORD1009', 'P005', 4, 3200.00),
('ORD1010', 'P004', 3, 120.00);