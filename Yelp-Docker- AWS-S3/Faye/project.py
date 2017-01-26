
__author__ = 'Faye'

from yelpapi import YelpAPI
import argparse
import sys
import io
import json, ast
import csv
import itertools

### YELP Authorization #############################################################
#Import authorization info from json file 
with io.open('config_secret.json') as cred:
    creds = json.load(cred)
    ast.literal_eval(json.dumps(creds))

    #convert a dict's keys & values from `unicode` to `str`
    STRING_DATA = dict([(str(k), v) for k, v in creds.items()]) 

    #assign each key with value
    consumer_key = STRING_DATA['consumer_key']
    consumer_secret = STRING_DATA['consumer_secret']
    token = STRING_DATA['token']
    token_secret = STRING_DATA['token_secret']

### YELP Api call to get raw data ###################################################
yelp_api = YelpAPI(consumer_key, consumer_secret, token, token_secret)

#search query: 20 attractions in SF sorted by high rating 
response = yelp_api.search_query(location = "San Francisco", term = "attractions", sort= 1, limit = 20)

### Organize Data & Export CSV ######################################################
#creat output file
with open('output.csv', 'w') as f:
    #create header
    fieldnames = ["Name", "Category", "Rating", "Review Count", "Address", "City", "State", "Zip Code"]
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()

    #For-loop that go through each business amoung the 20 businesses 
    for business in response['businesses']:
        #reorganzie raw category data to combine more than one statements together. Eg: 'Local Flavor', 'Landmarks & Historical Buildings'
        if business['categories']:
            categories = []
            for i in business['categories']:
                categories.append(i[0])
                category_list = []
                for z in categories:
                    category_list.append(str(z))

        #reorganzie raw address data to combine more than one statements together. Eg: '323 Geary St', 'Ste 203'     
        if business['location']['address']:  
            address_list = []
            for z in business['location']['address']:
                address_list.append(str(z))
        
        #reorganize the necessary data into a new dictionary for export 
        business_list = {}
        business_list['Name'] = business['name']   
        business_list['Category'] = ', '.join(category_list)
        business_list['Rating'] = business['rating']   
        business_list['Review Count'] = business['review_count']   
        business_list['Address'] = ', '.join(address_list)
        business_list['City'] = business['location']['city']  
        business_list['State'] = business['location']['state_code']  
        business_list['Zip Code'] = business['location']['postal_code']  
         
        #write the output data row by row 
        writer.writerow({'Name':business_list['Name'], 'Category':business_list['Category'], 'Rating':business_list['Rating'], 'Review Count':business_list['Review Count'], 'Address':business_list['Address'], 'City':business_list['City'], 'State':business_list['State'], 'Zip Code': business_list['Zip Code']})
        
print("Done! Please check output in output.csv file.")        