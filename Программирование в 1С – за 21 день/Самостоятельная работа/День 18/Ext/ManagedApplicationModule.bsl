﻿Перем ДвухзначноеЧисло, Степень;

Процедура ДеньНеделиНГЗа10Лет()
 
    Для Сч = 0 По 9 Цикл
        ТекущийГод = КонецГода(ТекущаяДата()+ Сч*365*24*3600); 
        НомерДняНедели = (ДеньНедели(ТекущийГод));
        Если НомерДняНедели = 1 Тогда
            Сообщить("Новый Год " + Формат(Год(ТекущийГод),"ЧГ=0") + " в понедельник.");
        ИначеЕсли НомерДняНедели = 2 Тогда
            Сообщить("Новый Год " + Формат(Год(ТекущийГод),"ЧГ=0") + " во вторник.");
        ИначеЕсли НомерДняНедели = 3 Тогда
            Сообщить("Новый Год " + Формат(Год(ТекущийГод),"ЧГ=0") + " в среду.");
        ИначеЕсли НомерДняНедели = 4 Тогда
            Сообщить("Новый Год " + Формат(Год(ТекущийГод),"ЧГ=0") + " в четверг.");
        ИначеЕсли НомерДняНедели = 5 Тогда
            Сообщить("Новый Год " + Формат(Год(ТекущийГод),"ЧГ=0") + " в пятницу.");
        ИначеЕсли НомерДняНедели = 6 Тогда
            Сообщить("Новый Год " + Формат(Год(ТекущийГод),"ЧГ=0") + " в субботу.");
        ИначеЕсли НомерДняНедели = 7 Тогда
            Сообщить("Новый Год " + Формат(Год(ТекущийГод),"ЧГ=0") + " в воскресенье.");
        КонецЕсли;
    КонецЦикла;
    
КонецПроцедуры

МассивЧисел = Новый Массив;
МассивЧисел.Добавить(999);
МассивЧисел.Добавить(1111); 

Для Каждого МассивТЧ из МассивЧисел Цикл
	Сообщить(МассивТЧ);
КонецЦикла;



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

ДеньНеделиНГЗа10Лет();

	