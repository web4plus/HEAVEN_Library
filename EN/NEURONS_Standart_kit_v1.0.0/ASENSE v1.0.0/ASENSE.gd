extends GraphNode

# ПОЛЕ ДАННЫХ - это  объект в главной ноде конструктора, в котором все ноды будут хранить свои динамические данные, таким образом что бы сохранение и загрузка данных были максимально удобными и гибкими 


# Подключится к корню платформы
onready var MAIN = get_node_or_null("/root/MAIN")

var bridge_source = null # Нода будет содержать код моста, т.е. рецептор-источник

var node_type = "ASENSE" # Возможно будет достаточно и определение типа в корневой ноде 

var IMPULSE : float

var NodeData = {} # Переменная которая будет содержать ссылку на ячейку для данной ноды в поле данных
#var Connections  = {}  # Ссылка на арздел в ячейке NodeData, Словарь связей для данной ноды, содержит имя ноды и вес связи
#onready var SpinBox_val = $SpinBox.value# Ссылка на раздел значения SpinBox

var Indicator = 0.0

var GraphData # = get_parent().GraphData # Получить доступ к глобальному словарю
#onready var NodeData = GraphData["lol"] # Попробовать получить доступ к своей ячейке данных (должен возвратить null если fail)/ обращается по имени ноды

#$GraphEdit


var transporter_connection = null



func _ready():
	#title = name
	$ColorRect.color = Color(0,255,0,Indicator)
	#print($SpinBox.get_line_edit().text) # Получить значение подаваемого напряжения
	#rect_position= Vector2(900,100)
#	print(GraphData["testtest1"])
	####### 29 aug 2023 var NEW_TRANSPORT_NODE = get_parent().SPAWN_NODE('transporter', title, Vector2(offset.x+275,offset.y))
	# Первым же делом произвести сопряжение с полем данных 
	CONNECT_DATA()
	
	# Вторым следует восстановить данные из поля
	#print('////'+str(GraphData[name]["Params"]["SpinBox_val"]))
	###MAIN.ADD_TO_CONSOLE(GraphData[name]["Params"]["SpinBox_val"])
	#$SpinBox.set_value(float(GraphData[name]["Params"]["SpinBox_val"]))
	#s$SpinBox.
	
	
	
	#Добавить в выпадающее меню пункт, позволяющий тонко настраивать силу сенсора
	$PopupMenu.add_item("SELECT KIDS")
	$PopupMenu.add_item("ORDER")
	$PopupMenu.add_item("MANAGE")
	$PopupMenu.add_item("VALUES")
	$PopupMenu.add_item("DATA")

	
	
	# Если запись о связях уже прису
	#if "CONNECTIONS" in GraphData:
	#	Connections = GraphData["CONNECTIONS"]
	#else:
	#	GraphData["CONNECTIONS"] = Connections
		
		
	#print(GraphData)








# ФУНКЦИЯ СОПРЯЖЕНИЯ С ПОЛЕМ ДАННЫХ
# Задача: после подгрузки, нода должна подключится к полю информации
#	Затем нода должна либо создать свою ячейку в случаи если та отсутствует
#	Либо если та присутствует, подключится к своей ячейке и связаться с  соотв данными
# Смысл в том, что после создания новой ноды та интегрируется с полем, где хранит свое 
# 	динамическое состояние в виде параметров, подключение происходит в виде ссылок
# Когда происходит сохранение, поле записывается в settings, после загрузки поле 
# 	переназначается конструктору. В этом случаи каждая далее подгружаемая ноды из сохранения
# 	интегрируется с подгруженными данными и таким образом параметры восстанавливаются из сохранения 

func CONNECT_DATA():
	print()
	#MAIN.ADD_TO_CONSOLE('F: CONNECT_DATA()', true)
	print('F: CONNECT_DATA()')
	
	#Получить доступ к полю данных, которое находится в корневой ноде конструктора
	GraphData = get_parent().GraphData
	
	#MAIN.ADD_TO_CONSOLE('Current DF state::')
	print("Текущее поле данных конструктора: ")
	print(GraphData)
	
	# Если системное имя данной ноды находится в поле данных
	if name in GraphData:
		# В общем ничего делать не нужно на данный момент
		#MAIN.ADD_TO_CONSOLE('Node exist in the DF!')
		print('Существует информация о данной ноде в поле')
	# Но если запись о этой ноде не обнаружена в поле данных
	else:
		#MAIN.ADD_TO_CONSOLE('Node still not in the DF')
		print('Информация о ноде отсутствует в поле')
		
		# РЕГИСТРАЦИЯ ЯЧЕЙКИ В ПОЛЕ ИНФОРМАЦИИ
		# Создать новый объект ячейку непосредственно в поле
		GraphData[name] = {} 
		# Создать раздел с подключениями для данной ноды в ее ячейке 
		
		GraphData[name]["Connections"] = {0:{}}
		#GraphData[name]["Connections"] = {}
		# Создать раздел со значением SpinBox (сила импульса) и определить текущую
		GraphData[name]["Params"] = {}
		GraphData[name]["Params"]["SpinBox_val"] = $SpinBox.value
		
		# Запись для хранения дерева редирекции 
		GraphData[name]["Redirection"] = {}
	
	
	# БЛОК ИНТЕГРАЦИИ С ПОЛЕМ ИНФОРМАЦИИ
	
	# определить NodeData как ссылку на ячейку в поле ??? нужно ли
	NodeData = GraphData[name] 
	$SpinBox.set_value(float(GraphData[name]["Params"]["SpinBox_val"]))
	# Определить Connections как ссылку на соотв. раздел ячейки  в поле ??? нужно ли 
	#Connections = NodeData["Connections"]
	#NodeData["Connections"] = Connections 
	# Определить SpinBox_val как ссылку на соотв раздел в ячейке
	
	print(NodeData)
	#get_tree().quit()
	
	#NodeData["Params"]["SpinBox_val"] = SpinBox_val 
	# / БЛОК ИНТЕГРАЦИИ С ПОЛЕМ ИНФОРМАЦИИ
	
	
	print("Новое состояние поля :")
	MAIN.ADD_TO_CONSOLE("", true)
	MAIN.ADD_TO_CONSOLE("Current DF state + \n")
	
	# Отобразить новое состояние в консоли
	for DF_item in GraphData:
		MAIN.ADD_TO_CONSOLE(DF_item)
		MAIN.ADD_TO_CONSOLE("   " + str(GraphData[DF_item]))
		
	print(GraphData)
	#print(name)
	#print(NodeData)
	print('/ F: CONNECT_DATA()')
	print()






# ФУНКЦИЯ АКТИВИРУЕТСЯ КОГДА ПРОИСХОДИТ НАЖАТИЕ НА НОДУ ЛЕВОЙ КНОПКОЙ
func _on_SENSOR_gui_input(event):
	
	if event.is_action_pressed("mouse_left_click") == true:
		IMPULSE = float($SpinBox.get_line_edit().text)
		print('SENSOR clicked: ', IMPULSE)
		print(NodeData)
		#SEND_IMPULSE(IMPULSE, "None")
		print(NodeData["Connections"])
		#SIGNAL(float($SpinBox.get_line_edit().text)) # Активация функции возбуждения
		
	if event.is_action_pressed("mouse_right_click") == true:
		$PopupMenu.popup( Rect2( get_global_mouse_position(), Vector2(10,10) ) )
		




		
		
func SEND_IMPULSE(IMP, DATA):
	print('>>'+title)
	var reciever = null
	
	
	print('Сейчас будет отправлен импульс: ', IMP)
	print('Ссодержащий следующие данные: ', DATA)
	
	if str(DATA) in NodeData["Redirection"].keys():
		print('>>ЗАПИСЬ О КЛЮЧЕ НАЙДЕНА В СПИСКЕ ПЕРЕАДРЕСАЦИИ')
		#Теперь переменная содержит ссылку на ноду которая закреплена за ключем 
		reciever = NodeData["Redirection"][str(DATA)]
	else:
		print('Запись переадресации не найдена, создаю ')
		NodeData["Redirection"][str(DATA)] = null
		print('Результат')
		print(NodeData["Redirection"])
		
		# Тут нужно создать новую ноду и соеденить ее с данной нодой, затем закрепить за ключем
		var NEW_REDIR_NODE = get_parent().SPAWN_NODE('exhibition', str(DATA), Vector2(offset.x+175,offset.y))
		NEW_REDIR_NODE.show_close = false
		
		# Теперь я настраиваю связи между новой нодой и этой (родительской) 
		get_parent()._on_GraphEdit_connection_request(name, 0, NEW_REDIR_NODE.name, 0)
		# Теперь нужно закрепить ноду за ключем 
		NodeData["Redirection"][str(DATA)] = NEW_REDIR_NODE.name
		# Далее назначить получателя заново. Если нода не будет создана, значение по ппрежнему будет null
		reciever = NodeData["Redirection"][str(DATA)]
		# А так же провести позиционирование 
		ORDER()
	
	# Ту следую написать новую функцию импульсации 
	
	if reciever != null:
		print('Получатель не равен NULL, совершаю импульс')
		if $SpinBox.editable == true:
			IMP = float($SpinBox.get_line_edit().text)
		
		# Убедится в существовании ноды
		var receiver_node = get_parent().get_node_or_null(reciever)
		# Если нода существует
		if receiver_node != null:
			print('НОДА ПОУЛЧАТЕЛЯ ОБНАРУЖЕНА!')
			receiver_node.SUMM(IMP)        #.SUMM(IMP)  #Отсюда я убрал адрес
			$ColorRect.color = Color(0,255,0)
			Indicator = 1.0
		# Если нода не существует
		elif receiver_node == null:
			print('Нода получателя не обнаружена')
			#Тут нужно почистить список ключей 
			print(get_parent().GraphData[name]["Redirection"])
			print('Нужно удалить ключ редиректа ')
			get_parent().DISCONNECT_WITH_NEIGH_REMOVE(name, reciever)
			get_parent().GraphData[name]["Redirection"].erase(str(DATA))
			print(get_parent().GraphData[name]["Redirection"])
			# Тут нужно?? отключить ноду правильно 

			# Тут нужно удалить запись о соседе из поля информации
			#get_parent().GraphData[name]["Connections"].erase(NEIGH)
			#print('ЗАПИСЬ УДАЛЕНА!')
		
		
	else:
		print("ПОлучатель равен NULL, импульс не совершается")

"""
	# Если кол-во связей нейрона больше нуля
	if NodeData["Connections"].size() > 0:
		print('Список связей')
		print(NodeData["Connections"])
		# Пройти по каждому соседу в списке связей
		for NEIGH in NodeData["Connections"]: 
			print("Текущий сосед сенсора: ", NEIGH, " ", NodeData["Connections"][NEIGH])
			# Тут нужно сразу посчитать potentian*W(neigh)
			#X = Y * Connections[NEIGH]
			#print('Выход по данной связи')
			#print(current_potential)
			#print(Connections[NEIGH])
			#print(X)
			# Активировать функцию 
			#get_node('/root/MAIN/GraphEdit/'+NEIGH).potential += IMP
			
			if $SpinBox.editable == true:
				IMP = float($SpinBox.get_line_edit().text)
			
			# Убедится в существовании ноды
			var receiver_node = get_parent().get_node_or_null(NEIGH)
			# Если нода существует
			if receiver_node != null:
				print('СОСЕД ОБНАРУЖЕН!')
				receiver_node.SUMM(IMP)        #.SUMM(IMP)  #Отсюда я убрал адрес
				$ColorRect.color = Color(0,255,0)
				Indicator = 1.0
			# Если нода не существует
			elif receiver_node == null:
				print('СОСЕД НЕ ОБНАРУЖЕН')
				# Тут нужно удалить запись о соседе из поля информации
				get_parent().GraphData[name]["Connections"].erase(NEIGH)
				print('ЗАПИСЬ УДАЛЕНА!')
				
			#Recatangle_light = 0
			#$ColorRect.color = Color(Recatangle_light)
			#potential -= current_potential

	print('---')




# Функция возбуждения. Активируется когда на нейрон совершается какое-либо воздействие 
#func SUMM(voltage): # Суммирование?
#		print("SUMM!")
#		potential += voltage # Увеличить текущий заряд нейрона
#		Recatangle_light = -100 # Изменить (погасить) значение индикатора 
#		$ColorRect.color = Color(Recatangle_light) # Изменить индикатор
#		$Label3.text = "C: "+str(potential) # Изменить тексовый индикатор
		

func SIGNAL(input):
	#Recatangle_light = 255
	#$ColorRect.color = Color(Recatangle_light)
	print("Input", input)
	#Y = 1 / (1 - pow(2.71828,-input)) # Сигмоидальная функция
	#print("Y:", Y)
	# Если кол-во связей нейрона больше нуля
	if Connection !=  "":
		print('Список связей')
		print(Connection)
		# Пройти по каждому соседу в списке связей
		##for NEIGH in Connections: 
		print("Cосед: ", Connection, " ", Connections[NEIGH])
			# Тут нужно сразу посчитать potentian*W(neigh)
			#X = Y * Connections[NEIGH]
			#print('Выход по данной связи')
			#print(current_potential)
			#print(Connections[NEIGH])
			#print(X)
			# Активировать функцию 
			get_node('/root/MAIN/GraphEdit/'+Connection).SIGMOID(input)
			#Recatangle_light = 0
			#$ColorRect.color = Color(Recatangle_light)
			#potential -= current_potential
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
"""





# ФУНКЦИЯ ЗАКРЫТИЯ НОДЫ СЕНСОРА
func _on_GraphNode_close_request():
	# УДАЛИТЬ ЗАПИСЬ ИЗ ОБЩЕГО ПОЛЯ ИНФОРМАЦИИ
	GraphData.erase(name)
	# УДАЛИТЬ МОСТ
	#$WORLD/CHARACTER/BODY.BRIDGES_UP[] = spawned_node.get_path()
	if bridge_source != null:
		get_node("/root/MAIN/WORLD/CHARACTER/BODY").BRIDGES_UP[title] = null
		MAIN.SYNC_WORLD()
		
	# Закрыть ноду
	queue_free()




func _physics_process(_delta):
	if Indicator > 0.0: 
		Indicator -= 0.1
		$ColorRect.color = Color(0,255,0,Indicator)
		print(Indicator)



func _on_PopupMenu_id_pressed(id):
	var item_name = $PopupMenu.get_item_text(id)
	print(item_name)
	if item_name == "VALUES":
		print("VALUES")
		if $SpinBox.editable == true:
			$SpinBox.editable = false
		elif $SpinBox.editable == false:
			$SpinBox.editable = true

	if item_name == 'DATA':
		print('DATA')
		MAIN.ADD_TO_CONSOLE('', true)
		MAIN.ADD_TO_CONSOLE(GraphData)

	if item_name == 'MANAGE':
		get_node("/root/MAIN").MANAGE_NODE(name)

	if item_name == 'SELECT KIDS':
		selected = true
		for NEIGH in GraphData[name]["Connections"]:
			if get_parent().get_node_or_null(NEIGH) != null:
				get_parent().get_node_or_null(NEIGH).selected = true
		pass#get_parent().set_selected(GraphData[name]["Connections"].keys()[0])

	if item_name == 'ORDER':
		ORDER()
"""
		print("Позиционирование")

		
		# Тут нужно вычислить общую длину всех дочерних нод
		var summ_lenght = 0 
		for NEIGH in GraphData[name]["Connections"]:
			#print(get_parent().get_node(NEIGH).rect_size.x)
			print(get_parent().get_node(NEIGH).rect_size.y)
			summ_lenght += int(get_parent().get_node(NEIGH).rect_size.y)

		print("Общая длина нод составляет:" )
		print(summ_lenght)

		# Это текущая позиция родительской ноды
		print("Позиция родительской ноды:" + str(offset))
		
		print("Центр родительской ноды:")
		var root_node_center =  int(rect_size.y)/2
		
		# Формула расчета стартовой точки для позиционирования
		var pos_starting_point = ( int(offset.y) + root_node_center ) - (summ_lenght / 2)
		print(" стартовая точка позиционирования")
		print(pos_starting_point)
		
		
		# Собственно позиционирование
		for NEIGH in GraphData[name]["Connections"]:
			get_parent().get_node(NEIGH).offset.y = pos_starting_point
			get_parent().get_node(NEIGH).offset.x = offset.x + 175
			# Увеличить значениеточки позиционирования на длину текущей ноды
			pos_starting_point += get_parent().get_node(NEIGH).rect_size.y
"""
func _on_SpinBox_value_changed(value):
	print('ValChanged')
	#print(GraphData[name]["Params"]["SpinBox_val"])
	#print(SpinBox_val)
	
	
	GraphData[name]["Params"]["SpinBox_val"] = $SpinBox.value
	#SpinBox_val = $SpinBox.value
	
	#print($SpinBox.value)
	#print(GraphData[name]["Params"]["SpinBox_val"])
	#print()

	#pass # Replace with function body.




func ORDER():
		print("Позиционирование")

		
		# Тут нужно вычислить общую длину всех дочерних нод
		var summ_lenght = 0 
		for NEIGH in GraphData[name]["Connections"][0]:
			#print(get_parent().get_node(NEIGH).rect_size.x)
			print(get_parent().get_node(NEIGH).rect_size.y)
			summ_lenght += int(get_parent().get_node(NEIGH).rect_size.y)

		print("Общая длина нод составляет:" )
		print(summ_lenght)

		# Это текущая позиция родительской ноды
		print("Позиция родительской ноды:" + str(offset))
		
		print("Центр родительской ноды:")
		var root_node_center =  int(rect_size.y)/2
		
		# Формула расчета стартовой точки для позиционирования
		var pos_starting_point = ( int(offset.y) + root_node_center ) - (summ_lenght / 2)
		print(" стартовая точка позиционирования")
		print(pos_starting_point)
		
		
		# Собственно позиционирование
		for NEIGH in GraphData[name]["Connections"][0]:
			get_parent().get_node(NEIGH).offset.y = pos_starting_point
			get_parent().get_node(NEIGH).offset.x = offset.x + 175
			# Увеличить значениеточки позиционирования на длину текущей ноды
			pos_starting_point += get_parent().get_node(NEIGH).rect_size.y


