﻿Перем ДвухзначноеЧисло, Степень;

Степень = 10;
ДвухзначноеЧисло = 11;
Результат = 1;

Для Сч = 1 По Степень Цикл
	Результат = Результат*ДвухзначноеЧисло;
КонецЦикла;

Если Результат < 10000 Тогда
	Сообщить("Результат меньше 10000");
Иначе Сообщить("Результат больше 10000");
КонецЕсли;

Сообщить("Результат = " + Результат);

	