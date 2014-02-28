#contig-550123   991     0.406659939455096       23500   21150
#contig-4870773  94      0.414893617021277       94      0
#contig-4806892  475     0.292631578947368       7332    1880
#contig-841945   119     0.336134453781513       2162    1786
#contig-3754387  103     0.407766990291262       846     470
#contig-5703828  252     0.428571428571429       3478    658

data <- read.table("attr.tab.dp")
library("ggplot2")
png("cvg-1.png")
qplot(data[,2], data[,3], xlab="Sequence Length",ylab="GC",ylim=c(0,1))
png("cvg-2.png")
qplot(data[,2], data[,4]/data[,2], xlab="Sequence Length",ylab="Sequence Depth(X)",ylim=c(0,100))
png("cvg-3.png")
qplot(data[,2], (data[,4]+data[,5])/data[,2], xlab="Sequence Length",ylab="Sequence Depth(X)",ylim=c(0,100))
png("cvg-4.png")
qplot(data[,3], data[,4]/data[,2], xlab="GC",ylab="Sequence Depth(X)",ylim=c(0,100))
png("cvg-5.png")
qplot(data[,3], (data[,4]+data[,5])/data[,2], xlab="GC",ylab="Sequence Depth(X)",ylim=c(0,100))
#points(data[,1][y < 40],data[,2][y < 40], col = "blue")
#points(data[,1][y >= 40],data[,2][y >= 40], col = "red" , pch = 19)
dev.off()
