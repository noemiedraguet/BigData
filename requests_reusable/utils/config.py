import base64 #print(base64.b64encode('myMongoDB'.encode("utf-8"))) #base64.b64decode(b'bXlNb25nb0RC').decode("utf-8") 

#------------------------------------------------------------------------------------------------------
#region--------------------------------------  DATABASE   ---------------------------------------------
#------------------------------------------------------------------------------------------------------
database_credential_dict = {'bigdata_mysql': {'encrypted_server': b'aWRhc20xMDEudW5hbXVyY3MuYmU=',
                                            'encrypted_database': b'cmVsZGF0YQ==',
                                            'encrypted_username': b'cm9vdA==',
                                            'encrypted_password':b'cGFzc3dvcmQ=',
                                            'port':33062,},

                            'bigdata_mongodb':{'server':b'aWRhc20xMDEudW5hbXVyY3MuYmU=',
                                               'database':b'bXlNb25nb0RC',
                                               'port':27012,},

                            'bigdata_redis':{'server':b'aWRhc20xMDEudW5hbXVyY3MuYmU=',
                                            'database':0,
                                            'port':63792,}
}
#endregion

