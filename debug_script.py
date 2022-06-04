#Python Nifty PE Script
#pip install nsepy
from datetime import date
# Index P/E ratio history
from nsepy import get_index_pe_history
nifty_pe = get_index_pe_history(symbol="NIFTY",
                                start=date(2022,1,1),
                                end=date(2022,5,9))
