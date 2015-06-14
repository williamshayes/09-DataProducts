library(shiny)
library(datasets)
library(ggplot2)
library(dplyr)

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
    
    # By declaring datasetInput as a reactive expression we ensure that:
    #
    #  1) It is only called when the inputs it depends on changes
    #  2) The computation and result are shared by all the callers (it 
    #     only executes a single time)
    
    # DATA
    # Perform calculations to subset the diamonds data set by the cut, color 
    # and clarity options selected on the UI.
    data.r <- reactive({
        data_sub <- diamonds %>% filter(cut %in% input$cut_vars) %>%
                                 filter(color %in% input$color_vars) %>%
                                 filter(clarity %in% input$clarity_vars) %>%
                                 filter(carat >= input$carat_vars[1] &
                                        carat <= input$carat_vars[2])
        return(data_sub)
    })

    # Row Count
    output$text_nrow <- renderText({ 
        paste("Number of diamonds selected: ", nrow(data.r()),
              ifelse(nrow(data.r())==0,
                     " [NO DIAMONDS SELECTED, PLEASE INCREASE CHOICES ON LEFT]",
                     " ")
             )
    })
    
    # PLOT
    # Plot the subseted data based on user calculations and add an
    # indicative fit line ("smooth") to let the user know what the 
    # relationship is.
    output$dia_plot = renderPlot({
        
        s <- qplot(carat, price, data = data.r(), 
                   geom = c("point", "smooth"), group=1,
                   shape=cut, color=color, size=clarity,
                   method = "gam", formula = y ~ s(x, bs = "cs")) +
                   theme_bw() + theme(legend.position = "bottom")
    
        print(s)
    })
})