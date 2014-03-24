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

data <- read.table("rate.tab")
pdf("out.pdf")
hist(data[,1])
hist(data[,2])
hist(data[,3])
hist(data[,4])
hist(data[,5])
dev.off()

#*************  Float like a butterfly! Stay like a buttonwood!  *************

