


SELECT *
FROM PortfolioProject4..NashvilleHousing;


-- Clean up the DATE format

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM PortfolioProject4..NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate);

ALTER TABLE NashvilleHousing
ADD SalesDateConverted Date; 

UPDATE NashvilleHousing
SET SalesDateConverted = CONVERT(Date,SaleDate);

SELECT SalesDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject4..NashvilleHousing;

ALTER TABLE NashvilleHousing
RENAME COLUMN SalesDateConverted TO SaleDateConverted;


-- Populate the property address

SELECT PropertyAddress
FROM PortfolioProject4..NashvilleHousing;

SELECT *
FROM PortfolioProject4..NashvilleHousing
WHERE PropertyAddress IS NULL;

SELECT a.ParcelID, a.PropertyAddress, b.PropertyAddress
FROM PortfolioProject4..NashvilleHousing a
JOIN PortfolioProject4..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

SELECT a.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject4..NashvilleHousing a
JOIN PortfolioProject4..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject4..NashvilleHousing a
JOIN PortfolioProject4..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;


-- Breaking out the address into multiple columns

SELECT PropertyAddress
FROM PortfolioProject4..NashvilleHousing;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
FROM PortfolioProject4..NashvilleHousing;

ALTER TABLE PortfolioProject4..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(250);

UPDATE PortfolioProject4..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1);

ALTER TABLE PortfolioProject4..NashvilleHousing
ADD PropertySplitCity NVARCHAR(250);

UPDATE PortfolioProject4..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM PortfolioProject4..NashvilleHousing;

SELECT OwnerAddress
FROM PortfolioProject4..NashvilleHousing;

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM PortfolioProject4..NashvilleHousing;

ALTER TABLE PortfolioProject4..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(250);

UPDATE PortfolioProject4..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE PortfolioProject4..NashvilleHousing
ADD OwnerSplitCity NVARCHAR(250);

UPDATE PortfolioProject4..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE PortfolioProject4..NashvilleHousing
ADD OwnerSplitState NVARCHAR(250);

UPDATE PortfolioProject4..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


-- Updating SoldAsVacant

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject4..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject4..NashvilleHousing;

UPDATE PortfolioProject4..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;


-- Removing Duplicates

WITH RowNumCTE as (
SELECT *,
	ROW_Number() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProject4..NashvilleHousing
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1;


-- Delete Unused Columns

SELECT *
FROM PortfolioProject4..NashvilleHousing;

ALTER TABLE PortfolioProject4..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;




