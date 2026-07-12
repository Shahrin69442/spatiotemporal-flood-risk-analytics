#
install.packages('sf')
library(sf)
install.packages('tidyverse')
library(tidyverse)
install.packages('forecast')
library(forecast)
install.packages('geodata')
library(geodata)
install.packages('ggspatial')
library(ggspatial)
install.packages('viridis')
library(viridis)
#
# 
# Research Project: Spatiotemporal Modeling and Predictive Analytics of 
#                   Riverbank Erosion and Flood Inundation Dynamics in Bangladesh
# Author: Md Shahrin Parvez
# Framework: End-to-End Scalable Pipeline (Spatial KDE + Auto-ARIMA + Simulation)
#
#
library(sf)
library(tidyverse)
library(geodata)
library(ggspatial)

cat(">>> Phase 2: Fetching GADM Spatial Data & Mapping High-Risk Zones...\n")

raw_gadm <- geodata::gadm(country = "BGD", level = 2, path = tempdir())
bd_districts <- st_as_sf(raw_gadm)

names(bd_districts)[names(bd_districts) == "NAME_2"] <- "District"
names(bd_districts)[names(bd_districts) == "NAME_1"] <- "Division"

target_districts <- c("Cox's Bazar", "Bandarban", "Chittagong", "Rangamati", 
                      "Khagrachhari", "Noakhali", "Sylhet", "Sunamganj", 
                      "Habiganj", "Netrakona", "Jamalpur")

bd_districts$Risk_Zone <- "Baseline"
bd_districts$Risk_Zone[bd_districts$District %in% target_districts] <- "High Risk"

map_plot <- ggplot(data = bd_districts) +
  geom_sf(aes(fill = Risk_Zone), color = "white", size = 0.2) +
  scale_fill_manual(values = c("High Risk" = "#d95f02", "Baseline" = "#f0f0f0"), name = "Framework Zone") +
  
  annotation_scale(location = "bl", width_hint = 0.2, style = "ticks") +
  annotation_north_arrow(location = "bl", which_north = "true", pad_x = unit(0.2, "in"), pad_y = unit(0.4, "in"),
                         style = north_arrow_fancy_orienteering) +
  
  labs(title = "Spatiotemporal Risk Assessment: Target Study Area",
       subtitle = "11 High-Risk Flood Inundation & Erosion Districts in Bangladesh",
       caption = "Projection: WGS 84 | Data Source: GADM Framework", 
       x = "Longitude", y = "Latitude") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 12, hjust = 0.5),
        plot.subtitle = element_text(face = "italic", size = 9, hjust = 0.5, color = "gray30"))

print(map_plot)
#
cat(">>> Phase 3: Engineering Climate Physics Simulation Matrix (2020-2025)...\n")

dates <- seq(as.Date("2020-01-01"), as.Date("2025-12-31"), by = "day")

hotspots <- data.frame(
  District = target_districts,
  lon = c(92.01, 92.22, 91.78, 92.20, 91.99, 91.10, 91.87, 91.40, 91.41, 90.72, 89.94),
  lat = c(21.43, 22.19, 22.35, 22.65, 23.11, 22.82, 24.89, 25.07, 24.37, 24.88, 24.92),
  stringsAsFactors = FALSE
)

base_grid <- expand.grid(Date = dates, District = target_districts, stringsAsFactors = FALSE)
simulated_data <- merge(base_grid, hotspots, by = "District", all.x = TRUE)

simulated_data$Month <- as.numeric(format(simulated_data$Date, "%m"))
simulated_data$Year <- as.numeric(format(simulated_data$Date, "%Y"))
simulated_data$Season_Weight <- ifelse(simulated_data$Month %in% 6:9, 1.75, 0.45)

set.seed(2026)
simulated_data$Rainfall_mm <- rgamma(nrow(simulated_data), shape = 2, scale = 15) * simulated_data$Season_Weight
simulated_data$Displacement_Index <- (simulated_data$Rainfall_mm * 1.8) + rnorm(nrow(simulated_data), mean = 50, sd = 15)

cat(">>> Phase 3 execution complete. Dataframe built successfully.\n")
#
#
cat(">>> Phase 4: Computing 2D Kernel Density Estimation for Hotspots...\n")

extreme_events <- simulated_data[simulated_data$Rainfall_mm > 80, ]

kde_plot <- ggplot() +
  geom_sf(data = bd_districts, fill = "#fcfcfc", color = "gray80", size = 0.2) +
  stat_density_2d(data = extreme_events, aes(x = lon, y = lat, fill = after_stat(level)), 
                  geom = "polygon", alpha = 0.6, bins = 10) +
  scale_fill_viridis_c(option = "inferno", name = "Density Kernel") +
  labs(title = "Geospatial Hotspot Identification via 2D KDE",
       subtitle = "Continuous Probability Distributions of Extreme Hydrological Anomalies",
       x = "Longitude", y = "Latitude") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 12, hjust = 0.5))

print(kde_plot)
#
#
library(forecast)
library(ggplot2)

cat(">>> Phase 5: Executing Time-Series Aggregation & Stochastic Forecasting...\n")

monthly_aggregation <- aggregate(Displacement_Index ~ Year + Month, data = simulated_data, FUN = mean)
monthly_ts_data <- monthly_aggregation[order(monthly_aggregation$Year, monthly_aggregation$Month), ]

displacement_ts <- ts(monthly_ts_data$Displacement_Index, start = c(2020, 1), frequency = 12)

fit_arima <- auto.arima(displacement_ts, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)

cat("\n=================== MODEL DIAGNOSTICS ===================\n")
print(summary(fit_arima))
cat("=========================================================\n")

forecast_horizon <- forecast(fit_arima, h = 24)

forecast_plot <- autoplot(forecast_horizon) +
  labs(title = "Stochastic Predictive Horizon via Optimised Auto-ARIMA",
       subtitle = "24-Month Forward Forecast (2026-2027) with 80% and 95% Confidence Intervals",
       x = "Temporal Scale (Years)", y = "Predicted Socio-Economic Displacement Index") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 12, hjust = 0.5))

print(forecast_plot)

cat("\n>>> Pipeline successfully executed. All plots rendered in high-resolution.\n")
