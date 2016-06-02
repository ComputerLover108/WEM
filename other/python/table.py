# -*- coding: utf-8 -*-
"""
Created on Tue Nov 24 21:10:29 2015

@author: wkx
"""

import os

with open('temp.txt', 'w') as f:
    f.write('<table>\n')
    for row in range(1,32):
        rs="\t<tr>\n"
        f.write(rs)
        for column in range(1,32):
            cs=specialValue(row,column)
#            cs="\t\t<td>({0},{1})</td>\n".format(row,column)
            f.write(cs)
        f.write("\t</tr>\n")
    f.write('</table>\n')
    
def specialValue(row,column):
    if row==3 and column==1 :
        temp='乙二醇'
    if row==3 and column==14 :
        temp='轻油'
    if row==3 and column==18 :
        temp='V-631'
    if row==3 and column==24 :
        temp='V-601'       
    if row==3 and column==26 :
        temp='液化石油气'
    return "\t\t<td>({0})</td>\n".format(temp)