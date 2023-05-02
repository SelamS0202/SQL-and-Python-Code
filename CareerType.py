# -*- coding: utf-8 -*-
"""
Created on Tue Feb  9 17:13:15 2021

@author: Selam
"""
import pyodbc
import csv
from collections import defaultdict
import pandas as pd
# open the group by test.csv file
global Distinct_studentId
def myfunc(): 
    prev_ID = 0
    Student_SchoolCareer_History_temp =defaultdict(list)
    flat_studentSchoolPath = defaultdict(list)
    Regular_Career_Students = {}
    stud_val = []
    simplified_dict  = dict()
    student_info_dict = {}
    # read a a file
    with open("test.csv",'r') as InpFile: 
        StudentID_reader = csv.DictReader(InpFile) 
        Distinct_studentId= set([int(row["ID"]) for row in StudentID_reader]) 
        print(Distinct_studentId) 
    with open("test_copy.csv",'r') as InputFile: 
        InputFile_reader = csv.DictReader(InputFile) 
        for row in InputFile_reader: 
            #res = defaultdict(list) 
            Student_SchoolCareer_History_temp[int(row["ID"])
                                              ].append({k:v for k,v in row.items() 
                                                       if k !='ID'} )
    
    for key, value_list in Student_SchoolCareer_History_temp.items():
        for elemnt_dic in value_list:
            Ay= elemnt_dic["AYear"] 
            Cls = elemnt_dic["Class"] 
            FinalRes = elemnt_dic["FinalResult"][:1]
            row_dict = {Ay:Cls+FinalRes}
            flat_studentSchoolPath[key].append(row_dict)
        row_dict = dict()
    
    value_dict_map_flatdict = dict()
    
    for k, val in flat_studentSchoolPath.items():
        for dict_elem in val:
            for key, val in dict_elem.items():
                value_dict_map_flatdict[key] = val
        simplified_dict[k] = value_dict_map_flatdict
        value_dict_map_flatdict = dict()
    
    Student_Career_type_dict = dict()
    
    for stud_Id,value_dict in simplified_dict.items():
        if (value_dict.get('2011/12') == "1A" and value_dict.get('2012/13') == "2A" and 
        value_dict.get('2013/14') == "3A" and value_dict.get('2014/15') =="4A" and
        value_dict.get('2015/16') == "5A" and value_dict.get('2016/17') == "1A" and
        value_dict.get('2017/18') == "2A" and value_dict.get('2018/19') == "3A" and
        value_dict.get('2019/20') == "1A") :
            Student_Career_type_dict[stud_Id] = "Regular"
        elif((value_dict.get('2011/12') == "1A" and value_dict.get('2012/13') == "2A" and 
        value_dict.get('2013/14') == "3A" and value_dict.get('2014/15') =="4A" and
        value_dict.get('2015/16') == "5A" and value_dict.get('2016/17') == "1A" and
        value_dict.get('2017/18') == "2A" and value_dict.get('2018/19') == "3A") and 
        (len(value_dict)== 8)):
            Student_Career_type_dict[stud_Id] = "Regular"
        elif ((value_dict.get('2011/12') == "1A" and value_dict.get('2012/13') == "2A" and 
        value_dict.get('2013/14') == "3A" and value_dict.get('2014/15') =="4A" and
        value_dict.get('2015/16') == "5A" and value_dict.get('2016/17') == "1A" and
        value_dict.get('2017/18') == "2A") and (len(value_dict)== 7)):
              Student_Career_type_dict[stud_Id] = "Regular"
        elif ((value_dict.get('2011/12') == "1A" and value_dict.get('2012/13') == "2A" and 
        value_dict.get('2013/14') == "3A" and value_dict.get('2014/15') =="4A" and
        value_dict.get('2015/16') == "5A" and value_dict.get('2016/17') == "1A") and
        (len(value_dict)== 6)):
              Student_Career_type_dict[stud_Id] = "Regular"
        elif ((value_dict.get('2011/12') == "1A" and value_dict.get('2012/13') == "2A" and 
        value_dict.get('2013/14') == "3A" and value_dict.get('2014/15') =="4A" and 
        value_dict.get('2015/16') == "5A") and (len(value_dict)== 5)): 
            Student_Career_type_dict[stud_Id] = "Regular"
        elif ((value_dict.get('2011/12') == "1A" and value_dict.get('2012/13') == "2A" and 
        value_dict.get('2013/14') == "3A" and value_dict.get('2014/15') =="4A" ) and 
        (len(value_dict)== 4)): 
            Student_Career_type_dict[stud_Id] = "Regular"
        elif ((value_dict.get('2011/12') == "1A" and value_dict.get('2012/13') == "2A" and 
        value_dict.get('2013/14') == "3A") and (len(value_dict)== 3)):
            Student_Career_type_dict[stud_Id] = "Regular"
        elif ((value_dict.get('2011/12') == "1A" and value_dict.get('2012/13') == "2A") and 
              (len(value_dict)== 2)): 
            Student_Career_type_dict[stud_Id] = "Regular"
        elif ((value_dict.get('2011/12') == "1A") and (len(value_dict)== 1)): 
              Student_Career_type_dict[stud_Id] = "Regular"      
        
        else:
            Student_Career_type_dict[stud_Id] = "Non Regular"
    
    Regular_Schoolcareer_pathStudents_dict = {student_ID:CareerType for student_ID, CareerType in Student_Career_type_dict.items()
                                              if CareerType == "Regular"}
    NonRegular_schoolCareer_Students_dict = {student_ID:CareerType for student_ID, CareerType in Student_Career_type_dict.items()
                                              if CareerType == "Non Regular"}
    print(f"Regular:{len(Regular_Schoolcareer_pathStudents_dict)}")
    print(f"Non regular: {len( NonRegular_schoolCareer_Students_dict)}")
    RegularCType_df = pd.DataFrame(Regular_Schoolcareer_pathStudents_dict.items(), 
                                   columns=['ID', 'Career_Type'])
    NonRegularCType_df = pd.DataFrame(NonRegular_schoolCareer_Students_dict.items(), 
                                   columns=['ID', 'Career_Type'])
    return simplified_dict
   
myfunc()
    
             
        
            
            
            
            
            

        
        
            
                
                
                

    
       