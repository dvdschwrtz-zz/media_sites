# Media Sites

## About this repo
- This is an elixir umbrella project that has 4 main sections. here is an overview of what they all do

### Amazon Product API
- this repo builds upon a pre existing library - when given an Amazon category, it recursively gets all the best sellers in that category and subcategories and retrieves specific information from each individual product.

### Web Scraper
- this repo takes each individual product from the best seller list and grabs the Google Trends score for that product.

### Media_web && Media
- this is a site generator project where you can create new blog/ media sites simply by changing a config file and adding in new css files. These sites also include amp-html templates to conform with Google's new format. So, this project can be used to launch 100 different blog and media sites simply by adding new sass (css) files for each site. 4 sites were previously launched using this repo, but are not online at the moment.
