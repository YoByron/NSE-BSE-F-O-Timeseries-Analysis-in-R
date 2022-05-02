import sys # must be done before
try:
     __file__
except NameError: 
    __file__ = sys.argv[0
    
#from datetime 
from datetime import datetime
from requests import Session

#import click
import csv
import pandas as pd
#import matplotlib as plt
import numpy as np

page_url = "https://www.nseindia.com/get-quotes/equity?symbol=LT"
chart_data_url = "https://www.nseindia.com/api/chart-databyindex"

s = Session()
h = {"user-agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36",
     "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
    "accept-encoding": "gzip, deflate, br",
    "accept-language": "en-GB,en-US;q=0.9,en;q=0.8",
    }
s.headers.update(h)
r = s.get(page_url)

symbol=r.symbol

def fetch_data(symbol):
    data = {"index": symbol + "EQN"}
    r = s.get(chart_data_url, params=data)
    data = r.json()['grapthData']
    return [[datetime.fromtimestamp(d[0]/1000),d[1]] for d in data]
    d = fetch_data(symbol)
    today = datetime.now().date()
    df = pd.DataFrame(d)
    df.columns = ['Time', "Price"]
    df.index = df['Time'].dt.time
    return df
#df['Price'].plot(figsize=(12,6), grid=True)

with open("{}-{}.csv".format(symbol, today), "w") as fp:
    d = fetch_data(symbol)
    today = datetime.now().date()
    w = csv.writer(fp)
    w.writerow(["Time", "Price"])
    w.writerows(d)
