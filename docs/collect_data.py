### Imports - beautifulsoup to handle HTML, requests to carry the HTML, pandas to make dataframes 
from bs4 import BeautifulSoup 
import requests
import pandas as pd

## Pulls and sorts HTML info into 4 dataframes - school scores, then scores by division (honors/scholastic/varsity)
## Returns a list of dataframes 

def pull_and_sort(wiki_url):
    
    ## Handle online response
    response = requests.get(wiki_url) # - get request content
    soup = BeautifulSoup(response.text,'html.parser') # use BeautifulSoup html parser to turn html into text
    
    ## Constants to hold the tables
    table_counter = 0
    schools = None
    honors = None
    scholastic = None
    varsity = None
    for table in soup.find_all('table', attrs={'class':"wikitable sortable"}):
        if table_counter == 0:
            schools = pd.read_html(str(table))[0]
        elif table_counter == 1:
            honors = pd.read_html(str(table))[0]
        elif table_counter == 2:
            scholastic = pd.read_html(str(table))[0]
        elif table_counter == 3:
            varsity = pd.read_html(str(table))[0]
        else:
            pass
        table_counter += 1
    
    return [schools, honors, scholastic, varsity]

### Uses pull and sort to create a dictionary containing a list of four dataframes for each year (keyed by URL), column added for year

def collect_data(url_dict):
    url_vals = {}
    
    for key in url_dict.keys():
        url_vals[key] = pull_and_sort(url_dict[key]) # - pull and sort to get dataframes
    
    for val in list(url_vals.keys()):
        year_script = val[-2:]
        for item in url_vals[val]:
            item['Year'] = f'20{year_script}' # - add year column for each particular year 
    
    return url_vals

## Break and regroup into school and student divisions 

def stratify_by_type(url_vals):
    sk_list = [] # - School
    h_list = [] # - Honors
    sc_list = [] # - Scholastic
    v_list = [] # - Varsity 
    
    for val in url_vals.keys():
        for i in range(len(url_vals[val])):
            if i == 0:
                sk_list.append(url_vals[val][i])
            elif i == 1:
                h_list.append(url_vals[val][i])
            elif i == 2:
                sc_list.append(url_vals[val][i])
            elif i == 3:
                v_list.append(url_vals[val][i])
            else: 
                pass
    
    return sk_list, h_list, sc_list, v_list

## Construct final dataframe for school totals and student totals 

def make_dfs(sk_list, h_list, sc_list, v_list):
    
    ## Make division and school based dataframes 
    schools_df = pd.concat(sk_list)
    h_df = pd.concat(h_list)
    sc_df = pd.concat(sc_list)
    v_df = pd.concat(v_list)
    
    ## Add divisional markers for each student division
    h_df['Division'] = 'Honors'
    sc_df['Division'] = 'Scholastic'
    v_df['Division'] = 'Varsity'
    
    ## Combine the student dfs
    students_df = pd.concat([h_df, sc_df, v_df])
    
    return schools_df, students_df

## Full Pipeline

def data_collection(states_range=14): # I chose to go back as far as 2014
    
    ## Creating the dictionary of URL's
    url_dict = {}
    for i in range(states_range,23): 
        url_dict[f'url_{i}'] = f'https://acadecscores.gilslotd.com/wiki/State/20{i}'

    
    ## Collecting the dataframes from HTML tables
    url_vals = collect_data(url_dict)

    ## Sorting by info type 
    schools, honors, scholastic, varsity = stratify_by_type(url_vals)

    ## Making cumulative dataframes for each type of information 

    schools_df, students_df = make_dfs(schools, honors, scholastic, varsity)
    return schools_df, students_df