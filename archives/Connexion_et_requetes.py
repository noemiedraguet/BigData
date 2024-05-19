import mysql.connector
from mysql.connector import errorcode
import pymongo
import redis

def mysql_query1():
    try:
        cnx = mysql.connector.connect(user='root', password='password', host='idasm101.unamurcs.be', port='33062', database='reldata')
        cursor = cnx.cursor()

        query = ("SELECT CategoryName, Description, Picture FROM Categories WHERE Description NOT LIKE (%s)")

        chain = '%\sweet%'

        cursor.execute(query, (chain,))

        for (CategoryName, Description, Picture) in cursor:
            print(f'Category: {CategoryName}\nDescription: {Description}\n')

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


def mongodb_query2():
    client = pymongo.MongoClient('idasm101.unamurcs.be', 27012)
    db = client['myMongoDB']
    collection = db["Orders"]
    pipeline = {'OrderID': 10248}
    result = collection.find(pipeline)
    for doc in result :
        cust_ID = doc['customer']['CustomerID']

    collection_2 = db["Customers"]
    second_pipeline = {'ID': cust_ID}
    customers = collection_2.find(second_pipeline)
    for cust in customers:
       id = cust['ID']
       Name = cust['ContactName']
       Address = cust['Address']
       City = cust['City']
       Postal_Code = cust['PostalCode']
       Region = cust['Region']
       Country = cust['Country']
       Company_Name = cust['CompanyName']
       Contact_Title = cust['ContactTitle']
       Fax = cust['Fax']
       Phone = cust['Phone']
       print(f'\nID: {id}\nName: {Name}\nAddress: {Address}\nCity: {City}\nPostcode: {Postal_Code}\nRegion: {Region}\nCountry: {Country}\nCompany Name: {Company_Name}\nContact title: {Contact_Title}\nFax: {Fax}\nPhone number: {Phone}\n')

        
def redis_query3():
    r = redis.Redis(host='idasm101.unamurcs.be', port=63792, db=0)
    infos_shipper_2 = r.keys('SHIPPERS:2:*')
    infos = []
    for key in infos_shipper_2:
        infos.append(r.get(key).decode('utf-8'))

    print(f'Company name: {infos[0]}\nPhone number: {infos[1]}')

def query4():
    client = pymongo.MongoClient('idasm101.unamurcs.be', 27012)
    db = client['myMongoDB']
    collection = db["Employees"]
    collection_2 = db["Orders"]
    collection_3 = db["Customers"]

    pipeline = {'FirstName': 'Margaret'}
    
    employees = collection.find(pipeline)
    for employee in employees :
        empl_ID = employee['EmployeeID']
        pipeline2 = {'EmployeeRef': empl_ID}
        orders = collection_2.find(pipeline2)
        for order in orders:
            cl_ID = order['customer']['CustomerID']
            pipeline3 = {'ID': cl_ID}
            clients = collection_3.find(pipeline3)
            for client in clients:
                id = client['ID']
                Name = client['ContactName']
                Address = client['Address']
                City = client['City']
                Postal_Code = client['PostalCode']
                Region = client['Region']
                Country = client['Country']
                Company_Name = client['CompanyName']
                Contact_Title = client['ContactTitle']
                Fax = client['Fax']
                Phone = client['Phone']
                print(f'\nID: {id}\nName: {Name}\nAddress: {Address}\nCity: {City}\nPostcode: {Postal_Code}\nRegion: {Region}\nCountry: {Country}\nCompany Name: {Company_Name}\nContact title: {Contact_Title}\nFax: {Fax}\nPhone number: {Phone}\n\n')


#mysql_query1()
#mongodb_query2()
#redis_query3()
#query4()
