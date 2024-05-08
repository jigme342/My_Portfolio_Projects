--Cleaning Data in SQL Queries

SELECT *
FROM [Nashville Housing];

--Populate Property Address Data

SELECT *
FROM [Nashville Housing]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;



--Using ISNULL and UPDATE to populate the blank property address of the data that has the same parcel id but different unique id

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Nashville Housing] a
JOIN [Nashville Housing] b
     ON a.ParcelID = b.ParcelID
	 AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is NULL;



UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Nashville Housing] a
JOIN [Nashville Housing] b
     ON a.ParcelID = b.ParcelID
	 AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is NULL;


--Breaking out Address into Individual Columns(Address, City, State)

SELECT PropertyAddress
FROM [Nashville Housing];

--Method 1

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM [Nashville Housing];


ALTER TABLE [Nashville Housing]
ADD PropertySplitAddress NVARCHAR(255);

UPDATE [Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);


ALTER TABLE [Nashville Housing]
ADD PropertySplitCity NVARCHAR(255);

UPDATE [Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

SELECT * 
FROM [Nashville Housing];

--Method 2


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM [Nashville Housing];


ALTER TABLE [Nashville Housing]
ADD OwnerSplitAddress NVARCHAR(255);;

UPDATE [Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3);


ALTER TABLE [Nashville Housing]
ADD OwnerSplitCity NVARCHAR(255);

UPDATE [Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2);


ALTER TABLE [Nashville Housing]
ADD OwnerSplitState NVARCHAR(255);

UPDATE [Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1);


SELECT *
FROM [Nashville Housing];



--Change 1 and 0 to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsvacant), COUNT(SoldAsVacant)
FROM [Nashville Housing]
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant;


SELECT SoldAsVacant,
CASE
    WHEN SoldAsVacant = 0 THEN 'No'
	ELSE 'Yes'
END
FROM [Nashville Housing];

UPDATE [Nashville Housing]
SET SoldAsVacant = 
    CASE 
        WHEN SoldAsVacant = 0 THEN 'No'
        ELSE 'Yes'
    END 
FROM [Nashville Housing];



--Removing Duplicates


WITH RowNumCTE AS(
SELECT *,
       ROW_NUMBER() OVER (
	   PARTITION BY ParcelID,
	                PropertyAddress,
					SalePrice,
					SaleDAte,
					LegalReference
					ORDER BY 
					   UniqueID
					   ) row_num

FROM [Nashville Housing]
--ORDER BY ParcelID
 )
 DELETE 
 FROM RowNumCTE
 WHERE row_num > 1;

-SELECT *
 FROM RowNumCTE
 WHERE row_num > 1
 ORDER BY PropertyAddress;



--Deleting Unused Columns

SELECT *
FROM [Nashville Housing];


ALTER TABLE [Nashville Housing]
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict;