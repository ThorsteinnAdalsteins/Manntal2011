


rm(list = ls())
## nota pxweb_interactive til þess að búa til fyrirspurn.
## geymi json hlutann í _JsonQuery
source('./R_Sources/__init__.R')
# pxweb::pxweb_interactive()

## Húsnæði tafla 2
tafla_id <- 'CEN04530'

## undirbúningur fyrir íslensku útgáfuna:
url.is <- "http://px.hagstofa.is/pxis/api/v1/is/Ibuar/manntal/4manntalhusn/CEN04530.px"
json.is <- './_JsonQueries/CEN04530.is.json'
if(!file.exists(json.is)){stop('Fann ekki json skránna')}

## undirbúningur fyrir ensku útgáfuna:
url.en <- "http://px.hagstofa.is/pxen/api/v1/en/Ibuar/manntal/4manntalhusn/CEN04530.px"
json.en <- './_JsonQueries/CEN04530.en.json'
if(!file.exists(json.en)){stop('Fann ekki json skránna')}

# sæki gögnin
px_data.is <- pxweb_get(url = url.is, query = json.is)
px_data.en <- pxweb_get(url = url.en, query = json.en)

# dreg út gögnin 
data.cd <- as.data.frame(
  px_data.is, 
  column.name.type = "code", 
  variable.value.type = "code", 
  stringsAsFactors = FALSE)

data.is <- as.data.frame(
  px_data.is, 
  column.name.type = "text", 
  variable.value.type = "text",
  stringsAsFactors = FALSE)

data.en <- data.is.text <- as.data.frame(
  px_data.en, 
  column.name.type = "text", 
  variable.value.type = "text",
  stringsAsFactors = FALSE)

## #########################################################################
##  stop-point 2
## #########################################################################
## byrja að laga gögnin til og setja upp tengitöflur
# fyrst tafla með kortlagningu fyrir dálkanöfn
names(data.cd)

dalkar.meta <- tibble(
  dalkanofn_cd = c('byggingagerd', 'nyting_ibuda', 'byggingartimi', paste(tafla_id, 'gildi', sep ='_')),
  dalkanofn_is = names(data.is),
  dalkanofn_en = names(data.en)
)
# set dálkanöfnin í einfaldað form
names(data.cd) <- dalkar.meta$dalkanofn_cd
names(data.cd)[-length(names(data.cd))] <- paste(names(data.cd)[-length(names(data.cd))], 'cd', sep = '_')

names(data.is) <- dalkar.meta$dalkanofn_cd
names(data.is)[-length(names(data.is))] <- paste(names(data.is)[-length(names(data.is))], 'is', sep = '_')

names(data.en) <- dalkar.meta$dalkanofn_cd
names(data.en)[-length(names(data.en))] <- paste(names(data.en)[-length(names(data.en))], 'en', sep = '_')

# tek út lykla
dalkar.meta$dalkanofn_cd


data <- cbind(data.cd %>% select(-ends_with('gildi')),
              data.is %>% select(-ends_with('gildi')),
              data.en %>% select(-ends_with('gildi')))

data <- data %>% as_tibble() %>% unique()

# hér nota ég saekja.lykla() fallið sem er í R_Source
lyklar <- lapply(dalkar.meta$dalkanofn_cd[-length(dalkar.meta$dalkanofn_cd)], saekja.lykla)
dalkar.lyklar <- do.call(rbind, lyklar)

## töflurnar sem við höfum áhuga á eru

data.cd %>% as_tibble()
dalkar.meta %>% as_tibble()
dalkar.lyklar %>% as_tibble()


## set upp rétt heiti á skrám
csv.data <- tafla_id %>% str_c('gogn', sep ='_') %>% str_c('csv', sep = '.')
csv.meta <- tafla_id %>% str_c('dalkar', sep ='_') %>% str_c('csv', sep = '.')
csv.lyklar <- tafla_id %>% str_c('dalka_lyklar', sep ='_') %>% str_c('csv', sep = '.')


write.table(x = data.cd, file = paste0('./_GognUt/', csv.data), row.names = FALSE, na = 'NULL', fileEncoding = 'UTF-8')
write.table(x = dalkar.meta, file = paste0('./_GognUt/', csv.meta), row.names = FALSE, na = 'NULL', fileEncoding = 'UTF-8')
write.table(x = dalkar.lyklar, file = paste0('./_GognUt/', csv.lyklar), row.names = FALSE, na = 'NULL', fileEncoding = 'UTF-8')
