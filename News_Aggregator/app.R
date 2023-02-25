# Load required packages
library(shiny)
library(dplyr)
library(lubridate)
library(httr)
library(rvest)

# Define UI
ui <- fluidPage(
  titlePanel("Stock News Aggregator"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "ticker",
                  label = "Select Ticker Symbol:",
                  choices = c("AAPL", "GOOGL", "AMZN", "MSFT"),
                  selected = "AAPL"),
      dateRangeInput(inputId = "date_range",
                     label = "Select Date Range:",
                     start = Sys.Date() - 7,
                     end = Sys.Date(),
                     format = "yyyy-mm-dd"),
      actionButton(inputId = "get_news",
                   label = "Get News")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Latest News",
                 tableOutput(outputId = "latest_news"))
      )
    )
  )
)

# Define Server
server <- function(input, output) {
  
  # Function to scrape news articles
  scrape_news <- function(ticker, date_range) {
    url <- paste0("https://www.google.com/search?q=", ticker, "+stock+news&tbm=nws&tbs=cdr:1,cd_min:", date_range[1], ",cd_max:", date_range[2])
    res <- GET(url)
    content <- content(res, "text")
    content <- gsub("\\\\u....", "", content)
    html <- read_html(content)
    titles <- html %>% html_nodes(".BNeawe") %>% html_text()
    links <- html %>% html_nodes(".BNeawe") %>% html_attr("href")
    links <- links[grep("^http", links)]
    data.frame(title = titles, link = links)
  }
  
  # Event to trigger scraping of news articles
  observeEvent(input$get_news, {
    news <- scrape_news(input$ticker, input$date_range)
    output$latest_news <- renderTable({
      news
    })
  })
  
}

# Run the app
shinyApp(ui = ui, server = server)