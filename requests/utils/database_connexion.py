import time
import json
import base64
import pandas as pd
from datetime import datetime

#MYSQL
import mysql.connector as connection
#NO-SQL
import pymongo
import redis

from ..utils.config import database_credential_dict

def get_df_from_mysql(query:str, params:tuple, db:str = 'bigdata_mysql',
                      database_credential_dict: dict = database_credential_dict, optionnal_message:str ="",)-> pd.DataFrame:
    """
    Queries MySQL database and returns the results under a pandas DataFrame object \n
    Supports SQL injection prevention. Ex: query = "select * from db.table where user = %s" ; params = ('myusername',)

    Input
    -----
    `query`: sql query
    `params`: used in "prepared sql statement" to prevent sql injection 
    `db`: database key used to retrieve connection information in config dictionary
    `database_credential_dict`: config dictionary containing encrypted connection information
    `optionnal_message`: message displayed when function is called

    Returns
    -------
    `return`: pandas dataframe
    `display`: runtime in seconds
    """

    #CREDENTIALS
    server = base64.b64decode(database_credential_dict[db]['encrypted_server']).decode("utf-8")
    database = base64.b64decode(database_credential_dict[db]['encrypted_database']).decode("utf-8")
    username = base64.b64decode(database_credential_dict[db]['encrypted_username']).decode("utf-8")
    password = base64.b64decode(database_credential_dict[db]['encrypted_password']).decode("utf-8")
    port = database_credential_dict[db]['port']

    #QUERY
    start_time = time.time()
    print(f"[{datetime.now().strftime('%H:%M:%S')}] Database connection to {db}...")  
    with connection.connect(host=server, database = database,user=username, passwd=password,port = port) as db_object:
        df = pd.read_sql(query,db_object, params=params)
        print(f"{optionnal_message}" +"runtime -> %s seconds" % (round(time.time() - start_time,2)))
        return df

def get_df_from_mongodb(collection_name:str = "Orders", mongo_condition = 'all_documents', normalized = False, db: str = 'bigdata_mongodb',
                        database_credential_dict: dict = database_credential_dict, optionnal_message:str ="",) -> pd.DataFrame:
    """
    Queries Mongodb database and returns the results under a pandas DataFrame object.

    1. Pick a collection to search from
    2. Write a condition as dictionnary on any attribute which can be found in documents of the collection
    3. This function will return each document as a row of a dataframe

    Input
    -----
    `collection_name`: name of the collection to parse
    `mongo_condition`: `all_documents`, `first_document`, or dictionary such that {'attribute':'value'}
    `normalized`: if set to true, subdictionaries will be split into columns with name = `subdict.key`
    `db`: database key used to retrieve connection information in config dictionary
    `database_credential_dict`: config dictionary containing encrypted connection information
    `optionnal_message`: message displayed when function is called

    Returns
    -------
    `return`: pandas dataframe
    `display`: runtime in seconds
    """

    #CREDENTIALS
    database = base64.b64decode(database_credential_dict[db]['database']).decode("utf-8")
    server = base64.b64decode(database_credential_dict[db]['server']).decode("utf-8")
    port = database_credential_dict[db]['port']

    #QUERY
    start_time = time.time()
    print(f"[{datetime.now().strftime('%H:%M:%S')}] Database connection to {db}...")
    db_object = pymongo.MongoClient(server, port)[database]
    collection = db_object[collection_name]

    if mongo_condition == 'all_documents':
        all_documents = list(collection.find())
        nbr_documents = len(all_documents)
        if normalized:
            df = pd.DataFrame(pd.json_normalize(all_documents))
        else:
            df = pd.DataFrame(all_documents)

        print(f'Nombre de documents collectés : {nbr_documents}')
        
    elif mongo_condition == 'first_document':
        #Result stored into list to avoid considering subdict as indexes values
        first_document = [collection.find_one()]
        if normalized:
            df = pd.DataFrame(pd.json_normalize(first_document))
        else:
            df = pd.DataFrame(first_document)
        
        print(json.dumps(dict(first_document[0]), sort_keys= True, indent = 4, default= str))

    else :
        all_documents = list(collection.find(mongo_condition))
        nbr_documents = len(all_documents)
        if normalized:
            df = pd.DataFrame(pd.json_normalize(all_documents))
        else:
            df = pd.DataFrame(all_documents)

        print(f'Nombre de documents collectés : {nbr_documents}')

    print(f"{optionnal_message}" +"runtime -> %s seconds" % (round(time.time() - start_time,2)))

    return df

def redis_select(db: str = 'bigdata_redis', redis_key_path = 'KEY1:KEY2:*', redis_key_map = 'Entity:ID:Info', redis_key_grouper = '', return_type = 'df',
                 database_credential_dict: dict = database_credential_dict, optionnal_message:str ="",) -> pd.DataFrame:
    """
    Queries Redis database and returns the results under a dictionary object.

    1. Pick a Key path = KEY1:KEY2:KEY3 chain
    2. This function will return all objects contained under that path sequence and their potential sub-paths\n
    in a pandas dataframe or within a dictionnary.

    Input
    -----
    `redis_key_path`: `KEY1:KEY2:KEY3` as a string (where * is a wildcard character) such that `'*'`returns every complete key paths
    `redis_key_map`: Title to give to each key
    `db`: database key used to retrieve connection information in config dictionary
    `database_credential_dict`: config dictionary containing encrypted connection information
    `optionnal_message`: message displayed when function is called

    Returns
    -------
    `return`: pandas dataframe
    `display`: runtime in seconds
    """

    #CREDENTIALS
    server = base64.b64decode(database_credential_dict[db]['server']).decode("utf-8")
    database = database_credential_dict[db]['database']
    port = database_credential_dict[db]['port']

    #QUERY
    start_time = time.time()
    print(f"[{datetime.now().strftime('%H:%M:%S')}] Database connection to {db}...")
    db_object = redis.Redis(host=server, port=port, db=database)
    retrieved_keys = db_object.keys(redis_key_path)

    retrieved_dict = {}
    for k in retrieved_keys:
        try:
            retrieved_dict[k.decode('utf-8')] = db_object.get(k).decode('utf-8')
        except redis.exceptions.ResponseError:
            retrieved_dict[k.decode('utf-8')] = db_object.hgetall(k)

    print(f"{optionnal_message}" +"runtime -> %s seconds" % (round(time.time() - start_time,2)))

    if return_type == 'df':
        df = pd.DataFrame([{'key_'+str(i+1):k for i, k in enumerate(k.split(':'))} | {'value':v} for k,v in retrieved_dict.items()])
        df.columns = redis_key_map.split(':') + ['Value']

        if redis_key_grouper!= '':
            df = df.groupby(redis_key_grouper.split(':')).agg('first')

        return df

    else:
        return retrieved_dict
