# initial setup and import

setwd("/home/dale/Documents/seriousevents")
se <- read.csv("seriousevents.csv", stringsAsFactors=FALSE)
se$desc <- NULL
se$name <- NULL

se$start <- as.Date(se$start)
se$end   <- as.Date(se$end)

se$cost <- as.numeric(gsub("[^.0-9]", "", se$cost))

se <- se[order(se$start),]

# plot setup
png(filename="us_serious_events_1980-2017.png",
    width=580, height=460)

  # layout
layout(matrix(1:2), heights=c(6,5))

  # main bar/segment plot

oldpar <- par(mar=c(0,4,2,2)+0.1)

plot(se$start, se$cost,
     xlim=c(as.Date("1980-01-01"), as.Date("2018-01-01") ),
     ylim=c(0,170), axes=FALSE, ann=FALSE, bty="n", type="n",
     xaxs="i", yaxs="i")

axis(2, at=axTicks(2), cex.axis=0.9, lwd=0, lwd.tick=1, las=1, col="#cccccc", col.axis="#666666")

palette(c("red","#666666"))

abline(h=axTicks(2)[-1], lty=3, col="#cccccc")

segments(se$start, 0, se$start, se$cost,
         col=ifelse(se$type == "cyclone", 1, 2),
         lwd=2, lend=1)

with(
    se[se$shortname=="Katrina",],
    text(start, cost, shortname, pos=4, col="#666666", cex=0.9)
)

box(col="#cccccc")

title(main="Costs of Natural Disasters (CPI Adjusted)",
      ylab="$B", cex.lab=1, cex.main=1, font.lab=2, col.lab="#666666", col.main="#666666")

legend("topleft",
       lwd=2,
       col=1:2,
       legend=c("Cyclone","Other"),
       cex=0.9,
       bg="white",
       box.col="#cccccc",
       text.col="#666666"
       )

oldpar

  # cumulative plot

oldpar <- par(mar=c(4,4,1,2)+0.1)

plot(se$start, se$cost,
     xlim=c(as.Date("1980-01-01"), as.Date("2018-01-01") ),
     ylim=c(0,800), axes=FALSE, ann=FALSE, bty="n", type="n",
     xaxs="i", yaxs="i")

axis.Date(
    1,
    at=seq.Date(
        as.Date("1980-01-01"), as.Date("2018-01-01"), by="12 months"),
    lwd=0, lwd.tick=1, col="#cccccc", col.axis="#666666", las=2, cex.axis=0.9
    )

axis(2, at=seq(0,800,200), cex.axis=0.9, lwd=0, lwd.tick=1, las=1, col="#cccccc", col.axis="#666666")

abline(h=axTicks(2)[-1], lty=3, col="#cccccc")

box(col="#cccccc")

lines(se$start, cumsum(replace(se$cost, se$type!="cyclone", 0)), col=1)
lines(se$start, cumsum(replace(se$cost, se$type=="cyclone", 0)), col=2)

title(xlab="Year", ylab="Cumulative $B",
      font.lab=2, col.lab="#666666")

oldpar

## close device
dev.off()
