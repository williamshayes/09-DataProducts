library(shiny)

# Set up the user selectable option ranges
library(ggplot2)
data(diamonds)
cut_opts <- levels(unique(diamonds$cut))
color_opts <- sort(levels(unique(diamonds$color)), decreasing=TRUE)
clarity_opts <- levels(unique(diamonds$clarity))
min_carat <- min(diamonds$carat)
max_carat <- max(diamonds$carat)

shinyUI(fluidPage(

    # Sidebar with controls to provide a caption, select a dataset, and 
    # specify the number of observations to view. Note that changes made
    # to the caption in the textInput control are updated in the output
    # area immediately as you type
    
    # Application title
    titlePanel("Diamond Researcher"),
    
    # Widget input controls for Carat (slider) and 
    #                           Cut, Color and Clarity (Checkboxes)
    
    # Selected 3.0 as the initial upper value for the carat slider because
    # most of the values lie inside min to 2.77 carats.  The value is 
    # arbitrary, just to aid the eye as a start.
    sidebarLayout(
        sidebarPanel(
            sliderInput("carat_vars", "Carat",
                        min = min_carat, 
                        max = max_carat,
                        value=c(min_carat,2.77)),
            checkboxGroupInput('cut_vars', 'Cut',
                               cut_opts, selected = cut_opts),
            checkboxGroupInput('color_vars', 'Color',
                               color_opts, selected = color_opts),
            checkboxGroupInput('clarity_vars', 'Clarity',
                               clarity_opts, selected = clarity_opts)
            
        ),
        
        
        # Show the caption and reactive plot and associated fit line for the
        # subselected data set.
        mainPanel(
            h4("Prepare for Your Engagement Ring Purchase", align="center"),
            p("Select from the left your probable Carat range, Cut, Color
               and Clarity choices to see how it impacts the price for your 
               purchase. Each selector is ordered from least desireable at the
               top to most desireable at the bottom, e.g., for color J is the 
               worst value and D is the best. The server will calculate a data 
               subset, a fit line and the total number of diamonds in your 
               subset as you change your selections from our data set of 50,000+ 
               round cut diamonds. Prices are in US dollars. (Note: Initial plot
               takes a moment to appear.)"),
            h5(textOutput("text_nrow"),align="center"),
            plotOutput("dia_plot")
        )
    )
))