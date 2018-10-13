########################## LOADING LIBRARIES #######################

library(shinythemes)
library(shiny)
library(png)
library(shinydashboard)
library(dplyr)
library(caret)
library(e1071)

#install.packages('shinydashboard')

#install.packages('caret')
########################### READING DATA ###########################

FraudData<-read.csv('C:\\Users\\dee Jay\\Downloads\\Deepika.csv',header=T,row.names=NULL)

FraudData$isFraud<-as.factor(FraudData$isFraud)
library(caret)
set.seed(123)
sample <- sample.int(n = nrow(FraudData), size = floor(.75*nrow(FraudData)), replace = F)
train <- FraudData[sample, ]
glmfit<-train(isFraud~.,data=train, method='glm')

########################### RSHINY APP #############################

ui<-fluidPage(
  titlePanel(column(12, offset = 5, tags$img(src = "imdb2.png", width =200))),
  column(6, offset = 3 , tags$hr(style="border: solid 1.5px gold")),
  tags$head(
    tags$style(HTML("body{
                    background-image: url(https://images.pexels.com/photos/147635/pexels-photo-147635.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260);
                    }"))),
  fluidRow(column(width = 4, offset = 0, 
                  wellPanel(top = 75, style="border: solid 2px green;background-color:maroon",
                            sliderInput("srcobal",
                                        h2("Old Balance at Origin :", 
                                           style = "color:gold;font-family:Courier;text-align:left",
                                           icon("usd",class="fa-align-right fa-3x")), 
                                        value=20000,min=0,max=100000,step=1000),
                            sliderInput("Amount",
                                        h2("Transaction AMount :", 
                                           style = "color:gold;font-family:Courier;text-align:left",
                                           icon("usd",class="fa-align-right fa-3x")), 
                                        value=20000,min=0,max=1000000,step=1000),
                            selectizeInput("type",
                                           h2("Transaction Type", 
                                              style = "color:gold;font-family:Courier;text-align:center",
                                              icon("list-ol",class="fa-align-right fa-3x")),
                                           c("CASH_IN", "CASH_OUT", "TRANSFER", "DEBIT",
                                             "PAYMENT"),
                                           c("Crime","Drama"),
                                           multiple = FALSE),
                            
                            #          textInput("amount", "Enter Amount:", "Enter Amount",
                            #       style = "color:gold;font-family:Courier;text-align:left",
                            #                    icon("robber",class="fa-align-right fa-3x")),
                            #          verbatimTextOutput("value"),
                            numericInput("time",
                                         h2("Transaction Time:", 
                                            style = "color:gold;font-family:Courier;text-align:left",
                                            icon("hourglass",class="fa-align-right fa-3x")), 
                                         value=1,min=1,max=12)
                            #   sliderInput("amount",
                            #              h2("Transaction Amount", 
                            #               style = "color:gold;font-family:Courier;text-align:left",
                            #                icon("robber",class="fa-align-right fa-3x")), 
                            #           value=208,min=1,max=1000,step=50),
                            
                            
                            
                            
                            
                  )), 
           column(width = 5, offset=3,
                  wellPanel(style="border: solid 2px green;background-color: maroon",
                            sliderInput("destobal",
                                        h2("Old Balance at Destination :", 
                                           style = "color:gold;font-family:Courier;text-align:left",
                                           icon("usd",class="fa-align-right fa-3x")), 
                                        value=20000,min=0,max=100000,step=1000),
                            sliderInput("destnbal",
                                        h2("New Balance at Destination :", 
                                           style = "color:gold;font-family:Courier;text-align:left",
                                           icon("usd",class="fa-align-right fa-3x")), 
                                        value=20000,min=0,max=100000,step=1000),
                            
                            dateInput('date',h2("Transaction Date", 
                                                style = "color:gold;font-family:Courier;text-align:left",
                                                icon("time",class="fa-align-right fa-3x")), 
                                      
                                      value = as.character(Sys.Date()),
                                      min = Sys.Date() - 5, max = Sys.Date() + 5,
                                      format = "dd/mm/yy",
                                      startview = 'year', language = 'zh-TW', weekstart = 1
                            ),
                            
                            #          textInput("amount", "Enter Amount:", "Enter Amount",
                            #       style = "color:gold;font-family:Courier;text-align:left",
                            #                    icon("robber",class="fa-align-right fa-3x")),
                            #          verbatimTextOutput("value"),
                            
                            radioButtons('timem', h2("When ? AM/PM", 
                                                     style = "color:gold;font-family:Courier;text-align:center",
                                                     icon("hourglass",class="fa-align-right fa-3x")),
                                         choiceNames= list(
                                           HTML("<p style='color:gold;'>AM</p>"),
                                           HTML("<p style='color:gold;'>PM</p>") 
                                         ), inline = TRUE, selected = 0,
                                         choiceValues= list(0,1)
                            )
                            
                            
                            
                            
                  ))),
  column(4, offset=4, 
         wellPanel(style="border: solid 2px green;background-color:black",
                   actionButton("go", "Calculate Risk!", 
                                style="display:inline-block;width:100%;text-align: center; font-size: 25px;background-color:red",
                                icon = icon("exclamation-sign",lib="glyphicon")),
                   h2("The Fraud Detector", style="color:gold;text-align:center"),
                   verbatimTextOutput("value")
         )))

server<-function(input,output){
  data_ref=as.Date("2018-10-01")
  srcobal_<-reactive(
    input$srcobal)
  add_<-reactive(ifelse(input$timem==0,0,1))
  time_<-reactive(input$time+add_*12)
  # srcnbal_<-reactive(input$srcnbal)
  type_<-reactive(input$type)
  amount_<-reactive(input$Amount)
  date_<-reactive(as.Date(input$date)-data_ref)
  time_<-reactive((input$time))
  destobal_<-reactive(input$destobal)
  destnbal_<-reactive(input$destnbal)
  
  
  
  output$value <- renderText({
    if (input$go > 0){
      # paste(input$type)
      pred <- predict(glmfit,
                      newdata <- data.frame(isFraud=0,#as.numeric(date_())*24+as.numeric(time_()),
                                            type=type_(),
                                            amount=amount_(),
                                            oldbalanceOrg=srcobal_(),
                                            newbalanceOrig=srcobal_()-amount_(),
                                            
                                            #as.numeric(time_()),
                                            oldbalanceDest=destobal_(),
                                            newbalanceDest=destnbal_(),
                                            Day
                                            =as.numeric(date_()),
                                            TimeOfDay=time_()),
                      
                      
                      interval="predict")
      
      a<-ifelse(pred==0,"This Transaction is not Fraud\n You can go ahead with it!","This Transaction is Fraud\nDon't proceed ahead with it!")
      paste(a)
      
    }}
  )}
shinyApp(ui=ui,server=server)

####################### THE END #############################