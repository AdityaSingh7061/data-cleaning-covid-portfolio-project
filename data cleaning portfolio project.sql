select *
from NashvilleHousing

--cleaning data in sql queries
--standardise date format

select saledate
from NashvilleHousing


update NashvilleHousing
set SaleDate=CONVERT(date,saledate)


select saledate,CONVERT(date,saledate)
from NashvilleHousing

alter table nashvillehousing
add saledateconverted date;

update NashvilleHousing
set SaleDateconverted=convert(date,saledate)

-----------------------------------------------------------------------------------------------

--populate property address data

select propertyaddress
from NashvilleHousing
where PropertyAddress is not null 

select *
from NashvilleHousing
--where propertyaddress is not null
order by ParcelID

select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress,isnull( a.PropertyAddress,b.propertyaddress)
from NashvilleHousing a
join NashvilleHousing b
        on a.ParcelID=b.ParcelID
		and a.[UniqueID ]<>b.[UniqueID ]
   where a.PropertyAddress is null


   update a
   set PropertyAddress=isnull(a.propertyaddress,b.propertyaddress)
   from NashvilleHousing a
   join NashvilleHousing b
      on a.ParcelID=b.ParcelID
	  and a.[UniqueID ]<>b.[UniqueID ]
	where a.PropertyAddress is null 

	select distinct *
	from NashvilleHousing
	where PropertyAddress is  not null

	---------------------------------------------------------------------------------------

--Breaking out Address into individual Columns(address,city,state)

select propertyaddress
from NashvilleHousing

select SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)as address,
SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))as address
from NashvilleHousing

alter table nashvillehousing
add propertysplitaddress Nvarchar(255);

update NashvilleHousing
set PropertysplitAddress = SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)

alter table nashvillehousing
add propertysplitcity nvarchar(255)

update NashvilleHousing
set propertysplitcity = SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))


select * 
from NashvilleHousing
----------------------------------------------------------------------------------------------------------

--Changing owner Address

select OwnerAddress
from NashvilleHousing

select PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from nashvillehousing

alter table nashvillehousing
add ownersplitaddress nvarchar(255)

update NashvilleHousing
set OwnersplitAddress = parsename(replace(owneraddress,',','.'),3)

select *
from NashvilleHousing

alter table nashvillehousing
add ownersplitcity nvarchar(255)

update NashvilleHousing
set ownersplitcity = parsename(replace(owneraddress,',','.'),2)

select *
from NashvilleHousing

alter table nashvillehousing
add ownersplitstate nvarchar(255)

update NashvilleHousing
set ownersplitstate = parsename(replace(owneraddress,',','.'),1)


----------------------------------------------------------------------------------------------------------

--Change Y and N to yes and no in 'Sold as vacant' field

select distinct(soldasvacant) , count(soldasvacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

select soldasvacant,
       case when soldasvacant='y' then 'yes'
	   when soldasvacant = 'n' then 'no'
	   else soldasvacant
	   end
	from NashvilleHousing


update NashvilleHousing
set SoldAsVacant= Case when soldasvacant='y' then 'yes'
                   when SoldAsVacant='n' then 'no'
				  else SoldAsVacant
		------------------------------------------------------------------------------
		
--delete unused columns

alter table nashvillehousing
drop column owneraddress,taxdistrict,propertyaddress,saledate

select *
from NashvilleHousing

-------------------------------------------------------------------------------------------------

--remove duplicates
with rownumcte as(
select *,
      ROW_NUMBER()over(
	  partition by parcelid,
	               legalreference,
				   propertysplitaddress,
				   saledateconverted,
				   saleprice
				   order by uniqueid
				   )row_num
		from NashvilleHousing
)
delete
from rownumcte
where row_num >1
order by PropertysplitAddress

select *
from NashvilleHousing

------------------------------------------------------------------------------------------
