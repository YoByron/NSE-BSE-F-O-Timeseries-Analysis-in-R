from datetime import date
from jugaad_data.nse import NSELive bhavcopy_save, bhavcopy_fo_save
pwd = pwd()
# Download bhavcopy
bhavcopy_save(date(2020,1,1), "$pwd")

# Download bhavcopy for futures and options
bhavcopy_fo_save(date(2020,1,1), "/path/to/directory")

# Download stock data to pandas dataframe
from jugaad_data.nse import stock_df
df = stock_df(symbol="SBIN", from_date=date(2020,1,1),
            to_date=date(2020,1,30), series="EQ")

#Live stock quotes
n = NSELive()
q = n.stock_quote("HDFC")
print(q['priceInfo'])
