# attach REPL to an active jupyter kernel
jupyter console --active

# Display all columns in a pandas df
import pandas as pd
from IPython.display import display
pd.options.display.max_columns = None
