# Data Management: Car Dealership

**Note: The code was written in Spanish**
![](https://di-uploads-pod19.dealerinspire.com/oceanautoclub/uploads/2021/04/doral-location-1024x584.jpg)

## Overview

This project aims to simulate the implementation of a new system that allows the management and commercialization of a used car dealership, as well as the commercialization of auto parts.

The implementation of this system requires prior data migration. Therefore, it is necessary to redefine the processes and design of the database to meet the new constraints. Additionally, the implementation of procedures is requested to make forecasts, analyze scenarios, and project future decisions through a business intelligence model.

## Solution Strategy

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;    \>\>\>\> &nbsp; &nbsp; [Find our solution strategy here.](strategy.md) &nbsp; &nbsp; <<<<

## Team members

- [Leonel Bazan](https://www.linkedin.com/in/bazanotin/)
- [Diego Perez](https://www.linkedin.com/in/diego-p%C3%A9rez-pe%C3%B1a-b5881822a/)
- [Lannert Nicolás](https://www.linkedin.com/in/nicolas-lannert/)

## Index
- [General Objectives](#general-objectives)
- [Project Components](#project-components)
  - [Database and Data Model](#database-and-data-model)
  - [Use Case Specification](#use-case-specification)
- [Requirements](#requirements)
  - [General](#general)
  - [Database](#database)
  - [Business Intelligence (BI) Model](#business-intelligence-bi-model)
  - [Database](#database)
  - [BI Model Specification](#bi-model-specification)
- [Implementation](#implementation)
  - [General](#general)
  - [Database](#database)
- [Solution Constraints](#solution-constraints)
- [Approval Conditions](#approval-conditions)
  - [Testing](#testing)
- [SQL Queries](#sql-queries)


## General Objectives

```
The present project pursues the following general objectives:
```

- Promote research on database techniques.
- Apply data management theory to a concrete application.
- Develop and test different algorithms on real data.
- Encourage delegation and teamwork.


## Project Components

Two components of the system will be provided, and based on these, the corresponding procedures must be carried out. The components to be received are:

### Database and Data Model

A script is provided that allows creating a database in SQL Server 2019. This database includes the model of a single table, called "master," which is loaded with data. The data in this table is disorganized and lacks any form of normalization.

The received data should be studied, and a data model should be created that follows all the standards of database management development. The data in this master table belongs to a domain of buying and selling both cars and auto parts.

The business logic will be mostly defined by a specification of the main use cases that are currently implemented in the system (master table).

### Use Case Specification

#### 1. Car Purchase

This functionality allows a user to register the purchase of a used car at a corresponding branch.

The following data should be recorded for a purchase:

- Branch
- Car details:
  - Chassis number
  - Engine number
  - License plate
  - Year of manufacture
  - Mileage
  - Model
- Purchase number
- Purchase date
- Car price

#### 2. Auto Part Purchase

This functionality allows a user to make a purchase of different types of auto parts along with their respective quantities. This operation is performed by a specific branch. The following data should be recorded for this process:

- Auto part code
- Category/sector
- Model of the car to which the auto part belongs
- Manufacturer
- Branch

#### 3. Car Invoicing

This functionality registers the sale of a specific car. The car mentioned can be in stock at any branch (registered as a purchase from a specific branch). The following data should be selected:

- Car details
- Selling branch
- Selling price
- Invoice number
- Invoicing date

The selling price of the car (sale price) is calculated to be approximately 20% of the purchase price.

#### 4. Auto Part Invoicing

This functionality allows the sale of a certain quantity of specific auto parts. Similar to the previous use case, these auto parts can be in stock at any branch. The following data should be recorded:

- City of origin
- Branch
- Required auto parts
- Quantity of auto parts
- Category/sector of auto parts
- Price of auto parts
- Invoice number
- Date

It should be noted that the use case specification is only a summary of the data found in the master table, illustrating the main operations performed in the system and are particularly relevant in the context of the project. The remaining fields corresponding to each entity to be modeled should be surveyed.

## Requirements

### General

All database components must be created, and subsequently, a business intelligence model must be implemented to obtain specific information through a dashboard.

### Database

A data model must be created to organize and normalize the data from the single table provided. This data model includes:

- Creation of new tables and views.
- Creation of primary and foreign keys to relate these tables.
- Creation of constraints and triggers on these tables when necessary.
- Creation of indexes to efficiently access the data in these tables.
- Data migration: Load all created tables using all the data provided by the single table in the model. Stored procedures should be used for this point on the database.

A single script file must be delivered, which, when executed, performs all the aforementioned steps in the correct order. The entire created data model must be successfully created and loaded by executing this script only once.

All columns created for the new tables must respect the same data types as the existing columns in the main table. New columns, keys, and identifiers can be created to meet specific needs. However, no fictitious information can be invented, such as creating a customer who never existed.

Later, in another delivery, a single script file must be delivered, which, when executed, creates another database, always within the same schema. This database will contain the created business intelligence model and will migrate the data from the transactional system to the new data model, allowing access to queries that manage a dashboard.

### Business Intelligence (BI) Model

### Database

A data model must be created to organize and generate a business intelligence model that supports the execution of simple queries to solve the defined queries. The activities to be performed for this delivery are as follows:

- Creation of new tables and views that make up the proposed business intelligence model.
- Creation of primary and foreign keys to relate these tables.
- Migration of data to the dimensional model: Load all created tables in the dimensional model using the originally migrated data from the created transactional data model to solve the defined use cases.
- A new script file must be delivered, which, when executed, performs all the aforementioned steps in the correct order. The entire created data model must be successfully created and loaded by executing this script only once.

All columns created for the new tables must respect the same data types as the existing columns in the main table. New columns, keys, and identifiers can be created to meet specific needs.

### BI Model Specification

Considering the created transactional data model that solves the problem of buying and selling cars and auto parts, another business intelligence data model must be generated. This model should unify the information, considering at least the following dimensions, in addition to any other dimensions deemed appropriate:

- Time (year and month)
- Customer (age, gender)
  - Age:
    - 18-30 years
    - 31-50 years
    - > 50 years
- Branch
- Model
- Manufacturer
- Car Type
- Transmission Type
- Number of Gears
- Engine Type
- Transmission Type
- Power
  - 50-150hp
  - 151-300hp
  - > 300hp
- Auto Part
- Auto Part Sector
- Manufacturer

A series of views must be created on these dimensions to provide the following information through direct queries:

- Cars:
  - Quantity of cars sold and purchased by branch and month
  - Average price of cars sold and purchased
  - Profits (selling price - purchase price) by branch and month
  - Average time in stock for each car model

- Auto Parts:
  - Average price of each auto part sold and purchased
  - Profits (selling price - purchase price) by branch and month
  - Average time in stock for each auto part
  - Maximum stock quantity for each branch (annually)

## Implementation

### General

A SQL Server database script must be developed to create the data model and migrate the data from the master table to the created model. Additionally, another script must be developed, which includes the creation of the business intelligence model and the appropriate queries for its correct population. The implementation details of each component are outlined below:

### Database

Install the SQL Server database engine.

Once the database engine is installed, the client tools "Microsoft SQL Server Management Studio Express" for SQL Server 2019 must be installed as well. Run this application and enter the credentials for the user "sa" created earlier (in "SQL Server Authentication" mode).

Within the "Management Studio," create a new database with the default parameters and name it "GD2C2020."

Once the database is created and configured with the user, two scripts need to be executed. To do this, the SQL Server console command "sqlcmd" must be executed, which will run the following two files in order:
- gd_esquema.Schema.sql: This file generates a schema named "gd_esquema" within the database and assigns it to the user "gd."
- gd_esquema.master.Table.sql: This file creates the main table of the project and populates it with the corresponding data. The file has a significant volume and cannot be executed from the "Management Studio."

A BATCH file is provided to execute this operation, named "EjecutarScriptTablamaster.bat." Double-clicking on it will execute both files ("gd_esquema.Schema.sql" and "gd_esquema.master.Table.sql") through the console mode. The script takes approximately 40 minutes to complete its execution.

```
sqlcmd –S <ServerInstance> -U <Username> -P <Password> -i <Filename1>, <Filename2> -a 32767
```
Example:

```
sqlcmd -S localhost SQLSERVER2019 -U gd -P gd2019 -i
gd_esquema.Schema.sql,gd_esquema.master.Table.sql -a 32767 -o
resultado_output.txt
```
Regarding user authentication, if "Windows Authentication" was selected during database configuration, the script should not include "-U <Username> -P <Password>" as it would only be used if the database is configured for mixed authentication. Therefore, the username and password should be explicitly specified.

After all the data from the master table is loaded, the user's own schema must be created within the database. The schema name must be the same as the group name registered in the course (the registration process will be explained later). The schema name must be in uppercase, without spaces, and separated by underscores. For example, "Los mejores" should be "LOS_MEJORES."

All new database objects such as tables, stored procedures, views, triggers, and others created by the user must belong to this created schema. If the delivered solution has database objects outside the schema with the group name, the project will be rejected without evaluating its functionality.

With this configuration, you are ready to start implementing the database part.

## Solution Constraints

The database engine must be Microsoft SQL Server 2019. Both the Express and full versions are suitable for the project. No auxiliary tools that assist in data migration can be used. Custom application development for data migration is also not allowed. The migration must be done using T-SQL code in the "initial_creation_script.sql" script file.

## Approval Conditions

### Testing

Two components must be delivered:

- Relational database script ("initial_creation_script.sql") with everything necessary to create the data model and populate it with data.
- BI database script ("BI_creation_script.sql") with everything necessary to create the BI model and populate it correctly.

The project will be tested in the following order:
1. A clean database identical to the original one provided is available.

2. Execute the "initial_creation_script.sql" file. This file must contain everything necessary to create and load the data model. The execution must be performed in order and without any errors or warnings.

3. Execute the "BI_creation_script.sql" file. The execution must be performed in order and without any errors or warnings.

The "initial_creation_script.sql" and "BI_creation_script.sql" files should contain everything necessary to create the data model and populate it. If any auxiliary tools or custom programs were used, they will not be used by the course staff.
If errors occur during execution, the project will be rejected without further evaluation.
All new database objects created by the user must belong to a database schema created with the group name. If this restriction is not met, the project will be rejected without further evaluation.
Performance criteria will also be considered when creating relationships and indexes in the tables.

## SQL Queries

All SQL queries made by the application will be evaluated according to the SQL programming standard explained in class. The performance of the queries will be taken into account when assigning the grade.