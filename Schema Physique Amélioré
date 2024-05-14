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
				TitleOfCourtesy,			# (String)
				EmployeeTerritories{			# (Object)
					Territories,				# (Array)
					Regions					# (Array)
				}
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
	}, 

	key value schema myredis {
		kvpairs stockInfo {
			key : "PRODUCT:"[ProductID]":STOCKINFO",
			value : hash{
				UnitsInStock,
				UnitsOnOrder
				}
		},

		kvpairs EmployeesOrders {
			key: "EMPLOYEE:"[EMPLOYEEID]":ORDER:"[ORDERID],
			value : hash {				
				Freight,				
				OrderDate, 				
				RequiredDate,				
				ShipAddress,				
				customer.ContactName,				
				customer.CustomerID,				
				ShipCity,				
				ShipCountry,				
				ShipName,				
				ShipPostalCode,				
				ShipRegion,				
				ShipVia,				
				ShippedDate,
				Employee.Address,				
				Employee.City,					
				Employee.Country,				
				Employee.Extension,				
				Employee.FirstName, 				
				Employee.HireDate,				
				Employee.HomePhone, 				
				Employee.LastName,				
				Employee.Photo, 					
				Employee.PostalCode, 				
				Employee.Region, 				
				Employee.Salary,					
				Employee.Title,					
				Employee.BirthDate,								
				Employee.Notes, 					
				Employee.PhotoPath,				
				Employee.ReportsTo,				
				Employee.TitleOfCourtesy				
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
				ProductRef -> myrel.ProductsInfo.ProductID
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
				SupplierRef -> reldata.Suppliers.SupplierID,
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

