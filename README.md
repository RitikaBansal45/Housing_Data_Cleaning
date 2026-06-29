# Housing Data Cleaning

## Business Problem
A Nashville housing dataset contained several data quality issues: datetimes instead of dates, full addresses in a single column, inconsistent categorical values (Y/N vs Yes/No), and duplicate records. The data was not usable for analysis or reporting until cleaned and standardised.

## SQL Techniques Used
•	CONVERT for date standardisation	
•	ALTER TABLE + ADD (new derived columns)	
•	SUBSTRING + CHARINDEX (address parsing)
•	PARSENAME + REPLACE (owner address split)	
•	CASE WHEN for value standardisation	
•	ROW_NUMBER() OVER with PARTITION BY (duplicate detection)
•	ALTER TABLE DROP COLUMN (removing redundant columns)

## Key Queries Performed
•	Convert SaleDate from datetime to date format
•	Parse PropertyAddress into Address + City using SUBSTRING/CHARINDEX
•	Parse OwnerAddress into 3 columns using PARSENAME + REPLACE
•	Standardise SoldAsVacant: Y→Yes, N→No
•	Detect duplicates with ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference)
•	Drop redundant columns (OwnerAddress, TaxDistrict, PropertyAddress, SaleDate)

## Key Insights
•	Multiple records shared identical ParcelID, PropertyAddress, SalePrice, and SaleDate — confirmed duplicates
•	SoldAsVacant field had 4 inconsistent values (Y, N, Yes, No) — standardised to 2
•	Owner and property addresses were unusable for geographic analysis until parsed
•	Cleaning revealed the dataset was significantly larger than initially usable rows suggested

## Recommendations
•	Implement data entry validation at source to prevent Y/N vs Yes/No inconsistency
•	Add a composite unique key constraint on (ParcelID + SaleDate + SalePrice) to prevent future duplicates
•	Store address components in separate columns from point of entry for easier downstream analysis
