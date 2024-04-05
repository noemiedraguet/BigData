import mysql.connector
from mysql.connector import errorcode
import pymongo
import redis

def mysql_select():
    try:
        cnx = mysql.connector.connect(user='root', password='password', host='idasm101.unamurcs.be', port='33062', database='reldata')
        cursor = cnx.cursor()

        query = ("SELECT CategoryName, Description FROM Categories WHERE CategoryName in (%s, %s)")

        first_parameter = 'Beverages'
        second_parameter = 'Condiments'

        cursor.execute(query, (first_parameter, second_parameter))

        for (CategoryName, Description) in cursor:
            print(f'Category "{CategoryName}" with description "{Description}"')

        cursor.close()
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print(err)
    else:
        cnx.close()


def mongodb_select():
    client = pymongo.MongoClient('idasm101.unamurcs.be', 27012)
    db = client['myMongoDB']
    collection = db["Orders"]
    pipeline = [{"$sample": {"size": 5}}]
    result = collection.aggregate(pipeline)
    for doc in result :
        order_id = doc['OrderID']
        print(f'Order ID: {order_id}')

        
def redis_select():
    r = redis.Redis(host='idasm101.unamurcs.be', port=63792, db=0)
    hash_result = r.hget('PRODUCT:72:STOCKINFO', 'UnitsInStock')
    print(f'Product in stock: {hash_result}')
        
mysql_select()
mongodb_select()
redis_select()
