
# Happy Pet Clinic Two-Year Revenue Analysis

#### Table of Contents

- [Project Background](#project-background)
- [Executive Summary](#executive-summary)
- [Key Insights](#key-insights)
    - [Revenue Trends and Growth Rates](#revenue-trends-and-growth-rates)
    - [Service Line and Veterinary Performance](#service-line-and-veterinary-performance)
    - [Species Distribution, Case Count and ACV](#species-distribution-case-count-and-acv)
    - [Owner Demographics and Revenue Concentration](#owner-demographics-and-revenue-concentration)
    - [Revenue By Items](#revenue-by-items)
- [Strategic Recommendations](#strategic-recommendations)
    - [Workforce Optimization](#workforce-optimization)
    - [Revenue Diversification](#revenue-diversification)
    - [Geographic Expansion and Pet Owner Growth](#geographic-expansion-and-pet-owner-growth)
- [Assumptions and Caveats](#assumptions-and-caveats)

## Project Background

Happy Pet Clinic is a Hong Kong based SME providing veterinary services to local pet owners. I am partnering up with its business owner to learn about its revenue and performance over the past two years. This report summarizes insights derived from 50k+ clinical records spanning July 2023 to June 2025. The objective is to inform operational decision-making, resource allocation, and commercial strategy across HPC's medical, procurement, and marketing teams.

## Executive Summary

HPC has achieved consistent revenue expansion, with **a compound semi-annual growth rate of 7.8%** and **a peak revenue of HKD 1.4 million in May 2025**. Revenue remains highly concentrated across the four services: General Practice, Emergency, Surgery, and Ophthalmology.

Some critical operational imbalances are identified:
- Underperformance within select General Practice and Emergency vets
- Elevated workload risks for a top-performing Ophthalmologist
- High dependency on canines as the primary revenue species
- Geographic concentration of owners, hence revenue, in New Territories

Strategic actions are recommended in workforce management, species diversification, and client acquisition initiatives in order to sustain growth and enhance business resilience and operational performance.

> ![ERD of HPC Dataset](/05_screenshots/01_ERD_hpc_v2025.06.21.png)
> 
> <sup> Visual Reference: _Entity Relationship Diagram of HPC's operational dataset_ </sup>

## Key Insights

### Revenue Trends and Growth Rates

- Revenue has grown at a **7.8% semi-annual compound rate**, demonstrating positive momentum since July 2023.
- **Emergency services** experienced the highest annualized growth at **59.2%**, followed by **Internal Medicine (+40.7%)** and **General Practice (+40.4%)**. Conversely, **Ophthalmology (+17.3%)** and **Surgery (+7.7%)** exhibited suboptimal growth.
- Both numbers of **canine** and **feline** increased by **19.1%** and **19.6%** respectively. Canines continue to account for approximately three times that of felines, while **rabbits remain immaterial** with negligible growth.
- **Case volume** increased by **24.3%**, while **Average Case Value (ACV)** grew modestly by **5.5%**, indicating pressure on revenue-per-case metrics.
- Revenue composition remains stable, with approximately **60% generated from professional services** and **40% from medical products**.

> ![Revenue Growth by Service](/05_screenshots/02_revenue_growth_by_service.png
"From tab Q1+2")
>
> <sup> Revenue Growth by Services </sup>

> [Interactive Revenue Dashboard in Tableau](https://public.tableau.com/views/workbook_hpc_v2025_06_26/Dashboard)

---

### Service Line and Veterinary Performance

- **General Practice** and **Emergency** are now the top two revenue streams.
- Individual performance variability is evident:
  - **Fung (General Practice)**: Declining performance across revenue and pet count. This requires immediate managerial attention.
  - **Lin (Emergency)**: Performance has plateaued with no discernible growth trajectory.
  - **Mak (Internal Medicine)**: Delivers above-average performance in both revenue and pet count despite the department's lower overall revenue share.
  - **Koo (Ophthalmology)**: The top performer of all. However, sustained high caseloads present potential retention risks.
  - **Lee (Ophthalmology)**: Recently onboarded so limited dataset.
- All remaining vets who maintain revenue levels at or above the average benchmark (the horizontal red line) are within acceptable parameters.

> ![Ranking by Service Revenue](/05_screenshots/04_rank_service.png
"From tab Q7_SRank")
>
> <sup> Ranking by Service Revenue </sup>

> ![Vet Performance Scatter Plot](/05_screenshots/03_scatter_graph_vet.png
"From tab Q6_scatter")
>
> <sup> Vet Performance Scatter Plot </sup>

---

### Species Distribution, Case Count and ACV

- Revenue exhibits material species dependency. **Canines** account for **~70%** of total revenue, pet count, and case volume, whereas **Felines** account for **~30%** and **Rabbits** represent an **immaterial** share.
- **~70%** of pets make **one to two visits annually**. Additional visits correlate with diminishing ACV returns (**~1.5% decline per incremental visit**).
- Felines consistently command higher ACV relative to canines where case volume is below 10.
- Revenue contribution by **pet lifestage** is relatively consistent at **~HKD 4,500 per pet across canines and felines**.

> ![Case Frequency & ACV](/05_screenshots/05_case_freq_acv.png
"From tab Q8+9_2025")
>
> <sup> Case Frequency & ACV </sup>

> ![Pet Species Concentration](/05_screenshots/06_pet_concn.png
"From tab pet_concn")
>
> <sup> Pet Species Concentration </sup>

> ![Pet Lifestage Distribution](/05_screenshots/07_pet_age.png
"From tab Q10_age")
>
> <sup> Pet Lifestage Distribution </sup>

---

### Owner Demographics and Revenue Concentration

- **49.8%** of owners reside in **New Territories**, **28.3%** in Kowloon and **21.9%** in **Hong Kong Island**. Distribution of canines and felines, and revenue follow a similar pattern.
- **90.5%** of owners **owns a single pet**. Among multi-pet owners, **21.2%** span **ownership across species**.
- Notable high-value clients for reference:
    - Owner <ins> C2834</ins>: Largest pet owner with **12 canines** living in **New Territory**. Moderate spending profile with **HKD 22.1k YTD** ranked 374<sup>th </sup> of 517 (higher rank higher spending).
    - Owner <ins> C5204</ins>: Top revenue contributor **HKD 122k YTD** with **a single feline** making frequent visits who also lives in **New Territory**.

> ![Owner Location Distribution](/05_screenshots/08_location.png
"From tab Q11_location")
>
> <sup> Owner Location Distribution </sup>

> ![Pet Ownership Distribution](/05_screenshots/09_OCount.png
"From tab Q13_OCount")
>
> <sup> Pet Ownership Distribution </sup>

> ![Owners' Ranking by Revenue and Pet Count](/05_screenshots/10_ORank.png
"From tab Q12_ORank")
>
> <sup> Owners' Ranking by Revenue and Pet Count </sup>

---

### Revenue By Items

_The current structure of this dimension is synthetic in nature and does not yield meaningful analytical value at this stage. A redesign is planned to enhance its integrity, after which a formal analysis will be conducted. This limitation does not compromise the overall analytical framework or logic in this showcase project._

## Strategic Recommendations

### Workforce Optimization
- **Performance Intervention**: Initiate a conversation with Fung (GP) and Lin (ER) to understand their current situation and struggles, then develop <ins> individualized improvement plans </ins> with measurable milestones.
- **Revenue Enhancement**: Provide <ins> targeted mentoring </ins> for stagnating GPs, Dai and Gong, to improve revenue-per-pet ratios. Ha could be an ideal candidate for mentorship.
- **Talent Retention**: Engage with Koo to assess <ins> workload sustainability</ins>. Leverage Lee's onboarding to distribute Ophthalmology caseloads more effectively.

### Revenue Diversification
- **Species Dependency Mitigation**: Develop marketing and service offerings to <ins> increase feline and alternative species owner segments </ins>.
- **ACV Improvement**: <ins> Enhance first-time resolution rates </ins> through advanced diagnostics and premium medical protocols. <ins> Review pricing strategies </ins> to align with service quality enhancements.
- **Lifecycle Preparedness**: <ins> Align procurement plans </ins> with anticipated shifts in pet demographics and lifestages to ensure service readiness.

### Geographic Expansion and Pet Owner Growth
- **New Owner Acquistion**: Launch <ins> targeted marketing campaigns </ins> in Kowloon and Hong Kong Island to diversify the geographic revenue base. Possible marketing medium might be leaflets, social media, or by word-of-mouth.
- **Owner Insight & Retention**: Implement <ins> short-form client satisfaction surveys </ins> to capture service gaps and identify opportunities for new service development.

## Assumptions and Caveats

- **Uniform Operational Exposure**: The analysis assumes consistent business hours and pet owner exposure across all vets.
- **Service Line Characteristics**: The veterinary performance scatter plot serves as an indicative diagnostic tool and should not be interpreted as an absolute performance measure. Its primary purpose is to enable early-stage identification of potential underperformance. It is important to note that if all veterinarians are already operating near maximum efficiency, positioning in the lower left quadrant may be attributable to inherent limitations within specific service lines rather than individual capability.
- **Data Completeness Caveats**: Missing data in `Pet_Number`, `Species`, and `Age` fields require further investigation within the PMS system.
- **Case Segmentation**: Each `Case_Number` is treated as discrete. Potential interdependencies between cases have not been modeled.
- **Mortality Impact**: Deceased pets have not been excluded from the dataset, which may introduce minor distortions in analyses focused exclusively on active pet distribution metrics.

---

- For data cleaning methodology and records, please refer to [files in this folder](/03_data_cleaning).
- For data analysis related SQL queries and Excel workbook, please refer to [files in this folder](/04_data_analysis).
- For potential collaboration or further discussion, please contact me [via email](mailto:craig.lwy@gmail.com).
