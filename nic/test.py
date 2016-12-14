import cx_Oracle
import getpass

def get_conn_info():
    username = raw_input("Username: ")
    if not username:
        print "Error: No username supplied."
        exit(1)
    
    password = getpass.getpass("Password: ")
    if not password:
        print "Error: No password supplied."
        exit(1)

    hostname = raw_input("Hostname (default 127.0.0.1:1521): ")
    if not hostname:
        hostname = "127.0.0.1:1521"

    sid = raw_input("SID (default orcl.localdomain): ")
    if not sid:
        sid = "orcl.localdomain"

    print ""

    return (username + "/" + password + "@" + hostname + "/" + sid)

def main():
    conn_info = get_conn_info()
    db = cx_Oracle.connect(conn_info)

    while True:
        cursor = db.cursor()
        query = raw_input("Enter SQL query: ")
        cursor.execute(query)

        for result in cursor:
            print result

        # Example
        #cursor.execute("SELECT FIRST(SQL_ID) FROM V$SQL WHERE SQL_TEXT LIKE '%FIND_ME%'")
        #sql_id = cursor[0]
        #print sql_id

    cursor.close()
    db.close()

if __name__ == "__main__": main()
