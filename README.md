# It's All About Stats

This is a Rails application that uses MySQL and AngularJS to calculate and display:

1. Number of page views per URL, grouped by day, for the past 5 days

2. Top 5 referrers for the top 10 URLs, grouped by day, for the past 5 days

## Running the application

To run this application, you will need Rails and MySQL installed. You can reset and seed database with:

```
rake db:reset
```

```
rails server
```

## Viewing the data

Visit [http://localhost:3000/top_urls](http://localhost:3000/top_urls) to
see the page views per URL, grouped by day, for the past 5 days.

Visit [http://localhost:3000/top_referrers](http://localhost:3000/top_referrers) to
see the top 5 referrers for the top 10 URLs, grouped by day, for the past 5 days. 

## TODO

* Optimize queries for large datasets and the Top N per Group Problem
    - My initial implementation of this project involved too much calculating and filtering
    on the client side. I worked on reducing the number of SQL queries I was making and 
    letting the database do more of the filtering.
* Decrease page loading time
    - The page load time is slower than it could be. 
        - For the Top URLs page, it takes
    about 4 seconds to query the database and 11 seconds to render the view. 
        - For the top Referrers page, it takes about 5 seconds to query the 
        database and only 11 ms to render the view.


