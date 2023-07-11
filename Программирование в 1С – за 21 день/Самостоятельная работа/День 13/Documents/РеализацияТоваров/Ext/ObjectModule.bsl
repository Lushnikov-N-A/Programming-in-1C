﻿
Процедура ОбработкаПроведения(Отказ, Режим)  
	
	Движения.ОстаткиТоваров.Записывать = Истина;
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.ОстаткиТоваров.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Товар = ТекСтрокаТовары.Товар;
		Движение.Склад = Склад;
		Движение.Количество = ТекСтрокаТовары.Количество;
	КонецЦикла;     
	
	Движения.Записать();
	
	Если Режим = РежимПроведенияДокумента.Оперативный Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Товар КАК Товар,
		|	ОстаткиТоваровОстатки.Склад КАК Склад,
		|	-ОстаткиТоваровОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(
		|			,
		|			Склад = &Склад
		|				И Товар В
		|					(ВЫБРАТЬ
		|						РеализацияТоваровТовары.Товар КАК Товар
		|					ИЗ
		|						Документ.РеализацияТоваров.Товары КАК РеализацияТоваровТовары
		|					ГДЕ
		|						РеализацияТоваровТовары.Ссылка = &Ссылка)) КАК ОстаткиТоваровОстатки
		|ГДЕ
		|	ОстаткиТоваровОстатки.КоличествоОстаток < 0";
		
		Запрос.УстановитьПараметр("Склад", Склад);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();  
		
		Если Не РезультатЗапроса.Пустой() Тогда
			
			Отказ = Истина;
				
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
				
				Сообщить("Недостаточно товара "+ ВыборкаДетальныеЗаписи.Товар + " в количестве " + ВыборкаДетальныеЗаписи.Количество);
				
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;  
	
	Если Не Отказ Тогда
		
		Движения.СебестоимостьТоваров.Записывать = Истина;
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СебестоимостьТоваровОстатки.Номенклатура КАК Номенклатура,
		|	СебестоимостьТоваровОстатки.СуммаОстаток КАК Сумма,
		|	СебестоимостьТоваровОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.СебестоимостьТоваров.Остатки(
		|			&МоментВремени,
		|			Номенклатура В
		|				(ВЫБРАТЬ
		|					РеализацияТоваровТовары.Товар КАК Товар
		|				ИЗ
		|					Документ.РеализацияТоваров.Товары КАК РеализацияТоваровТовары
		|				ГДЕ
		|					РеализацияТоваровТовары.Ссылка = &Ссылка)) КАК СебестоимостьТоваровОстатки";
		
		Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл  
			
			Если ВыборкаДетальныеЗаписи <> 0 Тогда
				
				СебестоимостьЕденицы = ВыборкаДетальныеЗаписи.Сумма/ВыборкаДетальныеЗаписи.Количество;
				
			Иначе                        
				
				СебестоимостьЕденицы = 0;
				
			КонецЕсли;  
			
			Движение = Движения.СебестоимостьТоваров.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;   
			СтрокаТЧ = Товары.Найти(ВыборкаДетальныеЗаписи.Номенклатура, "Товар");
			Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
			Движение.Количество = СтрокаТЧ.Количество;
			Движение.Сумма =  СебестоимостьЕденицы * СтрокаТЧ.Количество; 
			
			// регистр Продажи 
			Движения.Продажи.Записывать = Истина;
			Движение = Движения.Продажи.Добавить();
			Движение.Период = Дата;
			Движение.Клиент = Покупатель;
			Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
			Движение.Количество = СтрокаТЧ.Количество;
			Движение.Сумма = СтрокаТЧ.Сумма;
			Движение.Себестоимость = СебестоимостьЕденицы * СтрокаТЧ.Количество;
	
		КонецЦикла;
     		
	КонецЕсли;

 КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	СуммаДокумента = 0;
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		СуммаДокумента = СуммаДокумента + СтрокаТЧ.Сумма;		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Покупатель.Клиент = Истина Тогда
		Сообщить("Это клиент!");
	Иначе
		Сообщить(Покупатель);
		Сообщить("Это не клиент!!!");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры     









