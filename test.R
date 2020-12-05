library(googlesheets4)
read_sheet("https://docs.google.com/spreadsheets/d/1Q2jHrechQiepjjF0GEHhau5emKCwvaFKYkUUh95s1u4/edit#gid=452876183",
           sheet = "Mayor Data",
           skip = 2)

# the below code was originally used to access Dallas May's data

if (use_cache) {
  raw_data <- load("raw_data.RData")
} else {
  raw_sheet <- read_sheet(params$data_url, skip = 2)
  sheet_names <- sheet_names(params$data_url)
  
  # These are hard-coded numbers of rows to skip on each page. This is not ideal and should
  # be automated if possible.
  rows_to_skip = c(2, 1, 2, 1, 0, 1)
  names(rows_to_skip) <- sheet_names
  
  get_sheet_data <- function(sheet_name) {
    row_skip_count <- rows_to_skip[sheet_name]
    raw_sheet <-
      read_sheet(params$data_url, sheet = sheet_name, skip = row_skip_count)
  }
  
  raw_data <- sapply(sheet_names, get_sheet_data)
  
  save(raw_data, file = "raw_data.RData")
}

hospital_use <- read_sheet("https://docs.google.com/spreadsheets/d/1Q2jHrechQiepjjF0GEHhau5emKCwvaFKYkUUh95s1u4/edit#gid=452876183",
                           sheet = "Mayor Data",
                           skip = 2)

hospital_use %>%
  group_by(`County Name`,
           week) %>%
  summarize(weekly_case_count = sum(daily_case_count)) %>%
  filter(`County Name` == "Dallas") %>%
  ggplot(aes(x = week, y = weekly_case_count)) +
  geom_col() +
  labs(title = "Dallas County COVID-19 cases by week",
       subtitle = "data from https://www.dshs.state.tx.us/coronavirus/additionaldata/") +
  xlab("CDC week") +
  ylab("case count")
