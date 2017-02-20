#!/usr/bin/python
# -*- coding: UTF-8 -*-

import argparse
import poplib
import imaplib
from email import parser
import re

def getPopEmailattachment(password,email='ComputerLover108@gmail.com',dir='.'):
   host=''
   pattern = '.*@gmail.com'
   if re.match(pattern,email):
      host='pop.googlemail.com'
      port=995
      pop_conn = poplib.POP3_SSL(host,port,timeout=30)

   # print(host,pattern,email,re.match(pattern,email))
   if re.match('.*@qq.com',email):
      host='pop.qq.com'
      port=995
      pop_conn = poplib.POP3_SSL(host,port,timeout=30)

   if re.match('.*@sina.com',email):
      host='pop3.sina.com'
      port=110
      pop_conn = poplib.POP3(host,port)

   if re.match('.*@163.com',email):
      host='imap.163.com'
      port=143
   if re.match('.*@126.com',email):
      host='imap.126.com'
      port=143

   pop_conn.user(email)
   pop_conn.pass_(password)
#    #Get messages from server:
#    # 获得邮件
   messages = [pop_conn.retr(i) for i in range(1, len(pop_conn.list()[1]) + 1)]
   print(len(messages),pop_conn.stat())
#    #print "--------------------------------------------------"
#    # Concat message pieces:
   # messages = ["\n".join(mssg[1]) for mssg in messages]
   # print(messages)

#    #Parse message intom an email object:
#    # 分析
   # messages = [parser.Parser().parsestr(mssg) for mssg in messages]
#    i = 0
#    for message in messages:
#       i = i + 1
#       mailName = "mail%d.%s" % (i, message["Subject"])
#       f = open(mailName + '.log', 'w');
#       print("Date: ", message["Date"], file=f)
#       print("From: ", message["From"], file=f)
#       print("To: ", message["To"], file=f)
#       print("Subject: ", message["Subject"], file=f)
#       print("Data: ", file=f)
#       j = 0
#       for part in message.walk():
#          j = j + 1
#          fileName = part.get_filename()
#          contentType = part.get_content_type()
#          # 保存附件
#          if fileName:
#             data = part.get_payload(decode=True)
#             fileName = "%s.%d.%s" % (mailName, j, fileName)
#             fEx = open(fileName, 'wb')
#             fEx.write(data)
#             fEx.close()
#          # elif contentType == 'text/plain' or contentType == 'text/html':
#          #    #保存正文
#          #    data = part.get_payload(decode=True)
#          #    print(data, file=f)

#       f.close()
   pop_conn.quit()


def extract_body(payload):
    if isinstance(payload,str):
        return payload
    else:
        return '\n'.join([extract_body(part.get_payload()) for part in payload])

def getImapEamilAttachment(password,email='ComputerLover108@gmail.com',dir='.'):
   conn = imaplib.IMAP4_SSL("pop.gmail.com", 993)
   conn.login("mine@gmail.com", "******")
   conn.select()
   typ, data = conn.search(None, 'UNSEEN')
   try:
       for num in data[0].split():
           typ, msg_data = conn.fetch(num, '(RFC822)')
           for response_part in msg_data:
               if isinstance(response_part, tuple):
                   msg = email.message_from_string(response_part[1])
                   subject=msg['subject']                   
                   print(subject)
                   payload=msg.get_payload()
                   body=extract_body(payload)
                   print(body)
           typ, response = conn.store(num, '+FLAGS', r'(\Seen)')
   finally:
       try:
           conn.close()
       except:
           pass
       conn.logout()

def main():
   description = '指定邮箱的所有邮件附件存储到指定目录里。'
   parser = argparse.ArgumentParser(description=description)
   parser.add_argument('-d','--directory',default='./attachment',help='指定目录[缺省目录是:./attachment]')
   parser.add_argument('-i','--interactive',help='交互式方法')
   parser.add_argument('-f','--file',help='电邮和密码在指定配置文件里')
   args = parser.parse_args()
   # print(args.directory,args.email,args.password)
   getEmailattachment(args.password,args.email,args.directory)

if __name__ == "__main__":
   main()