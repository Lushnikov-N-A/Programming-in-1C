﻿
Процедура ОбработкаПроведения(Отказ, Режим)    
	
	// регистр ЗаработнаяПлата
	Движения.ЗаработнаяПлата.Записывать = Истина;
	Движение = Движения.ЗаработнаяПлата.Добавить();
	Движение.Сторно = Ложь;
	Движение.ВидРасчета = ПланыВидовРасчета.Начисления.ОкладПоТарифу;
	Движение.ПериодДействияНачало = НачалоМесяца(Дата);
	Движение.ПериодДействияКонец = КонецМесяца(Дата);
	Движение.ПериодРегистрации = Дата;
	Движение.Сотрудник = Сотрудник;
	Движение.РасчетныеДанные = Сумма;
	
	Движения.Записать();	
				
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаработнаяПлатаДанныеГрафика.РабочийДеньПериодДействия КАК Норма,
		|	ЗаработнаяПлатаДанныеГрафика.РабочийДеньФактическийПериодДействия КАК Факт,
		|	ЗаработнаяПлатаДанныеГрафика.РасчетныеДанные КАК РасчетныеДанные
		|ИЗ
		|	РегистрРасчета.ЗаработнаяПлата.ДанныеГрафика(Регистратор = &Регистратор) КАК ЗаработнаяПлатаДанныеГрафика";
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		
		Если ВыборкаДетальныеЗаписи.Норма <> 0 Тогда
			Оклад = ВыборкаДетальныеЗаписи.РасчетныеДанные * ВыборкаДетальныеЗаписи.Факт/ВыборкаДетальныеЗаписи.Норма;   
			Движение.Сумма = Оклад;
			Движения.ЗаработнаяПлата.Записать(); 
			
			Движения.ВыплатаЗП.Записывать = Истина;
			Движение = Движения.ВыплатаЗП.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.Сотрудник = Сотрудник;
			Движение.Сумма = Оклад;

			
		Иначе
			Сообщить("Неверно заполнен график работ");
		КонецЕсли;
		
		
	КонецЕсли;

КонецПроцедуры
