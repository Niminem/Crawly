# Crawly
A fast, high-level web crawling & scraping framework for Nim.

## Directory Structure (temp notes)

This is likely to change. Currently doing some experimenting with combining multi-processing, threads, and
asynchronous execution to squeeze the most performance as possible.

In theory, if we split independent workloads into their own processes we can leverage threads
much much better.

***crawly/main*** Main process
***crawly/networking*** Networking process
***crawly/parsing*** Parsing process