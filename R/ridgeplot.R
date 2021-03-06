## ##' ridgeplot for GSEA result
## ##'
## ##'
## ##' @title ridgeplot
## ##' @param x gseaResult object
## ##' @param showCategory number of categories for plotting
## ##' @param fill one of "pvalue", "p.adjust", "qvalue"
## ##' @param core_enrichment whether only using core_enriched genes
## ##' @return ggplot object
## ##' @importFrom ggplot2 scale_fill_gradientn
## ##' @importFrom rvcheck get_fun_from_pkg
## ##' @export
## ##' @author guangchuang yu
## ridgeplot <- function(x, showCategory=30, fill="p.adjust", core_enrichment = TRUE) {
##     if (!is(x, "gseaResult"))
##         stop("currently only support gseaResult")

##     ## fill <- match.arg(fill, c("pvalue", "p.adjust", "qvalue"))
##     if (fill == "qvalue") {
##         fill <- "qvalues"
##     }
##     if (!fill %in% colnames(x@result)) {
##         stop("'fill' variable not available ...")
##     }

##     geom_density_ridges <- get_fun_from_pkg('ggridges', 'geom_density_ridges')

##     n <- showCategory
##     if (core_enrichment) {
##         gs2id <- geneInCategory(x)[1:n]
##     } else {
##         gs2id <- x@geneSets[x$ID[1:n]]
##     }

##     gs2val <- lapply(gs2id, function(id) {
##         res <- x@geneList[id]
##         res <- res[!is.na(res)]
##     })

##     nn <- names(gs2val)
##     i <- match(nn, x$ID)
##     nn <- x$Description[i]

##     j <- order(x$NES[i], decreasing=F)

##     len <- sapply(gs2val, length)
##     gs2val.df <- data.frame(category = rep(nn, times=len),
##                             color = rep(x[i, fill], times=len),
##                             value = unlist(gs2val))

##     colnames(gs2val.df)[2] <- fill
##     gs2val.df$category <- factor(gs2val.df$category, levels=nn[j])

##     ggplot(gs2val.df, aes_string(x="value", y="category", fill=fill)) + geom_density_ridges() +
##         ## geom_vline(xintercept=0, color='firebrick', linetype='dashed') +
##         xlab(NULL) + ylab(NULL) + scale_fill_gradientn(colors=heatmap_palette) + theme_dose()
## }


## heatmap_palette <- palette <- colorRampPalette(c("red", "yellow", "green"))(n = 299)
