# Load required packages
library(RSQLite)
library(dplyr)
library(readr)

# Connect to the database (using a copy if needed)
db <- dbConnect(SQLite(), "~/Documents/chat_copy.db")

query <- "
SELECT
    m.rowid,
    datetime(m.date / 1000000000 + strftime('%s','2001-01-01'), 'unixepoch') AS date,
    h.id AS sender,
    m.text
FROM message m
LEFT JOIN handle h ON m.handle_id = h.rowid
WHERE h.id = '+19178035970' AND m.text IS NOT NULL
ORDER BY m.date
;"


# Run the query and get the messages
msg_df <- dbGetQuery(db, query)
msg_df <- msg_df %>%
  filter(!is.na(text))   # remove NA text


# Save to CSV
write_csv(msg_df, "data/processed/ethan.csv")

# Disconnect from database
dbDisconnect(db)

saveRDS(msg_df, "data/processed/ethan.rds")
