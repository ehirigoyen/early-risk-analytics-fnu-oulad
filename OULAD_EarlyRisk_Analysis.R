############################################################
# Project: OULAD Early Risk Analysis
# File: OULAD_EarlyRisk_Analysis.R
# Purpose: Identify early-risk patterns using student
#          engagement during the first weeks of the course
# Data Source: OULAD_Analytics (SQL Server)
# Author: Enrique Hirigoyen
# Date: 
############################################################


# Load vw_OULAD_EarlyRisk into R (only one time)

#install.packages(c("DBI", "odbc", "dplyr", "ggplot2"))

# 1- Load libraries 
library(DBI)
library(odbc)
library(dplyr)
library(ggplot2)

# 2- Connect to SQL Server (LAPTOP-EH)
con <- dbConnect(
  odbc::odbc(),
  Driver = "SQL Server",
  Server = "LAPTOP-EH",
  Database = "OULAD_Analytics",
  Trusted_Connection = "Yes"
)

# 3- Load the Early Risk view
oulad_early <- dbReadTable(con, "vw_OULAD_EarlyRisk")

# Check if load the data 
   dim(oulad_early)
   head(oulad_early)
   summary(oulad_early$clicks_day0_21)
   
# 4) Create basic outcome flags (to match FNU logic)

oulad_early <- oulad_early %>%
  mutate(
    pass_flag = ifelse(final_result %in% c("Pass", "Distinction"), 1, 0),
    withdraw_flag = ifelse(final_result == "Withdrawn", 1, 0)
  )

#  Quick sanity check:

table(oulad_early$final_result)

#5) First Early-Risk Insight (very important)
oulad_early %>%
  group_by(pass_flag) %>%
  summarise(
    avg_clicks_early = mean(clicks_day0_21, na.rm = TRUE),
    avg_active_days  = mean(active_days_0_21, na.rm = TRUE),
    n = n()
  )


# ----------------------------------------------------------
# STEP 6: First Visualization — Early Engagement vs Outcome
# ----------------------------------------------------------

ggplot(oulad_early, aes(x = factor(pass_flag), y = clicks_day0_21)) +
  geom_boxplot(outlier.alpha = 0.05, fill = "lightgray") +
  scale_x_discrete(
    labels = c("0" = "Did Not Pass", "1" = "Passed")
  ) +
  labs(
    title = "Early Engagement vs Final Outcome (OULAD)",
    subtitle = "Student activity during the first 3 weeks (Days 0–21)",
    x = "Final Outcome",
    y = "Total Clicks (First 3 Weeks)"
  ) +
  theme_minimal(base_size = 12)

ggsave("OULAD_EarlyEngagement_vs_Outcome.png", width = 8, height = 5, dpi = 300)


# ----------------------------------------------------------
# STEP 7: Define an Early-Risk Threshold
# ----------------------------------------------------------

# 7.1 Inspect the distribution (to choose a cutoff)

summary(oulad_early$clicks_day0_21)
quantile(oulad_early$clicks_day0_21, probs = c(0.10, 0.25, 0.50), na.rm = TRUE)


# 7.2 Create the Early-Risk flag

oulad_early <- oulad_early %>%
  mutate(
    early_risk_flag = ifelse(
      clicks_day0_21 < quantile(clicks_day0_21, 0.25, na.rm = TRUE),
      1, 0
    )
  )

# 7.3 Validate the rule

oulad_early %>%
  group_by(early_risk_flag) %>%
  summarise(
    pass_rate     = round(mean(pass_flag), 3),
    withdraw_rate = round(mean(withdraw_flag), 3),
    students      = n()
  )

# 7.4 Visual check

ggplot(oulad_early, aes(x = factor(early_risk_flag), y = clicks_day0_21)) +
  geom_boxplot(outlier.alpha = 0.05, fill = "lightgray") +
  scale_x_discrete(labels = c("0" = "Not Early Risk", "1" = "Early Risk")) +
  labs(
    title = "Early-Risk Classification Based on First-3-Weeks Activity",
    x = "Early-Risk Flag",
    y = "Total Clicks (Days 0–21)"
  ) +
  theme_minimal()

# Option A: zoom the y-axis (recommended for a report)
ggplot(oulad_early, aes(x = factor(early_risk_flag), y = clicks_day0_21)) +
  geom_boxplot(outlier.alpha = 0.05, fill = "lightgray") +
  coord_cartesian(ylim = c(0, 800)) +
  scale_x_discrete(labels = c("0" = "Not Early Risk", "1" = "Early Risk")) +
  labs(title="Early-Risk Classification (Zoomed)", x="Early-Risk Flag", y="Total Clicks (Days 0–21)") +
  theme_minimal()

# Option B: log scale (good for heavy tails)

ggplot(oulad_early, aes(x = factor(early_risk_flag), y = clicks_day0_21 + 1)) +
  geom_boxplot(outlier.alpha = 0.05, fill = "lightgray") +
  scale_y_log10() +
  scale_x_discrete(labels = c("0" = "Not Early Risk", "1" = "Early Risk")) +
  labs(title="Early-Risk Classification (Log Scale)", x="Early-Risk Flag", y="Log10(Clicks + 1)") +
  theme_minimal()


# Save the cutoff once (more readable + reproducible than recomputing inside mutate()):

cutoff_25 <- quantile(oulad_early$clicks_day0_21, 0.25, na.rm = TRUE)
oulad_early <- oulad_early %>% mutate(early_risk_flag = ifelse(clicks_day0_21 < cutoff_25, 1, 0))


# ----------------------------------------------------------
# STEP 8: Predicting Pass Probability (Logistic Regression)
# ----------------------------------------------------------

# 8.1 Build a clean modeling dataset (keep only needed fields)
model_data <- oulad_early %>%
  select(
    pass_flag,
    clicks_day0_21,
    active_days_0_21,
    age_band,
    gender,
    highest_education
  ) %>%
  na.omit()

# Quick check
dim(model_data)
table(model_data$pass_flag)

# 8.2 Fit a logistic regression model (interpretable)
model_pass <- glm(
  pass_flag ~ clicks_day0_21 + active_days_0_21 + age_band + gender + highest_education,
  data = model_data,
  family = binomial
)

summary(model_pass)

# 8.3 Odds Ratios (easier to interpret)
odds_ratios <- exp(coef(model_pass))
conf_int <- exp(confint(model_pass))

odds_table <- data.frame(
  Odds_Ratio = odds_ratios,
  CI_Lower = conf_int[,1],
  CI_Upper = conf_int[,2]
)

round(odds_table, 3)

# 8.4 Predicted probabilities
model_data$predicted_pass_prob <- predict(model_pass, type = "response")

summary(model_data$predicted_pass_prob)

model_data <- model_data %>%
  mutate(
    high_risk_model = ifelse(predicted_pass_prob < 0.40, 1, 0)
  )

table(model_data$high_risk_model)

# ----------------------------------------------------------
# STEP 9: FNU vs OULAD – Comparative Analysis
# ----------------------------------------------------------

con_fnu <- dbConnect(
  odbc::odbc(),
  Driver = "SQL Server",
  Server = "LAPTOP-EH",
  Database = "FNU_Analytics",
  Trusted_Connection = "Yes"
)

# List available views/tables (do this once)
#dbListTables(con_fnu)


# Load FNU EarlyRisk if see it

fnu_early <- dbReadTable(con_fnu, "vw_FNU_EarlyRisk")

names(fnu_early)


fnu_summary <- fnu_early %>%
  summarise(
    dataset = "FNU",
    pass_rate = mean(pass_flag, na.rm = TRUE),
    withdraw_rate = mean(withdraw_flag, na.rm = TRUE),
    avg_logins_w1_3 = mean(logins_w1_3, na.rm = TRUE),
    avg_minutes_w1_3 = mean(minutes_w1_3, na.rm = TRUE),
    avg_assignments_w1_3 = mean(assignments_w1_3, na.rm = TRUE)
  )

oulad_summary <- oulad_early %>%
  summarise(
    dataset = "OULAD",
    pass_rate = mean(pass_flag, na.rm = TRUE),
    withdraw_rate = mean(withdraw_flag, na.rm = TRUE),
    avg_clicks_day0_21 = mean(clicks_day0_21, na.rm = TRUE),
    avg_active_days_0_21 = mean(active_days_0_21, na.rm = TRUE)
  )

comparison_table <- bind_rows(fnu_summary, oulad_summary)
comparison_table

# *****************************************************************************
# Although FNU and OULAD measure early engagement using different indicators, 
# both datasets show comparable pass rates and a consistent relationship 
# between early activity and student success. This suggests that early 
# engagement is a robust and transferable predictor of academic outcomes 
# across institutional contexts.
# *****************************************************************************

# 9.3.1 Prepare data for plotting

library(tidyr)
library(scales)

comparison_long <- comparison_table %>%
  select(dataset, pass_rate, withdraw_rate) %>%
  pivot_longer(
    cols = c(pass_rate, withdraw_rate),
    names_to = "metric",
    values_to = "value"
  )

# 9.3.2 Create the comparison bar chart

ggplot(comparison_long, aes(x = dataset, y = value, fill = metric)) +
  geom_col(position = "dodge", width = 0.6) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    limits = c(0, 0.6)
  ) +
  scale_fill_manual(
    values = c("pass_rate" = "steelblue", "withdraw_rate" = "firebrick"),
    labels = c("Pass Rate", "Withdraw Rate")
  ) +
  labs(
    title = "FNU vs OULAD: Academic Outcomes Comparison",
    subtitle = "Pass and withdrawal rates across two learning contexts",
    x = "Dataset",
    y = "Percentage of Students",
    fill = "Outcome"
  ) +
  theme_minimal(base_size = 12)

# 9.3.3 Save the chart

ggsave(
  "FNU_vs_OULAD_Academic_Outcomes.png",
  width = 8,
  height = 5,
  dpi = 300
)



# *****************************************************************************
# This project demonstrates that early student engagement is a robust and 
# transferable indicator of academic success. By leveraging early behavioral 
# data, institutions can proactively identify at-risk students and implement 
# timely interventions, improving retention and learning outcomes across 
# diverse educational contexts.
# *****************************************************************************