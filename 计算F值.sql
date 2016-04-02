select sum((1-d.error)*e.weight) from
	(select artist_id, sqrt(avg(error)) as error from
		(select a.artist_id,a.ds,pow((b.times-a.times)/greatest(a.times,1),2) as error from 
			tianchi.artist_day_plays a 
			join 
			tianchi.predict_artist_day_plays b 
			on a.artist_id=b.artist_id and a.ds=b.ds and a.ds>=20150701
		) c
		group by artist_id
	) d 
	join
	(
		select artist_id,sqrt(sum(times)) as weight from tianchi.artist_day_plays group by artist_id
	) e 
	on d.artist_id=e.artist_id 
