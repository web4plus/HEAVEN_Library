import os
os.system("cls||clear")

# ANSI 
moto_color = '\033[91m'
propri_color = '\033[95m'
senso_color = '\033[94m'
title_color = '\033[1m'
reset_color = '\033[0m'



external_impact = 0

muscle_contraction = 0          # aM
proprio_contraction = 0         # yM
proprio_sensor = 0              # yS

muscle_lenght_max = 10   # * Initial relaxation 
proprio_lenght_max = 10  # * Initial relaxation

muscle_lenght = 10 #*
proprio_lenght = 10 #*





def display_muscle_state():
   m_lenght = "#" * muscle_lenght
   p_lenght = "#" * proprio_lenght


   print("[ Artificial muscle state ]")
   print()
   print("   M: [" + moto_color + m_lenght + reset_color + "] " + str(muscle_lenght) +" +(" + str(external_impact) +")" ) # [##########] М
   print("     ˪" + reset_color + "Imp" + reset_color +  ":"+ str(external_impact))
   print("     ˪" + moto_color + "aM" + reset_color +  ":"+ str(muscle_contraction))  # Display аМ param

   print()

   print("   P: [" + propri_color + p_lenght + reset_color + "] " +str(proprio_lenght) +" +(" + str(external_impact) +")") # [##########] P
   print("     ˪" + reset_color + "Imp" + reset_color +  ":"+ str(external_impact))
   print("     ˪"  + propri_color +  "y" + moto_color + "M"  + reset_color +  ":" + str(proprio_contraction))
   print("     ˪"  + propri_color +  "y" + senso_color + "S"  + reset_color +  ":"  + str(proprio_sensor))






def apply_external_impact():
   global external_impact
   global muscle_lenght
   global proprio_sensor

   print("   >>> Started with lenght: ", muscle_lenght)
   new_external_impact_val = int(input("   >>> Enter new impact value: "))


   # Ограничение воздейтсвия
   if (muscle_lenght + new_external_impact_val) > muscle_lenght_max:
      print("   >>> The impact is more that maximum muscle length, preventing detachment.")
      print("   >>> Calculation of a limited impact")
      new_external_impact_val = muscle_lenght_max - muscle_lenght
      
   external_impact = new_external_impact_val
   muscle_lenght = muscle_lenght + new_external_impact_val
   print("   >>> New difference yS: ")
   proprio_sensor = get_difference()





def get_difference():
   difference = muscle_lenght - proprio_lenght
   print("   >>> Difference: ", difference)
   print()
   return difference






def fix_difference():
   #global muscle_lenght
   global proprio_sensor 

   #muscle_lenght = muscle_contraction + proprio_sensor 
   alpha_neuron(muscle_contraction + proprio_sensor)






def alpha_neuron(value):
   global muscle_lenght
   global muscle_contraction
   global proprio_sensor

   # Limitation (valid values only between 0 and 10)
   if value > 10: 
      value = 10
      print("   >>> Value exceeds the allowable limit, setting a new value ", value)

   elif value < 0:
      value = 0
      print("   >>> Value is below the limit, set value ", value)      

   # here to assign an AM value
   muscle_contraction = value

   print("   >>> Changing lenght of muscle: ")
   print("   >>> ", muscle_lenght, " --> ", value)
   muscle_lenght = muscle_lenght_max - value 


   print("   >>> New difference yS: ")
   proprio_sensor = get_difference()










def gamma_neuron(value):
   global proprio_lenght
   global proprio_contraction
   global proprio_sensor

   # Limitation (valid values only between 0 and 10)
   if value > 10: 
      value = 10
      print("   >>> Value exceeds the allowable limit, set value ", value)

   elif value < 0:
      value = 0
      print("   >>> Value is below the limit, set value ", value)      


   # тут назначить yМ value
   proprio_contraction = value

   print("   >>> Changing in proprioceptor length: ")
   print("   >>> ", proprio_lenght, " --> ", value)
   proprio_lenght = proprio_lenght_max -value 
   print("   >>> New difference yS: ")
   proprio_sensor = get_difference()



# Program's general body

while True:
   print(title_color + "[ .///HEAVEN | Muscle proprio FPEV2 | web4plus.github.io]" + reset_color)

   print()
   display_muscle_state()
   print()

   print("Following command acceptible:")

   print("   A - Activate aM neuron (moto)")
   print("   Y - Activate yM neuron (proprio)")
   print("   W - Apply external impact")
   print("   D - Fix the difference")
   print()

   command = input("Enter command: ")
   
   if command == "R":
      get_difference()

   elif command == "W":
      print()
      apply_external_impact()
      print()

   elif command == "D":
      print()
      fix_difference()
      print()


   elif command == "M":
      print()
      print("   >>> Muscle lenght: ", muscle_lenght)
      print()

   elif command == "P":
      print()
      print("   >>> Proprioceptor's lenght: ", proprio_lenght)
      print()

   elif command == "A":
      print()
      print("   >>> Activating aM neuron: ")
      new_external_impact_val = input("   >>> Enter value of a new extrafusal lenght: ")
      alpha_neuron(int(new_external_impact_val))
      print()

   elif command == "Y":
      print()
      print("   >>> Activating yM neuron: ")
      new_external_impact_val = input("   >>> Enter value of a new intrafusal lenght: ")
      gamma_neuron(int(new_external_impact_val))
      print()

   else:
      print()
      print("   >>> Command not found")
      print()


   input("Hit 'Enter' to continue")
   print()
   os.system("cls||clear")









