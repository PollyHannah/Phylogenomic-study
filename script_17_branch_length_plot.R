library(tidyverse)
library(ggrepel)

# input vector
x <- c(
  0.6978, 0.3992, 0.5175, 0.7774, 2.6686, 0.6114, 0.6201, 1.8119,
  1.0034, 0.5732, 0.5004, 1.032, 0.6852, 0.7711, 0.5864, 0.378,
  1.384, 0.757, 0.3488, 0.5829, 0.5857, 0.9972, 1.6709, 0.6136,
  0.3623, 0.4802
)

# thresholds
q1 <- quantile(x, 0.25)
q3 <- quantile(x, 0.75)
iqr <- q3 - q1
hi  <- q3 + 1.5 * iqr

df <- tibble(idx = seq_along(x),
             value = x,
             outlier = value > hi)

# plot (highlight only high outliers)
ggplot(df, aes(x = factor(1), y = value)) +
  geom_boxplot(width = 0.15, outlier.shape = NA) +
  geom_text_repel(data = df |> filter(outlier),
                  aes(label = round(value, 3)),
                  nudge_x = 0.2, min.segment.length = 0) +
  geom_text_repel(data = df |> filter(value==1.384),
                  aes(label = round(value, 3)),
                  nudge_x = 0.2, min.segment.length = 0) +
  geom_jitter(aes(color = outlier), width=0.02, size = 2, alpha = 1) +
  scale_color_manual(values = c(`TRUE` = "red", `FALSE` = "grey")) +
  coord_flip() +
  labs(x = NULL, y = "Branch length",
       title = "Branch lengths connecting MCV to other genomes",
       subtitle = "Outliers of 1.5 * IQR are highlighted in red \nLoci which were examined with BLAST are labelled") +
  theme_minimal() +
  ylim(0, NA) +
  theme(legend.position = "none")

