library(shiny)
library(ggplot2)
library(scales)  # for comma formatting

# Sample data (replace with your actual data)
cleaned_df <- data.frame(
  starting_hour = rep(1:24, each = 7),
  day_of_week = rep(rep(1:7, each = 24), times = 2),
  member_casual = rep(c("Member", "Casual"), each = 7 * 24),
  rides = rpois(7 * 24 * 2, lambda = 10)
)
cleaned_df$day_of_week <- factor(cleaned_df$day_of_week, levels = 1:7, labels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Convert member_casual to a factor
cleaned_df$member_casual <- factor(cleaned_df$member_casual)

top_10_station_member <- data.frame(
  stations = paste("Station", 1:10),
  station_count = sample(50:200, 10)
)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .bullet-points {
        margin-top: -10px; 
        margin-bottom: 20px;
      }
    "))
  ),
  titlePanel(h3("Case Study-How does a bike-share navigate speedy success?", align = "center", style = "font-weight:bold;")),
  fluidRow(
    column(width = 6,
           h4("Hourly Use of Bikes Throughout the Week", align = "center"),
           plotOutput("bikePlot", height = 300, width = 550)
    ),
    column(width = 6,
           h4("Top 10 Used Stations by Members", align = "center"),
           plotOutput("stationPlot", height = 300, width = 550)
    )
  ),
  fluidRow(
    column(width = 6,
           h4("Number of Rides per Hour", align = "center"),
           plotOutput("additionalPlot", height = 300, width = 450)
    ),
    column(width = 6,
           h4("Additional Observations", align = "center"),
           h5("Observations : ", align = "left"),
           HTML("<ul>
                  <li>Casual riders ride more during the weekend.</li>
                  <li>Both casual and members prefer classic bikes while docked bikes not being used by casual.</li>
                  <li>Casual riders who ride for a long duration.</li>
                  <li>Most trips occur in summer times (July - August) for both casual and member.</li>
                </ul>"),
           h5("Recommendations : ", align = "left"),
           HTML("<ul>
                  <li>Offering incentives or offers to the most rides members and announcing them by placing banners in the locations of the most frequently used stations by casual riders to attract them.</li>
                  <li>Offering discounts on holidays or the most frequently used July-August months is (summer offers)</li>
                </ul>")
  )
  )
)

server <- function(input, output) {
  output$bikePlot <- renderPlot({
    ggplot(data = cleaned_df) +
      aes(x = starting_hour, fill = member_casual) +
      facet_wrap(~day_of_week) +
      geom_bar() +
      labs(x = 'Starting hour', y = 'Number of rides', fill = 'Member type') +
      theme(axis.text = element_text(size = 5))
  })
  
  output$stationPlot <- renderPlot({
    ggplot(data = top_10_station_member) +
      geom_col(aes(x = reorder(stations, station_count), y = station_count), fill = '#56B4E9') +
      labs(y = "Number of Rides", x = "") +
      scale_y_continuous(labels = comma) +
      coord_flip() +
      theme_minimal()
  })
  
  output$additionalPlot <- renderPlot({
    ggplot(data = cleaned_df, aes(x = day_of_week, y = rides, fill = member_casual)) +
      stat_summary(fun = "mean", geom = "bar", position = "dodge") +
      labs(x = 'Day of week', y = 'Mean number of rides', fill = 'Member type', title = 'Bar graph of mean rides by day of week and member type') +
      theme_minimal()
  })
  
}

shinyApp(ui, server)
