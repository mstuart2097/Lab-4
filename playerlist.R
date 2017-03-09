```{r}

  players <- function(letter = "a"){
  url <- paste0("http://www.baseball-reference.com/players/", letter, "/" )
  html <- read_html(url)
  players <- html %>% html_nodes("b a") %>% html_text()
  links <- html %>% html_nodes("b a") %>% html_attr(name="href")
  playerlist <- data.frame(players=players, links = links)
  return(playerlist)
}

```
