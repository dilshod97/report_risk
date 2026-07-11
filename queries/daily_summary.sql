--Қунлик умумий ҳисобот
select u.vaz_code, m.katta_otasi_nomi, p.description, p.g_name,
-- u.organization, u.profile_id,
--Жами аниқланган сумма
count(1) as all_count,
sum(u.k_sum_k) as all_sums,
--Қизил ранг
sum(case when u."degree" = 1 then 1 else 0 end) as degree_qizil_count,
sum(case when u."degree" = 1 then u.k_sum_k else 0 end) as degree_qizil_sums,
--Сариқ ранг
sum(case when u."degree" = 2 then 1 else 0 end) as degree_sariq_count,
sum(case when u."degree" = 2 then u.k_sum_k else 0 end) as degree_sariq_sums,
--яшил ранг
sum(case when u."degree" = 3 then 1 else 0 end) as degree_yashil_count,
sum(case when u."degree" = 3 then u.k_sum_k else 0 end) as degree_yashil_sums,
-- ранг йўқ
sum(case when u."degree" is null or u."degree"=0 then 1 else 0 end) as degree_ajratilmagan_count,
sum(case when u."degree" is null or u."degree"=0 then u.k_sum_k else 0 end) as degree_ajratilmagan_sums,
-- Назоратда 'Назоратда' -> '78158aa6-9881-4810-8378-95968fc81b12'
sum(case when u.qayerdan>=1 and u.qayerga>=1 then 1 else 0 end) as nazoratda,
sum(case when u.qayerdan>=1 and u.qayerga>=1 then u.k_sum_k else 0 end) as nazoratda_sums,
-- Назоратда палата 'Назоратда' -> '78158aa6-9881-4810-8378-95968fc81b12'
sum(case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 then 1 else 0 end) as nazoratda_palata,
sum(case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 then u.k_sum_k else 0 end) as nazoratda_palata_sums,
-- Назоратда палата 10 кунгача 'Назоратда' -> '78158aa6-9881-4810-8378-95968fc81b12'
sum(case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 and u.harakat_vaqti + INTERVAL '10 DAY' >= current_date then 1 else 0 end) as nazoratda_palata_10_kungacha,
sum(case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 and u.harakat_vaqti + INTERVAL '10 DAY' >= current_date then u.k_sum_k else 0 end) as nazoratda_palata_10_kungacha_sums,
-- Назоратда палата 10 кундан ортган 'Назоратда' -> '78158aa6-9881-4810-8378-95968fc81b12'
sum(case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 and u.harakat_vaqti + INTERVAL '10 DAY' < current_date then 1 else 0 end) as nazoratda_palata_10_kundanotrgan,
sum(case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 and u.harakat_vaqti + INTERVAL '10 DAY' < current_date then u.k_sum_k else 0 end) as nazoratda_palata_10_kundanotrgan_sums,
-- Ҳисоб палатасига назоратдан ечиш учун келган--
sum(case when u.harakat_id = 12 and u.qayerga=1 then 1 else 0 end) as nazoratdan_echishda_hp_jami_son,
sum(case when u.harakat_id = 12 and u.qayerga=1 then u.k_sum_k else 0 end) as nazoratdan_echishda_hp_jami_sum,
--'Назоратдан ечишга юборилган (Ҳисоб палатасига->олди олинган)'
sum(case when u.harakat_id = 12 and u.qayerga=1 and u.is_approved in (1, 2, 4, 5, 6) and u.prevent=1 then 1 else 0 end) as nazoratdan_echishda_hp_oldi_olindi_son,
sum(case when u.harakat_id = 12 and u.qayerga=1 and u.is_approved in (1, 2, 4, 5, 6) and u.prevent=1 then u.k_sum_k else 0 end) as nazoratdan_echishda_hp_oldi_olindi_sum,
--'Назоратдан ечишга юборилган (Ҳисоб палатасига->кейинги назорат)'
sum(case when u.harakat_id = 12 and u.qayerga=1 and u.is_approved in (1, 2, 4, 5, 6) and (u.prevent=2 or u.prevent is null) then 1 else 0 end) as nazoratdan_echishda_hp_keyingi_nazorat_son,
sum(case when u.harakat_id = 12 and u.qayerga=1 and u.is_approved in (1, 2, 4, 5, 6) and (u.prevent=2 or u.prevent is null) then u.k_sum_k else 0 end) as nazoratdan_echishda_hp_keyingi_nazorat_sum,
--'Назоратдан ечишга юборилган (Ҳисоб палатасига->тасдиғини топмади)'
sum(case when u.harakat_id = 12 and u.qayerga=1 and u.is_approved=3 then 1 else 0 end) as nazoratdan_echishda_hp_tasdigini_topmadi_son,
sum(case when u.harakat_id = 12 and u.qayerga=1 and u.is_approved=3 then u.k_sum_k else 0 end) as nazoratdan_echishda_hp_tasdigini_topmadi_sum,
--'Назоратдан ечишга юборилган (Ҳисоб палатасига->менинг сохам эмас)'
sum(case when u.harakat_id = 12 and u.qayerga=1 and u.is_approved=18 then 1 else 0 end) as nazoratdan_echishda_hp_mening_soxam_emas,
sum(case when u.harakat_id = 12 and u.qayerga=1 and u.is_approved=18 then u.k_sum_k else 0 end) as nazoratdan_echishda_hp_mening_soxam_emas_sums,
-- Назоратда вазирликларда 'Назоратда' -> '78158aa6-9881-4810-8378-95968fc81b12'
sum(case when u.qayerdan >= 1 and u.qayerga >=1 then 1 else 0 end - case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 then 1 else 0 end - case when u.harakat_id = 12 and u.qayerga=1 then 1 else 0 end) as nazoratda_vazirlik,
sum(case when u.qayerdan >= 1 and u.qayerga >=1 then u.k_sum_k else 0 end - case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 then u.k_sum_k else 0 end - case when u.harakat_id = 12 and u.qayerga=1 then u.k_sum_k else 0 end) as nazoratda_vazirlik_sums,
-- Назоратда вазирликларда 10 кунгача 'Назоратда' -> '78158aa6-9881-4810-8378-95968fc81b12'
sum(case when u.qayerdan >= 1 and u.qayerga >=1 and u.harakat_vaqti + INTERVAL '10 DAY' >= current_date then 1 else 0 end - case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 and u.harakat_vaqti + INTERVAL '10 DAY' >= current_date then 1 else 0 end - case when u.harakat_id = 12 and u.qayerga=1 and u.harakat_vaqti + INTERVAL '10 DAY' >= current_date then 1 else 0 end) as nazoratda_vazirlik_10_kungacha,
sum(case when u.qayerdan >= 1 and u.qayerga >=1 and u.harakat_vaqti + INTERVAL '10 DAY' >= current_date then u.k_sum_k else 0 end - case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 and u.harakat_vaqti + INTERVAL '10 DAY' >= current_date then u.k_sum_k else 0 end - case when u.harakat_id = 12 and u.qayerga=1 and u.harakat_vaqti + INTERVAL '10 DAY' >= current_date then u.k_sum_k else 0 end) as nazoratda_vazirlik_10_kungacha_sums,
-- Назоратда палата 10 кундан ортган 'Назоратда' -> '78158aa6-9881-4810-8378-95968fc81b12'
sum(case when u.qayerdan >= 1 and u.qayerga >=1 and u.harakat_vaqti + INTERVAL '10 DAY' < current_date then 1 else 0 end - case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 and u.harakat_vaqti + INTERVAL '10 DAY' < current_date then 1 else 0 end - case when u.harakat_id = 12 and u.qayerga=1 and u.harakat_vaqti + INTERVAL '10 DAY' < current_date then 1 else 0 end) as nazoratda_vazirlik_10_kundanotrgan,
sum(case when u.qayerdan >= 1 and u.qayerga >=1 and u.harakat_vaqti + INTERVAL '10 DAY' < current_date then u.k_sum_k else 0 end - case when u.harakat_id <> 12 and u.qayerdan = 1 and u.qayerga = 1 and u.harakat_vaqti + INTERVAL '10 DAY' < current_date then u.k_sum_k else 0 end - case when u.harakat_id = 12 and u.qayerga=1 and u.harakat_vaqti + INTERVAL '10 DAY' < current_date then u.k_sum_k else 0 end) as nazoratda_vazirlik_10_kundanotrgan_sums,
-- Назоратдан ечиш учун вазирликда турган --
sum(case when u.harakat_id = 12 and u.qayerga=2 then 1 else 0 end) as nazoratdan_echishda_vazirlikda_jami_son,
sum(case when u.harakat_id = 12 and u.qayerga=2 then u.k_sum_k else 0 end) as nazoratdan_echishda_vazirlikda_jami_sum,
--'Назоратдан ечишга юборилган (вазирликда турган->олди олинган)'
sum(case when u.harakat_id = 12 and u.qayerga=2 and u.is_approved in (1, 2, 4, 5, 6) and u.prevent=1 then 1 else 0 end) as nazoratdan_echishda_vazirlikda_oldi_olindi_son,
sum(case when u.harakat_id = 12 and u.qayerga=2 and u.is_approved in (1, 2, 4, 5, 6) and u.prevent=1 then u.k_sum_k else 0 end) as nazoratdan_echishda_vazirlikda_oldi_olindi_sum,
--'Назоратдан ечишга юборилган (вазирликда турган->кейинги назорат)'
sum(case when u.harakat_id = 12 and u.qayerga=2 and u.is_approved in (1, 2, 4, 5, 6) and (u.prevent=2 or u.prevent is null) then 1 else 0 end) as nazoratdan_echishda_vazirlikda_keyingi_nazorat_son,
sum(case when u.harakat_id = 12 and u.qayerga=2 and u.is_approved in (1, 2, 4, 5, 6) and (u.prevent=2 or u.prevent is null) then u.k_sum_k else 0 end) as nazoratdan_echishda_vazirlikda_keyingi_nazorat_sum,
--'Назоратдан ечишга юборилган (вазирликда турган->тасдиғини топмади)'
sum(case when u.harakat_id = 12 and u.qayerga=2 and u.is_approved=3 then 1 else 0 end) as nazoratdan_echishda_vazirlikda_tasdigini_topmadi_son,
sum(case when u.harakat_id = 12 and u.qayerga=2 and u.is_approved=3 then u.k_sum_k else 0 end) as nazoratdan_echishda_vazirlikda_tasdigini_topmadi_sum,
--'Назоратдан ечишга юборилган (вазирликда турган->менинг сохам эмас)'
sum(case when u.harakat_id = 12 and u.qayerga=2 and u.is_approved=18 then 1 else 0 end) as nazoratdan_echishda_vazirlikda_mening_soxam_emas,
sum(case when u.harakat_id = 12 and u.qayerga=2 and u.is_approved=18 then u.k_sum_k else 0 end) as nazoratdan_echishda_vazirlikda_mening_soxam_emas_sums,
-- Назоратга олинмаганлар 'Янги' -> 'f7908aea-1ead-4e9b-a8a4-2a57a71f60f3'
sum(case when u.qayerdan = 0 and u.qayerga = 1 then 1 else 0 end) as nazoratga_olinmagan,
sum(case when u.qayerdan = 0 and u.qayerga = 1 then u.k_sum_k else 0 end) as nazoatga_olinmagan_sums,
-- Назоратга олинмаган ранглар белгиланган 'Янги' -> 'f7908aea-1ead-4e9b-a8a4-2a57a71f60f3'
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is not null then 1 else 0 end) as nazoratga_olinmagan_ranglangan,
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is not null then u.k_sum_k else 0 end) as nazoatga_olinmagan_ranglangan_sums,
-- Назоратга олинмаган ранглар белгиланган 10 кунгача 'Янги' -> 'f7908aea-1ead-4e9b-a8a4-2a57a71f60f3'
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is not null and u.detected_date + INTERVAL '10 DAY' >= current_date then 1 else 0 end) as nazoratga_olinmagan_ranglangan_10_kungacha,
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is not null and u.detected_date + INTERVAL '10 DAY' >= current_date then u.k_sum_k else 0 end) as nazoatga_olinmagan_ranglangan_10_kungacha_sums,
-- Назоратга олинмаган ранглар белгиланган 10 кундан ортган 'Янги' -> 'f7908aea-1ead-4e9b-a8a4-2a57a71f60f3'
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is not null and u.detected_date + INTERVAL '10 DAY' < current_date then 1 else 0 end) as nazoratga_olinmagan_ranglangan_10_kungacha,
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is not null and u.detected_date + INTERVAL '10 DAY' < current_date then u.k_sum_k else 0 end) as nazoatga_olinmagan_ranglangan_10_kungacha_sums,
-- Назоратга олинмаган ранглар белгиланмаган 'Янги' -> 'f7908aea-1ead-4e9b-a8a4-2a57a71f60f3'
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is null then 1 else 0 end) as nazoratga_olinmagan_ranglanmagan,
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is null then u.k_sum_k else 0 end) as nazoatga_olinmagan_ranglanmagan_sums,
-- Назоратга олинмаган ранглар белгиланмаган 10 кунгача 'Янги' -> 'f7908aea-1ead-4e9b-a8a4-2a57a71f60f3'
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is null and u.detected_date + INTERVAL '10 DAY' >= current_date then 1 else 0 end) as nazoratga_olinmagan_ranglanmagan_10_kungacha,
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is null and u.detected_date + INTERVAL '10 DAY' >= current_date then u.k_sum_k else 0 end) as nazoatga_olinmagan_ranglanmagan_10_kungacha_sums,
-- Назоратга олинмаган ранглар белгиланмаган 10 кундан ортган
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is null and u.detected_date + INTERVAL '10 DAY' < current_date then 1 else 0 end) as nazoratga_olinmagan_ranglanmagan_10_kungacha,
sum(case when u.qayerdan = 0 and u.qayerga = 1 and u."degree" is null and u.detected_date + INTERVAL '10 DAY' < current_date then u.k_sum_k else 0 end) as nazoatga_olinmagan_ranglanmagan_10_kungacha_sums,
-- Назоратдан ечилган
sum(case when u.qayerga=0 then 1 else 0 end) as nazoratdan_echildi,
sum(case when u.qayerga=0 then u.k_sum_k else 0 end) as nazoratdan_echildi_sums,
-- Назоратдан ечилган ижрочи ҳисоб палата
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha = 1 then 1 else 0 end) as nazoratdan_echildi_palata,
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha = 1 then u.k_sum_k else 0 end) as nazoratdan_echildi_palata_sums,
-- Назоратдан ечилган ижрочи ҳисоб палата олди олинди
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha = 1 and u.is_approved in (1, 2, 4, 5, 6) and u.prevent=1 then 1 else 0 end) as nazoratdan_echildi_palata_oldini_oldi,
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha = 1 and u.is_approved in (1, 2, 4, 5, 6) and u.prevent=1 then u.k_sum_k else 0 end) as nazoratdan_echildi_palata_oldini_oldi_sums,
-- Назоратдан ечилган ижрочи ҳисоб палата кейинги назорат
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha = 1 and u.is_approved in (1, 2, 4, 5, 6) and (u.prevent=2 or u.prevent is null) then 1 else 0 end) as nazoratdan_echildi_palata_keyin_naz,
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha = 1 and u.is_approved in (1, 2, 4, 5, 6) and (u.prevent=2 or u.prevent is null) then u.k_sum_k else 0 end) as nazoratdan_echildi_palata_keyin_naz_sums,
-- Назоратдан ечилган ижрочи ҳисоб палата тасдиғини топмади
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha = 1 and u.is_approved = 3 then 1 else 0 end) as nazoratdan_echildi_palata_tasdiq_topmadi,
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha = 1 and u.is_approved = 3 then u.k_sum_k else 0 end) as nazoratdan_echildi_palata_tasdiq_topmadi_sums,
-- Назоратдан ечилган ижрочи ҳисоб палата тасдиғини бошқа ҳолатлар
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha = 1 and (u.is_approved not in (1, 2, 3, 4, 5, 6) or u.is_approved is null) then 1 else 0 end) as nazoratdan_echildi_hp_boshqa_holatlar,
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha = 1 and (u.is_approved not in (1, 2, 3, 4, 5, 6) or u.is_approved is null) then u.k_sum_k else 0 end) as nazoratdan_echildi_hp_boshqa_holatlar,
-- Назоратдан ечилган ижрочи вазирлик 'Техник хато' -> -------
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha > 1 then 1 else 0 end) as nazoratdan_echildi_vazirlik, -------
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha > 1 then u.k_sum_k else 0 end) as nazoratdan_echildi_vazirlik_sums,
-- Назоратдан ечилган ижрочи вазирлик олди олинди 'Техник хато' -> '683b4643-f582-4040-a192-f8c1c9582bba', 'Риск емас' -> 'd51f5b5d-9900-4c84-bbb2-3a20f4717dd8', 'Бартараф етилди' -> '66ea5af8-99a9-4350-946e-17b5474f8d7a', 'Бажарилди' -> '96498063-66f0-42f3-aec4-048341300702'
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha > 1 and u.is_approved in (1, 2, 4, 5, 6) and u.prevent=1 then 1 else 0 end) as nazoratdan_echildi_vazirlik_oldini_oldi,
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha > 1 and u.is_approved in (1, 2, 4, 5, 6) and u.prevent=1 then u.k_sum_k else 0 end) as nazoratdan_echildi_vazirlik_oldini_oldi_sums,
-- Назоратдан ечилган ижрочи вазирлик кейинги назорат 'Техник хато' -> '683b4643-f582-4040-a192-f8c1c9582bba', 'Риск емас' -> 'd51f5b5d-9900-4c84-bbb2-3a20f4717dd8', 'Бартараф етилди' -> '66ea5af8-99a9-4350-946e-17b5474f8d7a', 'Бажарилди' -> '96498063-66f0-42f3-aec4-048341300702'
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha > 1 and u.is_approved in (1, 2, 4, 5, 6) and (u.prevent=2 or u.prevent is null) then 1 else 0 end) as nazoratdan_echildi_vazirlik_keyin_naz, --келажакда or u.prevent is null ўчирилади
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha > 1 and u.is_approved in (1, 2, 4, 5, 6) and (u.prevent=2 or u.prevent is null) then u.k_sum_k else 0 end) as nazoratdan_echildi_vazirlik_keyin_naz_sums,
-- Назоратдан ечилган ижрочи вазирлик тасдиғини топмади 'Техник хато' -> '683b4643-f582-4040-a192-f8c1c9582bba', 'Риск емас' -> 'd51f5b5d-9900-4c84-bbb2-3a20f4717dd8', 'Бартараф етилди' -> '66ea5af8-99a9-4350-946e-17b5474f8d7a', 'Бажарилди' -> '96498063-66f0-42f3-aec4-048341300702'
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha > 1 and u.is_approved = 3 then 1 else 0 end) as nazoratdan_echildi_vazirlik_tasdiq_topmadi,
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha > 1 and u.is_approved = 3 then u.k_sum_k else 0 end) as nazoratdan_echildi_vazirlik_tasdiq_topmadi_sums,
-- Назоратдан ечилган ижрочи вазирлик тасдиғини бошқа ҳолатлар
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha > 1 and (u.is_approved not in (1, 2, 3, 4, 5, 6) or u.is_approved is null) then 1 else 0 end) as nazoratdan_echildi_vaz_boshqa_holatlar,
sum(case when u.qayerdan <> 0 and u.qayerga=0 and u.kimgacha > 1 and (u.is_approved not in (1, 2, 3, 4, 5, 6) or u.is_approved is null) then u.k_sum_k else 0 end) as nazoratdan_echildi_vaz_boshqa_holatlar,
-- Назоратдан ечилган ижрочи система 'Техник хато' -> -------------
sum(case when u.qayerdan = 0 and u.qayerga=0 then 1 else 0 end) as nazoratdan_echildi_system,
sum(case when u.qayerdan = 0 and u.qayerga=0 then u.k_sum_k else 0 end) as nazoratdan_echildi_system_sums,
-- Назоратдан ечилган ижрочи вазирлик олди олинди 'Техник хато' -> '683b4643-f582-4040-a192-f8c1c9582bba', 'Риск емас' -> 'd51f5b5d-9900-4c84-bbb2-3a20f4717dd8', 'Бартараф етилди' -> '66ea5af8-99a9-4350-946e-17b5474f8d7a', 'Бажарилди' -> '96498063-66f0-42f3-aec4-048341300702'
sum(case when u.qayerdan = 0 and u.qayerga=0 and u.prevent=1 then 1 else 0 end) as nazoratdan_echildi_system_oldini_oldi,
sum(case when u.qayerdan = 0 and u.qayerga=0 and u.prevent=1 then u.k_sum_k else 0 end) as nazoratdan_echildi_system_oldini_oldi_sums,
-- Назоратдан ечилган ижрочи вазирлик кейинги назорат 'Техник хато' -> '683b4643-f582-4040-a192-f8c1c9582bba', 'Риск емас' -> 'd51f5b5d-9900-4c84-bbb2-3a20f4717dd8', 'Бартараф етилди' -> '66ea5af8-99a9-4350-946e-17b5474f8d7a', 'Бажарилди' -> '96498063-66f0-42f3-aec4-048341300702'
sum(case when u.qayerdan = 0 and u.qayerga=0 and u.is_approved in (1, 2, 4, 5, 6) and (u.prevent=2 or u.prevent is null) then 1 else 0 end) as nazoratdan_echildi_system_keyin_naz, --келажакда or u.prevent is null ўчирилади
sum(case when u.qayerdan = 0 and u.qayerga=0 and u.is_approved in (1, 2, 4, 5, 6) and (u.prevent=2 or u.prevent is null) then u.k_sum_k else 0 end) as nazoratdan_echildi_system_keyin_naz_sums,
-- Назоратдан ечилган ижрочи вазирлик тасдиғини топмади 'Техник хато' -> '683b4643-f582-4040-a192-f8c1c9582bba', 'Риск емас' -> 'd51f5b5d-9900-4c84-bbb2-3a20f4717dd8', 'Бартараф етилди' -> '66ea5af8-99a9-4350-946e-17b5474f8d7a', 'Бажарилди' -> '96498063-66f0-42f3-aec4-048341300702'
sum(case when u.qayerdan = 0 and u.qayerga=0 and u.is_approved = 3 then 1 else 0 end) as nazoratdan_echildi_system_tasdiq_topmadi,
sum(case when u.qayerdan = 0 and u.qayerga=0 and u.is_approved = 3 then u.k_sum_k else 0 end) as nazoratdan_echildi_system_tasdiq_topmadi_sums,
-- Назоратдан ечилган ижрочи система тасдиғини бошқа ҳолатлар
sum(case when u.qayerdan = 0 and u.qayerga=0 and (u.is_approved not in (1, 2, 3, 4, 5, 6) or u.is_approved is null) then 1 else 0 end) as nazoratdan_echildi_sys_boshqa_holatlar,
sum(case when u.qayerdan = 0 and u.qayerga=0 and (u.is_approved not in (1, 2, 3, 4, 5, 6) or u.is_approved is null) then u.k_sum_k else 0 end) as nazoratdan_echildi_sys_boshqa_holatlar
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
	where p.hidden_profile is false --Ҳисоботда чиқмайдиган
) u
left join
(
	select m.inn quyi_inn, m.katta_otasi, m1.name_cr katta_otasi_nomi
	from public.ministry_trees m
	left join public.ministry_trees m1 on m.katta_otasi = m1.inn
)m on u.vaz_code = m.quyi_inn
left join
(
	select p.*, g.name_cr as g_name
	from public.profiles p
	left join public."groups" g on p.group_id = g.id
) p on u.profile_id=p.id
where u.detected_date >= '2024-01-01' -- and u.organization = 6 and p.description='Тўғридан-тўғри шартномалар мониторинги' and u.vaz_code = '200936593'
group by u.vaz_code, m.katta_otasi_nomi, p.description, p.g_name;
