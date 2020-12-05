library(knitr)
# if RWordPress isn't installed, uncomment and run the next two lines once
# library(devtools)
# devtools::install_github(c("duncantl/XMLRPC", "duncantl/RWordPress"))
library(keyring)

# you must use keyring::key_set() to set the below-referenced keys first
# they are specific to your own WordPress install
# example: keyring::key_set("WordPress publisher", "password")
# Also, due to a limitation in how R's options work, the key name cannot
# be set by providing a string. You'll need to replace `Aren Cambre` below
# with your own username.
options(WordpressLogin = c(`Aren Cambre` = key_get("WordPress publisher", "password")),
        WordpressURL = paste0(key_get("WordPress publisher", "hostname"),
                              'xmlrpc.php'))

knit2wp(input = 'analysis.Rmd',
        title = 'COVID-19 stats for Dallas and Texas',
        publish = TRUE,
        action = "editPost",
        postid = 3275)
