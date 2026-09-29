from __future__ import annotations

import datetime as dt
from dataclasses import dataclass
from pathlib import Path
from typing import Callable

from reports import (
    excel_ikt_static,
    excel_risk_groups,
    excel_risk_states,
    pdf_daily_summary,
)


@dataclass(frozen=True)
class ReportSpec:
    name: str
    build_fn: Callable[[], Path]


# Har kuni ertalab yuboriladigan hisobotlar ro'yxati. Yangi yo'nalish (Excel)
# tayyor bo'lganda shu yerga bitta qator qo'shish kifoya - qolgan kod
# (scheduler, bot) o'zgarmaydi.
def _joriy_yil_boshi() -> str:
    """Chaqirilgan paytdagi yilning 1-yanvari (2026 -> '2026-01-01')."""
    return f"{dt.date.today().year}-01-01"


REPORTS: list[ReportSpec] = [
    ReportSpec("Kunlik umumiy hisobot (PDF)", pdf_daily_summary.build),
    ReportSpec("Aniqlangan risk guruhlari kesimida (Excel)", excel_risk_groups.build),
    ReportSpec("Aniqlangan risk holatlari (Excel)", excel_risk_states.build),
    ReportSpec("Masofaviy audit tizimi ISHLAB chiqilishi (ИКТ, statik Excel)", excel_ikt_static.build),
    # Joriy yil kesimi: xuddi shu hisobotlar, faqat detected_date joriy yildan
    # boshlab. Yil almashganda avtomatik yangi yilga o'tadi. Statik ИКТ fayliga
    # yillik filtr qo'llanmaydi (u o'zgarmas tayyor fayl).
    ReportSpec(
        "Kunlik umumiy hisobot - joriy yil (PDF)",
        lambda: pdf_daily_summary.build(date_from=_joriy_yil_boshi()),
    ),
    ReportSpec(
        "Aniqlangan risk guruhlari kesimida - joriy yil (Excel)",
        lambda: excel_risk_groups.build(date_from=_joriy_yil_boshi()),
    ),
    ReportSpec(
        "Aniqlangan risk holatlari - joriy yil (Excel)",
        lambda: excel_risk_states.build(date_from=_joriy_yil_boshi()),
    ),
]
