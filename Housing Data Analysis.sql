USE COVID

SELECT * FROM Housing

UPDATE Housing
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE Housing
ADD Converted_Date DATE

UPDATE Housing
SET Converted_Date = CONVERT(date,SaleDate)

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS City
FROM
Housing

ALTER TABLE Housing
ADD Address TEXT

ALTER TABLE Housing
ADD City TEXT

SELECT * FROM Housing

UPDATE Housing
SET Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

UPDATE Housing
SET City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT 
OwnerAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS Owner_address,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS Owner_city,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS Owner_state
FROM 
Housing 
WHERE 
OwnerAddress IS NOT NULL

ALTER TABLE Housing
ADD Owner_address TEXT

ALTER TABLE Housing
ADD Owner_city TEXT

ALTER TABLE Housing
ADD Owner_state TEXT

UPDATE Housing
SET Owner_address = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

UPDATE Housing
SET Owner_city = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

UPDATE Housing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT
*
FROM
Housing
WHERE
OwnerAddress IS NOT NULL

SELECT
SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant 
	END,
COUNT(*) AS Total_records
FROM
Housing
GROUP BY
SoldAsVacant

UPDATE Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

WITH Duplicate_records AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM
Housing
)
SELECT *
FROM Duplicate_records
WHERE row_num > 1
ORDER BY PropertyAddress

ALTER TABLE Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

SELECT * FROM Housing