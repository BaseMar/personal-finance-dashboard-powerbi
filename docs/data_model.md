# Data Model

## Overview

The Personal Finance Intelligence Dashboard uses a star schema data model.

The model consists of two fact tables and several dimension tables. This structure improves readability, simplifies DAX calculations and supports efficient filtering in Power BI.

---

# Model Structure

## Fact Tables

### FactTransactions

The main transactional table containing all income and expense records.

Grain of the table:

> One row represents one financial transaction.

Main fields:

- transaction_id
- transaction_date
- merchant_id
- category_id
- payment_method_id
- account_id
- transaction_type
- amount
- is_recurring

### FactBudget

The budget table containing planned monthly budget values by category.

Grain of the table:

> One row represents one planned monthly budget amount for one category.

Main fields:

- budget_id
- month
- category_id
- planned_amount

---

# Dimension Tables

## DimDate

Date table used for time intelligence analysis.

Connected to:

- FactTransactions through transaction_date
- FactBudget through month

## DimCategory

Category table used to classify income and expenses.

Connected to:

- FactTransactions through category_id
- FactBudget through category_id

## DimMerchant

Merchant table containing transaction counterparties such as shops, service providers and income sources.

Connected to:

- FactTransactions through merchant_id

## DimPaymentMethod

Payment method table containing payment types.

Connected to:

- FactTransactions through payment_method_id

## DimAccount

Account table containing financial accounts.

Connected to:

- FactTransactions through account_id

---

# Relationships

| From Table | From Column | To Table | To Column | Cardinality |
|---|---|---|---|---|
| DimDate | date | FactTransactions | transaction_date | One-to-many |
| DimDate | date | FactBudget | month | One-to-many |
| DimCategory | category_id | FactTransactions | category_id | One-to-many |
| DimCategory | category_id | FactBudget | category_id | One-to-many |
| DimMerchant | merchant_id | FactTransactions | merchant_id | One-to-many |
| DimPaymentMethod | payment_method_id | FactTransactions | payment_method_id | One-to-many |
| DimAccount | account_id | FactTransactions | account_id | One-to-many |

---

# Model Diagram

```text
                  DimDate
                    |
                    |
DimMerchant --- FactTransactions --- DimCategory --- FactBudget
                    |
                    |
            DimPaymentMethod
                    |
                    |
                DimAccount

```

# Design Decisions
## Star Schema

A star schema was selected because it is a common data modeling approach for analytical reporting. It separates measurable events from descriptive attributes.

## Separate Budget Table

Budget data is stored in a separate fact table because planned budget values have a different granularity than individual transactions.

Transactions are recorded at transaction level, while budget values are planned monthly by category.

Synthetic Data

The project uses synthetic sample data generated with Python. No real personal financial data is included in the repository.

## Date Table

A dedicated date table will be created in Power BI to support time-based analysis such as:

- monthly trends
- month-over-month comparison
- year-to-date calculations
- weekday and weekend analysis

---