library(rvest)
library(tidyverse)


players <- function(letter = "a"){
  url <- paste0("http://www.baseball-reference.com/players/", letter, "/" )
  html <- read_html(url)
  players <- html %>% html_nodes("b a") %>% html_text()
  links <- html %>% html_nodes("b a") %>% html_attr(name="href")
  playerlist <- data.frame(players=players, links = links)
  return(playerlist)
}

getStats <- function(link) {
  s <- html_session("http://www.baseball-reference.com")
  s <- s %>% jump_to(link)
  html <- read_html(s)
  type <- html %>% html_nodes(".stats_pullout .poptip") %>% html_text() 
  values <- html %>% html_nodes(".stats_pullout .p1 p, .stats_pullout .p2 p, .stats_pullout .p3 p") %>% html_text()
  what <- html %>% html_nodes(".stats_pullout strong") %>% html_text()
  position<-html %>% html_nodes("#meta p:nth-child(2)") %>% html_text()
  position<-gsub("[[:space:]]","",position)
  position<-gsub("Position\\:","",position)
  df <- data.frame(type=rep(type, each=length(what)), values=values, what = rep(what, length(values)), 
                   position=rep(position, length(values)))
}


favorite_letter<-"a"
plist<-players(letter=favorite_letter)

p_data <- plist[1:10,] %>% mutate(career = links %>% purrr::map(getStats))
