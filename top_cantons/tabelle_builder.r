#TESTING
if (simulation == TRUE) {
cant <- cant %>%
  mutate(cantonJaStimmenInProzent = runif(n(), min = 0, max = 100),
         cantonNoStimmenInProzent = runif(n(), min = 0, max = 100))
}

# Fonction pour créer la table par langue
create_table <- function(lang_col, vorlage_col) {
  
  # Première votation
  fr_1 <- cant %>% filter(issue_number == 1)
  tab_1 <- fr_1 %>%
    select({{lang_col}}, cantonJaStimmenInProzent, cantonNoStimmenInProzent, everything()) %>%
    slice_max(order_by = cantonJaStimmenInProzent, n = 3) %>%
    mutate(cantonNoStimmenInProzent = NA_real_) %>%
    bind_rows(
      fr_1 %>%
        slice_max(order_by = cantonNoStimmenInProzent, n = 3) %>%
        mutate(cantonJaStimmenInProzent = NA_real_)
    ) %>%
    add_row(!!as.name(lang_col) := fr_1[[vorlage_col]][1], .before = 1)
  
  # Deuxième votation
  fr_2 <- cant %>% filter(issue_number == 2)
  tab_2 <- fr_2 %>%
    select({{lang_col}}, cantonJaStimmenInProzent, cantonNoStimmenInProzent, everything()) %>%
    slice_max(order_by = cantonJaStimmenInProzent, n = 3) %>%
    mutate(cantonNoStimmenInProzent = NA_real_) %>%
    bind_rows(
      fr_2 %>%
        slice_max(order_by = cantonNoStimmenInProzent, n = 3) %>%
        mutate(cantonJaStimmenInProzent = NA_real_)
    ) %>%
    add_row(!!as.name(lang_col) := fr_2[[vorlage_col]][1], .before = 1)
  
  # Assembler
  bind_rows(tab_1, tab_2) 
}

create_table <- function(lang_col, vorlage_col) {
  
  make_tab <- function(issue_num) {
    df <- cant %>% filter(issue_number == issue_num)
    
    # Top 3 Ja
    top_ja <- df %>%
      slice_max(order_by = cantonJaStimmenInProzent, n = 3) %>%
      mutate(cantonNoStimmenInProzent = NA_real_)
    
    # Top 3 No
    top_no <- df %>%
      slice_max(order_by = cantonNoStimmenInProzent, n = 3) %>%
      mutate(cantonJaStimmenInProzent = NA_real_)
    
    # Ligne Vorlage : uniquement le texte de la votation, tout le reste vide
    vorlage_row <- df[1, ] %>%
      mutate(across(everything(), ~ NA)) %>%      # mettre tout à NA
      mutate(!!as.name(lang_col) := df[[vorlage_col]][1])  # remplacer la colonne de langue
    
    # Assembler
    bind_rows(vorlage_row, top_ja, top_no) %>%
      select({{lang_col}}, cantonJaStimmenInProzent, cantonNoStimmenInProzent, everything())
  }
  
  # Votation 1 et 2
  tab1 <- make_tab(1)
  tab2 <- make_tab(2)
  
  bind_rows(tab1, tab2)
}




replace_na_with_space <- function(df) {
  df %>%
    mutate(across(everything(), ~ ifelse(is.na(.), " ", .)))
}

# Exemple d'utilisation
tabelle_fr <- create_table("Kanton_f", "Vorlage_f") %>%
  replace_na_with_space()


tabelle_de <- create_table("Kanton_d", "Vorlage_d") %>%
  replace_na_with_space()

tabelle_it <- create_table("Kanton_i", "Vorlage_i") %>%
  replace_na_with_space()






####

tabelle_fr <- tabelle_fr %>%
  select(Kanton_f,Wappen,cantonJaStimmenInProzent,cantonNoStimmenInProzent) %>%
  rename(Canton = Kanton_f,
         " " = Wappen,
         Oui = cantonJaStimmenInProzent,
         Non = cantonNoStimmenInProzent)

tabelle_de <- tabelle_de %>%
  select(Kanton_d,Wappen,cantonJaStimmenInProzent,cantonNoStimmenInProzent) %>%
  rename(Kanton = Kanton_d,
         " " = Wappen,
         Ja = cantonJaStimmenInProzent,
         Nein = cantonNoStimmenInProzent)

tabelle_it <- tabelle_it %>%
  select(Kanton_i,Wappen,cantonJaStimmenInProzent,cantonNoStimmenInProzent) %>%
  rename(Cantone = Kanton_i,
         " " = Wappen,
         Si = cantonJaStimmenInProzent,
         No = cantonNoStimmenInProzent)


#fr_1 <- cant %>%
 # filter(issue_number == 1)

#tab_fr_1 <- fr_1 %>%
  # sélectionner les colonnes utiles (on garde tout pour la sortie)
 # select(Kanton_f, cantonJaStimmenInProzent, cantonNoStimmenInProzent, everything()) %>%
#  slice_max(order_by = cantonJaStimmenInProzent, n = 3) %>%
 # mutate(cantonNoStimmenInProzent = NA_real_) %>%
#  bind_rows(
    # top 3 No
 #   cant %>%
  #    filter(issue_number == 1) %>%
   #   slice_max(order_by = cantonNoStimmenInProzent, n = 3) %>%
   #   mutate(cantonJaStimmenInProzent = NA_real_)
  #) %>%
  #add_row(Kanton_f = fr_1$Vorlage_f[1], .before = 1)

#fr_2 <- cant %>%
 # filter(issue_number == 2)
  
#tab_fr_2 <- fr_2 %>%  
  # sélectionner les colonnes utiles (on garde tout pour la sortie)
 # select(Kanton_f, cantonJaStimmenInProzent, cantonNoStimmenInProzent, everything()) %>%
#  slice_max(order_by = cantonJaStimmenInProzent, n = 3) %>%
 # mutate(cantonNoStimmenInProzent = NA_real_) %>%
  #bind_rows(
    # top 3 No
   # cant %>%
    #  filter(issue_number == 2) %>%
     # slice_max(order_by = cantonNoStimmenInProzent, n = 3) %>%
    #  mutate(cantonJaStimmenInProzent = NA_real_)
#  ) %>%
 # add_row(Kanton_f = fr_2$Vorlage_f[1], .before = 1)

#tabelle_fr <- tab_fr_1 %>%
 # bind_rows(tab_fr_2)
 