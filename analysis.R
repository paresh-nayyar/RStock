library(quantmod)

start <- as.Date("2017-01-01")
end   <- as.Date("2017-04-23")

#xts objects (provided in the xts package) are seen as improved versions of the ts object
#for storing time series data.
getSymbols("AAPL", src = "google", from = start, to = end)
getSymbols("GOOGL" , src = "google" , from = start , to = end)

par(mfrow=c(2,1))
plot(AAPL[,"AAPL.Open"],main = "AAPL Open")
plot(AAPL[,"AAPL.High"],main = "AAPL High")
plot(AAPL[,"AAPL.Low"],main = "AAPL Low")
plot(AAPL[,"AAPL.Close"],main = "AAPL Close")
plot(AAPL[,"AAPL.Volume"],main = "Volume Traded Apple")
candleChart(AAPL, up.col = "black", dn.col = "red", theme = "white")

plot(GOOGL[,"GOOGL.Open"],main = "GOOGL Open")
plot(GOOGL[,"GOOGL.High"],main = "GOOGL High")
plot(GOOGL[,"GOOGL.Low"],main = "GOOGL Low")
plot(GOOGL[,"GOOGL.Close"],main = "GOOGL Close")
plot(GOOGL[,"GOOGL.Volume"],main = "Volume Traded Google")
candleChart(GOOGL, up.col = "black", dn.col = "red", theme = "white")

