
# sækir lykla fyrir px töflur (vonandi)

saekja.lykla <- function(nafn){
  d <- data %>% 
    as_tibble() %>% 
    select(starts_with(nafn)) %>% 
    unique()
  
  names(d) <- c('cd', 'is', 'en')
  d$dalkur <- nafn
  
  return(select(d, dalkur, cd, is, en)) 
}
