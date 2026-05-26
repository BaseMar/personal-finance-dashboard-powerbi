# DAX Measures

## Overview
This document describes the DAX measures used in the Personal Finance Intelligence Dashboard.

The measures are grouped into the following areas:

- Income and expenses
- Cash flow
- Budget tracking
- Transaction analysis
- Fixed and variable expenses
- Needs vs wants analysis
- Month-over-month analysis
- Savings recommendations

---

# Core Financial Measures
## Total Income
Calculates total income from transactions marked as `Income`.

```DAX
Total Income =
CALCULATE(
    SUM(FactTransactions[amount]),
    FactTransactions[transaction_type] = "Income"
)
```

## Total Expenses
Calculates total expenses from transactions marked as Expense.

```DAX
Total Expenses =
CALCULATE(
    SUM(FactTransactions[amount]),
    FactTransactions[transaction_type] = "Expense"
)
```

## Net Cash Flow
Calculates the difference between income and expenses.

```DAX
Net Cash Flow =
[Total Income] - [Total Expenses]
```

## Savings Rate
Calculates the percentage of income remaining after expenses.

```DAX
Savings Rate =
DIVIDE(
    [Net Cash Flow],
    [Total Income]
)
```
---

# Budget Measures
## Planned Budget
Calculates the total planned budget.

```DAX
Planned Budget =
SUM(FactBudget[planned_amount])
```

## Budget Variance
Calculates the difference between planned budget and actual expenses.

```DAX
Budget Variance =
[Planned Budget] - [Total Expenses]
```

## Budget Usage %
Calculates what percentage of the planned budget has been used.

```DAX
Budget Usage % =
DIVIDE(
    [Total Expenses],
    [Planned Budget]
)
```
---

# Transaction Measures
## Transaction Count
Counts the number of transactions.

```DAX
Transaction Count =
COUNTROWS(FactTransactions)
```

## Average Transaction Amount
Calculates the average transaction amount.

```DAX
Average Transaction Amount =
AVERAGE(FactTransactions[amount])
```

## Average Daily Expense
Calculates average daily expenses in the selected period.

```DAX
Average Daily Expense =
DIVIDE(
    [Total Expenses],
    DISTINCTCOUNT(DimDate[Date])
)
```
---

# Expense Structure Measures
## Fixed Expenses
Calculates expenses classified as fixed.

```DAX
Fixed Expenses =
CALCULATE(
    [Total Expenses],
    KEEPFILTERS(DimCategory[expense_type] = "Fixed")
)
```

## Variable Expenses
Calculates expenses classified as variable.

```DAX
Variable Expenses =
CALCULATE(
    [Total Expenses],
    KEEPFILTERS(DimCategory[expense_type] = "Variable")
)
```

## Fixed Expenses %
Calculates the share of fixed expenses in total expenses.

```DAX
Fixed Expenses % =
DIVIDE(
    [Fixed Expenses],
    [Total Expenses]
)
```

## Variable Expenses %
Calculates the share of variable expenses in total expenses.

```DAX
Variable Expenses % =
DIVIDE(
    [Variable Expenses],
    [Total Expenses]
)
```

---
# Needs vs Wants Measures
## Needs Expenses
Calculates expenses classified as needs.

```DAX
Needs Expenses =
CALCULATE(
    [Total Expenses],
    KEEPFILTERS(DimCategory[need_or_want] = "Need")
)
```

## Wants Expenses
Calculates expenses classified as wants.

```DAX
Wants Expenses =
CALCULATE(
    [Total Expenses],
    KEEPFILTERS(DimCategory[need_or_want] = "Want")
)
```

## Wants Expenses %
Calculates the share of wants in total expenses.

```DAX
Wants Expenses % =
DIVIDE(
    [Wants Expenses],
    [Total Expenses]
)
```

## Recommended Savings From Wants
Estimates potential savings by reducing wants-related expenses by 20%.

```DAX
Recommended Savings From Wants =
[Wants Expenses] * 0.2
```

---
# Month-over-Month Measures
## Previous Month Expenses
Calculates expenses from the previous month.

```DAX
Previous Month Expenses =
CALCULATE(
    [Total Expenses],
    DATEADD(DimDate[Date], -1, MONTH)
)
```

## Expense MoM Change
Calculates the difference between current and previous month expenses.

```DAX
Expense MoM Change =
[Total Expenses] - [Previous Month Expenses]
```

## Expense MoM Change %
Calculates percentage change in expenses compared to the previous month.

```DAX
Expense MoM Change % =
DIVIDE(
    [Expense MoM Change],
    [Previous Month Expenses]
)
```

## Savings Transfers
Calculates the amount transferred to savings-related categories.

```DAX
Savings Transfers =
CALCULATE(
    [Total Expenses],
    KEEPFILTERS(DimCategory[category_name] = "Savings")
)
```

## Consumption Expenses
Calculates total expenses excluding savings transfers. 

```DAX
Consumption Expenses =
CALCULATE(
    [Total Expenses],
    KEEPFILTERS(DimCategory[category_name] <> "Savings")
)
```

## Total Saved
Calculates total saved amount as savings transfers plus remaining net cash flow.

```DAX
Total Saved =
[Savings Transfers] + [Net Cash Flow]
```

## True Savings Rate
Calculates the actual savings rate including both savings transfers and remaining net cash flow.

```DAX
True Savings Rate =
DIVIDE(
    [Total Saved],
    [Total Income]
)
```

## Consumption Ratio
Calculates what percentage of income is spent on consumption expenses.

```DAX
Consumption Ratio =
DIVIDE(
    [Consumption Expenses],
    [Total Income]
)
```
---
KEEPFILTERS is used to preserve the current filter context when additional category filters are applied inside CALCULATE.

---

# Expense Analysis Measures
## Expense Share %
Calculates the share of each category in total consumption expenses.

```DAX
Expense Share % =
DIVIDE(
    [Consumption Expenses],
    CALCULATE(
        [Consumption Expenses],
        ALL(DimCategory[category_name])
    )
)
```

## Recurring Expenses
Calculates expenses marked as recurring.

```DAX
Recurring Expenses =
CALCULATE(
    [Total Expenses],
    KEEPFILTERS(FactTransactions[is_recurring] = TRUE())
)
```

## Non-Recurring Expenses
Calculates expenses not marked as recurring.
```DAX
Non-Recurring Expenses =
CALCULATE(
    [Total Expenses],
    KEEPFILTERS(FactTransactions[is_recurring] = FALSE())
)
```

## Weekend Expenses
Calculates consumption expenses that occurred during weekends.
```DAX
Weekend Expenses =
CALCULATE(
    [Consumption Expenses],
    KEEPFILTERS(DimDate[Is Weekend] = TRUE())
)
```

## Weekend Expenses %
Calculates the share of weekend expenses in total consumption expenses.
```DAX
Weekend Expenses % =
DIVIDE(
    [Weekend Expenses],
    [Consumption Expenses]
)
```

## Average Expense Transaction
Calculates the average amount of a single consumption expense transaction.

```DAX
Average Expense Transaction =
CALCULATE(
    AVERAGE(FactTransactions[amount]),
    KEEPFILTERS(FactTransactions[transaction_type] = "Expense"),
    KEEPFILTERS(DimCategory[category_name] <> "Savings")
)
```

---
# Budget Analysis Measures

## Budget Overrun

Shows the amount by which actual expenses exceeded the planned budget.

## Remaining Budget

Shows the remaining budget when actual expenses are below the planned budget.

## Budget Status

Classifies each category as Within Budget, Near Limit or Over Budget.

## Categories Over Budget

Counts how many categories exceeded the planned budget.

## Categories Near Limit

Counts categories where budget usage is between 90% and 100%.
---