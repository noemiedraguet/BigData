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
		table Orders{
			columns{
				OrderID,		# Identifiant primaire
		                CustomerRef,
		                EmployeeRef,
		                OrderDate,
		                RequiredDate,
		                ShippedDate,
		                ShipVia,
		                Freight,
		                ShipName,
		                ShipAdress,
		                ShipCity,
		                ShipRegion,
		                ShipPostalCode,
		                ShipCountry
			}
		        references{
		        	CustomerRef -> reldata.Customers.CustomerID
		                EmployeeRef -> reldata.Employees.EmployeeID
		                ShipVia -> reldata.Shippers.ShipperID
		        }
		},
		
		table Products {
			columns{
				ProductID,		# Identifiant primaire
		                ProductName,
		                SupplierRef,
		                CategoryRef,
		                QuantityPerUnit,
		                UnitPrice,
		                UnitsInStock,
		                UnitsOnOrder,
		                ReorderLevel,
		                Discontinued
			}
			references {
				SupplierRef -> reldata.Suppliers.SupplierID
                		CategoryRef -> reldata.Categories.CategoryID
            		}
		},

        	table ProductsInfo{
			columns{
				ProductID,		# Identifiant primaire
		                ProductName,
		                SupplierRef,
		                CategoryRef,
		                QuantityPerUnit,
		                UnitPrice,
		                ReorderLevel,
		                Discontinued
			}
		},

        	table Region{
			columns{
				RegionID,		# Identifiant primaire
                		RegionDescription
			}
		},

        	table Shippers{
			columns{
				ShipperID,		# Identifiant primaire
                		CompanyName,
                		Phone
			}
		},

        	table Suppliers{
			columns{
				SupplierID,		# Identifiant primaire
		                CompanyName,
		                ContactName,
		                ContactTitle,
		                Address,
		                City,
		                Region,
		                PostalCode,
		                Country,
		                Phone,
		                Fax,
		                HomePage
			}
		},

        	table Territories{
			columns{
				TerritoryID,		# Identifiant primaire
		                TerritoryDescription,
		                RegionRef
			}
            		references {
				RegionRef -> reldata.Region.RegionID
            		}
		},

    		table Categories {
			columns{
				CategoryID,		# Identifiant primaire
				CategoryName,
				Description,
				Picture
			}
			references {
			}
		},

		table CustomerDemographics {
			columns{
		            CustomerTypeID,		# Identifiant primaire
		            CustomerDesc
		        }
		        references {
		        }
	        },

    		table Customers {
			columns{
				CustomerID,		# Identifiant primaire
				CompanyName,
				ContactName,
				ContactTitle,
				Address,
				City,
				Region,
				PostalCode,
				Country,
				Phone,
				Fax
			}
			references {
				CustomerID -> mymongo.Customers.id
			}
		},

		table Employees {
		        columns{
		            EmployeeID,		# Identifiant primaire
		            LastName,
		            FirstName,
		            Title,
		            TitleOfCourtesy,
		            BirthDate,
		            HireDate,
		            Address,
		            City,
		            Region,
		            PostalCode,
		            Country,
		            HomePhone,
		            Extension,
		            Photo,
		            Notes,
		            ReportsTo,
		            PhotoPath,
		            Salary
		        }
		        references {
		            EmployeeID -> mymongo.Employees.id
		        }
		},
	
		table EmployeesTerritories {
		        columns{
		            EmployeeRef,	# Identifiant primaire
		            TerritoryRef 	# Identifiant primaire
		        }
		        references {
		        }
		},
	
		table Order_Details {
			columns{
				OrderRef,	# Identifiant primaire
				ProductRef,	# Identifiant primaire
				UnitPrice,
				Quantity,
				Discount
				}
			references {
				}
		}
	}
}

