﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//{{_КОНСТРУКТОР_ПЕЧАТИ(ПечатьСчетаНаОплату)
	ТабДок = Новый ТабличныйДокумент;
	ПечатьСчетаНаОплату(ТабДок, ПараметрКоманды);

	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	//}}
КонецПроцедуры

&НаСервере
Процедура ПечатьСчетаНаОплату(ТабДок, ПараметрКоманды)
	Документы.ЗаказКлиента.ПечатьСчетаНаОплату(ТабДок, ПараметрКоманды);
КонецПроцедуры
