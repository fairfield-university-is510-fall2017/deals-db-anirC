#2. Indicate that we are using the deals database
USE deals;  
# Execute a test query  
SELECT *
FROM Companies
WHERE CompanyName like "%Inc.";

#3. Select companies sorted by CompanyName
SELECT *
FROM Companies
ORDER BY CompanyID;

#5. Use a where clause to merge data from multiple tables
select DealName,PartNumber, DollarValue from Deals,DealParts where Deals.DealID = DealParts.DealID;

#6. Repeat the multi-table query but using JOIN ON instead of WHERE to match records in the two tables.
select DealName,PartNumber, DollarValue from Deals join DealParts on (Deals.DealID = DealParts.DealID);

#7. Study the database schema to see more opportunities to join table.
Select DealName, Rolecode, CompanyName 
FROM COMPANIES JOIN Players ON (Companies.CompanyID = Players.CompanyID)
			   JOIN deals ON (Players.DealID = Deals.DEalID) Order by DealName;
               
#8. Create a reusable view based on the previous select query.
# Create a view that matches companies to deals
CREATE View CompanyDeals AS
SELECT DealName,RoleCode,CompanyName
FROM Companies
	JOIN Players ON (Companies.CompanyID = Players.CompanyID)
	JOIN Deals ON (Players.DealID = Deals.DealID)
ORDER BY DealName;
# A test of the CompanyDeals view
SELECT * FROM CompanyDeals;

#9. Create a view named DealValues that lists the DealID, total dollar value and number of parts for each deal.
CREATE View DealValues AS
SELECT Deals.DealID,sum(Dollarvalue) as 'Total Dollar Value', Count(partnumber) As 'Number of Parts'
FROM Deals JOIN DealParts ON (Deals.DealID = DealParts.DealID) group by Deals.DealID
ORDER BY Deals.DealID;
# A test of the CompanyDeals view
SELECT * FROM DealValues;		

#10. Create a view named DealSummary that lists the DealID, DealName, number of players, total dollar value, and number of parts for each deal.
CREATE View DealSummary AS
SELECT Deals.DealID,Deals.DealName,sum(Dollarvalue) as 'Total Dollar Value', Count(partnumber) As 'Number of Parts', count(playerID) As 'Number of Players'
FROM Deals JOIN DealParts ON (Deals.DealID = DealParts.DealID)
		   JOIN Players ON (Deals.DealID = Players.DealID) 	
group by Deals.DealID
ORDER BY Deals.DealID;
#Bonus: use a subquery to construct a comma-separated list of deal types for each deal. 
select DealTypes.typecode from DealTypes where DealTypes.DealID in (select DealID from DealSummary);


#11. Create a view called DealsByType that lists TypeCode, number of deals, and total value of deals for each deal type.
CREATE View DealsByType AS
SELECT DealTypes.typecode,count(Deals.DealID) as 'Number of Deals', sum(Dollarvalue) as 'Total Dollar Value'
FROM Deals JOIN DealParts ON (Deals.DealID = DealParts.DealID)
			RIGHT JOIN DealTypes ON (Deals.DealID = DealTypes.DealID) 	
group by DealTypes.typecode
ORDER BY count(Deals.DealID) desc

#12. Create a view called DealPlayers that lists the CompanyID, Name, and Role Code for each deal. Sort the players by the RoleSortOrder.
CREATE View DealPlayers AS
SELECT Deals.DealID,Companies.CompanyID,Companies.CompanyName, Players.RoleCode
FROM PLAYERS JOIN Deals ON (players.DealID = Deals.DealID)
			JOIN Companies ON (players.CompanyID = Companies.CompanyID)
            JOIN rolecodes ON (players.rolecode = rolecodes.rolecode)
ORDER BY rolecodes.RoleSortorder;
# A test of the CompanyDeals view
SELECT * FROM DealPlayers;	

#13. Create a view called DealsByFirm that lists the FirmID, Name, number of deals, and total value of deals for each firm.
CREATE View DealsByFirm AS
SELECT FIRMS.FIRMID,FIRMS.name as "Firm Name", count(players.DealID) as 'Num of Deals', sum(dealvalues.`Total Dollar Value`) 'Total value'
FROM FIRMS JOIN playersupports ON (FIRMS.FIRMID = playersupports.FIRMID)
			JOIN players ON (players.PlayerID = playersupports.PlayerID)
            JOIN dealvalues on (dealvalues.dealID = players.DealID)
GROUP BY FIRMS.FirmID;
# A test of the CompanyDeals view
SELECT * FROM DealsByFirm;	