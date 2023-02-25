# Load required packages
library(shiny)
library(dplyr)
library(lubridate)
library(httr)
library(rvest)
library(openNLP)

tickers = c("AAPL", "GOOGL", "AMZN", "MSFT")
# Define UI
ui <- fluidPage(titlePanel("Stock News Aggregator"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      inputId = "ticker",
                      label = "Select Ticker Symbol:",
                      choices = tickers,
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
    # Remove " - " separator
    title <- gsub(" - ", " ", title)
    # Remove leading/trailing whitespace
    title <- trimws(title)
    # Remove ticker symbol enclosed in parentheses
    title <- gsub(sprintf("\\s*\\(%s:[^\\)]+\\)", input$ticker), "", title)
    # Remove "..." from title
    title <- gsub("\\.\\.\\.", "", title)
    # Return cleaned-up title
    title
  }
  
  
  
  # Function to scrape news articles
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
    print(url)
    # Make the HTTP request and extract the content
    res <- GET(url)
    content <- content(res, "text")
    content <- gsub("\\\\u....", "", content)
    
    # Parse the HTML and extract the titles
    html <- read_html(content)
    titles <- html %>% html_nodes(".BNeawe") %>% html_text() %>% 
      # Clean up titles
      lapply(clean_title) %>% unlist()
    
    # Correct grammar in titles
    sentences <- sentDetect(titles)
    words <- unlist(strsplit(sentences, "\\s+"))
    tagged.words <- tagPOS(words)
    corrected.words <- hunspell_suggest(tagged.words)
    corrected.sentences <- lapply(corrected.words, paste, collapse = " ")
    corrected.titles <- unlist(corrected.sentences)
    
    links <- html %>% html_nodes(".BNeawe") %>% html_attr("href")
    links <- links[grep("^http", links)]
    
    # Combine the titles into a data frame
    data.frame(title = titles, stringsAsFactors = FALSE) %>% 
      # Filter out short titles
      filter(nchar(title) >= 26) %>% 
      # Filter out titles containing "Good Investment"
      filter(!grepl("Good Investment", title)) %>%
      # Filter out titles containing "Good Buy"
      filter(!grepl("Good Buy", title)) %>%
      # Filter out titles containing "Good Buy"
      filter(!grepl("Better Buy", title)) %>%
      # Filter out titles containing "Bull Market"
      filter(!grepl("Bull Market", title)) %>%
      # Filter out titles containing "Nearly"
      filter(!grepl("Nearly", title)) %>%
      # Filter out titles containing "Was Up"
      filter(!grepl("Was Up", title)) %>%
      # Filter out titles containing S&P
      filter(!grepl("S&P", title)) %>% 
      # Remove duplicate titles
      distinct() %>% 
      # Filter out titles that do not start with an uppercase letter
      filter(grepl("^[[:upper:]]", title))
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