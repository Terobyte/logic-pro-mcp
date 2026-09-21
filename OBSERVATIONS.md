# Наблюдения — logic-pro-mcp (сессия 2026-09-21)

Не план. Сырые факты, которые я увидел, пока ставил вокальную цепочку в «бело красный» через этот MCP.
Разбор по пунктам с кодом — в `IMPROVEMENTS.md`.

## Среда
- macOS 15 (Darwin 24.6), Swift 6.2.3, Logic Pro (bundle `com.apple.logic10`), раскладка русская.
- Бинарь собран из upstream (`swift build -c release`, ~60 с), лежит в `~/.local/bin/LogicProMCP`,
  зарегистрирован `claude mcp add --scope user logic-pro`. Сейчас это **upstream-сборка, не форк**.
- Accessibility у терминала выдан; Automation (Logic) — «not yet requested», ни разу не понадобился.
- Logic живёт на другом Space: `screencapture` его не видит, скриншоты бесполезны — только AX.
- UAD-плагины установлены (сотни `.component`), но карта/Apollo не работает → UAD в проекте фактически мёртвые.

## Проект «бело красный»
- Имя проекта в Logic: «бэйби я не знаю как мне эиьб» (по первой строке текста).
- Реальных треков 5: бит, стек «Warm Vocal» (summing, input Bus 1), подтрек с take folder (~20 дублей),
  aux «PreDelay» (**без выхода** — посылы в него тишина), aux «Warmth».
- Было: пресет канала «Vocal light» = UAD Pure Plate → Pultec → Teletronix.
- Стало: стек переименован в «Rose Vocal», стерео, цепочка Channel EQ → Compressor (Vintage Opto) → DeEsser 2 →
  ChromaGlow → ChromaVerb (Vocal Hall, 20%). Сохранён патч `~/Music/Audio Music Apps/Patches/Audio/Rose Vocal.patch`.
- Проект **не сохранён** мной. Темп стоит 120 — похоже на дефолт, реальный BPM бита неизвестен.
- Smart Controls остались от патча Warm Vocal и указывают на уже удалённые плагины.

## Что в MCP работало
- stdio JSON-RPC поднимается сразу; ресурсы `project/info`, `tracks` отвечают.
- AX-чтение инспекторного channel strip — богатое и стабильное (inserts, bypass, sends, I/O, setting, метры).

## Что в MCP не работало / врало
- `insert_plugin` и вся группа plugin.* — заглушка, хотя help её рекламирует.
- `tracks select` → `{"selected":N}`, а выделение в Logic не меняется.
- `logic://tracks`: 26 записей вместо 5 (take-лейны как треки), volume/pan = 0 хардкодом, type = unknown.
- `logic://mixer` = `[]`, когда не открыт отдельный Mixer.

## Поведение Logic через AX (неочевидное)
- `AXWindows` пустой → только `AXMainWindow`. Модалка становится main-окном и «прячет» основное.
- Пункты **подменю** в меню слота плагина на `AXPress` не реагируют (возвращают успех). Top-level пункты (`No Plug-in`) — реагируют.
- Меню-бар через System Events кликается надёжно (`Mix > Search and Add Plug-in…`, `Window > Hide All Plug-in Windows`).
- Search and Add вставляет плагин в **верхний** слот.
- `AXValue` на слайдере = +1 шаг, не абсолют. `AXIncrement/Decrement` + `AXValueDescription` = точная установка.
  Шаги грубые и неравномерные (EQ gain 1 дБ, Wet 10%, Make Up 5 дБ, Threshold 5 дБ).
- `View > Controls` в окне плагина даёт подписанные параметры в реальных единицах; у ChromaVerb/ChromaGlow в Editor-виде AX почти пуст.
- Кнопка `open` у плагина — тоггл.
- Переключение channel mode Mono→Stereo через AXPress сохранило плагины.
- `keystroke` при русской раскладке печатает кириллицу → текст только через `AXValue`.
- Save Patch: кнопка `Save…` в Library → стандартная save-панель, поле `saveAsNameTextField`.

## Upstream
- koltyj/logic-pro-mcp активен: мержит внешние PR (#32, #33, #35), последний мерж 2026-09-05.
- Открытые PR: #36 set_tempo (висит с 09-10), #42 mixer parameter contracts (пересекается с нашим volume/pan), #43 bundle ID / permissions.
- Направление автора совпадает с нашим: #34 «report unverified deliveries honestly».
- Форк: github.com/Terobyte/logic-pro-mcp, `origin` = форк, `upstream` = автор. В форке закоммичен только `IMPROVEMENTS.md`.

## Мои временные хелперы (scratchpad сессии, пропадут)
axdump (дерево AX), axc/slotmenu (меню слотов), setsearch (Search and Add), pp (параметры плагина: dump/inc/press/menu),
openplug, st (состояние bypass), savedlg/libsave (сохранение патча). Логика из них — готовый материал для plugin.* в форке.

## Открытые вопросы
- Реальный BPM бита (для delay).
- Решение по сведению: наш AX-воркфлоу vs Cryo Mix vs гибрид.
- Форк: сразу PR мелкими ветками или сначала issue автору по плагинам.
- Как «слушать»: баунс стемов → LUFS/спектр/спектрограммы, референс-трек, внешняя аудио-модель.
