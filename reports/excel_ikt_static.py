from __future__ import annotations

from pathlib import Path

import config

# 4-hisobot - statik fayl. Query bilan to'ldirilmaydi, o'zi o'zgarmasdan
# yuboriladi. Yangilash kerak bo'lsa, shu faylni almashtirish kifoya.
STATIC_PATH = config.BASE_DIR / "static_reports" / "ikt_hisobot.xlsx"


def build() -> Path:
    if not STATIC_PATH.exists():
        raise FileNotFoundError(f"Statik ИКТ hisobot fayli topilmadi: {STATIC_PATH}")
    return STATIC_PATH


if __name__ == "__main__":
    print(build())
