physical schemas { 
	
	document schema mymongo {
		collection Customers {
			fields {
				_id,
				City,
				CompanyName,
				ContactName,
				ContactTitle,
				Country,
				Fax, 
				ID, 
				Phone, 
				PostalCode, 
				Region,
				Address
			}
		},

		collection Employees {
			fields {
				_id,
				Address,
				City,
				Country,
				Extension,
				FirstName, 
				HireDate,
				HomePhone, 
				LastName,
				Photo, 
				PostalCode, 
				Region, 
				Salary, 
				Title,
				BirthDate,
				EmployeeID,
				Notes, 
				PhotoPath,
				ReportsTo,
				TitleOfCourtesy
			}
		},

		collection Orders {
			fields {
				_id,
				EmployeeRef,
				Freight,
				OrderDate, 
				RequiredDate,
				ShipAddress,
				customer[1]{
					ContactName,
					CustomerID
				},
				OrderID,
				ShipCity,
				ShipCountry,
				ShipName,
				ShipPostalCode,
				ShipRegion,
				ShipVia,
				ShippedDate
			}
		}, 

		collection Suppliers {
			fields {
				_id,
				Address,
				City, 
				CompanyName,
				ContactName, 
				ContactTitle,
				Country,
				Fax,
				HomePage,
				Phone,
				PostalCode,
				Region, 
				SupplierID
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
				OrderID,
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
		        	CustomerRef -> reldata.Shippers.ShipperID
		                EmployeeRef -> reldata.Customers.CustomerID
		                ShipVia -> reldata.Shippers.ShipperID
		        }
		}
		
		
		table Products {
			columns{
				ProductID,
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
		}

        	table ProductsInfo{
			columns{
				ProductID,
		                ProductName,
		                SupplierRef,
		                CategoryRef,
		                QuantityPerUnit,
		                UnitPrice,
		                ReorderLevel,
		                Discontinued
			}
		}

        	table Region{
			columns{
				RegionID,
                		RegionDescription
			}
		}

        	table Shippers{
			columns{
				ShipperID,
                		CompanyName,
                		Phone
			}
		}

        	table Suppliers{
			columns{
				SupplierID,
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
		}

        	table Territories{
			columns{
				TerritoryID,
		                TerritoryDescription,
		                RegionRef
			}
            		references {
				RegionRef -> reldata.Region.RegionID
            		}
		}
	}
}

