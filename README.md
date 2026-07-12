# Spatiotemporal Modeling and Predictive Analytics of Riverbank Erosion and Flood Inundation Dynamics in Bangladesh

An end-to-end, high-compatibility statistical pipeline developed in R to analyze, map, and forecast extreme hydro-meteorological risks and socio-economic displacement across 11 highly vulnerable districts in Bangladesh.

## 📌 Project Overview
This repository contains a strictly functional, pipe-free (`%>%`) base R framework engineered for spatial risk assessment and time-series forecasting. The pipeline transitions raw GADM administrative boundaries into structured spatial data, applies 2D Kernel Density Estimation (KDE) to isolate extreme weather anomalies, and deploys an optimized Auto-ARIMA model for multi-year predictive modeling.

## 🛠️ Key Methodologies Deployed
*   **Phase 1: Environment Setup & Dependencies** – Automates the audit and installation of required libraries (`sf`, `tidyverse`, `forecast`, `geodata`, `ggspatial`, `viridis`).
*   **Phase 2: Geospatial Baseline Mapping** – Fetches Level 2 GADM data for Bangladesh and isolates 11 high-risk framework zones (Cox's Bazar, Bandarban, Chittagong, Rangamati, Khagrachhari, Noakhali, Sylhet, Sunamganj, Habiganj, Netrakona, Jamalpur).
*   **Phase 3: Bounded Stochastic Climate Simulation** – Engineers a synthetic daily dataset (2020–2025) incorporating historical monsoon season weights and Gamma-distributed rainfall variations.
*   **Phase 4: 2D Kernel Density Estimation (KDE)** – Computes continuous probability distributions over spatial coordinate matrices to identify geographic anomaly hotspots.
*   **Phase 5: Automated ARIMA Forecasting** – Aggregates stochastic metrics to a monthly temporal scale, fits an optimized ARIMA model based on minimized information criteria (AIC/BIC), and projects a 24-month forward predictive horizon with 80% and 95% confidence intervals.

## 📊 Visual Outputs Generated
The pipeline successfully renders three publication-quality visualizations inside RStudio:
1.  **Target Study Area Map** (Cartographic map with scale and north arrow indicators)
2.  **Geospatial Hotspot Probability Heatmap** (Continuous 2D density distributions via viridis inferno scales)
3.  **Stochastic Predictive Horizon Plot** (24-month forward time-series forecast with uncertainty bands)

## 🚀 How to Run the Pipeline
1. Clone this repository to your local system.
2. Open the script in **RStudio**.
3. Run the entire pipeline to automatically handle package dependencies, download boundary assets, and display all analytical plots.

```R
# To execute the full project pipeline, open the script and run:
source("Spatiotemporal_Modeling_Pipeline.R")
