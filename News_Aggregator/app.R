# Load required packages
library(shiny)
library(dplyr)
library(lubridate)
library(httr)
library(rvest)

# Define UI
ui <- fluidPage(titlePanel("Stock News Aggregator"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      inputId = "ticker",
                      label = "Select Ticker Symbol:",
                      choices = c("AAPL", "GOOGL", "AMZN", "MSFT"),
                      selected = "AAPL"
                    ),
                    dateRangeInput(
                      inputId = "date_range",
                      label = "Select Date Range:",
                      start = Sys.Date() - 7,
                      end = Sys.Date(),
                      format = "yyyy-mm-dd"
                    ),
                    actionButton(inputId = "get_news",
                                 label = "Get News")
                  ),
                  mainPanel(tabsetPanel(tabPanel(
                    "Latest News",
                    tableOutput(outputId = "latest_news")
                  )))
                ))


  
# Define Server
server <- function(input, output) {
  
  # Function to clean up news article titles
  clean_title <- function(title) {
    # Remove stock symbol from title
    #title <- gsub("\\b[A-Z]+\\b", "", title)
    # Remove " - " separator
    #title <- gsub(" - ", " ", title)
    # Remove " , " separator
    #title <- gsub(" , ", " ", title)
    # Remove " . " separator
    #title <- gsub(" . ", " ", title)
    # Remove " ... " separator
    #title <- gsub(" ... ", " ", title)
    # Remove " () " separator
    #title <- gsub(" () ", "", title)
    # Remove " ) " separator
    #title <- gsub(" ) ", "", title)
    # Remove " [video] " separator
    #title <- gsub(" [video] ", " ", title)
    # Remove leading/trailing whitespace
    title <- trimws(title)
    # Return cleaned-up title
    title
  }
  
  # Function to scrape news articles
  scrape_news <- function(ticker, date_range) {
    # Construct the URL
    url <- paste0(
      "https://www.google.com/search?q=",
      ticker,
      "+stock+news&tbm=nws&tbs=cdr:1,cd_min:",
      date_range[1],
      ",cd_max:",
      date_range[2]
    )
    
    # Make the HTTP request and extract the content
    res <- GET(url)
    content <- content(res, "text")
    content <- gsub("\\\\u....", "", content)
    
    # Parse the HTML and extract the titles
    html <- read_html(content)
    titles <- html %>% html_nodes(".BNeawe") %>% html_text() %>% 
      # Clean up titles
      lapply(clean_title) %>% unlist()
    
    # Combine the titles into a data frame
    data.frame(title = titles, stringsAsFactors = FALSE) %>% 
      distinct()
  }
  
  # Reactive expression to get the latest news for the selected ticker and date range
  latest_news <- reactive({
    scrape_news(input$ticker, input$date_range)
  })
  
  # Output the latest news as a table
  output$latest_news <- renderTable({
    latest_news()
  })
  
}

# Run the app
shinyApp(ui = ui, server = server)