#=============================================================================
#     FileName: plot.R
#         Desc: 
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2014-03-20 14:35:48
#      History:
#=============================================================================
barplot_with_pareto <- function(x,main = "",r=100,s=5) {
	op <- par(mar = c(5, 4, 4, 5) + 0.1, las = 2)
	
	bw <- seq(0, r, s)
	r1 <- hist(x,breaks=bw,plot=FALSE)
	r1
	x  <- r1$counts
	y  <- cumsum(x)/sum(x)

	barplot(x, xlab="Indentity(%)", ylab="Counts",main=main, col="pink")
	axis(2)
	xn <- paste(seq(0,r-s,s), seq(s,r,s), sep="--")
	names(x) <- xn 

	par(new = T)
	plot(y, type="l", col="blue", axes=FALSE,xlab='', ylab='', main='')
	axis(4)
	par(las=0)
	mtext("Cumulated frequency", side=4, line=3)
	
	axis(1, at=1:length(x), labels=names(x))
	par(op)
}

data <- read.table("rate.tab.best")
pdf("out2.pdf")
#bw <- seq(0,100,5)
#r1 <- hist(data[,1],breaks=bw,plot=FALSE)
#plot(bw,r1$counts,xlab="Indentity(%)",ylab="Counts(%)",type="l",lty=1,col="blue")
barplot_with_pareto(data[,1],main="Indentity Counts")
#r2 <- hist(data[,2],breaks=bw,plot=FALSE)
#r3 <- hist(data[,4],breaks=bw,plot=FALSE)
barplot_with_pareto(data[,2],main="Query Coverage Counts")
barplot_with_pareto(data[,3],main="Query Aln rate Counts")
barplot_with_pareto(data[,4],main="Target Coverage Counts")
barplot_with_pareto(data[,4],main="Target Aln rate Counts")

plot(data[,1], data[,2], xlim=c(0,100), ylim=c(0,100), 
	main="Indentity vs Query Coverage", 
	xlab="Indentity",
    ylab="Query Coverage")

plot(data[,1], data[,3], xlim=c(0,100), ylim=c(0,100), 
	main="Indentity vs Query Aln rate", 
	xlab="Indentity",
    ylab="Query Aln rate")

plot(data[,1], data[,4], xlim=c(0,100), ylim=c(0,100), 
	main="Indentity vs Target Coverage", 
	xlab="Indentity",
    ylab="Target Coverage")

plot(data[,1], data[,5], xlim=c(0,100), ylim=c(0,100), 
	main="Indentity vs Target Aln rate", 
	xlab="Indentity",
    ylab="Target Aln rate")

plot(data[,2], data[,4], xlim=c(0,100), ylim=c(0,100), 
	main="Query Coverage vs Target Coverage", 
	xlab="Query Coverage",
    ylab="Target Coverage")


plot(data[,2], data[,3], xlim=c(0,100), ylim=c(0,100), 
	main="Query Coverage vs Query aln rate", 
	xlab="Query Coverage",
    ylab="Query aln rate")


plot(data[,4], data[,5], xlim=c(0,100), ylim=c(0,100), 
	main="Target Coverage vs Target Aln rate", 
	xlab="Target Coverage",
    ylab="Target Aln rate")


barplot_with_pareto(data[,1]*data[,2]/10000,
	main="Indentity Counts Adjust by Query Coverage",r=1,s=0.05)

barplot_with_pareto(data[,1]*data[,3]/10000,
	main="Indentity Counts Adjust by Query Aln rate",r=1,s=0.05)

barplot_with_pareto(data[,1]*data[,4]/10000,
	main="Indentity Counts Adjust by Target Coverage",r=1,s=0.05)

barplot_with_pareto(data[,1]*data[,5]/10000,
	main="Indentity Counts Adjust by Target Aln rate",r=1,s=0.05)


dev.off()

#*************  Float like a butterfly! Stay like a buttonwood!  *************

