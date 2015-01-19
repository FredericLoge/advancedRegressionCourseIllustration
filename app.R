#install.packages("shiny")
#library(shiny)

#
# Partie interface
#

ui = shinyUI(pageWithSidebar(

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

#
# Partie serveur
#

server = shinyServer(function(input, output, session) {
  
  #Création des données montrées.
  donnees <- reactive({
    x = (runif(n=100, 0, 10)) 
    cbind.data.frame("x"=x, "y"=(x^2 + rnorm(n=100, 0, 1)))
  })
  
  #Exécution de la régression sur les données.
  regression <- reactive({
    lm(y~x, donnees())
  })
  
  #Exécution de la régression locale.
  regressionLocale <- reactive({
    data = donnees()
    data = data[abs(data$x-input$x0)<input$h, ]
    lm(y~x, data)
  })
  
  
  output$plot1 <- renderPlot({
    
    #Création du graphique.
    par(mar = c(5.1, 4.1, 0, 1))
    plot(donnees()$x, donnees()$y,
         col = "blue", pch = 20, cex = 1)

    #Ajout de la ligne verticale x = x0
    abline(v=input$x0, col="cyan")
    
    #Coloration de la zone où les données sont prises en compte
    #pour exécuter la régression locale
    v1 = input$x0 + c(-input$h, input$h)
    v2 = rep(max(donnees()$y),2)
    v3 = rep(min(donnees()$y),2)
    polygon(c(v1, rev(v1)), c(v2, rev(v3)),
            col = rgb(0.2, 0.1, 0.1,0.1) , border = NA)
        
    #Ajout des droites de régression. 
    abline(regression()$coeff[[1]], regression()$coeff[[2]], lwd=2, col="orange")
    abline(regressionLocale()$coeff[[1]], regressionLocale()$coeff[[2]], lwd=2, col="red")
    
  })
  
})

shinyApp(ui=ui, server=server)
