from __future__ import annotations

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
REPORTS: list[ReportSpec] = [
    ReportSpec("Kunlik umumiy hisobot (PDF)", pdf_daily_summary.build),
    ReportSpec("Aniqlangan risk guruhlari kesimida (Excel)", excel_risk_groups.build),
    ReportSpec("Aniqlangan risk holatlari (Excel)", excel_risk_states.build),
    ReportSpec("Masofaviy audit tizimi ISHLAB chiqilishi (ИКТ, statik Excel)", excel_ikt_static.build),
]
