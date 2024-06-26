#!/usr/bin/env R
##
## Parses a fa.fai file to generate a fake GTF file
##
## Writes stuff to stdout (line by line)
##
## 20 Feb 2020
## 

suppressPackageStartupMessages({
    library("optparse")
})


option_list = list(
    make_option(c("-f", '--fai'),
                type = 'character', default = NULL,
                help = 'fa fai file'))

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

## print(sprintf('processing GTF %s', opt$gtf))

con <- file(opt$fai, open = "r")

while (TRUE) {
    line <- readLines(con, n = 1)
    if (length(line) == 0) {
        break
    }

    line <- strsplit(line, split = '\t')[[1]]

    ## to add a family instance (that will be encoded within the 'gene' field)    

    ## gsub("(^.*)(_\\w*?)$", "\\1", 'Alusp_eo_bar_baz', perl=TRUE)
    ## gsub("(^.*)(_\\w*?)$", "\\1", 'Alusp-eo', perl=TRUE)
    ## gsub("(^.*)(_\\w*?)$", "\\1", 'Alusp_eo', perl=TRUE)
    family <- gsub("(^.*)(_\\w*?)$", "\\1", line[1], perl = TRUE)
    parsed <- c(line[1], 'repeat', 'exon', "1", line[2], "0.000000", '+', '.', sprintf('gene_id "%s"; transcript_id "%s";', family, line[1]))
    
    cat(sprintf('%s\n', paste(parsed, collapse = '\t')))
}

close(con)

