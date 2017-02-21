import imaplib, getpass, os
import poplib
import re
import getpass


# allowed_mimetypes = ["application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]

def getPopServer(email):
    if re.match('.*@gmail.com', email):
        host = 'pop.googlemail.com'
    if re.match('.*@qq.com', email):
        host = 'pop.qq.com'
    if re.match('.*@sina.com', email):
        host = 'pop3.sina.com'
    if re.match('.*@163.com', email):
        host = 'pop3.163.com'
    if re.match('.*@126.com', email):
        host = 'pop3.126.com'
    return host


def mail_connection(server, user, password):
    pop_conn = poplib.POP3_SSL(server)
    pop_conn.user(user)
    pop_conn.pass_(password)
    return pop_conn


def fetch_mail(pop_conn, delete_after=False):
    # pop_conn = mail_connection()
    messages = [pop_conn.retr(i) for i in range(1, len(pop_conn.list()[1]) + 1)]
    messages = ["\n".join(mssg[1]) for mssg in messages]
    messages = [parser.Parser().parsestr(mssg) for mssg in messages]
    if delete_after == True:
        delete_messages = [pop_conn.dele(i) for i in range(1, len(pop_conn.list()[1]) + 1)]
    pop_conn.quit()
    return messages


def get_attachments(messages):
    # messages = fetch_mail()
    attachments = []
    for msg in messages:
        for part in msg.walk():
            if part.get_content_type() != 'text/plain':
                # if part.get_content_type() in allowed_mimetypes:
                name = part.get_filename()
                data = part.get_payload(decode=True)
                f = file(name, 'wb')
                f.write(data)
                f.close()
                attachments.append(name)
    return attachments


# 输入邮件地址, 口令和POP3服务器地址:
def main():
    email = input('Email: ')
    password = getpass.getpass('Password: ')
    host = getPopServer(email)
    pop_conn = mail_connection(host, email, password)
    messages = fetch_mail(pop_conn)
    attachments = get_attachments(messages)
    print(attachments)


if __name__ == "__main__":
    main()
