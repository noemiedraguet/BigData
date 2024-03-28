physical schemas { 
	
	document schema mymongo {
		collection actorCollection {
			fields {
				id,
				fullname,
				birthyear,
				deathyear,
				movies[0-N]{
					id,
					title,
					rating[1]{
						rate,
						numberofvotes
					}
				}
			}
		}
	} , 

		collection 	Customers {
			fields {
				_id,
				Address,
				City,
				CompanyName,
				ContactTitle,
				Country,
				Fax, 
				ID, 
				Phone, 
				PostalCode, 
				Region
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
				customer,
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
		},






		key value schema myredis {
		kvpairs shippers {
			key : "shippers:"[id],
			value : string{
				COMPANYNAME,
				PHONE
			} , 
		kvpairs stockinfo {
			key : "products:"[id],
			value : hash{
				UnitsInStock,
				UnitsOnOrder
			}
		}
	}

}
}

