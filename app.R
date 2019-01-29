library(shiny)

barChartOutput <- function(id, color_left="#fc4c02", color_right = "rgb(54, 72, 140)", height="2em") {
  HTML(
    glue::glue(
      '<div id="{id}" class="stravachaser barchart">
<div class="leftwrapper">
       <div id="{id}-left" data-width="0.01" class="leftelem" data-text=" " data-height="{height}" data-direction="right" data-background="{color_left}"></div>
</div><div class="rightwrapper">
        <div id="{id}-right" data-width="0.01" class="rightelem" data-height="{height}" data-direction="left" data-text=" " data-background="{color_right}"></div>
      </div></div>
      <script>
      $("#{id}-left").simpleSkillbar({{width:0}});
$("#{id}-right").simpleSkillbar({{width:0}});
</script>
      '
    )
    
    )#HTML
  
  
}

renderBarChart <- function(expr, env=parent.frame(), quoted=FALSE) {
  # This piece of boilerplate converts the expression `expr` into a
  # function called `func`. It's needed for the RStudio IDE's built-in
  # debugger to work properly on the expression.
  
  func <- exprToFunction(expr, env, quoted)
  
  function() {
    data = func();
  }
}

ui <- fluidPage(theme = "simple-skillbar.css",
  tags$script(src="barchart-binding.js"),
  tags$script(src="simple-skillbar.js"),
  barChartOutput(id="one",height="3em",color_right = "black"),
  actionButton("test",labe="TEST double chart"),
  barChartOutput(id="two",height="3em"),
  
  actionButton("test2",labe="TEST single chart")
)
  
server <- function(input,output){
  
  observeEvent({
    input$test
  },{output$one <- renderBarChart({
    jsonlite::toJSON(list(left=c(50,100), right=c(20,30), unit="km",label=c("a","b")))
  })
  })
  observeEvent({
    input$test2
  },{output$two <- renderBarChart({
    jsonlite::toJSON(list(left=c(50), right=c(20), unit="km",label=c("a")))
  })
  })
    
    
}

shinyApp(ui = ui, server=server)