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

## Other Notes
* I chose to add a 'date_created_at' column in order to more effectively use indexing
when filtering by dates. You can't apply a function like date() to a datetime
within a where clause and still use a datetime index.
* I used the AngularJS $HTTP service to get the JSON at
[http://localhost:3000/get_top_urls](http://localhost:3000/get_top_urls) so I could
use the ng-repeat directive to display the data at
[http://localhost:3000/top_urls](http://localhost:3000/top_urls).

## TODO

* Optimize queries for large datasets
    - Work on reducing the number of SQL queries made and let the database
    do more of the filtering.
* Decrease page loading time
    - While the SQL query for Top URLs takes less than a second, generating the JSON
    is taking much longer.
* Add more CSS styling


