--UPDATE listings
--SET cleaning_fee = REPLACE(CAST(cleaning_fee AS VARCHAR(MAX)), '$', '')
with lstngs as (select id, name, property_type, room_type, amenities, beds, bed_type, bathrooms,house_rules, accommodates, minimum_nights, host_is_superhost, 
street, host_neighbourhood, review_scores_rating, security_deposit, extra_people, cleaning_fee
from listings
where minimum_nights<=3 
and beds <=3 
and is_location_exact like 't'
and lower(CAST(property_type AS NVARCHAR(255))) <> 'boat'),
-- join calendar and listings
dataset as (select calendar.[date], lstngs.id, --lstngs.[name], 
lstngs.property_type, lstngs.room_type, lstngs.review_scores_rating, calendar.price, lstngs.extra_people, lstngs.cleaning_fee,
lstngs.beds, lstngs.bed_type, lstngs.bathrooms, lstngs.amenities, lstngs.house_rules 
from calendar
right join lstngs
on calendar.listing_id = lstngs.id
where lstngs.host_is_superhost like 't')
select * from dataset
where dataset.[date] is not null
order by dataset.[date], dataset.price, dataset.beds, dataset.review_scores_rating desc