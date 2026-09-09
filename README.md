# Library Event Management Database

## 📌 Project Overview

The **Library Event Management Database** is a relational database project designed to manage library events, users, bookings, and related information.

The database is designed using **SQL** and follows relational database principles to keep the data organised, accurate, and easy to manage.

## 🛠️ Technologies Used

* SQL
* MySQL / MariaDB
* phpMyAdmin

## 🎯 Project Objectives

The main objectives of this project are to:

* Store library and event information in a structured way.
* Manage users and their event bookings.
* Connect related data using primary and foreign keys.
* Reduce duplicate data through database normalisation.
* Maintain data accuracy and consistency.
* Provide sample data for testing the database.


## 📊 Database Design

The database was designed as a **relational database** and follows **Third Normal Form (3NF)** principles where appropriate.

This helps to:

* Reduce unnecessary data duplication.
* Improve data consistency.
* Make the database easier to maintain.
* Organise information into related tables.

## 💾 Database File

The repository includes the SQL database file:

`Library_Event_DB.sql`

The SQL file contains the required database structure and sample data.

When the SQL file is imported into a compatible **MySQL/MariaDB** environment, the database, tables, relationships, and sample records can be created automatically.

## ▶️ How to Run the Database

1. Download the `library_event_management.sql` file from this repository.
2. Open **phpMyAdmin**, **MySQL Workbench**, or another MySQL/MariaDB-compatible database tool.
3. Import the `library_event_management.sql` file.
4. The SQL script will create the database and required tables automatically.
5. The primary keys, foreign keys, constraints, and sample data will also be created from the SQL script.
6. After importing, the database is ready to use and test.

### Note

The original database was developed and managed using **MariaDB through phpMyAdmin on a cPanel hosting environment**.

## 📁 Repository Contents

```text
Library-event-database/
│
├── Library_Event_DB.sql
├── screenshots/
│   ├── database-tables.png
│   ├── event_table-structure.png
|   ├── roompayment-table-structure.png
│   ├── library-database-erd.png
│   ├── sample-sql-query/result.png
└── README.md
```

## 📸 Screenshots

Screenshots are included in the `screenshots` folder to show the database structure, tables, ERD design and sample data.


## 🔑 Key Database Concepts Demonstrated

This project demonstrates practical knowledge of:

* Relational database design
* SQL
* Database tables
* Primary keys
* Foreign keys
* Relationships
* Constraints
* Data types
* Normalisation
* 3NF
* Sample data
* Database management using phpMyAdmin

## 👩‍💻 Author

**Sajidha Ayub Basha**

BSc (Hons) Computing
