# Report Design

## Design Direction

The report is designed as a minimalist portfolio-ready Power BI dashboard. The visual language uses a light canvas, a fixed left navigation rail and calm blue accents.

## Palette

| Role | Color |
|---|---|
| Canvas | `#F9F7F7` |
| Borders and subtle surfaces | `#DBE2EF` |
| Primary accent | `#3F72AF` |
| Primary text and navigation base | `#112D4E` |

## Page Structure

The report uses a 1280 x 720 canvas.

| Area | Placement | Purpose |
|---|---|---|
| Left navigation | x 0, width 220 | Report identity and page switching |
| Header | x 250, y 28 | Page title and short analytical context |
| KPI row | x 250, y 105 | Four high-level financial metrics |
| Analysis band | x 250, y 230 | Category, trend and filter visuals |
| Detail table | x 250, y 465 | Category-level budget and variance details |

## Pages

| Page | Status | Purpose |
|---|---|---|
| Executive Overview | Active | High-level income, spending, savings and budget snapshot |
| Expense Analysis | Added | Expense structure, budget usage and optimization focus |
| Validation | Hidden | Technical QA page retained outside the navigation flow |

## Navigation

The left rail uses Power BI page navigation. The navigator is expected to show visible report pages only, so the technical Validation page is marked as hidden.

Microsoft's Power BI page navigator keeps button labels and order synchronized with report pages, which makes it suitable for this dashboard structure.

## Power BI Theme

The importable theme is available at:

```text
powerbi/personal_finance_theme.json
```

The same palette is embedded into the PBIX base theme so the dashboard opens with the intended styling.
