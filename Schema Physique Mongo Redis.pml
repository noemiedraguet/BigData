physical schemas { 
	
	document schema mymongo {
		collection 	Customers {
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

		collection 	Employees {
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

		collection 	Orders {
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

		collection 	Suppliers {
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
	}
}

