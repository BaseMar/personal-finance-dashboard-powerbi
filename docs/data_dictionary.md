# Data Dictionary

## Overview

This document describes the structure of the dataset used in the Personal Finance Intelligence Dashboard project.

The dataset is designed to analyze personal income, expenses, budget usage, savings rate and spending behavior.

The project uses a star schema model with one main fact table and several dimension tables.

---

# Tables

## FactTransactions

Main table containing all income and expense transactions.

| Column | Data Type | Description | Example |
|---|---|---|---|
| transaction_id | Integer | Unique transaction identifier | 1001 |
| transaction_date | Date | Date when the transaction occurred | 2025-01-15 |
| description | Text | Raw transaction description | Grocery shopping |
| merchant_id | Integer | Reference to merchant dimension | 201 |
| category_id | Integer | Reference to category dimension | 301 |
| payment_method_id | Integer | Reference to payment method dimension | 401 |
| account_id | Integer | Reference to account dimension | 501 |
| transaction_type | Text | Type of transaction: Income or Expense | Expense |
| amount | Decimal | Transaction amount | 156.40 |
| is_recurring | Boolean | Indicates whether the transaction is recurring | TRUE |
| notes | Text | Optional transaction notes | Weekly groceries |

---

## FactBudget

Table containing planned monthly budgets by category.

| Column | Data Type | Description | Example |
|---|---|---|---|
| budget_id | Integer | Unique budget record identifier | 1 |
| month | Date | First day of the budget month | 2025-01-01 |
| category_id | Integer | Reference to category dimension | 301 |
| planned_amount | Decimal | Planned budget amount for the category | 1200.00 |

---

## DimDate

Date dimension used for time-based analysis.

| Column | Data Type | Description | Example |
|---|---|---|---|
| date | Date | Calendar date | 2025-01-15 |
| year | Integer | Year number | 2025 |
| quarter | Text | Quarter of year | Q1 |
| month_number | Integer | Month number | 1 |
| month_name | Text | Month name | January |
| year_month | Text | Year and month label | 2025-01 |
| day | Integer | Day of month | 15 |
| weekday_name | Text | Name of weekday | Wednesday |
| is_weekend | Boolean | Indicates whether the date is a weekend | FALSE |

---

## DimCategory

Category dimension used to classify transactions.

| Column | Data Type | Description | Example |
|---|---|---|---|
| category_id | Integer | Unique category identifier | 301 |
| category_name | Text | Main transaction category | Food |
| subcategory_name | Text | More detailed transaction category | Groceries |
| category_type | Text | Income or Expense category | Expense |
| expense_type | Text | Fixed or Variable expense | Variable |
| need_or_want | Text | Classification as Need or Want | Need |

---

## DimMerchant

Merchant dimension containing transaction counterparties.

| Column | Data Type | Description | Example |
|---|---|---|---|
| merchant_id | Integer | Unique merchant identifier | 201 |
| merchant_name | Text | Name of merchant or income source | Biedronka |
| merchant_type | Text | Type of merchant | Grocery Store |

---

## DimPaymentMethod

Payment method dimension.

| Column | Data Type | Description | Example |
|---|---|---|---|
| payment_method_id | Integer | Unique payment method identifier | 401 |
| payment_method | Text | Payment method name | Card |

---

## DimAccount

Account dimension.

| Column | Data Type | Description | Example |
|---|---|---|---|
| account_id | Integer | Unique account identifier | 501 |
| account_name | Text | Name of account | Main Account |
| account_type | Text | Type of account | Personal Bank Account |

---

# Planned Categories

The dashboard will use the following main categories:

## Income Categories

- Salary
- Freelance
- Bonus
- Other Income

## Expense Categories

- Housing
- Food
- Transport
- Health
- Entertainment
- Subscriptions
- Shopping
- Education
- Travel
- Savings
- Other

---

# Data Privacy

The repository will not contain real personal financial data. Only anonymized or synthetic sample data will be included in the `data/sample` directory.
