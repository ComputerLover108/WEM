from sys import argv
import poplib
from email import parser


f = open(argv[1], 'r')
f.close()

host = 'pop.163.com'
username = 'MyTest22@163.com'
password = 'xxxxxxxxx'

pop_conn = poplib.POP3_SSL(host)
pop_conn.user(username)
pop_conn.pass_(password)

#Get messages from server:
# 获得邮件
messages = [pop_conn.retr(i) for i in range(1, len(pop_conn.list()[1]) + 1)]
#print messages

#print "--------------------------------------------------"
# Concat message pieces:
messages = ["\n".join(mssg[1]) for mssg in messages]
#print messages

#Parse message intom an email object:
# 分析
messages = [parser.Parser().parsestr(mssg) for mssg in messages]
i = 0
for message in messages:
	i = i + 1
	mailName = "mail%d.%s" % (i, message["Subject"])
	f = open(mailName + '.log', 'w');
	print("Date: ", message["Date"], file=f)
	print("From: ", message["From"], file=f)
	print("To: ", message["To"], file=f)
	print("Subject: ", message["Subject"], file=f)
	print("Data: ", file=f)
	j = 0
	for part in message.walk():
		j = j + 1
		fileName = part.get_filename()
		contentType = part.get_content_type()
		# 保存附件
		if fileName:
			data = part.get_payload(decode=True)
			fileName = "%s.%d.%s" % (mailName, j, fileName)
			fEx = open(fileName, 'wb')
			fEx.write(data)
			fEx.close()
		elif contentType == 'text/plain' or contentType == 'text/html':
			#保存正文
			data = part.get_payload(decode=True)
			print(data, file=f)

	f.close()
pop_conn.quit()