#kantonwappen by benno
kanton_wappen_raw <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/11ubsMMA94G-aRhz7e3mganRLKzqEzfK1UgJ4e2h-RNE/edit?gid=0#gid=0")

#resp. envi.
link_1 <- "https://raw.githubusercontent.com/awp-finanznachrichten/lena_november2025/refs/heads/main/Output_Switzerland/CH_Service_Citoyen_all_data.csv" 

link_2 <- "https://raw.githubusercontent.com/awp-finanznachrichten/lena_november2025/refs/heads/main/Output_Switzerland/CH_Zukunft_all_data.csv"



obj_1 <- read_csv(link_1)

obj_2 <- read_csv(link_2)

