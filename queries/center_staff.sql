--Марказ ходимлари кесимида ҳисобот
select s.risk_name, s.vaz_code, s.vaz_name, f.foydalanuvchi_soni, s.user_fio, max(s.detected_date) oxitgi_ishlagan,
count(1) aniqlangan,
sum(case when s.qayerdan = 0 and s.qayerga = 1 then 1 else 0 end) as nazoratga_olinmagan,
sum(case when s.qayerdan > 0 and s.qayerga > 0 then 1 else 0 end) as nazoratga_olingan,
sum(case when s.harakat_id = 12 and s.qayerga = 1 then 1 else 0 end) as nazoratdan_echishga_kelgan,
sum(case when s.qayerga = 0 then 1 else 0 end) as nazoratdan_echilgan,
--10
sum(case when now()::date - s.detected_date<=16 then 1 else 0 end) as aniqlangan_16,
sum(case when s.qayerdan = 0 and s.qayerga = 1 and now()::date - s.harakat_vaqti::date<=16 then 1 else 0 end) as nazoratga_olinmagan_16,
sum(case when s.qayerdan > 0 and s.qayerga > 0 and now()::date - s.harakat_vaqti::date<=16 then 1 else 0 end) as nazoratga_olingan_16,
sum(case when s.harakat_id = 12 and s.qayerga = 1 and now()::date - s.harakat_vaqti::date<=16 then 1 else 0 end) as nazoratdan_echishga_kelgan_16,
sum(case when s.qayerga = 0 and now()::date - s.harakat_vaqti::date<=16 then 1 else 0 end) as nazoratdan_echilgan_16,
--10-30
sum(case when now()::date - s.detected_date ::date>16 and now()::date - s.detected_date ::date<=30 then 1 else 0 end) as aniqlangan_10_30,
sum(case when s.qayerdan = 0 and s.qayerga = 1 and now()::date - s.harakat_vaqti ::date>16 and now()::date - s.harakat_vaqti ::date<=30 then 1 else 0 end) as nazoratga_olinmagan_10_30,
sum(case when s.qayerdan > 0 and s.qayerga > 0 and now()::date - s.harakat_vaqti ::date>16 and now()::date - s.harakat_vaqti ::date<=30 then 1 else 0 end) as nazoratga_olingan_10_30,
sum(case when s.harakat_id = 12 and s.qayerga = 1 and now()::date - s.harakat_vaqti ::date>16 and now()::date - s.harakat_vaqti ::date<=30 then 1 else 0 end) as nazoratdan_echishga_kelgan_10_30,
sum(case when s.qayerga = 0 and now()::date - s.harakat_vaqti ::date>16 and now()::date - s.harakat_vaqti ::date<=30 then 1 else 0 end) as nazoratdan_echilgan_10_30,
--1-6 ой
sum(case when now()::date - s.detected_date ::date>30 and now()::date - s.detected_date ::date<=180 then 1 else 0 end) as aniqlangan_30_180,
sum(case when s.qayerdan = 0 and s.qayerga = 1 and now()::date - s.harakat_vaqti ::date>30 and now()::date - s.harakat_vaqti ::date<=180 then 1 else 0 end) as nazoratga_olinmagan_30_180,
sum(case when s.qayerdan > 0 and s.qayerga > 0 and now()::date - s.harakat_vaqti ::date>30 and now()::date - s.harakat_vaqti ::date<=180 then 1 else 0 end) as nazoratga_olingan_30_180,
sum(case when s.harakat_id = 12 and s.qayerga = 1 and now()::date - s.harakat_vaqti ::date>30 and now()::date - s.harakat_vaqti ::date<=180 then 1 else 0 end) as nazoratdan_echishga_kelgan_30_180,
sum(case when s.qayerga = 0 and now()::date - s.harakat_vaqti ::date>30 and now()::date - s.harakat_vaqti ::date<=180 then 1 else 0 end) as nazoratdan_echilgan_30_180,
--6-12 ой
sum(case when now()::date - s.detected_date ::date>180 and now()::date - s.detected_date ::date<=365 then 1 else 0 end) as aniqlangan_180_365,
sum(case when s.qayerdan = 0 and s.qayerga = 1 and now()::date - s.harakat_vaqti ::date>180 and now()::date - s.harakat_vaqti ::date<=365 then 1 else 0 end) as nazoratga_olinmagan_180_365,
sum(case when s.qayerdan > 0 and s.qayerga > 0 and now()::date - s.harakat_vaqti ::date>180 and now()::date - s.harakat_vaqti ::date<=365 then 1 else 0 end) as nazoratga_olingan_180_365,
sum(case when s.harakat_id = 12 and s.qayerga = 1 and now()::date - s.harakat_vaqti ::date>180 and now()::date - s.harakat_vaqti ::date<=365 then 1 else 0 end) as nazoratdan_echishga_kelgan_180_365,
sum(case when s.qayerga = 0 and now()::date - s.harakat_vaqti ::date>180 and now()::date - s.harakat_vaqti ::date<=365 then 1 else 0 end) as nazoratdan_echilgan_180_365,
--1 йил
sum(case when now()::date - s.detected_date ::date>365 then 1 else 0 end) as aniqlangan_365,
sum(case when s.qayerdan = 0 and s.qayerga = 1 and now()::date - s.harakat_vaqti ::date>365 then 1 else 0 end) as nazoratga_olinmagan_365,
sum(case when s.qayerdan > 0 and s.qayerga > 0 and now()::date - s.harakat_vaqti ::date>365 then 1 else 0 end) as nazoratga_olingan_365,
sum(case when s.harakat_id = 12 and s.qayerga = 1 and now()::date - s.harakat_vaqti ::date>365 then 1 else 0 end) as nazoratdan_echishga_kelgan_365,
sum(case when s.qayerga = 0 and now()::date - s.harakat_vaqti ::date>365 then 1 else 0 end) as nazoratdan_echilgan_365
from
(
	select u.detected_date, u."event", p.name_cr risk_name, mt.name_cr vaz_name, es.name_cr status_name, u.completed_date, u."degree", u.degree_from_user, u.is_approved, u.prevent, u.is_approved_user, u.harakat_id, u.harakat_vaqti, u.kim_id, u.kimga_id, u.kimgacha, u.qayerdan, u.qayerga, u.k_inn1, u.k_inn2, u.k_sum_k, u.k_t_sum_k, u.send_time, u.n_status_id, u.vaz_code, u.owner_id,
	au.last_name || ' ' || au.first_name || ' ' || au.middle_name user_fio
	from
	(
		select u.id, u.detected_date, u."event", u.profile_id, u.status_id, u.completed_date, u."degree", u.district, u.expanded_by, u.organization, u.region_id, u.action_id, u.degree_from_user, u.is_approved, u.prevent, u.is_approved_user, u.harakat_id, u.harakat_vaqti, u.kim_id, u.kimga_id, u.kimgacha, u.qayerdan, u.qayerga, u.k_inn1, u.k_inn2,
		case when p.hidden_sums is false then u.k_sum_k else 0 end k_sum_k,
		case when p.hidden_sums is false then u.k_t_sum_k else 0 end k_t_sum_k,
		u.send_time, u.n_status_id, u.vaz_code, u.owner_id, u."structure", u.module_type, p.*
		from public.untracked u
		left join
		(
			select p.id, p.name_cr profile_name_cr, p.hidden_profile, p.hidden_sums, g.name_cr as g_name
			from public.profiles p
			left join public."groups" g on p.group_id = g.id
		) p on u.profile_id=p.id
		where p.hidden_profile is false
	) u
	left join public.profiles p on u.profile_id = p.id
	left join public.event_status es on u.status_id = es.id
	left join public.account_user au on p.masul_id = au.id
	left join public.ministry_trees mt on u.vaz_code = mt.inn
)s
left join
(
	select m.katta_otasi, count(1) as foydalanuvchi_soni
	from public.account_user u
	left join ministry_trees m on u.my_mehnat_inn = m.inn
	where u.is_active is true --and m.inn = '200541754'
	group by m.katta_otasi
)f on s.vaz_code=f.katta_otasi
group by s.risk_name, s.vaz_code, s.vaz_name, f.foydalanuvchi_soni, s.user_fio;
