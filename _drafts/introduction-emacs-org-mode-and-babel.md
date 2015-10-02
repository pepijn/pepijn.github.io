---
layout:     post
title:      Introduction to Emacs Org mode and Babel
summary:    
categories: emacs org-mode git geojson
---

First we define the travel log and name it (put it in a variable) called
`travel-log`.

{% highlight cucumber %}
#+NAME: travel-log
#+RESULTS:
| Date             | Location                  |
|------------------+---------------------------|
| <2015-08-10 Mon> | Utrecht, The Netherlands  |
| <2015-08-10 Mon> | Kožná, Prague             |
| <2015-08-12 Wed> | Prenzlauer Berg, Berlin   |
| <2015-08-13 Thu> | A&O Hamburg City, Hamburg |
| <2015-08-14 Fri> | Utrecht, The Netherlands  |
{% endhighlight %}

In order to geocode the location names to coordinates we are going to use the
[`geocoder` Ruby gem](https://github.com/alexreisner/geocoder).

{% highlight sh %}
#+HEADER: :results output
#+BEGIN_SRC sh
gem install geocoder
#+END_SRC

#+RESULTS:
: Successfully installed geocoder-1.2.11
: Parsing documentation for geocoder-1.2.11
: Done installing documentation for geocoder after 1 seconds
: 1 gem installed

{% endhighlight %}

And now we will geocode it. We don't want to geocode Amsterdam twice so we use a
cache.

{% highlight ruby %}
#+HEADER: :var travel_log=travel-log
#+BEGIN_SRC ruby
locations = travel_log.map do |entry|
  # We only need the second column: the location
  _, location = entry
  location
end

distinct_locations = locations.uniq

require 'geocoder'
distinct_locations.map do |location|
  geo = Geocoder.search location
  coordinates = geo.first.geometry['location']

  [location, coordinates['lng'], coordinates['lat']]
end
#+END_SRC

#+NAME: geolocation-cache
#+RESULTS:
| Utrecht, The Netherlands  |  5.1214201 | 52.09073739999999 |
| Kožná, Prague             | 14.4213456 |        50.0862754 |
| Prenzlauer Berg, Berlin   |   13.44009 |          52.54114 |
| A&O Hamburg City, Hamburg |  9.9936818 |        53.5510846 |
{% endhighlight %}

We are going to construct the geoJSON file now. But before we do, we have to
specify the location to save the file.

{% highlight sh %}
#+NAME: geojson-file-path
#+RESULTS:
: /tmp/example_travel_log/my_trip.geojson
{% endhighlight %}

Now we contruct the geoJSON file.

{% highlight ruby %}
#+HEADER: :results silent
#+HEADER: :var geojson_file_path=geojson-file-path
#+HEADER: :var geolocation_cache=geolocation-cache
#+HEADER: :var travel_log=travel-log
#+BEGIN_SRC ruby
coordinates = Hash[geolocation_cache.map do |entry|
  location, longitude, latitude = entry
  [location, [longitude, latitude]]
end]

require 'date'
geojson_features = travel_log.map do |entry|
  org_date, location = entry

  date = Date.parse org_date

  {
    type: 'Feature',
    geometry: {
      type: 'Point',
      coordinates: coordinates[location]
    },
    properties: {
      Location: location,
      Date: date
    }
  }
end

require 'fileutils'
repository_dir = File.dirname geojson_file_path
FileUtils.mkdir_p repository_dir

require 'json'
open(geojson_file_path, 'w') do |file|
  file.write JSON.pretty_generate(
    type: 'FeatureCollection',
    features: geojson_features
  )
end
#+END_SRC
{% endhighlight %}

Now we look at the contents of the file.

{% highlight sh %}
#+HEADER: :results output
#+HEADER: :var GEOJSON_FILE_PATH=geojson-file-path
#+BEGIN_SRC sh
head -n 19 '' $GEOJSON_FILE_PATH
echo etc...
#+END_SRC

#+RESULTS:
#+begin_example
==> /tmp/example_travel_log/my_trip.geojson <==
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [
          5.1214201,
          52.09073739999999
        ]
      },
      "properties": {
        "Location": "Utrecht, The Netherlands",
        "Date": "2015-08-10"
      }
    },
    {
      "type": "Feature",
etc...
#+end_example

{% endhighlight %}

Finally we push the geoJSON file to GitHub.

{% highlight sh %}
#+HEADER: :results output silent
#+HEADER: :var GEOJSON_FILE_PATH=geojson-file-path
#+BEGIN_SRC sh
cd $(dirname $GEOJSON_FILE_PATH)

FILENAME=$(basename $GEOJSON_FILE_PATH)

brew install hub
hub init
hub create
hub add $FILENAME
hub commit -m 'Update travel_log' $FILENAME
hub push origin master

ROOT=$(hub remote -v | grep fetch | grep -oE '\w+\/\w+')
hub browse "$ROOT/blob/master/$FILENAME"
#+END_SRC

{% endhighlight %}
