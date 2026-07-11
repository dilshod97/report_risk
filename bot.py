from __future__ import annotations

import asyncio
import logging
from pathlib import Path

from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes

import config
from reports.base import REPORTS

logger = logging.getLogger(__name__)


async def _broadcast_message(application: Application, text: str) -> None:
    for chat_id in config.TELEGRAM_CHAT_IDS:
        try:
            await application.bot.send_message(chat_id=chat_id, text=text)
        except Exception:
            logger.exception("Xabar yuborishda xatolik (chat_id=%s)", chat_id)


async def send_reports(application: Application, paths: list[Path]) -> None:
    for path in paths:
        data = path.read_bytes()
        for chat_id in config.TELEGRAM_CHAT_IDS:
            try:
                await application.bot.send_document(
                    chat_id=chat_id, document=data, filename=path.name
                )
            except Exception:
                logger.exception(
                    "Hisobotni yuborishda xatolik: %s (chat_id=%s)", path, chat_id
                )


async def generate_and_send_all(application: Application) -> None:
    paths: list[Path] = []
    for spec in REPORTS:
        try:
            path = await asyncio.to_thread(spec.build_fn)
            paths.append(path)
        except Exception:
            logger.exception("Hisobotni tayyorlashda xatolik: %s", spec.name)
            await _broadcast_message(
                application, f"Xatolik: \"{spec.name}\" tayyorlanmadi."
            )
    if paths:
        await send_reports(application, paths)


async def run_now_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    chat = update.effective_chat
    if not chat or str(chat.id) not in config.TELEGRAM_CHAT_IDS:
        return
    await update.message.reply_text("Hisobotlar tayyorlanmoqda, biroz kuting...")
    await generate_and_send_all(context.application)


def build_application() -> Application:
    application = Application.builder().token(config.TELEGRAM_BOT_TOKEN).build()
    application.add_handler(CommandHandler("run_now", run_now_command))
    return application
