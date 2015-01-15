library(shiny)

shinyUI(pageWithSidebar(
  headerPanel('Régression locale'),
  sidebarPanel(
    #Largeur de l'intervalle
    sliderInput("h", "+/- h : interval width", 
                min = 0.5, max = 10, value = 1, step= 0.2),
    #X0
    sliderInput("x0", "x : point for local reg", 
                min = 0, max = 10, value = 5, step= 2)
  ),
  mainPanel(
    plotOutput('plot1')
  )
))
