library(tidyverse);library(rvest)

sotu_tab_page <- read_html("./data/text_extract/sotu_table.html")         

links <- sotu_tab_page %>%                                                 
  html_nodes("a") %>%                                                      
  html_attr("href") %>%                                                    
  .[which(str_detect(., "pid\\=[0-9]{4}"))]                                

lapply(links, function(x) {                                     
  
  cat(sprintf("%.1f", 100 * (which(links == x) / length(links))), "% \r")
  
  file_x <- str_c("data/text_extract/sotu/", str_extract(x, "[0-9]+$"), ".html")
  
  if(file.exists(file_x)) return(NULL)
  
  download.file(x, destfile = str_c("data/text_extract/sotu/",             
                                    str_extract(x, "[0-9]+$"),             
                                    ".html"), quiet = TRUE)                
  
  Sys.sleep(2 + abs(rnorm(1)))                                             
  
})