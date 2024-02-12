

all_qmd <- list.files(".",
                      recursive = TRUE,
                      pattern = ".qmd",
                      full.names = TRUE)


libs <- lapply(all_qmd, \(x) {
  
  tmp <- readLines(x)
  
  tmp <- tmp |> 
    stringr::str_extract_all("library\\([A-Za-z]+\\)") |>
    unlist()
  
  return(tmp)
}) |> unlist()

libs <- data.frame(Package = sort(stringr::str_remove_all(unique(libs), 
                                                     "library|\\(|\\)")),
                   Description = NA)

# If you want to install packages used in this project,
# run the following:
# libs$Package[libs$Package %in% installed.packages() == FALSE]

DT::datatable(libs)
