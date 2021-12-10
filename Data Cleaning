
/*
Cleaning Data in SQL Queries
*/
use PortfolioProjects

Select *
From housing_data

-- Standardize Date Format


Select saleDate, CONVERT(Date,SaleDate)
From housing_data

ALTER TABLE housing_data
Add SaleDateConverted Date;

Update housing_data
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address data


Select *
From housing_data
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From housing_data a
JOIN housing_data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From housing_data a
JOIN housing_data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)



Select PropertyAddress
From housing_data
--Where PropertyAddress is null
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From housing_data

ALTER TABLE housing_data
Add PropertySplitAddress Nvarchar(100);


Update housing_data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housing_data
Add PropertySplitCity Nvarchar(100);

Update housing_data
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From housing_data
-- Another way of breaking strings
Select OwnerAddress
From housing_data

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From housing_data



ALTER TABLE housing_data
Add OwnerSplitAddress Nvarchar(255);

Update housing_data
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE housing_data
Add OwnerSplitCity Nvarchar(255);

Update housing_data
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE housing_data
Add OwnerSplitState Nvarchar(255);

Update housing_data
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From housing_data



-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From housing_data
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From housing_data



Update	housing_data
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   
-- Remove Duplicates


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housing_data
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress	

Select *
From housing_data

-- Delete Unused Columns

Select *
From housing_data

ALTER TABLE housing_data
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

