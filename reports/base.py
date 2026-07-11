from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Callable

from reports import excel_center_staff, excel_risk_groups, pdf_daily_summary


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
    # Hozircha o'chirilgan - kerak bo'lganda quyidagini yoqing:
    # ReportSpec("Markaz xodimlari kesimida hisobot (Excel)", excel_center_staff.build),
]
