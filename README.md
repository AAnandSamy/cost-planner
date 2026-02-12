# Tex Cost Pro

Great question. To build a **cost module/planner** that works across all the departments you listed (for both a **Big Tex** operation and a **Medium Tex** operation), you’ll want a design that:

1.  models costs consistently from end‑to‑end,
2.  makes it easy to track **standard vs. actual** cost,
3.  supports rollups (product → order → shipment), and
4.  integrates cleanly with ERP/Accounts/Stores.

Below is a **complete blueprint** you can take to implementation.

***

## 1) Core Concepts & Cost Objects

**Primary Cost Objects**

*   **Product (Style/SKU/Color/Size)** – the unit you sell.
*   **BOM (Bill of Materials)** – yarn, fabric, trims, packaging; units & wastage.
*   **BOP/Routing (Bill of Processes)** – sequence: weaving → dye/print → cutting → stitching → checking/packing; time, rates, yields.
*   **MO (Manufacturing Order)** / **WO (Work Order)** – batch order with quantities & dates.
*   **Operations/Activities** – machine time, labor time, setups, inspections, transport, documentation.
*   **Overheads** – plant, utilities, SGA allocation rules.

**Cost Types**

*   **Standard Cost**: planned before production; used for pricing and budgets.
*   **Actual Cost**: what really happened (consumption, time, wastage).
*   **Variance**: Material, Labor, Overhead, Yield, Price, Mix, Efficiency.

**Valuation Methods (choose one per material class)**

*   FIFO / Weighted Average / Standard (with revaluation rules).

***

## 2) Costing Method (Recommended)

*   Use **Hybrid ABC + Routing Costing**:
    *   **Direct materials** via BOM *×* standard or actual purchase price.
    *   **Direct labor/machine** via **Routing** (planned time *×* rates).
    *   **Overheads** via **Activity‑Based Costing (ABC)** drivers:
        *   e.g., utility per machine hour, QA cost per inspection lot, documentation per shipment, transport per CBM/km, ERP/IT per MO, IE per SMV study, HR per headcount (or per MO if HR effort is MO‑linked).

***

## 3) Department‑wise Roles & Data Inputs

### Big Tex Departments (1–20)

1.  **Merchandising**: Target price, MOQ, delivery window, margin goals.  
    *Inputs*: target FOB, requested cost breakdown.
2.  **Designing**: Tech pack, size specs, construction, colorways.  
    *Inputs*: trim list, measurement charts (affects consumption).
3.  **Costing**: Builds **standard cost sheet** from BOM + Routing + overhead drivers.  
    *Inputs*: material prices, SMV/SME, machine rates, yields, wastage.
4.  **Sample**: Confirms feasibility & validates consumption/wastage assumptions.  
    *Outputs*: actual sample BOM, time, yield.
5.  **PPC (Pre‑Production Control)**: Confirms routing, batch sizes, line plan.  
    *Outputs*: final routing & capacity reservations.
6.  **Production**: Actual time, actual output, stoppages.  
    *Outputs*: labor hours, machine hours, actual yields.
7.  **Quality Control**: Inspection counts, defect rates, rework time.  
    *Outputs*: inspection lots, acceptance %, rework cost drivers.
8.  **Weave House**: Loom time, efficiency, weaving wastage.  
    *Outputs*: loom hours, picks per inch, fabric yield.
9.  **Dyeing/Printing**: Dye/print batch costs, chemical usage, reprocess.  
    *Outputs*: chemical kg, steam/electricity (if metered), rejects.
10. **Cutting**: Marker efficiency, fabric utilization, offcuts/waste.  
    *Outputs*: fabric usage per size ratio; cut vs. planned.
11. **Stitching**: SMV, line efficiency, changeover times.  
    *Outputs*: operator hours, machine hours, efficiency.
12. **Checking & Packing**: QC throughput, packing material usage.  
    *Outputs*: QC hours, polybag/box usage, CTNs per order.
13. **Documentation**: Export docs, compliance, testing fees.  
    *Outputs*: doc cost per shipment/order.
14. **Transport**: Inbound (raws), inter‑process moves, outbound freight.  
    *Outputs*: freight per CBM/kg/km; lane rates.
15. **Stores**: GRN, issues, returns, stock valuation, lot tracking.  
    *Outputs*: actual consumption vs. BOM; prices (FIFO/Avg).
16. **HR**: Headcount, wage rates, overtime, shift premiums.  
    *Outputs*: labor cost parameters, attendance feed.
17. **Accounts**: Purchase price variances, overhead pools, absorption rules.  
    *Outputs*: actual PPV, utilities bill allocation, period close postings.
18. **ERP (Software)**: Master data, transactions, APIs/integration.  
    *Outputs*: item masters, routing masters, cost center structures.
19. **IT (Hardware)**: Device uptime, scanner/PLC/IoT feeds.  
    *Outputs*: auto‑captures machine/runtime/energy if available.
20. **Industrial Engineering (IE)**: Time studies, SMV, bottlenecks.  
    *Outputs*: standard times, changeover matrix, line balancing.

### Medium Tex (1–10)

Consolidate roles (e.g., Merch + Costing; Production includes Weave/Cut/Stitch; QC+Packing merged). Same data, fewer owners.

***

## 4) Data Model (Starter Schema)

**Master Tables**

*   `Products(product_id, style, color, size, uom, buyer)`
*   `BOM(product_id, component_id, qty_per, uom, waste_pct, alt_component_group)`
*   `Components(component_id, type [yarn/fabric/trim/pack/chem], spec, uom)`
*   `Routing(product_id, op_seq, dept, operation, machine_group, std_time_min_per_unit, setup_time_min, yield_pct)`
*   `Rates(dept, rate_type [labor/machine], rate_per_hour, eff_target_pct, valid_from)`
*   `OverheadPools(pool_id, name, amount_period, driver, driver_qty_period, alloc_rule)`
*   `Vendors(vendor_id, lead_time, incoterm)`
*   `PriceList(component_id, price, currency, valid_from, vendor_id)`

**Transactional Tables**

*   `MO(mo_id, product_id, qty, start_date, end_date, status)`
*   `MO_Consumption(mo_id, component_id, qty_issued, price, lot)`
*   `MO_Time(mo_id, op_seq, labor_min, machine_min, rework_min)`
*   `QA_Results(mo_id, lot, accepted_qty, rejected_qty, defect_codes)`
*   `Logistics(mo_id, move_type, weight, cbm, km, charge)`
*   `Docs(mo_id, fee_type, amount)`
*   `PPV(component_id, std_price, actual_price, variance_amount, period)`

***

## 5) Cost Calculation Logic

### A) Standard Cost (per product, per unit)

    MaterialStd = Σ (BOM.qty_per × (1 + waste_pct) × StdPrice(component))
    ProcessStd  = Σ (Routing.std_time_min_per_unit × Rate_per_minute(dept))
    SetupAlloc  = Σ (setup_time_min × Rate_per_minute / ExpectedBatchQty)
    Overheads   = Σ (Pool.amount_period / Pool.driver_qty_period × product_driver_usage)
    StdCost     = MaterialStd + ProcessStd + SetupAlloc + Overheads
    TargetPrice = StdCost / (1 - TargetMargin%)

### B) Actual Cost (per MO)

    MaterialAct = Σ (qty_issued × actual_price)
    ProcessAct  = (Σ labor_min × labor_rate_per_min) + (Σ machine_min × machine_rate_per_min)
    ReworkCost  = Σ rework_min × rates + reprocess materials
    QA/Docs/Trans = Σ charges tied to the MO
    OverheadsAct = Σ (pool_rate_per_driver × actual_driver_usage)
    ActCostMO   = MaterialAct + ProcessAct + ReworkCost + QA/Docs/Trans + OverheadsAct
    ActCostUnit = ActCostMO / good_units_out

### C) Variance Analysis

*   **Material Price Variance (PPV)** = (StdPrice − ActualPrice) × ActualQty
*   **Material Usage Variance** = (StdQty − ActualQty) × StdPrice
*   **Labor Rate Variance** = (StdRate − ActualRate) × ActualHours
*   **Labor Efficiency Variance** = (StdHours − ActualHours) × StdRate
*   **Overhead Absorption Variance** = Applied OH − Actual OH
*   **Yield Variance** from routing yield% vs. actual acceptance%

***

## 6) Cost Sheet (Template)

**Header**

*   Buyer / Style / Season / MOQ / Lead Time / Target Margin

**BOM Section**

*   Component | Spec | UoM | Cons./Unit | Waste % | Price | Amount

**Process Section**

*   Operation | Dept | SMV/Min | Rate/min | Setup (alloc.) | Amount

**Overheads**

*   Pool | Driver | Driver/unit | Rate/driver | Amount

**Other**

*   QA/Testing | Docs | Freight (if included) | Commission

**Totals**

*   Material | Labor | Overhead | Other | **Std Unit Cost** | **Target Price**

I can generate this as an **Excel** or **Power BI model** if you want.

***

## 7) Workflow Across Departments

1.  **Merch RFQ → Designing** finalizes tech pack → **Costing** builds Std Cost.
2.  **Sample** validates consumption & times → Costing updates Std.
3.  **PPC** locks routing & batch → creates MO.
4.  **Stores** reserves/allocates materials; **Production** logs time & output (ideally via scans/IoT).
5.  **QC** logs defects; **Transport/Docs** attach charges.
6.  **Accounts** posts actuals & overhead pools; **Costing** closes MO & publishes **variance report**.
7.  **Merch** reviews margin vs. quote; **IE** updates SMVs for continuous improvement.
8.  **ERP/IT** ensure master data integrity & audit trail.

***

## 8) KPIs & Dashboards

*   **Unit Std Cost vs. Actual** (waterfall)
*   **Material Usage/Yield** by product/op
*   **SMV vs. Actual Minutes**; **Line Efficiency**
*   **PPV** by vendor/material
*   **Rework & Defect Cost** by cause code
*   **Overhead Absorption %**
*   **Contribution Margin by Order/Buyer**
*   **Lead Time Adherence** (PPC)
*   **Inventory Turns & WIP Aging** (Stores/Accounts)

***

## 9) Integrations

*   **ERP**: item masters, GRNs, issues, MO status, financial postings.
*   **Accounts**: actual prices, overhead pools, period close.
*   **HR/Time‑Attendance**: rates, actual hours/overtime.
*   **IE Tools**: SMV libraries.
*   **Weaving/Dyeing PLC/IoT** (optional): runtime, energy meters.
*   **Logistics**: carrier rates or TMS exports.

APIs or flat file drops (CSV/Excel) work initially; move to real‑time later.

***

## 10) Security & Controls

*   Role‑based access: Costing can edit standards; Production can only log actuals.
*   **Cost freeze & versioning** per season/order.
*   Audit trail for price/routing changes.
*   Tolerances & alerts (e.g., usage +5% triggers review).
*   Period close checklist (lock postings before variance publication).

***

## 11) Phased Rollout (Big Tex → Medium Tex)

**Phase 1 (4–6 weeks)**

*   Masters (Products, BOM, Routing, Rates), Standard Costing, Cost Sheet export.
*   Material actuals from Stores; basic variance.

**Phase 2 (6–8 weeks)**

*   Actual time capture (shopfloor app or scans).
*   Overhead pools & ABC drivers.
*   QC, Docs, Transport costs linked to MO.

**Phase 3 (4–6 weeks)**

*   Dashboards, auto alerts, PPV analysis, yield tracking.
*   Integrations (ERP, HR, Accounts).
*   Optional IoT/energy metering.

**Medium Tex** can compress to Phase 1 + light Phase 2 with merged roles.

***

## 12) Example: Cost Roll‑Up (Illustrative)

*   **BOM**: Fabric 1.8 m @ $2.20/m, 3% waste → $4.08  
    Trims: Buttons $0.12, Thread $0.05, Labels $0.08 → $0.25  
    Packing: Polybag $0.06, Carton alloc $0.10 → $0.16  
    **MaterialStd = $4.49**

*   **Routing**:  
    Weaving 12 min @ $0.08/min → $0.96  
    Dye/Print 8 min @ $0.10/min → $0.80  
    Cutting 5 min @ $0.09/min → $0.45  
    Stitching 18 min @ $0.12/min → $2.16  
    Check/Pack 6 min @ $0.09/min → $0.54  
    Setup alloc $0.12  
    **ProcessStd ≈ $5.03**

*   **Overheads (ABC)**: utilities per machine‑min $0.005 × 49 min → $0.245  
    QA per lot alloc $0.05, Docs per order alloc $0.03 → $0.08  
    **Overheads ≈ $0.325**

*   **Std Unit Cost ≈ $4.49 + $5.03 + $0.325 = $9.845**  
    Target Margin 20% → Target Price ≈ $12.31

***

## 13) What to Build First (MVP Features)

*   **Cost Sheet Builder**: pick Product → auto‑pull BOM, Routing, Rates → compute Std Cost; export PDF/Excel.
*   **Variance Report**: MO‑level actual vs. standard with drill‑down to BOM item and operation.
*   **Master Data Admin**: price lists, SMVs, setup times, overhead pools.
*   **Role‑based Workflow**: Draft → Reviewed (Sample/PPC) → Approved (Costing/Accounts).

***

## 14) Optional Enhancements

*   **Scenario Planning**: What‑if price changes, rate changes, yield shifts.
*   **Size‑ratio & marker efficiency** automation for Cutting.
*   **Learning models** to predict wastage by fabric/line/buyer.
*   **Auto SMV suggestions** from historical actuals (IE assist).
*   **Should‑Cost** for vendor negotiations.

***

## 15) Deliverables I can create for you (quick wins)

*   **Excel/CSV templates** for BOM, Routing, Rates, Overhead pools.
*   A **Power BI prototype dashboard** (Std vs. Actual, PPV, Yield).
*   A **sample cost sheet generator** (Python/Excel) using your data structure.

***

### A couple of quick questions to tailor this to you:

1.  Do you want the **module embedded in your existing ERP** or as a **standalone app** (with nightly sync)?
2.  Which **valuation method** are you using today (FIFO / Avg / Standard)?
3.  For Big Tex, do you have **machine and labor time capture** on the floor, or should we start with estimates?

If you like, I can spin up a **starter Excel** with the exact columns and formulas above, or generate a **sample cost sheet** for one of your styles to validate.
