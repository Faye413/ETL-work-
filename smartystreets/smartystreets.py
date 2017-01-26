import json, ast
import io
import urllib
import urllib2
import sys
import csv
from pandas.io.json import json_normalize

#load credentials 
with io.open('config.json') as cred:
    creds = json.load(cred)
    ast.literal_eval(json.dumps(creds))

    STRING_DATA = dict([(str(k), v) for k, v in creds.items()]) 

    authid = STRING_DATA['authid']
    auth_token = STRING_DATA['auth_token']

#form URL
URL = "https://api.smartystreets.com/street-address/?auth-id={0}&auth-token={1}".format(
    urllib.quote(authid),
    urllib.quote(auth_token)
)

with open("loan.txt", 'r') as f:
    reader = csv.reader(f, delimiter='\t')
    lists = list(reader)

    addresses = []
    for eachlist in lists:
        addresses.append({'input_id': eachlist[0],'street': eachlist[3]+','+eachlist[4], 'city' : eachlist[5], 'state' : eachlist[6], 'zipcode' : eachlist[7]})
    
    #due to limit 100 addresses look up per call 
    if sum(1 for line in open('loan.txt')) <= 100:  
        DATA = json.dumps(addresses)
        request = urllib2.Request(URL, data=DATA)
        response = urllib2.urlopen(request)
        y = json.loads(response.read())
        result = json_normalize(y)
        result.to_csv('output_100.txt',sep='\t')

    else:
        x = []
        sub_addresses = [addresses[y:y+100] for y in range(0, len(addresses),100)]
        for i, item in enumerate(sub_addresses):
            DATA = json.dumps(item)
            request = urllib2.Request(URL, data=DATA)
            response = urllib2.urlopen(request)

            y = json.loads(response.read())
            x = y + x
            result = json_normalize(x)
            result.to_csv('output_loan.txt',sep='\t')


    # f = csv.writer(open("output100.txt", "wb+"))
    # f.writerow(["candidate_index", "input_index'", "delivery_point_check_digit", "primary_number", "street_name", "zipcode", 
    #     "state_abbreviation", "delivery_point", "city_name", "plus4_code", "last_line", "active", "dpv_vacant", "dpv_footnotes", "dpv_match_code",
    #     "dpv_cmra", "delivery_point_barcode", "input_id", "delivery_line_1", "zip_type", "county_fips", "carrier_route", "elot_sort", 
    #     "elot_sequence", "precision", "longitude", "time_zone", "record_type", "utc_offset", "congressional_district", "county_name", "latitude", "rdi"])
    # for x in x:
    #     f.writerow([x["candidate_index"], 
    #                 x["input_index"], 
    #                 x["components"]["delivery_point_check_digit"], 
    #                 x["components"]["primary_number"],
    #                 x["components"]["street_name"],
    #                 x["components"]["zipcode"],
    #                 # x["components"]["street_suffix"],
    #                 # x["components"]["secondary_number"],
    #                 # x["components"]["secondary_designator"],
    #                 x["components"]["state_abbreviation"],
    #                 x["components"]["delivery_point"],
    #                 x["components"]["city_name"],
    #                 x["components"]["plus4_code"],
    #                 x["last_line"],
    #                 x["analysis"]["active"],
    #                 x["analysis"]["dpv_vacant"],
    #                 x["analysis"]["dpv_footnotes"],
    #                 x["analysis"]["dpv_match_code"],
    #                 x["analysis"]["dpv_cmra"],
    #                 x["delivery_point_barcode"],
    #                 x["input_id"],
    #                 x["delivery_line_1"],
    #                 x["metadata"]["zip_type"],
    #                 x["metadata"]["county_fips"],
    #                 x["metadata"]["carrier_route"],
    #                 x["metadata"]["elot_sort"],
    #                 #x["metadata"]["dst"],
    #                 x["metadata"]["elot_sequence"],
    #                 x["metadata"]["precision"],
    #                 x["metadata"]["longitude"],
    #                 x["metadata"]["time_zone"],
    #                 x["metadata"]["record_type"],
    #                 x["metadata"]["utc_offset"],
    #                 x["metadata"]["congressional_district"],
    #                 x["metadata"]["county_name"],
    #                 x["metadata"]["latitude"],
    #                 x["metadata"]["rdi"]])
    # new = open("output100.txt", "wb+")
    # csv.writer(f, delimiter ='/001',quotechar =',',quoting=csv.QUOTE_MINIMAL)
    # out = file("yourfile.txt", "w")
    # for line in y:
    #     print >> out, "\\001".join(line)
    # val = {}
    # for i in y.keys():
    #     if isinstance( y[i], dict ):
    #         get = flattenjson( y[i], delim )
    #         for j in get.keys():
    #             val[ i + "\\001" + j ] = get[j]
    #     else:
    #         val[i] = b[i]
    # print val

    # with open('001.txt', 'w') as file:
    #     file.writelines('\\001'.join(i) + '\n' for i in y)
    #csv.writer(f, delimiter ='/100',quotechar =',',quoting=csv.QUOTE_MINIMAL)
        #     print("Success. Please check the output file.")
        # except:
        #     print("Fail to write output.")

    # else: 
    #     sub_addresses = [addresses[x:x+100] for x in xrange(0, len(addresses),100)]
    #     for i, item in enumerate(sub_addresses):
    #         DATA = json.dumps(item)
    #         request = urllib2.Request(URL, data=DATA)
    #         response = urllib2.urlopen(request)

    #         parsed = json.loads(response.read())
    #         small_filename = 'small_file_{}.json'.format(i * 100 + 100)
    #         sys.stdout = open(small_filename, "w")
    #         try: 
    #           print json.dumps(parsed, indent=4, sort_keys=True)
    #         except: 
    #           print("Fail to write output.")
     

