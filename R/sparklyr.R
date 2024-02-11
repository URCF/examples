# require(sparklyr)
# require(arrow)
# require(microbenchmark)

# Attach packages
suppressPackageStartupMessages({
  library(sparklyr)
  library(dplyr)
})

sc <- spark_connect(master = "spark://node057:63765", 
                    spark_home = "/ifs/opt/spark/3.5.0",
                    config = list("sparklyr.shell.driver-memory" = "5g",
                                  "spark.executor.instances" = 3,
                                  "spark.executor.cores" = 20,
                                  "spark.executor.memory" = "24g"))

# load airline dataset into Spark
airline_tlb <- spark_read_csv(sc, 
                              name = 'airline_data', 
                              path = '/home/lbn28/data/airlines/data/')
print(sdf_dim(airline_tlb))

# Average delay during different day of week
microbenchmark::microbenchmark(
  spark_r = {
    delay_timeofday_spark <- airline_tlb %>% 
      mutate(numeric_depdelay = as.numeric(DepDelay)) %>%
      mutate(numeric_arrdelay = as.numeric(ArrDelay)) %>%
      group_by(DayOfWeek) %>%
      summarize(avg_depdelay = mean(numeric_depdelay),
                avg_arrdelay = mean(numeric_arrdelay)) %>%
      collect            
  }, times = 1)

# load airline dataset into local memory
library(readr)
list_of_files <- list.files(path = "/home/lbn28/data/airlines/data/",
                            recursive = TRUE,
                            pattern = "\\.csv$",
                            full.names = TRUE)
airline_df <- readr::read_csv(list_of_files, id = "file_name")
airline_df <- subset(airline_df, select=-c(file_name))

microbenchmark::microbenchmark(
  spark_r = {
    delay_timeofday_spark <- airline_tlb %>% 
      mutate(numeric_depdelay = as.numeric(DepDelay)) %>%
      mutate(numeric_arrdelay = as.numeric(ArrDelay)) %>%
      group_by(DayOfWeek) %>%
      summarize(avg_depdelay = mean(numeric_depdelay),
                avg_arrdelay = mean(numeric_arrdelay)) %>%
      collect            
  },
  vanilla_r = {
    delay_timeofday_vanilla <- airline_df %>% 
      filter(!is.na(DepDelay)) %>%
      filter(!is.na(ArrDelay)) %>%
      group_by(DayOfWeek) %>%
      summarize(avg_depdelay = mean(DepDelay),
                avg_arrdelay = mean(ArrDelay))
    }, 
  times = 10
) %T>% print() %>% ggplot2::autoplot()

spark_disconnect(sc)
