physical schemas { 
														
	document schema mymongo {
		collection Customers {
			fields {
				_id,		# Identifiant primaire (ObjectId)
				City,					# (String)
				CompanyName,				# (String)
				ContactName,				# (String)
				ContactTitle,				# (String)
				Country,				# (String)
				Fax, 					# (String)
				ID, 					# (String)
				Phone,					# (String) 
				PostalCode,				# (String) 
				Region,					# (String)
				Address					# (String)
			}
		},

		collection Employees {
			fields {
				_id,		# Identifiant primaire (ObjectId)
				Address,				# (String)
				City,					# (String)
				Country,				# (String)
				Extension,				# (String)
				FirstName, 				# (String)
				HireDate,				# (ISODate)
				HomePhone, 				# (String)
				LastName,				# (String)
				Photo, 					# (BinData)
				PostalCode, 				# (String)
				Region, 				# (String)
				Salary,					# (Double) 
				Title,					# (String)
				BirthDate,				# (ISODate)
				EmployeeID,				# (Int32)
				Notes, 					# (String)
				PhotoPath,				# (String)
				ReportsTo,				# (String)
				TitleOfCourtesy				# (String)
			}
		},

		collection Orders {
			fields {
				_id,		# Identifiant primaire (ObjectId)
				EmployeeRef,				# (Int32)
				Freight,				# (Double)
				OrderDate, 				# (ISODate)
				RequiredDate,				# (ISODate)
				ShipAddress,				# (String)
				customer[1]{				# (Object)
					ContactName,				# (String)
					CustomerID				# (String)
				},
				OrderID,				# (Int32)
				ShipCity,				# (String)
				ShipCountry,				# (String)
				ShipName,				# (String)
				ShipPostalCode,				# (String)
				ShipRegion,				# (String)
				ShipVia,				# (Int32)
				ShippedDate				# (ISODate)
			}
		}, 

		collection Suppliers {
			fields {
				_id,		# Identifiant primaire (ObjectId)
				Address,				# (String)
				City, 					# (String)
				CompanyName,				# (String)
				ContactName,				# (String) 
				ContactTitle,				# (String)
				Country,				# (String)
				Fax,					# (String)
				HomePage,				# (String)
				Phone,					# (String)
				PostalCode,				# (String)
				Region, 				# (String)
				SupplierID				# (Int32)
			}
		}
	}, 

	key value schema myredis {
		kvpairs shippersName {
			key : "SHIPPERS:"[ShipperID]":COMPANYNAME",
			value : string{COMPANYNAME}
		} , 
		kvpairs shippersPhone {
			key : "SHIPPERS:"[ShipperID]":PHONE",
			value : string{PHONE}
		} ,
		kvpairs stockInfo {
			key : "PRODUCT:"[ProductID]":STOCKINFO",
			value : hash{
				UnitsInStock,
				UnitsOnOrder
				}
		}
	},

	relational schema reldata {

    		table Categories {
			columns{
				CategoryID,		# Identifiant primaire (int)
				CategoryName,					# (varcar(15))
				Description,					# (mediumtext)
				Picture						# (varchar(15))
			}
		},

		table CustomerDemographics {
			columns{
		            CustomerTypeID,		# Identifiant primaire (varchar(10))
		            CustomerDesc					# (mediumtext)
		        }
	        },

    		table Customers {
			columns{
				CustomerID,		# Identifiant primaire (varchar(5))
				CompanyName,					# (varchar(40))
				ContactName,					# (varchar(30))
				ContactTitle,					# (varchar(30))
				Address,					# (varchar(60))
				City,						# (varchar(15))
				Region,						# (varchar(15))
				PostalCode,					# (varchar(10))
				Country,					# (varchar(15))
				Phone,						# (varchar(24))
				Fax						# (varchar(24))
			}
			references {
				CustomerID -> mymongo.Customers.ID
			}
		},

		table Employees {
		        columns{
		            EmployeeID,			# Identifiant primaire (int)
		            LastName,						# (varchar(20))
		            FirstName,						# (varchar(10))
		            Title,						# (varchar(30))
		            TitleOfCourtesy,					# (varchar(25))
		            BirthDate,						# (datetime)
		            HireDate,						# (datetime)
		            Address,						# (varchar(60))
		            City,						# (varchar(15))
		            Region,						# (varchar(15))
		            PostalCode,						# (varchar(10))
		            Country,						# (varchar(15))
		            HomePhone,						# (varchar(24))
		            Extension,						# (varchar(4))
		            Photo,						# (longblob)
		            Notes,						# (mediumtext)
		            ReportsTo,						# (int)
		            PhotoPath,						# (varchar(255))
		            Salary						# (float)
		        }
		        references {
		            EmployeeID -> mymongo.Employees.EmployeeID
		        }
		},
	
		table EmployeesTerritories {
		        columns{
		            EmployeeRef,		# Identifiant primaire (int)
		            TerritoryRef 		# Identifiant primaire (varchar(20))
		        }
		        references {
			    EmployeeRef -> mymongo.Employees.EmployeeID, 
	   	 	    TerritoryRef -> myrel.Territories.TerritoryID
		        }
		},
	
		table Order_Details {
			columns{
				OrderRef,		# Identifiant primaire (int)
				ProductRef,		# Identifiant primaire (int)
				UnitPrice,					# (decimal(10,4))
				Quantity,					# (smallint)
				Discount					# (double(8,0)) 					 
				}
			references {
				OrderRef -> myrel.Orders.OrderID, 
				OrderRef -> mymongo.Orders.OrderID
				ProductRef -> myrel.Products.ProductID
				}
		}
		table Orders{
			columns{
				OrderID,		# Identifiant primaire (int)
		                CustomerRef,					# (varchar(15))
		                EmployeeRef,					# (int)
		                OrderDate,					# (datetime)
		                RequiredDate,					# (datetime)
		                ShippedDate,					# (datetime)
		                ShipVia,					# (int)
		                Freight,					# (decimal(10,4))
		                ShipName,					# (varchar(40))
		                ShipAdress,					# (varchar(60))
		                ShipCity,					# (varchar(15))
		                ShipRegion,					# (varchar(15))
		                ShipPostalCode,					# (varchar(10))
		                ShipCountry					# (varchar(15))
			}
		        references{
		        	CustomerRef -> reldata.Customers.CustomerID, 
				CustomerRef -> mymongo.Customers.ID,
		                EmployeeRef -> reldata.Employees.EmployeeID,
				EmployeeRef -> mymongo.Emplyees.ID,
				ShipVia -> mymongo.Shippers.CustomerID,
		                ShipVia -> reldata.Shippers.ShipperID
		        }
		},
		
		table Products {
			columns{
				ProductID,		# Identifiant primaire (int)
		                ProductName,					# (varchar(40))
		                SupplierRef,					# (int)
		                CategoryRef,					# (int)
		                QuantityPerUnit,				# (varchar(20))
		                UnitPrice,					# (decimal(10,4))
		                UnitsInStock,					# (smallint)
		                UnitsOnOrder,					# (smallint)
		                ReorderLevel,					# (smallint)
		                Discontinued					# (tinyint(1))
			}
			references {
				SupplierRef -> reldata.Suppliers.SupplierID,
				SupplierRef -> mymongo.Suppliers.SupplierID,
                		CategoryRef -> reldata.Categories.CategoryID
            		}
		},

        	table ProductsInfo{
			columns{
				ProductID,		# Identifiant primaire (int)
		                ProductName,					# (varchar(40))
		                SupplierRef,					# (int)
		                CategoryRef,					# (int)
		                QuantityPerUnit,				# (varchar(20))
		                UnitPrice,					# (decimal(10,4))
		                ReorderLevel,					# (smallint)
		                Discontinued					# (tinyint(1))
			}
			references {
				ProductID -> reldata.Products.ProductID
				SupplierRef -> reldata.Suppliers.SupplierID,
				SupplierRef -> mymongo.Suppliers.SupplierID,
                		CategoryRef -> reldata.Categories.CategoryID
            		}
		},

        	table Region{
			columns{
				RegionID,		# Identifiant primaire (int)
                		RegionDescription				# (varchar(150))
			}
		},

        	table Shippers{
			columns{
				ShipperID,		# Identifiant primaire (int)
                		CompanyName,					# (varchar(40))
                		Phone						# (varchar(24))
			}
		},

        	table Suppliers{
			columns{
				SupplierID,		# Identifiant primaire (int)
		                CompanyName,					# (varchar(40))
		                ContactName,					# (varchar(30))
		                ContactTitle,					# (varchar(30))
		                Address,					# (varchar(60))
		                City,						# (varchar(15))
		                Region,						# (varchar(15))
		                PostalCode,					# (varchar(10))
		                Country,					# (varchar(15))
		                Phone,						# (varchar(24))
		                Fax,						# (varchar(24))
		                HomePage					# (mediumtext)
			}
		},

        	table Territories{
			columns{
				TerritoryID,		# Identifiant primaire (varchar(20))
		                TerritoryDescription,				# (varchar(50))
		                RegionRef					# (int)
			
            		references {
				RegionRef -> reldata.Region.RegionID
            		}
		}

	}
}

