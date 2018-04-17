library(quantmod)
library(ggplot2)
library(cowplot)
library(dplyr)
library(dygraphs)

start <- as.Date("2017-01-01")
end   <- Sys.Date()

getSymbols("AAPL", src = "yahoo", from = start, to = end)
getSymbols("GOOGL" , src = "yahoo" , from = start , to = end)

Date    <- Date[!(weekdays(Date) %in% c("Saturday","Sunday"))]  #only weekdays
getdata1 <- as.data.frame(AAPL) 
getdata2 <- as.data.frame(GOOGL)

apple <- data.frame(Date = as.Date(rownames(getdata1)), Opening_Rate = getdata1$AAPL.Open , Day_High = getdata1$AAPL.High ,
                     Day_Low = getdata1$AAPL.Low , Closing_Rate = getdata1$AAPL.Close , Volume = getdata1$AAPL.Volume)

google  <- data.frame(Date = as.Date(rownames(getdata2)), Opening_Rate = getdata2$GOOGL.Open , Day_High = getdata2$GOOGL.High ,
                     Day_Low = getdata2$GOOGL.Low , Closing_Rate = getdata2$GOOGL.Close , Volume = getdata2$GOOGL.Volume)


# Plotting

g1 <- ggplot(google, aes(Date)) + geom_line(aes(y = Opening_Rate , colour = "Opening_Rate"),size = 1.2) +
                           geom_line(aes(y = Closing_Rate , colour = "Closing_Rate"), size = 1.2) +
                           xlab("Date") + ylab("Stock Price") + ggtitle("Google Index") +
                           theme(plot.title = element_text(lineheight=.7, face="bold"))+
                           scale_color_manual(name = "Rate" ,values=c("Opening_Rate"="blue", "Closing_Rate"="brown"))

g2 <- ggplot(apple, aes(Date)) + geom_line(aes(y = Opening_Rate , colour = "Opening_Rate"),size = 1.2) +
                                  geom_line(aes(y = Closing_Rate , colour = "Closing_Rate"), size = 1.2) +
                                  xlab("Date") + ylab("Stock Price") + ggtitle("Apple Index") +
                                  theme(plot.title = element_text(lineheight=.7, face="bold"))+
                                  scale_color_manual(name = "Rate" ,values=c("Opening_Rate"="blue", "Closing_Rate"="brown"))

plot_grid(g1, g2, labels= NULL, ncol = 1, nrow = 2)


# PLotting with two different scale
par(mar = c(5,5,2,5))
plot(apple$Closing_Rate,type = 'l',col='red3',ylab = 'Apple Opening Price')
par(new=T)
plot(google$Closing_Rate,type = 'l',col='blue',xlab = NA,ylab = NA,axes = F)
axis(side=4) #pu the axis on right side
mtext(side = 4,line = 3,'Google Opening Price')
legend('topleft',legend = c('Apple','Google'),col=c('red3','blue'),lty = c(1,1),cex = 0.8)

# Interactive Plots

apple_xts_open  <- xts(apple$Opening_Rate, order.by = apple$Date , frequency = 365)
apple_xts_close <- xts(apple$Closing_Rate, order.by = apple$Date , frequency = 365)
plot.xts(apple_xts_open)

stocks <- cbind(apple_xts_open,apple_xts_close)

dygraph(stocks,ylab="Price",
        main="Apple Open and Close Price") %>%
        dySeries("..1",label="Apple Open ") %>%
        dySeries("..2",label="Apple Close") %>%
        dyOptions(colors = c("blue","brown")) %>%
        dyRangeSelector() %>%
    dyOptions(strokeWidth = 3)

mat <- as.matrix(apple[,2:5])
rownames(mat) <- as.character(apple$Date)

dygraph(mat , main = 'Apple Stock' , xlab = 'Date' , ylab = 'Stock Price')  %>%
      dyCandlestick() %>%
      dyRangeSelector()

# Plot Returns
getstocks <- as.xts(data.frame(AAPL[,'AAPL.Close'],GOOGL[,'GOOGL.Close']))
names(getstocks) <- c('Apple','Google')
stock_return <- apply(getstocks,1,function(x) {x/getstocks[1,]}) %>% t %>% as.xts
dygraph(stock_return,ylab='Return',
        main='Stocks Return') %>%
        dySeries("Apple",label='Apple') %>%
        dySeries("Google",label = 'Google') %>%
        dyOptions(colors = c('brown','blue'))
        dyRangeSelector() %>%
        dyOptions(strokeWidth = 3)
#plot.xts(stock_return,ylab='Return',col=c('brown','blue'),legend.loc = 'topleft')
