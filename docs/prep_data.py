## Imports
import numpy as np 
import pandas as pd 

## Handle NA and drop 

def na_and_drop(df, col_to_drop, col_to_handle, score_col): 
    df.drop(columns=[col_to_drop], inplace=True) # Drop 10-event 
    df[score_col] = df[score_col].fillna(df[col_to_handle]) # fill na with 8-event 
    df.drop(columns=[col_to_handle], inplace=True) # Drop 8-event after use  
    return df

## Pull column as string 

def get_stringList(df, is_student, col_val='Score'): 
    test_scoresList = list(df[col_val]) 
    str_scoresList = [str(score) for score in test_scoresList] 
    if is_student: 
        commas = [score[:5] if ',' in score else score[:4] for score in str_scoresList] 
    else: 
        commas = [score[:6] if ',' in score else score[:5] for score in str_scoresList] 
    return commas

## fix score format 

def fix_score_format(stringList): 
    formatList = [] 
    intList = [] 
     
    for string in stringList: 
        if ',' in string: 
            formatList.append(string.replace(',',"")) 
        else: 
            formatList.append(string) 
     
    for formatted in formatList: 
        intList.append(int(formatted)) 
     
    return intList

## handle 2020 scores 

def handle_2020(df, intList): 
    idx_sorter = [] 
    intsFixedList = [] 
     
    for i, row in df.iterrows(): 
        if row['Year'] == 2020: 
            idx_sorter.append(i) 
    for score in intList: 
        if intList.index(score) in idx_sorter: 
            intsFixedList.append(1.25*score) 
        else: 
            intsFixedList.append(float(score)) 
     
    return intsFixedList

## Full Pipeline

def preprocess(df, col_to_drop='10-Event', col_to_handle='8-Event', score_col='Score', is_student=False): 
    ## Handle NA and drops  
    df = na_and_drop(df, col_to_drop, col_to_handle, score_col) 
     
    ## get string list, using convert_score 
    stringList = get_stringList(df, is_student, col_val=score_col) 
     
    ## format into formatlist 
    intList = fix_score_format(stringList) 
     
    ## Handle 2020 online exam case 
    intFixedList = handle_2020(df, intList) 
     
    df[score_col] = intFixedList 
     
    return 0