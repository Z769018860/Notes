class Class(object):
    class_student = {}
    def __init__(self, class_name,class_student):
        self.__class_name = class_name
        self.__class_student = class_student
    def add_student(self,newstudent):
        self.__class_student.append = newstudent
    def kaoshi(self):
        for i in range(len(self.__class_student)):
            self.__class_student[i] = numpy.random.randint(0,100,size = 15)
        print(self.__class_student)
    def ave_class(self):
        sumclass = 0
        for i in range(len(self.__class_student)):
            for j in range(15):
                sumclass =  sumclass + self.__class_student[i][j]
        ave_class = sumclass / len(self.__class_student)
        return(ave_class)
    def ave_subject(self,subject):
        sumsub = 0
        for i in range(len(self.__class_student)):
            sumsub = sumsub + self.__class_student[i][subject-1]
        ave_subject = sumsub / len(self.__class_student)
        return(ave_subject)
class1 = Class('one',[[90,89,88,87,86,85,96,76,77,84,83,97,79,89,90],[99,88,77,78,67,78,98,66,70,80,95,96,79,80,69]])
Class.ave_class(class1)
Class.kaoshi(class1)
Class.ave_subject(class1,15)