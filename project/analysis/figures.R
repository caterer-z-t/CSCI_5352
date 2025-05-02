# In[1]: Imports ----

library(ggplot2)
library(dplyr)
library(gridExtra)
library(cowplot)
library(ggpattern)
library(tidyr)
library(ggbeeswarm) # for swarm plots

# In[2]: Custom Colors ----

# Create a custom color palette that differentiates between eras and categories
custom_colors <- c(
    "Historic Total Funding" = "#052F5F",
    "Historic Collaboration Funding" = "#0D7DFF",
    "Modern Total Funding" = "#50723C",
    "Modern Collaboration Funding" = "#84BD64"
)

# Define custom colors
custom_colors_minimal <- c(
    "Historic" = "#052F5F",
    "Modern" = "#50723C",
    "historic" = "#052F5F",
    "modern" = "#50723C"
)

# In[3]: Load Data ----

# set working directory to this file's location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Load data
df <- read.csv("../results/funding_data.csv")

head(df)

df <- # remove the last 2 rows
    df %>%
    filter(Year != "Modern") %>%
    filter(Year != "Historic") %>%
    filter(Year != 2025) %>%
    filter(Year != 2000)

# In[4]: Funding Plot ----

# Compute the maximum Funding.Amount to set a common y-axis range
max_y_value <- max(df$Funding.Amount, na.rm = TRUE)

# Ensure the data has a combined category column
df$Combined_Category <- paste(df$Era, df$Category)

# Create a single plot for both Historic and Modern eras
plot <- ggplot(df, aes(x = Year, y = Funding.Amount, fill = Combined_Category)) +
    geom_bar(stat = "identity", position = position_dodge(width = 0.5)) +
    # Facet wrap to separate Historic and Modern eras
    facet_wrap(~Era,
        scales = "free_x", ncol = 2,
        labeller = labeller(Era = c(
            "Historic" = "Historic (1995 - 1999)",
            "Modern" = "Modern (2020 - 2024)"
        ))
    ) +
    labs(
        title = "Funding Amounts Across Eras",
        x = "Year",
        y = "Funding Amount ($)"
    ) +
    scale_fill_manual(
        values = custom_colors,
        name = "Funding Category",
        labels = c(
            "Historic Collaboration",
            "Historic Total",
            "Modern Collaboration",
            "Modern Total"
        )
    ) +
    scale_y_continuous(limits = c(0, max_y_value)) +
    theme_minimal() +
    theme(
        plot.margin = margin(10, 10, 10, 10),
        axis.text.x = element_text(angle = 45, hjust = 1),
        plot.background = element_rect(fill = "white"),
        plot.title = element_text(hjust = 0.5),
        strip.text = element_text(face = "bold", hjust = 0.5)
    )
print(plot)
ggsave("../figures/funding_plot.png", plot, width = 12, height = 6, dpi = 600)

# In[4.1]: numerical summary ----
# lets sum up the funding amount and total grants for the eras
df_summary <- df %>%
    group_by(Era, Category) %>%
    summarise(
        Total_Funding = sum(Funding.Amount, na.rm = TRUE),
        Total_Grants = sum(Grants, na.rm = TRUE)
    )
print(df_summary)

# get the difference in(%) for the funding and grants from historic to modern and print it
df_summary <- df_summary %>%
    group_by(Category) %>%
    summarise(
        Funding_Difference = (Total_Funding[Era == "Modern"] - Total_Funding[Era == "Historic"]) / Total_Funding[Era == "Historic"] * 100,
        Grants_Difference = (Total_Grants[Era == "Modern"] - Total_Grants[Era == "Historic"]) / Total_Grants[Era == "Historic"] * 100
    )
print(df_summary)

# In[5]: Number of Grants Plot ----

# Compute the maximum Grants to set a common y-axis range
max_y_value <- max(df$Grants, na.rm = TRUE)

# Ensure the data has a combined category column
df$Combined_Category <- paste(df$Era, df$Category)

# Create a single plot for both Historic and Modern eras
plot <- ggplot(df, aes(x = Year, y = Grants, fill = Combined_Category)) +
    geom_bar(stat = "identity", position = position_dodge(width = 0.5)) +
    # Facet wrap to separate Historic and Modern eras
    facet_wrap(~Era,
        scales = "free_x", ncol = 2,
        labeller = labeller(Era = c(
            "Historic" = "Historic (1995 - 1999)",
            "Modern" = "Modern (2020 - 2024)"
        ))
    ) +
    labs(
        title = "Number of Grants Across Eras",
        x = "Year",
        y = "Number of Grants"
    ) +
    scale_fill_manual(
        values = custom_colors,
        name = "Funding Category",
        labels = c(
            "Historic Collaboration",
            "Historic Total",
            "Modern Collaboration",
            "Modern Total"
        )
    ) +
    scale_y_continuous(limits = c(0, max_y_value)) +
    theme_minimal() +
    theme(
        plot.margin = margin(10, 10, 10, 10),
        axis.text.x = element_text(angle = 45, hjust = 1),
        plot.background = element_rect(fill = "white"),
        plot.title = element_text(hjust = 0.5),
        strip.text = element_text(face = "bold", hjust = 0.5)
    )
print(plot)
ggsave("../figures/number_of_grants_plot.png", plot, width = 12, height = 6, dpi = 600)

# In[6]: Node and Graph level statistics ----

# Load data
df <- read.csv("../results/graph_stats.csv")
df_lcc <- read.csv("../results/graph_stats_lcc.csv")

df <- df %>%
    mutate(
        era = ifelse(grepl("modern", graph), "modern", "historic"),
        year = suppressWarnings(as.numeric(gsub(".*_(\\d{4}).*", "\\1", graph))), # Extract year safely
        self_loops = ifelse(grepl("no_self_loops", graph), "No", "Yes")
    )

df_lcc <- df_lcc %>%
    mutate(
        era = ifelse(grepl("modern", graph), "modern", "historic"),
        year = suppressWarnings(as.numeric(gsub(".*_(\\d{4}).*", "\\1", graph))), # Extract year safely
        self_loops = ifelse(grepl("no_self_loops", graph), "No", "Yes")
    )

# remove year 2000 and 2025
df <- df %>%
    filter(year != 2000) %>%
    filter(year != 2025)

df_lcc <- df_lcc %>%
    filter(year != 2000) %>%
    filter(year != 2025)

print(colnames(df_lcc))
print(head(df_lcc))

# Ensure df_lcc is properly structured
df_lcc <- df_lcc %>%
    mutate(era = factor(era, levels = c("historic", "modern"), labels = c("Historic", "Modern"))) # Capitalize "era"

# Select relevant columns and pivot data for ggplot2
df_long <- df_lcc %>%
    select(era, avg_degree, clustering_coeff, density, radius, avg_shortest_path_length, avg_betweenness_centrality) %>%
    pivot_longer(cols = -era, names_to = "metric", values_to = "value") %>%
    mutate(
        metric = gsub("_", " ", metric), # Replace underscores with spaces
        metric = tools::toTitleCase(metric) # Capitalize each word
    )

ggplot(df_long, aes(x = era, y = value, fill = era)) +
    geom_boxplot(outlier.shape = NA, alpha = 0.8) +
    geom_jitter(position = position_jitter(width = 0.1), size = 1, alpha = 0.5) + # Show data points
    scale_fill_manual(values = custom_colors_minimal) +
    facet_wrap(~metric, scales = "free_y") + # Separate plots per metric, allowing different y-scales
    labs(
        title = "Evolution of Research Collaboration Networks",
        x = "Era",
        y = "Value",
        fill = "Era"
    ) +
    theme_minimal() +
    theme(
        axis.text.x = element_text(angle = 45, hjust = 1, size = 10), # Rotate x-axis labels
        plot.title = element_text(size = 14, face = "bold", hjust = 0.5), # Improve title readability
        strip.text = element_text(size = 12, face = "bold"), # Facet titles
        legend.position = "none", # Remove legend
        plot.margin = margin(10, 10, 10, 10), # Increase plot margins
        plot.background = element_rect(fill = "white", color = NA)
    )

ggsave("../figures/graph_stats.png", width = 12, height = 12, dpi = 600)

# In[7]: Centrality ----

# Load data
df <- read.csv("../results/centrality_combined.csv")

print(head(df))

# Scatter plot: Degree vs. Centrality (colored by Era)
ggplot(df, aes(x = Degree, y = Betweenness, color = Era)) +
    geom_point(alpha = 0.7) +
    theme_minimal() +
    labs(
        title = "Collaboration Centrality Over Time",
        x = "Degree Centrality",
        y = "Betweenness Centrality",
        color = "Era"
    ) +
    scale_color_manual(values = c("historic" = "blue", "modern" = "red"))

# Faceted version (to show yearly trends within each era)
ggplot(df, aes(x = Degree, y = Betweenness, color = Era)) +
    geom_point(alpha = 0.7) +
    facet_wrap(~Year) +
    theme_minimal() +
    labs(
        title = "Collaboration Centrality Trends Per Year",
        x = "Degree Centrality",
        y = "Betweenness Centrality",
        color = "Era"
    ) +
    scale_color_manual(values = c("historic" = "blue", "modern" = "red"))

# Boxplot: Comparing distributions of centrality measures by Era
ggplot(df, aes(x = Era, y = Betweenness, fill = Era)) +
    geom_boxplot(alpha = 0.5) +
    theme_minimal() +
    labs(
        title = "Comparison of Centrality Measures Across Eras",
        x = "Era",
        y = "Betweenness Centrality"
    ) +
    scale_fill_manual(values = c("historic" = "blue", "modern" = "red"))


# In[8]: Network Metrics Bar Graphs----

# Load data
df_values <- read_csv("../results/network_metrics.csv")
df_nulls <- read_csv("../results/network_metrics_null.csv")

# Separate into Count and Metric axes
df_values$Axis <- factor(df_values$Axis, levels = c("Count", "Metric"))
df_nulls$Axis <- factor(df_nulls$Axis, levels = c("Count", "Metric"))

# Set up for dual axis scaling
# You must rescale one y-axis to map to the same space
scaling_factor <- max(df_values$Value[df_values$Axis == "Count"]) /
    max(df_values$Value[df_values$Axis == "Metric"])

# Apply scaling to secondary y-axis values
df_values <- df_values %>%
    mutate(Value_scaled = ifelse(Axis == "Metric", Value * scaling_factor, Value))

df_nulls <- df_nulls %>%
    mutate(Value_scaled = ifelse(Axis == "Metric", Value * scaling_factor, Value))

# Plot
ggplot(df_values, aes(x = Metric, y = Value_scaled, fill = Group)) +
    geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.7) +
    geom_point(
        data = df_nulls,
        aes(x = Metric, y = Value_scaled, color = Group, shape=Group),
        position = position_dodge(width = 0.8),
        size = 3, inherit.aes = FALSE
    ) +
    scale_fill_manual(values = c("Historic" = "#052F5F", "Modern" = "#50723C")) +
    scale_color_manual(values = c("Historic WS" = "#929292", "Modern WS" = "#929292")) +
    scale_y_continuous(
        name = "Count (Nodes, Edges)",
        sec.axis = sec_axis(~ . / scaling_factor, name = "Metric Value (Clustering, Avg. Path Length)")
    ) +
    ggtitle("Network Metrics Comparison: Historic vs. Modern") +
    theme_minimal() +
    theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 12),
        axis.title.y.right = element_text(size = 12),
        legend.title = element_blank()
    )

ggsave("../figures/network_metrics.png", width = 12, height = 6, dpi = 600)


# In[9]: eigenvector centrality  ----

# Load the data from CSV
centrality_df <- read_csv("../results/centrality_data.csv")

# Add log10 centrality (avoiding log(0))
centrality_df <- centrality_df %>%
    mutate(log_centrality = log(ifelse(centrality == 0, NA, centrality)))

# Plot
# Plot with violin + swarm (beeswarm)
ggplot(centrality_df, aes(x = period, y = log_centrality, fill = period)) +
    geom_violin(trim = TRUE, alpha = 0.7) +
    geom_beeswarm(color = "grey", size = 1, alpha = 0.3, priority = "density", cex = 0.3) +
    scale_fill_manual(values = c("Historic" = "#052F5F", "Modern" = "#50723C")) +
    theme_minimal() +
    theme(
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        axis.title.y = element_text(size = 12), # now the y-axis title shows up
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        legend.position = "none"
    ) +
    labs(
        title = "Eigenvector Centrality Distribution",
        y = expression(ln("Eigenvector Centrality")), # math-style label
        x = "Period"
    )



# Save the plot
ggsave("../figures/eigenvector_centrality_distribution.png", width = 8, height = 5, dpi = 600)


# In[10]: Modularity Matrix ----

historic_df <- read.csv("../results/modularity/historic_modularity_matrix.csv")

# Normalize frequency column
historic_df <- historic_df %>%
    mutate(frequency = frequency / sum(frequency))

# Convert digits to numeric for filtering
historic_df <- historic_df %>%
    mutate(
        A_num = as.numeric(as.character(zip_digit_A)),
        B_num = as.numeric(as.character(zip_digit_B))
    )
    # ) %>%
    # filter(B_num <= A_num) # upper triangle (flipped y)

# Reset factor levels for plotting
historic_df <- historic_df %>%
    mutate(
        zip_digit_A = factor(A_num, levels = sort(unique(A_num))),
        zip_digit_B = factor(B_num, levels = rev(sort(unique(B_num))))
    )

# Plot
ggplot(historic_df, aes(x = zip_digit_A, y = zip_digit_B, fill = frequency)) +
    geom_tile(color = "white") +
    scale_fill_gradient(low = "white", high = "#052F5F") +
    labs(
        title = "Collaboration Frequency by ZIP Digit, Historic (1995 - 1999)",
        x = "ZIP Digit of Institution A",
        y = "ZIP Digit of Institution B",
    ) +
    theme_minimal() +
        theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text.y = element_text(angle = 0, hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        legend.position = "none",
        legend.title = element_blank(),
        legend.key.size = unit(0.5, "cm"),
        legend.text = element_text(size = 10)
    ) 

# Save the plot
ggsave("../figures/modularity/historic_modularity_matrix.png", width = 8, height = 6, dpi = 600)

# In[11]: Modularity Matrix Modern ----
modern_df <- read.csv("../results/modularity/modern_modularity_matrix.csv")
# Normalize frequency column
modern_df <- modern_df %>%
    mutate(frequency = frequency / sum(frequency))
# Convert digits to numeric for filtering
modern_df <- modern_df %>%
    mutate(
        A_num = as.numeric(as.character(zip_digit_A)),
        B_num = as.numeric(as.character(zip_digit_B))
    )
    # ) %>%
    # filter(B_num <= A_num) # upper triangle (flipped y)
# Reset factor levels for plotting
modern_df <- modern_df %>%
    mutate(
        zip_digit_A = factor(A_num, levels = sort(unique(A_num))),
        zip_digit_B = factor(B_num, levels = rev(sort(unique(B_num))))
    )
# Plot
ggplot(modern_df, aes(x = zip_digit_A, y = zip_digit_B, fill = frequency)) +
    geom_tile(color = "white") +
    scale_fill_gradient(low = "white", high = "#50723C") +
    labs(
        title = "Collaboration Frequency by ZIP Digit, Modern (2020 - 2024)",
        x = "ZIP Digit of Institution A",
        y = "ZIP Digit of Institution B",
    ) +
    theme_minimal() +
    theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text.y = element_text(angle = 0, hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        legend.position = "none",
        legend.title = element_blank(),
        legend.key.size = unit(0.5, "cm"),
        legend.text = element_text(size = 10)
    )
# Save the plot
ggsave("../figures/modularity/modern_modularity_matrix.png", width = 8, height = 6, dpi = 600)
