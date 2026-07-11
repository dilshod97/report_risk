from __future__ import annotations

import logging

from telegram.ext import Application

from bot import build_application
from scheduler import build_scheduler

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s")
logger = logging.getLogger(__name__)


def main() -> None:
    application = build_application()
    scheduler = build_scheduler(application)

    async def _on_startup(app: Application) -> None:
        scheduler.start()
        logger.info("Scheduler ishga tushdi")

    application.post_init = _on_startup
    logger.info("Bot ishga tushmoqda...")
    application.run_polling()


if __name__ == "__main__":
    main()
