﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		// Заполнение шапки
		Клиент = ДанныеЗаполнения.Клиент;
		Склад = ДанныеЗаполнения.Склад;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
			НоваяСтрока.Сумма = ТекСтрокаТовары.Сумма;
			НоваяСтрока.Товар = ТекСтрокаТовары.Товар;
			НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
		КонецЦикла;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр Взаиморасчеты Приход
	Движения.Взаиморасчеты.Записывать = Истина;
	Движение = Движения.Взаиморасчеты.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Контрагент = Клиент;
	Движение.Сумма = СуммаДокумента;

	// регистр Продажи 
	Движения.Продажи.Записывать = Истина;
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.Продажи.Добавить();
		Движение.Период = Дата;
		Движение.Клиент = Клиент;
		Движение.Номенклатура = ТекСтрокаТовары.Товар;
		Движение.Количество = ТекСтрокаТовары.Количество;
		Движение.Сумма = ТекСтрокаТовары.Сумма;
	КонецЦикла;

	// регистр ТоварыНаСкладах Расход
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.ТоварыНаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Товар;
		Движение.Склад = Склад;
		Движение.Количество = ТекСтрокаТовары.Количество;
	КонецЦикла;
	
	Сообщить(Режим);
	
	Движения.Записать();
	
	
	Если Режим = РежимПроведенияДокумента.Оперативный Тогда 
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТоварыНаСкладахОстатки.Номенклатура,
		|	ТоварыНаСкладахОстатки.Склад,
		|	-ТоварыНаСкладахОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.ТоварыНаСкладах.Остатки(
		|			,
		|			Склад = &Склад
		|				И Номенклатура В
		|					(ВЫБРАТЬ
		|						РеализацияТоваровИУслугТовары.Товар
		|					ИЗ
		|						Документ.РеализацияТоваровИУслуг.Товары КАК РеализацияТоваровИУслугТовары
		|					ГДЕ
		|						РеализацияТоваровИУслугТовары.Ссылка = &Ссылка)) КАК ТоварыНаСкладахОстатки
		|ГДЕ
		|	ТоварыНаСкладахОстатки.КоличествоОстаток < 0";
		
		Запрос.УстановитьПараметр("Склад", Склад);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Отказ = Истина;
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();			
				
			    Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				Сообщить("Недостаточно товара "+ВыборкаДетальныеЗаписи.Номенклатура+" в количестве "+ВыборкаДетальныеЗаписи.Количество);       
				
				КонецЦикла;
		КонецЕсли;  
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		Движения.СебестоимостьТоваров.Записывать = Истина;
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СебестоимостьТоваровОстатки.Номенклатура,
		|	СебестоимостьТоваровОстатки.СуммаОстаток КАК Сумма,
		|	СебестоимостьТоваровОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.СебестоимостьТоваров.Остатки(
		|			&МоментВремени,
		|			Номенклатура В
		|				(ВЫБРАТЬ
		|					РеализацияТоваровИУслугТовары.Товар
		|				ИЗ
		|					Документ.РеализацияТоваровИУслуг.Товары КАК РеализацияТоваровИУслугТовары
		|				ГДЕ
		|					РеализацияТоваровИУслугТовары.Ссылка = &Ссылка)) КАК СебестоимостьТоваровОстатки";
		
		Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Если ВыборкаДетальныеЗаписи.Количество <> 0 Тогда 
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
			Движение.Сумма = СебестоимостьЕденицы * СтрокаТЧ.Количество;
			
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	СуммаДокумента = 0;	
	Для Каждого СтрокаТЧ ИЗ Товары Цикл
		СуммаДокумента = СуммаДокумента + СтрокаТЧ.Сумма;
		Сообщить(СтрокаТЧ.Товар.ОсновнойПоставщик);
	КонецЦикла;
	
	Сообщить(МоментВремени());
	
КонецПроцедуры
