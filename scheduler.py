from __future__ import annotations

import logging

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger
from telegram.ext import Application

import config
from bot import generate_and_send_all

logger = logging.getLogger(__name__)


def build_scheduler(application: Application) -> AsyncIOScheduler:
    scheduler = AsyncIOScheduler(timezone=config.TIMEZONE)

    async def run_daily() -> None:
        logger.info("Kunlik hisobotlarni tayyorlash boshlandi")
        await generate_and_send_all(application)

    scheduler.add_job(
        run_daily,
        CronTrigger(hour=config.REPORT_HOUR, minute=config.REPORT_MINUTE),
        id="daily_reports",
        replace_existing=True,
    )
    return scheduler
