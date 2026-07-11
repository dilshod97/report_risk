"""Test: hisobotlarni darrov yaratib Telegramga yuboradi (barcha chat_id larga).

Ishlatish:
    .venv/bin/python test_reports.py

.env da to'ldirilgan bo'lishi shart:
  - DB_* (SSH tunnel ochiq turishi kerak)
  - TELEGRAM_BOT_TOKEN
  - TELEGRAM_CHAT_ID (vergul bilan bir nechta: 111,222,-100123)

Yuboriladigan hisobotlar reports/base.py REPORTS ro'yxati bilan belgilanadi.
"""
from __future__ import annotations

import asyncio
import logging

from telegram.ext import Application

import config
from bot import generate_and_send_all
from reports.base import REPORTS

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s")


async def _run() -> None:
    if not config.TELEGRAM_BOT_TOKEN:
        raise SystemExit(".env da TELEGRAM_BOT_TOKEN yo'q")
    if not config.TELEGRAM_CHAT_IDS:
        raise SystemExit(".env da TELEGRAM_CHAT_ID yo'q")

    print(f"Qabul qiluvchilar: {config.TELEGRAM_CHAT_IDS}")
    print("Hisobotlar:", [s.name for s in REPORTS])
    print("Tayyorlanmoqda va yuborilmoqda...")

    application = Application.builder().token(config.TELEGRAM_BOT_TOKEN).build()
    await application.initialize()
    try:
        await generate_and_send_all(application)
    finally:
        await application.shutdown()
    print("Tayyor — Telegramni tekshiring.")


if __name__ == "__main__":
    asyncio.run(_run())
