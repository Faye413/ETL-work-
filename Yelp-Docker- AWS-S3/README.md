Get ready to explore SF's top 20 attractions! :)


## ABOUT
This program is a pure Python implementation of the [Yelp v2.0 API](https://www.yelp.com/developers/documentation/v2/overview). It searches for SF's top 20 rated attractions and returns all the data in a CSV file(output.csv).

## REQUIREMENTS
This code requires Python 2.7 or higher and [requests_oauthlib](https://github.com/requests/requests-oauthlib).

## INSTALL
Install using [pip](http://www.pip-installer.org/):
    pip install yelpapi

Install from source:
    python setup.py install

## USING THIS CODE
Add your API access keys to config_secret.json

Then run [project.py](Faye/project.py): 
    python project.py 

## SQL
What are 10 highest rated landmarks, restaurants, and cafes?
This is asking for the highest rate attractions' data, thus it needs to ORDER BY rating. 
This also asks for the top 10 results, thus it needs to limit number of results by using Top 10. 

SELECT Top 10 * FROM table ORDER BY rating

What are the 10 most visited places?
This is asking for the most visited attractions' data, thus it needs to ORDER BY rating count. 
Assumes that there is a high correlation between rating count and visits to that place.
This also asks for the top 10 results, thus it needs to limit number of results by using Top 10. 

SELECT Top 10 * FROM table ORDER BY rating count

## Reasoning 
Why do I use Python? 
Python emphasizes productivity and code readability. It's usually used by programmers that want to delve into data analysis or apply statistical techniques, and by developers that turn to data science. Coding and debugging is easier to do in Python, mainly because the easy and clean syntax. The indentation of the code affects its meaning.

Why do I organize my code this way? 
Since the purpose of this program is to return specific data, I spend most of the time reorganize the data structure for output. The process of getting the data is quite simple. Firstly, I import my API access keys from config_secret.json file, and make a API call with my authorization. Secondly, I used the API call to make a search query: Top 20 attractions in SF ordered by rating, and I get a list of returing data. Thirdly, I organize the data structure into a new nested dictionary(business_list), so I only keep the necessary data and it's easier to display as well. Finally, I use the for loop to iterate through each business' data and write it out to a CSV file - output.csv. The reason I choose CSV(Excel) is that it is convenient for data analysis. This whole process occurs in project.py file. 

What's good? 
It's a very light, clean and efficient program. Simply using 70 lines of code to make YELP API call, serach query, organzie data and export data. The whole process takes 2 seconds to complete. The python syntax makes it easy to read and understand. 

The new data structure(business_list) is very neat for the output. I only saved the necessay data for the new nested structure, so it's easy to iterate through, look for data, and minimize the run time. This is the structure for business_list: 
{name: name1, category: category1, rating: rating1, review_account: review_account1, address: address1, city: city1, state: state1, zip_code: zip_code1}
{name: name2, category: category2, rating: rating2, review_account: review_account2, address: address2, city: city2, state: state2, zip_code: zip_code2}
......

What's bad?
Since I wrote the program just for the coding challenge, I put all my code in one file and didn't seperate out the class and function calls to maximize the program efficiency. It might be hard for future development to add code or re-use the code. 

In order to solve this, I would seperate the code into different classes. Eg class GetYelpAPIClient(object), class Location(object)...
