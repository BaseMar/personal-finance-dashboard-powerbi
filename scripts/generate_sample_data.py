from pathlib import Path
from datetime import date
import csv
import random


random.seed(42)

PROJECT_ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = PROJECT_ROOT / "data" / "sample"

TRANSACTIONS_FILE = OUTPUT_DIR / "fact_transactions.csv"
BUDGET_FILE = OUTPUT_DIR / "fact_budget.csv"


def random_day(year: int, month: int, start_day: int = 1, end_day: int = 28) -> date:
    """Return a random date within a selected month."""
    return date(year, month, random.randint(start_day, end_day))


def write_csv(file_path: Path, fieldnames: list[str], rows: list[dict]) -> None:
    """Write rows to a CSV file."""
    with file_path.open(mode="w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def generate_transactions() -> list[dict]:
    """Generate synthetic personal finance transactions."""
    transactions = []
    transaction_id = 1001

    def add_transaction(
        transaction_date: date,
        description: str,
        merchant_id: int,
        category_id: int,
        payment_method_id: int,
        account_id: int,
        transaction_type: str,
        amount: float,
        is_recurring: bool,
        notes: str = "",
    ) -> None:
        nonlocal transaction_id

        transactions.append(
            {
                "transaction_id": transaction_id,
                "transaction_date": transaction_date.isoformat(),
                "description": description,
                "merchant_id": merchant_id,
                "category_id": category_id,
                "payment_method_id": payment_method_id,
                "account_id": account_id,
                "transaction_type": transaction_type,
                "amount": round(amount, 2),
                "is_recurring": str(is_recurring).upper(),
                "notes": notes,
            }
        )

        transaction_id += 1

    for month in range(1, 13):
        year = 2025

        # Income
        add_transaction(
            date(year, month, 10),
            "Monthly salary",
            201,
            101,
            402,
            501,
            "Income",
            6200.00,
            True,
            "Base monthly salary",
        )

        if month in [3, 9]:
            add_transaction(
                date(year, month, 15),
                "Performance bonus",
                201,
                103,
                402,
                501,
                "Income",
                random.uniform(800, 1500),
                False,
                "Occasional bonus",
            )

        if month in [2, 5, 8, 11]:
            add_transaction(
                date(year, month, 20),
                "Freelance project income",
                202,
                102,
                402,
                501,
                "Income",
                random.uniform(600, 1800),
                False,
                "Additional project income",
            )

        # Fixed expenses
        add_transaction(
            date(year, month, 1),
            "Monthly rent",
            213,
            301,
            402,
            501,
            "Expense",
            2200.00,
            True,
            "Fixed housing cost",
        )

        add_transaction(
            date(year, month, 5),
            "Utilities payment",
            214,
            302,
            405,
            501,
            "Expense",
            random.uniform(350, 520),
            True,
            "Electricity and utilities",
        )

        add_transaction(
            date(year, month, 6),
            "Internet bill",
            215,
            302,
            405,
            501,
            "Expense",
            89.99,
            True,
            "Monthly internet payment",
        )

        add_transaction(
            date(year, month, 7),
            "Netflix subscription",
            206,
            309,
            405,
            501,
            "Expense",
            49.00,
            True,
            "Streaming subscription",
        )

        add_transaction(
            date(year, month, 8),
            "Spotify subscription",
            207,
            309,
            405,
            501,
            "Expense",
            23.99,
            True,
            "Music subscription",
        )

        add_transaction(
            date(year, month, 12),
            "Emergency fund transfer",
            222,
            315,
            402,
            502,
            "Expense",
            800.00,
            True,
            "Monthly savings transfer",
        )

        # Groceries
        for _ in range(random.randint(5, 7)):
            merchant_id = random.choice([203, 204])
            description = "Grocery shopping"
            add_transaction(
                random_day(year, month),
                description,
                merchant_id,
                303,
                random.choice([401, 404]),
                501,
                "Expense",
                random.uniform(80, 260),
                False,
                "Variable grocery expense",
            )

        # Convenience stores
        for _ in range(random.randint(2, 5)):
            add_transaction(
                random_day(year, month),
                "Convenience store purchase",
                205,
                303,
                random.choice([401, 404, 403]),
                501,
                "Expense",
                random.uniform(15, 70),
                False,
                "Small daily purchase",
            )

        # Restaurants
        for _ in range(random.randint(2, 5)):
            add_transaction(
                random_day(year, month),
                "Restaurant visit",
                219,
                304,
                random.choice([401, 404]),
                501,
                "Expense",
                random.uniform(45, 180),
                False,
                "Eating out",
            )

        # Transport
        for _ in range(random.randint(2, 4)):
            add_transaction(
                random_day(year, month),
                "Public transport ticket",
                random.choice([210, 211]),
                305,
                random.choice([401, 404]),
                501,
                "Expense",
                random.uniform(20, 120),
                False,
                "Transport expense",
            )

        if month in [1, 2, 4, 6, 8, 10, 12]:
            add_transaction(
                random_day(year, month),
                "Fuel purchase",
                212,
                306,
                401,
                501,
                "Expense",
                random.uniform(180, 350),
                False,
                "Fuel expense",
            )

        # Health
        if month in [1, 4, 7, 10]:
            add_transaction(
                random_day(year, month),
                "Pharmacy purchase",
                216,
                307,
                401,
                501,
                "Expense",
                random.uniform(40, 160),
                False,
                "Health-related expense",
            )

        if month in [3, 9]:
            add_transaction(
                random_day(year, month),
                "Doctor appointment",
                217,
                307,
                401,
                501,
                "Expense",
                random.uniform(150, 300),
                False,
                "Medical visit",
            )

        # Entertainment
        for _ in range(random.randint(1, 3)):
            add_transaction(
                random_day(year, month),
                "Cinema or event ticket",
                218,
                308,
                random.choice([401, 404]),
                501,
                "Expense",
                random.uniform(35, 140),
                False,
                "Entertainment expense",
            )

        # Shopping
        if month in [2, 5, 8, 11]:
            add_transaction(
                random_day(year, month),
                "Clothes shopping",
                random.choice([208, 209]),
                311,
                401,
                501,
                "Expense",
                random.uniform(150, 500),
                False,
                "Clothing purchase",
            )

        if month in [6, 11]:
            add_transaction(
                random_day(year, month),
                "Electronics purchase",
                random.choice([208, 209]),
                312,
                401,
                501,
                "Expense",
                random.uniform(400, 1200),
                False,
                "Electronics purchase",
            )

        # Education
        if month in [1, 4, 9]:
            add_transaction(
                random_day(year, month),
                "Online course purchase",
                random.choice([220, 221]),
                313,
                401,
                501,
                "Expense",
                random.uniform(80, 300),
                False,
                "Learning and development",
            )

        # Travel
        if month in [7, 8, 12]:
            add_transaction(
                random_day(year, month),
                "Travel accommodation",
                223,
                314,
                401,
                501,
                "Expense",
                random.uniform(600, 1600),
                False,
                "Travel expense",
            )

    return transactions


def generate_budget() -> list[dict]:
    """Generate monthly planned budget by expense category."""
    budget_rows = []
    budget_id = 1

    planned_budget_by_category = {
        301: 2200.00,  # Rent
        302: 650.00,   # Utilities
        303: 1300.00,  # Groceries
        304: 500.00,   # Restaurants
        305: 250.00,   # Public transport
        306: 300.00,   # Fuel
        307: 250.00,   # Health
        308: 300.00,   # Entertainment
        309: 100.00,   # Streaming
        310: 150.00,   # Software
        311: 350.00,   # Clothes
        312: 400.00,   # Electronics
        313: 250.00,   # Education
        314: 500.00,   # Travel
        315: 800.00,   # Savings
        316: 200.00,   # Other
    }

    for month in range(1, 13):
        for category_id, planned_amount in planned_budget_by_category.items():
            budget_rows.append(
                {
                    "budget_id": budget_id,
                    "month": date(2025, month, 1).isoformat(),
                    "category_id": category_id,
                    "planned_amount": planned_amount,
                }
            )
            budget_id += 1

    return budget_rows


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    transactions = generate_transactions()
    budget = generate_budget()

    transaction_fields = [
        "transaction_id",
        "transaction_date",
        "description",
        "merchant_id",
        "category_id",
        "payment_method_id",
        "account_id",
        "transaction_type",
        "amount",
        "is_recurring",
        "notes",
    ]

    budget_fields = [
        "budget_id",
        "month",
        "category_id",
        "planned_amount",
    ]

    write_csv(TRANSACTIONS_FILE, transaction_fields, transactions)
    write_csv(BUDGET_FILE, budget_fields, budget)

    print(f"Generated {len(transactions)} transactions.")
    print(f"Generated {len(budget)} budget rows.")
    print(f"Files saved in: {OUTPUT_DIR}")


if __name__ == "__main__":
    main()