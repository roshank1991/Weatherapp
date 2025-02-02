#  WeatherApp

#Description:

The weatherApp is a simple application to check the weather information of current city based on the current location of the user.
It also has a feature to browse other cities weather information too.
By calling OpenweatherMap API we are fetching global weather information for the same.To access OpenweatherMap API we have registered on their official webiste to get the api key which we have used to make api calls within the application.

#Getting Started:

Make sure you have minimum Xcode v12.0 to run the project on the system.
Download the project and simply run.
The application checks for internet connection first, if the internet is available the app moves further to check the current location.Once the location services are put "ON" the app fetches the current location's lat and long and makes OpenWeatherMap api call which fetches weather information based on the lat and long  passed in the api parameters.
If the internet is not available the application shows the alert for the same.
If the location services are not "ON" the application shows the alert to put it on in order to fetch the current location.
The App also has 2 buttons "search city" and "My Location".
On click of "search city" the applications presents a controller with a searchbar.User can type the city name and app fetches the  list of cities from the Map API . On selecting the city the application makes OpenWeatherMap API call and  shows weather information of the selected city.
On click of "My Location" button the application fetches the current locations weather info again.
The project also includes code for Unit testing  API and parses its data.
The test results can be monitored in the console.



