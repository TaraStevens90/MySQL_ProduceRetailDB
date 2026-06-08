# **ProduceRetailDB – SQL Retail Management System**

A SQL Server database project demonstrating schema design, data integrity, transactions, triggers, security, and backup operations.

---

## **📌 Project Overview**

ProduceRetailDB is a fully designed SQL Server database created for a comprehensive SQL II final project. The goal was to build a functional retail management system that supports customers, orders, products, and inventory workflows while demonstrating real‑world database concepts such as:

- Normalized table design  
- Data validation and constraints  
- Transactions and error handling  
- Triggers for automated data enforcement  
- Role‑based security  
- Backup and recovery  
- Testing and verification queries  

This project simulates the backend of a small fruit and vegetable retail business and is structured to be scalable, maintainable, and production‑ready.

---

## **🗂️ Database Schema**

The database includes the following core tables:

- **Customers** – customer profiles and contact information  
- **Products** – product catalog  
- **Orders** – order headers  
- **OrderItems** – line‑item details for each order  
- **Inventory** – stock levels  

Each table includes primary keys, foreign keys, and appropriate data types to ensure referential integrity.

---

## **🧩 Step‑by‑Step Implementation**

### **Steps 1–6: Schema Creation & Data Population**

- Created all required tables with primary keys, foreign keys, and constraints, including a `CHECK` constraint to prevent negative inventory quantities.  
- Inserted sample data for customers, products, orders, order items, and inventory.  
- Created a view to generate receipt totals using common aggregate functions.  
- Built multiple stored procedures for common retail sales metrics, including filtering with multiple parameters.  
- Ensured normalization and a clean relational structure.

---

### **Step 7: Data Standardization & Trigger Creation**

#### **Part 1 – Capitalize All Existing Customer Last Names**  
A transaction was used to update all existing customer last names to uppercase.

#### **Part 2 – Trigger to Enforce Uppercase on Future Inserts/Updates**  
A trigger was created to automatically uppercase last names whenever a customer is added or modified.

#### **Part 3 – Trigger Testing**  
A test insert was wrapped in a transaction and rolled back to keep the table clean.

---

### **Step 8: Inventory‑Safe Order Transaction**

A full transaction block was created to ensure that orders cannot be placed for items that are out of stock.

**Logic flow:**

- Check inventory  
- If enough stock → insert order + order items + update inventory  
- If not → rollback and print an error message  

This demonstrates atomicity and real‑world retail logic.

---

### **Step 9: Security – Admin & Staff Users**

Two SQL Server logins and database users were created:

- **AdminUser** → full control (`db_owner`)  
- **StaffUser** → read‑only (`db_datareader`)  

Verification queries were used to confirm role membership.

---

### **Step 10: Database Backup**

A full `.bak` backup of the database was created using a T‑SQL backup command.  
This demonstrates backup and recovery readiness.

---

## **🧭 Step 13: Future Improvements**

If I had additional time to continue developing the ProduceRetailDB project, I would focus on expanding its functionality and refining its design for real‑world use. Some key improvements would include:

- **Enhanced Data Relationships:** Introduce additional foreign‑key constraints and cascading updates to strengthen referential integrity between tables such as `Orders`, `OrderItems`, and `Inventory`.  
- **Stored Procedures and Views:** Replace repetitive queries with stored procedures for common operations (e.g., placing an order, updating stock) and create views for simplified reporting.  
- **User Interface Integration:** Connect the database to a front‑end application using Python or C# to allow staff to manage customers and inventory through a graphical interface.  
- **Automated Backups and Error Handling:** Schedule regular backups and add error‑handling logic to transactions to improve reliability.  
- **Analytics and Reporting:** Implement summary tables or Power BI dashboards to visualize sales trends and inventory levels.  
- **Security Enhancements:** Add role‑based permissions beyond `db_owner` and `db_datareader`, such as a `db_datawriter` role for staff who need limited update access.

These improvements would make the database more scalable, secure, and user‑friendly by transforming it from a classroom project into a production‑ready retail management system.

---

## **🧪 Testing & Validation Summary**

To ensure reliability, verification queries were used to confirm:

- Trigger fired correctly on inserts/updates  
- Transactions rolled back when stock was insufficient  
- AdminUser could perform all operations  
- StaffUser was restricted to read‑only  
- Backup file successfully generated  
- All queries executed without errors  

Screenshots were captured for documentation.

---

## **🛠️ Technologies Used**

- **SQL Server 2022 Express**  
- **T‑SQL**  
- **SQL Server Management Studio (SSMS)**  

---

## **👤 Author**

**Tara Stevens**  
IT Student | Pierce College  
Dual AAS in Data Management & Health Information Technology  
Microsoft Certified: Azure, AI, and Data Fundamentals  

---

## **📁 Recommended Repository Structure**

```
/FinalProject_TaraStevens
│
├── README.md
├── ProduceRetailDB.sql
├── CommonRetail_StoredProcedures_Produce.sql
├── GenerateReceiot_StoredProcedurs_Produce.sql
├── ASCII_Style_StoredProcedures_Produce.sql
├── ProduceRetailDB.bak
├── Screenshots/
│   ├── Step1_FiveTables.png
│   ├── Step2_ProduceRetailDB_Diagram.png
│   ├── Step4_CHECK_Constraint.png
│   ├── Step5_View.png
│   ├── Step6_ProcedureWithParameters.png
│   ├── Step7_Trigger_UpdateLastName.png
│   ├── Step8_Transaction_CheckQuantity.png
│   ├── Step9_LoginAndUser.png
│   └── Step10_Backup.png
└── documentation/
```
