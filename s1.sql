20150301-20150830
训练集20150301-20150630:0~121/1~122
验证集20150701-20150830:122~182/123~183
--------------------------------------------------
create database tianchi;
use tianchi;
--导入数据
load data local infile 'E:/github/tianchi/data/mars_tianchi_songs.csv' into table mars_tianchi_songs fields terminated by ','
enclosed by '"'
lines terminated by '\n'
(song_id,artist_id,publish_time,song_init_plays,lang,gender)

load data local infile 'E:/github/tianchi/data/mars_tianchi_user_actions.csv' into table mars_tianchi_user_actions fields terminated by ','
enclosed by '"'
lines terminated by '\n'
(user_id,song_id,gmt_create,action_type,ds)


song_id,artist_id,publish_time,song_init_plays,lang,gender
行数：10842
CREATE TABLE `mars_tianchi_songs` (
  `song_id` text not null,
  `artist_id` text not null,
  `publish_time` int(11) not null,
  `song_init_plays` bigint(20) not null,
  `lang` int(11) not null,
  `gender` int(11) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


user_id,song_id,gmt_create,action_type,ds
行数：5652232
CREATE TABLE `mars_tianchi_user_actions` (
  `user_id` text not null,
  `song_id` text not null,
  `gmt_create` bigint(20) not null,
  `action_type` int(11) not null,
  `ds` int(11) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


----------------------------------------

--生成每个song在第k天的播放量
drop table if exists song_day_plays;
create table song_day_plays as
select song_id,ds,count(*) as times from mars_tianchi_user_actions
where action_type=1
group by song_id,ds
;

--生成每个artist在第k天的播放量
drop table if exists artist_day_plays;
create table artist_day_plays as
select d.artist_id,d.ds,
	(case when (c.times is null) then 0 else c.times end) as times
from
	(select a.artist_id,b.ds,sum(b.times) as times
	from
		(select distinct artist_id,song_id from 
			mars_tianchi_songs
		)a
		left outer join
		song_day_plays b
		on a.song_id=b.song_id
	group by a.artist_id,b.ds
	) c 
	right outer join 
	(select artist_id,ds from
		(select distinct artist_id from mars_tianchi_songs) e,
		(select distinct ds from song_day_plays) f
	) d 
	on c.artist_id=d.artist_id and c.ds=d.ds 
;

--生成每个artist的播放量的降序排列
drop table if exists artist_idx;
create table artist_idx as
select (@rowNum:=@rowNum+1) as idx,artist_id,times
from 
	(select artist_id,sum(times) as times
		from artist_day_plays
		group by artist_id
	) a,
	(select (@rowNum :=0) ) b
order by times desc,artist_id asc
;
--生成每个song的播放量的降序排列
drop table if exists song_idx;
create table song_idx as
select (@rowNum:=@rowNum+1) as idx,song_id,times
from 
	(select song_id,sum(times) as times
		from song_day_plays
		group by song_id
	) a,
	(select (@rowNum :=0) ) b
order by times desc,song_id asc
;


--预测表tianchi.predict_artist_day_plays 

--method1：根据训练集20150301-20150630的平均播放量，预测验证集20150701-20150830
--F='5097.0695694789965'
drop table if exists predict_artist_day_plays;
create table predict_artist_day_plays as
select a.artist_id,b.ds,a.times from
	(select artist_id,avg(times) as times from artist_day_plays
	where ds<20150701
	group by artist_id
	) a
	join
	(select artist_id,ds from artist_day_plays
	where ds>=20150701
	) b 
	on a.artist_id=b.artist_id
;

--method2：根据对训练集一阶多项式拟合，预测验证集20150701-20150830
--F='3965.3461045839686'
drop table if exists predict_artist_day_plays;
create table predict_artist_day_plays as
select b.artist_id,b.ds,
	b1+a1*datediff(str_to_date(cast(ds as char),'%Y%m%d'),str_to_date(cast(20150301 as char),'%Y%m%d')) as times
from
	(select artist_id,
		(n*s3-s1*s2)/(n*s4-s1*s1) as a1,
		(s4*s2-s3*s1)/(n*s4-s1*s1) as b1
	from
		(select artist_id,
			cast(sum(x) as decimal) as s1,
			cast(sum(y) as decimal) as s2,
			cast(sum(x*y) as decimal) as s3,
			cast(sum(x*x) as decimal) as s4,
			cast(count(*) as decimal) as n
		from
			(select artist_id,
				datediff(str_to_date(cast(ds as char),'%Y%m%d'),str_to_date(cast(20150301 as char),'%Y%m%d')) as x,
				cast(times as decimal) as y
			from artist_day_plays
			where ds<20150701
			) aa1
		group by artist_id
		) aa2
	) a
	join
	(select artist_id,ds from artist_day_plays
	where ds>=20150701
	) b 
	on a.artist_id=b.artist_id
	
--method3：根据对训练集的song进行一阶多项式拟合，预测验证集20150701-20150830
--F='4391.425924601521'
drop table if exists predict_artist_day_plays;
create table predict_artist_day_plays as
select d.artist_id,c.ds,sum(c.times) as times from
	(select b.song_id,b.ds,
		b1+a1*datediff(str_to_date(cast(ds as char),'%Y%m%d'),str_to_date(cast(20150301 as char),'%Y%m%d')) as times
	from
		(select song_id,
			(n*s3-s1*s2)/(n*s4-s1*s1) as a1,
			(s4*s2-s3*s1)/(n*s4-s1*s1) as b1
		from
			(select song_id,
				cast(sum(x) as decimal) as s1,
				cast(sum(y) as decimal) as s2,
				cast(sum(x*y) as decimal) as s3,
				cast(sum(x*x) as decimal) as s4,
				cast(count(*) as decimal) as n
			from
				(select song_id,
					datediff(str_to_date(cast(ds as char),'%Y%m%d'),str_to_date(cast(20150301 as char),'%Y%m%d')) as x,
					cast(times as decimal) as y
				from song_day_plays
				where ds<20150701
				) aa1
			group by song_id
			) aa2
		) a
		join
		(select song_id,ds from song_day_plays
		where ds>=20150701
		) b 
		on a.song_id=b.song_id
	) c
	join
	(select artist_id,song_id from mars_tianchi_songs) d
	on c.song_id=d.song_id
group by c.ds,d.artist_id


--判断结果
select sum((1-d.error)*e.weight) from
	(select artist_id, sqrt(avg(error)) as error from
		(select a.artist_id,a.ds,pow((b.times-a.times)/greatest(a.times,1),2) as error from 
			artist_day_plays a 
			join 
			predict_artist_day_plays b 
			on a.artist_id=b.artist_id and a.ds=b.ds and a.ds>=20150701
		) c
		group by artist_id
	) d 
	join
	(
		select artist_id,sqrt(sum(times)) as weight from artist_day_plays
			where ds>=20150701
		group by artist_id
	) e 
	on d.artist_id=e.artist_id 


--统计有两个以上artist的song。
select song_id,nums from
	(select song_id,count(*) as nums
		from mars_tianchi_songs
		group by song_id
	) a 
	where nums>1



--每个song在inter_time之前的各项特征

--7天内的unique user
set @inter_time_train=92;
set @inter_time_test=@inter_time_train+45;

drop table if exists song_f1_train;
create table song_f1_train as 
select song_id, count(distinct user_id) as f1
from mars_tianchi_user_actions
where action_type='1' 
and datediff(str_to_date(cast(ds as char),'%Y%m%d'),str_to_date(cast(20150301 as char),'%Y%m%d'))<=@inter_time_train
and datediff(str_to_date(cast(ds as char),'%Y%m%d'),str_to_date(cast(20150301 as char),'%Y%m%d'))>@inter_time_train-7
group by song_id
;












