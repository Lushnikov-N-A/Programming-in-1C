﻿
&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)      
	
	ТекущиеДанныеТоваров = Элементы.Товары.ТекущиеДанные;
	ТекущиеДанныеТоваров.Сумма = ТекущиеДанныеТоваров.Цена*ТекущиеДанныеТоваров.Количество;      
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
		
	ТекущиеДанныеТоваров = Элементы.Товары.ТекущиеДанные;
	ТекущиеДанныеТоваров.Сумма = ТекущиеДанныеТоваров.Цена*ТекущиеДанныеТоваров.Количество;      
		
КонецПроцедуры
